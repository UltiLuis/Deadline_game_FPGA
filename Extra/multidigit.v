`timescale 1ns / 1ps

module multidigit( 
    input sevenseg_clk,
    input [6:0] segval_t, 
    input [6:0] segval_u, 
    output reg [6:0] segval,
    output reg [7:0] select
    );
    
    reg [1:0] counter = 0;
   
 always @(posedge sevenseg_clk) 
 begin
  case(counter) 
   2'b0:
      begin 
         select<=8'b11111110; //first seven segment
         segval<=segval_u; 
      end
   2'b1:
      begin 
         select<=8'b11111101; //second seven segment
         segval<=segval_t; 
      end 
   default:
      begin 
         select= 8'b01111110; //default seven segment
         segval<=0; 
      end
 endcase
 
 if (counter < 1)
   begin
     counter <= counter + 1;
   end
   else 
   begin
     counter <= 0;
   end
 
 end
 
endmodule

