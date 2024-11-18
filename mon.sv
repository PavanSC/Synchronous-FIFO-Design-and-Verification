class mon extends uvm_monitor;
  
  virtual fifo_if vif;

  uvm_analysis_port#(trans) ap;
  
  `uvm_component_utils(mon)
 

  function new(string name="mon", uvm_component parent=null);
    super.new(name, parent);
    ap=new("ap", this);
  endfunction
  
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual fifo_if)::get(this, "", "fifo_if", vif)) begin
       `uvm_fatal("build_phase", "No virtual interface specified for this monitor instance")
       end
   endfunction
  
  

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
     trans rd;
     rd=trans::type_id::create("rd",this);
      @(posedge vif.clk)
      wait(vif.wen==1 || vif.ren==1);
      begin
        if(vif.wen==1) 
         begin
          rd.wen=vif.wen;
          rd.din=vif.din;
          rd.full=vif.full;
         // @(posedge vif.clk)
        end
        else if(vif.ren==1) 
         begin
          rd.ren=vif.ren;
          @(posedge vif.clk)
          @(posedge vif.clk)
          rd.dout=vif.dout;
          rd.empty=vif.empty;

        end
        ap.write(rd);
`uvm_info("MON",$sformatf("printing from Monitor \n %s", rd.sprint()),UVM_LOW)
      end
    end
  endtask
endclass
    