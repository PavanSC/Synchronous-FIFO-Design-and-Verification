class trans extends uvm_sequence_item;
`uvm_object_utils(trans)

rand bit [31:0] din;
rand bit [31:0] dout;
rand bit ren;
rand bit wen;
bit full;
bit empty;
rand bit rst;

//contsraint c1{ren != wen;};

function void pre_randomize();
 if(ren)
   din.rand_mode(0);
endfunction

function new(string name="trans");
 super.new(name);
endfunction


function void do_print(uvm_printer printer);
 super.do_print(printer);
 printer.print_field("Din",this.din,32,UVM_BIN);
 printer.print_field("Dout",this.dout,32,UVM_BIN);
 printer.print_field("REN",this.ren,1,UVM_BIN);
 printer.print_field("WEN",this.wen,1,UVM_BIN);
 printer.print_field("FUll",this.full,1,UVM_BIN);
 printer.print_field("empty",this.empty,1,UVM_BIN);
 printer.print_field("RST",this.rst,1,UVM_BIN);

endfunction

endclass

