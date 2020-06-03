module extend_address (

	input [11:0] stack_reg,
	output [15:0] stack_addr
	
);

wire z = 0;

assign stack_addr = {z, z, z, z, stack_reg};

endmodule