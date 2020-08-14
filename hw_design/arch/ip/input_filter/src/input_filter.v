`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/12/2020 09:53:16 AM
// Design Name: 
// Module Name: input_filter
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


module input_filter#
    (
        parameter FILTER_SIZE = 32,
        parameter INPUT_WIDTH = 2
    )
    (
    input clk,
    input [INPUT_WIDTH-1:0]in_data,
    output reg [INPUT_WIDTH-1:0]out_data
    );
    integer i;
    reg [FILTER_SIZE-1:0]shift_reg[INPUT_WIDTH-1:0];
    
    always @ (posedge clk)
    begin
        for(i=0;i<INPUT_WIDTH;i=i+1)
        begin
            shift_reg[i] <= {shift_reg[i][FILTER_SIZE-2:0],in_data[i]};
        end
    end
    
    always @ (posedge clk)
    begin
        for(i=0;i<INPUT_WIDTH;i=i+1)
        begin
            if(&shift_reg[i]) out_data[i] <= 1;
            else if(~(|shift_reg[i])) out_data[i] <= 0;
            else out_data[i] <= out_data[i];
        end
    end
endmodule
