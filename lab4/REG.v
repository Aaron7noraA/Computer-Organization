module IF_ID_REG(clk_i, rst_n, instruction_in, instruction_out);
input clk_i;
input rst_n;
input [31:0] instruction_in;

output [31:0] instruction_out;
reg [31:0] instruction_out;

always @(posedge clk_i or negedge rst_n) begin
    if(~rst_n) begin
	    instruction_out <= 32'b0;    	
    end

	else
		begin
			instruction_out <= instruction_in;			
		end

end
endmodule 



module ID_EX_REG(clk_i, rst_n, WD_in, WD_out, M_in, M_out, EXE_in, EXE_out, RS_data_in, RS_data_out, RT_data_in, RT_data_out, SE_in, SE_out, Zero_in, Zero_out, instr_s_in, instr_s_out, alu_ctr_in, alu_ctr_out, RT_dest_in, RT_dest_out, RD_dest_in, RD_dest_out);
input clk_i;
input rst_n;
input [1:0] WD_in;
input [1:0] M_in;
input [4:0]  instr_s_in, RD_dest_in, RT_dest_in;
input [5:0] alu_ctr_in;
input [4:0] EXE_in;
input [31:0] RS_data_in, RT_data_in, SE_in, Zero_in;


output [1:0] WD_out;
output [1:0] M_out;
output [4:0] instr_s_out, RD_dest_out, RT_dest_out;
output [5:0] alu_ctr_out;
output [4:0] EXE_out;
output [31:0] RS_data_out, RT_data_out, SE_out, Zero_out;

reg [1:0] WD_out;
reg [1:0] M_out;
reg [4:0] instr_s_out, RD_dest_out, RT_dest_out;
reg [5:0] alu_ctr_out;
reg [4:0] EXE_out;
reg [31:0] RS_data_out, RT_data_out, SE_out, Zero_out;

always @(posedge clk_i or negedge rst_n) begin
    if(~rst_n) begin
		WD_out <= 3'b0;
		M_out <= 3'b0;
		EXE_out <= 7'b0;
		instr_s_out <= 5'b0;
		RD_dest_out <= 5'b0;
		RT_dest_out <= 5'b0;
		alu_ctr_out <= 6'b0;
		RS_data_out <= 32'b0;
		RT_data_out <= 32'b0;
		SE_out <= 32'b0;
		Zero_out <= 32'b0;
    end
    else begin
		WD_out <= WD_in;
		M_out <= M_in;
		EXE_out <= EXE_in;
		instr_s_out <= instr_s_in;
		RD_dest_out <= RD_dest_in;
		RT_dest_out <= RT_dest_in;
		alu_ctr_out <= alu_ctr_in;
		RS_data_out <= RS_data_in;
		RT_data_out <= RT_data_in;
		SE_out <= SE_in;
		Zero_out <= Zero_in;    	
    end
	
end
endmodule




module EXE_MEM_REG (clk_i, rst_n, WB_in, WB_out, M_in, M_out, ALU_res_in, ALU_res_out, RT_data_in, RT_data_out, REG_dest_in, REG_dest_out);
input clk_i;
input rst_n;
input [1:0] WB_in;
input [1:0] M_in;
input [31:0] ALU_res_in, RT_data_in;
input [4:0] REG_dest_in;


output [1:0] WB_out;
output [1:0] M_out;
output [31:0] ALU_res_out, RT_data_out;
output [4:0] REG_dest_out;

reg [1:0] WB_out;
reg [1:0] M_out;
reg [31:0] ALU_res_out, RT_data_out;
reg [4:0] REG_dest_out;

always @(posedge clk_i or negedge rst_n) begin
    if(~rst_n) begin
		WB_out <= 3'b0;
		M_out <= 3'b0;
		ALU_res_out <= 32'b0;
		RT_data_out <= 32'b0;
		REG_dest_out <= 5'b0;
    end
    else begin
		WB_out <= WB_in;
		M_out <= M_in;
		ALU_res_out <= ALU_res_in;
		RT_data_out <= RT_data_in;
		REG_dest_out <= REG_dest_in;    	
    end

end
endmodule 


module M_WB_REG(clk_i, rst_n, WB_in, WB_out, MEM_in, MEM_out, ALU_res_in, ALU_res_out, REG_dest_in, REG_dest_out);
input clk_i;
input rst_n;
input [1:0] WB_in;
input [31:0] MEM_in;
input [31:0] ALU_res_in;
input [4:0]REG_dest_in;



output [1:0] WB_out;
output [31:0] MEM_out;
output [31:0] ALU_res_out;
output [4:0] REG_dest_out;
reg [1:0] WB_out;
reg [31:0] MEM_out;
reg [31:0] ALU_res_out;
reg [4:0] REG_dest_out;

always @(posedge clk_i or negedge rst_n) begin
    if(~rst_n) begin
		WB_out <= 3'b0;
		MEM_out <= 32'b0;
		ALU_res_out <= 32'b0;
		REG_dest_out <= 32'b0;
    end
    else begin
		WB_out <= WB_in;
		MEM_out <= MEM_in;
		ALU_res_out <= ALU_res_in;
		REG_dest_out <= REG_dest_in;	   	
    end

end



endmodule