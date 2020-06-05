module reg_enable_logic (
	input port1,
	input port2,
	input write1en,
	input write2en,
	
	output enable
);

assign enable = port1&write1en | port2&write2en;

endmodule