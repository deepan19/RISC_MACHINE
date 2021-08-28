module datapath(mdata,sximm8,sximm5,PC,writenum,write,readnum,clk,loada,loadb,shift,asel,bsel,ALUop,loads,loadc,vsel,Z_out,C);
    input [15:0] mdata,sximm8,sximm5;
    input [8:0] PC;
    input [2:0] writenum,readnum;
    input loada,loadb,asel,bsel,loadc,loads,write,clk;
    input [3:0] vsel;
    input [1:0] shift,ALUop;
    output [15:0] C;
    output [2:0] Z_out;

    wire [15:0] data_out;
    reg [15:0] data_in;
    always @(*) begin //the added mux with added inputs. 
        case(vsel)
        4'b0001: data_in = mdata;
        4'b0010: data_in = sximm8;
        4'b0100: data_in = {7'b0,PC};
        4'b1000: data_in = C;
        default: data_in = {16{1'bx}};
        endcase
    end                                                             
    regfile REGFILE(data_in,writenum,write,readnum,clk,data_out); //instantiate regfile module that has all the 8 registers.

    wire [15:0] aout,in,sout;
    loadff #(16) A(data_out,loada,clk,aout);                            //instantiate load enable register A.
    loadff #(16) B(data_out,loadb,clk,in);                              //instantiate load enable register B.
    shifter U1(in,shift,sout);                                    //THis is the shifter unit that exclusively connects the output of B.

    wire [15:0] Ain,Bin,out;
    wire [2:0] Z1;
    assign Ain = asel ? 16'b0 : aout;                            //Ain gets the output of the MUX that uses asel.
    assign Bin = bsel ? sximm5 : sout;         //Bin gets the output of the MUX that uses bsel.
    ALU U2(Ain,Bin,ALUop,out,Z1);
    loadff #(3) status(Z1,loads,clk,Z_out);                                                                       
    loadff #(16) C_(out,loadc,clk,C);                        //instantiate the 16bit load enable register that connects out to datapath_out.


endmodule

module loadff(in,load,clk,out);                                  //This is the module for the load enable registers.
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





