

module hw1_display(
  input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] hw1_x,  // blk x position
        input wire [9:0] hw1_y,   // blk y position
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out // output rgb signal for current pixel
    );
	
	
	wire [4:0] row;
	wire [4:0] col;
	assign row = y  - hw1_y ;
	assign col = x  - hw1_x ;
	
	
	hw111_rom hw1_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule