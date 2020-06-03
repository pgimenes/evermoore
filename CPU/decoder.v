module decoder

(

	input [15:0] instruction,
	input [1:0] state,
	input stack_overflow,
	
	output [5:0] encoded_opcode,
	
	output alu_input_sel,
	output status_reg_sload,
	output stack_reg_increment,
	output stack_reg_load,
	output stack_reg_restart,
	
	output [2:0] reg_write_address,
	output [2:0] reg_read_address,
	output [1:0] regf_data1_sel,
	output regf_data2_sel,
	output reg_shift_en,
	output reg_shiftin,
	output reg_clear,
	
	output ram_instr_addr_sel,
	output [1:0] ram_data_addr_sel,
	output ram_wren_instr,
	output ram_wren_data,
	
	output exec1,
	output jump_sel,
	output pc_sload,
	output pc_cnt_en,
	output ir_en,
	
	output sm_extra,
	
	output aim,
	output sim,
	output stop,
	output clock
);

// STATE MACHINE WIRES
wire fetch, exec2;

assign fetch = ~state[0]&~state[1];
assign exec1 = ~state[0]&state[1];
assign exec2 = state[0]&~state[1];

// CONDITION
reg [3:0] cond_field = 

// INSTRUCTION IDENTIFIERS
// SIMPLER WAY TO DECODE?
wire jmr, car, lsr, asr, inv, twc, inc, dec, ldi, seb, clb ,stb ,lob, add, adc, sub, sbc, gha, ghs, mov, mow, push, load, pop, store, AND, OR, XOR, comp,
mul, mls, jmd, call, lda, rtn, stp, clear, sez, clz, sen, cln, sec, clc, set, clt, sev, clv, ses, cls, sei, cli, bru, brd ;

assign lda 	= instruction[15]&instruction[14]&instruction[13]&~instruction[12];
assign call = instruction[15]&instruction[14]&~instruction[13]&instruction[12];
assign jmd 	= instruction[15]&instruction[14]&~instruction[13]&~instruction[12];

assign rtn 	= instruction[15]&instruction[14]&instruction[13]&instruction[12]&~instruction[11]&&~instruction[10]&~instruction[9]&&~instruction[8]&~instruction[7]&&~instruction[6]&~instruction[5]&&~instruction[4];
assign stp 	= instruction[15]&instruction[14]&instruction[13]&instruction[12]&~instruction[11]&&~instruction[10]&~instruction[9]&&~instruction[8]&~instruction[7]&&~instruction[6]&~instruction[5]&&instruction[4];


assign inc 	= ~instruction[15]&~instruction[14]&~instruction[13]&~instruction[12]&~instruction[11]&instruction[10]&~instruction[9]&~instruction[8]&~instruction[7];
assign jmr 	= ~instruction[15]&~instruction[14]&~instruction[13]&~instruction[12]&~instruction[11]&~instruction[10]&~instruction[9]&~instruction[8]&~instruction[7];
assign dec 	= ~instruction[15]&~instruction[14]&~instruction[13]&~instruction[12]&~instruction[11]&instruction[10]&~instruction[9]&~instruction[8]&instruction[7];
assign sim 	= ~instruction[15]&~instruction[14]&~instruction[13]&~instruction[12]&~instruction[11]&instruction[10]&instruction[9]&~instruction[8]&~instruction[7];

assign mov 	= ~instruction[15]&instruction[14]&~instruction[13]&instruction[12]&instruction[11]&~instruction[10];
assign add 	= ~instruction[15]&instruction[14]&~instruction[13]&~instruction[12]&~instruction[11]&~instruction[10];
assign sub 	= ~instruction[15]&instruction[14]&~instruction[13]&~instruction[12]&instruction[11]&~instruction[10];
assign push = ~instruction[15]&instruction[14]&instruction[13]&~instruction[12]&~instruction[11]&~instruction[10];
assign pop 	= ~instruction[15]&instruction[14]&instruction[13]&~instruction[12]&instruction[11]&~instruction[10];
assign store= ~instruction[15]&instruction[14]&instruction[13]&~instruction[12]&instruction[11]&instruction[10];

assign mul 	= instruction[15]&~instruction[14]&~instruction[13];
  
assign encoded_opcode[0] = car|asr|twc|dec|aim|seb|stb|add|sub|gha|mov|push|pop|AND|XOR|mul|jmd|lda|stp|sez|sen|sec|set|sev|ses|sei|bru ;
assign encoded_opcode[1] = car|inv|twc|ldi|aim|clb|stb|adc|sub|ghs|mov|load|pop|OR|XOR|mls|jmd|rtn|stp|clz|sen|clc|set|clv|ses|cli|bru ;
assign encoded_opcode[2] = lsr|asr|inv|twc|sim|seb|clb|stb|sbc|gha|ghs|mov|store|AND|OR|XOR|call|lda|rtn|stp|cln|sec|clc|set|cls|sei|cli|bru ;
assign encoded_opcode[3] = inc|dec|ldi|aim|sim|seb|clb|stb|mow|push|load|pop|store|AND|OR|XOR|clear|sez|clz|sen|cln|sec|clc|set|brd ;
assign encoded_opcode[4] = lob|add|adc|sub|sbc|gha|ghs|mov|mow|push|load|pop|store|AND|OR|XOR|clt|sev|clv|ses|cls|sei|cli|bru|brd ;
assign encoded_opcode[5] = comp|mul|mls|jmd|call|lda|rtn|stp|clear|sez|clz|sen|cln|sec|clc|set|clt|sev|clv|ses|cls|sei|cli|bru|brd ;

// CONTROL SIGNALS
	
	assign alu_input_sel,
	assign status_reg_sload,
	assign stack_reg_increment,
	assign stack_reg_load,
	assign stack_reg_restart,
	
	assign reg_write_address = 
	
	assign reg_read_address = 
	
	assign regf_data1_sel [2] = 
	assign regf_data1_sel [1] = 
	assign regf_data1_sel [0] = 

	assign regf_data2_sel,
	assign reg_shift_en = exec1 & (asr | lsr);
	assign reg_shiftin = exec1 & asr; // CHANGE THIS
	assign reg_clear = exec1 & (clear | stop);
	
	assign ram_instr_addr_sel = exec1 & (jmr | jmd);
	assign ram_data_addr_sel [0] = exec1 & call;
	assign ram_data_addr_sel [1] = exec1 & rtn;
	
	assign ram_wren_data = exec1 & (store | push | call | car);
	
	assign jump_sel [0] = exec1 & (jmd | call);
	assign jump_sel [1] = exec1 & (rtn);
	
	assign pc_sload = exec1 & (jmd | jmr | call | car | rtn);
	assign pc_cnt_en = fetch | exec1 | (exec2 & (aim | sim | ldi));
	assign ir_en = exec1 & sm_extra;
	
	assign sm_extra = exec1 & (ldi | aim | sim | load | pop);
	
	assign stop = (stp & exec1) | stack_overflow;
	assign clock = mul & exec1;

endmodule
