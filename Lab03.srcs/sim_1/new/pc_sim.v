`timescale 1ns / 1ps

module pc_sim();
    reg clk;
    reg rst;
    reg [31:0] new_pc;
    wire [31:0] pc;
    

    initial begin
        clk = 1'b0; 
        rst = 1'b0;
        new_pc = 32'h10;
        
        repeat(10) @(posedge clk);
        @(posedge clk) rst = 1'b1;
        repeat(5) @(posedge clk);
        @(posedge clk) rst = 1'b0;
        repeat(100) @(posedge clk);
        $finish;
    end

    always #5 new_pc = pc+32'h4;
    always #5 clk = ~clk;
//    adder #(32)(.a(pc), .b())

   pc p(
        .clk(clk),
        .rst(rst), 
        .newpc(new_pc), 
        .pc(pc)
   );
endmodule
