module alu (

	input [15:0] instruction, 			// from IR'
	input [5:0] encoded_opcode,
	input [11:0] stack_reg,
	
	input [15:0] rs1data, 				// Rs register data outputs
	input [15:0] rs2data, 				// 2nd Rs register data output

	input [7:0] statusregin,			//input of status reg

	input [2:0] reg_write_addr,
	input [2:0] reg_read_addr,
	
	input CLOCK,

	output [15:0] aluout1, 
	output [15:0] aluout2,				// used only for MULT
	output [2:0] incremented_write_addr,
	output [2:0] incremented_read_addr,
	output [7:0] statusregout, 		// output of status reg
	output [11:0] decremented_stack_reg
);

wire [31:0] thirtytwooutput;	

mult16x16 calc(
	.CLOCK(CLOCK),
	.enable (encoded_opcode == 6'b100001),
	.A (rs1data[15:0]),
	.B (rs2data[15:0]),
	.P (thirtytwooutput[31:0])
);

// 
reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
wire cin; // The ALU carry input, determined from instruction as in ISA spec
wire alucout;                  // alu carry output
wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
assign cin = statusregin[2];

assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
assign aluout1 = (encoded_opcode == 6'b100001 || encoded_opcode == 6'b100010) ? thirtytwooutput[15:0] :
						alusum [15:0]; // 16 normal bits from sum
assign aluout2 = thirtytwooutput[31:16] ;   // 16 normal bits from sum

// SETTING STATUS REGISTER
wire eqzero = encoded_opcode == 6'b100001 ? &(~thirtytwooutput) : &(~alusum);
wire neg = encoded_opcode == 6'b100001 ? thirtytwooutput[31] : alusum[15];
wire twc_overflow; // COMPLETE THIS
wire sign_flag = neg & ~twc_overflow | ~neg & twc_overflow;

//decide if to use control instr output to status reg or to use the normal procedures
reg [7:0] statusregintermediate;
assign statusregout = (encoded_opcode == 6'b101001||encoded_opcode == 6'b101010||encoded_opcode == 6'b101011||encoded_opcode == 6'b101100||encoded_opcode == 6'b101101||encoded_opcode == 6'b101110||encoded_opcode == 6'b101111||encoded_opcode == 6'b110000||encoded_opcode == 6'b110001||encoded_opcode == 6'b110010||encoded_opcode == 6'b110011||encoded_opcode == 6'b110100||encoded_opcode == 6'b110101||encoded_opcode == 6'b110110) ? statusregintermediate : // control ops with offset
           ( (encoded_opcode == 6'b010101) || (encoded_opcode == 6'b010110) || (encoded_opcode == 6'b100011) || (encoded_opcode == 6'b000000) || (encoded_opcode == 6'b100100) || (encoded_opcode == 6'b000011) || (encoded_opcode == 6'b100110) || (encoded_opcode == 6'b110111) || (encoded_opcode == 6'b111000) ) ? statusregin : // GHOST INSTRUCTIONS: ADD/SUB, JMD, JMR, CALL, CAR, RTN, BRU, BRD
				{statusregin[7], 1'b1, sign_flag, twc_overflow, 1'b0, alucout, neg, eqzero}; 

reg [11:0] stackregintermediate;
assign decremented_stack_reg [11:0] = stackregintermediate [11:0];
			 
//for inc or dec
wire one;
assign one = 1;

wire zero;
assign zero = 0;

assign incremented_write_addr = reg_write_addr + one;
assign incremented_read_addr = reg_read_addr + one;

wire [16:0] decoded_offset = 17'b00000000000000001 << instruction[3:0];

always @(*)
begin 
		case (encoded_opcode)
		
					6'b000000: alusum = {5'b00000, rs1data[11:0]} + one ; //JMR
					6'b000001: alusum = {1'b0, rs1data} + cin ; //ASC					
					6'b000011: begin alusum = {4'b0000, rs1data[11:0]}  + one; // CAR
									 stackregintermediate = {stack_reg} + one ; end
					6'b000110: alusum = {1'b0,~rs1data} ; //INV 
					6'b000111: alusum = {1'b0,~rs1data} + one; //TWC 
					6'b001000: alusum = {1'b0,rs1data}  + one; //INC 
					6'b001001: alusum = {1'b0,rs1data}  - one; //DEC 
					6'b001010: alusum = {1'b0,rs2data} ; //LDI 
					6'b001011: alusum = {1'b0,rs1data} + {1'b0, rs2data} ; //AIM COmPLETE NO ALU? 
					6'b001100: alusum = {1'b0,rs1data} - {1'b0, rs2data}; //SIM COMPLETE NO ALU?
					
					
					6'b001101: alusum = {1'b0, rs1data} | decoded_offset; // SEB
					6'b001110: alusum = {1'b0, rs1data} & ~decoded_offset; // CLB
					6'b001111: statusregintermediate[4] = rs1data [decoded_offset]; //STB COMPLETE									
//					6'b010000: rs1data[k] = statusregisterin[3]; // LOB
					
					
					6'b010001: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; //ADD 
					6'b010010: alusum = {1'b0,rs1data} + {1'b0,rs2data} + cin ; //ADC 
					6'b010011: alusum = {1'b0,rs2data} - {1'b0,rs1data}; //SUB 
					6'b010100: alusum = {1'b0,rs2data} - {1'b0,rs1data} - cin ; //SBC 
					6'b010101: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; // GHA 
					6'b010110: alusum = {1'b0,rs2data} - {1'b0,rs1data} ; // GHS 
					
					6'b011001: alusum = {1'b0,rs2data}  + one; //PUSH 
					6'b011010: alusum = {1'b0,rs1data} ; //LOAD : cannot be changed so status register updates
					
					6'b011011: begin stackregintermediate = {stack_reg} - one; // POP
									alusum = {1'b0, rs1data} - one; end
					
					6'b011100: alusum = {1'b0,rs1data} ; //STORE : cannot be changed so status register updates
					6'b011101: alusum = {1'b0,rs1data} & {1'b0,rs2data} ; //AND 
					6'b011110: alusum = {1'b0,rs1data} | {1'b0,rs2data} ; //OR 
					6'b011111: alusum = ({1'b0,rs1data} + {1'b0,rs2data}) & ({1'b0,~rs1data} + {1'b0,~rs2data}) ; //XOR 
					6'b100000: alusum = {1'b0,rs1data} ; //COMP COMPLETE
					
					6'b100011: alusum = {5'b00000, instruction[11:0]} + one ; //JMD 
					6'b100100: begin stackregintermediate = {stack_reg}  + one; // CALL
									 alusum = {5'b00000, instruction[11:0]} + one ; end
					//6'b100101: alusum = {1'b0,rs1data} ; //LDA 
					
					6'b100110: begin stackregintermediate = {stack_reg}  - one ; //RTN
								alusum = {5'b00000, rs1data [11:0]} + one ; end
					
					6'b101001: statusregintermediate[0] = one; //SEZ 
					6'b101010: statusregintermediate[0] =  zero; //CLZ 
					6'b101011: statusregintermediate[1] =  one;  //SEN 
					6'b101100: statusregintermediate[1] =  zero;  //CLN
					6'b101101: statusregintermediate[2] =  one;  //SEC 
					6'b101110: statusregintermediate[2] =  zero;  //CLC 
					6'b101111: statusregintermediate[3] =  one;  //SET 
					6'b110000: statusregintermediate[3] =  zero;  //CLT 
					6'b110001: statusregintermediate[4] =  one;  //SEV
					6'b110010: statusregintermediate[4] =  zero;  //CLV 
					6'b110011: statusregintermediate[5] =  one;  //SES 
					6'b110100: statusregintermediate[5] =  zero;  //CLS 
					6'b110101: statusregintermediate[7] =  one;  //SEI 
					6'b110110: statusregintermediate[7] =  zero;  //CLI
					
					6'b110111: alusum = {1'b0,rs1data} ; //BRU COMPLETE
					6'b111000: alusum = {1'b0,rs1data} ; //BRD COMPLETE
					
					default : alusum = {1'b0, rs1data}; // default output for unimplemented OP values, do not change
		endcase;
end

endmodule

