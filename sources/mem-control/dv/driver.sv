`include "uvm_macros.svh"

import uvm_pkg::*;

class mem_item extends uvm_sequence_item;

  rand logic [31:0] Address;
  rand logic [7:0]  bl;

  constraint legal {
    Address < 32'h10000;
    Address > 32'h100; 
    bl >= 4;
    bl < 8;
  }  

  // Use utility macros to implement standard functions
  // like print, copy, clone, etc
  `uvm_object_utils_begin(mem_item)
  	`uvm_field_int (Address, UVM_DEFAULT)
  	`uvm_field_int (bl, UVM_DEFAULT)	
  `uvm_object_utils_end

  function new(string name = "mem_item");
    super.new(name);
  endfunction
endclass

class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)
  function new(string name="gen_item_seq");
    super.new(name);
  endfunction

  rand int num; 	// Config total number of items to be sent

  constraint c1 { num inside {[2:5]}; }

  virtual task body();
    for (int i = 0; i < num; i ++) begin
    	mem_item m_item = mem_item::type_id::create("m_item");
    	start_item(m_item);
    	m_item.randomize();
    	`uvm_info("SEQ", $sformatf("Generate new item: "), UVM_LOW)
    	m_item.print();
      	finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", num), UVM_LOW)
  endtask
endclass


class memory_driver extends uvm_driver #(mem_item);

  `uvm_component_utils (memory_driver)
   function new (string name = "memory_driver", uvm_component parent = null);
     super.new (name, parent);
   endfunction

   virtual mem_intf mem_if;

   virtual function void build_phase (uvm_phase phase);
     super.build_phase (phase);
     if(uvm_config_db #(virtual mem_intf)::get(this, "", "VIRTUAL_INTERFACE", mem_if) == 0) begin
       `uvm_fatal("INTERFACE_CONNECT", "Could not get from the database the virtual interface for the TB")
     end
   endfunction
   
   virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      mem_item m_item;
      `uvm_info("DRV", $sformatf("Wait for item from sequencer"), UVM_LOW)
      seq_item_port.get_next_item(m_item);
      drive_mem(m_item);
      seq_item_port.item_done();
    end
  endtask  

  virtual task drive_mem(mem_item m_item);
       
    @ (negedge mem_if.sys_clk);
     $display("Write Address: %x, Burst Size: %d",m_item.Address,m_item.bl);

     for(int i=0; i < m_item.bl; i++) begin
       mem_if.wb_stb_i        = 1;
       mem_if.wb_cyc_i        = 1;
       mem_if.wb_we_i         = 1;
       mem_if.wb_sel_i        = 4'b1111;
       mem_if.wb_addr_i       = m_item.Address[31:2]+i;
       mem_if.wb_dat_i        = $random & 32'hFFFFFFFF;
      
       do begin
         @ (posedge mem_if.sys_clk);
       end while(mem_if.wb_ack_o == 1'b0);
         @ (negedge mem_if.sys_clk);
      
       $display("Status: Burst-No: %d  Write Address: %x  WriteData: %x",i,mem_if.wb_addr_i,mem_if.wb_dat_i);
     end
     
     mem_if.wb_stb_i        = 0;
     mem_if.wb_cyc_i        = 0;
     mem_if.wb_we_i         = 'hx;
     mem_if.wb_sel_i        = 'hx;
     mem_if.wb_addr_i       = 'hx;
     mem_if.wb_dat_i        = 'hx;

   endtask 

endclass
   


