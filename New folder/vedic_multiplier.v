module ha(a,b,s,c);
//ha - half adder || a,b - inputs || s - sum || c - carry
input a,b;
output s,c;
////declaring data modelling
    xor(s,a,b);
    and(c,a,b);
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module sba(a,b,sum);
//sba - six bit adder || a,b - inputs || sum - outputs
input [5:0] a,b;
output [5:0] sum;
////declaring data modelling
     assign sum = a+b;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ddba(a,b,sum);
//sba - duodecimal bit adder || a,b - inputs || sum - outputs
input [11:0] a,b;
output [11:0] sum;
////declaring data modelling
     assign sum = a+b;
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module tbm(a,b,ma);
//tbm - two bit multiplier || a,b - two bit inputs || ma - four bit output(multiplicative answer)
input [1:0] a;
input [1:0] b;
output [3:0] ma;
wire [2:0] and_values;
wire  carry;
/////declaring data modelling
    and(ma[0],a[0],b[0]);//this is output ma[0]
    and(and_values[0],a[1],b[0]);
    and(and_values[1],a[0],b[1]);
    and(and_values[2],a[1],b[1]);
    ha z1(and_values[0],and_values[1],ma[1],carry);//ma1 the seccond bit output and carry obtained
    ha z2(and_values[2],carry,ma[2],ma[3]);//ma2 and ma3 the final bits of output are obtained
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module fbm(a,b,ma);
//fbm - four bit multiplier || a,b- four bit inputs || ma - eight bit (multiplicative output)
input [3:0] a;
input [3:0] b;
output [7:0] ma;
wire [15:0] quotient_values;
wire [15:0] adding_values;
wire [3:0] concatinate;
wire [5:0] final_concatinate;
wire [5:0] final_adding;
/////declaring data modelling
     tbm z1(a[1:0],b[1:0],quotient_values[3:0]);
     tbm z2(a[3:2],b[1:0],quotient_values[7:4]);
     tbm z3(a[1:0],b[3:2],quotient_values[11:8]);
     tbm z4(a[3:2],b[3:2],quotient_values[15:12]);
     assign ma[1:0] = quotient_values[1:0];
     assign concatinate[3:0] = {2'b0,quotient_values[3:2]};
////quotient of last two bits
     assign adding_values[3:0] = quotient_values[7:4]+concatinate[3:0];
     assign adding_values[9:4] = {2'b0,quotient_values[11:8]};
     assign adding_values[15:10] = {quotient_values[15:12],2'b0};
////so finally we should add all three above statements by 6 bit adder
     sba g1(adding_values[15:10],adding_values[9:4],final_adding[5:0]);
     assign final_concatinate[5:0] = {2'b0,adding_values[3:0]};
     sba g2(final_concatinate[5:0],final_adding[5:0],ma[7:2]);
////The last values are also given to quotient
endmodule
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////// MAIN MODULE OR FINAL MODULE ///////////////////////////////////////////////////////////////////
module ebm(a,b,ma);
//ebm - eight bit multiplier || a,b- eight bit inputs || ma - sixteen bit (multiplicative output)
input [7:0] a;
input [7:0] b;
output [15:0] ma;
wire [31:0] quotient_values;
wire [31:0] adding_values;
wire [7:0] concatinate;
wire [11:0] final_concatinate;
wire [11:0] final_adding;
/////declaring data modelling
     fbm z1(a[3:0],b[3:0],quotient_values[7:0]);
     fbm z2(a[7:4],b[3:0],quotient_values[15:8]);
     fbm z3(a[3:0],b[7:4],quotient_values[23:16]);
     fbm z4(a[7:4],b[7:4],quotient_values[31:24]);
     assign ma[3:0] = quotient_values[3:0];
     assign concatinate[7:0] = {4'b0,quotient_values[7:4]};
////quotient of last two bits
     assign adding_values[7:0] = quotient_values[15:8]+concatinate[7:0];
     assign adding_values[19:8] = {4'b0,quotient_values[23:16]};
     assign adding_values[31:20] = {quotient_values[31:24],4'b0};
////so finally we should add all three above statements by 6 bit adder
     ddba g1(adding_values[19:8],adding_values[31:20],final_adding[11:0]);
     assign final_concatinate[11:0] = {4'b0,adding_values[7:0]};
     ddba g2(final_concatinate[11:0],final_adding[11:0],ma[15:4]);
////The last values are also given to quotient
endmodule
