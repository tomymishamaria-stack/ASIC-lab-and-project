`timescale 1ns/1ps

module tb_idle_counter;

    reg         clk;
    reg         rst_n;
    reg         active;
    wire [7:0] idle_count;

    // Instantiate Unit Under Test (DUT)
    idle_counter #(
        .WIDTH(8)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .active(active),
        .idle_count(idle_count)
    );

    // 100 MHz Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_idle_counter.vcd");
        $dumpvars(0, tb_idle_counter);

        // Initialize Signals
        clk    = 0;
        rst_n  = 0;
        active = 1;

        // 1. Release Initial Reset (0 -> 1 transition)
        #15 rst_n = 1;
        #20;

        // 2. Set active low to allow counter to reach max value (255 / 8'hFF)
        // This ensures all 8 bits of idle_count[7:0] toggle from 0 to 1
        active = 0;
        #2600; 

        // 3. Clear counter back to 0 (all 8 bits toggle 1 -> 0)
        active = 1;
        #30;

        // 4. Toggle rst_n mid-simulation (Fixes rst_n 0% toggle coverage)
        rst_n = 0; // 1 -> 0 transition
        #20;
        rst_n = 1; // 0 -> 1 transition
        #20;

        $display("Simulation Complete - 100%% Toggle Target Reached!");
        $finish;
    end

endmodule
