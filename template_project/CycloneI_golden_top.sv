module CycloneI_golden_top(
    input  logic        CLOCK_50, // 50MHZ
    output logic   		BUZZER,	 // PNP
    output logic [3:0]  HEX_EN,   // 4, 3, 2, 1
    output logic [7:0]  HEX_LED,  // A, B, C, D, E, F, G, POINT
    output logic [5:0]  LED,		 // D2, D3, D4, D5, D6
    input  logic [3:0]  BUTTON,   // K1, K2, K3, K4 (PULLUP)
    input  logic [5:0]  DIP_U5,   // PULLUP
    input  logic [5:0]  DIP_U6,   // PULLDOWN
    inout  logic [27:0] GPIO


);

	initial begin
		HEX_EN = 4'b1111;
		HEX_LED = 8'b11111111;
		LED = 6'b111111;
		BUZZER = 1;
	end

endmodule


