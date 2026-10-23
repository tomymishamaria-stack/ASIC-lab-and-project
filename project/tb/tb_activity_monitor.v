`timescale 1ns/1ps

module tb_activity_monitor;

    reg        clk;
    reg        rst_n;
    reg        uart_act;
    reg        spi_act;
    reg        gpio_act;
    reg        timer_act;
    reg  [3:0] holdoff_val;
    wire       active;

    // Instantiate Unit Under Test (UUT)
    activity_monitor uut (
        .clk(clk),
        .rst_n(rst_n),
        .uart_act(uart_act),
        .spi_act(spi_act),
        .gpio_act(gpio_act),
        .timer_act(timer_act),
        .holdoff_val(holdoff_val),
        .active(active)
    );

    // 100 MHz Clock Generation (10 ns period)
    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_activity_monitor.vcd");
        $dumpvars(0, tb_activity_monitor);

        // Initialize Signals
        clk         = 0;
        rst_n       = 0;
        uart_act    = 0;
        spi_act     = 0;
        gpio_act    = 0;
        timer_act   = 0;
        holdoff_val = 4'b0000;

        // 1. Initial Reset Release
        #15 rst_n = 1;
        #20;

        // 2. Pulse UART, SPI, GPIO, and Timer Activity sequentially
        uart_act = 1; #20; uart_act = 0; #40;
        spi_act  = 1; #20; spi_act  = 0; #40;
        gpio_act = 1; #20; gpio_act = 0; #40;
        timer_act= 1; #20; timer_act= 0; #40;

        // 3. Drive holdoff_val through ALL bit toggles (0000 -> 1111 -> 0000)
        holdoff_val = 4'b1111; // Drives all bits high (0->1)
        #20;
        timer_act   = 1; #20; timer_act = 0; #180; // Let counter count to 15
        
        holdoff_val = 4'b0000; // Drives all bits low (1->0)
        #20;

        // 4. Mid-simulation Reset Toggle (Fixes rst_n 0% Toggle Coverage)
        rst_n = 0; // Drives rst_n 1->0
        #20;
        rst_n = 1; // Drives rst_n 0->1
        #20;

        $display("Simulation Finished Successfully!");
        $finish;
    end

endmodule
