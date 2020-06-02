module extend_address (

	input [11:0] stack_reg,
	output [15:0] stack_addr
	
);

assign stack_addr = {0, 0, 0, 0, stack_reg};

endmodule