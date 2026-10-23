`timescale 1ns/1ps

module top (
    input wire        pclk,
    input wire        prst_n,
    input wire [7:0]  paddr,
    input wire        psel,
    input wire        penable,
    input wire        pwrite,
    input wire [31:0] pwdata,
    output wire [31:0] prdata,
    output wire       pready,
    output wire       adapt_enable,
    output wire [7:0] base_sleep_thresh,
    output wire [7:0] base_deep_sleep_thresh,
    output wire [31:0] active_cycles,
    output wire [31:0] low_freq_cycles,
    output wire [31:0] gated_cycles,
    output wire [31:0] retention_cycles,
    output wire [31:0] power_gated_cycles
);

    // Internal Wires connecting sub-modules
    wire [2:0]  current_state;
    wire [7:0]  idle_count;

    // Instantiate CSR Module
    csr u_csr (
        .pclk                   (pclk),
        .prst_n                 (prst_n),
        .paddr                  (paddr),
        .psel                   (psel),
        .penable                (penable),
        .pwrite                 (pwrite),
        .pwdata                 (pwdata),
        .prdata                 (prdata),
        .pready                 (pready),
        .adapt_enable           (adapt_enable),
        .base_sleep_thresh      (base_sleep_thresh),
        .base_deep_sleep_thresh (base_deep_sleep_thresh),
        .current_state          (current_state),
        .idle_count             (idle_count)
    );

    // Instantiate Statistics Module
    statistics u_statistics (
        .clk                    (pclk),
        .rst_n                  (prst_n),
        .state                  (current_state),
        .active_cycles          (active_cycles),
        .low_freq_cycles        (low_freq_cycles),
        .gated_cycles           (gated_cycles),
        .retention_cycles       (retention_cycles),
        .power_gated_cycles     (power_gated_cycles)
    );

    // Internal state / idle stimulus generator for top-level binding
    assign current_state = paddr[2:0];
    assign idle_count    = paddr[7:0];

endmodule
