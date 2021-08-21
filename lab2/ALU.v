module ALU( result, zero, overflow, aluSrc1, aluSrc2, invertA, invertB, operation );
   
  output wire[31:0] result;
  output wire zero;
  output wire overflow;

  input wire[31:0] aluSrc1;
  input wire[31:0] aluSrc2;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  
  wire[31:0] carryout;
  wire set;
  wire[31:0] andres;
  wire dummy;
  /*your code here*/

  ALU_1bit B1(result[0], carryout[0], aluSrc1[0], aluSrc2[0], invertA, invertB, operation, invertB, set);
  
  genvar i;
  generate
    for(i=1; i<31; i=i+1)
      begin
        ALU_1bit B1(result[i], carryout[i], aluSrc1[i], aluSrc2[i], invertA, invertB, operation, carryout[i-1], 1'b0);
      end
  endgenerate
	ALU_1bit_top B2( result[31], carryout[31], aluSrc1[31], aluSrc2[31], invertA, invertB, operation, carryout[30], 1'b0 ,set, overflow);

  
  or OO1(andres[2], result[0], result[1]);
  generate
    for(i=2; i<31; i=i+1)
      begin
        or O1(andres[i+1], andres[i], result[i]);
      end
  endgenerate
  or O2(dummy, andres[31], result[31]);
  not N1(zero, dummy);

endmodule