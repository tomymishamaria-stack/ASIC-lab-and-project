`timescale 1ns/1ps

module tb_clock_divider;

    reg  clk;
    reg  rst_n;
    reg  clk_div_en;
    wire scaled_clk;

    // Instantiate Device Under Test
    clock_divider uut (
        .clk(clk),
        .rst_n(rst_n),
        .clk_div_en(clk_div_en),
        .scaled_clk(scaled_clk)
    );

    // 100 MHz System Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_clock_divider.vcd");
        $dumpvars(0, tb_clock_divider);

        // 1. Initial Reset Sequence
        clk        = 0;
        rst_n      = 0;
        clk_div_en = 0;

        // Reset De-assertion (0 -> 1 transition)
        #15 rst_n = 1;

        // 2. Pass-through mode check (clk_div_en = 0)
        #30;

        // 3. Clock Division Mode (clk_div_en = 1)
        clk_div_en = 1; // 0 -> 1 transition
        #100;           // Allow internal division counter to roll over multiple times

        // 4. Return to Pass-through Mode
        clk_div_en = 0; // 1 -> 0 transition
        #40;

        // 5. Re-assert Reset (1 -> 0 transition on rst_n for 100% toggle)
        rst_n = 0;
        #20;
        rst_n = 1;      // Return to active high
        #20;

        $finish;
    end

endmodule
