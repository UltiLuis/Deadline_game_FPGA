`timescale 1ns / 1ps


module game_top(
    input wire clk,
    input wire rst,
    input left,
    input right, 
    input up, 
    input down,
    input [2:0] diff,
    input wire start,
    output [3:0] pix_r,
    output [3:0] pix_g,
    output [3:0] pix_b,
    output wire hsync,
    output wire vsync,
    output wire led1,
    output wire led2,
    output wire led3,
    output wire led4,
    output led1_r, led1_g, led1_b,
    output led2_r, led2_g, led2_b,
    output [6:0] segval,
    output [7:0] sel

    );
    wire [10:0] curr_x; 
    wire [9:0] curr_y;
    
    wire [6:0] segval_t;
    wire [6:0] segval_u;


    wire [3:0] tpix_r;
    wire [3:0] tpix_g;
    wire [3:0] tpix_b;

    wire clk_83;
    wire clk_60;
    wire sevenseg_clk;

    
    wire [9:0] top_layer_1;
    wire [9:0] top_layer_2;
    wire [9:0] top_layer_3;
    wire [9:0] top_layer_4;
    wire [9:0] top_layer_5;

    wire [10:0] left_platform_1;
    wire [10:0] right_platform_1;
    wire [10:0] left_platform_2;
    wire [10:0] right_platform_2;
    wire [10:0] left_platform_3;
    wire[10:0] right_platform_3;
    
    
    wire [10:0] hw1_x;
    wire [9:0] hw1_y; 
    
    wire [10:0] hw2_x;
    wire [9:0] hw2_y; 
    
    wire [10:0] hw3_x;
    wire [9:0] hw3_y; 
    
    wire [10:0] gold_x;
    wire [9:0] gold_y; 
    
    wire [10:0] student_x;
    wire [9:0] student_y; 
  
    wire end_game;
    wire win;
    wire lose;
    wire dissappear_flag_1;
    wire dissappear_flag_2;
    wire dissappear_flag_3;
    wire dissappear_flag_4;
    
    wire reminder_flag1;
    wire reminder_flag2;
    
    
 PWM pwm_led(.clk(clk) , .reminder_flag1(reminder_flag1), .reminder_flag2(reminder_flag2),.led1_r(led1_r), .led1_g(led1_g), .led1_b(led1_b), .led2_r(led2_r), .led2_g(led2_g), .led2_b(led2_b)); 
 clkgen clkgen_inst(.clk(clk), .clk_83(clk_83), .clk_60(clk_60), .sevenseg_clk(sevenseg_clk));   
 vga_out game(.clk(clk_83),.red_in(tpix_r),.blu_in(tpix_b), .gre_in(tpix_g), .pix_r(pix_r), .pix_g(pix_g), .pix_b(pix_b),.hsync(hsync), .vsync(vsync), .curr_x(curr_x), .curr_y(curr_y));
 multidigit md (.sevenseg_clk(sevenseg_clk),.segval_u(segval_u),.segval_t(segval_t),.segval(segval),.select(sel));
   
 drawcon draw( .blkpos_x(student_x), .blkpos_y(student_y),
   .hw1_x(hw1_x), .hw1_y(hw1_y),
   .hw2_x(hw2_x), .hw2_y(hw2_y),
   .hw3_x(hw3_x), .hw3_y(hw3_y),
   .gold_x(gold_x), .gold_y(gold_y),
   .clk_60(clk_60), 
   .dissappear_flag_1(dissappear_flag_1), .dissappear_flag_2(dissappear_flag_2), .dissappear_flag_3(dissappear_flag_3), .dissappear_flag_4(dissappear_flag_4),
   .clk_83(clk_83),
   .draw_x(curr_x), .draw_y(curr_y),
   .top_layer_1(top_layer_1), .top_layer_2(top_layer_2),.top_layer_3(top_layer_3),.top_layer_4(top_layer_4),.top_layer_5(top_layer_5),
   .draw_r(tpix_r), .draw_g(tpix_g), .draw_b(tpix_b),
   .win(win), .lose(lose),
   .start(start),
   .left_platform_1(left_platform_1),.right_platform_1(right_platform_1), .left_platform_2(left_platform_2),.right_platform_2(right_platform_2),
   .left_platform_3(left_platform_3),.right_platform_3(right_platform_3));
   
   
 Position pos(.posclk(clk_60), 
   .right(right), .left(left), .down(down), .up(up),
   .blkpos_x1(student_x), .blkpos_y1(student_y), 
   .rst(rst), .start(start), .diff(diff),
   .dissappear_flag_1(dissappear_flag_1), .dissappear_flag_2(dissappear_flag_2), .dissappear_flag_3(dissappear_flag_3), .dissappear_flag_4(dissappear_flag_4),
   .reminder_flag1(reminder_flag1), .reminder_flag2(reminder_flag2),
   .hw1_x(hw1_x), .hw1_y(hw1_y),
   .hw2_x(hw2_x), .hw2_y(hw2_y),
   .hw3_x(hw3_x), .hw3_y(hw3_y),
   .gold_x(gold_x), .gold_y(gold_y),
   .left_platform_1(left_platform_1),.right_platform_1(right_platform_1), .left_platform_2(left_platform_2),.right_platform_2(right_platform_2),
   .left_platform_3(left_platform_3),.right_platform_3(right_platform_3),
   .top_layer_1(top_layer_1), .top_layer_2(top_layer_2),.top_layer_3(top_layer_3),.top_layer_4(top_layer_4),.top_layer_5(top_layer_5),
   .win(win), .lose(lose),
   .led1(led1), .led2(led2), .led3(led3), .led4(led4),
   .segval_u(segval_u),.segval_t(segval_t)
   );    

endmodule
