class unpacker_driver #(max_pkt_size=160) extends uvm_driver#(unpacker_transaction);
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
      integer packet_counter = 0, state = 0, data_size = 0;
      `uvm_info(get_full_name(), "driver: start",UVM_LOW)

      vif.sig_reset_L = 1'b0;
      vif.sig_val = 1'b0;
      vif.sig_sop = 1'b0;
      vif.sig_eop = 1'b0;
      vif.sig_vbc = 8'b0;
      vif.sig_data = 1279'b0;
      forever begin
         if(data_size == 0)
         begin
            seq_item_port.get_next_item(tx);
            `uvm_info("unpacker_driver", tx.sprint(), UVM_LOW);
            data_size = tx.pkt.size;
            vif.sig_val = 1'b0;
         end
         if(data_size > 160)
         begin
            state = 1;
         end
         if(data_size == 160)
         begin
            state = 2;
         end
         if(data_size < 160)
         begin
            state = 3;
         end

         @(posedge vif.sig_clock)
            begin
               case(state)
                  1: 
                  begin
                     vif.sig_reset_L = 1'b1;
                     vif.sig_sop = 1'b1;
                     vif.sig_val = 1'b1;
                     vif.sig_vbc = 8'd160;
                     vif.data = tx.pkt.data[max_pkt_size*packet_counter*8 +: max_pkt_size*8];
                     packet_counter++;
                     data_size = data_size - max_pkt_size;
                  end
                  2:
                  begin
                     vif.sig_reset_L = 1'b1;
                     vif.sig_sop = 1'b1;
                     vif.sig_val = 1'b1;
                     vif.sig_vbc = 8'd160;
                     vif.sig_eop = 1'b1;
                     vif.data = tx.pkt.data[max_pkt_size*packet_counter*8 +: max_pkt_size*8];
                     packet_counter = 0;
                     data_size = 0;
                     state = 0;
                     seq_item_port.item_done();
                  end
                  3:
                  begin
                     vif.sig_reset_L = 1'b1;
                     vif.sig_sop = 1'b1;
                     vif.sig_val = 1'b1;
                     vif.sig_vbc = data_size;
                     vif.sig_eop = 1'b1;
                     vif.data = tx.pkt.data[max_pkt_size*packet_counter*8 +: data_size*8];
                     packet_counter = 0;
                     data_size = 0;
                     state = 0;
                     seq_item_port.item_done();
                  end
               endcase
              seq_item_port.get_next_item(tx);
              // `uvm_info("driver tx", tx.sprint(), UVM_LOW);
              seq_item_port.item_done();
           end
      end
   endtask: drive
endclass: unpacker_driver
