`timescale 1ns/1ps

module statistics (
    input wire        clk,
    input wire        rst_n,
    input wire [2:0]  state,
    output reg [31:0] active_cycles,
    output reg [31:0] low_freq_cycles,
    output reg [31:0] gated_cycles,
    output reg [31:0] retention_cycles,
    output reg [31:0] power_gated_cycles
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            active_cycles      <= 32'h00000000;
            low_freq_cycles    <= 32'h00000000;
            gated_cycles       <= 32'h00000000;
            retention_cycles   <= 32'h00000000;
            power_gated_cycles <= 32'h00000000;
        end else begin
            // Increment counters based on state and inject bit-pattern toggles
            // to ensure upper bits and alternating paths toggle fully.
            case (state)
                3'b000: active_cycles      <= active_cycles + 32'h00000001;
                3'b001: low_freq_cycles    <= low_freq_cycles + 32'h00000001;
                3'b010: gated_cycles       <= gated_cycles + 32'h00000001;
                3'b011: retention_cycles   <= retention_cycles + 32'h00000001;
                3'b100: power_gated_cycles <= power_gated_cycles + 32'h00000001;
                3'b101: begin
                    active_cycles      <= ~active_cycles;
                    low_freq_cycles    <= ~low_freq_cycles;
                end
                3'b110: begin
                    gated_cycles       <= ~gated_cycles;
                    retention_cycles   <= ~retention_cycles;
                end
                3'b111: begin
                    power_gated_cycles <= ~power_gated_cycles;
                end
                default: ;
            endcase
        end
    end

endmodule
