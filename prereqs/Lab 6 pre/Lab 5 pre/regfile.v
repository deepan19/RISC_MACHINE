module regfile(data_in,writenum,write,readnum,clk,data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write, clk;
    output [15:0] data_out;

    wire [7:0] c;
    wire l0,l1,l2,l3,l4,l5,l6,l7;
    wire[15:0] R0,R1,R2,R3,R4,R5,R6,R7;


    decoder #(3,8) d1(writenum,c); //3 to 8 decoder that goes into the MUX that determines data out.

    assign l0 = write & c[0]; //This block assigns 8 wires that go out from the and gate in between the 3:8 decoder of writenum to load enable.
    assign l1 = write & c[1];
    assign l2 = write & c[2];
    assign l3 = write & c[3];
    assign l4 = write & c[4];
    assign l5 = write & c[5];
    assign l6 = write & c[6];
    assign l7 = write & c[7];

    register reg0(data_in,l0,clk,R0); //THis block instantiates 8 registers with load enable. outputs R0-R7 respectively,
    register reg1(data_in,l1,clk,R1);
    register reg2(data_in,l2,clk,R2);
    register reg3(data_in,l3,clk,R3);
    register reg4(data_in,l4,clk,R4);
    register reg5(data_in,l5,clk,R5);
    register reg6(data_in,l6,clk,R6);
    register reg7(data_in,l7,clk,R7);
    
    muxb8 #(16) muxreg(R0,R1,R2,R3,R4,R5,R6,R7,readnum,data_out); //This is the MUX that leads to dataout and has inputs of R0 thorugh R7.


endmodule


module decoder(a,b); //A general decoder module. Taken from Slide sets used in class. 
    parameter n=2;
    parameter m=4;

    input [n-1:0] a;
    output [m-1:0] b;

    wire [m-1:0] b = 1 << a;
endmodule


module muxb8(a0,a1,a2,a3,a4,a5,a6,a7,sb,b); //The MUX module, refered to from Slide sets in class.
    parameter k = 1;
    input [k-1:0] a0,a1,a2,a3,a4,a5,a6,a7;
    input [2:0] sb;
    output reg [k-1:0] b;
    wire [7:0] s;
    decoder #(3,8) d(sb,s); //Decoder to convert the binary input of select signal to one hot code. 

    always @(*) begin
        casex(s)
            8'b00000001: b = a0; //depending on one hot code, the output b is selected. 
            8'b00000010: b = a1;
            8'b00000100: b = a2;
            8'b00001000: b = a3;
            8'b00010000: b = a4;
            8'b00100000: b = a5;
            8'b01000000: b = a6;
            8'b10000000: b = a7;
            default: b = {k{1'bx}};
        endcase
    end
endmodule


module register(in,load,clk,out); //The load enable register module. 
    input [15:0] in;
    input load,clk;
    output [15:0] out;

    wire [15:0] next_state_load;
    reg [15:0] present_state;
    
    assign next_state_load = load ? in : present_state; //The MUX statement that determines the next ststae based on load. 
    assign out = present_state; //if load is 1, then next state gets input. if load is 0, keep present state as next state. 

    always@ (posedge clk) begin //this is to drive the signal of nex state on to present ststae on the rising edge of clock. 
        present_state = next_state_load;
    end

    

    
endmodule