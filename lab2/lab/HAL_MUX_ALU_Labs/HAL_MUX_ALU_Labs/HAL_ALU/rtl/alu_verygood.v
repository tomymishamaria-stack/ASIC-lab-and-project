module alu_verygood #(
    parameter [31:0] DATA_WIDTH = 32'd4,
    parameter [31:0] OP_WIDTH   = 32'd2
)(
    input wire clk,
    input wire rst_n,
    input wire [DATA_WIDTH-1:0] a,
    input wire [DATA_WIDTH-1:0] b,
    input wire [OP_WIDTH-1:0] op,
    output reg [DATA_WIDTH-1:0] y
);

    reg [DATA_WIDTH-1:0] reg_a;
    reg [DATA_WIDTH-1:0] reg_b;
    reg [OP_WIDTH-1:0] reg_op;


    always @(posedge clk or negedge rst_n) begin : proc_input_register

        if (!rst_n) begin
            reg_a  <= {DATA_WIDTH{1'b0}};
            reg_b  <= {DATA_WIDTH{1'b0}};
            reg_op <= {OP_WIDTH{1'b0}};
        end
        else begin
            reg_a  <= a;
            reg_b  <= b;
            reg_op <= op;
        end

    end


    always @(posedge clk or negedge rst_n) begin : proc_alu_output

        if (!rst_n) begin
            y <= {DATA_WIDTH{1'b0}};
        end
        else begin

            case (reg_op)

                2'b00: begin
                    y <= {1'b0,reg_a[DATA_WIDTH-2:0]} +
                         {1'b0,reg_b[DATA_WIDTH-2:0]};
                end

                2'b01: begin
                    y <= reg_a - reg_b;
                end

                2'b10: begin
                    y <= reg_a & reg_b;
                end

                2'b11: begin
                    y <= reg_a | reg_b;
                end

            endcase

        end

    end

endmodule
