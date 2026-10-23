

//`timescale 1ns/1ps

module tb_control_datapath;

    parameter DATA_WIDTH = 8;

    reg                   clk;
    reg                   rst_n;
    reg                   start;
    reg  [1:0]            op_sel;
    reg  [DATA_WIDTH-1:0] operand_a;
    reg  [DATA_WIDTH-1:0] operand_b;
    wire [2*DATA_WIDTH-1:0] result;
    wire                  done;
    wire                  div_by_zero_err;

    control_datapath #(
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .op_sel(op_sel),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .result(result),
        .done(done),
        .div_by_zero_err(div_by_zero_err)
    );

    always #5 clk = ~clk;

    task execute_op(input [1:0] op, input [DATA_WIDTH-1:0] a, input [DATA_WIDTH-1:0] b);
        begin
            @(posedge clk);
            operand_a = a;
            operand_b = b;
            op_sel    = op;
            start     = 1'b1;
            @(posedge clk);
            start     = 1'b0;
           
            wait(done);
            @(posedge clk);
        end
    endtask

    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_control_datapath);

        clk       = 0;
        rst_n     = 0;
        start     = 0;
        op_sel    = 0;
        operand_a = 0;
        operand_b = 0;

        #15 rst_n = 1;
        #10;

        execute_op(2'b00, 8'd15, 8'd25);
        execute_op(2'b01, 8'd50, 8'd18);
        execute_op(2'b10, 8'd12, 8'd9);
        execute_op(2'b11, 8'd100, 8'd4);
        execute_op(2'b11, 8'd50, 8'd0);

        execute_op(2'b00, 8'hFF, 8'hFF);
        execute_op(2'b10, 8'hFF, 8'hFF);
        execute_op(2'b01, 8'hAA, 8'h55);
        execute_op(2'b01, 8'h55, 8'hAA);

        #20;
        $finish;
    end

endmodule
