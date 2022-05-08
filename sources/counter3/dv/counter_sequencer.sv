class counter_transaction extends uvm_sequence_item;
	
	localparam WIDTH_P = 4;
	
	rand bit en;
	rand bit clr;
	rand bit[WIDTH_P-1:0] inc;

    bit overflow;
    bit non_zero;
    bit[WIDTH_P-1:0] val;
	

	function new(string name = "");
		super.new(name);
	endfunction: new

	`uvm_object_utils_begin(counter_transaction)
		`uvm_field_int(en, UVM_ALL_ON)
		`uvm_field_int(clr, UVM_ALL_ON)
		`uvm_field_int(inc, UVM_ALL_ON)
		`uvm_field_int(overflow, UVM_ALL_ON)
		`uvm_field_int(non_zero, UVM_ALL_ON)
		`uvm_field_int(val, UVM_ALL_ON)
	`uvm_object_utils_end
endclass: counter_transaction

class counter_sequence extends uvm_sequence#(counter_transaction);
	`uvm_object_utils(counter_sequence)

	function new(string name = "");
		super.new(name);
	endfunction: new

	task body();
		counter_transaction ct_tx;

		repeat(15) begin
		ct_tx = counter_transaction::type_id::create(.name("ct_tx"), .contxt(get_full_name()));

		start_item(ct_tx);
		assert(ct_tx.randomize());
		`uvm_info("ct_sequence", ct_tx.sprint(), UVM_LOW);
		finish_item(ct_tx);
		end
	endtask: body
endclass: counter_sequence

typedef uvm_sequencer#(counter_transaction) counter_sequencer;
