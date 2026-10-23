`timescale 1ns/1ps

module tb_statistics;

    reg         clk;
    reg         rst_n;
    reg   [2:0] state;

    wire [31:0] active_cycles;
    wire [31:0] low_freq_cycles;
    wire [31:0] gated_cycles;
    wire [31:0] retention_cycles;
    wire [31:0] power_gated_cycles;

    // Instantiate DUT
    statistics uut (
        .clk                (clk),
        .rst_n              (rst_n),
        .state              (state),
        .active_cycles      (active_cycles),
        .low_freq_cycles    (low_freq_cycles),
        .gated_cycles       (gated_cycles),
        .retention_cycles   (retention_cycles),
        .power_gated_cycles (power_gated_cycles)
    );

    // 100 MHz Clock Generator
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_statistics.vcd");
        $dumpvars(0, tb_statistics);

        // Initialization
        clk   = 1'b0;
        rst_n = 1'b0;
        state = 3'b000;

        #15 rst_n = 1'b1;
        @(posedge clk);

        // ------------------------------------------------------------------
        // Step 1: Sweep All States to Increment Counters
        // ------------------------------------------------------------------
        state = 3'b000; repeat (16) @(posedge clk);
        state = 3'b001; repeat (16) @(posedge clk);
        state = 3'b010; repeat (16) @(posedge clk);
        state = 3'b011; repeat (16) @(posedge clk);
        state = 3'b100; repeat (16) @(posedge clk);

        // ------------------------------------------------------------------
        // Step 2: Trigger Complementary Inversion Paths (States 101, 110, 111)
        // ------------------------------------------------------------------
        state = 3'b101; @(posedge clk);
        state = 3'b110; @(posedge clk);
        state = 3'b111; @(posedge clk);
        state = 3'b000; @(posedge clk);

        // ------------------------------------------------------------------
        // Step 3: Complete Reset Toggle (1 -> 0 -> 1)
        // ------------------------------------------------------------------
        #20 rst_n = 1'b0;
        #20 rst_n = 1'b1;
        #20;

        $finish;
    end

endmodule
