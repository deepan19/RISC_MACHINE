module shifter(in,shift,sout); //Module for shifter unit.
    input [15:0] in;
    input [1:0] shift;
    output [15:0] sout;

    reg [15:0] sout;

    always@ (*)begin //includes several if conditions to determine Sout based on choice of shift. 
        if(shift == 2'b00)begin
            sout = in;
        end
        else if(shift == 2'b01)begin
            sout = in << 1;
        end
        else if(shift == 2'b10)begin
            sout = in >> 1;
        end
        else if(shift == 2'b11)begin
             sout = {in >> 1};  
             sout[15] = in[15];
        end
        else begin
            sout = {16{1'bx}}; //If Shift has not signal set all 15 bits to dont cares. 
        end
    end
          
endmodule