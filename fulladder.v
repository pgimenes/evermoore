module fulladder (
	input A,
	input B,
	input CIN,
	output SUM,
	output COUT
);
	assign SUM = ((~A)&(~B)&CIN) + ((~A)&B&(~CIN)) + (A&(~B)&(~CIN)) + (A&B&CIN);
	assign COUT = A&B + B&CIN + CIN&A;
endmodule