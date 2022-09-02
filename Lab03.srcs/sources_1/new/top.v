`timescale 1ns / 1ps


module top(
	input wire clk,rst,
	output wire[31:0] writedata,dataadr,
	output wire memwrite,
	output [31:0] pc, instr,
	
	output wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,
	output wire [2:0] alucontrol,
	output wire [31:0] result,
	output wire [31:0] readdata
    );
	// wire clk;
	// wire [31:0] pc,instr,readdata;
//	wire [31:0] readdata;

	//   clk_div instance_name(
 //    	// Clock out ports
	//     .clk_out1(hclk),     // output clk_out1
	//    // Clock in ports
	//     .clk_in1(clk)
 //    	); 
   	wire lclk;
	clk_div #(5, 5) div(.clk(clk), .rst(rst), .clk_out(lclk));

	mips mips(lclk,rst,pc,instr,memwrite,dataadr,writedata,readdata,memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,alucontrol, result);

	inst_mem imem(
		.clka(clk),
		.ena(1'b1), 
		.addra(pc/4), 
		.douta(instr)
	);

	data_mem dmem(
		.clka(clk),
		.ena(1'b1), 
		.wea(memwrite),
		.addra(dataadr),
		.dina(writedata),
		.douta(readdata)
	);

endmodule
