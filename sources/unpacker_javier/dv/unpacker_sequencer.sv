class unpacker_transaction extends uvm_sequence_item;
	///rand bit[1:0] ina;
	///rand bit[1:0] inb;
	///bit[2:0] out;

	function new(string name = "");
		super.new(name);
	endfunction: new

	///`uvm_object_utils_begin(simpleadder_transaction)
		///`uvm_field_int(ina, UVM_ALL_ON)
		///`uvm_field_int(inb, UVM_ALL_ON)
		///`uvm_field_int(out, UVM_ALL_ON)
	///`uvm_object_utils_end
endclass: unpacker_transaction

class unpacker_sequence extends uvm_sequence#(unpacker_transaction);
	`uvm_object_utils(unpacker_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		unpacker_transaction unp_tx;

		repeat(15) begin
		unp_tx = unpacker_transaction::type_id::create(.name("unp_tx"), .contxt(get_full_name()));

		start_item(unp_tx);
		assert(unp_tx.randomize());
		//`uvm_info("sa_sequence", sa_tx.sprint(), UVM_LOW);
		finish_item(unp_tx);
		end
	endtask: body
endclass: unpacker_sequence

typedef uvm_sequencer#(unpacker_transaction) unpacker_sequencer;
