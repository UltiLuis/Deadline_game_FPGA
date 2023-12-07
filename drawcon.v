//PAST LOGIC
`timescale 1ns / 1ps

module drawcon(
    input [10:0] blkpos_x,
    input [9:0] blkpos_y,
    input start,
    input clk_60,
    input clk_83,
    input wire dissappear_flag_1,
    input wire dissappear_flag_2,
    input wire dissappear_flag_3,
    input wire dissappear_flag_4,
    input wire win,
    input wire lose,
    input [10:0] draw_x,
    input [9:0] draw_y,
    input [9:0] top_layer_1, 
    input [9:0] top_layer_2,
    input [9:0] top_layer_3,
    input [9:0] top_layer_4,
    input [9:0] top_layer_5,
    input [10:0] left_platform_1, 
    input [10:0] right_platform_1, 
    input [10:0] left_platform_2,
    input [10:0] right_platform_2,
    input [10:0] left_platform_3,
    input [10:0] right_platform_3,
    input [10:0] hw1_x,
    input [9:0] hw1_y,
    input [10:0] hw2_x,
    input [9:0] hw2_y,
    input [10:0] hw3_x,
    input [9:0] hw3_y,
    input [10:0] gold_x,
    input [9:0] gold_y,
    output wire [3:0] draw_r,
    output wire [3:0] draw_g,
    output wire [3:0] draw_b
    );
    
    reg [3:0] bg_r; //colour of background
    reg [3:0] bg_g;
    reg [3:0] bg_b;
    reg [3:0] blk_r; //colour of block
    reg [3:0] blk_g;
    reg [3:0] blk_b;
    
    wire  lose_on;
    wire  deadline_on;
    wire  win_on;
    
    // RGB values of the sprites
    wire [11:0] rgb_student;
    wire [11:0] rgb_deadline;  
    wire [11:0] rgb_platform1;
    wire [11:0] rgb_platform2; 
    wire [11:0] rgb_platform3; 
    wire [11:0] rgb_platform4; 
    wire [11:0] rgb_platform5;     
    wire [11:0] rgb_hw1;
    wire [11:0] rgb_hw2;
    wire [11:0] rgb_hw3;
    wire [11:0] rgb_gold;
    wire [11:0] rgb_win;
    wire [11:0] rgb_lose;
    
    // Static values for the logo, win and lose sprites
    reg [10:0] logo_x = 11'd522;
    reg [9:0] logo_y = 10'd222;
    
    reg [10:0] lose_x = 11'd522;
    reg [9:0] lose_y = 10'd222;
    
    reg [10:0] win_x = 11'd522;
    reg [9:0] win_y = 10'd222;
    
    // Instatiating the sprite display modules
    platform_display platform1( .clk(clk_83), .x(draw_x), .y(draw_y), .platform_x(left_platform_1), .platform_y(top_layer_1), .rgb_out(rgb_platform1));
    platform_display platform2( .clk(clk_83), .x(draw_x), .y(draw_y), .platform_x(left_platform_2), .platform_y(top_layer_2), .rgb_out(rgb_platform2));
    platform_display platform3( .clk(clk_83), .x(draw_x), .y(draw_y), .platform_x(left_platform_3), .platform_y(top_layer_3), .rgb_out(rgb_platform3));
    platform_display platform4( .clk(clk_83), .x(draw_x), .y(draw_y), .platform_x(left_platform_1), .platform_y(top_layer_4), .rgb_out(rgb_platform4));
    platform_display platform5( .clk(clk_83), .x(draw_x), .y(draw_y), .platform_x(left_platform_2), .platform_y(top_layer_5), .rgb_out(rgb_platform5));

    student_display student(.clk(clk_83), .x(draw_x), .y(draw_y), .student_x(blkpos_x), .student_y(blkpos_y), .rgb_out(rgb_student));
    deadline_display logo( .clk(clk_83), .x(draw_x), .y(draw_y), .deadline_x(logo_x), .deadline_y(logo_y), .rgb_out(rgb_deadline), .deadline_on(deadline_on));
    lose_display lose_pix( .clk(clk_83), .x(draw_x), .y(draw_y), .lose_x(lose_x), .lose_y(lose_y), .rgb_out(rgb_lose), .lose_on(lose_on));
    win_display win_pix( .clk(clk_83), .x(draw_x), .y(draw_y), .win_x(win_x), .win_y(win_y), .rgb_out(rgb_win), .win_on(win_on));
    hw1_display hw1( .clk(clk_83), .x(draw_x), .y(draw_y), .hw1_x(hw1_x), .hw1_y(hw1_y), .rgb_out(rgb_hw1));
    hw2_display hw2( .clk(clk_83), .x(draw_x), .y(draw_y), .hw2_x(hw2_x), .hw2_y(hw2_y), .rgb_out(rgb_hw2));
    hw3_display hw3( .clk(clk_83), .x(draw_x), .y(draw_y), .hw3_x(hw3_x), .hw3_y(hw3_y), .rgb_out(rgb_hw3));
    gold_display gold( .clk(clk_83), .x(draw_x), .y(draw_y), .gold_x(gold_x), .gold_y(gold_y), .rgb_out(rgb_gold));

   
    
    localparam xmax = 1268; //right border
    localparam xmin = 10;	//left border
    localparam ymax = 789;	//top border
    localparam ymin = 10;	//bottom border
    localparam white = 4'b1111;
    localparam black = 4'b0000;
    reg [3:0] bg_colour = 4'b1110;
    
    localparam width = 32;
    localparam height = 32;
       
        
        
    // Background ---------------------------------------
    always@(*)
    begin
        if (!start) //if we didn't start
        begin
        if (deadline_on) // Draw the logo
             begin
              bg_r <= rgb_deadline[11:8];
              bg_g <= rgb_deadline[7:4];
              bg_b <= rgb_deadline[3:0];  
              end   
         else if (draw_x <= xmin || draw_x >= xmax || draw_y <= ymin || draw_y >= ymax) 
            begin // Border Drawing
                bg_r <= 4'b0000;
                bg_g <= 4'b0111;
                bg_b <= 4'b1000;
            end
        else 
            begin
              bg_r <= white;
              bg_g <= white;
              bg_b <= white;  
        
           end    
        end
        else
        begin
        if (win || lose) // If the game ended i.e. we win or lose
        begin
            if (win) // Draw winning Sprite/background
            begin
                if (win_on)
                   begin
                      bg_r <= rgb_win[11:8];
                      bg_g <= rgb_win[7:4];
                      bg_b <= rgb_win[3:0];
                    end
                else if (draw_x <= xmin || draw_x >= xmax || draw_y <= ymin || draw_y >= ymax) 
                begin // Border Drawing
                    bg_r <= 4'b0000;
                    bg_g <= 4'b0111;
                    bg_b <= 4'b1000;
                end
                else 
                   begin
                      bg_r <= white;
                      bg_g <= white;
                      bg_b <= white;             
                   end
           end
           else if (lose)  // Draw losing sprite Background
           begin
                if (lose_on)
                   begin
                      bg_r <= rgb_lose[11:8];
                      bg_g <= rgb_lose[7:4];
                      bg_b <= rgb_lose[3:0]; 
                   end
                else if (draw_x <= xmin || draw_x >= xmax || draw_y <= ymin || draw_y >= ymax) 
                begin // Border Drawing
                    bg_r <= 4'b0000;
                    bg_g <= 4'b0111;
                    bg_b <= 4'b1000;
                end
                else 
                   begin
                     bg_r <= black;
                     bg_g <= black;
                     bg_b <= black;             
                   end
           end             
        end
        else  // The game is still playing 
           begin       // Drawing the platforms 
              if  (draw_y >= top_layer_1 && draw_y <= top_layer_1 + 6'd25 && (draw_x > right_platform_1 || draw_x < left_platform_1) ) 
                begin
                     bg_r <= rgb_platform1[11:8];
                     bg_g <= rgb_platform1[7:4];
                     bg_b <= rgb_platform1[3:0];
                end            
              else if (draw_y >= top_layer_2 && draw_y <= top_layer_2 + 6'd25 && (draw_x > right_platform_2 || draw_x < left_platform_2))
                begin
                     bg_r <= rgb_platform2[11:8];
                     bg_g <= rgb_platform2[7:4];
                     bg_b <= rgb_platform2[3:0];
                end
              else if (draw_y >= top_layer_3 && draw_y <= top_layer_3 + 6'd25 && (draw_x > right_platform_3 || draw_x < left_platform_3))
                begin
                     bg_r <= rgb_platform3[11:8];
                     bg_g <= rgb_platform3[7:4];
                     bg_b <= rgb_platform3[3:0];
                end
              else if (draw_y >= top_layer_4 && draw_y <= top_layer_4 + 6'd25 && (draw_x > right_platform_1 || draw_x < left_platform_1))
                begin
                     bg_r <= rgb_platform4[11:8];
                     bg_g <= rgb_platform4[7:4];
                     bg_b <= rgb_platform4[3:0];
                end
              else if (draw_y >= top_layer_5 && draw_y <= top_layer_5 + 6'd25 && (draw_x > right_platform_2 || draw_x < left_platform_2))
                begin
                     bg_r <= rgb_platform5[11:8];
                     bg_g <= rgb_platform5[7:4];
                     bg_b <= rgb_platform5[3:0];
                end
            else if ((draw_x < xmax) && (xmin < draw_x)  && (draw_y < ymax) && (ymin < draw_y)) // Background colour
                begin
                    bg_r <= bg_colour;
                    bg_g <= bg_colour;
                    bg_b <= bg_colour;
                end
            else
                begin // Border Drawing
                    bg_r <= 4'b0000;
                    bg_g <= 4'b0111;
                    bg_b <= 4'b1000;
                end
          end
       end
     end
        
        
    // Blocks  ---------------------------------------
    always@(*)
        begin
          if (!win && !lose && start) // If the started and we did not lose and did not win
        begin             
        if ( (blkpos_x <= draw_x)  && (draw_x <= blkpos_x+width) && (blkpos_y <= draw_y) && (draw_y <= blkpos_y+height))       // Draw student player   
                begin
                    blk_r <= rgb_student[11:8];
                    blk_g <= rgb_student[7:4];
                    blk_b <= rgb_student[3:0];
                end 
                
        else if ( (hw1_x <= draw_x)  && (draw_x <= hw1_x+32) && (hw1_y <= draw_y) && (draw_y <= hw1_y+32) && !dissappear_flag_1 ) // Draw HW1 block if not dissappeared
           begin
               blk_r <= rgb_hw1[11:8];
               blk_g <= rgb_hw1[7:4];
               blk_b <= rgb_hw1[3:0];
            end
        else if ( (hw1_x <= draw_x)  && (draw_x <= hw1_x+32) && (hw1_y <= draw_y) && (draw_y <= hw1_y+32) && dissappear_flag_1 )  // else we make it the same color as the background 
        begin
               blk_r <= bg_colour;
               blk_g <= bg_colour;
               blk_b <= bg_colour;
            end
            
         else if ( (hw2_x <= draw_x)  && (draw_x <= hw2_x+32) && (hw2_y <= draw_y) && (draw_y <= hw2_y+32) && !dissappear_flag_2  ) // Draw HW2 block if not dissappeared
           begin
               blk_r <= rgb_hw2[11:8];
               blk_g <= rgb_hw2[7:4];
               blk_b <= rgb_hw2[3:0];
            end
          else if ( (hw2_x <= draw_x)  && (draw_x <= hw2_x+32) && (hw2_y <= draw_y) && (draw_y <= hw2_y+32) && dissappear_flag_2 )  // else we make it the same color as the background 
            begin
              blk_r <= bg_colour;
              blk_g <= bg_colour;
              blk_b <= bg_colour;
            end
            
         else if ( (hw3_x <= draw_x)  && (draw_x <= hw3_x+32) && (hw3_y <= draw_y) && (draw_y <= hw3_y+32) && !dissappear_flag_3  ) // Draw HW3 block if not dissappeared
           begin
               blk_r <= rgb_hw3[11:8];
               blk_g <= rgb_hw3[7:4];
               blk_b <= rgb_hw3[3:0];                 
            end          
          else if ( (hw3_x <= draw_x)  && (draw_x <= hw3_x+32) && (hw3_y <= draw_y) && (draw_y <= hw3_y+32) && dissappear_flag_3 ) // else we make it the same color as the background 
            begin
               blk_r <= bg_colour;
               blk_g <= bg_colour;
               blk_b <= bg_colour;
            end
            
          else if ( (gold_x <= draw_x)  && (draw_x <= gold_x+32) && (gold_y <= draw_y) && (draw_y <= gold_y+32) && !dissappear_flag_4  ) // Draw Golden HW block if not dissappeared
           begin
               blk_r <= rgb_gold[11:8];
               blk_g <= rgb_gold[7:4];
               blk_b <= rgb_gold[3:0];                
            end          
          else if ( (gold_x <= draw_x)  && (draw_x <= gold_x+32) && (gold_y <= draw_y) && (draw_y <= gold_y+32) && dissappear_flag_4 ) // else we make it the same color as the background 
            begin
               blk_r <= bg_colour;
               blk_g <= bg_colour;
               blk_b <= bg_colour;
            end
        
        else // default block value i.e we wont draw
             begin
                    blk_r <= 4'b0000;
                    blk_g <= 4'b0000;
                    blk_b <= 4'b0000;
                end
        end      
       end
        
    //if the block has a color (its RGB components are greater than 0), the color of the block is used; otherwise, the background color is used. 
    assign draw_r = (blk_r > 0) ? blk_r: bg_r;
    assign draw_g = (blk_g > 0) ? blk_g: bg_g;
    assign draw_b = (blk_b > 0) ? blk_b: bg_b;
                     

endmodule