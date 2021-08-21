module Pipeline_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] instr, PC_i, PC_o, ReadData1, ReadData2, WriteData;
wire [32-1:0] signextend, zerofilled, ALUinput2, ALUResult, ShifterResult;
wire [5-1:0] WriteReg_addr, Shifter_shamt;
wire [4-1:0] ALU_operation;
wire [3-1:0] ALUOP;
wire [2-1:0] FURslt;
wire         RegDst, MemtoReg;
wire RegWrite, ALUSrc, zero, overflow;
wire Jump, Branch, BranchType, MemWrite, MemRead;
wire [32-1:0] PC_add1, PC_add2, PC_no_jump, PC_t, Mux3_result, DM_ReadData;
wire Jr;
assign Jr = ((instr[31:26] == 6'b000000) && (instr[20:0] == 21'd8)) ? 1 : 0;

wire [31:0] instr_out, pc_plus4_out;

//modules
Program_Counter PC(
        .clk_i(clk_i),
	    .rst_n(rst_n),
	    .pc_in_i(PC_add1),
	    .pc_out_o(PC_o)
	    );

Adder Adder1(//next instruction
        .src1_i(PC_o), 
	    .src2_i(32'd4),
	    .sum_o(PC_add1)
	    );

Instr_Memory IM(
        .pc_addr_i(PC_o),
	    .instr_o(instr)
	    );

IF_ID_REG FD(
        .clk_i(clk_i),
        .rst_n(rst_n),
        .instruction_in(instr),
        .instruction_out(instr_out)
        );

Reg_File RF(
        .clk_i(clk_i),
	    .rst_n(rst_n),
        .RSaddr_i(instr_out[25:21]),
        .RTaddr_i(instr_out[20:16]),
        .Wrtaddr_i(REG_dest_out2),
        .Wrtdata_i(WriteData),
        .RegWrite_i(WB_out2[1]),// consider jr
        .RSdata_o(ReadData1),
        .RTdata_o(ReadData2)
        );

Decoder Decoder(
        .instr_op_i(instr_out[31:26]),
	    .RegWrite_o(RegWrite),
	    .ALUOp_o(ALUOP),
	    .ALUSrc_o(ALUSrc),
	    .RegDst_o(RegDst),
		.MemWrite_o(MemWrite),
		.MemRead_o(MemRead),
		.MemtoReg_o(MemtoReg)
		);

    
Sign_Extend SE(
        .data_i(instr_out[15:0]),
        .data_o(signextend)
        );
/*always@(*)
begin
    $display("signextend: %d", signextend);
end*/
Zero_Filled ZF(
        .data_i(instr_out[15:0]),
        .data_o(zerofilled)
        );


wire [31:0] pc_plus4_out_2;
wire [1:0] WD_out;
wire [31:0] ReadData1_out, ReadData2_out, SE_out, Zero_out;
wire [4:0] instr_out_2, RT_dest_out, RD_dest_out;
wire [4:0] EXE_out;
wire [5:0] instr_out_3;
wire [1:0] M_out;
ID_EX_REG DE(
        .clk_i(clk_i), 
        .rst_n(rst_n),
        .WD_in({RegWrite, MemtoReg}), 
        .WD_out(WD_out),
        .M_in({MemRead, MemWrite}),
        .M_out(M_out), 
        .EXE_in({RegDst, ALUOP, ALUSrc}), 
        .EXE_out(EXE_out), 
        .RS_data_in(ReadData1), 
        .RS_data_out(ReadData1_out), 
        .RT_data_in(ReadData2), 
        .RT_data_out(ReadData2_out), 
        .SE_in(signextend), 
        .SE_out(SE_out), 
        .Zero_in(zerofilled), 
        .Zero_out(Zero_out), 
        .instr_s_in(instr_out[10:6]), 
        .instr_s_out(instr_out_2), 
        .alu_ctr_in(instr_out[5:0]), 
        .alu_ctr_out(instr_out_3), 
        .RT_dest_in(instr_out[20:16]), 
        .RT_dest_out(RT_dest_out), 
        .RD_dest_in(instr_out[15:11]), 
        .RD_dest_out(RD_dest_out)
        );



ALU_Ctrl AC(
        .funct_i(instr_out_3),
        .ALUOp_i(EXE_out[3:1]),
        .ALU_operation_o(ALU_operation),
        .FURslt_o(FURslt)
        );


Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(RT_dest_out),
        .data1_i(RD_dest_out),
        .select_i(EXE_out[4]),
        .data_o(WriteReg_addr)
        );  
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(ReadData2_out),
        .data1_i(SE_out),
        .select_i(EXE_out[0]),
        .data_o(ALUinput2)
        );	

ALU ALU(
		.aluSrc1(ReadData1_out),
	    .aluSrc2(ALUinput2),
	    .ALU_operation_i(ALU_operation),
		.result(ALUResult),
		.zero(zero),
		.overflow(overflow)
	    );
/*always@(*)
begin
	$display("ReadData1: %d", ReadData1);
	$display("ALUinput2: %d", ALUinput2);
	$display("ALUResult: %d", ALUResult);
end*/
Shifter shifter( 
		.result(ShifterResult),
		.leftRight(ALU_operation[0]),
		.shamt(instr_out_2),
		.sftSrc(ALUinput2)
		);

Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(ALUResult),
        .data1_i(ShifterResult),
		.data2_i(Zero_out),
        .select_i(FURslt),
        .data_o(Mux3_result)
        );			
/*always@(*)
begin
	$display("ALUResult: %d", ALUResult);
	$display("FURslt: %d", FURslt);
	$display("Mux3_result: %d", Mux3_result);
end*/

wire [1:0] WB_out;
wire [1:0] M_out2;
wire [31:0] ALU_res_out, RT_data_out2;
wire [4:0] REG_dest_out;

EXE_MEM_REG EM(
            .clk_i(clk_i), 
            .rst_n(rst_n),
            .WB_in(WD_out), 
            .WB_out(WB_out), 
            .M_in(M_out), 
            .M_out(M_out2), 
            .ALU_res_in(Mux3_result), 
            .ALU_res_out(ALU_res_out), 
            .RT_data_in(ReadData2_out), 
            .RT_data_out(RT_data_out2), 
            .REG_dest_in(WriteReg_addr), 
            .REG_dest_out(REG_dest_out)
            );


Data_Memory DM(
		.clk_i(clk_i),
		.addr_i(ALU_res_out),
		.data_i(RT_data_out2),
		.MemRead_i(M_out2[1]),
		.MemWrite_i(M_out2[0]),
		.data_o(DM_ReadData)
		);
/*always@(*)
begin
	$display("Mux3_result: %d", $signed(Mux3_result));
	$display("ReadData2: %d", $signed(ReadData2));
end*/	

wire [1:0] WB_out2;
wire [31:0] MEM_out, ALU_res_out2;
wire [4:0] REG_dest_out2;

M_WB_REG MW(
        .clk_i(clk_i), 
        .rst_n(rst_n),
        .WB_in(WB_out), 
        .WB_out(WB_out2), 
        .MEM_in(DM_ReadData), 
        .MEM_out(MEM_out), 
        .ALU_res_in(ALU_res_out), 
        .ALU_res_out(ALU_res_out2), 
        .REG_dest_in(REG_dest_out), 
        .REG_dest_out(REG_dest_out2)
        );


Mux2to1 #(.size(32)) Mux_Write( 
        .data0_i(ALU_res_out2),
        .data1_i(MEM_out),
        .select_i(WB_out2[0]),
        .data_o(WriteData)
        );
/*always@(*)
begin
	$display("WriteData: d", WriteData);
end*/
endmodule



