
module student_display(
  input wire clk,             // input clock signal for synchronous rom
        input wire [10:0] student_x,
        input wire [9:0] student_y, 
        input wire [10:0] x, [9:0] y,      // current pixel coordinates from vga_sync circuit
        output wire [11:0] rgb_out // output rgb signal for current pixel
    );
	
	
	wire [4:0] row;
	wire [4:0] col;
	assign row = y  - student_y ;
	assign col = x  - student_x ;	
	
	student3_rom student_unit (.clk(clk), .row(row), .col(col), .color_data(rgb_out));
endmodule