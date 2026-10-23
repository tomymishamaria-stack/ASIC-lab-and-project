`timescale 1ns/1ps

module activity_monitor (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       uart_act,
    input  wire       spi_act,
    input  wire       gpio_act,
    input  wire       timer_act,
    input  wire [3:0] holdoff_val,
    output reg        active
);

    // 2-Stage Synchronizer Registers for Metastability Prevention
    reg [1:0] uart_sync;
    reg [1:0] spi_sync;
    reg [1:0] gpio_sync;
    reg [1:0] timer_sync;

    wire raw_active_combined;
    reg [3:0] holdoff_cnt;

    // Double-flop synchronization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            uart_sync  <= 2'b00;
            spi_sync   <= 2'b00;
            gpio_sync  <= 2'b00;
            timer_sync <= 2'b00;
        end else begin
            uart_sync  <= {uart_sync[0],  uart_act};
            spi_sync   <= {spi_sync[0],   spi_act};
            gpio_sync  <= {gpio_sync[0],  gpio_act};
            timer_sync <= {timer_sync[0], timer_act};
        end
    end

    // Combined active status across all monitored inputs
    assign raw_active_combined = uart_sync[1] | spi_sync[1] | gpio_sync[1] | timer_sync[1];

    // Hold-off Timer Logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            holdoff_cnt <= 4'd0;
            active      <= 1'b0;
        end else begin
            if (raw_active_combined) begin
                active      <= 1'b1;
                holdoff_cnt <= 4'd0;
            end else if (holdoff_cnt < holdoff_val) begin
                active      <= 1'b1;
                holdoff_cnt <= holdoff_cnt + 1'b1;
            end else begin
                active      <= 1'b0;
            end
        end
    end

endmodule
