`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2020 10:53:12 AM
// Design Name: 
// Module Name: analog2digital
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


module analog2digital#
    (
        parameter HIGH_THRESHOLD = 18000,
        parameter LOW_THRESHOLD = 8000,
        parameter A0_ID = 17,
        parameter A1_ID = 22,
        parameter B0_ID = 25,
        parameter B1_ID = 31
    )
    (
    input [15:0] s_axis_tdata,
    input [4:0] s_axis_tid,
    input s_axis_tvalid,
    output s_axis_tready,
    input s_axis_aclk,
    output reg A0,
    output reg A1,
    output reg B0,
    output reg B1
    );
    assign s_axis_tready = 1;
    reg [15:0] A0_reg;
    reg [15:0] A1_reg;
    reg [15:0] B0_reg;
    reg [15:0] B1_reg;
    
    initial
    begin
        A0 = 0;
        A1 = 0;
        B0 = 0;
        B1 = 0;
        A0_reg = 0;
        A1_reg = 0;
        B0_reg = 0;
        B1_reg = 0;
    end
    
    always @ (posedge s_axis_aclk)
    begin
        if(s_axis_tvalid)
        begin
            case(s_axis_tid)
                A0_ID: {A0_reg,A1_reg,B0_reg,B1_reg} <= {s_axis_tdata,A1_reg,B0_reg, B1_reg};
                A1_ID:{A0_reg,A1_reg,B0_reg,B1_reg} <= {A0_reg,s_axis_tdata,B0_reg,B1_reg};
                B0_ID:{A0_reg,A1_reg,B0_reg,B1_reg} <= {A0_reg,A1_reg,s_axis_tdata,B1_reg};
                B1_ID:{A0_reg,A1_reg,B0_reg,B1_reg} <= {A0_reg,A1_reg,B0_reg,s_axis_tdata};
                default:{A0_reg,A1_reg,B0_reg,B1_reg} <= {A0_reg,A1_reg,B0_reg,B1_reg};
            endcase
        end
        else
        begin
            {A0_reg,A1_reg,B0_reg,B1_reg} <= {A0_reg,A1_reg,B0_reg,B1_reg};
        end
    end
    
    always @ (posedge s_axis_aclk)
    begin
        if(A0 == 0)
        begin
            if(A0_reg >= HIGH_THRESHOLD) A0 <= 1;
            else A0 <= A0;
        end
        else
        begin
            if(A0_reg <= LOW_THRESHOLD) A0 <= 0;
            else A0 <= A0;
        end
        
        if(A1 == 0)
        begin
            if(A1_reg >= HIGH_THRESHOLD) A1 <= 1;
            else A1 <= A1;
        end
        else
        begin
            if(A1_reg <= LOW_THRESHOLD) A1 <= 0;
            else A1 <= A1;
        end
        
        if(B0 == 0)
        begin
            if(B0_reg >= HIGH_THRESHOLD) B0 <= 1;
            else B0 <= B0;
        end
        else
        begin
            if(B0_reg <= LOW_THRESHOLD) B0 <= 0;
            else B0 <= B0;
        end
        
        if(B1 == 0)
        begin
            if(B1_reg >= HIGH_THRESHOLD) B1 <= 1;
            else B1 <= B1;
        end
        else
        begin
            if(B1_reg <= LOW_THRESHOLD) B1 <= 0;
            else B1 <= B1;
        end
    end
endmodule
