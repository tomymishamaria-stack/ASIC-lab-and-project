module mux_good (
    input  [3:0] a,
    input  [3:0] b,
    input        sel,
    output [3:0] y
);

    wire [3:0] sel_a;
    wire [3:0] sel_b;
    wire [3:0] sel_n;

    assign sel_n = {4{~sel}};

    assign sel_a = {4{sel}} & a;
    assign sel_b = sel_n & b;

    assign y = sel_a | sel_b;

endmodule
