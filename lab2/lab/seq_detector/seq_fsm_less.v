//`timescale 1ns/1ps

module tb_seq_101_min;

    reg clk;
    reg rst;
    reg x;
    wire y;

    // Instantiate DUT
    seq_101 dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock Generator (10ns Period)
    always #5 clk = ~clk;


    initial begin
        clk = 0;
        rst = 1;
        x   = 0;

        #10;
        rst = 0;

        // Cover limited FSM transitions
        // S0 -> S0
        x = 0; #10;

        // S0 -> S1
        x = 1; #10;

        // S1 -> S1
        x = 1; #10;

        #20;
        $finish;
    end

endmodule
