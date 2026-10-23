`timescale 1ns/1ps

module retention_ctrl (
    input  wire clk,
    input  wire rst_n,
    input  wire retention_req,
    output reg  retention_en,
    output reg  save_state,
    output reg  restore_state
);

    reg prev_req;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            retention_en  <= 1'b0;
            save_state    <= 1'b0;
            restore_state <= 1'b0;
            prev_req      <= 1'b0;
        end else begin
            prev_req      <= retention_req;
            retention_en  <= retention_req;
            save_state    <= retention_req && !prev_req;  // Pulse on entry
            restore_state <= !retention_req && prev_req;  // Pulse on exit
        end
    end

endmodule
