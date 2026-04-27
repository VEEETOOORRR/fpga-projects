module pwm #(
    parameter DUTY_BITS = 8, // Quantos bits de entrada vão determinar o valor do duty cycle
    parameter CLOCK_DIV = 8 // Divisor de clock
)(
    input logic clk,
    input logic rst,
    input logic [DUTY_BITS-1:0] duty,
    output logic pwm_signal
);

    logic [CLOCK_DIV-1:0] cont_clk;
    logic [DUTY_BITS-1:0] cont_pwm;

    logic clk_slow;

    assign clk_slow = cont_clk[CLOCK_DIV-1];

    always_ff @(posedge clk or posedge rst) begin
        if(rst) cont_clk <= 0;
        else begin
            cont_clk <= cont_clk + 1;
        end
    end

    always_ff @(posedge clk_slow or posedge rst) begin
        if(rst) cont_pwm <= 0;
        else begin
            cont_pwm <= cont_pwm + 1;
        end
    end

    always_comb begin
        if(rst) pwm_signal = 0;
        else begin
            if(cont_pwm < duty) pwm_signal = 1;
            else pwm_signal = 0; 
        end
    end

    
endmodule