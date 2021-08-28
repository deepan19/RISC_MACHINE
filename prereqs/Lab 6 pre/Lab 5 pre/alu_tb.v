module ALU_tb();

reg [15:0] Ain,Bin;
reg [1:0] ALUop;
wire Z;
wire [15:0] out;
reg err;

ALU DUT(Ain,Bin,ALUop,out,Z); //instantiating ALU module as DUT.

task my_checker;
    input [15:0] expected_out; //ALU has two outputs, out and Z, hence adding both for self checking. 
    input expected_Z;

    begin
        if(expected_out!==out)begin
             $display("ERROR ** actual:%b, expected:%b",out,expected_out); //if out doesnt match expected out, set error to 1.
            err = 1'b1;
        end
        if(expected_Z!==Z)begin
             $display("ERROR ** actual:%b, expected:%b",Z,expected_Z); //if expected Z and Z dont match sent error to 1.
            err = 1'b1;
        end
    end
endtask

initial begin
    err=1'b0; //initializing error to 0 at start. 
    Ain = 16'b0000000000000010; //This block checks the addition operation.
    Bin = 16'b0000000000000100;
    ALUop = 2'b00;
    #5;
    my_checker(16'b0000000000000110,1'b0); //self checker is called to verify output. 
    #5;

    
    Ain = 16'b0000000000000100; //This block checks the subtraction operation.
    Bin = 16'b0000000000000010;
    ALUop = 2'b01;
    #5;
    my_checker(16'b0000000000000010,1'b0);
    #5;

   
    Ain = 16'b0000000000000100; //This block checks the bitwise and operation.
    Bin = 16'b0000000000000100;
    ALUop = 2'b10;
    #5;
    my_checker(16'b0000000000000100,1'b0);
    #5;

    
    Ain = 16'b0000000000000010; //This block checks the negation of Bin  operation.
    Bin = 16'b0000000000000100;
    ALUop = 2'b11;
    #5;
    my_checker(16'b1111111111111011,1'b0);
    #5;

   
    Ain = 16'b0000000000000010; //Block checks if Z value is set to 1 when two same numbers subtract and give output as 0.
    Bin = 16'b0000000000000010;
    ALUop = 2'b01;
    #5;
    my_checker(16'b0000000000000000,1'b1);
    #5;
     if(~err) $display("PASSED"); //if error is 0, print passed.
end

endmodule