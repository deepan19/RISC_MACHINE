module shifter_tb();
reg [15:0] in;
reg [1:0] shift;
wire [15:0] sout;
reg err;

shifter DUT(in,shift,sout); //instantiate shifter module as DUT.

task checker;
    input [15:0] expected_sout;

     if(expected_sout!==sout)begin
             $display("ERROR ** actual:%b, expected:%b",sout,expected_sout); //if expected Sout does not match Sout, set error to 1.
            err = 1'b1;
        end
endtask

initial begin
    err = 1'b0; //initialize error to 1 at start.
    in = 16'b1111000011001111; //this block checks for when shift=00, hence sout copies B.
    shift = 2'b00;
    #5;
    checker(16'b1111000011001111); //calls self checker to verify output.
    #5;

    in = 16'b1111000011001111; //this block cheks for B shifting to left by 1 bit.
    shift = 2'b01;
    #5;
    checker(16'b1110000110011110);
    #5;

    in = 16'b1111000011001111; //this block checks for B shifting to right by 1 bit. 
    shift = 2'b10;
    #5;
    checker(16'b0111100001100111);
    #5;

    in = 16'b1111000011001111; // this block checks for B shifting right by 1 bit and the MSB being set to B[15].
    shift = 2'b11;
    #5;
    checker(16'b1111100001100111);
    #5;

     if(~err) $display("PASSED"); //if error is still 0, print PASSED. 

end
endmodule