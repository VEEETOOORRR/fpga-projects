module top (
    input logic clk,
    input logic rst,
    input logic en,
    input logic dir,
    input logic [2:0] tone,
    output logic [3:0] motor_control
);

    wire clk_slow;

    logic rst_inv, en_inv, dir_inv, tone_inv;

    assign rst_inv = ~rst;
    assign en_inv = ~en;
    assign dir_inv = ~dir;
    assign tone_inv = ~tone;

    divfreq_tone df (
        .clk(clk),
        .rst(rst_inv),
        .tone(tone_inv),
        .clk_slow(clk_slow)
    );

    motor_driver md (
        .clk(clk_slow),
        .rst(rst_inv),
        .en(en_inv),
        .dir(dir_inv),
        .motor_coils(motor_control)
    );


endmodule