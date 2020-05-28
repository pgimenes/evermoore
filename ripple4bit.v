module ripple4bit(
	input [3:0] A,
	input [3:0] B,
	output [3:0] SUM
);
	wire c1, c2, c3, c4;
	
	halfadder U1(.A(A[0]),.B(B[0]),.SUM(SUM[0]),.COUT(c1));
	fulladder U2(.A(A[1]),.B(B[1]),.CIN(c1),.SUM(SUM[1]),.COUT(c2));
	fulladder U3(.A(A[2]),.B(B[3]),.CIN(c2),.SUM(SUM[2]),.COUT(c3));
	fulladder U4(.A(A[3]),.B(B[3]),.CIN(c3),.SUM(SUM[3]),.COUT(c4));
	
endmodule