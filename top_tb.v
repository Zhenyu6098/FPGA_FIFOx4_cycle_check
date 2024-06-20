`timescale 1ns/1ps
module top_tb();

reg         clk           ;
reg         rst_n         ;
reg         fifo1_wrreq   ;
reg         fifo2_wrreq   ;
reg         fifo3_wrreq   ;
reg         fifo4_wrreq   ;
reg  [31:0] fifo1_data_in ;
reg  [31:0] fifo2_data_in ;
reg  [31:0] fifo3_data_in ;
reg  [31:0] fifo4_data_in ;

wire        data_valid    ;
wire [63:0] up_data       ;  

initial begin
clk   = 0;
rst_n = 0;
#200
rst_n = 1;
end

always #10 clk = ~clk;

reg [4:0] cnt1;
reg [4:0] cnt2;
reg [4:0] cnt3;
reg [4:0] cnt4;

always@(posedge clk or negedge rst_n)
    if(~rst_n)
        cnt1 <= 0;
    else if(cnt1==2)
        cnt1 <= 0;
    else 
        cnt1 <= cnt1 +1;
always@(posedge clk or negedge rst_n)
    if(~rst_n)begin
        fifo1_data_in <= 0;
        fifo1_wrreq <= 0;end
    else if(cnt1==2)begin
        fifo1_data_in <= {$random}%4000;
        fifo1_wrreq <= 1;end
    else begin
        fifo1_data_in <= 0;
        fifo1_wrreq <= 0;end


always@(posedge clk or negedge rst_n)
    if(~rst_n)
        cnt2 <= 0;
    else if(cnt2==3)
        cnt2 <= 0;
    else 
        cnt2 <= cnt2 +1;
always@(posedge clk or negedge rst_n)
    if(~rst_n)begin
        fifo2_data_in <= 0;
        fifo2_wrreq <= 0;end
    else if(cnt2==3)begin
        fifo2_data_in <= {$random}%5000;
        fifo2_wrreq <= 1;end
    else begin
        fifo2_data_in <= 0;
        fifo2_wrreq <= 0;end
        

always@(posedge clk or negedge rst_n)
    if(~rst_n)
        cnt3 <= 0;
    else if(cnt3==6)
        cnt3 <= 0;
    else 
        cnt3 <= cnt3 +1;
always@(posedge clk or negedge rst_n)
    if(~rst_n)begin
        fifo3_data_in <= 0;
        fifo3_wrreq <= 0;end
    else if(cnt3==6)begin
        fifo3_data_in <= {$random}%6000;
         fifo3_wrreq <= 1;end
    else begin
        fifo3_data_in <= 0;
        fifo3_wrreq <= 0;end
        
        
always@(posedge clk or negedge rst_n)
    if(~rst_n)
        cnt4 <= 0;
    else if(cnt4==8)
        cnt4 <= 0;
    else 
        cnt4 <= cnt4 +1;
always@(posedge clk or negedge rst_n)
    if(~rst_n)begin
        fifo4_data_in <= 0;
        fifo4_wrreq <= 0;end
    else if(cnt4==8)begin
        fifo4_data_in <= {$random}%7000;
        fifo4_wrreq <= 1;end
    else begin
        fifo4_data_in <= 0;
        fifo4_wrreq <= 0;end



top top_1(
    .    clk           ( clk          ) ,
    .    rst_n         ( rst_n        ) ,
    .    fifo1_wrreq   ( fifo1_wrreq  ) ,
    .    fifo2_wrreq   ( fifo2_wrreq  ) ,
    .    fifo3_wrreq   ( fifo3_wrreq  ) ,
    .    fifo4_wrreq   ( fifo4_wrreq  ) ,
    .    fifo2_data_in ( fifo2_data_in) ,
    .    fifo1_data_in ( fifo1_data_in) ,
    .    fifo3_data_in ( fifo3_data_in) ,
    .    fifo4_data_in ( fifo4_data_in) ,

    .    data_valid    ( data_valid   ) ,
    .    up_data       ( up_data      )   
);

endmodule