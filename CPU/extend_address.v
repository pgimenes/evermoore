module extend_address (

	input [11:0] address_input,
	output [15:0] extended_addr
	
);

wire z = 0;

assign extended_addr = {z, z, z, z, address_input};

endmodule