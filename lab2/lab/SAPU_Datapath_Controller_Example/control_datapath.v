module control_datapath #(
    parameter DATA_WIDTH = 8
)(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire                  start,
    input  wire [1:0]            op_sel,
    input  wire [DATA_WIDTH-1:0] operand_a,
    input  wire [DATA_WIDTH-1:0] operand_b,
    output reg  [2*DATA_WIDTH-1:0] result,
    output reg                  done,
    output reg                  div_by_zero_err
);

    localparam STATE_IDLE    = 2'b00;
    localparam STATE_LOAD    = 2'b01;
    localparam STATE_EXECUTE = 2'b10;

    reg [1:0] current_state, next_state;

    reg [DATA_WIDTH-1:0] reg_a, reg_b;
    reg [1:0]            reg_op;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= STATE_IDLE;
        else
            current_state <= next_state;
    end

    always @(*) begin
        case (current_state)
            STATE_IDLE:    next_state = start ? STATE_LOAD : STATE_IDLE;
            STATE_LOAD:    next_state = STATE_EXECUTE;
            STATE_EXECUTE: next_state = STATE_IDLE;
            default:       next_state = STATE_IDLE;
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_a           <= 0;
            reg_b           <= 0;
            reg_op          <= 2'b00;
            result          <= 0;
            done            <= 1'b0;
            div_by_zero_err <= 1'b0;
        end else begin
            case (current_state)
                STATE_IDLE: begin
                    done            <= 1'b0;
                    div_by_zero_err <= 1'b0;
                end

                STATE_LOAD: begin
                    reg_a  <= operand_a;
                    reg_b  <= operand_b;
                    reg_op <= op_sel;
                end

                STATE_EXECUTE: begin
                    done <= 1'b1;
                    case (reg_op)
                        2'b00: result <= reg_a + reg_b;
                        2'b01: result <= reg_a - reg_b;
                        2'b10: result <= reg_a * reg_b;
                        2'b11: begin
                            if (reg_b != 0) begin
                                result <= reg_a / reg_b;
                            end else begin
                                result          <= 0;
                                div_by_zero_err <= 1'b1;
                            end
                        end
                        default: result <= 0;
                    endcase
                end

                default: begin
                    done            <= 1'b0;
                    div_by_zero_err <= 1'b0;
                end
            endcase
        end
    end

endmodule
