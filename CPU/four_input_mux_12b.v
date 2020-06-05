module four_input_mux_12b (

	input [11:0] a,
	input [11:0] b,
	input [11:0] c,
	input [11:0] d,
	input [1:0] sel,
	output [11:0] out
);

assign out = (sel == 2'b00) ? a
					: (sel == 2'b01) ? b
					: (sel == 2'b10) ? c : d;

endmodule