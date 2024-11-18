class drv extends uvm_driver#(trans);
`uvm_component_utils(drv)

virtual fifo_if dif;

function new(string name="drv", uvm_component parent=null);
 super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 if(!uvm_config_db#(virtual fifo_if)::get(this,"","fifo_if",dif))
  `uvm_fatal("DRV CONFIG","have u set it??")
endfunction


task run_phase(uvm_phase phase);
forever begin
trans req;
seq_item_port.get_next_item(req);
`uvm_info("DRV",$sformatf("printing from Driver \n %s", req.sprint()),UVM_LOW)

drive_to_dut(req);
seq_item_port.item_done();
end
endtask

task drive_to_dut(trans d1);
//forever begin
@(posedge dif.clk)

 if(dif.rst) begin
  dif.ren <= 1'b0;
  dif.wen <= 1'b0;
  dif.din <= 1'b0;
  dif.dout <= 1'b0;
end

else begin
 dif.ren <= d1.ren;
 dif.wen <= d1.wen;
 dif.din <= d1.din;
 dif.dout <= d1.dout;
end

//end
endtask

endclass