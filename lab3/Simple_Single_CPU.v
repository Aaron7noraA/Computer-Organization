module Simple_Single_CPU( clk_i, rst_n );

//I/O port
input         clk_i;
input         rst_n;

//Internal Signles
wire [32-1:0] add_pc;
wire [32-1:0] pc_inst;
wire [32-1:0] instr_o;
wire [5-1:0] Write_reg;
wire [1:0] RegDst;
wire RegWrite;
wire [3-1:0] ALUOp;
wire ALUSrc;
wire [32-1:0] Write_Data;
wire [32-1:0] MEM_new_Data;
wire [32-1:0] rs_data;
wire [32-1:0] rt_data;
wire [4-1:0] ALUCtrl;
wire [2-1:0] FURslt;
wire [32-1:0] sign_instr;
wire [32-1:0] zero_instr;
wire [32-1:0] Src_ALU_Shifter;
wire [32-1:0] Fin_data;
wire zero;
wire [32-1:0] result_ALU;
wire [32-1:0] result_Shifter;
wire overflow;
wire [5-1:0] ShamtSrc;
wire sign, sor_sign;
wire [1:0]  BRANCH_TYPE;
wire [1:0] MEM_to_REG, JUMP;
wire BRANCH, MEM_W, MEM_R, Branch_col, PCSrc;
wire [31:0] add_branch, select_branch, next_addr;
//modules
Program_Counter PC(
        .clk_i(clk_i),      
	    .rst_n(rst_n),     
	    .pc_in_i(next_addr),   
	    .pc_out_o(pc_inst) 
	    );
	
Adder Adder1(
        .src1_i(pc_inst),     
	    .src2_i(32'd4),
	    .sum_o(add_pc)    
	    );
	
Instr_Memory IM(
        .pc_addr_i(pc_inst),  
	    .instr_o(instr_o)    
	    );

Mux3to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
                .data2_i(5'b11111),
        .select_i(RegDst),
        .data_o(Write_reg)
        );

/*
Mux2to1 #(.size(5)) Mux_Write_Reg(
        .data0_i(instr_o[20:16]),
        .data1_i(instr_o[15:11]),
        .select_i(RegDst),
        .data_o(Write_reg)
        );*/	
		
Reg_File RF(
        .clk_i(clk_i),      
	    .rst_n(rst_n) ,     
        .RSaddr_i(instr_o[25:21]) ,  
        .RTaddr_i(instr_o[20:16]) ,  
        .RDaddr_i(Write_reg) ,  
        .RDdata_i(Fin_data)  , 
        .RegWrite_i(RegWrite),
        .RSdata_o(rs_data) ,  
        .RTdata_o(rt_data)   
        );
	
Decoder Decoder(
        .instr_op_i(instr_o[32-1:26]), 
        .instr_fnc(instr_o[5:0]), 
	    .RegWrite_o(RegWrite), 
	    .ALUOp_o(ALUOp),   
	    .ALUSrc_o(ALUSrc),   
	    .RegDst_o(RegDst) ,
            .JUMP(JUMP),
            .BRANCH(BRANCH),
            .BRANCH_TYPE(BRANCH_TYPE),
            .MEM_W(MEM_W),
            .MEM_R(MEM_R),
            .MEM_to_REG(MEM_to_REG)
		);

ALU_Ctrl AC(
        .funct_i(instr_o[6-1:0]),   
        .ALUOp_i(ALUOp),   
        .ALU_operation_o(ALUCtrl),
		.FURslt_o(FURslt)
        );
	
Sign_Extend SE(
        .data_i(instr_o[15:0]),
        .data_o(sign_instr)
        );

Zero_Filled ZF(
        .data_i(instr_o[15:0]),
        .data_o(zero_instr)
        );
		
Mux2to1 #(.size(32)) ALU_src2Src(
        .data0_i(rt_data),
        .data1_i(sign_instr),
        .select_i(ALUSrc),
        .data_o(Src_ALU_Shifter)
        );	

Mux2to1 #(.size(5)) Shamt_Src(
        .data0_i(instr_o[10:6]),
        .data1_i(rs_data[5-1:0]),
        .select_i(ALUCtrl[1]),
        .data_o(ShamtSrc)
        );	

ALU ALU(
		.aluSrc1(rs_data),
	    .aluSrc2(Src_ALU_Shifter),
	    .ALU_operation_i(ALUCtrl),
		.result(result_ALU),
		.zero(zero),
		.overflow(overflow),
                .sign(sign),
                .sor_sign(sor_sign)
	    );

/*
Mux3to1 #(.size(1)) To_Branch(
        .data0_i(zero),
        .data1_i(~zero),
                .data2_i(sign),
        .select_i(BRANCH_TYPE),
        .data_o(Branch_col)
        );*/

Mux4to1 #(.size(1)) To_Branch(
        .data0_i(zero),
        .data1_i(~zero),
        .data2_i(sign),
        .data3_i(sor_sign),
        .select_i(BRANCH_TYPE),
        .data_o(Branch_col)
        );




/*
Mux2to1 #(.size(1)) To_Branch(
        .data0_i(zero),
        .data1_i(~zero),
        .select_i(BRANCH_TYPE),
        .data_o(Branch_col)
        );*/
Adder Adder2(
        .src1_i(add_pc),     
            .src2_i(sign_instr<<2),
            .sum_o(add_branch)    
            );

assign PCSrc = BRANCH & Branch_col;
		

Mux2to1 #(.size(32)) GO_Branch(
        .data0_i(add_pc),
        .data1_i(add_branch),
        .select_i(PCSrc),
        .data_o(select_branch)
        );
/*
Mux2to1 #(.size(32)) GO_Jump(
        .data0_i(select_branch),
        .data1_i({add_pc[31:28],instr_o[25:0],2'b00}),
        .select_i(JUMP),
        .data_o(next_addr)
        );*/


Mux3to1 #(.size(32)) GO_Jump(
        .data0_i(select_branch),
        .data1_i({add_pc[31:28],instr_o[25:0],2'b00}),
                .data2_i(Fin_data),
        .select_i(JUMP),
        .data_o(next_addr)
        );




Shifter shifter( 
		.result(result_Shifter), 
		.leftRight(ALUCtrl[0]),
		.shamt(ShamtSrc),
		.sftSrc(Src_ALU_Shifter) 
		);
		
Mux3to1 #(.size(32)) RDdata_Source(
        .data0_i(result_ALU),
        .data1_i(result_Shifter),
		.data2_i(zero_instr),
        .select_i(FURslt),
        .data_o(Write_Data)
        );	

Data_Memory DM(
        .clk_i(clk_i),
        .addr_i(Write_Data),
        .data_i(rt_data),
        .MemRead_i(MEM_R),
        .MemWrite_i(MEM_W), 
        .data_o(MEM_new_Data)
        );

/*
Mux2to1 #(.size(32)) Reg_Dest(
        .data0_i(Write_Data),
        .data1_i(MEM_new_Data),
        .select_i(MEM_to_REG),
        .data_o(Fin_data)
        );*/

Mux3to1 #(.size(32)) Reg_Dest(
        .data0_i(Write_Data),
        .data1_i(MEM_new_Data),
                .data2_i(add_pc),
        .select_i(MEM_to_REG),
        .data_o(Fin_data)
        );		

endmodule



