module ALU_1bit( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ); 
  
  output result;
  output wire carryOut;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  wire w1, w2;
  wire res;
  wire temp1, temp2;

  xor X1(w1, a, invertA);
  xor X2(w2, b, invertB);
  and A1(temp1, w1, w2);
  or O1(temp2, w1, w2);

  Full_adder F1(res, carryOut, carryIn, w1, w2);
  reg temp_res;
  always @(*)
    begin
      case(operation)
        2'b00: temp_res = temp2;
        2'b01: temp_res = temp1;
        2'b10: temp_res = res;
        2'b11: temp_res = less;
      endcase
    end
  assign result = temp_res;
endmodule



module ALU_1bit_top( result, carryOut, a, b, invertA, invertB, operation, carryIn, less ,set, overflow); 
  
  output wire result;
  output wire carryOut;
  output wire set, overflow;
  
  input wire a;
  input wire b;
  input wire invertA;
  input wire invertB;
  input wire[1:0] operation;
  input wire carryIn;
  input wire less;
  
  /*your code here*/ 
  wire w1, w2;
  wire temp1, temp2;

  xor X1(w1, a, invertA);
  xor X2(w2, b, invertB);
  and A1(temp1, w1, w2);
  or O1(temp2, w1, w2);

  Full_adder F1(set, carryOut, carryIn, w1, w2);
  xor X3(overflow, carryIn, carryOut);

  reg temp_res;
  always @(*)
    begin
      case(operation)
        2'b00: temp_res = temp1;
        2'b01: temp_res = temp2;
        2'b10: temp_res = set;
        2'b11: temp_res = less;
      endcase
    end
  assign result = temp_res;
endmodule