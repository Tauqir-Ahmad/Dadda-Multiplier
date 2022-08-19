// implementation of 8*8 dadda multiplier with csa
//results maybe different then, but we aren't considering that
`timescale 1ps/1ps

module dadda(a,b,result);
input [7:0]a,b;
output [15:0] result;
wire [7:0] pp1;
wire [8:1] pp2;
wire [9:2] pp3;
wire [10:3] pp4;
wire [11:4] pp5;
wire [12:5] pp6;
wire [13:6] pp7;
wire [14:7] pp8;
assign pp1=a*b[0];// partial product row generated.
assign pp2=a*b[1];// partial product row generated.
assign pp3=a*b[2];// partial product row generated.
assign pp4=a*b[3];// partial product row generated.
assign pp5=a*b[4];// partial product row generated.
assign pp6=a*b[5];// partial product row generated.
assign pp7=a*b[6];// partial product row generated.
assign pp8=a*b[7];// partial product row generated.
wire s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24,s25,s26,s27,s28,s29,s30,s31,s32,s33,s34,s35,s36,s37,s38,s39,s40,s41,s42;
wire c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14,c15,c16,c17,c18,c19,c20,c21,c22,c23,c24,c25,c26,c27,c28,c29,c30,c31,c32,c33,c34,c35,c36,c37,c38,c39,c40,c41,c42;

// si means sum from the ith full/half adder
//ci means the carry from ith full/half adder
/****************************************************/
//reduction stage 1

HA f1(pp1[6],pp2[6],s1,c1);
FA f2(pp1[7],pp2[7],pp3[7],s2,c2);
HA f3(pp4[7],pp5[7],s3,c3);
FA f4(pp2[8],pp3[8],pp4[8],s4,c4);
HA f5(pp5[8],pp6[8],s5,c5);
FA f6(pp3[9],pp4[9],pp5[9],s6,c6);


/********************************************************/
/****************************************************/
//reduction stage 2

HA f7(pp1[4],pp2[4],s7,c7);
FA f8(pp1[5],pp2[5],pp3[5],s8,c8);
HA f9(pp4[5],pp5[5],s9,c9);
FA f10(s1,pp3[6],pp4[6],s10,c10);
FA f11(pp5[6],pp6[6],pp7[6],s11,c11);
FA f12(s2,c1,s3,s12,c12);
FA f13(pp6[7],pp7[7],pp8[7],s13,c13);
FA f14(s4,c2,s5,s14,c14);
FA f15(c3,pp7[8],pp8[8],s15,c15);
FA f16(s6,c4,c5,s16,c16);
FA f17(pp6[9],pp7[9],pp8[9],s17,c17);
FA f18(c6,pp4[10],pp5[10],s18,c18);
FA f19(pp6[10],pp7[10],pp8[10],s19,c19);
FA f20(pp5[11],pp6[11],pp7[11],s20,c20);
/****************************************************/
/****************************************************/
//reduction stage 3

HA f21(pp1[3],pp2[3],s21,c21);
FA f22(s7,pp3[4],pp4[4],s22,c22);
FA f23(s8,c7,s9,s23,c23);
FA f24(s10,c8,s11,s24,c24);
FA f25(s12,c10,s13,s25,c25);
FA f26(s14,c12,s15,s26,c26);
FA f27(s16,c14,s17,s27,c27);
FA f28(s18,c16,s19,s28,c28);
FA f29(s20,c18,c19,s29,c29);
FA f30(pp6[12],pp7[12],pp8[12],s30,c30);

/****************************************************/
/****************************************************/
//reduction stage 4

HA f31(pp1[2],pp2[2],s31,c31);
FA f32(s21,pp3[3],pp4[3],s32,c32);
FA f33(s22,c21,pp5[4],s33,c33);
FA f34(s23,c22,pp6[5],s34,c34);
FA f35(s24,c23,c9,s35,c35);
FA f36(s25,c24,c11,s36,c36);
FA f37(s26,c25,c13,s37,c37);
FA f38(s27,c26,c15,s38,c38);
FA f39(s28,c27,c17,s39,c39);
FA f40(s29,c28,pp8[11],s40,c40);
FA f41(s30,c29,c20,s41,c41);
FA f42(c30,pp7[13],pp8[13],s42,c42);

/****************************************************/

//now generating the final two rows to be passed to the csa
//doing a 15 bit addition. Confirm by looking at Dinesh Sir's diagram.
wire[14:0] x1;
wire [14:0] x2;
assign x1[0]=pp1[0];
assign x1[1]=pp1[1];
assign x1[13:2]={s42,s41,s40,s39,s38,s37,s36,s35,s34,s33,s32,s31};
assign x1[14]=pp8[14];

assign x2[14:3]={c42,c41,c40,c39,c38,c37,c36,c35,c34,c33,c32,c31};
assign x2[2]=pp3[2];
assign x2[1]=pp2[1];
assign x2[0]=0;
gp g1(x1,x2,result);
endmodule

module FA
(
 input x,
 input y,
 input cin,
 
 output A, 
 output cout
 );
 wire t1,t2,t3;
    xor #30 (A,x,y,cin);
  and(t1,x,y);
  and(t2,cin,x);
  and(t3,cin,y);
  or #10 (cout,t1,t2,t3);

 
endmodule
module gp(a,b,result);
input [14:0] a,b;
output [15:0] result;

four_bit_ripple_carry r(a[3:0],b[3:0],0,result[3:0],c1);
five_bit_ripple_carry r1(a[8:4],b[8:4],c1,c2,result[8:4]);
six_bit_ripple_carry r2(a[14:9],b[14:9],c2,result[15],result[14:9]);

endmodule

module four_bit_ripple_carry(a,b,cin,sum,cout); //first stage doesn't need any select line and muxes
wire t1,t2,t3;
input [3:0] a,b;
  output [3:0]sum;
  input cin;
output cout;
FA f1(a[0],b[0],cin,sum[0],t1);
FA f2(a[1],b[1],t1,sum[1],t2);
FA f3(a[2],b[2],t2,sum[2],t3);
FA f4(a[3],b[3],t3,sum[3],cout);
endmodule

module five_bit_ripple_carry(a,b,cin,c_out,result);
input [4:0] a,b;
  output [4:0] result;
  input cin;
output c_out;
wire t1,t2,t3,t4,cout,cout1;
wire t5,t6,t7,t8;
wire [4:0] sum,sum1;
FA f1(a[0],b[0],0,sum[0],t1);
FA f2(a[1],b[1],t1,sum[1],t2);
FA f3(a[2],b[2],t2,sum[2],t3);
FA f4(a[3],b[3],t3,sum[3],t4);
FA f5(a[4],b[4],t4,sum[4],cout);

FA f6(a[0],b[0],1,sum1[0],t5);
FA f7(a[1],b[1],t5,sum1[1],t6);
FA f8(a[2],b[2],t6,sum1[2],t7);
FA f9(a[3],b[3],t7,sum1[3],t8);
FA f10(a[4],b[4],t8,sum1[4],cout1);

assign #20 result=cin?sum1:sum;
assign #20 c_out=cin?cout1:cout;

endmodule

module six_bit_ripple_carry(a,b,cin,c_out,result);
wire t1,t2,t3,t4,t5,cout,cout1;
input [5:0] a,b;
input cin;
output c_out;
  output[5:0] result;
wire [5:0] sum,sum1;
wire t6,t7,t8,t9,t10;
FA f1(a[0],b[0],0,sum[0],t1);
FA f2(a[1],b[1],t1,sum[1],t2);
FA f3(a[2],b[2],t2,sum[2],t3);
FA f4(a[3],b[3],t3,sum[3],t4);
FA f5(a[4],b[4],t4,sum[4],t5);
FA f6(a[5],b[5],t5,sum[5],cout);

FA f7(a[0],b[0],1,sum1[0],t6);
FA f8(a[1],b[1],t1,sum1[1],t7);
FA f9(a[2],b[2],t2,sum1[2],t8);
FA f10(a[3],b[3],t3,sum1[3],t9);
FA f11(a[4],b[4],t4,sum1[4],t10);
FA f12(a[5],b[5],t5,sum1[5],cout1);

assign #20 result=cin?sum1:sum;
assign #20 c_out=cin?cout1:cout;
endmodule
module HA(a,b,sum,cout);
input a,b;
output sum,cout;
   xor  #60 (sum,a,b);
    and #50 (cout,a,b);
endmodule
