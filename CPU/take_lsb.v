module take_lsb (

	input [15:0] input_bus,
	output [11:0] output_bus

);

assign output_bus = input_bus[11:0];

endmodule