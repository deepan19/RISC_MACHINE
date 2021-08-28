module datapath_tb();
    reg [15:0] datapath_in;
    reg [2:0] writenum,readnum;
    reg loada,loadb,asel,bsel,loadc,loads,vsel,write,clk,err;
    reg [1:0] shift,ALUop;
    wire [15:0] datapath_out;
    wire Z_out;

    datapath DUT(datapath_in,writenum,write,readnum,clk,loada,loadb,shift,asel,bsel,ALUop,loads,loadc,vsel,Z_out,datapath_out);
    //instantiating datapath module as DUT.

    task checker;
        input [15:0] expected_datapath_out;

        begin
            if(expected_datapath_out!==datapath_out)begin //checks if expected datapath_out matches actual. if doesnt match, set error to 1/
                $display("ERROR ** actual:%b, expected:%b",datapath_out,expected_datapath_out);
                err = 1'b1;
        end
        end
    endtask

    initial begin //clock oscillates forever.
    clk = 0; #5;
    forever begin
        clk = 1; #5;
        clk = 0; #5;
    end
    end

    initial begin
        err = 1'b0; //inititalize error to 0.
        loadc = 1'b1;                         // Test case 1: This first test takes 7 and stores it in R0, next, takes 2 and stores it in R1.
        asel = 1'b0;                          //Adds the values in R1 +(R0 shifter left by 1) and stores value 16 in R2.
        bsel = 1'b0;
        ALUop = 2'b00; //This block sets the constants such as ALUop, shift, and all loads to except loada and loadb to 1.
        shift = 2'b01;
        vsel = 1'b1;
        write = 1'b1;
        datapath_in = 16'b0000000000000111; //storing the first input in R0;
        writenum = 3'b000;
        readnum = 3'b000;
        loada = 1'b0;
        loadb = 1'b1;
        #20;
        datapath_in = 16'b0000000000000010; //storing next input in R1.
        writenum = 3'b001;
        readnum = 3'b001;
        loada = 1'b1;
        loadb = 1'b0;
        #20;
        #10;
        checker(16'b0000000000010000); //verify if output 16 is acheived.
        vsel = 1'b0;
        writenum = 3'b010;
        #10;


      
        loadc = 1'b1;                         // Test case 2: This second test takes 41 and stores it in R0, next, takes 10 and stores it in R1.
        asel = 1'b0;                          //Adds the values in R1 + R0 and stores value 51 in R2.
        bsel = 1'b0;
        ALUop = 2'b00; //This block sets the constants such as ALUop, shift, and all loads to except loada and loadb to 1.
        shift = 2'b00;
        vsel = 1'b1;
        write = 1'b1;
        datapath_in = 16'b0000000000101001; //storing the first input in R0;
        writenum = 3'b000;
        readnum = 3'b000;
        loada = 1'b0;
        loadb = 1'b1;
        #20;
        datapath_in = 16'b0000000000001010; //storing next input in R1.
        writenum = 3'b001;
        readnum = 3'b001;
        loada = 1'b1;
        loadb = 1'b0;
        #20;
        #10;
        checker(16'b0000000000110011); //verify if output 51 is acheived.
        vsel = 1'b0;
        writenum = 3'b010;
        #10;


        if(~err) $display("PASSED"); //if checker passes and error is 0, print PASSED.
        
    end

endmodule

     


            


