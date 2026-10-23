//`timescale 1ns/1ps

module tb_expression_full;

reg a, b, c, d;
wire y;

expression_cov dut (
    .a(a),
    .b(b),
    .c(c),
    .d(d),
    .y(y)
);

initial begin

    a=0; b=0; c=0; d=0;
    #10;

    a=1; b=0; c=0; d=0;
    #10;

    a=1; b=1; c=0; d=0;
    #10;

    a=1; b=1; c=1; d=0;
    #10;

    a=1; b=1; c=1; d=1;
    #10;

    a=0; b=1; c=1; d=1;
    #10;

    a=0; b=0; c=1; d=1;
    #10;

    a=0; b=0; c=0; d=1;
    #10;

    a=0; b=0; c=0; d=0;
    #10;

    $finish;

end

endmodule
