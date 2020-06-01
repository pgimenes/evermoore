module mult16x16 (
	input [15:0] A,
	input [15:0] B,
	output [31:0] P
);

	wire [15:0] net1;
	wire [15:0] net2;
	wire [15:0] net3;
	wire [15:0] net4;
	
	mult8x8 U1 (.A(A[7:0]),.B(B[7:0]),.P(net1));
	mult8x8 U2 (.A(A[7:0]),.B(B[15:8]),.P(net2));
	mult8x8 U3 (.A(A[15:8]),.B(B[7:0]),.P(net3));
	mult8x8 U4 (.A(A[15:8]),.B(B[15:8]),.P(net4));
	
	assign P[7:0] = net1[7:0];
	
	wire [15:0]net5;
	assign net5[15:0]={{8{1'b0}},net1[15:8]};
	
	wire [16:0]net6;
	
	assign net6 = net5 + net2 + net3;
	
	assign P[15:8] = net6[7:0];
	
	wire [15:0]net7;
	assign net7[15:0]={{7{1'b0}},net6[16:8]};
	
	assign P[31:16] = net4 + net7;

endmodule
	