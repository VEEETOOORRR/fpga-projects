module blink (
    input logic clk,
    output logic [5:0] led
);
    logic [23:0] cnt = 0;
    always_ff @(posedge clk) cnt <= cnt + 1;
    assign led = ~cnt[23:18];
endmodule