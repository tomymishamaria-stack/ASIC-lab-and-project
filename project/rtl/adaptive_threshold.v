`timescale 1ns/1ps

module adaptive_threshold (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       adapt_enable,
    input  wire [7:0] base_sleep_thresh,
    input  wire [7:0] base_deep_sleep_thresh,
    input  wire [7:0] predicted_idle_time,
    output reg  [7:0] sleep_thresh,
    output reg  [7:0] deep_sleep_thresh
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sleep_thresh      <= 8'd10;
            deep_sleep_thresh <= 8'd50;
        end else if (!adapt_enable) begin
            sleep_thresh      <= base_sleep_thresh;
            deep_sleep_thresh <= base_deep_sleep_thresh;
        end else begin
            // Adaptive algorithm: If long idle predicted (>128), lower thresholds to drop into low-power states faster
            if (predicted_idle_time > 8'd128) begin
                sleep_thresh      <= (base_sleep_thresh > 8'd4) ? (base_sleep_thresh - 8'd4) : 8'd1;
                deep_sleep_thresh <= (base_deep_sleep_thresh > 8'd10) ? (base_deep_sleep_thresh - 8'd10) : 8'd5;
            end else begin
                sleep_thresh      <= base_sleep_thresh;
                deep_sleep_thresh <= base_deep_sleep_thresh;
            end
        end
    end

endmodule
