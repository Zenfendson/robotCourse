`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/06/2020 11:33:35 AM
// Design Name: 
// Module Name: Encoder
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


module Encoder
    (
    input clk,
    input rstn,
    input A,
    input B,
    input dir,
    input in_en,
    input [21:0] clock_per_ms,
    input [9:0] sample_interval,
    output [31:0] data,
    output out_en
    );
    reg [27:0] rstCounter;
    reg A_reg_0;
    reg A_reg_1;
    integer pulseCounter;
    wire ARisingEdge;
    reg interRstn;
    reg [31:0] RSTVAL;
    reg dir_reg;
    
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(in_en)
            begin
                RSTVAL <= clock_per_ms * sample_interval;
                dir_reg <= dir;
            end
            else
            begin
                RSTVAL <= RSTVAL;
                dir_reg <= dir_reg;
            end
        end
        else
        begin
            RSTVAL <= 0;
            dir_reg <= 0;
        end
    end
    
    assign ARisingEdge = A_reg_0 == 1 & A_reg_1 == 0;
    always @ (posedge clk)
    begin
        A_reg_0 <= A;
        A_reg_1 <= A_reg_0;
    end
    
    assign data = pulseCounter;
    always @ (posedge clk)
    begin
        if(rstn & interRstn)
        begin
            case({dir_reg,ARisingEdge , B})
                3'b010: pulseCounter <= pulseCounter + 1;
                3'b011: pulseCounter <= pulseCounter - 1;
                3'b110: pulseCounter <= pulseCounter - 1;
                3'b111: pulseCounter <= pulseCounter + 1;
                default:pulseCounter <= pulseCounter;
            endcase
        end
        else
        begin
            pulseCounter <= 0;
        end
    end
    
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(rstCounter < RSTVAL - 1)
                rstCounter <= rstCounter + 1;
            else
                rstCounter <= 0; 
        end
        else
        begin
            rstCounter <= 0;
        end
    end
    
    assign out_en = ~interRstn;
    always @ (posedge clk)
    begin
        interRstn <= !(rstCounter == RSTVAL - 1);
    end

endmodule
