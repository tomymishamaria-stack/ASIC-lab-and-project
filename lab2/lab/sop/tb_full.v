module tb_sop_4bit_expr;

    reg A;
    reg B;
    reg C;
    reg D;
    wire Y;

    sop_4bit dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );

    initial begin

        // A = 0 cases
        A=0; B=0; C=0; D=0; #10;
        A=0; B=0; C=0; D=1; #10;
        A=0; B=1; C=0; D=0; #10;
        A=0; B=1; C=0; D=1; #10;

        // A = 1 cases
        A=1; B=0; C=0; D=0; #10;
        A=1; B=0; C=1; D=1; #10;
        A=1; B=1; C=0; D=0; #10;
        A=1; B=1; C=1; D=1; #10;

        // Extra toggles for individual condition coverage
        A=0; B=1; C=1; D=1; #10;
        A=1; B=0; C=1; D=0; #10;

        $finish;

    end

endmodule
