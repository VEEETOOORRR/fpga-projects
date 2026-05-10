module edge_detector(
    input logic clk, rst, signal,
    output logic pulse_posedge
);
    logic signal_prev;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) signal_prev <= 0;
        else signal_prev <= signal;
    end
    
    assign pulse_posedge = signal & ~signal_prev;
endmodule