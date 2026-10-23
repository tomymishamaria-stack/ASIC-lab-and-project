`timescale 1ns/1ps

module tb_alu_expr;

    // Testbench signals
    logic [7:0] A, B, C, D;
    logic signed [10:0] Y;

    // Instantiate the DUT (Device Under Test)
    alu_expr dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );

    // Expected value calculation for self-checking
    logic signed [11:0] expected_Y;
    assign expected_Y = $signed({3'b0, A}) + 
                        $signed({3'b0, B}) + 
                        $signed({3'b0, C}) - 
                        $signed({3'b0, D});

    initial begin
        // Monitor outputs
        $display("Time\t A\t B\t C\t D\t Y (DUT)\t Expected");
        $monitor("%0t\t %0d\t %0d\t %0d\t %0d\t %0d\t\t %0d", 
                 $time, A, B, C, D, Y, expected_Y);

        // Test Case 1: Standard small numbers
        A = 8'd10; B = 8'd20; C = 8'd30; D = 8'd5;
        #10;
        assert (Y == expected_Y) else $error("Mismatch! Y=%0d, Expected=%0d", Y, expected_Y);

        // Test Case 2: All zeros
        A = 8'd0; B = 8'd0; C = 8'd0; D = 8'd0;
        #10;
        assert (Y == expected_Y) else $error("Mismatch! Y=%0d, Expected=%0d", Y, expected_Y);

        // Test Case 3: Result goes negative
        A = 8'd10; B = 8'd10; C = 8'd10; D = 8'd100;
        #10;
        assert (Y == expected_Y) else $error("Mismatch! Y=%0d, Expected=%0d", Y, expected_Y);

        // Test Case 4: Maximum possible values (765)
        A = 8'd255; B = 8'd255; C = 8'd255; D = 8'd0;
        #10;
        assert (Y == expected_Y) else $error("Mismatch! Y=%0d, Expected=%0d", Y, expected_Y);

        // Test Case 5: Random inputs check
        repeat (10) begin
            A = $urandom_range(0, 255);
            B = $urandom_range(0, 255);
            C = $urandom_range(0, 255);
            D = $urandom_range(0, 255);
            #10;
            assert (Y == expected_Y) else $error("Mismatch! A=%0d B=%0d C=%0d D=%0d Y=%0d Expected=%0d", A, B, C, D, Y, expected_Y);
        end

        $display("All tests passed successfully!");
        $finish;
    end

endmodule
