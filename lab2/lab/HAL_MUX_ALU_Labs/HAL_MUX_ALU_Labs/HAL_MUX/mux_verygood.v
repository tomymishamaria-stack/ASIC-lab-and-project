module mux_verygood #(
    parameter [31:0] WIDTH = 32'd4
)(
    input wire clk,
    input wire rst_n,
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire sel,
    output reg [WIDTH-1:0] y
);

    reg [WIDTH-1:0] reg_a;
    reg [WIDTH-1:0] reg_b;
    reg reg_sel;

    always @(posedge clk or negedge rst_n) begin : proc_reg_inputs
        if (rst_n == 1'b0) begin
            reg_a <= {WIDTH{1'b0}};
            reg_b <= {WIDTH{1'b0}};
            reg_sel <= 1'b0;
        end
        else begin
            reg_a <= a;
            reg_b <= b;
            reg_sel <= sel;
        end
    end

    always @(posedge clk or negedge rst_n) begin : proc_mux_output
        if (rst_n == 1'b0) begin
            y <= {WIDTH{1'b0}};
        end
        else begin
            if (reg_sel == 1'b1) begin
                y <= reg_a;
            end
            else begin
                y <= reg_b;
            end
        end
    end

endmodule
