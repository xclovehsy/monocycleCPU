`timescale 1ns / 1ps


module datapath(
    input clk,          // 时钟信号
    input rst,          // 
    input [31:0] instr, //32位指�?
    input memtoreg,     //回写的数据来自于 ALU 计算的结�?/存储器读取的数据
    input pcsrc,        //回写的数据来自于 ALU 计算的结�?/存储器读取的数据
    input alusrc,       //送入 ALU B 端口的�?�是立即数的 32位扩�?/寄存器堆读取的�??
    input regdst,       //送入 ALU B 端口的�?�是立即数的 32位扩�?/寄存器堆读取的�??
    input regwrite,     //是否�?要写寄存器堆
    input jump,         //是否�? jump 指令        
    input [2:0] alucontrol,     //ALU 控制信号，代表不同的运算类型
    input [31:0] readdata,      //内存读取数据
    output zero,                //计算结果是否为零
    output [31:0] pc,           //pc
    output [31:0] aluout,       //alu计算结果
    output [31:0] writedata,     //写入内存数据
    output wire [31:0] result
    );

    wire [31:0] newpc1, newpc2, pcplus4;
    wire [31:0] pcbranch;
    wire [31:0] srcA, srcB;
    wire [4:0] writereg;           
    wire [31:0] signimm, signimm_sl2;
    // wire [31:0] result;             
    
    assign pcplus4 = pc + 32'h4;

    // 取指�?
    mux2 #(32) pc_mux1(.a(pcplus4), .b(pcbranch), .f(pcsrc), .c(newpc1));
    mux2 #(32) pc_mux2(.a(newpc1), .b({pcplus4[31:28], instr[25:0], 2'b00}), .f(jump), .c(newpc2));
    
    pc p(
        .clk(clk), 
        .rst(rst),
        .newpc(newpc2), 
        .pc(pc)
    );


    // 指令译码
    mux2 #(5) reg_mux(.a(instr[20:16]), .b(instr[15:11]), .f(regdst), .c(writereg));

    regfile rf( 
        .clk(clk),
        .we3(regwrite), 
        .ra1(instr[25:21]), 
        .ra2(instr[20:16]), 
        .wa3(writereg), 
        .wd3(result),
        .rd1(srcA), 
        .rd2(writedata)
    );

    assign signimm = {{16{instr[15]}}, instr[15:0]};
    sl2 sl2(.a(signimm), .y(signimm_sl2));
    adder branch_add(.a(signimm_sl2), .b(pcplus4), .y(pcbranch));


    // 计算执行
    mux2 #(32) src_mux(.a(writedata), .b(signimm), .f(alusrc), .c(srcB));
    alu #(32) alu(.A(srcA), .B(srcB), .F(alucontrol), .result(aluout));
    assign zero = aluout == 32'b0;
    

    // 内存访问

    // 回写
    mux2 #(32) result_mux(.a(aluout), .b(readdata), .f(memtoreg), .c(result));


endmodule