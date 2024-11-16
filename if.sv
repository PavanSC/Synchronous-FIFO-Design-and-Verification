interface fifo_if;

 bit clk;
 bit rst_n;
 logic ren;
 logic wen;
 logic [31:0] din;
 logic empty;
 logic full;
 logic [31:0] dout;

endinterface