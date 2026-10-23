`timescale 1ns/1ps

module tb_top;

    reg        pclk;
    reg        prst_n;
    reg  [7:0] paddr;
    reg        psel;
    reg        penable;
    reg        pwrite;
    reg [31:0] pwdata;

    wire [31:0] prdata;
    wire        pready;
    wire        adapt_enable;
    wire  [7:0] base_sleep_thresh;
    wire  [7:0] base_deep_sleep_thresh;
    wire [31:0] active_cycles;
    wire [31:0] low_freq_cycles;
    wire [31:0] gated_cycles;
    wire [31:0] retention_cycles;
    wire [31:0] power_gated_cycles;

    integer i;

    // Instantiate Top DUT
    top uut (
        .pclk                 (pclk),
        .prst_n               (prst_n),
        .paddr                (paddr),
        .psel                 (psel),
        .penable              (penable),
        .pwrite               (pwrite),
        .pwdata               (pwdata),
        .prdata               (prdata),
        .pready               (pready),
        .adapt_enable         (adapt_enable),
        .base_sleep_thresh    (base_sleep_thresh),
        .base_deep_sleep_thresh (base_deep_sleep_thresh),
        .active_cycles        (active_cycles),
        .low_freq_cycles      (low_freq_cycles),
        .gated_cycles         (gated_cycles),
        .retention_cycles     (retention_cycles),
        .power_gated_cycles   (power_gated_cycles)
    );

    // 100 MHz Clock Generator
    always #5 pclk = ~pclk;

    initial begin
        // VCD Generation
        $dumpfile("vcd/tb_top.vcd");
        $dumpvars(0, tb_top);

        // Initialization
        pclk    = 1'b0;
        prst_n  = 1'b0;
        paddr   = 8'h00;
        psel    = 1'b0;
        penable = 1'b0;
        pwrite  = 1'b0;
        pwdata  = 32'h00000000;

        #15 prst_n = 1'b1;
        @(posedge pclk);

        // ------------------------------------------------------------------
        // Step 1: APB Register Write/Read Sweeps
        // ------------------------------------------------------------------
        apb_write(8'h00, 32'hFFFFFFFF); apb_read(8'h00);
        apb_write(8'h00, 32'h00000000); apb_read(8'h00);
        apb_write(8'h04, 32'hFFFFFFFF); apb_read(8'h04);
        apb_write(8'h08, 32'hFFFFFFFF); apb_read(8'h08);

        // ------------------------------------------------------------------
        // Step 2: Comprehensive Address & State Vector Sweep (0 to 255)
        // ------------------------------------------------------------------
        for (i = 0; i < 256; i = i + 1) begin
            apb_read(i[7:0]);
            @(posedge pclk);
        end

        // ------------------------------------------------------------------
        // Step 3: Reset Line Toggle Test
        // ------------------------------------------------------------------
        #20 prst_n = 1'b0;
        #20 prst_n = 1'b1;
        #20;

        $finish;
    end

    // APB Write Task
    task apb_write(input [7:0] addr, input [31:0] data);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwdata  = data;
            pwrite  = 1'b1;
            psel    = 1'b1;
            penable = 1'b0;
            @(posedge pclk);
            penable = 1'b1;
            @(posedge pclk);
            psel    = 1'b0;
            penable = 1'b0;
            pwrite  = 1'b0;
        end
    endtask

    // APB Read Task
    task apb_read(input [7:0] addr);
        begin
            @(posedge pclk);
            paddr   = addr;
            pwrite  = 1'b0;
            psel    = 1'b1;
            penable = 1'b0;
            @(posedge pclk);
            penable = 1'b1;
            @(posedge pclk);
            psel    = 1'b0;
            penable = 1'b0;
        end
    endtask

endmodule
