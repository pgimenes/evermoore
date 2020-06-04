module reg_enable_logic (
	input port1,
	input port2,
	input write1en,
	input write2en,
	
	output enable
);

wire either_port = port1 & ~port2 | ~port1 & port2;
assign enable = either_port & (write1en | write2en);

endmodule