module cpu(clk,reset,in,out,N,V,Z,mem_cmd,mem_addr,halt);
    input clk,reset;
    input [15:0] in;
    output [15:0] out;
    output N , V , Z, halt;
    output [1:0] mem_cmd;
    output [8:0] mem_addr;

    wire [15:0] decin;
    LDff insreg(in,load_ir,clk,decin); //instantiate instruction register.
    wire [15:0] sximm8,sximm5;
    wire [2:0] nsel,opcode,writenum,readnum,cond;
    wire [1:0] op,shift,ALUop;
    insdecoder decoder(decin,nsel,opcode,op,writenum,readnum,shift,sximm8,sximm5,ALUop,cond); //instantiating decoder
    wire write,loada,loadb,asel,bsel,loads,loadc;
    wire [3:0] vsel;
    wire load_pc,addr_sel,reset_pc,load_addr,load_savepc,load_writepc;
    FSM stmac(reset,opcode,op,clk,write,loada,loadb,asel,bsel,loads,loadc,vsel,nsel,load_ir,load_pc,mem_cmd,addr_sel,reset_pc,load_addr,halt,load_savepc,load_writepc); //instantiating state machine
    wire [8:0] PC;
    wire [8:0] next_pc1,next_pc2;
    wire [8:0] cond_pc;
    Program_counter PC1(next_pc2,load_pc,clk,PC); //instantiating PC

    wire cond0,cond1,cond2,im3,cond3,cond4,im1,im2,cond5,choose;
    assign cond0=1'b1;
    EqComp1 #(1) eq1(1'b1,Z,cond1); //this block are the conditions for the brach instructions
    EqComp1 #(1) eq2(1'b0,Z,cond2);
    EqComp1 #(1) eq3(N,V,im3);
    assign cond3 = ~im3;
    EqComp1 #(1) eq4(N,V,im1);
    EqComp1 #(1) eq5(1'b1,Z,im2);
    assign cond4 = ~im1 | im2;
    assign cond5 = 1'b0;
    muxb #(1) COND(cond0,cond1,cond2,cond3,cond4,cond5,cond,choose); //mux that chooses the load reflected by the cond.
    assign cond_pc = choose ? PC + 1'b1 + sximm8[8:0] : PC + 1'b1;
    assign next_pc1 = reset_pc ? 9'b0 : cond_pc; //add 1 after each cycle

    wire [8:0] writepc;

    assign next_pc2 = load_writepc ? writepc : next_pc1;
    loadfff #(9) WRITEPC(out[8:0],load_writepc,clk,writepc);

    wire [15:0] readpc = {7'b0000000,(PC-sximm8[8:0])};
    wire [15:0] readpc2;

    loadfff #(16) SAVEPC(readpc,load_savepc,clk,readpc2);
    wire [15:0] mdata;
    assign mdata = load_savepc ? readpc2 : in;



    wire [8:0] d_aout;
    assign mem_addr = addr_sel ? PC : d_aout; //mem_addr wire is controlled by addr_sel load.
    wire [15:0] datapath_out;
    wire [8:0] new = datapath_out[8:0];
    loadfff #(9) DA(new,load_addr,clk,d_aout); //instantiate data adress register
    wire [2:0] Z_out;
    
    datapath DP(mdata,sximm8,sximm5,PC,writenum,write,readnum,clk,loada,loadb,shift,asel,bsel,ALUop,loads,loadc,vsel,Z_out,datapath_out); //instantiating data path.
    assign out = datapath_out;
    assign N = Z_out[2];
    assign V = Z_out[1];
    assign Z = Z_out[0];

endmodule

module LDff(in,load,clk,out); //reference from slides, code for load enable flip flop.                                
    input [15:0] in;
    input load,clk;
    output [15:0] out;

    wire [15:0] next_state_load;
    reg [15:0] present_state;
    
    assign next_state_load = load ? in : present_state; //if load is 0, then do not update rpesent state to next state. 
    assign out = present_state;

    always@ (posedge clk) begin //present state is next state on rising edge of clock. 
        present_state = next_state_load;
    end
endmodule

module insdecoder(in,nsel,opcode,op,writenum,readnum,shift,sximm8,sximm5,ALUop,cond);
    input [15:0] in;
    input [2:0] nsel; //assuming 3 bit onehot code
    output [1:0] ALUop,shift,op;
    output [15:0] sximm5,sximm8;
    output [2:0] readnum,writenum,opcode,cond;

    assign ALUop = in[12:11]; //this block assifns signals to control based on the large 16bit input
    assign shift = in[4:3];
    assign opcode = in[15:13];
    assign op = in[12:11];
    reg [2:0] cond;
    always @(*) begin
        if(opcode==3'b001 && op==2'b00) begin
            cond = in[10:8];
        end
        else if(opcode==3'b010 && op==2'b11) begin
            cond = 3'b000;
        end
        else if(opcode==3'b010 && op==2'b10) begin
            cond = 3'b000;
        end
        else begin
            cond = 3'b110;
        end
    end

    wire[2:0] Rn,Rd,Rm;
    reg[2:0] muxout;

    assign Rn = in[10:8]; ///this block assifns signals to control based on the large 16bit input
    assign Rd = in[7:5];
    assign Rm = in[2:0];
    always@(*) begin //this case statement chooses which input of MUX to choose from.
        case(nsel)
        3'b100: muxout = Rm;
        3'b010: muxout = Rd;
        3'b001: muxout = Rn;
        default: muxout = 3'bxxx;
        endcase
    end
    assign readnum = muxout; ///this block assifns signals to control based on the large 16bit input
    assign writenum = muxout;

    wire [4:0] imm5;
    wire [7:0] imm8;
    reg [15:0] sximm5,sximm8;
    assign imm5 = in[4:0];
    assign imm8 = in[7:0];

    always@(*) begin //sign extension that depends on the MSB. 
        if(imm5[4]==1'b1)
            sximm5 = {11'b11111111111,imm5};
        else
            sximm5 = {11'b00000000000,imm5};
    end
    always@(*) begin //sign extension that depends on the MSB.
        if(imm8[7]==1'b1)
            sximm8 = {8'b11111111,imm8};
        else
            sximm8 = {8'b00000000,imm8};
    end
endmodule

`define wait 8'b00000000 //definition of various states. 8 bits are needed to accomodate all the states/
`define decode 8'b00000001
`define writeimm 8'b00000011
`define MOV2_1 8'b00000010
`define MOV2_2 8'b00000100
`define MOV2_3 8'b00001001
`define ADD_1 8'b00000101
`define ADD_2 8'b00000110
`define ADD_3 8'b00000111
`define ADD_4 8'b00001000
`define CMP_1 8'b00001010
`define CMP_2 8'b00001011
`define CMP_3 8'b00010000
`define AND_1 8'b00010001
`define AND_2 8'b00010010
`define AND_3 8'b00010011
`define AND_4 8'b00010100
`define MVN_1 8'b00010101
`define MVN_2 8'b00010110
`define MVN_3 8'b00010111
`define RST 8'b00011000
`define IF1 8'b00011001
`define IF2 8'b00011010
`define UpdatePC 8'b00011011
`define LDR_1 8'b00011100
`define LDR_2 8'b00011101
`define LDR_3 8'b00011110
`define LDR_4 8'b00011111
`define LDR_5 8'b00100000
`define LDR_6 8'b00100001
`define LDR_7 8'b10000000
`define STR_1 8'b00100010
`define STR_2 8'b00100011
`define STR_3 8'b01000000
`define STR_4 8'b01000001
`define STR_5 8'b01000010
`define STR_6 8'b01000011
`define STR_7 8'b10000001
`define B_1 8'b10000100
`define B_2 8'b10000101
`define BL_1 8'b10000110
`define BL_2 8'b10000111
`define BX_1 8'b10001000
`define BX_2 8'b10001001
`define BX_3 8'b10001010
`define BX_4 8'b10001011
`define BLX_1 8'b10001100
`define BLX_2 8'b10001101
`define BLX_3 8'b10001110
`define BLX_4 8'b10001111
`define BLX_5 8'b10010000
`define BLX_6 8'b10010001
`define HLT 8'b10000011
`define MREAD 2'b10
`define MWRITE 2'b01
`define MNONE 2'b00


module FSM(reset,opcode,op,clk,write,loada,loadb,asel,bsel,loads,loadc,vsel,nsel,load_ir,load_pc,mem_cmd,addr_sel,reset_pc,load_addr,halt,load_savepc,load_writepc);
    input reset,clk;
    input [2:0] opcode;
    input [1:0] op;
    output write,loada,loadb,asel,bsel,loads,loadc,load_ir,load_pc,addr_sel,reset_pc,load_addr,halt,load_savepc,load_writepc;
    output [3:0] vsel;
    output [2:0] nsel;
    output [1:0] mem_cmd;

    reg halt;

    wire [7:0] present_state, state_next_reset, state_next;
    reg [30:0] next;
    wire [4:0] control;
    assign control = {opcode,op}; //control is the concatnation of the signals op and opcide that choose which branch path to take. 

    vvDFF #(8) STATE(clk,state_next_reset,present_state);
    assign state_next_reset = reset ? `RST : state_next; //reset pressed will lead to wait state regardless of inputs.
    
    assign {state_next,write,loada,loadb,asel,bsel,loads,loadc,vsel,nsel,load_ir,load_pc,mem_cmd,addr_sel,reset_pc,load_addr,load_savepc,load_writepc} = next; //concatnation of control signals.

    always@(*) begin
        casex({present_state,control}) //moore machine where output depnds only on present state.
            {`RST,5'bxxxxx}: next = {`IF1,14'b0,1'b0,1'b1,`MNONE,1'b0,1'b1,1'b0,2'b00};
            {`IF1,5'bxxxxx}: next = {`IF2,14'b0,1'b0,1'b0,`MREAD,1'b1,1'b0,1'b0,2'b00};
            {`IF2,5'bxxxxx}: next = {`UpdatePC,14'b0,1'b1,1'b0,`MREAD,1'b1,1'b0,1'b0,2'b00};
            {`UpdatePC,5'bxxxxx}: next = {`decode,14'b0,1'b0,1'b1,`MNONE,1'b0,1'b0,1'b0,2'b00};

            {`decode,5'b11010}: next = {`writeimm,20'b0,1'b0,2'b00};
            {`writeimm,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0010,3'b001,6'b0,1'b0,2'b00}; //ins1. write immediate into R. no control signals updated except write during transition.

            {`decode,5'b11000}: next = {`MOV2_1,20'b0,1'b0,2'b00};
            {`MOV2_1,5'bxxxxx}: next = {`MOV2_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b100,6'b0,1'b0,2'b00}; //this block is for 2nd ins. value is read and stored in B, which is then passed through the shifter. result is stored back in R. 
            {`MOV2_2,5'bxxxxx}: next = {`MOV2_3,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,4'b0000,3'b000,6'b0,1'b0,2'b00};
            {`MOV2_3,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b1000,3'b010,6'b0,1'b0,2'b00};

            {`decode,5'b10100}: next = {`ADD_1,20'b0,1'b0,2'b00};
            {`ADD_1,5'bxxxxx}: next = {`ADD_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b100,6'b0,1'b0,2'b00}; //this block is for the add ins. 2 values from R are read ans stroed in A and B. Next, they are passed through ALU and finally stored back in R. 
            {`ADD_2,5'bxxxxx}: next = {`ADD_3,1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b001,6'b0,1'b0,2'b00};
            {`ADD_3,5'bxxxxx}: next = {`ADD_4,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,4'b0000,3'b000,6'b0,1'b0,2'b00};
            {`ADD_4,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b1000,3'b010,6'b0,1'b0,2'b00};

            {`decode,5'b10101}: next = {`CMP_1,20'b0,1'b0,2'b00};
            {`CMP_1,5'bxxxxx}: next = {`CMP_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b100,6'b0,1'b0,2'b00}; //this block is for the CMP ins. Only here there is no writing back. only here loads is 1 in final state. 2 values are substracted to compare equality and result is shown in status signals.  
            {`CMP_2,5'bxxxxx}: next = {`CMP_3,1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b001,6'b0,1'b0,2'b00};
            {`CMP_3,5'bxxxxx}: next = {`IF1,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,4'b00000,3'b000,6'b0,1'b0,2'b00};

            {`decode,5'b10110}: next = {`AND_1,20'b0,1'b0,2'b00};
            {`AND_1,5'bxxxxx}: next = {`AND_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b100,6'b0,1'b0,2'b00}; //this block is for the AND ins. very similar to ADD. only differs in control code. otherwise, reads 2 values and performs bitwsie and and stores back in R.
            {`AND_2,5'bxxxxx}: next = {`AND_3,1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b001,6'b0,1'b0,2'b00};
            {`AND_3,5'bxxxxx}: next = {`AND_4,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,4'b0000,3'b000,6'b0,1'b0,2'b00};
            {`AND_4,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b1000,3'b010,6'b0,1'b0,2'b00};

            {`decode,5'b10111}: next = {`MVN_1,20'b0,1'b0,2'b00};
            {`MVN_1,5'bxxxxx}: next = {`MVN_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b100,6'b0,1'b0,2'b00}; //this block is for the MVN ins. negates the read value from R and stores back in R. 
            {`MVN_2,5'bxxxxx}: next = {`MVN_3,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,4'b0000,3'b000,6'b0,1'b0,2'b00};
            {`MVN_3,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b1000,3'b010,6'b0,1'b0,2'b00};

            {`decode,5'b01100}: next = {`LDR_1,20'b0,1'b0,2'b00};
            {`LDR_1,5'bxxxxx}: next = {`LDR_2,1'b0,1'b1,1'b0,1'b1,1'b0,1'b0,1'b0,4'b0000,3'b001,7'b0,2'b00}; //this block is for the LDR instruction that reads from mem the address's contents and dtores into R.
            {`LDR_2,5'bxxxxx}: next = {`LDR_3,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,4'b0000,3'b000,7'b0,2'b00};
            {`LDR_3,5'bxxxxx}: next = {`LDR_4,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MREAD,1'b0,1'b0,1'b1,2'b00};
            {`LDR_4,5'bxxxxx}: next = {`LDR_5,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MREAD,1'b0,1'b0,1'b1,2'b00};
            {`LDR_5,5'bxxxxx}: next = {`LDR_6,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MREAD,1'b0,1'b0,1'b1,2'b00};
            {`LDR_6,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0001,3'b010,1'b0,1'b0,`MREAD,1'b0,1'b0,1'b0,2'b00};

            {`decode,5'b10000}: next = {`STR_1,20'b0,1'b0,2'b00};
            {`STR_1,5'bxxxxx}: next = {`STR_2,1'b0,1'b1,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b001,7'b0,2'b00};
            {`STR_2,5'bxxxxx}: next = {`STR_3,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b1,1'b0,1'b1,2'b00}; //this block is for the STR instuction that stores a value from R into address in MEM that is also provided by R
            {`STR_3,5'bxxxxx}: next = {`STR_4,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b010,1'b0,1'b0,`MNONE,1'b1,1'b0,1'b1,2'b00};
            {`STR_4,5'bxxxxx}: next = {`STR_5,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b1,1'b0,1'b0,2'b00};
            {`STR_5,5'bxxxxx}: next = {`STR_6,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MWRITE,1'b0,1'b0,1'b0,2'b00};
            {`STR_6,5'bxxxxx}: next = {`STR_7,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MWRITE,1'b0,1'b0,1'b0,2'b00};
            {`STR_7,5'bxxxxx}: next = {`IF1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MWRITE,1'b0,1'b0,1'b0,2'b00};
            
            
            {`decode,5'b00100}: next = {`B_1,20'b0,1'b0,2'b00};
            {`B_1,5'bxxxxx}: next = {`B_2,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,2'b00};
            {`B_2,5'bxxxxx}: next = {`IF1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,2'b00};

            {`decode,5'b01011}: next = {`BL_1,20'b0,1'b0,2'b00};
            {`BL_1,5'bxxxxx}: next = {`BL_2,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0001,3'b001,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b1,1'b0};
            {`BL_2,5'bxxxxx}: next = {`IF1,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0001,3'b001,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b1,1'b0};

            {`decode,5'b01000}: next = {`BX_1,20'b0,1'b0,2'b00};
            {`BX_1,5'bxxxxx}: next = {`BX_2,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b010,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b0};
            {`BX_2,5'bxxxxx}: next = {`BX_3,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};
            {`BX_3,5'bxxxxx}: next = {`BX_4,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b1,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};
            {`BX_4,5'bxxxxx}: next = {`IF1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b1,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};

            {`decode,5'b01010}: next = {`BLX_1,20'b0,1'b0,2'b00};
            {`BLX_1,5'bxxxxx}: next = {`BLX_2,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0001,3'b001,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b1,1'b0};
            {`BLX_2,5'bxxxxx}: next = {`BLX_3,1'b1,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0001,3'b001,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b1,1'b0};
            {`BLX_3,5'bxxxxx}: next = {`BLX_4,1'b0,1'b0,1'b1,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b010,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b0};
            {`BLX_4,5'bxxxxx}: next = {`BLX_5,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,1'b1,4'b0000,3'b000,1'b0,1'b0,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};
            {`BLX_5,5'bxxxxx}: next = {`BLX_6,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b1,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};
            {`BLX_6,5'bxxxxx}: next = {`IF1,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,4'b0000,3'b000,1'b0,1'b1,`MNONE,1'b0,1'b0,1'b0,1'b0,1'b1};


            {`decode,5'b111xx}: next = {`HLT,20'b0,1'b0,2'b0};
            {`HLT,5'bxxxxx}: next = {`HLT,21'b0,2'b0};
            


            default: next = {29{1'bx}}; //avoid infered latch
        endcase

        if(present_state==`HLT) begin
            halt = 1'b1;
        end else begin
            halt = 1'b0;
        end
    end
endmodule

            
module vvDFF(clk,D,Q); //referenced from slides. code for dff. 
  parameter n=1;
  input clk;
  input [n-1:0] D;
  output [n-1:0] Q;
  reg [n-1:0] Q;

  always @(posedge clk)
    Q <= D;
endmodule

module Program_counter(in,load,clk,out); //folllows the same procinicples as the load enable flip flop.
    parameter k=9;
    input [k-1:0] in;
    input load,clk;
    output [k-1:0] out;

    wire [k-1:0] next_state_load;
    reg [k-1:0] present_state;
    
    assign next_state_load = load ? in : present_state;
    assign out = present_state; 

    always@ (posedge clk) begin 
        present_state = next_state_load;
    end

endmodule
module loadfff(in,load,clk,out);                                  //This is the module for the load enable registers.
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

module muxb(a0,a1,a2,a3,a4,a5,sb,b); //The MUX module, refered to from Slide sets in class.
    parameter k = 1;
    input [k-1:0] a0,a1,a2,a3,a4,a5;
    input [2:0] sb;
    output reg [k-1:0] b;
    wire [7:0] s;
    decoder1 #(3,8) d(sb,s); //Decoder to convert the binary input of select signal to one hot code. 

    always @(*) begin
        casex(s)
            8'b00000001: b = a0; //depending on one hot code, the output b is selected. 
            8'b00000010: b = a1;
            8'b00000100: b = a2;
            8'b00001000: b = a3;
            8'b00010000: b = a4;
            8'b00100000: b = a5;
            default: b = 8'b00100000;
        endcase
    end
endmodule

module decoder1(a,b); //A general decoder module. Taken from Slide sets used in class. 
    parameter n=2;
    parameter m=4;

    input [n-1:0] a;
    output [m-1:0] b;

    wire [m-1:0] b = 1 << a;
endmodule

module EqComp1(a,b,eq); //from slide set.
    parameter k=8;
    input [k-1:0] a,b;
    output eq;
    wire eq;

    assign eq = (a==b) ;
endmodule








