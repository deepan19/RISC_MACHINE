module ALU(Ain,Bin,ALUop,out,Z); //module for the ALU unit. 
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output [15:0] out;
    output reg [2:0] Z;

    reg [15:0] out;
    

    reg sub;
    wire [15:0] s;
    wire ovf;

    always@(*) begin
        if(ALUop==2'b00) 
            sub = 1'b0;
        else if(ALUop==2'b01) 
            sub = 1'b1;
        else
            sub = 1'bx;
    end
        
    OVFcheck check(Ain,Bin,sub,s,ovf);

    always@(*) begin
        case(ALUop) //This case statement determines the output based on what operation the ALUop suggests. 
            2'b00: out = Ain + Bin;
            2'b01: out = Ain - Bin;
            2'b10: out = Ain & Bin;
            2'b11: out = ~Bin;
            default: out = 2'bxx;
        endcase
    end

    always@(*) begin

        if(out==16'b0000000000000000) begin //THe case when the output is 0, set Z as 1, else set Z as 0.
            Z[0] = 1'b1;
        end
        else begin
            Z[0] = 1'b0;
        end
    end

    always@(*) begin

        if(out[15]==1'b1) begin
            Z[2] = 1'b1;
        end
        else begin
            Z[2] = 1'b0;
        end
    end

    always@(*) begin

        if(ovf==1'b1) begin
            Z[1] = 1'b1;
        end
        else begin
            Z[1] = 1'b0;
        end
    end
    
endmodule

module OVFcheck(a,b,sub,s,ovf);
    parameter n = 16;
    input [n-1:0] a,b;
    input sub;
    output [n-1:0] s;
    output ovf;

    wire c1,c2;
    assign ovf = c1 ^ c2;

    Adder1 #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]);
    Adder1 #(1) as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]);
endmodule

module Adder1(a,b,cin,cout,s);
    parameter n = 16;
    input [n-1:0] a,b;
    input cin;
    output [n-1:0] s;
    output cout;
    wire [n-1:0] s;
    wire cout;

    assign {cout,s} = a + b + cin;
endmodule 



