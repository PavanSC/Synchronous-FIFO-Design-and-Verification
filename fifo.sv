module fifo(clk,rst,din,dout,wen,ren,full,empty,fifo_cnt);

 input clk,rst;    //clock, reset
 input [31:0] din; //32 bit data input
 input wen,ren;              // Read and write enable
 output reg [4:0] fifo_cnt;  // 5 bit counter to count upto 16
 output reg [31:0] dout;     // 32 bit data output
 output reg full,empty;      // empty and full signals
 
 reg [31:0] mem [0:15];      // memory array with 16 bit depth and 32 bit width
 reg [3:0] rptr,wptr;        // 4 bit read and write pointers for 16 locations


 // Assigning empty and full condition
 assign empty = (fifo_cnt == 0)? 1 : 0;
 assign full  = (fifo_cnt == 16)? 1 : 0;


 // Counter block 
 always @(posedge clk)begin
  if(!rst)
   fifo_cnt <= 0;  // Reset counter
  else begin
   case ({wen,ren})
    2'b00: fifo_cnt <= fifo_cnt;  // No operation
    2'b01: fifo_cnt <= (fifo_cnt==0) ? 0: fifo_cnt - 1;   //read
    2'b10: fifo_cnt <= (fifo_cnt==16) ? 16: fifo_cnt + 1; //write
    2'b11: fifo_cnt <= fifo_cnt;  // Write and read simultaneoulsy
   endcase
  end
 end



// Pointer block
always @(posedge clk) begin
 if(!rst) begin
  wptr <=0;  // Reset write pointer
  rptr <=0;  //Reset read pointer
 end
 else begin
  wptr <= ((wen && !full)) || ((wen && ren)) ? wptr + 1 : wptr;
  rptr <= ((ren && !empty)) || ((wen && ren)) ? rptr + 1 : rptr;
 end
end


// Write block
always @(posedge clk) begin
 if(wen && !full)
  mem[wptr] <=din; //Write data into memory
 else if (wen && ren)
  mem[wptr] <=din;
end



// Read block
always @(posedge clk) begin
 if((ren && !empty) || (wen && ren)) begin
  dout <= mem[rptr];  // Read data from memory
end
end

endmodule
 
  
 