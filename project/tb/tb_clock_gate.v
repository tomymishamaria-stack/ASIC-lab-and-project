`timescale 1ns/1ps

module tb_clock_gate;
    reg clk, clk_gate_req;
    wire gated_clk;

    clock_gate uut (
        .clk(clk), .clk_gate_req(clk_gate_req), .gated_clk(gated_clk)
    );

    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_clock_gate.vcd");
        $dumpvars(0, tb_clock_gate);

        clk = 0; clk_gate_req = 0;
        #12;

        // Assert request when clk is high
        clk_gate_req = 1;
        #40;

        // Deassert request when clk is low
        @ (negedge clk);
        clk_gate_req = 0;
        #40;

        $finish;
    end
endmodule
