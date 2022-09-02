`timescale 1ns / 1ps


module controller(
        input [31:0] inst,
        input zero,
        output jump,        
        output alusrc,    
        output memwrite,    
        output memtoreg,    
        output regwrite,    
        output regdst,    
        output [2:0] alucontrol,    
        output pcsrc
    );

    wire [1:0] aluop;
    wire branch;
    assign pcsrc = zero & branch;

    maindec main_control(
        .op(inst[31:26]), 
        .control_sig({jump, regwrite, regdst, alusrc, branch, memwrite, memtoreg, aluop})    
    );

    aludec alu_dec(
        .funct(inst[5:0]),
        .aluop(aluop),
        .alucontrol(alucontrol)
    );
    
endmodule
