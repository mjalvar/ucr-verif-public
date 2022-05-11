class txn_packet #(max_size=1024) extends uvm_object;
   rand bit [max_size*8-1:0] data;
   rand bit [10:0]   size;

   constraint limit_size { size > 0; size <= max_size; }
   constraint limit_data { data <= (1 << (size * 8)) - 1; }

   function new(string name = "");
      super.new(name);
   endfunction: new

   `uvm_object_utils_begin(txn_packet)
      `uvm_field_int(data,UVM_ALL_ON)
      `uvm_field_int(size,UVM_ALL_ON)
   `uvm_object_utils_end
endclass: txn_packet

class unpacker_transaction extends uvm_sequence_item;
   typedef enum {
      OP_PACKET
   } op_t;

   op_t op;
   rand txn_packet pkt;

   function new(string name = "");
      super.new(name);
      pkt = new("pkt");
   endfunction: new

   `uvm_object_utils_begin(unpacker_transaction)
      `uvm_field_enum(op_t,op,UVM_ALL_ON)
      `uvm_field_object(pkt,UVM_ALL_ON)
   `uvm_object_utils_end
endclass: unpacker_transaction

class unpacker_sequence extends uvm_sequence#(unpacker_transaction);
   `uvm_object_utils(unpacker_sequence)

   function new(string name = "");
      super.new(name);
   endfunction: new

   task body();
      unpacker_transaction tx;

      repeat(15) begin
         tx = unpacker_transaction::type_id::create(.name("tx"), .contxt(get_full_name()));

         start_item(tx);
         assert(tx.randomize());
         //`uvm_info("sequence", tx.sprint(), UVM_LOW);
         finish_item(tx);
      end
   endtask: body
endclass: unpacker_sequence

typedef uvm_sequencer#(unpacker_transaction) unpacker_sequencer;
