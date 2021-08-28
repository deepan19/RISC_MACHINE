module cpu_tb();
    reg clk,reset,s,load;
    reg [15:0] in;
    wire [15:0] out;
    wire N,V,Z,w;
    reg err;

    
    cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);

   initial begin //clock oscillates forever.
    clk = 0; #5;
    forever begin
        clk = 1; #5;
        clk = 0; #5;
    end
    end

    initial begin
        err=1'b0;
        in = 16'b1101000000000011; //this block checks instruction 1. wrtites immediate value 3 into R
        s=1'b1;
        load=1'b1;
        reset=1'b0;
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R0 !== 16'h3) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1101000100000010; //this block checks instruction 1. wrtites immediate value 2 into R
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R1 !== 16'h2) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1100000001101001; //this block checks instruction 2. shifts value of 2 left by 1 bit.
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'h4) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1010000001100001; //this block checks instruction 3. tests ADD instruction by using R values written by previous writeimm blocks. 
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R3 !== 16'h5) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1101010100000111; //this block writes immmediate value 7 into R for further testing of other instructions. 
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R5 !== 16'h7) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1010100000000101; //this block checks instruction CMP . a negative value is attained and checks if the N flag is raised. 
        #100;
        reset = 1'b1;
        #15;
        reset=1'b0;
        in = 16'b1011001110000000; //this block checks instruction AND. bitwise and and should result in the value 1. 
         #100;
         if (cpu_tb.DUT.DP.REGFILE.R4 !== 16'h1) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
        reset = 1'b1;
        #15;
        reset = 1'b0;
        in = 16'b1011100011100000; //this block checks instruction MVN. The ngation of 3 in bits is expected. 
        #100;
        if (cpu_tb.DUT.DP.REGFILE.R7 !== 16'b1111111111111100) begin
        err = 1;
        $display("FAILED");
        $stop;
        end
    end

endmodule