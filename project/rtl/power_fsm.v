`timescale 1ns/1ps

module power_fsm (
    input  wire       clk,
    input  wire       rst_n,
    input  wire       active,
    input  wire [7:0] idle_count,
    output reg  [1:0] state,
    output reg        clk_gate,
    output reg        power_gate
);

    // State Encoding
    localparam ACTIVE     = 2'b00;
    localparam SLEEP      = 2'b01;
    localparam DEEP_SLEEP = 2'b10;

    // Thresholds
    localparam SLEEP_THRESH      = 8'd10;
    localparam DEEP_SLEEP_THRESH = 8'd50;

    reg [1:0] current_state, next_state;

    // State Register (Sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= ACTIVE;
        else
            current_state <= next_state;
    end

    // Next State Logic (Combinational)
    always @(*) begin
        next_state = current_state;
        case (current_state)
            ACTIVE: begin
                if (!active && (idle_count >= SLEEP_THRESH))
                    next_state = SLEEP;
            end
            SLEEP: begin
                if (active)
                    next_state = ACTIVE;
                else if (idle_count >= DEEP_SLEEP_THRESH)
                    next_state = DEEP_SLEEP;
            end
            DEEP_SLEEP: begin
                if (active)
                    next_state = ACTIVE;
            end
            default: next_state = ACTIVE;
        endcase
    end

    // Output Logic
    always @(*) begin
        clk_gate   = 1'b0;
        power_gate = 1'b0;
        state      = ACTIVE;

        case (current_state)
            ACTIVE: begin
                clk_gate   = 1'b0;
                power_gate = 1'b0;
                state      = ACTIVE;
            end
            SLEEP: begin
                clk_gate   = 1'b1;
                power_gate = 1'b0;
                state      = SLEEP;
            end
            DEEP_SLEEP: begin
                clk_gate   = 1'b1;
                power_gate = 1'b1;
                state      = DEEP_SLEEP;
            end
            default: begin
                clk_gate   = 1'b0;
                power_gate = 1'b0;
                state      = ACTIVE;
            end
        endcase
    end

endmodule
