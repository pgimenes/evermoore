module carrysave4bit (
	input [3:0] A,
	input [3:0] B,
	input [3:0] C,
	output [5:0] SUM
);

wire net1, net2, net3, net4, net5, net6, net7, c1, c2, c3;
	
	fulladder U1 (.A(A[0]),.B(B[0]),.CIN(C[0]),.SUM(SUM[0]),.COUT(net1));
	fulladder U2 (.A(A[1]),.B(B[1]),.CIN(C[1]),.SUM(net2),.COUT(net3));
	fulladder U3 (.A(A[2]),.B(B[2]),.CIN(C[2]),.SUM(net4),.COUT(net5));
	fulladder U4 (.A(A[3]),.B(B[3]),.CIN(C[3]),.SUM(net6),.COUT(net7));
	
	halfadder U5 (.A(net1),.B(net2),.SUM(SUM[1]),.COUT(c1));
	fulladder U6 (.A(net3),.B(net4),.CIN(c1),.SUM(SUM[2]),.COUT(c2));
	fulladder U7 (.A(net5),.B(net6),.CIN(c2),.SUM(SUM[3]),.COUT(c3));
	halfadder U8 (.A(net7),.B(c3),.SUM(SUM[4]),.COUT(SUM[5]));

endmodule	