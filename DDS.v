module DDS(
  input clk,                   // Clock input
  input [26:0] desired_freq,   // 27-bit input for desired output frequency
  output wire [15:0] sine_lookup_output // 16-bit output for sine wave value
);

  // 32-bit phase accumulator register
  // This register keeps track of the current phase of the sine wave
  reg [31:0] phase_acc;   

  // Update the phase accumulator on every clock cycle
  // The phase accumulator is incremented by the 27-bit desired_freq input
  // The 5 most significant bits are set to 0 to sign-extend the input
  always @(posedge clk) begin
    phase_acc <= phase_acc + {5'b0, desired_freq};
  end

  // Instantiate the sine lookup table module
  // This module takes the 32-bit phase_acc as the address input
  // and outputs the corresponding 16-bit sine wave value
  wire [15:0] sine_value;
  sine_lookup my_sine(
    .clk(clk),
    .addr(phase_acc),
    .value(sine_value)
  );

  // Connect the sine wave value output of the sine lookup table
  // to the sine_lookup_output port of the DDS module
  assign sine_lookup_output = sine_value;

endmodule
