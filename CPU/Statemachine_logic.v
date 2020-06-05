module Statemachine_logic (
	input EXTRA, 		//1 for 3 cycle instruction
	input [1:0] Q,		//previous state
	output [1:0] N		//next state
);

	assign N[1] = ~Q[1]&Q[0]&EXTRA;
//	assign N[0] = (~Q[1]&~Q[0])|(~Q[1]&Q[0]&~EXTRA)|(Q[1]&~Q[0]);
	assign N[0] = ~EXTRA | Q[1] | (~Q[1] & ~Q[0]);

endmodule