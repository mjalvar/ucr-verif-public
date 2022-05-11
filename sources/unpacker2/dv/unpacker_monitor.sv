class unpacker_monitor extends uvm_monitor;
   `uvm_component_utils(unpacker_monitor)

   uvm_analysis_port#(unpacker_transaction) mon_ap;

   virtual unpacker_if vif;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_resource_db#(virtual unpacker_if)::read_by_name
            (.scope("ifs"), .name("unpacker_if"), .val(vif)));
      mon_ap = new(.name("mon_ap"), .parent(this));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      integer unpacker_mon = 0, state = 0;

      unpacker_transaction tx;
      tx = unpacker_transaction::type_id::create
              (.name("tx"), .contxt(get_full_name()));
      tx.pkt.data[0] = 0;

      `uvm_info(get_full_name(), "monitor: start",UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
           begin
              //Send the transaction to the analysis port
              mon_ap.write(tx);
           end
      end
   endtask: run_phase
endclass: unpacker_monitor
