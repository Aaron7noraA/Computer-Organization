module Decoder( instr_op_i, instr_fnc, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o, JUMP, BRANCH, BRANCH_TYPE, MEM_W, MEM_R, MEM_to_REG );
     
//I/O ports
input	[6-1:0] instr_op_i;
input	[6-1:0] instr_fnc;

output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output	[1:0]		RegDst_o, JUMP;
output 			BRANCH, MEM_W, MEM_R;
output [1:0] BRANCH_TYPE, MEM_to_REG;
//Internal Signals
wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire	[1:0]		RegDst_o;

reg [2:0] temp1;
reg [1:0] temp2, temp3;

/*
wire R,ADDI,LW,SW,BNE,jump;

assign R = ~instr_op_i[0] & ~instr_op_i[1] & ~instr_op_i[2] & ~instr_op_i[3] & ~instr_op_i[4] & ~instr_op_i[5]; //R
assign ADDI = ~instr_op_i[0] & ~instr_op_i[1] & ~instr_op_i[2] & instr_op_i[3] & ~instr_op_i[4] & ~instr_op_i[5]; // addi
assign BEQ = ~instr_op_i[0] & instr_op_i[1] & ~instr_op_i[2] & instr_op_i[3] & ~instr_op_i[4] & ~instr_op_i[5]; //beq
assign LW = ~instr_op_i[0] & ~instr_op_i[1] & instr_op_i[2] & instr_op_i[3] & ~instr_op_i[4] & instr_op_i[5]; //lw
assign SW = instr_op_i[0] & ~instr_op_i[1] & instr_op_i[2] & instr_op_i[3] & ~instr_op_i[4] & instr_op_i[5]; //sw
assign BNE = instr_op_i[0] & instr_op_i[1] & ~instr_op_i[2] & instr_op_i[3] & ~instr_op_i[4] & ~instr_op_i[5]; //bne
assign jump = ~instr_op_i[0] & instr_op_i[1] & ~instr_op_i[2] & ~instr_op_i[3] & ~instr_op_i[4] & ~instr_op_i[5]; //jump

assign RegDst_o = R;
assign ALUSrc_o = ADDI | LW | SW;
assign ALUOp_o = {{ADDI | BNE},{R | BNE},BEQ};
//assign ALUOp_o = {ADDI,BEQ,BEQ};
assign MEM_to_REG = LW;
assign RegWrite_o = R | LW | ADDI;
assign MEM_R = LW;
assign MEM_W = SW;
assign BRANCH = BEQ | BNE;
assign JUMP = jump;
assign BRANCH_TYPE = BNE;
*/





//Main function
assign RegWrite_o = ({instr_op_i, instr_fnc} == 12'b000000001000) ? 1'b0 : // jr can't write
			(instr_op_i == 6'b000000) ? 1'b1 :
		    (instr_op_i == 6'b001000) ? 1'b1 : 
		    (instr_op_i == 6'b101100) ? 1'b1 : 
		    (instr_op_i == 6'b000011) ? 1'b1 : //jal
		    (instr_op_i == 6'b001111) ? 1'b1 : 1'b0;

always  @(*)
	begin
		case(instr_op_i)
			6'b000000: //R
				begin
				 	temp1 <= 3'b010;
				 	temp2 <= 2'b01;
				 	temp3 <= 2'b00;									
				end 
			6'b001000: //addi
				begin
					temp1 <= 3'b100;
					temp2 <= 2'b00;
					temp3 <= 2'b00;
				end
			6'b001010: //beq
				begin
					temp1 <= 3'b001;
					temp2 <= 2'b00;  //don' care
					temp3 <= 2'b0;  //don' care
				end
			6'b001111: //lui
				begin
					temp1 <= 3'b101;
					temp2 <= 2'b0;
					temp3 <= 2'b00;
				end
			6'b101100: //LW
				begin
					temp1 <= 3'b000;
					temp2 <= 2'b00;
					temp3 <= 2'b01;
				end
			6'b101101: // SW
				begin
					temp1 <= 3'b000;
					temp2 <= 2'b00;  //don' care
					temp3 <= 2'b01;  //don' care
				end
			6'b001011: //BNE
				begin
					temp1 <= 3'b110;
					temp2 <= 2'b00;  //don' care
					temp3 <= 2'b00;  //don' care
				end
			6'b000010: //JUMP
				begin
					temp1 <= 3'b000; //don't care
					temp2 <= 2'b00;  //don' care
					temp3 <= 2'b00;  //don' care
				end
			6'b000011: //JAL
				begin
					temp1 <= 3'b000; //don't care
					temp2 <= 2'b10; //for(bit(11111))
					temp3 <= 2'b10;
				end
			6'b001110: //BLT
				begin
					temp1 <= 3'b110;
					temp2 <= 2'b00;  //don' care
					temp3 <= 2'b00;  //don' care
				end
			6'b001100: //BNEZ
				begin
					temp1 <= 3'b110;
					temp2 <= 2'b00;
					temp3 <= 2'b00;  //don' care
				end
			6'b001101: //BGEZ
				begin
					temp1 <= 3'b110;//don' care
					temp2 <= 2'b00;
					temp3 <= 2'b00;  //don' care
				end
		endcase		
	end

assign ALUOp_o = temp1;
assign RegDst_o = temp2; 
assign MEM_to_REG = temp3;


assign ALUSrc_o = (instr_op_i == 6'b000000) ? 1'b0 : //Rtype
		 (instr_op_i == 6'b001010) ? 1'b0 : //beq
		 (instr_op_i == 6'b001011) ? 1'b0 : //bne
		 (instr_op_i == 6'b001110) ? 1'b0 : //blt
		 (instr_op_i == 6'b001100) ? 1'b0 : //bnez
		 (instr_op_i == 6'b001101) ? 1'b0 : 1'b1; //bgez

assign JUMP = (instr_op_i == 6'b000010) ? 2'b01 : // j
		 (instr_op_i == 6'b000011) ? 2'b01 ://jal
		 ({instr_op_i, instr_fnc} == 12'b000000001000) ? 2'b10 : 2'b00;//jr


assign BRANCH = (instr_op_i == 6'b001010) ? 1'b1 ://BEQ
		 (instr_op_i == 6'b001011) ? 1'b1 ://bne
		 (instr_op_i == 6'b001110) ? 1'b1 ://blt
		 (instr_op_i == 6'b001100) ? 1'b1 ://bnez
		 (instr_op_i == 6'b001101) ? 1'b1 : 1'b0;//bgez

assign BRANCH_TYPE = (instr_op_i == 6'b001010) ? 2'b00 : //BEQ
					 (instr_op_i == 6'b001011) ? 2'b01 : //BNE
					 (instr_op_i == 6'b001100) ? 2'b01 : //Bnez
					 (instr_op_i == 6'b001110) ? 2'b10 : //blt
					 (instr_op_i == 6'b001101) ? 2'b11 :	2'b00; //bgez

assign MEM_W = (instr_op_i == 6'b101101) ? 1'b1 : //SW
						1'b0; 

assign MEM_R = (instr_op_i == 6'b101100) ? 1'b1 : 1'b0; //lW

				
endmodule
   