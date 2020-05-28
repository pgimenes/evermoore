module mult8x8 (
	input [7:0] A,
	input [7:0] B,
	output [15:0] P
);

	wire [7:0] net1;
	wire [7:0] net2;
	wire [7:0] net3;
	wire [7:0] net4;
	
	mult4x4 U1 (.A(A[3:0]),.B(B[3:0]),.P(net1));
	mult4x4 U2 (.A(A[3:0]),.B(B[7:4]),.P(net2));
	mult4x4 U3 (.A(A[7:4]),.B(B[3:0]),.P(net3));
	mult4x4 U4 (.A(A[7:4]),.B(B[7:4]),.P(net4));
	
	assign P[3:0] = net1[3:0];
	
	wire [7:0]net5;
	assign net5[7:0]={{4{1'b0}},net1[7:4]};
	
	wire [8:0]net6;
	
	assign net6 = net5 + net2 + net3;
	
	assign P[7:4] = net6[3:0];
	
	wire [7:0]net7;
	assign net7[7]=0;
	assign net7[6]=0;
	assign net7[5]=0;
	assign net7[4:0]=net6[8:4];
	
	assign P[15:8] = net4 + net7;

endmodule
	