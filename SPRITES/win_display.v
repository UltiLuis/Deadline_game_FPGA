module win_display(
  input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] win_x,
        input wire [9:0] win_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out, // output rgb signal for current pixel
        output wire win_on     // output signal asserted when x and y are within win sprite range
    );
	
	
	wire [7:0] row;
	wire [7:0] col;
	assign row = y  - win_y ;
	assign col = x  - win_x ;

	// assert win when vga x and y is located within win
	assign win_on = ( (x >= win_x && x < win_x+256 && y >= win_y && y < win_y+256) ) ? 1 : 0;
	
	
	win_rom win_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule