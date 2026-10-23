module tb_full_adder_max;

    reg  a, b, cin;
    wire sum, cout;

    // DUT
    full_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .sum(sum),
        .cout(cout)
    );

    initial begin
        // Case 1
        {a, b, cin} = 3'b000;
        #10;

        // Case 2
        {a, b, cin} = 3'b111;
        #10;

        // Case 3
        {a, b, cin} = 3'b000;
        #10;

        $finish;
    end

endmodule
