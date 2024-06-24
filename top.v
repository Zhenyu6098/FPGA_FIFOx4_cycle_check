module top(
    input   wire         clk            ,
    input   wire         rst_n          ,
    input   wire         fifo1_wrreq    ,
    input   wire         fifo2_wrreq    ,
    input   wire         fifo3_wrreq    ,
    input   wire         fifo4_wrreq    ,
    input   wire [31:0]  fifo1_data_in  ,
    input   wire [31:0]  fifo2_data_in  ,
    input   wire [31:0]  fifo3_data_in  ,
    input   wire [31:0]  fifo4_data_in  ,
                                        
    output  wire         data_valid     ,
    output  wire [63:0]  up_data          
);

wire  [12:0] fifo1_rdusedw ;
wire  [12:0] fifo2_rdusedw ;
wire  [12:0] fifo3_rdusedw ;
wire  [12:0] fifo4_rdusedw ;

wire         fifo1_rdreq   ;
wire         fifo2_rdreq   ;
wire         fifo3_rdreq   ;
wire         fifo4_rdreq   ;

wire  [63:0] fifo1_out     ;
wire  [63:0] fifo2_out     ;
wire  [63:0] fifo3_out     ;
wire  [63:0] fifo4_out     ;

 cycle_check_out cycle_check_out_1(
    .clk           ( clk           ) ,
    .rst_n         ( rst_n         ) ,
    .fifo1_rdusedw ( fifo1_rdusedw ) ,
    .fifo2_rdusedw ( fifo2_rdusedw ) ,
    .fifo3_rdusedw ( fifo3_rdusedw ) ,
    .fifo4_rdusedw ( fifo4_rdusedw ) ,
    .fifo1_out     ( fifo1_out     ) ,
    .fifo2_out     ( fifo2_out     ) ,
    .fifo3_out     ( fifo3_out     ) ,
    .fifo4_out     ( fifo4_out     ) ,
    
    .fifo1_rdreq   ( fifo1_rdreq   ) ,
    .fifo2_rdreq   ( fifo2_rdreq   ) ,
    .fifo3_rdreq   ( fifo3_rdreq   ) ,
    .fifo4_rdreq   ( fifo4_rdreq   ) ,
    .data_valid    ( data_valid    ) ,
    .up_data       ( up_data       )  
);

fifo32in_64out	fifo1 (
	.data    ( fifo1_data_in  ),
	.rdclk   ( clk            ),
	.rdreq   ( fifo1_rdreq    ),
	.wrclk   ( clk            ),
	.wrreq   ( fifo1_wrreq    ),
	.q       ( fifo1_out      ),
	.rdusedw ( fifo1_rdusedw  )
);
fifo32in_64out	fifo2 (
	.data    ( fifo2_data_in  ),
	.rdclk   ( clk            ),
	.rdreq   ( fifo2_rdreq    ),
	.wrclk   ( clk            ),
	.wrreq   ( fifo2_wrreq    ),
	.q       ( fifo2_out      ),
	.rdusedw ( fifo2_rdusedw  )
);
fifo32in_64out	fifo3 (
	.data    ( fifo3_data_in  ),
	.rdclk   ( clk            ),
	.rdreq   ( fifo3_rdreq    ),
	.wrclk   ( clk            ),
	.wrreq   ( fifo3_wrreq    ),
	.q       ( fifo3_out      ),
	.rdusedw ( fifo3_rdusedw  )
);
fifo32in_64out	fifo4 (
	.data    ( fifo4_data_in  ),
	.rdclk   ( clk            ),
	.rdreq   ( fifo4_rdreq    ),
	.wrclk   ( clk            ),
	.wrreq   ( fifo4_wrreq    ),
	.q       ( fifo4_out      ),
	.rdusedw ( fifo4_rdusedw  )
);                            


endmodule