module divfreq_tone (
    input logic clk,
    input logic rst,
    input logic [2:0] tone,
    output logic clk_slow
);

    int counter_module;
    logic [31:0] cont;

    // N = fclk / (2 * fout)

    always_comb begin
        case(tone)
            0: counter_module = 95555; // C4 (261.63 hz)
            1: counter_module = 85132; // D4 (293.66 hz)
            2: counter_module = 75843; // E4 (329.63 hz)
            3: counter_module = 71586; // F4 (349.23 hz)
            4: counter_module = 63776; // G4 (392.00 hz)
            5: counter_module = 56818; // A4 (440.00 hz)
            6: counter_module = 50619; // B4 (493.88 hz)
            7: counter_module = 47778; // C5 (523.25 hz)
            default: counter_module = 56818;
        endcase
    end

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            cont <= 0;
            clk_slow <= 0;
        end else begin
            if(cont >= counter_module - 1) cont <= cont + 1;
            else begin
                cont <= 0;
                clk_slow <= ~clk_slow;
            end
        end

    end

endmodule