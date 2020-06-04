module decoder

(

	input [15:0] instruction,
	input [1:0] state,
	input [7:0] status_reg,
	input stack_overflow,
	
	output [5:0] encoded_opcode,
	
	output alu_input_sel,
	output status_reg_sload,
	output stack_reg_increment,
	output stack_reg_load,
	output stack_reg_restart,
	
	// REG FILE INPUT
	output [2:0] reg_write_addr1,
	output [2:0] reg_write_addr2,
	output [2:0] reg_read_addr1,
	output [2:0] reg_read_addr2,
	output write_addr_sel,
	output read_addr_sel,
	
	output [1:0] regf_data1_sel,
	output regf_data2_sel,
	output write1_en,
	output write2_en,
	output reg_shift_en,
	output reg_shiftin,
	output reg_clear,
	
	
	output ram_instr_addr_sel,
	output [1:0] ram_data_addr_sel,
	output ram_wren_instr,
	output ram_wren_data,
	
	// CONTROL PATH
	output exec1,
	output [1:0] jump_sel,
	output pc_sload,
	output pc_cnt_en,
	
	output sm_extra,
	
	output stop,
	output clock
);

// STATE MACHINE WIRES
wire fetch, exec2;
assign fetch = ~state[0]&~state[1];
assign exec1 = ~state[0]&state[1];
assign exec2 = state[0]&~state[1];

// ADDRESSING MODES
wire single_reg = instruction [15:13] == 3'b000;
wire single_reg_ba = instruction [15:13] == 3'b001;
wire double_reg = instruction [15:14] == 2'b01;
wire triple_reg = instruction [15:14] == 2'b10;
wire direct_add = instruction [15:14] == 2'b11;
wire control_ops = instruction [15:11] == 5'b11110;
wire control_ops_offset = instruction [15:11] == 5'b11111;

// COND FIELD
wire [3:0] cond_field;
assign cond_field[0] =  (single_reg&instruction[3])|(single_reg_ba&instruction[7])|(double_reg&instruction[6])|(triple_reg&instruction[9])|(direct_add& 0)|control_ops&instruction[0]|control_ops_offset&instruction[3];
assign cond_field[1] = 	(single_reg&instruction[4])|(single_reg_ba&instruction[8])|(double_reg&instruction[7])|(triple_reg&instruction[10])|(direct_add& 1)|control_ops&instruction[1]|control_ops_offset&instruction[4];
assign cond_field[2] = 	(single_reg&instruction[5])|(single_reg_ba&instruction[9])|(double_reg&instruction[8])|(triple_reg&instruction[11])|(direct_add& 1)|control_ops&instruction[2]|control_ops_offset&instruction[5];
assign cond_field[3] =	(single_reg&instruction[6])|(single_reg_ba&instruction[10])|(double_reg&instruction[9])|(triple_reg&instruction[12])|(direct_add& 0)|control_ops&instruction[3]|control_ops_offset&instruction[6];

reg cond_evaluated;

always @(*) begin
	case (cond_field)
		4'b0000: cond_evaluated = status_reg[0];
		4'b0001: cond_evaluated = status_reg[1];
		4'b0010:	cond_evaluated = status_reg[2];
		4'b0011: cond_evaluated = status_reg[3];
		4'b0100: cond_evaluated = status_reg[4];
		4'b0101: cond_evaluated = status_reg[5];
		4'b0110: cond_evaluated = 1; // ALWAYS
		4'b0111: cond_evaluated = status_reg[7];
		4'b1000: cond_evaluated = ~status_reg[0];
		4'b1001: cond_evaluated = ~status_reg[1];
		4'b1010: cond_evaluated = ~status_reg[2];
		4'b1011: cond_evaluated = ~status_reg[3];
		4'b1100: cond_evaluated = ~status_reg[4];
		4'b1101: cond_evaluated = ~status_reg[5];
		// 4'b1110: cond_evaluated = ~status_reg[6]; // INVALID
		4'b1111: cond_evaluated = ~status_reg[7];
		default : cond_evaluated = 1;
	endcase
end	

// INSTRUCTION IDENTIFIERS
// SIMPLER WAY TO DECODE?
wire jmr, car, lsr, asr, inv, twc, inc, dec, ldi, aim, sim, seb, clb ,stb ,lob, add, adc, sub, sbc, gha, ghs, mov, mow, push, load, pop, store, AND, OR, XOR, comp,
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
	
	assign alu_input_sel = exec1 & (aim | sim);
	assign status_reg_sload = exec1 & ~(gha | ghs);
	assign stack_reg_increment = exec1 & (call | car);
	assign stack_reg_load = exec1 & rtn;
	assign stack_reg_restart = fetch | stop;
	
	assign reg_write_addr1 = single_reg ? instruction [2:0] : 0;
	assign reg_write_addr2 = single_reg ? instruction [2:0] : 0;
	
//	assign reg_read_addr1 = 
//	assign reg_read_addr2 = 
	
	assign write_addr_sel = exec2 & pop;
	assign read_addr_sel = mow;
 
	assign regf_data1_sel [0] = ~(lsr | asr | mov | mow | lda);
	assign regf_data1_sel [1] = mov | mow | exec2 & (pop | load | ldi);
	
	assign regf_data2_sel = mul;
	
	assign write1_en = cond_evaluated & ~(jmr | car | stb | lob | store | jmd | call | comp | rtn | control_ops | control_ops_offset | (exec1 & (load | aim | sim | ldi)) ); // enable might have to be low for clear instruction
	assign write2_en = cond_evaluated & (mow | mul);
	assign reg_shift_en = exec1 & (asr | lsr);
	assign reg_shiftin = exec1 & asr; // & MSB
	assign reg_clear = exec1 & (clear | stop) & cond_evaluated;
	
	assign ram_instr_addr_sel = exec1 & (jmr | jmd);
	assign ram_data_addr_sel [0] = exec1 & call;
	assign ram_data_addr_sel [1] = exec1 & rtn;
	
	assign ram_wren_data = exec1 & (store | push | call | car) & cond_evaluated;
	
	assign jump_sel [0] = exec1 & (jmd | call);
	assign jump_sel [1] = exec1 & (rtn);
	
	assign pc_sload = exec1 & (jmd | jmr | call | car | rtn) & cond_evaluated;
	assign pc_cnt_en = fetch | exec1 | (exec2 & (aim | sim | ldi));
	
	assign sm_extra = exec1 & (ldi | aim | sim | load | pop);
	
	assign stop = (stp & exec1) | stack_overflow & cond_evaluated;
	assign clock = mul & exec1;

endmodule



