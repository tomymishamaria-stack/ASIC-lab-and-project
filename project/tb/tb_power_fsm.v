`timescale 1ns/1ps

module tb_power_fsm;

    reg         clk;
    reg         rst_n;
    reg         active;
    reg   [7:0] idle_count;
    wire  [1:0] state;
    wire        clk_gate;
    wire        power_gate;

    power_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .active(active),
        .idle_count(idle_count),
        .state(state),
        .clk_gate(clk_gate),
        .power_gate(power_gate)
    );

    // 100 MHz Clock Generation
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_power_fsm.vcd");
        $dumpvars(0, tb_power_fsm);

        clk        = 0;
        rst_n      = 0;
        active     = 1;
        idle_count = 0;

        #15 rst_n = 1;
        #20;

        // 1. Transition: ACTIVE -> SLEEP
        active     = 0;
        idle_count = 8'd12;
        #20;

        // 2. Transition: SLEEP -> DEEP_SLEEP
        idle_count = 8'd55;
        #20;

        // 3. Toggle all idle_count bits high for 100% toggle coverage
        idle_count = 8'hFF;
        #20;

        // 4. Transition: DEEP_SLEEP -> ACTIVE
        active     = 1;
        idle_count = 8'd0;
        #20;

        // 5. Test wakeup transition: ACTIVE -> SLEEP -> ACTIVE
        active     = 0;
        idle_count = 8'd15;
        #20;
        active     = 1;
        idle_count = 8'd0;
        #20;

        // 6. Force current_state to 2'b11 to hit default block (line 72)
        force dut.current_state = 2'b11;
        #10;
        release dut.current_state;

        // 7. Reset back to ACTIVE
        rst_n = 0;
        #10;
        rst_n = 1;
        #20;

        $finish;
    end

endmodule
