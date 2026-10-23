//`timescale 1ns/1ps

module tb_expression_partial;

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

    // Test 1: (a&b)=1, (c&d)=0, y=1
    a = 1; b = 1; c = 0; d = 0;
    #10;

    // Test 2: (a&b)=0, (c&d)=0, y=0
    a = 0; b = 1; c = 0; d = 1;
    #10;

    // Test 3: (a&b)=1, (c&d)=0, y=1
    a = 1; b = 1; c = 1; d = 0;
    #10;

    $finish;

end

endmodule
