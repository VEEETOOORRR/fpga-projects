module top (
    input logic clk,
    input logic rst,
);
    logic rst_inv;
    
    assign rst_inv = ~rst;

endmodule