`timescale 1ns/1ps

module ripple_tb;

reg [3:0] A;
reg [3:0] B;
reg Cin;

wire [3:0] Sum;
wire Cout;

// Instantiate the Ripple Carry Adder
ripple_adder_4bit DUT (
    .A(A),
    .B(B),
    .Cin(Cin),
    .Sum(Sum),
    .Cout(Cout)
);

initial begin

    $display(" Time\t A\t B\t Cin\t Sum\t Cout");
    $monitor("%4t\t%b\t%b\t%b\t%b\t%b",
              $time, A, B, Cin, Sum, Cout);

    // Test Case 1
    A = 4'b0000;
    B = 4'b0000;
    Cin = 0;
    #10;

    // Test Case 2
    A = 4'b0001;
    B = 4'b0010;
    Cin = 0;
    #10;

    // Test Case 3
    A = 4'b0011;
    B = 4'b0101;
    Cin = 0;
    #10;

    // Test Case 4
    A = 4'b1111;
    B = 4'b0001;
    Cin = 0;
    #10;

    // Test Case 5
    A = 4'b1010;
    B = 4'b0101;
    Cin = 0;
    #10;

    // Test Case 6
    A = 4'b1111;
    B = 4'b1111;
    Cin = 0;
    #10;

    // Test Case 7 (with carry in)
    A = 4'b1001;
    B = 4'b0110;
    Cin = 1;
    #10;

    $finish;

end

endmodule
