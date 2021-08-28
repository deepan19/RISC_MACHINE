module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
    input [3:0] KEY;
    input [9:0] SW;
    output [9:0] LEDR;
    output [6:0] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
    wire clk = ~KEY[0];
    wire reset = ~KEY[1];
    wire [15:0] read_data,write_data;
    wire N,V,Z;
    wire [1:0] mem_cmd;
    wire [8:0] mem_addr;
    cpu CPU(clk,reset,read_data,write_data,N,V,Z,mem_cmd,mem_addr); //instnatiate CPU module.
    wire [15:0] dout;
    wire write;
    RAM MEM(clk,mem_addr[7:0],mem_addr[7:0],write,write_data,dout); //instantiate MEM module.
    wire eq1,msel,check,eq2;
    EqComp #(2) EQ1(2'b10,mem_cmd,eq1); //this block contains instnatiation for equality comparator
    EqComp #(1) EQ2(1'b0,mem_addr[8:8],msel);
    EqComp #(2) EQ3(2'b01,mem_cmd,eq2);
    assign write = eq2 & msel; //this block is the read/write load input for the MEM.
    assign check = eq1 & msel;
    assign read_data = check ? dout : 15'bz;

    wire eq3,eq4,swcheck;
    EqComp #(2) EQ4(2'b10,mem_cmd,eq3); //this block is for the IO mapping.
    EqComp #(9) EQ5(9'h140,mem_addr,eq4); //only when memaddress is 320, should the switches's inputs go to R.
    assign swcheck = eq3 & eq4;
    assign read_data[7:0] = swcheck ? SW[7:0] : 8'bz;
    assign read_data[15:8] = swcheck ? 8'h00 : 8'bz;

    wire eq5,eq6,ledcheck;
    EqComp #(2) EQ6(2'b01,mem_cmd,eq5); //instnatiate equality comparator.
    EqComp #(9) EQ7(9'h100,mem_addr,eq6); //only when mem address is 256 should the R be read on LEDs.
    assign ledcheck = eq5 & eq6;
    loadffff #(8) ledreg(write_data[7:0],ledcheck,clk,LEDR[7:0]); //instantiate LED register.

    assign LEDR[9:8] = 2'b0;
    assign HEX0 = 7'b1;
    assign HEX1 = 7'b1;
    assign HEX2 = 7'b1;
    assign HEX3 = 7'b1;
    assign HEX4 = 7'b1;
    assign HEX5 = 7'b1;
    

endmodule



module RAM(clk,read_address,write_address,write,din,dout); //from slide set.
    parameter data_width = 16;
    parameter addr_width = 8;
    parameter filename = "lab8fig2.txt";

    input clk;
    input [addr_width-1:0] read_address,write_address;
    input write;
    input [data_width-1:0] din;
    output [data_width-1:0] dout;
    reg [data_width-1:0] dout;

    reg [data_width-1:0] mem [2**addr_width-1:0];

    initial $readmemb(filename,mem);

    always @(posedge clk) begin
        if(write)
            mem[write_address] <=din;
        dout <= mem[read_address]; 
    end
    endmodule 

module EqComp(a,b,eq); //from slide set.
    parameter k=8;
    input [k-1:0] a,b;
    output eq;
    wire eq;

    assign eq = (a==b) ;
endmodule

module loadffff(in,load,clk,out);                                  //This is the module for the load enable registers.
    parameter n = 16;
    input [n-1:0] in;
    input load,clk;
    output [n-1:0] out;

    wire [n-1:0] next_state_load;
    reg [n-1:0] present_state;
    
    assign next_state_load = load ? in : present_state; //MUX to assign next state based on load condition. 
    assign out = present_state;// if laod is 1, update next state with input.

    always@ (posedge clk) begin //drive signal at rising edge of clock.
        present_state = next_state_load;
    end
endmodule


    