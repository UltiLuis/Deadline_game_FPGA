`timescale 1ns / 1ps

module vga_out(
    input clk,
    input [3:0] red_in,
    input [3:0] blu_in,
    input [3:0] gre_in,
    output [3:0] pix_r,
    output [3:0] pix_g,
    output [3:0] pix_b,
    output wire hsync,
    output wire vsync,
    output reg [10:0] curr_x,
    output reg [9:0] curr_y
    );
    
  
    reg [10:0] hcount = 0;
    reg [9:0]  vcount = 0;
  
    always@(posedge clk)
	begin
	if (hcount <= 11'd1679) 
		begin
			hcount <= hcount + 1'b1; 
		end
	else 
		begin
			hcount <= 11'd0;
			if (vcount <= 10'd827) 
				begin
					vcount <= vcount + 1'b1;
				end
			else
				begin
					vcount <= 10'd0;
				end
		end
		end

	assign hsync = (hcount <= 11'd135 && hcount >= 11'd0) ? 0:1;
	assign vsync = (vcount <= 2'd2 && vcount >= 0) ? 1:0; 
    
 always @ (posedge clk)
  begin   
      if (hcount >=336 && hcount <=1615)
      begin
         if (vcount >=27 && vcount <=826)
         begin
           curr_x <= hcount - 336;
           curr_y <= vcount -  27;
         end
      end
      else
      begin
        curr_x <= 0;
        curr_y <= 0;
      end 
   end 
   
    
    localparam hmax = 1615;
    localparam hmin = 336;
    localparam vmax = 826;
    localparam vmin = 27;
    
    assign pix_r = ((hcount <= hmax && hcount >= hmin) && (vcount >= vmin && vcount <= vmax)) ? red_in:0;
    assign pix_b = ((hcount <= hmax && hcount  >= hmin) && (vcount >= vmin && vcount <= vmax)) ? blu_in:0;
    assign pix_g = ((hcount <= hmax && hcount  >= hmin) && (vcount >= vmin && vcount <= vmax)) ? gre_in:0;        
                            
endmodule
