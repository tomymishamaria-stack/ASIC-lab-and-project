`timescale 1ns/1ps
module idle_counter #(
    parameter WIDTH = 8
)(
    input  wire             clk,
    input  wire             rst_n,
    input  wire             active,
    output reg [WIDTH-1:0]  idle_count
);

always @(posedge clk or negedge rst_n) begin

    if (!rst_n)
        idle_count <= {WIDTH{1'b0}};

    else if (active)
        idle_count <= {WIDTH{1'b0}};

    else
        idle_count <= idle_count + 1'b1;

end

endmodule
