module Decoder( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, MemWrite_o, MemRead_o, MemtoReg_o);
     
//I/O ports
input	[6-1:0] instr_op_i;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	RegDst_o, MemtoReg_o;
output			MemWrite_o, MemRead_o;
 
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	RegDst_o, MemtoReg_o;
wire			MemWrite_o, MemRead_o;

//Main function
/*your code here*/

reg RegWrite_o1;
reg [3-1:0] ALUOp_o1;
reg ALUSrc_o1;
reg RegDst_o1, MemtoReg_o1;
reg 		MemWrite_o1, MemRead_o1;

always@(instr_op_i)
begin
  case(instr_op_i)
    6'b000000: // R-Type
      begin
        RegWrite_o1 = 1;
        ALUOp_o1 = 3'b010;
	    ALUSrc_o1 = 0;
        RegDst_o1 = 1;
		MemWrite_o1 = 0;
		MemRead_o1 = 0;
		MemtoReg_o1 = 0;
      end
	6'b101101: //sw
	  begin
        RegWrite_o1 = 0;
        ALUOp_o1 = 3'b000;
	    ALUSrc_o1 = 1;
		MemWrite_o1 = 1;
		MemRead_o1 = 0;
      end
	6'b101100: //lw
	  begin
        RegWrite_o1 = 1;
        ALUOp_o1 = 3'b000;
	    ALUSrc_o1 = 1;
        RegDst_o1 = 0;
		MemWrite_o1 = 0;
		MemRead_o1 = 1;
		MemtoReg_o1 = 1;
      end
    6'b001000: //addi
      begin
        RegWrite_o1 = 1;
        ALUOp_o1 = 3'b011;
        ALUSrc_o1 = 1;
        RegDst_o1 = 0;
		MemWrite_o1 = 0;
		MemRead_o1 = 0;
		MemtoReg_o1 = 0;
	  end

  endcase
end

assign  RegWrite_o = RegWrite_o1;
assign  ALUOp_o = ALUOp_o1;
assign  ALUSrc_o = ALUSrc_o1;
assign  RegDst_o = RegDst_o1;
assign	MemWrite_o = MemWrite_o1;
assign	MemRead_o = MemRead_o1;
assign	MemtoReg_o = MemtoReg_o1;

endmodule
   