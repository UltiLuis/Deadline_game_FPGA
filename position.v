`timescale 1ns / 1ps

module Position(
    input posclk,           // Clock signal.
    input rst,              // Reset signal.
    input right,            // Right movement control.
    input left,             // Left movement control.
    input down,             // Down movement control.
    input up,               // Up movement control.
    input start,            // Flag to start game.
    input [2:0] diff,       // switch control for speed.
    input [10:0] left_platform_1,  // Left platform position for layer 1.
    input [10:0] right_platform_1, // Right platform position for layer 1.
    input [10:0] left_platform_2,  // Left platform position for layer 2.
    input [10:0] right_platform_2, // Right platform position for layer 2.
    input [10:0] left_platform_3,  // Left platform position for layer 3.
    input [10:0] right_platform_3, // Right platform position for layer 3.
    output [10:0] hw1_x, // HW 1 X position.
    output [9:0] hw1_y,  // HW 1 Y position.
    output [10:0] hw2_x, // HW 2 X position.
    output [9:0] hw2_y,  // HW 2 Y position.
    output [10:0] hw3_x, // HW 3 X position.
    output [9:0] hw3_y,  // HW 3 Y position.
    output [10:0] gold_x, // HW 3 X position.
    output [9:0] gold_y,  // HW 3 Y position.
    output [10:0] blkpos_x1,    // Student X position.
    output [9:0] blkpos_y1,      // Student Y position.
    output reg [9:0] top_layer_1 = 10'd150, // Top position of layer 1.
    output reg [9:0] top_layer_2 = 10'd320, // Top position of layer 2.
    output reg [9:0] top_layer_3 = 10'd500, // Top position of layer 3.
    output reg [9:0] top_layer_4 = 10'd660, // Top position of layer 4.
    output reg [9:0] top_layer_5 = 10'd830, // Top position of layer 5.
    output wire led1,        // LED control signal.
    output wire led2,        // LED control signal.
    output wire led3,        // LED control signal.
    output wire led4,        // LED control signal.
    output wire win,         // Win signal.
    output wire lose,        // Lose signal.
    output wire dissappear_flag_1, // Hw1 disappearance flag.
    output wire dissappear_flag_2, // Hw2 disappearance flag.
    output wire dissappear_flag_3, // Hw3 disappearance flag.
    output wire dissappear_flag_4, // gold Hw disappearance flag.
    output wire reminder_flag1, // Reminder flag for deadline after 5 sec.
    output wire reminder_flag2, // Reminder flag for deadline after 10 sec.
    output wire [6:0] segval_t,    // Seven Segment Decimal Tens position value
    output wire [6:0] segval_u     // Seven Segment Decimal Unit position value
    );

    
    // Border parameters.
    localparam xmax = 1268;  // Right border.
    localparam xmin = 10;    // Left border.
    localparam ymax = 789;   // Bottom border.
    localparam ymin = 10;    // Top border.
    
    localparam width = 32;   // Student block width.
    localparam height = 32;  // Student block height.
    
    // Student Block and HW positions.
    reg [10:0] blkpos_x = 11'd140;
    reg [9:0] blkpos_y = 11'd200;
    
    reg [10:0] hw1_x_reg = 11'd100;
    reg [9:0] hw1_y_reg = 11'd220;
    
    reg [10:0] hw2_x_reg = 11'd900;
    reg [9:0] hw2_y_reg = 11'd540;
    
    reg [10:0] hw3_x_reg = 11'd150;
    reg [9:0] hw3_y_reg = 11'd700;
    
    reg [10:0] gold_x_reg = 11'd600;
    reg [9:0] gold_y_reg = 11'd220;
    
    // HW flags that signify collisions or (collecting the HW).
    reg hw1_flag;
    reg hw2_flag;
    reg hw3_flag;
    reg gold_flag;
    
    
    // Game state flags.
    reg win_flag = 0;
    reg lose_flag = 0;
    
    // Dissapper flag to indicate to the drawcon to turn the HW to the same color as background.
    reg dissappear_flag1 = 0;
    reg dissappear_flag2 = 0;
    reg dissappear_flag3 = 0;
    reg dissappear_flag4 = 0;
    
    // Reminder flag to turn on RGB led lights.
    reg reminder_flag1_reg = 0;
    reg reminder_flag2_reg = 0;
    
    // LED registers since we will be changing them within an always block.
    reg led1_reg = 0;
    reg led2_reg = 0;
    reg led3_reg = 0;
    reg led4_reg = 0;
       
    // LED reg Assignments. 
    assign led1 = led1_reg;
    assign led2 = led2_reg;
    assign led3 = led3_reg;
    assign led4 = led4_reg;
    
    // Game (platform) speed register.
    reg [2:0] speed;
    
    // Deathcounter.
    reg [5:0] count=15;
    reg timeout;


    
    // Combinational logic for game state.
    always @* begin
        if (hw1_flag == 1 && hw2_flag == 1 && hw3_flag == 1 && gold_flag ==1) begin // If we got all the HW blocks signal win.
            win_flag = 1;
        end
        else if (hw1_flag == 0 || hw2_flag == 0 || hw3_flag == 0 || gold_flag == 0) begin //else if any one of them was not collected then we don't signal win.
             win_flag = 0;
        end
        if (timeout == 1) // If we reach the timeout limit then we signal lose.
        begin
         lose_flag = 1;
        end
        else if (timeout == 0) // else we dont signal lose.
        begin
           lose_flag = 0;
        end
    end
    
    // Combinational logic for game speed levels.
    always @* begin
     case(diff)            // based on the four first switches we set the speed of the platforms going down.
       3'b000: speed= 3'd1;
       3'b001: speed= 3'd2;
       3'b010: speed= 3'd3;
       3'b100: speed= 3'd4;
    default: speed= 3'd2;   
    endcase 
    end
    

    // Sequential logic for game state and platform (layer) movement ----------------------------
    always @(posedge posclk) begin
        if (rst) begin      
            // Reset game state
            top_layer_1 <= 10'd150;
            top_layer_2 <= 10'd320;
            top_layer_3 <= 10'd500;
            top_layer_4 <= 10'd660;
            top_layer_5 <= 10'd830;   
            count <= 15;       
            timeout <= 0;
            reminder_flag1_reg <= 0; 
            reminder_flag2_reg <= 0; 
            
        end else begin       
            if (count <= 1) begin // if the count reaches 1 or less we signal timeout.
               timeout <= 1;
            end
            
            if (count <= 10) begin
             reminder_flag1_reg <= 1;
            end
            
            if (count <= 5) begin
             reminder_flag2_reg <= 1;
            end
        
        // Update the position of layer 1, if the top of the layer reaches the bottom of the screen (ymax) then we position it at the top again (ymin) else we move it down by the specified speed.
        top_layer_1 <= (top_layer_1 + 6'd25 > ymax) ? ymin : top_layer_1 + speed;
        
        // Update the position of layer 2.
        if (top_layer_2 + 6'd25 > ymax) // if the top of the layer reaches the bottom of the screen (ymax)
			begin
                if (count >= 6'd1 && start) begin // if the count is more than 1 and the game has started, We place the decrement here so the timer is slower and only updates when layer 2 and layer 4 reach the bottom of the screen.
                   count <= count-6'd1; //then we decrement the counter by 1.
                end
                else begin
                   count <= count; // else count stays the same.
                end
			top_layer_2 <= ymin; // then we position it at the top again (ymin)
			end
		else
            begin				
                top_layer_2 <= top_layer_2 + speed; // else we move it down by the specified speed.
            end
        
        // Update the position of layer 3, if the top of the layer reaches the bottom of the screen (ymax) then we position it at the top again (ymin) else we move it down by the specified speed.
        top_layer_3 <= (top_layer_3 + 6'd25 > ymax) ? ymin : top_layer_3 + speed;
        
       // Update the position of layer 4.
        if (top_layer_4 + 6'd25 > ymax) // if the top of the layer reaches the bottom of the screen (ymax)
			begin
                if (count >= 6'd1 && start) begin // if the count is more than 1 and the game has started, We place the decrement here so the timer is slower and only updates when layer 2 and layer 4 reach the bottom of the screen.
                   count <= count-6'd1; //then we decrement the counter by 1.
                end
                else begin
                   count <= count; // else count stays the same.
                end
			top_layer_4 <= ymin; // then we position it at the top again (ymin)
			end
		else
            begin				
                top_layer_4 <= top_layer_4 + speed; // else we move it down by the specified speed.
            end
        
        // Update the position of layer 5, if the top of the layer reaches the bottom of the screen (ymax) then we position it at the top again (ymin) else we move it down by the specified speed.
        top_layer_5 <= (top_layer_5 + 6'd25 > ymax) ? ymin : top_layer_5 + speed;

        end
     end


    // Sequential logic for block movement and HW collisions -------------------------
    always @(posedge posclk) begin  
        if (rst)
         begin
            // Reset Game parameters
            dissappear_flag1 <= 0;
            dissappear_flag2 <= 0;
            dissappear_flag3 <= 0;
            dissappear_flag4 <= 0;
            
            
            hw1_x_reg <= 11'd100;        
            hw1_y_reg <= top_layer_1 - 11'd40;
            
            hw2_x_reg <= 11'd900;
            hw2_y_reg <= top_layer_3 - 11'd40;
            
            hw3_x_reg <= 11'd150;
            hw3_y_reg <= top_layer_5 - 11'd40;  
            
            gold_x_reg <= 11'd600;
            gold_y_reg <= top_layer_2 - 11'd40;  
         end
         
        // Directional Movements for student blk ----------------------------------
        if (left) begin // If left is high than we move the student to the left by 9 pixels
            blkpos_x <= blkpos_x - 11'd9;
        end

        if (right) begin // If right is high than we move the student to the right by 9 pixels
            blkpos_x <= blkpos_x + 11'd9;
        end

        if (down) begin // If down is high than we move the student to the down by 9 pixels
            blkpos_y <= blkpos_y + 10'd9;
        end

        // Border detection ---------------------------------------
        if (blkpos_x + width> xmax) begin // If the student's x position plus its width is more than the right border (xmax), here we add width becasue we want to ditect the blocks right side which starts at position 0 plus its width.
            blkpos_x <= xmax - width; // then we set its position to ensure it stays within the borders.
        end

        if (blkpos_y + height > ymax) begin // If the student's y position plus its height is more than the bottom border (ymax) i.e (it reaches the bottom).
            blkpos_y <= ymin; // then we set its y position back at the top.
            blkpos_x <= 11'd700; // and the x position somewhat in the middle.
        end

        if (blkpos_x < xmin) begin // If the student's x position is more than the left border (xmin), here we dont add width becasue we want to ditect the blocks left side which starts at position 0.
            blkpos_x <= xmin; // then we set its position to ensure it stays within the borders.
        end

        if (blkpos_y < ymin) begin // If the student's y position is more than the top border (ymin) i.e (it reaches the top).
            blkpos_y <= ymin; // then we set its position to ensure it stays within the borders.
        end

        // Platform detection ----------------------------------
        if ( (blkpos_y + height >= top_layer_1 - 3'd5 && blkpos_y + height < top_layer_1 + 3'd6) // Detecting platforms of layer 1
					 && ( (blkpos_x < left_platform_1) || (blkpos_x  + width > right_platform_1) ))  // If the student's y position is close to the top of layer 1 and its x position is not within the gap of the platforms.
			begin
				blkpos_y <= top_layer_1 - height;  // Move the block above the top of layer 1 i.e. (its stays on top of the platforms)
				if ( (up) && (blkpos_x + width < right_platform_2 + 6'd5 && blkpos_x > left_platform_2 - 6'd5) ) // If up is high and the block is within the gap of the left and right platforms of layer 5 platforms (which uses right and left platforms 2)
					begin
						blkpos_y <= blkpos_y - 10'd200; // Move the block upward by 200
					end
				else if ( (up) && !(blkpos_x + width < right_platform_2 + 6'd5 && blkpos_x > left_platform_2 - 6'd5) ) // else If up is high and the block is not within the gap of the left and right platforms of layer 5 platforms.
					begin
						blkpos_y <= blkpos_y - 10'd100; // Move the block upward by 100, essentially making it not reach the top range that would place it on top of the next platfoms.
					end
			end                
		
		else if ( (blkpos_y + height >= top_layer_2 - 3'd5&& blkpos_y + height < top_layer_2 + 3'd6) // Detecting platforms of layer 2
					 && ( (blkpos_x < left_platform_2) || (blkpos_x  + width > right_platform_2) ) )  // If the student's y position is close to the top of layer 2 and its x position is not within the gap of the platforms.
			begin
				blkpos_y <= top_layer_2 - height; // Move the block above the top of layer 2 i.e. (its stays on top of the platforms)
				if ( (up) && (blkpos_x + width < right_platform_1 + 6'd5 && blkpos_x > left_platform_1 - 6'd5) ) // If up is high and the block is within the gap of the left and right platforms of layer 1 platforms (which uses right and left platforms 1)
					begin
						blkpos_y <= blkpos_y - 10'd200;  // Move the block upward by 200
					end
				else if ( (up) && !(blkpos_x + width < right_platform_1 + 6'd5 && blkpos_x > left_platform_1 - 6'd5) ) // else If up is high and the block is not within the gap of the left and right platforms of layer 1 platforms.
					begin
						blkpos_y <= blkpos_y - 10'd100; // Move the block upward by 100, essentially making it not reach the top range that would place it on top of the next platfoms.
					end
			end
			
		else if ( (blkpos_y + height >= top_layer_3 - 3'd5 && blkpos_y + height < top_layer_3 + 3'd6) // Detecting platforms of layer 3
					&& ( (blkpos_x < left_platform_3) || (blkpos_x  + width> right_platform_3) ) ) // If the student's y position is close to the top of layer 3 and its x position is not within the gap of the platforms.
			begin
				blkpos_y <= top_layer_3 - height; // Move the block above the top of layer 3 i.e. (its stays on top of the platforms)
				if ( (up) && (blkpos_x + width < right_platform_2 + 6'd5 && blkpos_x > left_platform_2 - 6'd5) ) // If up is high and the block is within the gap of the left and right platforms of layer 2 platforms (which uses right and left platforms 2)
					begin
						blkpos_y <= blkpos_y - 10'd200; // Move the block upward by 200
					end
				else if ( (up) && !(blkpos_x + width < right_platform_2 + 6'd5 && blkpos_x > left_platform_2 - 6'd5) ) // else If up is high and the block is not within the gap of the left and right platforms of layer 2 platforms.
					begin
						blkpos_y <= blkpos_y - 10'd100; // Move the block upward by 100, essentially making it not reach the top range that would place it on top of the next platfoms.
					end
			end

		else if ( (blkpos_y + height >= top_layer_4 - 3'd5 && blkpos_y + height < top_layer_4 + 3'd6) // Detecting platforms of layer 4.
				   && ( (blkpos_x < left_platform_1) || (blkpos_x  + width > right_platform_1) )) // If the student's y position is close to the top of layer 4 and its x position is not within the gap of the platforms.
			begin
				blkpos_y <= top_layer_4 - height; // Move the block above the top of layer 4 i.e. (its stays on top of the platforms)
					if ((up) && (blkpos_x + width < right_platform_3 + 6'd5 && blkpos_x > left_platform_3 - 6'd5)) // If up is high and the block is within the gap of the left and right platforms of layer 3 platforms (which uses right and left platforms 3)
					begin
					  blkpos_y <= blkpos_y - 10'd200; // Move the block upward by 200
					end
					else if ((up) && !(blkpos_x + width < right_platform_3 + 6'd5 && blkpos_x > left_platform_3 - 6'd5)) // else If up is high and the block is not within the gap of the left and right platforms of layer 3 platforms.
                        begin
						blkpos_y <= blkpos_y - 10'd100; // Move the block upward by 100, essentially making it not reach the top range that would place it on top of the next platfoms.
					    end		
            end
		else if ((blkpos_y + height >= top_layer_5 - 3'd5 && blkpos_y + height < top_layer_5 + 3'd6) // Detecting platforms of layer 5.
				   && ( (blkpos_x < left_platform_2) || (blkpos_x  + width > right_platform_2) )) // If the student's y position is close to the top of layer 5 and its x position is not within the gap of the platforms.
			begin
				blkpos_y <= top_layer_5 - height ; // Move the block above the top of layer 5 i.e. (its stays on top of the platforms)
					if ((up) && (blkpos_x + width < right_platform_1 + 6'd5 && blkpos_x > left_platform_1 - 6'd5)) // If up is high and the block is within the gap of the left and right platforms of layer 4 platforms (which uses right and left platforms 1)
					begin
					  blkpos_y <= blkpos_y - 10'd200;  // Move the block upward by 200
					end
					else if ((up) && !(blkpos_x + width < right_platform_1 + 6'd5 && blkpos_x > left_platform_1 - 6'd5)) // else If up is high and the block is not within the gap of the left and right platforms of layer 4 platforms.
					begin
					  blkpos_y <= blkpos_y - 10'd70; // Move the block upward by 70, because the space between this layer and the one above it is not as big as the others.
					end
			end  
																													 
		else 
                begin
                    blkpos_y <= blkpos_y + 10'd7; // Gravity always pulling down 
                end  
                                         

        // HW collision detection -----------------------------------------------
        if ((blkpos_x + width > hw1_x_reg) && (blkpos_x < hw1_x_reg + 11'd32) && // if the right edge of the student is more than the left egde of the HW and the left edge of the student is less than the right edge of the HW
            (blkpos_y + height > hw1_y_reg) && (blkpos_y < hw1_y_reg + 10'd32)) begin // and the bottom of the HW is more than top of the HW and the Top of the student is less than the bottom of the Hw, essentially checking for overlap
            // Collision with HW 1
            hw1_flag <= 1; // set the hw1 flag to one indicating there is collision
            dissappear_flag1 <= 1; // set the dissappear flag to cjange its color to the background color
            hw1_x_reg <= 11'd900; // we move its position to off the screen 
            hw1_y_reg <= 11'd900;
        end 
        else
         begin
            hw1_flag <= 0; // otherwise there is no collision
            hw1_y_reg <= (hw1_y_reg + 11'd32 > ymax) ? ymin : top_layer_1 - 11'd40; // the HW y position changes with the movement of the layers, if it reaches the bottom it starts again at the top
         end

        if ((blkpos_x + width > hw2_x_reg) && (blkpos_x < hw2_x_reg + 11'd32) &&
            (blkpos_y + height > hw2_y_reg) && (blkpos_y < hw2_y_reg + 10'd32)) begin
            // Collision with HW 2
            hw2_flag <= 1;
            dissappear_flag2 <= 1;
            hw2_x_reg <= 11'd1100;
            hw2_y_reg <= 11'd900;
        end
         else
         begin
            hw2_flag <= 0;
            hw2_y_reg <= (hw2_y_reg + 11'd32 > ymax) ? ymin : top_layer_3 - 11'd40;
         end

        if ((blkpos_x + width > hw3_x_reg) && (blkpos_x < hw3_x_reg + 11'd32) &&
            (blkpos_y + height > hw3_y_reg) && (blkpos_y < hw3_y_reg + 10'd32)) begin
            // Collision with HW 3
            hw3_flag <= 1;
            dissappear_flag3 <= 1;
            hw3_x_reg <= 11'd900;
            hw3_y_reg <= 11'd900;
        end
        else
         begin
            hw3_flag <= 0;
            hw3_y_reg <= (hw3_y_reg + 11'd32 > ymax) ? ymin : top_layer_5 - 11'd40;
         end
         
         if ((blkpos_x + width > gold_x_reg) && (blkpos_x < gold_x_reg + 11'd32) &&
            (blkpos_y + height > gold_y_reg) && (blkpos_y < gold_y_reg + 10'd32)) begin
            // Collision with golden HW
            gold_flag <= 1;
            dissappear_flag4 <= 1;
            gold_x_reg <= 11'd1100;
            gold_y_reg <= 11'd900;
        end
         else
         begin
            gold_flag <= 0;
            gold_y_reg <= (gold_y_reg + 11'd32 > ymax) ? ymin : top_layer_2 - 11'd40;
         end
        
        // Set LED lights to ON when there is a collision indicated by the flag
        led1_reg <= (hw1_flag == 1) ? 1 : 0;
        led2_reg <= (hw2_flag == 1) ? 1 : 0;
        led3_reg <= (hw3_flag == 1) ? 1 : 0;
        led4_reg <= (gold_flag == 1) ? 1 : 0;
        
        
        // Check if the position of the HW blk has changed, we make sure its flag is 1 meaning a collision happened
        if (hw1_x_reg == 11'd900) begin
            hw1_flag <= 1;
        end else begin // else a collision has not occured and the y position of the HW updates.
            hw1_flag <= 0; 
            hw1_y_reg <= (hw1_y_reg + 11'd32 > ymax) ? ymin : top_layer_1 - 11'd40;
        end

        if (hw2_x_reg == 11'd1100) begin
            hw2_flag <= 1;
        end else begin
        hw2_flag <=0;
            hw2_y_reg <= (hw2_y_reg + 11'd32 > ymax) ? ymin : top_layer_3 - 11'd40;
        end
        
        if (hw3_x_reg == 11'd900) begin
            hw3_flag <= 1;
        end else begin
            hw3_flag <= 0;
            hw3_y_reg <= (hw3_y_reg + 11'd32 > ymax) ? ymin : top_layer_5 - 11'd40;
        end     
        
        
        if (gold_x_reg == 11'd1100) begin
            gold_flag <= 1;
        end else begin
        gold_flag <=0;
            gold_y_reg <= (gold_y_reg + 11'd32 > ymax) ? ymin : top_layer_2 - 11'd40;
        end  
        
    end

    // Output assignments
    assign hw1_x = hw1_x_reg;
    assign hw1_y = hw1_y_reg;
    assign hw2_x = hw2_x_reg;
    assign hw2_y = hw2_y_reg;
    assign hw3_x = hw3_x_reg;
    assign hw3_y = hw3_y_reg;
    assign gold_x = gold_x_reg;
    assign gold_y = gold_y_reg;
    assign blkpos_x1 = blkpos_x;
    assign blkpos_y1 = blkpos_y;
    assign win = win_flag;
    assign lose = lose_flag;
    assign dissappear_flag_1 = dissappear_flag1;
    assign dissappear_flag_2 = dissappear_flag2;
    assign dissappear_flag_3 = dissappear_flag3;
    assign dissappear_flag_4 = dissappear_flag4;
    assign reminder_flag1 = reminder_flag1_reg;
    assign reminder_flag2 = reminder_flag2_reg;
    
    // Instantiate the DownCount Module, which takes the count and turns it into the correct tens and unit values.
    Downcount MC (.count(count),.segval_u(segval_u),.segval_t(segval_t));  

    
endmodule

	