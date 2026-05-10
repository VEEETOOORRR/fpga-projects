module top (
    input logic clk,
    input logic rst,
    input logic push_button,
    output logic [1:0] led
);
    logic rst_inv, push_button_inv;

    assign rst_inv = ~rst;
    assign push_button_inv = ~push_button;

    wire clk_slow_wire, push_button_db_wire, pulse_posedge_wire;

    assign led[0] = push_button_db_wire;

    divfreq #(.MODULO(13500)) df (
        .clk(clk),
        .rst(rst_inv),
        .clk_slow(clk_slow_wire)
    );

    debounce #(.DB_TIME(50)) db (
        .clk(clk_slow_wire),
        .rst(rst_inv),
        .push_button(push_button_inv),
        .push_button_db(push_button_db_wire)
    );

    edge_detector ed (
        .clk(clk_slow_wire),
        .rst(rst_inv),
        .signal(push_button_db_wire),
        .pulse_posedge(pulse_posedge_wire)
    );

    toggle t (
        .clk(clk_slow_wire),
        .rst(rst_inv),
        .signal(pulse_posedge_wire),
        .toggle_output(led[1])
    );

endmodule