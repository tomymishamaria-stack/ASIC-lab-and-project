module alu_expr (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic [7:0] C,
    input  logic [7:0] D,
    output logic signed [10:0] Y
);

    always_comb begin
        Y = $signed({3'b000, A})
          + $signed({3'b000, B})
          + $signed({3'b000, C})
          - $signed({3'b000, D});
    end

endmodule
