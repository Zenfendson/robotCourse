`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2020 09:52:03 AM
// Design Name: 
// Module Name: motor_ctrl_sel
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


module motor_ctrl_sel(
    input PWM,
    input dir,
    input sel,
    output reg out1,
    output reg out2
    );
    
    always @ *
    begin
        case({sel,dir})
        2'b00:
        begin
            out1 <= PWM;
            out2 <= dir;
        end
        2'b01:
        begin
            out1 <= PWM;
            out2 <= dir;
        end
        2'b10:
        begin
            out1 <= PWM;
            out2 <= 0;
        end
        2'b11:
        begin
            out1 <= 0;
            out2 <= PWM;
        end
        default:
        begin
            out1 <= PWM;
            out2 <= dir;
        end
        endcase
    end
endmodule
