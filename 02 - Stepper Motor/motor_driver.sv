module stepper_driver {
    input logic clk,
    input logic rst,
    input logic dir,
    input logic en,
    output logic [3:0] motor_coils
};

    typedef enum logic [2:0] {
        S0, S1, S2, S3, S4
    } state_t;

    state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= S0;
        end else begin

            if(enable) state <= 0;
            else begin
                case(state)
                    S0: begin
                        state <= S1;
                    end

                    S1: begin
                        if(dir) state <= S2;
                        else state <= S4;
                    end

                    S2: begin
                        if(dir) state <= S3;
                        else state <= S1;
                    end

                    S3: begin
                        if(dir) state <= S4;
                        else state <= S2;
                    end

                    S4: begin
                        if(dir) state <= S1;
                        else state <= S3;
                    end

                    default: state <= S0;

                endcase
            end
        end
    end

    always_comb begin
        case(state)
            S0: motor_coils =       4'b0000;
            S1: motor_coils =       4'b1000;
            S2: motor_coils =       4'b0100;
            S3: motor_coils =       4'b0010;
            S4: motor_coils =       4'b0001;
            default: motor_coils =  4'b0000;
        endcase
    end



endmodule