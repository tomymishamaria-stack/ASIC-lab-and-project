module seq_101(
    input  clk,
    input  rst,
    input  x,
    output reg y
);

    // State declaration
    parameter S0 = 2'b00;   // No bit detected
    parameter S1 = 2'b01;   // Detected '1'
    parameter S2 = 2'b10;   // Detected '10'

    reg [1:0] state, next_state;

    // State memory
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else
            state <= next_state;
    end


    // Next state logic
    always @(*) begin
        case(state)

            S0: begin
                if (x)
                    next_state = S1;
                else
                    next_state = S0;
            end


            S1: begin
                if (x)
                    next_state = S1;   // Still have '1'
                else
                    next_state = S2;   // Got '10'
            end


            S2: begin
                if (x)
                    next_state = S1;   // Overlap: detected 101, keep last 1
                else
                    next_state = S0;
            end


            default:
                next_state = S0;

        endcase
    end


    // Mealy output logic
    always @(*) begin
        if ((state == S2) && (x == 1'b1))
            y = 1'b1;     // Sequence 101 detected
        else
            y = 1'b0;
    end

endmodule
