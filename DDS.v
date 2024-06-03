module DDS(
  input clk,                   // Clock input
  input [26:0] desired_freq,   // 27-bit input for desired output frequency
  output wire [9:0] DAC_data_out // 10-bit output for sine wave value
);

  // Phase Accumulator
  // This is the core of the DDS system, responsible for generating the phase information
  // that will be used to look up the corresponding sine wave values.
  reg [31:0] phase_acc;
  always @(posedge clk) begin
    // On every clock cycle, the phase accumulator is updated by adding the desired frequency value
    // (left-padded with 5 zero bits) to the current phase accumulator value.
    // This effectively implements the phase progression of the sine wave.
    phase_acc <= phase_acc + {5'b0, desired_freq};
  end

  // Sine Lookup Tables
  // The module instantiates two sine wave lookup tables, which will be used to obtain
  // the sine wave values corresponding to the current phase information.
  wire [16:0] sine1_lv, sine2_lv;
  sine_lookup my_sine1(.clk(clk), .addr(phase_acc[31:21]), .value(sine1_lv));
  sine_lookup my_sine2(.clk(clk), .addr(phase_acc[31:21]+11'h1), .value(sine2_lv));

  // Phase Fractional Bits Delay
  // The lower 21 bits of the phase accumulator (the fractional part) are delayed through
  // a series of three registers. This is necessary to match the latency introduced
  // by the lookup table access, ensuring that the fractional phase information is
  // aligned with the corresponding sine wave values.
  reg [20:0] phase_LSB_delay1;
  reg [20:0] phase_LSB_delay2;
  reg [20:0] phase_LSB_delay3;

  always @(posedge clk) begin
    phase_LSB_delay1 <= phase_acc[20:0];
    phase_LSB_delay2 <= phase_LSB_delay1;
    phase_LSB_delay3 <= phase_LSB_delay2;
  end

  // Linear Interpolation
  // This section performs linear interpolation between the two sine wave values obtained
  // from the lookup tables. The fractional part of the phase is used to perform the
  // linear interpolation, which helps to improve the quality of the output sine wave
  // by creating a smoother transition between the discrete sine wave samples.
  wire [21:0] sine1_mf = 22'h200000 - phase_LSB_delay3;
  wire [20:0] sine2_mf = phase_LSB_delay3;
  reg [37:0] sine_p;

  always @(posedge clk) begin
    // The linear interpolation is performed by multiplying the sine wave values
    // (sine1_lv and sine2_lv) with their respective fractional parts, and then
    // adding the results together.
    sine_p <= sine1_lv * sine1_mf + sine2_lv * sine2_mf;
  end

  // Output Assignment
  // The final result of the linear interpolation is stored in the sine_p register,
  // which is a 38-bit value. The upper 10 bits of the sine_p register are then
  // assigned to the DAC_data_out output signal, which represents the sine wave
  // value to be sent to the Digital-to-Analog Converter (DAC).
  assign DAC_data_out = sine_p[37:28];

endmodule
