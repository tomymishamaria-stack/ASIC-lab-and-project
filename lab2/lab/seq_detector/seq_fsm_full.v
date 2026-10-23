module tb_seq_101_max;

    reg clk;
    reg rst;
    reg x;
    wire y;

    // Instantiate Design Under Test (DUT)
    seq_101 dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .y(y)
    );

    // Clock Generation (10ns period)
    always #5 clk = ~clk;

    initial begin
        // Initialize Signals
        clk = 0;
        rst = 1;
        x = 0;

        // Apply Reset (S0 State)
        #10 rst = 0;

        // --- Cover S0 Transitions ---
        @(posedge clk) x = 0; // S0 -> S0 (x = 0)
        @(posedge clk) x = 1; // S0 -> S1 (x = 1)

        // --- Cover S1 Transitions ---
        @(posedge clk) x = 1; // S1 -> S1 (x = 1)
        @(posedge clk) x = 0; // S1 -> S2 (x = 0)

        // --- Cover S2 Transitions ---
        @(posedge clk) x = 0; // S2 -> S0 (x = 0)

        // Re-enter S2: S0 -> S1 -> S2
        @(posedge clk) x = 1;
        @(posedge clk) x = 0;

        // Cover S2 -> S1 Transition & Overlapping Detection ("101")
        @(posedge clk) x = 1; // S2 -> S1 (x = 1), y should pulse HIGH

        // --- Cover Overlapping Sequence ("10101") ---
        @(posedge clk) x = 0; // S1 -> S2
        @(posedge clk) x = 1; // S2 -> S1, second '101' detected

        // --- Cover Reset Assertion while Active ---
        @(posedge clk) x = 0; // Move to S2
        @(posedge clk) rst = 1; // Reset mid-operation back to S0
        @(posedge clk) rst = 0;

        #20;
        $display("---FSM Coverage max---");
        $finish;
    end

endmodule
