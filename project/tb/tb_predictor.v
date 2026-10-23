`timescale 1ns/1ps

module tb_predictor;
    reg clk, rst_n, active;
    wire [7:0] predicted_idle_time;

    predictor uut (
        .clk(clk),
        .rst_n(rst_n),
        .active(active),
        .predicted_idle_time(predicted_idle_time)
    );

    always #5 clk = ~clk;

    initial begin
        // VCD Generation Block
        $dumpfile("vcd/tb_predictor.vcd");
        $dumpvars(0, tb_predictor);

        // 1. Initial State
        clk = 0; 
        rst_n = 0; 
        active = 0;
        
        // 0 -> 1 transition on rst_n
        #15 rst_n = 1;

        // 2. Shift in 8 continuous 1s (history fills with 0xFF, predicted_idle_time drops to 0x00)
        repeat (8) begin
            active = 1; 
            #10;
        end

        // 3. Shift in 8 continuous 0s (history fills with 0x00, predicted_idle_time rises to 0xFF)
        repeat (8) begin
            active = 0; 
            #10;
        end

        // 4. Alternating pattern (forces middle bits [6:1] of history and predicted_idle_time to toggle)
        repeat (4) begin
            active = 1; #10;
            active = 0; #10;
        end

        // 5. Re-assert Reset (Triggers 1 -> 0 transition on rst_n for 100% rst_n toggle coverage)
        #10 rst_n = 0;
        #20 rst_n = 1;

        #20 $finish;
    end
endmodule
