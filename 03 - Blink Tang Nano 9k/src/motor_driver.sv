module motor_driver (
    input logic clk,
    input logic rst,
    input logic dir,
    input logic en,
    output logic [3:0] motor_coils
);

    logic [3:0] motor_coils_reg;
    logic dir_reg;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            dir_reg <= 0;
            motor_coils_reg <= 4'b0000;
        end else begin
            dir_reg <= dir;
            if(!en) begin
                motor_coils_reg <= 4'b0000;
            end else begin
                if(motor_coils_reg == 4'b000) motor_coils_reg <= 4'b0001;
                else begin
                    if(dir_reg) motor_coils_reg <= {motor_coils_reg[0], motor_coils_reg[3:1]};
                    else motor_coils_reg <= {motor_coils_reg[3], motor_coils_reg[2:0]};
                end
            end
        end
    end

    assign motor_coils = motor_coils_reg;


endmodule