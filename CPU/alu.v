module alu (

	input [15:0] instruction, 			// from IR'
	input exec1, 							// timing signal: when things happen
	input [5:0] encoded_opcode,
	
	input aim,
	input sim,
	
	input [15:0] rs1data, 				// Rs register data outputs
	input [15:0] rs2data, 				// 2nd Rs register data output

	input [7:0] statusregin,			//input of status reg

	input [2:0] reg_addr,

	output [15:0] aluout1, 
	output [15:0] aluout2,				// used only for MULT
	output [2:0] incremented_reg_addr,
	output [7:0] statusregout 		// output of status reg
);

wire alucout;                  // alu carry output
wire carryout; 						// the CARRY out, D for CARRY flip flop

//doing logic and assigning outputs

reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
wire cin; // The ALU carry input, determined from instruction as in ISA spec
wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
assign cin = statusregin[2];

assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
assign aluout1 = alusum [15:0]; // 16 normal bits from sum

assign statusregout[0] = ~alusum[16]&&~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
assign statusregout[1] = alusum[15];
 //ghostaddsubwire orred with cin
assign statusregout[2] = (~(instruction[13]==0&&instruction[12]==1&&instruction[11]==0&&instruction[10]==0)||~(instruction[13]==0&&instruction[12]==1&&instruction[11]==0&&instruction[10]==1)) ?   alucout : cin   ;
								 
//for inc or dec
wire one;
assign one = 1;

wire zero;
assign zero = 0;

//for clb seb stb lob
	
wire fourbitzero;
wire fourbitone;
wire fourbittwo;
wire fourbitthree;
wire fourbitfour;
wire fourbitfive;
wire fourbitsix;
wire fourbitseven;
wire fourbiteight;
wire fourbitnine;
wire fourbitten;
wire fourbiteleven;
wire fourbittwelve;
wire fourbitthirteen;
wire fourbitfourteen;
wire fourbitfifteen;


assign fourbitzero = ~instruction[3]&&~instruction[2]&&~instruction[1]&&~instruction[0];
assign fourbitone = ~instruction[3]&&~instruction[2]&&~instruction[1]&&instruction[0];
assign fourbittwo = ~instruction[3]&&~instruction[2]&&instruction[1]&&~instruction[0];
assign fourbitthree = ~instruction[3]&&~instruction[2]&&instruction[1]&&instruction[0];
assign fourbitfour = ~instruction[3]&&instruction[2]&&~instruction[1]&&~instruction[0];
assign fourbitfive = ~instruction[3]&&instruction[2]&&~instruction[1]&&instruction[0];
assign fourbitsix = ~instruction[3]&&instruction[2]&&instruction[1]&&~instruction[0];
assign fourbitseven = ~instruction[3]&&instruction[2]&&instruction[1]&&instruction[0];
assign fourbiteight = instruction[3]&&~instruction[2]&&~instruction[1]&&~instruction[0];
assign fourbitnine = instruction[3]&&~instruction[2]&&~instruction[1]&&instruction[0];
assign fourbitten = instruction[3]&&~instruction[2]&&instruction[1]&&~instruction[0];
assign fourbiteleven = instruction[3]&&~instruction[2]&&instruction[1]&&instruction[0];
assign fourbittwelve = instruction[3]&&instruction[2]&&~instruction[1]&&~instruction[0];
assign fourbitthirteen = instruction[3]&&instruction[2]&&~instruction[1]&&instruction[0];
assign fourbitfourteen = instruction[3]&&instruction[2]&&instruction[1]&&~instruction[0];
assign fourbitfifteen = instruction[3]&&instruction[2]&&instruction[1]&&instruction[0];
		
										 
		
										 
		
	
always @(*)
begin 
		case (encoded_opcode)
		
					6'b000000: alusum = {1'b0,rs1data} ; //JMR 
					//6'b000001: alusum = {1'b0,rs1data} ; //JMI 
					//6'b000010: alusum = {1'b0,rs1data} ; //JEQ 
					6'b000011: alusum = {1'b0,rs1data} ; //CAR COMPLETE
					6'b000100: alusum = {1'b0,rs1data} ; //LSR COMPLETE
					6'b000101: alusum = {1'b0,rs1data} ; //ASR COMPLETE
					6'b000110: alusum = {1'b0,~rs1data} ; //INV 
					6'b000111: alusum = {1'b0,~rs1data} + one; //TWC 
					6'b001000: alusum = {1'b0,rs1data}  + one; //INC 
					6'b001001: alusum = {1'b0,rs1data}  - one; //DEC 
					//6'b001010: alusum = {1'b0,rs1data} ; //LDI 
					6'b001011: alusum = {1'b0,rs1data} ; //AIM COmPLETE 
					6'b001100: alusum = {1'b0,rs1data} ; //SIM COMPLETE
					
					
					//6'b001101: (fourbitzero&&rs1data[0])||(fourbitone&&rs1data[1])||(fourbittwo&&rs1data[2])||(fourbitthree&&rs1data[3])||(fourbitfour&&rs1data[4])||(fourbitfive&&rs1data[5])||(fourbitsix&&rs1data[6])||(fourbitseven&&rs1data[7])||(fourbiteight&&rs1data[8])||(fourbitnine&&rs1data[9])||(fourbitten&&rs1data[10])||(fourbiteleven&&rs1data[11])||(fourbittwelve&&rs1data[12])||(fourbitthirteen&&rs1data[13])||(fourbitfourteen&&rs1data[14])||(fourbitfifteen&&rs1data[15])= one;//SEB find bit k of rs1data
					6'b001110: alusum = {1'b0,rs1data} ; //CLB COMPLETE SEB 
					6'b001111: alusum = {1'b0,rs1data} ; //STB COMPLETE
					6'b010000: alusum = {1'b0,rs1data} ; //LOB COMPLETE
					
					
					6'b010001: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; //ADD 
					6'b010010: alusum = {1'b0,rs1data} + {1'b0,rs2data} + cin ; //ADC 
					6'b010011: alusum = {1'b0,rs1data} + {1'b0,~rs2data} ; //SUB 
					6'b010100: alusum = {1'b0,rs1data} + {1'b0,~rs2data} - cin ; //SBC 
					6'b010101: alusum = {1'b0,rs1data} + {1'b0,rs2data} ; //GHA 
					6'b010110: alusum = {1'b0,rs1data} + {1'b0,~rs2data} ; //GHS 
					
					
					6'b010111: alusum = {1'b0,rs1data} ; //MOV 
					6'b011000: alusum = {1'b0,rs1data} ; //MOW COMPLETE
					6'b011001: alusum = {1'b0,rs1data} ; //PUSH COMPLETE
					//6'b011010: alusum = {1'b0,rs1data} ; //LOAD 
					6'b011011: alusum = {1'b0,rs1data} ; //POP COMPLETE
					//6'b011100: alusum = {1'b0,rs1data} ; //STORE 
					6'b011101: alusum = {1'b0,rs1data} && {1'b0,rs2data} ; //AND 
					6'b011110: alusum = {1'b0,rs1data} || {1'b0,rs2data} ; //OR 
					6'b011111: alusum = ({1'b0,rs1data} + {1'b0,rs2data}) && ({1'b0,~rs1data} + {1'b0,~rs2data}) ; //XOR 
					6'b100000: alusum = {1'b0,rs1data} ; //COMP COMPLETE
					
					
					6'b100001: alusum = {1'b0,rs1data} ; //MUL COmPLETE
					6'b100010: alusum = {1'b0,rs1data} ; //MLS COMPLETE
					
					
					//6'b100011: alusum = {1'b0,rs1data} ; //JMD 
					6'b100100: alusum = {1'b0,rs1data} ; //CALL  COMPLETE
					//6'b100101: alusum = {1'b0,rs1data} ; //LDA 
					
					
					6'b100110: alusum = {1'b0,rs1data} ; //RTN COMPLETE
					//6'b100111: alusum = {1'b0,rs1data} ; //STP 
					//6'b101000: alusum = {1'b0,rs1data} ; //CLEAR 
					6'b101001: alusum = {1'b0,rs1data} ; //SEZ COMPLETE
					6'b101010: alusum = {1'b0,rs1data} ; //CLZ COMPLETE
					6'b101011: alusum = {1'b0,rs1data} ; //SEN COMPLETE
					6'b101100: alusum = {1'b0,rs1data} ; //CLN COMPLETE
					6'b101101: alusum = {1'b0,rs1data} ; //SEC COMPLETE
					6'b101110: alusum = {1'b0,rs1data} ; //CLC COMPLETE
					6'b101111: alusum = {1'b0,rs1data} ; //SET COMPLETE
					6'b110000: alusum = {1'b0,rs1data} ; //CLT COMPLETE
					6'b110001: alusum = {1'b0,rs1data} ; //SEV COMPLETE
					6'b110010: alusum = {1'b0,rs1data} ; //CLV COMPLETE
					6'b110011: alusum = {1'b0,rs1data} ; //SES COMPLETE
					6'b110100: alusum = {1'b0,rs1data} ; //CLS COMPLETE
					6'b110101: alusum = {1'b0,rs1data} ; //SEI COMPLETE
					6'b110110: alusum = {1'b0,rs1data} ; //CLI COMPLETE
					6'b110111: alusum = {1'b0,rs1data} ; //BRU COMPLETE
					6'b111000: alusum = {1'b0,rs1data} ; //BRD COMPLETE
					
					default : alusum = 0;// default output for unimplemented OP values, do not change
		endcase;
end

endmodule