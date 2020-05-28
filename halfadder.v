module halfadder (A,B,SUM,COUT);
	
	input A,B;
	output SUM,COUT;
	
	assign SUM = (~A&B) + (A&~B);
	assign COUT = A&B;

endmodule