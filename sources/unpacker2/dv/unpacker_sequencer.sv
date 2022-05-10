class unpacker_transaction extends uvm_sequence_item;
   // TODO: Implement transaction
   rand integer data;

   function new(string name = "");
      super.new(name);
   endfunction: new

   `uvm_object_utils_begin(unpacker_transaction)
      `uvm_field_int(data, UVM_ALL_ON)
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
