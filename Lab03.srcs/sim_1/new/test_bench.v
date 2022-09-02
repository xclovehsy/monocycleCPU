`timescale 1ns / 1ps


module test_bench();
	reg clk;
	reg rst;
	
	wire [31:0] pc, instr;
	wire [5:0] rs, rt, rd;
//	wire memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero;
//	wire [2:0] alucontrol;
	wire[31:0] writedata,dataadr;
	wire memwrite;
	wire [31:0] result;
	wire [31:0] readdata;
	
	assign rs = instr[25:21];
	assign rt = instr[20:16];
    assign rd = instr[15:11];
	

//	top dut(clk,rst,writedata,dataadr,memwrite, pc, instr, memtoreg,alusrc,regdst,regwrite,jump,pcsrc,zero,alucontrol);

	top dut(
	       .clk(clk),
	       .rst(rst),
	       .pc(pc),
	       .instr(instr),
	       .writedata(writedata),
	       .dataadr(dataadr),
	       .memwrite(memwrite),
	       .result(result),
	       .readdata(readdata)     
	);


	initial begin 
	   clk = 1'b0;
	   rst = 1'b1;
	   #20 rst = 1'b0;
	end

	always #5 clk = ~clk;

	always @(negedge clk) begin
		if(memwrite) begin
			/* code */
			if(dataadr === 84 & writedata === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(dataadr !== 80) begin
				/* code */
				$display("Simulation Failed");
//				$stop;
			end
		end
	end
endmodule
