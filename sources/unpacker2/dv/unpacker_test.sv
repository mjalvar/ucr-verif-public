class unpacker_test extends uvm_test;

   `uvm_component_utils(unpacker_test)

   unpacker_env env;

   function new(string name, uvm_component parent);
      super.new(name, parent);
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = unpacker_env::type_id::create(.name("env"), .parent(this));
   endfunction: build_phase

   task run_phase(uvm_phase phase);
      unpacker_sequence seq;

      phase.raise_objection(.obj(this));
      seq = unpacker_sequence::type_id::create(.name("seq"), .contxt(get_full_name()));
      assert(seq.randomize());
      seq.start(env.agent.seqr);
      phase.drop_objection(.obj(this));
   endtask: run_phase

endclass: unpacker_test
