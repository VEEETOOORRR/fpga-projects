module divfreq #(
    parameter MODULO = 13500  // N = fclk / (2 * fout)
)(
    input logic clk, rst,
    output logic clk_slow
);

    logic [15:0] counter;
    logic clk_slow_reg;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            clk_slow_reg <= 0;
            counter <= 0;
        end else begin
            if(counter == MODULO) begin
                clk_slow_reg <= ~clk_slow_reg;
                counter <= 0;
            end else counter <= counter + 1;
        end
    end

    assign clk_slow = clk_slow_reg;

endmodule