`timescale 1ns/1ps

module tb_retention_ctrl;

    reg clk;
    reg rst_n;
    reg retention_req;

    wire retention_en;
    wire save_state;
    wire restore_state;

    // Instantiate Device Under Test
    retention_ctrl uut (
        .clk(clk),
        .rst_n(rst_n),
        .retention_req(retention_req),
        .retention_en(retention_en),
        .save_state(save_state),
        .restore_state(restore_state)
    );

    // 100 MHz System Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_retention_ctrl.vcd");
        $dumpvars(0, tb_retention_ctrl);

        // 1. Initial Reset Phase
        clk           = 0;
        rst_n         = 0;
        retention_req = 0;

        // Reset De-assertion (0 -> 1 transition)
        #15 rst_n = 1;

        // 2. Assert Retention Request (Triggers save_state pulse & retention_en)
        #10 retention_req = 1;
        #30; // Hold in retention state

        // 3. De-assert Retention Request (Triggers restore_state pulse & drops retention_en)
        #10 retention_req = 0;
        #30;

        // 4. Re-assert Reset (1 -> 0 and 0 -> 1 transitions on rst_n for 100% toggle)
        #10 rst_n = 0;
        #20 rst_n = 1;
        #20;

        $finish;
    end

endmodule
