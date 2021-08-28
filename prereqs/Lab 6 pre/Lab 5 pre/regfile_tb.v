module regfile_tb();

reg [15:0] data_in;
reg [2:0] writenum,readnum;
reg write,clk,err;
wire [15:0] data_out;


regfile DUT(data_in,writenum,write,readnum,clk,data_out); //instantiating regfile module for test.


task my_checker;
    input [15:0] expected_data_out;
    begin
        if(expected_data_out!==data_out) begin
            $display("ERROR ** actual:%b, expected:%b",data_out,expected_data_out);  //Checks of the output signal is same as expected output or not.
            err = 1'b1; // set err to 1 if expected and actual do not match.
        end        
    end
endtask

initial begin //clock oscilates forever.
    clk = 0; #5;
    forever begin
        clk = 1; #5;
        clk = 0; #5;
end
end

initial begin
    err=1'b0; //initiate error is 0 at start of tb.
    write = 1'b1; writenum = 3'b001; data_in = 16'b1010101010101010; //this block tests if writing data onto R1 and reading from R1 works.
    #10;
    write = 1'b0; readnum = 3'b001; 
    #10;
    my_checker(16'b1010101010101010); //self checker is called to verify output.

    
    write = 1'b1; writenum = 3'b100; data_in = 16'b0000001010101010; //this block checks if the same condition as above works for another R.
    #10;
    write = 1'b0; readnum = 3'b100;
    #10;
    my_checker(16'b0000001010101010);


    write = 1'b1; writenum = 3'b111; data_in = 16'b0000000000000001; //again checking if the last R works. 
    #10;
    write = 1'b0; readnum = 3'b111;
    #10;
    my_checker(16'b0000000000000001);

    write = 1'b1; writenum = 3'b001; data_in = 16'b0000000000000111; // CHecks if overwriting data of R1 overwrites value. attemps to read afterwards.
    #10;
    write = 1'b0; readnum = 3'b001;
    #10;
    my_checker(16'b0000000000000111);

    write = 1'b1; writenum = 3'b100; data_in = 16'b0000000000001111; // agains checking for overwrite behaviour for another R.
    #10;
    write = 1'b0; readnum = 3'b100;
    #10;
    my_checker(16'b0000000000001111);
     if(~err) $display("PASSED"); //of error signal is still 0, print passed.


end
endmodule
