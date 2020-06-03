module Decoder

(

input [15:0] instruction,
input [1:0] state,
output [5:0] encoded_opcode,
output alu_input_sel, reg_data1_sel, reg_data2_sel, reg_shift_en, reg_shiftin, ram_instr_addr_sel, ram_data_addr_sel, ir_mux, jump_sel, status_reg_sload, pc_sload, pc_cnt_en, ir_en, ram_wren_instr, ram_wren_data, sm_extra
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
  
assign decoder_opcode[0] = jmi|car|asr|twc|dec|aim|seb|stb|add|sub|gha|mov|push|pop|AND|XOR|mul|jmd|lda|stp|sez|sen|sec|set|sev|ses|sei|bru ;
assign decoder_opcode[1] = jeq|car|inv|twc|ldi|aim|clb|stb|adc|sub|ghs|mov|load|pop|OR|XOR|mls|jmd|rtn|stp|clz|sen|clc|set|clv|ses|cli|bru ;
assign decoder_opcode[2] = lsr|asr|inv|twc|sim|seb|clb|stb|sbc|gha|ghs|mov|store|AND|OR|XOR|call|lda|rtn|stp|cln|sec|clc|set|cls|sei|cli|bru ;
assign decoder_opcode[3] = inc|dec|ldi|aim|sim|seb|clb|stb|mow|push|load|pop|store|AND|OR|XOR|clear|sez|clz|sen|cln|sec|clc|set|brd ;
assign decoder_opcode[4] = lob|add|adc|sub|sbc|gha|ghs|mov|mow|push|load|pop|store|AND|OR|XOR|clt|sev|clv|ses|cls|sei|cli|bru|brd ;
assign decoder_opcode[5] = comp|mul|mls|jmd|call|lda|rtn|stp|clear|sez|clz|sen|cln|sec|clc|set|clt|sev|clv|ses|cls|sei|cli|bru|brd ;

assign sm_extra = (lda&exec1)||(aim&exec1)||(sim&exec1) ;

endmodule
