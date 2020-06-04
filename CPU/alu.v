module alu (

	input [15:0] instruction, 			// from IR'
	input [5:0] encoded_opcode,
	input [11:0] stack_reg,
	
	input [15:0] rs1data, 				// Rs register data outputs
	input [15:0] rs2data, 				// 2nd Rs register data output

	input [7:0] statusregin,			//input of status reg

	input [2:0] reg_write_addr,
	input [2:0] reg_read_addr,

	output [15:0] aluout1, 
	output [15:0] aluout2,				// used only for MULT
	output [2:0] incremented_write_addr,
	output [2:0] incremented_read_addr,
	output [7:0] statusregout, 		// output of status reg
	output [11:0] decremented_stack_reg
);

wire alucout;                  // alu carry output
wire carryout; 						// the CARRY out, D for CARRY flip flop

//doing logic and assigning outputs

wire [31:0] thirtytwooutput;	




mult16x16 calc(
					.A (rs1data[15:0]),
					.B (rs2data[15:0]),
					.P (thirtytwooutput[31:0])
									);

									
									
reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
wire cin; // The ALU carry input, determined from instruction as in ISA spec
wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
assign cin = statusregin[2];

assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
assign aluout1 = (encoded_opcode == 6'b101010) ? thirtytwooutput[15:0] :
						alusum [15:0]; // 16 normal bits from sum
						
assign aluout2 = thirtytwooutput[31:16] ;   // 16 normal bits from sum


wire eqzero = ~alusum[16]&&~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
wire neg = alusum[15];
wire twc_overflow;
wire sign_flag = neg & ~twc_overflow | ~neg & twc_overflow;

//decide if to use control instr output to status reg or to use the normal procedures

reg [7:0] statusregintermediate = statusregin;

assign statusregout = (encoded_opcode == 6'b101001||encoded_opcode == 6'b101010||encoded_opcode == 6'b101011||encoded_opcode == 6'b101100||encoded_opcode == 6'b101101||encoded_opcode == 6'b101110||encoded_opcode == 6'b101111||encoded_opcode == 6'b110000||encoded_opcode == 6'b110001||encoded_opcode == 6'b110010||encoded_opcode == 6'b110011||encoded_opcode == 6'b110100||encoded_opcode == 6'b110101||encoded_opcode == 6'b110110) ? statusregintermediate : // control ops with offset
           ((encoded_opcode == 6'b010101)||(encoded_opcode == 6'b010110)) ? statusregin : // ghost arithmetic operations
            {eqzero, neg, alucout, 1'b0, twc_overflow, sign_flag, 1'b1, statusregin[7]}; //COMPLETE ALL 8 BITS



reg [11:0] stackregintermediate;
assign decremented_stack_reg [11:0] = stackregintermediate [11:0];

			 
//for inc or dec
wire one;
assign one = 1;

wire zero;
assign zero = 0;



	




//wire fourbitzero;
//wire fourbitone;
//wire fourbittwo;
//wire fourbitthree;
//wire fourbitfour;
//wire fourbitfive;
//wire fourbitsix;
//wire fourbitseven;
//wire fourbiteight;
//wire fourbitnine;
//wire fourbitten;
//wire fourbiteleven;
//wire fourbittwelve;
//wire fourbitthirteen;
//wire fourbitfourteen;
//wire fourbitfifteen;
//
//assign fourbitzero = ~instruction[3]&&~instruction[2]&&~instruction[1]&&~instruction[0];
//assign fourbitone = ~instruction[3]&&~instruction[2]&&~instruction[1]&&instruction[0];
//assign fourbittwo = ~instruction[3]&&~instruction[2]&&instruction[1]&&~instruction[0];
//assign fourbitthree = ~instruction[3]&&~instruction[2]&&instruction[1]&&instruction[0];
//assign fourbitfour = ~instruction[3]&&instruction[2]&&~instruction[1]&&~instruction[0];
//assign fourbitfive = ~instruction[3]&&instruction[2]&&~instruction[1]&&instruction[0];
//assign fourbitsix = ~instruction[3]&&instruction[2]&&instruction[1]&&~instruction[0];
//assign fourbitseven = ~instruction[3]&&instruction[2]&&instruction[1]&&instruction[0];
//assign fourbiteight = instruction[3]&&~instruction[2]&&~instruction[1]&&~instruction[0];
//assign fourbitnine = instruction[3]&&~instruction[2]&&~instruction[1]&&instruction[0];
//assign fourbitten = instruction[3]&&~instruction[2]&&instruction[1]&&~instruction[0];
//assign fourbiteleven = instruction[3]&&~instruction[2]&&instruction[1]&&instruction[0];
//assign fourbittwelve = instruction[3]&&instruction[2]&&~instruction[1]&&~instruction[0];
//assign fourbitthirteen = instruction[3]&&instruction[2]&&~instruction[1]&&instruction[0];
//assign fourbitfourteen = instruction[3]&&instruction[2]&&instruction[1]&&~instruction[0];
//assign fourbitfifteen = instruction[3]&&instruction[2]&&instruction[1]&&instruction[0];


assign incremented_write_addr = reg_write_addr + one;
assign incremented_read_addr = reg_read_addr + one;

reg [3:0] offset = instruction [3:0];
reg [16:0] decoded_offset = 17'b00000000000000001 << offset;

always @(*)
begin 
		case (encoded_opcode)
		
					//6'b000000: alusum = {1'b0,rs1data} ; //JMR 
					//6'b000001: alusum = {1'b0,rs1data} ; //JMI 
					//6'b000010: alusum = {1'b0,rs1data} ; //JEQ 
					6'b000011: alusum = {1'b0,rs1data} ; //CAR COMPLETE
					//6'b000100: alusum = {1'b0,rs1data} ; //LSR 
					//6'b000101: alusum = {1'b0,rs1data} ; //ASR 
					6'b000110: alusum = {1'b0,~rs1data} ; //INV 
					6'b000111: alusum = {1'b0,~rs1data} + one; //TWC 
					6'b001000: alusum = {1'b0,rs1data}  + one; //INC 
					6'b001001: alusum = {1'b0,rs1data}  - one; //DEC 
					//6'b001010: alusum = {1'b0,rs1data} ; //LDI 
					6'b001011: alusum = {1'b0,rs1data} ; //AIM COmPLETE NO ALU? 
					6'b001100: alusum = {1'b0,rs1data} ; //SIM COMPLETE NO ALU?
					
					
//					6'b001101: alusum = (fourbitzero&&({1'b0,rs1data[15:1],1'b1}))||(fourbitone&&({1'b0,rs1data[15:2],1'b1,rs1data[0]}))||(fourbittwo&&({1'b0,rs1data[15:3],1'b1,rs1data[1:0]}))||(fourbitthree&&({1'b0,rs1data[15:4],1'b1,rs1data[2:0]}))||(fourbitfour&&({1'b0,rs1data[15:5],1'b1,rs1data[3:0]}))||(fourbitfive&&({1'b0,rs1data[15:6],1'b1,rs1data[4:0]}))||(fourbitsix&&({1'b0,rs1data[15:7],1'b1,rs1data[5:0]}))||(fourbitseven&&({1'b0,rs1data[15:8],1'b1,rs1data[6:0]}))||(fourbiteight&&({1'b0,rs1data[15:9],1'b1,rs1data[7:0]}))||(fourbitnine&&({1'b0,rs1data[15:10],1'b1,rs1data[8:0]}))||(fourbitten&&({1'b0,rs1data[15:11],1'b1,rs1data[9:0]}))||(fourbiteleven&&({1'b0,rs1data[15:12],1'b1,rs1data[10:0]}))||(fourbittwelve&&({1'b0,rs1data[15:13],1'b1,rs1data[11:0]}))||(fourbitthirteen&&({1'b0,rs1data[15:14],1'b1,rs1data[12:0]}))||(fourbitfourteen&&({1'b0,rs1data[15],1'b1,rs1data[13:0]}))||(fourbitfifteen&&({1'b0,1'b1,rs1data[14:0]})) ;//SEB find bit k of rs1data COMPLETE
//					6'b001110: alusum = (fourbitzero&&({1'b0,rs1data[15:1],1'b0}))||(fourbitone&&({1'b0,rs1data[15:2],1'b0,rs1data[0]}))||(fourbittwo&&({1'b0,rs1data[15:3],1'b0,rs1data[1:0]}))||(fourbitthree&&({1'b0,rs1data[15:4],1'b0,rs1data[2:0]}))||(fourbitfour&&({1'b0,rs1data[15:5],1'b0,rs1data[3:0]}))||(fourbitfive&&({1'b0,rs1data[15:6],1'b0,rs1data[4:0]}))||(fourbitsix&&({1'b0,rs1data[15:7],1'b0,rs1data[5:0]}))||(fourbitseven&&({1'b0,rs1data[15:8],1'b0,rs1data[6:0]}))||(fourbiteight&&({1'b0,rs1data[15:9],1'b0,rs1data[7:0]}))||(fourbitnine&&({1'b0,rs1data[15:10],1'b0,rs1data[8:0]}))||(fourbitten&&({1'b0,rs1data[15:11],1'b0,rs1data[9:0]}))||(fourbiteleven&&({1'b0,rs1data[15:12],1'b0,rs1data[10:0]}))||(fourbittwelve&&({1'b0,rs1data[15:13],1'b0,rs1data[11:0]}))||(fourbitthirteen&&({1'b0,rs1data[15:14],1'b0,rs1data[12:0]}))||(fourbitfourteen&&({1'b0,rs1data[15],1'b0,rs1data[13:0]}))||(fourbitfifteen&&({1'b0,1'b0,rs1data[14:0]})) ;//SEB find bit k of rs1data COMPLETE
					6'b001101: alusum = {1'b0, rs1data} | decoded_offset;
					6'b001110: alusum = {1'b0, rs1data} & ~decoded_offset;
					6'b001111: alusum = {1'b0,rs1data}; //STB COMPLETE
									
//					6'b010000: rs1data[k] = statusregisterin[3]; // LOB
					
					
					6'b010001: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; //ADD 
					6'b010010: alusum = {1'b0,rs1data} + {1'b0,rs2data} + cin ; //ADC 
					6'b010011: alusum = {1'b0,rs1data} + {1'b0,~rs2data} + 1; //SUB 
					6'b010100: alusum = {1'b0,rs1data} + {1'b0,~rs2data} + 1 - cin ; //SBC 
					6'b010101: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; // GHA 
					6'b010110: alusum = {1'b0,rs1data} + {1'b0,~rs2data} + 1 ; // GHS 
					
					
					//6'b010111: alusum = {1'b0,rs1data} ; //MOV 
					6'b011000: alusum = {1'b0,rs1data} ; //MOW COMPLETE
					6'b011001: alusum = {1'b0,rs2data}  + one; //PUSH 
					//6'b011010: alusum = {1'b0,rs1data} ; //LOAD 
					6'b011011: alusum = {1'b0,rs1data}  - one ; //POP 
					//6'b011100: alusum = {1'b0,rs1data} ; //STORE 
					6'b011101: alusum = {1'b0,rs1data} & {1'b0,rs2data} ; //AND 
					6'b011110: alusum = {1'b0,rs1data} | {1'b0,rs2data} ; //OR 
					6'b011111: alusum = ({1'b0,rs1data} + {1'b0,rs2data}) & ({1'b0,~rs1data} + {1'b0,~rs2data}) ; //XOR 
					6'b100000: alusum = {1'b0,rs1data} ; //COMP COMPLETE
					
					
					//6'b100001: {aluout1,aluout2} = thirtytwooutput ; //MUL COmPLETE
					6'b100010: alusum = {1'b0,rs1data} ; //MLS COMPLETE
					
					
					//6'b100011: alusum = {1'b0,rs1data} ; //JMD 
					// 6'b100100: stackregintermediate = {stack_reg}  - one; //CALL 
					//6'b100101: alusum = {1'b0,rs1data} ; //LDA 
					
					
					6'b100110: stackregintermediate = {stack_reg}  - one ; //RTN 
					//6'b100111: alusum = {1'b0,rs1data} ; //STP 
					//6'b101000: alusum = {1'b0,rs1data} ; //CLEAR 
					
					6'b101001: statusregintermediate[0] =  one; //SEZ 
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
					
					default : alusum = 0;// default output for unimplemented OP values, do not change
		endcase;
end



endmodule

