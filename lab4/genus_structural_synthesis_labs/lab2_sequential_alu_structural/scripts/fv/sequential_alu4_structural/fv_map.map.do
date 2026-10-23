
//input ports
add mapped point clk clk -type PI PI
add mapped point rst rst -type PI PI
add mapped point a[3] a[3] -type PI PI
add mapped point a[2] a[2] -type PI PI
add mapped point a[1] a[1] -type PI PI
add mapped point a[0] a[0] -type PI PI
add mapped point b[3] b[3] -type PI PI
add mapped point b[2] b[2] -type PI PI
add mapped point b[1] b[1] -type PI PI
add mapped point b[0] b[0] -type PI PI
add mapped point opcode[1] opcode[1] -type PI PI
add mapped point opcode[0] opcode[0] -type PI PI

//output ports
add mapped point result[3] result[3] -type PO PO
add mapped point result[2] result[2] -type PO PO
add mapped point result[1] result[1] -type PO PO
add mapped point result[0] result[0] -type PO PO
add mapped point carry carry -type PO PO

//inout ports




//Sequential Pins
add mapped point q0/q/q q0/q_reg/Q -type DFF DFF
add mapped point q1/q/q q1/q_reg/Q -type DFF DFF
add mapped point q2/q/q q2/q_reg/Q -type DFF DFF
add mapped point q3/q/q q3/q_reg/Q -type DFF DFF
add mapped point qc/q/q qc/q_reg/Q -type DFF DFF



//Black Boxes



//Empty Modules as Blackboxes
