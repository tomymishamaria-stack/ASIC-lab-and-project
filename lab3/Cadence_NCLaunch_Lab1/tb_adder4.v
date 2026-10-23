`timescale 1ns/1ps
module tb_adder4;
reg [3:0] A,B;
reg Cin;
wire [3:0] Sum;
wire Cout;

adder4 DUT(.A(A),.B(B),.Cin(Cin),.Sum(Sum),.Cout(Cout));

initial begin
$display("Time A B Cin Sum Cout");
$monitor("%0t %0d %0d %0b %0d %0b",$time,A,B,Cin,Sum,Cout);
A=0;B=0;Cin=0;
#10 A=3;B=2;
#10 A=5;B=7;
#10 A=9;B=4;Cin=1;
#10 A=15;B=15;
#10 $finish;
end
endmodule
