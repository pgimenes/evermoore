module write_decoder 
(
	input [2:0] add1,
	input [2:0] add2,
	output sel0,
	output sel1,
	output sel2,
	output sel3,
	output sel4,
	output sel5,
	output sel6,
	output sel7
);

assign sel0 = ~add2[2] & ~add2[1] & ~add2[0];
assign sel1 = ~add2[2] & ~add2[1] & add2[0];
assign sel2 = ~add2[2] & add2[1] & ~add2[0];
assign sel3 = ~add2[2] & add2[1] & add2[0];
assign sel4 = add2[2] & ~add2[1] & ~add2[0];
assign sel5 = add2[2] & ~add2[1] & add2[0];
assign sel6 = add2[2] & add2[1] & ~add2[0];
assign sel7 = add2[2] & add2[1] & add2[0];


endmodule