`timescale 1ns / 1ps

module platform_display(
        input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] platform_x,
        input wire [9:0] platform_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out // output rgb signal for current pixel
    );
	
	
	wire [5:0] row;
	wire [8:0] col;
	assign row = y  - platform_y ;
	assign col = x  - platform_x ;
	
	
	platform_rom platform_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule
