module cycle_check_out(
input  wire         clk            ,
input  wire         rst_n          ,

input  wire  [12:0] fifo1_rdusedw  ,
input  wire  [12:0] fifo2_rdusedw  ,
input  wire  [12:0] fifo3_rdusedw  ,
input  wire  [12:0] fifo4_rdusedw  ,

input  wire  [63:0] fifo1_out      ,
input  wire  [63:0] fifo2_out      ,
input  wire  [63:0] fifo3_out      ,
input  wire  [63:0] fifo4_out      ,

output reg          fifo1_rdreq    ,
output reg          fifo2_rdreq    ,
output reg          fifo3_rdreq    ,
output reg          fifo4_rdreq    ,

output reg          data_valid     ,
output reg   [63:0] up_data         
);

parameter YUZHI       = 1024;//超过阈值开始读出数据
parameter YUZHI_POINT = YUZHI/8;//即为(阈值*8)/64

parameter HEAD        = 32'hadf90c00;

parameter IDLE       = 4'd0,
          S1check    = 4'd1,
          S1out      = 4'd2,
          S2check    = 4'd3,
          S2out      = 4'd4,
          S3check    = 4'd5,
          S3out      = 4'd6,
          S4check    = 4'd7,
          S4out      = 4'd8;

reg [3:0] state;
reg [15:0] cnt_work;
reg [63:0] cnt1;
reg [63:0] cnt2;
reg [63:0] cnt3;
reg [63:0] cnt4;

reg [31:0] CHXX_NUM;
always@(posedge clk or negedge rst_n)
    if(~rst_n)
        CHXX_NUM <= 0;
    else if(state == S1out)
        CHXX_NUM <= 1;
    else if(state == S2out)
        CHXX_NUM <= 2;
    else if(state == S3out)
        CHXX_NUM <= 3;
    else if(state == S4out)
        CHXX_NUM <= 4;
    else
        CHXX_NUM <= 0;

always@(posedge clk or negedge rst_n)
    if(~rst_n)
        begin
            state        <=  IDLE;
            cnt_work     <=  0;
            fifo1_rdreq  <=  0;
            fifo2_rdreq  <=  0;
            fifo3_rdreq  <=  0;
            fifo4_rdreq  <=  0;
            data_valid   <=  0;
            up_data      <=  0;
            cnt1         <=  0;
            cnt2         <=  0;
            cnt3         <=  0;
            cnt4         <=  0;
        end
    else case(state)
    IDLE:
        begin
            cnt_work   <= 0;
            data_valid <= 0;
            state      <= S1check;
        end
    S1check:
        begin
            if(fifo1_rdusedw >= YUZHI_POINT)
                state <= S1out;
            else 
                state <= S2check;
        end
    S1out:
        begin
            if(cnt_work == (YUZHI_POINT + 10))
                begin
                    cnt_work <= 0;
                    state    <= S2check;
                end
            else 
                cnt_work <= cnt_work + 1;

            if(state == S1out && cnt_work == 1)
                cnt1 <= cnt1 +1;
            else
                cnt1 <= cnt1;
                
            if(cnt_work == 2)
                up_data <= {HEAD,CHXX_NUM};
            else if(cnt_work == 3)
                up_data <= cnt1;
            else
                up_data <= fifo1_out;
                
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+1))
                fifo1_rdreq <= 1;  
            else                   
                fifo1_rdreq <= 0;  
            //上面up_data的赋值使用了时序逻辑
            //在计数2产生请求则在3产生数据,则在4数据才能传入updata
            //所以req的产生提前了两个时钟,才能与有效信号的第3到第130位对应
            //
            //
            //
            //若up_data的赋值在后面使用组合逻辑
            //则上方的请求信号条件应为cnt_work>=(3) && cnt_work<=(YUZHI_POINT+2))
            //组合时的赋值条件应为
            //if(cnt_work == 3)
            //    up_data <= {HEAD,CHXX_NUM};
            //else if(cnt_work == 4)
            //    up_data <= cnt1;
            //else
            //    up_data <= fifo1_out;
            //
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+3))//1到x为x个数,2到x+1也为x个数
                data_valid <= 1;
            else
                data_valid <= 0;
        end
    S2check:
        begin
            if(fifo2_rdusedw >= YUZHI_POINT)
                state <= S2out;
            else 
                state <= S3check;
        end
    S2out:
        begin
            if(cnt_work == (YUZHI_POINT +10))
                begin
                    cnt_work <= 0;
                    state    <= S3check;
                end
            else 
                cnt_work <= cnt_work + 1;
                
            if(state == S2out && cnt_work == 1)
                cnt2 <= cnt2 +1;
            else
                cnt2 <= cnt2;
                
            if(cnt_work == 2)
                up_data <= {HEAD,CHXX_NUM};
            else if(cnt_work == 3)
                up_data <= cnt2;
            else 
                up_data <= fifo2_out;
            
            
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+1))
                fifo2_rdreq <= 1;
            else 
                fifo2_rdreq <= 0;
                
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+3))
                data_valid <= 1;
            else
                data_valid <= 0;
        end
    S3check:
        begin
            if(fifo3_rdusedw >= YUZHI_POINT)
                state <= S3out;
            else 
                state <= S4check;
        end
    S3out:
        begin
            if(cnt_work == (YUZHI_POINT +10))
                begin
                    cnt_work <= 0;
                    state <= S4check;
                end
            else 
                cnt_work <= cnt_work + 1;
                
            if(state == S3out && cnt_work == 1)
                cnt3 <= cnt3 +1;
            else
                cnt3 <= cnt3;
                
            if(cnt_work == 2)
                up_data <= {HEAD,CHXX_NUM};
            else if(cnt_work == 3)
                up_data <= cnt3;
            else 
                up_data <= fifo3_out;

            
            if(cnt_wor k>= (2) && cnt_work <= (YUZHI_POINT+1))
                fifo3_rdreq <= 1;
            else 
                fifo3_rdreq <= 0;
                
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+3))
                data_valid <= 1;
            else
                data_valid <= 0;
        end
    S4check:
        begin
            if(fifo4_rdusedw >= YUZHI_POINT)
                state <= S4out;
            else 
                state <= S1check;
        end
    S4out:
        begin
            if(cnt_work == (YUZHI_POINT +10))
                begin
                    cnt_work <= 0;
                    state <= S1check;          
                end
            else 
                cnt_work <= cnt_work + 1;
      
            if(state == S4out && cnt_work == 1)
                cnt4 <= cnt4 +1;
            else
                cnt4 <= cnt4;
     
            if(cnt_work == 2)
                up_data <= {HEAD,CHXX_NUM};
            else if(cnt_work == 3)
                up_data <= cnt4;
            else 
                up_data <= fifo4_out;

      
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+1))
                fifo4_rdreq <= 1;
            else 
                fifo4_rdreq <= 0;
         
            if(cnt_work >= (2) && cnt_work <= (YUZHI_POINT+3))
                data_valid <= 1;
            else
                data_valid <= 0;
        end
endcase

endmodule
