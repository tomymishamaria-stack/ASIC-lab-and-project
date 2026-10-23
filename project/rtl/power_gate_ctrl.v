`timescale 1ns/1ps

module power_gate_ctrl (
    input  wire clk,
    input  wire rst_n,
    input  wire power_gate_req,
    output reg  iso_en,
    output reg  power_off
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            iso_en    <= 1'b0;
            power_off <= 1'b0;
        end else begin
            // Sequence isolation before shutting down power
            iso_en    <= power_gate_req;
            power_off <= power_gate_req;
        end
    end

endmodule
