module debounce #(
    parameter DB_TIME = 50
)(
    input logic clk,
    input logic rst,
    input logic push_button,
    output logic push_button_db
);

    logic [6:0] db_counter;

    typedef enum logic [1:0] {
        INIT,
        DB,
        HOLD
    } db_state_t;

    db_state_t state;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= INIT;
            db_counter <= 0;
        end else begin
            case(state)
                INIT: begin
                    if(push_button) state <= DB; else state <= INIT;
                end

                DB: begin
                    if(db_counter < DB_TIME) begin
                        if(push_button) db_counter <= db_counter + 1;
                        else begin
                            state <= INIT;
                            db_counter <= 0;
                        end
                    end else begin
                        state <= HOLD;
                        db_counter <= 0;
                    end
                end

                HOLD: begin
                    if(push_button) state <= HOLD;
                    else state <= INIT;
                end
            endcase
        end
    end

    always_comb begin
        case(state)
            INIT: push_button_db = 0;
            DB: push_button_db = 0;
            HOLD: push_button_db = 1;
            default: push_button_db = 0;
        endcase
    end

endmodule