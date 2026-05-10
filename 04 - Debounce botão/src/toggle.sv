module toggle (
    input logic clk, rst, signal,
    output logic toggle_output
);

    logic reg_toggle;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) reg_toggle <= 0;
        else begin
            if(signal) reg_toggle <= ~reg_toggle;
            else reg_toggle <= reg_toggle;
        end
    end

    assign toggle_output = reg_toggle;


endmodule

