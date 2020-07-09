`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/29/2020 10:57:21 AM
// Design Name: 
// Module Name: PWM_Generator
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


module PWM_Generator
(
    input clk,
    input rstn,
    input [10:0] data,
    input wren,
    input [31:0] frqz_ratio,
    input dir_set,
    output reg PWM,
    output reg dir
    );
    localparam COUNTER_MAXVAL = 1000;
    
    wire [9:0] data_in;
    wire sign_in;
    assign {sign_in,data_in} = data;
    reg [9:0] data_reg0;
    reg sign_reg0;
    reg [9:0] data_reg1;
    reg sign_reg1;
    
    reg [9:0] pwm_counter;
    reg [19:0] clk_counter;
    reg clk_work;
    
    reg rst_reg;
    reg inter_rst;
    reg [31:0] frqz_ratio_reg;
    reg dir_set_reg;
    reg [31:0] clk_div_fac_reg;
    
    always @ (posedge clk)
    begin
        clk_div_fac_reg <= frqz_ratio_reg/COUNTER_MAXVAL;
    end
    always @ (posedge clk)
    begin
        if(!rstn)
        begin
            rst_reg <= 1;
        end
        else if(inter_rst)
        begin
            rst_reg <= 0;
        end
        else 
            rst_reg <= rst_reg;
    end
    
    always @ (posedge clk_work)
    begin
        if(rst_reg)
            inter_rst <= 1;
        else
            inter_rst <= 0;
    end
    always @ (posedge clk)
    begin
        if(dir_set_reg == 0)
            dir <= sign_reg1;
        else
            dir <= ~sign_reg1;
    end
    always @ (posedge clk)
    begin
        PWM <= data_reg1 == 1000? 1 : pwm_counter > COUNTER_MAXVAL - data_reg1 - 1;
    end
    always @ (posedge clk)
    begin
        clk_work <= ( clk_counter <= clk_div_fac_reg / 2 - 1)? 0:1;
    end
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(clk_counter < clk_div_fac_reg - 1)
                clk_counter = clk_counter + 1;
            else 
                clk_counter <= 0;
        end
        else
            clk_counter <= 0;
    end
    
    always @ (posedge clk_work)
    begin
        if(inter_rst)
        begin
            pwm_counter <= 0;
        end
        else
        begin
            if(pwm_counter < COUNTER_MAXVAL - 1)
                pwm_counter = pwm_counter + 1;
            else 
                pwm_counter <= 0;
        end
    end
    
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(pwm_counter == 0)
            begin
                sign_reg1 <= sign_reg0;
                data_reg1 <= sign_reg0 ? ~data_reg0 + 1 : data_reg0;
            end
            else
            begin 
                sign_reg1 <= sign_reg1;
                data_reg1 <= data_reg1;
            end
        end
        else
        begin
            sign_reg1 <= 0;
            data_reg1 <= 0;
        end
    end
    
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(wren)
            begin
                dir_set_reg <= dir_set;
                frqz_ratio_reg <= frqz_ratio;
                sign_reg0 <= sign_in;
                data_reg0 <= data_in;
            end
            else
            begin
                dir_set_reg <= dir_set_reg;
                frqz_ratio_reg <= frqz_ratio_reg; 
                sign_reg0 <= sign_reg0;
                data_reg0 <= data_reg0;
            end
        end
        else
        begin
            dir_set_reg <= 0;
            frqz_ratio_reg <= 1000000; 
            sign_reg0 <= 0;
            data_reg0 <= 0;
        end
    end
endmodule

