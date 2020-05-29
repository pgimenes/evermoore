module alu ( instruction, rddata, rsdata, carrystatus, skipstatus, exec1,
aluout, carryout, skipout, carryen, skipen, wenout) ;
// v1.01


input [15:0] instruction; // from IR'
input exec1; // timing signal: when things happen
input [15:0] rddata; // Rd register data outputs
input [15:0] rsdata; // Rs register data outputs
input [15:0] rs1data; // 2nd Rs register for three register AM
input carrystatus; // the Q output from CARRY
input skipstatus; // the Q output from SKIP
input [7:0] statusregin;

output [15:0] aluout; // the ALU block output, written into Rd
output [7:0] statusregout;
output carryout; // the CARRY out, D for CARRY flip flop
output skipout; // the SKIP output, D for SKIP flip flop
output carryen; // the enable signal for CARRY flip-flop
output skipen; // the enable signal for SKIP flip-flop
output wenout; // the enable for writing Rd in the register file

if(instruction[15]==0&&instruction[14]==0) //single register mode
	begin
	
	if(instruction[13]==0)
		begin
		
		
			// these wires are for convenience to make logic easier to see
		wire [5:0] opinstr = instruction [12:7]; // OP field from IR'
		wire [3:0] condinstr = instruction [6:3]; // COND field from IR'
		wire [2:0] rsnumber  = instruction [2:0];
		reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
		wire cin; // The ALU carry input, determined from instruction as in ISA spec
		wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
			// do not change
			
			assign cin = statusregin[2];
			
			
		
			case (opinstr)
			
					6'b000111 : alusum = {1'b0,~rsdata} ; // if OP = 000111 INV
					default : alusum = 0;// default output for unimplemented OP values, do not change


			endcase;
			
			
			
			assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
			assign aluout = alusum [15:0]; // 16 normal bits from sum
			
			assign rsdata = alucout;
				// change as needed
			
			assign statusregout[0] = ~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
			assign statusregout[1] = alusum[15];
			assign statusregout[2] = alucout;


		end
		
	if(instruction[13]==1)
		begin
		
		// these wires are for convenience to make logic easier to see
		wire [1:0] opinstr = instruction [12:11]; // OP field from IR'
		wire [3:0] condinstr = instruction [10:7]; // COND field from IR'
		wire [2:0] rsnumber  = instruction [6:4];
		wire [3:0] bit = instruction [3:0];
		reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
		wire cin; // The ALU carry input, determined from instruction as in ISA spec
		wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
			// do not change
			
			assign cin = statusregin[2];
			
			
		case (opinstr)
			
					
					default : alusum = 0;// default output for unimplemented OP values, do not change


			endcase;
			
			
			
			assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
			assign aluout = alusum [15:0]; // 16 normal bits from sum
			
			assign rsdata = alucout;
				// change as needed
				
			assign statusregout[0] = ~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
			assign statusregout[1] = alusum[15];
			assign statusregout[2] = alucout;
			
		
		end
	
	end
if(instruction[15]==0&&instruction[14]==1) //double register mode
	begin
	
	
	// these wires are for convenience to make logic easier to see
	wire [3:0] opinstr = instruction [13:10]; // OP field from IR'
	wire [3:0] condinstr = instruction [9:6]; // COND field from IR'
	wire [2:0] rdnumber  = instruction [5:3];
	wire [2:0] rsnumber  = instruction [2:0];
	reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
	wire cin; // The ALU carry input, determined from instruction as in ISA spec
	wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
			// do not change
			
	 assign cin = statusregin[2];
			
			
	case (opinstr)
			
					4'b0000 : alusum = {1'b0,rddata} + {1'b0,rsdata} ; 
					4'b0001 : alusum = {1'b0,rddata} + {1'b0,rsdata} + cin ; 
					4'b0010 : alusum = {1'b0,rddata} + {1'b0,~rsdata} ; 
					4'b0011 : alusum = {1'b0,rddata} + {1'b0,~rsdata} - cin ; 
					4'b0100 : alusum = {1'b0,rddata} + {1'b0,rsdata} ;
					4'b0101 : alusum = {1'b0,rddata} + {1'b0,~rsdata} ;
					4'b0110 : alusum = {1'b0,rsdata} ;
					
					
					default : alusum = 0;// default output for unimplemented OP values, do not change


		endcase;
			
			
			
		assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 011
		if(~(opinstr[3]==0&&opinstr[2]==1&&opinstr[1]==0&&opinstr[0]==0)||~(opinstr[3]==0&&opinstr[2]==1&&opinstr[1]==0&&opinstr[0]==1))        //ghost ADD AND SUB should not pass this if
			begin
			assign statusregout[2] == alucout;
			end
			
		assign aluout = alusum [15:0]; // 16 normal bits from sum
		
		assign statusregout[0] = ~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
		assign statusregout[1] = alusum[15];
	
	
	
	end
if(instruction[15]==1&&instruction[14]==0) // triple register mode
	begin
	
	// these wires are for convenience to make logic easier to see
	wire opinstr = instruction [13]; // OP field from IR'
	wire [3:0] condinstr = instruction [12:9]; // COND field from IR'
	wire [2:0] rdnumber  = instruction [8:6];
	wire [2:0] rsnumber  = instruction [5:3];
	wire [2:0] rs1number = instruction [2:0]; 
	reg [16:0] alusum; // the 17 bit sum, 1 extra bit so ALU carry out can be extracted
	wire cin; // The ALU carry input, determined from instruction as in ISA spec
	wire shiftin; // value shifted into bit 15 on LSR, determined as in ISA spec
			// do not change
			
	 assign cin = statusregin[2];
			
			
	case (opinstr)
			
					1'b0 : alusum = {1'b0,rddata} + {1'b0,rsdata} ; //MULTIPLY
					1'b1 : alusum = {1'b0,rddata} + {1'b0,rsdata} ; //MULTIPLY TWOS COMPLIMENT
					
				
					
					
					default : alusum = 0;// default output for unimplemented OP values, do not change


		endcase;
			
			
			
		assign alucout = alusum [16]; // carry bit from sum, or shift if OP = 01
		assign statusregout[2] == alucout;		
		assign aluout = alusum [15:0]; // 16 normal bits from sum
		
		assign statusregout[0] = ~alusum[15]&&~alusum[14]&&~alusum[13]&&~alusum[12]&&~alusum[11]&&~alusum[10]&&~alusum[9]&&~alusum[8]&&~alusum[7]&&~alusum[6]&&~alusum[5]&&~alusum[4]&&~alusum[3]&&~alusum[2]&&~alusum[1]&&~alusum[0];
		assign statusregout[1] = alusum[15];
		assign statusregout[2] = alucout;
	
	
	end
if(instruction[15]==1&&instruction[14]==1) // memory mode
	begin
	end






assign wenout = exec1; // correct timing, to do: add enable condition
assign carryen = exec1; // correct timing, to do: add enable condition
assign carryout = alucout; // this is correct except for XSR
// note the special case of rsdata[0] when OP=011 (XSR)


assign cin = 0; // dummy, to do: replace with correct logic
assign shiftin = 0; // dummy, to do: set equal to cin for correct XSR functionality
assign skipout = 0; // dummy, to do: replace with correct logic
assign skipen = exec1; // correct timing, to do: add enable condition
always @(*) // do not change this line -it makes sure we have combinational logic


endmodule