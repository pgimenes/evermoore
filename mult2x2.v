module mult2x2 (
	input [1:0] A,		//multiplier
	input [1:0] B,		//multiplicand
	output [3:0] P 	//product
);
	wire net1;
	
	assign P[0] = A[0] & B[0];
	halfadder U1(.SUM(P[1]),.COUT(net1),.A(A[1]&B[0]),.B(B[1]&A[0]));
	halfadder U2(.SUM(P[2]),.COUT(P[3]),.A(A[1]&B[1]),.B(net1));
	
endmodule