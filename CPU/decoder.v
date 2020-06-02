module decoder (

	input [15:0] instruction,
	input [1:0] state,

	output alu_input_sel,
	output reg_data1_sel,
	output reg_data2_sel,
	output reg_shift_en,
	output reg_shiftin,

	output ram_instr_addr_sel,
	output ram_data_addr_sel,

	output ir_mux,
	output jump_sel,

	output status_reg_sload,
	output pc_sload,
	output pc_cnt_en,
	output ir_en,

	output ram_wren_instr,
	output ram_wren_data,

	output sm_extra

);

endmodule