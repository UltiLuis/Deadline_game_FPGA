module lose_display(
  input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] lose_x,
        input wire [9:0] lose_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out, // output rgb signal for current pixel
        output wire lose_on     // output signal asserted when x and y are within lose sprite range
    );
	
	
	wire [7:0] row;
	wire [7:0] col;
	assign row = y  - lose_y ;
	assign col = x  - lose_x ;

	// assert lose when vga x and y is located within lose 
	assign lose_on = ( (x >= lose_x && x < lose_x+256 && y >= lose_y && y < lose_y+256) ) ? 1 : 0;
	
	
	lose_rom lose_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule