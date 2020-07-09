`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/28/2020 09:06:59 AM
// Design Name: 
// Module Name: ultrasonic_ranger
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


module ultrasonic_ranger(
    input clk,
    input rstn,
    output [31:0] rawdata,
    output valid,
    input sig_i,
    output sig_o,
    output sig_t,
    output reg [3:0] state,
    output reg [31:0]usCounter,
    output sig_in_dbg
    );
    assign sig_in_dbg = sig_i;
    parameter PULSES_PER_US = 100;
    parameter SAMP_FRQZ = 100;
    parameter PULSE_WIDTH_US = 5;
    parameter TIMEOUT = 1000000;
    wire[31:0] sampMicroPulses;
    assign  sampMicroPulses = 1000000 / SAMP_FRQZ;
    //state def
    localparam IDLE = 0;
    localparam RSTC0 = 1;
    localparam SEND = 2;
    localparam WAIT0 = 3;
    localparam WAIT1 = 4;
    localparam RSTC1 = 5;
    localparam RECV = 6;
    localparam WRITE = 7;
    localparam CLEAR = 8;
    //reg [3:0] state;
    //
    //sig def
    wire sig_out;
    wire sig_in;
    reg sig_in_reg;
    wire dir;                              //direction:1 out;0 in 
    //
    //time counter def
    //reg[31:0] usCounter;
    reg[9:0] usGenCounter;
    wire counterRstn;
    wire clk_1m;
    //
    
    assign valid = state == WRITE;
    assign rawdata = usCounter;
    //fsm
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            case(state)
            IDLE:
            begin
            if(usCounter >= sampMicroPulses)
                state <= RSTC0;
            else
                state <= state;
            end
            RSTC0:
            begin
                state <= SEND;
            end
            SEND:
            begin
            if(usCounter >= PULSE_WIDTH_US+1)
                state <= WAIT0;
            else
                state <= state;
            end
            WAIT0:
            begin
                state <= WAIT1;
            end
            WAIT1:
            begin
            if(sig_in_reg)
                state <= RSTC1;
            else if(usCounter >= TIMEOUT)
                state <= WRITE; 
            else
            state <= state;
            end
            RSTC1:
            begin
                state <= RECV;
            end
            RECV:
            begin
            if(!sig_in_reg)
                state <= WRITE;
            else
                state <= state;
            end
            WRITE:
            begin
                state <= CLEAR;
            end
            CLEAR:
            begin
                state <= IDLE;
            end
            default:
            begin
                state <= IDLE;
            end
            endcase
        end
        else
        begin
            state <= IDLE;
        end
    end
    //
    //generate us pulses
    assign clk_1m = usGenCounter< PULSES_PER_US / 2 - 1;
    always @ (posedge clk)
    begin
        if(rstn)
        begin
            if(usGenCounter <= PULSES_PER_US-1)
                usGenCounter <= usGenCounter + 1;
            else
                usGenCounter <= 0;
        end
        else
        begin
            usGenCounter <= 0;
        end
    end
    //
    
    //usCounter operation def
    assign counterRstn = !(state == RSTC0 | state == RSTC1 | state == WAIT0 | state == CLEAR);
    always @ (posedge clk_1m or negedge counterRstn or negedge rstn)
    begin
        if(!counterRstn | !rstn)
            usCounter <= 0;
        else
        begin
        if(usCounter <= TIMEOUT)
            usCounter <= usCounter + 1;
        else
            usCounter = 0;
        end
    end
    //
    
    //sig def
    assign sig_o = sig_out;
    assign sig_in = sig_i;
    assign sig_t = !dir;
    assign dir = state != RECV & state != WAIT1 & state != RSTC1;
    assign sig_out = state == SEND & usCounter != 0;
    always @ (posedge clk)
    begin
        sig_in_reg <= sig_in;
    end
    //
endmodule
