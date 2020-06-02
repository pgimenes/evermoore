module Decoder

(

input instruction[15:0];
input state[1:0];
output alu_input_sel, reg_data1_sel, reg_data2_sel, reg_shift_en, reg_shiftin, ram_instr_addr_sel, ram_data_addr_sel, ir_mux, jump_sel, status_reg_sload, pc_sload, pc_cnt_en, ir_en, ram_wren_instr, ram_wren_data, sm_extra, decoder_opcode[5:0]
);

wire fetch, exec1, exec2;

assign fetch = ~state[0]&~state[1];
assign exec1 = ~state[0]&state[1];
assign exec2 = state[0]&~state[1];



wire jmr, car, lsr, asr, inv, twc, inc, dec, ldi, aim, sim, seb, clb ,stb ,lob, add, adc, sub, sbc, gha, ghs, mov, mow, push, load, pop, store, AND, OR, XOR, comp, mul, mls, jmd, call, lda, rtn, stp, clear, sez, clz, sen, cln, sec, clc, set, clt, sev, clv, ses, cls, sei, cli, bru, brd ;

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














assign sm_extra = (lda&exec1)||(adi&exec1)||(sim&exec1) ;













