module hw2_display(
  input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] hw2_x,
        input wire [9:0] hw2_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out // output rgb signal for current pixel
    );
	
	
	wire [4:0] row;
	wire [4:0] col;
	assign row = y  - hw2_y ;
	assign col = x  - hw2_x ;

	
	hw222_rom hw2_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule