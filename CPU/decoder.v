module decoder

(

	input [15:0] instruction,
	input [1:0] state,
	input [7:0] status_reg,
	input stack_overflow,
	input jump,
	
	output [5:0] encoded_opcode,
	
	output alu_input1_sel,
	output alu_input2_sel,
	output status_reg_sload,
	output stack_reg_increment,
	output stack_dec_sel,
	output stack_reg_load,
	output stack_reg_restart,
	
	// REG FILE INPUT
	output [2:0] reg_write_addr1,
	output [2:0] reg_read_addr1,
	output [2:0] reg_read_addr2,
	output read_addr_sel,
	
	output [1:0] regf_data1_sel,
	output regf_data2_sel,
	output write1_en,
	output write2_en,
	output reg_shift_en,
	output reg_shiftin,
	output reg_clear,
	
	
	output [1:0] ram_instr_addr_sel,
	output [1:0] ram_data_addr_sel,
	output ram_data_input_sel,
	output ram_wren_data,
	
	// CONTROL PATH
	output exec1,
	output pc_sload,
	output pc_cnt_en,
	
	output sm_extra,
	
	output stop,
	output clock,
	output set_jump
);

// STATE MACHINE WIRES
wire fetch, exec2;
assign fetch = ~state[0]&~state[1];
assign exec1 = state[0]&~state[1];
assign exec2 = ~state[0]&state[1];

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
wire jmr = instruction[15:7] == 9'b000000000;
wire asc = instruction[15:7] == 9'b000000001;
wire car = instruction[15:7] == 9'b000000011;
wire lsr = instruction[15:7] == 9'b000000100;
wire asr = instruction[15:7] == 9'b000000101;
wire inv = instruction[15:7] == 9'b000000110;
wire twc = instruction[15:7] == 9'b000000111;
wire inc = instruction[15:7] == 9'b000001000;
wire dec = instruction[15:7] == 9'b000001001;
wire ldi = instruction[15:7] == 9'b000001010;

wire aim = instruction[15:7] == 9'b000001011;
wire sim = instruction[15:7] == 9'b000001100;

wire seb = instruction[15:11] == 5'b00100;
wire clb = instruction[15:11] == 5'b00101;
wire stb = instruction[15:11] == 5'b00110;
wire lob = instruction[15:11] == 5'b00111;

wire add = instruction[15:10] == 6'b010000;
wire adc = instruction[15:10] == 6'b010001;
wire sub = instruction[15:10] == 6'b010010;
wire sbc = instruction[15:10] == 6'b010011;
wire gha = instruction[15:10] == 6'b010100;
wire ghs = instruction[15:10] == 6'b010101;
wire mov = instruction[15:10] == 6'b010110;
wire mow = instruction[15:10] == 6'b010111;
wire push = instruction[15:10] == 6'b011000;
wire load = instruction[15:10] == 6'b011001;
wire pop = instruction[15:10] == 6'b011010;
wire store = instruction[15:10] == 6'b011011;
wire AND = instruction[15:10] == 6'b011100;
wire OR = instruction[15:10] == 6'b011101;
wire XOR = instruction[15:10] == 6'b011110;
wire comp = instruction[15:10] == 6'b011111;

wire mul = instruction[15:13] == 3'b100;
wire mls = instruction[15:13] == 3'b101;

wire jmd = instruction[15:12] == 4'b1100;
wire call = instruction[15:12] == 4'b1101;
wire lda = instruction[15:12] == 4'b1110;

wire rtn = instruction[15:4] == 12'b111100000000;
wire stp = instruction[15:4] == 12'b111100000001;
wire clear = instruction[15:4] == 12'b111100000010;
wire sez = instruction[15:4] == 12'b111100000011;
wire clz = instruction[15:4] == 12'b111100000100;
wire sen = instruction[15:4] == 12'b111100000101;
wire cln = instruction[15:4] == 12'b111100000110;
wire sec = instruction[15:4] == 12'b111100000111;
wire clc = instruction[15:4] == 12'b111100001000;
wire set = instruction[15:4] == 12'b111100001001;
wire clt = instruction[15:4] == 12'b111100001010;
wire sev = instruction[15:4] == 12'b111100001011;
wire clv = instruction[15:4] == 12'b111100001100;
wire ses = instruction[15:4] == 12'b111100001101;
wire cls = instruction[15:4] == 12'b111100001110;
wire sei = instruction[15:4] == 12'b111100001111;
wire cli = instruction[15:4] == 12'b111100010000;

wire bru = instruction[15:7] == 9'b111110000;
wire brd = instruction[15:7] == 9'b111110001;
  
assign encoded_opcode[0] = asc|car|asr|twc|dec|aim|seb|stb|add|sub|gha|mov|push|pop|AND|XOR|mul|jmd|lda|stp|sez|sen|sec|set|sev|ses|sei|bru ;
assign encoded_opcode[1] = car|inv|twc|ldi|aim|clb|stb|adc|sub|ghs|mov|load|pop|OR|XOR|mls|jmd|rtn|stp|clz|sen|clc|set|clv|ses|cli|bru ;
assign encoded_opcode[2] = lsr|asr|inv|twc|sim|seb|clb|stb|sbc|gha|ghs|mov|store|AND|OR|XOR|call|lda|rtn|stp|cln|sec|clc|set|cls|sei|cli|bru ;
assign encoded_opcode[3] = inc|dec|ldi|aim|sim|seb|clb|stb|mow|push|load|pop|store|AND|OR|XOR|clear|sez|clz|sen|cln|sec|clc|set|brd ;
assign encoded_opcode[4] = lob|add|adc|sub|sbc|gha|ghs|mov|mow|push|load|pop|store|AND|OR|XOR|clt|sev|clv|ses|cls|sei|cli|bru|brd ;
assign encoded_opcode[5] = comp|mul|mls|jmd|call|lda|rtn|stp|clear|sez|clz|sen|cln|sec|clc|set|clt|sev|clv|ses|cls|sei|cli|bru|brd ;

// CONTROL SIGNALS
	assign alu_input1_sel = exec2 & (load | pop | rtn);
	assign alu_input2_sel = exec2 & (ldi | aim | sim);
	
	assign status_reg_sload = exec1 & ~(gha | ghs);
	assign stack_reg_increment = exec1 & (call | car);
	assign stack_dec_sel = exec1 & pop;
	assign stack_reg_load = exec1 & rtn;
	assign stack_reg_restart = fetch | stop;
	
	assign reg_write_addr1 = single_reg ? instruction [2:0]
									: single_reg_ba ? instruction [6:4]
									: double_reg & pop & exec1 ? instruction [2:0] // Rs for decrementing the stack address
									: double_reg & ~(pop & exec1) ? instruction[5:3]
									: triple_reg ? instruction [8:6] : 3'b000; // default is 000 for LDA (R0)
	
	assign reg_read_addr1 = single_reg ? instruction [2:0]
									: single_reg_ba ? instruction [6:4]
									: double_reg ? instruction [2:0] // Rs
									: triple_reg ? instruction [2:0] : 3'b000; // default is 000 for LDA (R0)
	
	assign reg_read_addr2 = double_reg ? instruction [5:3] : instruction [5:3]; // default is triple_reg
	
	assign read_addr_sel = mow;
 
 	assign regf_data1_sel [1] = mov | mow | exec2 & (pop | load);
	assign regf_data1_sel [0] = ~(lsr | asr | mov | mow | lda);
	
	assign regf_data2_sel = mul;
	
	assign write1_en = cond_evaluated & ~fetch & ~(lsr | asr | jmr | car | stb | lob | store | jmd | call | comp | rtn | control_ops | control_ops_offset | (exec1 & (load | aim | sim | ldi | mul)) ); // enable might have to be low for clear instruction
	assign write2_en = cond_evaluated & (mow | mul & exec2) & ~ (fetch | asr | lsr); // maybe high for exec2?
	
	assign reg_shift_en = exec1 & (asr | lsr);
	assign reg_shiftin = exec1 & asr; // & MSB
	assign reg_clear = exec1 & (clear | stop) & cond_evaluated;
	
	assign ram_instr_addr_sel [1] = ( (rtn & ~fetch) | ( exec1 & (jmr | car) ) ) & cond_evaluated;  
	assign ram_instr_addr_sel [0] = ( (rtn & ~fetch) | (exec1 & (jmd | call)) ) & cond_evaluated;
	
	assign ram_data_addr_sel [1] = exec1 & (rtn | push | pop);
	assign ram_data_addr_sel [0] = exec1 & (call|car|push);
	
	assign ram_data_input_sel = exec1 & (call | car);
	
	assign ram_wren_data = exec1 & (store | push | call | car) & cond_evaluated;
	
	wire three_cycle = (ldi | aim | sim | load | pop |rtn | mul | mls);
	assign pc_sload = cond_evaluated & ( (exec1 & (jmd | jmr | call | car) ) | (exec2 & rtn) );
	assign pc_cnt_en = fetch | (exec1 & ~(load | pop | rtn | mul | mls)) | exec2 & three_cycle;
	
	assign sm_extra = exec1 & (ldi | aim | sim | load | pop | rtn | mul);
	
	assign stop = (stp & exec1) | stack_overflow & cond_evaluated;
	assign clock = mul & exec1;
	assign set_jump = exec1 & (call | car | jmr | jmd ) | exec2 & rtn;

endmodule



