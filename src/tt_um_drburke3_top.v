/*
 * Copyright (c) 2024 Daniel Burke
 * SPDX-License-Identifier: Apache-2.0
 */

`timescale 1ns / 1ps
`default_nettype none

module tt_um_drburke3_top (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  /// assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

sklansky_adder_8bit diff_1(
.a      (ui_in[7:0]),   // input a
.sum    (uo_out[7:0]),  // addition out
.b      (uio_in[7:0]),  // input b
.enable (ena),          // will go high when the design is enabled
.clock  (clk),          // clock
.reset_n  (rst_n)       // reset 
);

endmodule


//////////////////////////////////////////////////////////////////////////////////
// Company: Berkeley Neuromorphic
// Engineer: Daniel Burke
// 
// Create Date: 09/14/2022 10:16:27 AM
// Design Name: 
// Module Name: sklansky_adder_8bit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 8-bit generated fast adder with black, gray, and generate-propagate included at bottom
//		naming changed, truncated at 8-bits, and 'multiple packed array wires' error fixed.
// 
// Dependencies: self-contained
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// from fluffybird2323 generator
// https://github.com/fluffybird2323/n-bit-sklansky-adder-code-generator-notebook/blob/master/README.Black
//////////////////////////////////////////////////////////////////////////////////


/* Generated 8 bit sklansky adder 
In this adder, binary tree of propagate and generate 
cells will first simultaneously generate all the carries, Cin. 
It builds recursively 2-bit adders then 4-bit adders, 8-bit adders, 
16-bit adder and so on by abutting each time two smaller adders. 
*/

module sklansky_adder_8bit(a,b,sum,enable,clock,reset_n);
input [7:0] a;
input [7:0] b;
output reg [7:0] sum;
input  enable;
input  clock;
input  reset_n;

// declare array wires
wire [8:0] g [8:0];
wire [8:0] p [8:0];

assign g[0][0]=1'b0;
assign p[0][0]=1'b0;
	
	generate_propagate GeneratePropagate_00(a[0],b[0],g[1][1],p[1][1]);
	generate_propagate GeneratePropagate_01(a[1],b[1],g[2][2],p[2][2]);
    generate_propagate GeneratePropagate_02(a[2],b[2],g[3][3],p[3][3]);
	generate_propagate GeneratePropagate_03(a[3],b[3],g[4][4],p[4][4]);
	generate_propagate GeneratePropagate_04(a[4],b[4],g[5][5],p[5][5]);
	generate_propagate GeneratePropagate_05(a[5],b[5],g[6][6],p[6][6]);
	generate_propagate GeneratePropagate_06(a[6],b[6],g[7][7],p[7][7]);
	generate_propagate GeneratePropagate_07(a[7],b[7],g[8][8],p[8][8]);

/// nomenclature is first number is clock level (1 is highest)
/// nomenclature is second number is bit position (0 is rightmost)

/// Level 1:	
	gray_cell GrayCell_1_1(g[1][1],p[1][1],g[0][0],g[1][0]);
	black_cell BlackCell_1_3(g[3][3],p[3][3],g[2][2],p[2][2],g[3][2],p[3][2]);
	black_cell BlackCell_1_5(g[5][5],p[5][5],g[4][4],p[4][4],g[5][4],p[5][4]);
	black_cell BlackCell_1_7(g[7][7],p[7][7],g[6][6],p[6][6],g[7][6],p[7][6]);
	
/// Level 2:
	gray_cell grayCell_2_2(g[2][2],p[2][2],g[1][0],g[2][0]);
	gray_cell grayCell_2_3(g[3][2],p[3][2],g[1][0],g[3][0]);
	black_cell BlackCell_2_6(g[6][6],p[6][6],g[5][4],p[5][4],g[6][4],p[6][4]);
	black_cell BlackCell_2_7(g[7][6],p[7][6],g[5][4],p[5][4],g[7][4],p[7][4]);
	
/// Level 3:
	gray_cell GrayCell_3_4(g[4][4],p[4][4],g[3][0],g[4][0]);
	gray_cell grayCell_3_5(g[5][4],p[5][4],g[3][0],g[5][0]);
	gray_cell grayCell_3_6(g[6][4],p[6][4],g[3][0],g[6][0]);
	gray_cell grayCell_3_7(g[7][4],p[7][4],g[3][0],g[7][0]);
	
/// Level 4: (if carry out needed)
///	gray cell_4_8(g[8][8],p[8][8],g[7][0],g[8][0]);

always @(posedge clock)
begin
	if(reset_n == 1'b0)
        begin
            sum <= 8'b00000000;      
        end 
	else if(enable == 1'b1)
        begin
           	sum[0] <= g[0][0]^p[1][1];
		    sum[1] <= g[1][0]^p[2][2];
	       	sum[2] <= g[2][0]^p[3][3];
	      	sum[3] <= g[3][0]^p[4][4];
	       	sum[4] <= g[4][0]^p[5][5];
	       	sum[5] <= g[5][0]^p[6][6];
	       	sum[6] <= g[6][0]^p[7][7];
	       	sum[7] <= g[7][0]^p[8][8];   
    end 
end
	
endmodule

// Generate Propagate code
module generate_propagate(A,B,G,P);
input A,B;
output G,P;
assign G = A&B;
assign P = A^B;
endmodule

// Gray module code
module gray_cell(G4_3,P4_3,G2_2,G4_2);
  input G4_3,P4_3,G2_2;
  output G4_2;
  wire signal;
  assign signal = P4_3 & G2_2;
  assign G4_2=signal | G4_3;
endmodule

// Black module code
module black_cell(G6_8,P6_8,G7_10,P7_10,G6_10,P6_10);
  input G6_8,P6_8,G7_10,P7_10;
  output G6_10,P6_10;
  wire signal;
  assign signal = P6_8 & G7_10;
  assign G6_10=signal | G6_8;
  assign P6_10=P6_8 & P7_10;
endmodule
