module tb_sop_4bit;

    reg A, B, C, D;
    wire Y;

    sop_4bit dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .Y(Y)
    );

    initial begin

        // Activate term 1: A'B'C'D
        A=0; B=0; C=0; D=1;
        #10;

        // Activate term 2: A'BC'D
        A=0; B=1; C=0; D=1;
        #10;

        // Activate term 3: AB'CD
        A=1; B=0; C=1; D=1;
        #10;

        // Activate term 4: ABC'D'
        A=1; B=1; C=0; D=0;
        #10;

        $finish;

    end

endmodule
