class unpacker_monitor_in extends uvm_monitor;
   `uvm_component_utils(unpacker_monitor_in)

   uvm_analysis_port#(unpacker_transaction) mon_ap;

   virtual unpacker_if vif;

   unpacker_transaction tlm;

   covergroup covgrp1_in;
      reset_L : coverpoint vif.sig_reset_L {
         bins test_reset = (0=>1=>0=>1=>0=>1);
      }
      all_pkt_size :   coverpoint tlm.pkt.size;
      zero_zero_zero : coverpoint tlm.pkt.size {
         bins test1 = (0=>0=>0);
      }

   endgroup: covgrp1_in 

   covergroup covgrp2_in;
      small_small : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>[1:32]);
      }
      small_medium : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>[33:160]);
      }
      small_large : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>[161:1024]);
      }
      medium_small : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>[1:32]);
      }
      medium_medium : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>[33:160]);
      }
      medium_large : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>[1:32]);
      }
      large_small : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>[1:32]);
      }
      large_medium : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>[33:160]);
      }
      large_large : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>[161:1024]);
      }
   endgroup: covgrp2_in

   covergroup covgrp3_in;
      small_zero_small : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>0=>[1:32]);
      }
      small_zero_medium : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>0=>[33:160]);
      }
      small_zero_large : coverpoint tlm.pkt.size {
         bins test1 = ([1:32]=>0=>[161:1024]);
      }
      medium_zero_small : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>0=>[1:32]);
      }
      medium_zero_medium : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>0=>[33:160]);
      }
      medium_zero_large : coverpoint tlm.pkt.size {
         bins test1 = ([33:160]=>0=>[1:32]);
      }
      large_zero_small : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>0=>[1:32]);
      }
      large_zero_medium : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>0=>[33:160]);
      }
      large_zero_large : coverpoint tlm.pkt.size {
         bins test1 = ([161:1024]=>0=>[161:1024]);
      }
   endgroup: covgrp3_in

   function new(string name, uvm_component parent);
      super.new(name, parent);
      covgrp1_in = new();
      covgrp2_in = new();
      covgrp3_in = new();
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      void'(uvm_resource_db#(virtual unpacker_if)::read_by_name
            (.scope("ifs"), .name("unpacker_if"), .val(vif)));
      mon_ap = new(.name("mon_ap_in"), .parent(this));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      integer shift = 0;

      tlm = unpacker_transaction::type_id::create
              (.name("tlm"), .contxt(get_full_name()));

      `uvm_info(get_full_name(), "monitor_in: start", UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
         begin
            covgrp1_in.sample();
            covgrp2_in.sample();
            covgrp3_in.sample();

            if(vif.sig_reset_L==0)
              begin
                 // This is just to discard the current pkt TLM
                 tlm.op = OP_RESET_L;
                 continue;
              end

            if(vif.sig_val==1 && vif.sig_ready==1)
              begin
                 tlm.pkt.size = tlm.pkt.size + vif.sig_vbc;
                 shift = shift + 160*8;
                 tlm.pkt.data = tlm.pkt.data + (vif.sig_data << shift);
                 if (vif.sig_sop==1)
                   begin
                      shift = 0;
                      tlm.op = OP_PACKET;
                      tlm.pkt.size = vif.sig_vbc;
                      tlm.pkt.data = vif.sig_data;
                   end
                 if (vif.sig_eop==1 && tlm.op==OP_PACKET)
                   begin
                      mon_ap.write(tlm.clone());
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

   unpacker_transaction tlm;

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
      integer shift = 0;

      tlm = unpacker_transaction::type_id::create
              (.name("tlm"), .contxt(get_full_name()));
      tlm.op = OP_MAX;

      `uvm_info(get_full_name(), "monitor_out: start", UVM_LOW)

      forever begin
         @(posedge vif.sig_clock)
         begin
            if(vif.sig_reset_L==0)
              begin
                 tlm.op = OP_RESET_L;
                 continue;
              end
            else if(vif.sig_reset_L==1 && tlm.op==OP_RESET_L)
              begin
                 mon_ap.write(tlm.clone());
                 tlm.op = OP_MAX;
              end

            if(vif.sig_o_val==1)
              begin
                 tlm.pkt.size = tlm.pkt.size + vif.sig_o_vbc;
                 shift = shift + 32*8;
                 tlm.pkt.data = tlm.pkt.data + (vif.sig_o_data << shift);

                 if (vif.sig_o_sop==1)
                   begin
                      shift = 0;
                      tlm.op = OP_PACKET;
                      tlm.pkt.size = vif.sig_o_vbc;
                      tlm.pkt.data = vif.sig_o_data;
                   end
                 if (vif.sig_o_eop==1 && tlm.op==OP_PACKET)
                   begin
                      mon_ap.write(tlm.clone());
                   end
              end
         end
      end
   endtask: run_phase
endclass: unpacker_monitor_out
