class unpacker_monitor_in extends uvm_monitor;
   `uvm_component_utils(unpacker_monitor_in)

   uvm_analysis_port#(unpacker_transaction) mon_ap;

   virtual unpacker_if vif;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_resource_db#(virtual unpacker_if)::read_by_name
            (.scope("ifs"), .name("unpacker_if"), .val(vif)));
      mon_ap = new(.name("mon_ap_in"), .parent(this));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      integer unpacker_mon = 0, state = 0, pkg_size = 0, a = 0, b = 0, size = 0;
      //logical [9:0] pkg_size;
      

      unpacker_transaction tx;
      tx = unpacker_transaction::type_id::create
              (.name("tx"), .contxt(get_full_name()));
      tx.pkt.data[0] = 0;

      `uvm_info(get_full_name(), "monitor_in: start", UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
            begin
               if(vif.sig_val==1'b1)
               begin
                  if(vif.sig_ready==1'b1)
                  begin
                     tx.pkt.size = tx.pkt.size + vif.sig_vbc;
                     a = size + vif.sig_vbc;
                     b = size;
                     ///tx.pkt.data[a-1:b]=vif.sig_data;
                     if (vif.sig_sop==1'b1)
                     begin
                        tx.pkt.size = vif.sig_vbc;
                        size = vif.sig_vbc;
                        ///tx.pkt.data[size-1:0]=vif.sig_data;
                        end
                     if (vif.sig_eop==1'b1)
                     begin
                        /// write transcaction ////
                        mon_ap.write(tx);
                     end
                  end
               end
            end
      end
   endtask: run_phase
endclass: unpacker_monitor_in

class unpacker_monitor_out extends uvm_monitor;
   `uvm_component_utils(unpacker_monitor_out)

   uvm_analysis_port#(unpacker_transaction) mon_ap;

   virtual unpacker_if vif;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_resource_db#(virtual unpacker_if)::read_by_name
            (.scope("ifs"), .name("unpacker_if"), .val(vif)));
      mon_ap = new(.name("mon_ap_out"), .parent(this));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      integer unpacker_mon = 0, state = 0, pkg_size = 0, a = 0, b = 0, size = 0;

      unpacker_transaction tx;
      tx = unpacker_transaction::type_id::create
              (.name("tx"), .contxt(get_full_name()));
      tx.pkt.data[0] = 0;

      `uvm_info(get_full_name(), "monitor_out: start", UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
         begin
            if(vif.sig_val==1'b0)
            begin
               state = 0;
               tx.pkt.size = 0;
            end else begin
               if(vif.sig_sop==1'b1)
               begin
                  state = 2;
               end else begin
                  if(vif.sig_eop==1'b1)
                  begin
                     state = 4;
                  end else begin
                     state = 3;
                  end
               end
            end

            // state = 2 -> val = 1, sop = 1, eop = 0
            if(state == 2)
            begin
               tx.pkt.size = vif.sig_o_vbc;
               size = vif.sig_o_vbc;
               ///tx.pkt.data[size-1:0] = vif.sig_o_data;
            end

            // state = 3 -> val = 1, sop = 0, eop = 0
            if(state == 3)
            begin
               tx.pkt.size = tx.pkt.size + vif.sig_o_vbc;
               a = size + vif.sig_o_vbc;
               b = size;
               ///tx.pkt.data[a-1:b] = vif.sig_o_data;
            end

            // state = 4 -> val = 1, sop = 0, eop = 1
            if(state == 4)
            begin
               tx.pkt.size = tx.pkt.size + vif.sig_o_vbc;
               a = size + vif.sig_o_vbc;
               b = size;
               ///tx.pkt.data[a-1:b] = vif.sig_o_data;
               // write transaction ////
               mon_ap.write(tx);
            end
         end  
      end
   endtask: run_phase
endclass: unpacker_monitor_out
