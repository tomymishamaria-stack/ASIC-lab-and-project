`timescale 1ns/1ps

module tb_power_gate_ctrl;

    reg clk;
    reg rst_n;
    reg power_gate_req;

    wire iso_en;
    wire power_off;

    // Instantiate Device Under Test
    power_gate_ctrl uut (
        .clk(clk),
        .rst_n(rst_n),
        .power_gate_req(power_gate_req),
        .iso_en(iso_en),
        .power_off(power_off)
    );

    // 100 MHz System Clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_power_gate_ctrl.vcd");
        $dumpvars(0, tb_power_gate_ctrl);

        // 1. Initial Reset Phase
        clk            = 0;
        rst_n          = 0;
        power_gate_req = 0;

        // Reset De-assertion (0 -> 1 transition)
        #15 rst_n = 1;

        // 2. Assert Power Gate Request
        #10 power_gate_req = 1;
        #40; // Hold in power gated state

        // 3. De-assert Power Gate Request (Wakeup)
        #10 power_gate_req = 0;
        #30;

        // 4. Re-assert Reset (1 -> 0 and 0 -> 1 transitions on rst_n for 100% toggle)
        #10 rst_n = 0;
        #20 rst_n = 1;
        #20;

        $finish;
    end

endmodule
