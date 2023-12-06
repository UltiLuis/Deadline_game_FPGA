`timescale 1ns / 1ps

module PWM(
    input clk,
    input reminder_flag1,
    input reminder_flag2,
    output led1_r, led1_g, led1_b,
    output led2_r, led2_g, led2_b
    );
    
    // Create the PWM to drive RGBs
    reg [6:0] counter_100 = 0;
    wire pwm_30, pwm_20, pwm_10;
    reg led1_r_reg, led1_g_reg, led1_b_reg;
    reg led2_r_reg, led2_g_reg, led2_b_reg;
    
    always @(posedge clk)
    begin
        if(counter_100 == 99)
            counter_100 <= 0;
        else
            counter_100 <= counter_100 + 1;
    end
            
    assign pwm_10 = (counter_100 < 10) ? 1 : 0; // 10% duty cycle
    assign pwm_20 = (counter_100 < 20) ? 1 : 0; // 20% duty cycle
    assign pwm_30 = (counter_100 < 30) ? 1 : 0; // 30% duty cycle
    
  
    always @*
    begin
        if (reminder_flag1)
        begin
            led1_r_reg <= pwm_20; //purple
            led1_g_reg <= 1'b0;
            led1_b_reg <= pwm_10;
        end 
    end
    
    always @*
    begin
        if (reminder_flag2)
        begin
             led2_r_reg <= pwm_30; //red 
             led2_g_reg <= 1'b0;
             led2_b_reg <= 1'b0;
        end 
    end
    
    //Output Assignments
    assign led1_r = led1_r_reg;
    assign led1_g = led1_g_reg;
    assign led1_b = led1_b_reg;
    
    assign led2_r = led2_r_reg;
    assign led2_g = led2_g_reg;
    assign led2_b = led2_b_reg;
    
    
endmodule
