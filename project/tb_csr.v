`timescale 1ns/1ps

module tb_csr;

    reg        pclk;
    reg        prst_n;
    reg  [7:0] paddr;
    reg        psel;
    reg        penable;
    reg        pwrite;
    reg [31:0] pwdata;
    reg  [2:0] current_state;
    reg  [7:0] idle_count;

    wire [31:0] prdata;
    wire        pready;
    wire        adapt_enable;
    wire  [7:0] base_sleep_thresh;
    wire  [7:0] base_deep_sleep_thresh;

    integer i;

    // Instantiate DUT
    csr uut (
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

    // 100 MHz Clock Generation
    always #5 pclk = ~pclk;

    initial begin
        // Initialization
        pclk          = 1'b0;
        prst_n        = 1'b0;
        paddr         = 8'h00;
        psel          = 1'b0;
        penable       = 1'b0;
        pwrite        = 1'b0;
        pwdata        = 32'h00000000;
        current_state = 3'b000;
        idle_count    = 8'h00;

        #15 prst_n = 1'b1;
        @(posedge pclk);

        // ------------------------------------------------------------------
        // Step 1: Sweep Full 32-bit Data Patterns
        // ------------------------------------------------------------------
        apb_write(8'h00, 32'hFFFFFFFF); apb_read(8'h00);
        apb_write(8'h00, 32'h00000000); apb_read(8'h00);
        apb_write(8'h00, 32'hAAAAAAAA); apb_read(8'h00);
        apb_write(8'h00, 32'h55555555); apb_read(8'h00);

        apb_write(8'h04, 32'hFFFFFFFF); apb_read(8'h04);
        apb_write(8'h04, 32'h00000000); apb_read(8'h04);

        apb_write(8'h08, 32'hFFFFFFFF); apb_read(8'h08);
        apb_write(8'h08, 32'h00000000); apb_read(8'h08);

        // ------------------------------------------------------------------
        // Step 2: Comprehensive Walking 1s/0s Sweep for paddr[7:0]
        // ------------------------------------------------------------------
        for (i = 0; i < 8; i = i + 1) begin
            apb_read(8'h01 << i);
            apb_read(~(8'h01 << i));
        end
        apb_read(8'hAA);
        apb_read(8'h55);
        apb_read(8'h0C);
        apb_read(8'h10);

        // ------------------------------------------------------------------
        // Step 3: Exercise State & Counter Vectors
        // ------------------------------------------------------------------
        current_state = 3'b111; idle_count = 8'hFF; @(posedge pclk);
        current_state = 3'b000; idle_count = 8'h00; @(posedge pclk);
        current_state = 3'b101; idle_count = 8'hAA; @(posedge pclk);
        current_state = 3'b010; idle_count = 8'h55; @(posedge pclk);

        // ------------------------------------------------------------------
        // Step 4: Reset Line Toggle
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
