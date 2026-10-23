`timescale 1ns/1ps

module tb_adaptive_threshold;

    reg        clk;
    reg        rst_n;
    reg        adapt_enable;
    reg  [7:0] base_sleep_thresh;
    reg  [7:0] base_deep_sleep_thresh;
    reg  [7:0] predicted_idle_time;

    wire [7:0] sleep_thresh;
    wire [7:0] deep_sleep_thresh;

    // Instantiate Device Under Test (DUT)
    adaptive_threshold uut (
        .clk(clk),
        .rst_n(rst_n),
        .adapt_enable(adapt_enable),
        .base_sleep_thresh(base_sleep_thresh),
        .base_deep_sleep_thresh(base_deep_sleep_thresh),
        .predicted_idle_time(predicted_idle_time),
        .sleep_thresh(sleep_thresh),
        .deep_sleep_thresh(deep_sleep_thresh)
    );

    // 100 MHz Clock Generator
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_adaptive_threshold.vcd");
        $dumpvars(0, tb_adaptive_threshold);

        // -------------------------------------------------------------
        // Phase 1: Reset Initialization & Falling Edge Capture
        // -------------------------------------------------------------
        clk                    = 0;
        rst_n                  = 0;
        adapt_enable           = 0;
        base_sleep_thresh    = 8'h00;
        base_deep_sleep_thresh = 8'h00;
        predicted_idle_time    = 8'h00;

        #15 rst_n = 1; // rst_n 0 -> 1 transition

        // -------------------------------------------------------------
        // Phase 2: Bypass Mode (adapt_enable = 0)
        // -------------------------------------------------------------
        // Drive 0xAA and 0x55 to toggle all 8 bits on base threshold inputs
        base_sleep_thresh      = 8'hAA;
        base_deep_sleep_thresh = 8'h55;
        #10;

        base_sleep_thresh      = 8'h55;
        base_deep_sleep_thresh = 8'hAA;
        #10;

        // -------------------------------------------------------------
        // Phase 3: Adaptive Mode Enabled (adapt_enable = 1)
        // -------------------------------------------------------------
        adapt_enable = 1; // adapt_enable 0 -> 1 transition
        #10;

        // Sweep predicted_idle_time across high/low extreme values
        // Toggles all 8 bits of predicted_idle_time, sleep_thresh, & deep_sleep_thresh
        predicted_idle_time = 8'hFF;
        #10;

        predicted_idle_time = 8'h00;
        #10;

        predicted_idle_time = 8'hAA;
        #10;

        predicted_idle_time = 8'h55;
        #10;

        // -------------------------------------------------------------
        // Phase 4: Mode Deassertion & Final Reset Toggles
        // -------------------------------------------------------------
        adapt_enable = 0; // adapt_enable 1 -> 0 transition
        #10;

        // Force all 8 bits on base registers to 0xFF then 0x00
        base_sleep_thresh      = 8'hFF;
        base_deep_sleep_thresh = 8'hFF;
        #10;

        base_sleep_thresh      = 8'h00;
        base_deep_sleep_thresh = 8'h00;
        #10;

        // Force rst_n 1 -> 0 transition for complete toggle coverage on reset line
        rst_n = 0;
        #10;
        rst_n = 1;
        #10;

        $finish;
    end

endmodule
