class unpacker_driver extends uvm_driver#(unpacker_transaction);
   `uvm_component_utils(unpacker_driver)

   virtual unpacker_if vif;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_resource_db#(virtual unpacker_if)::read_by_name
            (.scope("ifs"), .name("unpacker_if"), .val(vif)));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      drive();
   endtask: run_phase

   virtual task drive();
      unpacker_transaction tx;
      integer unpacker = 0, state = 0;
      `uvm_info(get_full_name(), "driver: start",UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
           begin
              seq_item_port.get_next_item(tx);
              // `uvm_info("driver tx", tx.sprint(), UVM_LOW);
              seq_item_port.item_done();
           end
      end
   endtask: drive
endclass: unpacker_driver
