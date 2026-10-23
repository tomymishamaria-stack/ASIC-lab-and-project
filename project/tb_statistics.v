`timescale 1ns/1ps

module tb_statistics;

    // Inputs to DUT
    reg        clk;
    reg        rst_n;
    reg  [2:0] state;

    // Outputs from DUT
    wire [31:0] active_cycles;
    wire [31:0] low_freq_cycles;
    wire [31:0] gated_cycles;
    wire [31:0] retention_cycles;
    wire [31:0] power_gated_cycles;

    // Instantiate DUT
    statistics uut (
        .clk                  (clk),
        .rst_n                (rst_n),
        .state                (state),
        .active_cycles        (active_cycles),
        .low_freq_cycles      (low_freq_cycles),
        .gated_cycles         (gated_cycles),
        .retention_cycles     (retention_cycles),
        .power_gated_cycles   (power_gated_cycles)
    );

    // 100 MHz Clock Generator
    always #5 clk = ~clk;

    initial begin
        // Step 0: Initial Zero State
        clk   = 1'b0;
        rst_n = 1'b0;
        state = 3'b000;

        // Step 1: Release Reset
        #15 rst_n = 1'b1;
        @(posedge clk);

        // ------------------------------------------------------------------
        // Phase 1: Long Run to Push Lower Counter Bits Across Boundaries
        // ------------------------------------------------------------------
        state = 3'b000; repeat (2048) @(posedge clk);
        state = 3'b001; repeat (2048) @(posedge clk);
        state = 3'b010; repeat (2048) @(posedge clk);
        state = 3'b011; repeat (2048) @(posedge clk);
        state = 3'b100; repeat (2048) @(posedge clk);

        // ------------------------------------------------------------------
        // Phase 2: Toggle State Vector Bits Completely
        // ------------------------------------------------------------------
        state = 3'b101; repeat (10) @(posedge clk);
        state = 3'b110; repeat (10) @(posedge clk);
        state = 3'b111; repeat (10) @(posedge clk);
        state = 3'b000; repeat (10) @(posedge clk);

        // ------------------------------------------------------------------
        // Phase 3: Reset Pulse to Toggle Bits 1 -> 0 -> 1
        // ------------------------------------------------------------------
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;
        #20;

        $finish;
    end

endmodule
