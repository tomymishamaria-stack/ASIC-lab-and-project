`timescale 1ns/1ps

module predictor (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       active,
    output reg  [7:0] predicted_idle_time
);

    reg [7:0] history_shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            history_shift_reg   <= 8'h00;
            predicted_idle_time <= 8'd0;
        end else begin
            // Shift in activity history bit on every clock cycle
            history_shift_reg <= {history_shift_reg[6:0], active};
            
            // Calculate activity density: lightweight prediction metric
            // Higher history_shift_reg value implies frequent recent activity
            // Lower value implies extended upcoming idle period
            predicted_idle_time <= 8'hFF - history_shift_reg;
        end
    end

endmodule
