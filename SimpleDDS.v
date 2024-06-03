module SimpleDDS(
    input DAC_clk,     // Input clock for the Digital-to-Analog Converter (DAC)
    output [9:0] DAC_data // 10-bit output data for the DAC
);

    // 16-bit free-running binary counter
    reg [15:0] cnt;
    always @(posedge DAC_clk) begin
        // Increment the counter by 1 on every positive edge of the DAC_clk
        cnt <= cnt + 16'h1;
    end

    // Generate the DAC signal output
    wire cnt_tap = cnt[7]; // Use bit 7 (the 8th bit) of the counter
    assign DAC_data = {10{cnt_tap}}; // Duplicate the selected bit 10 times
                                    // to create the 10-bit DAC output value
                                    // with the maximum possible amplitude

    // Uncomment the following lines for different waveform generation:

    // Sawtooth wave
    // assign DAC_data = cnt[9:0]; // Use the lower 10 bits of the counter

    // Triangular wave
    // assign DAC_data = cnt[10] ? ~cnt[9:0] : cnt[9:0]; // Use the lower 10 bits of the counter,
                                                       // but flip the bits when the 11th bit is 1
endmodule
