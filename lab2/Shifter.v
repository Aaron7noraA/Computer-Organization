module Shifter( result, leftRight, shamt, sftSrc  );
    
  output wire[31:0] result;
  input wire leftRight;
  input wire[4:0] shamt;
  input wire[31:0] sftSrc ;
  reg[31:0] temp1;
  
  /*your code here*/ 

  always @(*)
  	begin
  		case(leftRight)
  			1'b0:temp1[31:0] = sftSrc[31:0]>>shamt;					
  			1'b1:temp1[31:0] = sftSrc[31:0]<<shamt;
  		endcase
  	end
  	assign result[31:0] = temp1[31:0];



endmodule