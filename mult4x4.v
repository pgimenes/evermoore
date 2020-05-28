module mult4x4 (
	input [3:0] A,
	input [3:0] B,
	output [7:0] P
);
	wire [3:0] net1;
	wire [3:0] net2;
	wire [3:0] net3;
	wire [3:0] net4;
	
	mult2x2 U1 (.A(A[1:0]),.B(B[1:0]),.P(net1));
	mult2x2 U2 (.A(A[1:0]),.B(B[3:2]),.P(net2));
	mult2x2 U3 (.A(A[3:2]),.B(B[1:0]),.P(net3));
	mult2x2 U4 (.A(A[3:2]),.B(B[3:2]),.P(net4));
	
	assign P[1:0] = net1[1:0];
	
	wire [3:0] net5;
	assign net5[1:0] = net1[3:2];
	assign net5[2] = 0;
	assign net5[3] = 0;
	wire [5:0] net6;
	
	carrysave4bit U5 (.A(net2),.B(net3),.C(net5),.SUM(net6));
	
	assign P[3:2] = net6[1:0];
	
	wire [3:0] net7 = {net6[5:2]};
	
	ripple4bit U6(.A(net7),.B(net4),.SUM(P[7:4]));
	
endmodule	