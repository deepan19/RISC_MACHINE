module Lab7_top_tb();
    reg [3:0] KEY;
    reg [9:0] SW;
    wire [9:0] LEDR; 
    wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
   

    lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

    initial forever begin
        KEY[0] = 1; #5;
        KEY[0] = 0; #5;
    end

    initial begin
    KEY[1] = 1'b0; // reset asserted


    #10; // wait until next falling edge of clock
    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4

    #10; // waiting for RST state to cause reset of PC
    SW = 10'b0011101111;

    //data1.txt should be used for using this TB:
    //MOV R0, SW_BASE
    //LDR R0, [R0]
    //LDR R2, [R0]
    //MOV R3, R2, LSL #1
    //MOV R1, LEDR_BASE
    //LDR R1, [R1]
    //STR R3, [R1]
    //HALT
    //SW_BASE:
    //.word 0x0140
    //LEDR_BASE:
    //.word 0x0100



    end
endmodule