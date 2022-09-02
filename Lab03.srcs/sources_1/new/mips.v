`timescale 1ns / 1ps


module mips(
	input wire clk,rst,
	output wire[31:0] pc,
	input wire[31:0] instr,
	output wire memwrite,
	output wire[31:0] aluout,writedata,
	input wire[31:0] readdata,
	output wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,
	output wire [2:0] alucontrol,
	output [31:0] result
    );
	
//	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero; //,overflow;
//	wire[2:0] alucontrol;

	// 控制器模�?
	controller c(
		.inst(instr),
		.zero(zero),
		.jump(jump),
		.alusrc(alusrc),
		.memwrite(memwrite),
		.memtoreg(memtoreg),
		.regwrite(regwrite),
		.regdst(regdst),
		.alucontrol(alucontrol),
		.pcsrc(pcsrc)
	);

	datapath dp(
		.clk(clk),
		.rst(rst),
		.memtoreg(memtoreg),
		.pcsrc(pcsrc),
		.alusrc(alusrc),
		.regdst(regdst),
		.regwrite(regwrite),
		.jump(jump),
		.alucontrol(alucontrol),
		// .overflow(overflow),
		.zero(zero),
		.pc(pc),
		.instr(instr),
		.aluout(aluout),
		.writedata(writedata),
		.readdata(readdata),
		.result(result)
	);
	
endmodule
