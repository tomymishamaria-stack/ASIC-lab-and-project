`timescale 1ns/1ps

module clock_divider (
    input  wire clk,
    input  wire rst_n,
    input  wire clk_div_en,
    output reg  scaled_clk
);

    reg [1:0] cnt;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt        <= 2'd0;
            scaled_clk <= 1'b0;
        end else if (clk_div_en) begin
            cnt <= cnt + 1'b1;
            if (cnt == 2'd1) begin
                scaled_clk <= ~scaled_clk;
                cnt        <= 2'd0;
            end
        end else begin
            cnt        <= 2'd0;
            scaled_clk <= clk; // Pass through primary clock when div is disabled
        end
    end

endmodule
