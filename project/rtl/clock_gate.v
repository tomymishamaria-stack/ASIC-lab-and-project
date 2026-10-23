`timescale 1ns/1ps

module clock_gate (
    input  wire clk,
    input  wire clk_gate_req,
    output wire gated_clk
);

    reg latch_en;
    wire enable_n = ~clk_gate_req;

    // Active low latch on active low clock phase avoids output glitching
    always @(clk or enable_n) begin
        if (!clk)
            latch_en <= enable_n;
    end

    assign gated_clk = clk && latch_en;

endmodule
