module top();

import uvm_pkg::*;
import fifo_pkg::*;

bit clk;


initial begin
clk=1'b0;
forever #5 clk = ~clk;
end


fifo_if intf(clk);


fifo DUT(.clk(intf.clk), .rst(intf.rst), .din(intf.din), .dout(intf.dout), .wen(intf.wen), .ren(intf.ren), .full(intf.full), .empty(intf.empty), .fifo_cnt(intf.fifo_cnt));


initial begin
 uvm_config_db#(virtual fifo_if)::set(null,"*","fifo_if",intf);
end

initial begin
run_test();
end




property reset;
 @(posedge clk)
  (intf.rst==0 |=> (intf.full==0 && intf.empty==1));
endproperty


property fifo_full;
 @(posedge clk)
  disable iff(!intf.rst)
   ((intf.fifo_cnt>15) |-> intf.full==1);
endproperty


property fifo_not_full;
 @(posedge clk)
  disable iff(!intf.rst)
   ((intf.fifo_cnt < 15) |-> !(intf.full));
endproperty


property fifo_go_full;
@(posedge clk)
 disable iff(!intf.rst)
 ((intf.fifo_cnt == 15 && intf.ren==0 && intf.wen==1) |=> intf.full);
endproperty


/*property full_write_full;
    @(posedge clk) 
    disable iff (!intf.rst)
    (intf.full && intf.wen && !intf.ren |=> intf.full && $stable(intf.wptr) );
  endproperty*/
  
  property fifo_empty;
    @(posedge clk)
    disable iff(!intf.rst)
    (intf.fifo_cnt==0 |-> intf.empty );
  endproperty 
    
  property empty_read;
    @(posedge clk) 
    disable iff(!intf.rst)
    (intf.empty && intf.ren && !intf.wen |=> intf.empty);
  endproperty
  

  
  assert property(reset)
    begin
      $display($time, ": Assertion Passed: The design passed the reset condition");
      $display(" full flag and empty flag are now reset");
    end
    else
      $display("Assertion Failed: The design failed the reset condition");
      
  assert property(fifo_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo full condition.");
      $display("Fifo full flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo full condition.");
   
  assert property(fifo_not_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo not full condition.");
      $display("Fifo full flag is not high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo not full condition.");
    
    
  assert property(fifo_go_full)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo should go full condition.");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo should go full condition.");
   
    
 /*ssert property(full_write_full)
    begin
      $display($time, ": Assertion Passed: The design passed the write in full fifo condition.");
      $display("You are writing in a full fifo and fifo full flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the write in full fifo condition.");*/
  
    
  assert property(fifo_empty)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo empty condition.");
      $display("Fifo empty flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo empty condition.");
   
  assert property(empty_read)
    begin
      $display($time, ": Assertion Passed: The design passed the fifo empty read condition.");
      $display("You are trying to read from empty fifo, fifo empty flag is high");
    end
    else
      $display($time, ": Assertion Failed: The design failed the fifo empty read condition.");
   

endmodule