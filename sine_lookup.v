// sine lookup value module using two symmetries
// appears like a 2048x16bit LUT even if it uses a 512x16bit internally
// 3 clock latency
module sine_lookup(
    input clk,         // Clock input
    input [10:0] addr, // 11-bit address input representing the sine wave phase
    output reg [16:0] value // 17-bit sine wave value output (including sign bit)
);

    wire [15:0] sine_1sym; // 16-bit sine wave value with one symmetry applied

    // Instantiate the 512x16bit BRAM module with 2 clock cycle latency
    blockram512x16bit_2clklatency my_quarter_sine_LUT(
        .rdclock(clk),
        .rdaddress(addr[9] ? ~addr[8:0] : addr[8:0]), // Apply first symmetry
        .q(sine_1sym)
    );

    // Delay the most significant bit of the address (addr[10])
    // by two clock cycles to match the BRAM read latency
    reg addr10_delay1; always @(posedge clk) addr10_delay1 <= addr[10];
    reg addr10_delay2; always @(posedge clk) addr10_delay2 <= addr10_delay1;

    // Apply the second symmetry based on the delayed addr[10] bit
    wire [16:0] sine_2sym = addr10_delay2 ? {1'b0, -sine_1sym} : {1'b1, sine_1sym};

    // Register the final 17-bit sine wave value with an additional clock cycle
    // of latency for better performance
    always @(posedge clk) value <= sine_2sym;
endmodule

// 512x16bit BRAM module with 2 clock cycle read latency
module blockram512x16bit_2clklatency(
    input wire rdclock,     // Read clock input
    input wire [8:0] rdaddress, // 9-bit read address input
    output wire [15:0] q    // 16-bit data output
);

    // Register the read address
    reg [8:0] rdaddress_reg;

    // Register the BRAM output
    reg [15:0] q_reg;
    
    // 512x16bit BRAM
    reg [15:0] ram [0:511];

    // BRAM read operation with 2 clock cycle latency
    always @(posedge rdclock) begin
        // On the first clock cycle, store the read address in rdaddress_reg
        rdaddress_reg <= rdaddress;

        // On the second clock cycle, fetch the BRAM data and store it in q_reg
        q_reg <= ram[rdaddress_reg];
    end

    // Connect the registered output q_reg to the output port q
    assign q = q_reg;
endmodule
