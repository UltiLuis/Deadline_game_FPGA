`timescale 1ns / 1ps


module clkgen(
    input clk,
    output clk_60,
    output wire clk_83,
    output wire sevenseg_clk
    );
    
clk_wiz_0 instance_name
(
// Clock out ports
.clk_out1(clk_83),     // output clk_out1
// Clock in ports
.clk_in1(clk));      // input clk_in1

reg clk2 = 0;
reg [21:0] counter = 0; 

// Clock divider for 60 Hz
 always@(posedge clk_83) 
 begin
if (counter > 22'd1391000) // 83.46/60 = 1391000 
     begin
		counter <= 0;
		clk2 <= ~clk2;
    end
 else
	begin
		counter <= counter + 1'd1;
	end
 end
 assign clk_60 = clk2;

 reg divided_clk = 0;
 reg [16:0] counter_value = 0;  
    
  always @ (posedge clk)
  begin
   if (counter_value == 4999)
       counter_value <= 0; //reset value
   else
       counter_value <= counter_value+1; //count up
   end  
   
  // Clock divider for Seven Segment
  always @ (posedge clk)
  begin
   if (counter_value == 4999)
       divided_clk <= ~divided_clk; // flip the signal
   else
       divided_clk <= divided_clk; // store value
   end  
   
   assign sevenseg_clk = divided_clk;


endmodule