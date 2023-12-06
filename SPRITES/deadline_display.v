`timescale 1ns / 1ps

module deadline_display(
        input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] deadline_x,
        input wire [9:0] deadline_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out, // output rgb signal for current pixel
        output wire deadline_on     // output signal asserted when x and y are within logo on display
    );
	
	
	wire [7:0] row;
	wire [7:0] col;
	assign row = y  - deadline_y ;
	assign col = x  - deadline_x ;

	// assert deadline logo when vga x and y is located within the loga range
	assign deadline_on = ( (x >= deadline_x && x < deadline_x+256 && y >= deadline_y && y < deadline_y+256) ) ? 1 : 0;
	
	
	logo_rom deadline_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));


endmodule

