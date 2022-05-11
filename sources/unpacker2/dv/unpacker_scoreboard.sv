`uvm_analysis_imp_decl(_sb)

class unpacker_scoreboard extends uvm_scoreboard;
   `uvm_component_utils(unpacker_scoreboard)

   uvm_analysis_export #(unpacker_transaction) sb_export;
   uvm_tlm_analysis_fifo #(unpacker_transaction) fifo;

   unpacker_transaction transaction;

    function new(string name, uvm_component parent);
      super.new(name, parent);

      transaction = new("transaction");
   endfunction: new

   function void build_phase(uvm_phase phase);
      super.build_phase(phase);

      sb_export  = new("sb_export", this);

      fifo = new("fifo", this);
   endfunction: build_phase

   function void connect_phase(uvm_phase phase);
      sb_export.connect(fifo.analysis_export);
   endfunction: connect_phase

   task run();
      forever begin
         fifo.get(transaction);
         compare();
      end
   endtask: run

   virtual function void compare();
         `uvm_info("transaction", transaction.sprint(), UVM_LOW);
      if (transaction.pkt.data[0] == 0) begin
         `uvm_info("compare", {"Test: OK!"}, UVM_LOW);
      end else begin
         `uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
      end
   endfunction: compare
endclass: unpacker_scoreboard
