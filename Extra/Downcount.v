`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2023 12:51:18 AM
// Design Name: 
// Module Name: Downcount
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Downcount(
    input [5:0] count,
    output reg [6:0] segval_t,
    output reg [6:0] segval_u
); 

    always @* begin
        case (count)
            6'd0: begin segval_u = 7'b1000000; segval_t = 7'b1000000; end // Display 0
            6'd1: begin segval_u = 7'b1111001; segval_t = 7'b1000000; end // Display 1
            6'd2: begin segval_u = 7'b0100100; segval_t = 7'b1000000; end // Display 2
            6'd3: begin segval_u = 7'b0110000; segval_t = 7'b1000000; end // Display 3
            6'd4: begin segval_u = 7'b0011001; segval_t = 7'b1000000; end // Display 4
            6'd5: begin segval_u = 7'b0010010; segval_t = 7'b1000000; end // Display 5
            6'd6: begin segval_u = 7'b0000010; segval_t = 7'b1000000; end // Display 6
            6'd7: begin segval_u = 7'b1111000; segval_t = 7'b1000000; end // Display 7
            6'd8: begin segval_u = 7'b0000000; segval_t = 7'b1000000; end // Display 8
            6'd9: begin segval_u = 7'b0010000; segval_t = 7'b1000000; end // Display 9
            6'd10: begin segval_u = 7'b1000000; segval_t = 7'b1111001; end // Display 10
            6'd11: begin segval_u = 7'b1111001; segval_t = 7'b1111001; end // Display 11
            6'd12: begin segval_u = 7'b0100100; segval_t = 7'b1111001; end // Display 12
            6'd13: begin segval_u = 7'b0110000; segval_t = 7'b1111001; end // Display 13
            6'd14: begin segval_u = 7'b0011001; segval_t = 7'b1111001; end // Display 14
            6'd15: begin segval_u = 7'b0010010; segval_t = 7'b1111001; end // Display 15
            6'd16: begin segval_u = 7'b0000010; segval_t = 7'b1111001; end // Display 16
            6'd17: begin segval_u = 7'b1111000; segval_t = 7'b1111001; end // Display 17
            6'd18: begin segval_u = 7'b0000000; segval_t = 7'b1111001; end // Display 18
            6'd19: begin segval_u = 7'b0010000; segval_t = 7'b1111001; end // Display 19
            default: begin segval_t = 7'b0111111; segval_u = 7'b0111111; end // Display nothing for other values
        endcase
    end
    endmodule

