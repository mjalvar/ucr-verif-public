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
      integer packet_counter = 0, send = 0, data_size = 0, remainning_bytes = 0, temp_data = 160'b0;
      `uvm_info(get_full_name(), "driver: start",UVM_LOW)

      vif.sig_reset_L = 1'b0;
      vif.sig_val = 1'b0;
      vif.sig_sop = 1'b0;
      vif.sig_eop = 1'b0;
      vif.sig_vbc = 8'b0;
      vif.sig_data = 1279'b0;
      forever begin
         vif.sig_reset_L = 1'b1;

         if(send == 0)
         begin
            seq_item_port.get_next_item(tx);
            `uvm_info("unpacker_driver", tx.sprint(), UVM_LOW);
            data_size = tx.pkt.size;
            if(data_size != 0)
            begin
               remainning_bytes = data_size;
               vif.sig_sop = 1'b1;
               send = 1;
            end
         end

         //assign vif.sig_eop = (remainning_bytes < 160 && send == 1);   

         @(posedge vif.sig_clock)
            begin
               vif.sig_eop = (remainning_bytes < 160 && send == 1);

               if (vif.sig_ready  == 1'b1 && send == 1)
                  begin  
                     if(remainning_bytes == data_size)
                     begin
                        vif.sig_val = 1'b1;
                     end
                     temp_data = tx.pkt.data[max_pkt_size*packet_counter*8 +: max_pkt_size*8];
                     if(remainning_bytes >= 160)
                     begin
                        vif.sig_data = temp_data;
                        vif.sig_vbc = 8'd160;
                        remainning_bytes = remainning_bytes - 160;
                        packet_counter++; 
                     end else begin
                        vif.sig_data = temp_data >> (max_pkt_size-remainning_bytes)*8;;
                        vif.sig_vbc = remainning_bytes;
                        seq_item_port.item_done();
                        packet_counter = 0;
                        remainning_bytes = 0;
                        send = 0;
                     end
                  end

               if (remainning_bytes < data_size)
               begin
                  vif.sig_sop = 1'b0;
               end

              // `uvm_info("driver tx", tx.sprint(), UVM_LOW);
           end
      end
   endtask: drive
endclass: unpacker_driver
