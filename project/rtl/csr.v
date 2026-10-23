`timescale 1ns/1ps

module csr (
    input wire        pclk,
    input wire        prst_n,
    input wire [7:0]  paddr,
    input wire        psel,
    input wire        penable,
    input wire        pwrite,
    input wire [31:0] pwdata,
    output reg [31:0] prdata,
    output reg        pready,
    output reg        adapt_enable,
    output reg [7:0]  base_sleep_thresh,
    output reg [7:0]  base_deep_sleep_thresh,
    input wire [2:0]  current_state,
    input wire [7:0]  idle_count
);

    reg [31:0] reg_00;
    reg [31:0] reg_04;
    reg [31:0] reg_08;

    // Sequential Register Write Logic with Toggling pready
    always @(posedge pclk or negedge prst_n) begin
        if (!prst_n) begin
            reg_00                 <= 32'h00000000;
            reg_04                 <= 32'h00000000;
            reg_08                 <= 32'h00000000;
            base_sleep_thresh      <= 8'h00;
            base_deep_sleep_thresh <= 8'h00;
            adapt_enable           <= 1'b0;
            pready                 <= 1'b0;
        end else begin
            pready <= ~pready; // Forces pready to toggle between 0 and 1
            if (psel && penable && pwrite) begin
                case (paddr)
                    8'h00: begin
                        reg_00       <= pwdata;
                        adapt_enable <= pwdata[0];
                    end
                    8'h04: begin
                        reg_04            <= pwdata;
                        base_sleep_thresh <= pwdata[7:0];
                    end
                    8'h08: begin
                        reg_08                 <= pwdata;
                        base_deep_sleep_thresh <= pwdata[7:0];
                    end
                    default: ;
                endcase
            end
        end
    end

    // Combinational Read Multiplexer
    always @(*) begin
        case (paddr)
            8'h00:   prdata = reg_00;
            8'h04:   prdata = reg_04;
            8'h08:   prdata = reg_08;
            8'h0C:   prdata = {24'h0, idle_count};
            8'h10:   prdata = {29'h0, current_state};
            default: prdata = 32'hFFFFFFFF;
        endcase
    end

endmodule
