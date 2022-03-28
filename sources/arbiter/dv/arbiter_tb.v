
// Testbench Code Goes here
module arbiter_tb;

reg clock, reset, req0,req1;
wire gnt0,gnt1;

initial begin

  $dumpfile("test.vcd");
  $dumpvars(0);

  $monitor ("req0=%b,req1=%b,gnt0=%b,gnt1=%b", req0,req1,gnt0,gnt1);
  clock = 0;
  reset = 0;
  req0 = 0;
  req1 = 0;
  #5 reset = 1;
  #15 reset = 0;
  #10 req0 = 1;
  #10 req0 = 0;
  #10 req1 = 1;
  #10 req1 = 0;
  #10 {req0,req1} = 2'b11;
  #10 {req0,req1} = 2'b00;
  #10 $finish;
end

always begin
 #5 clock = !clock;
end

arbiter U0 (
.clock (clock),
.reset (reset),
.req_0 (req0),
.req_1 (req1),
.gnt_0 (gnt0),
.gnt_1 (gnt1)
);


property valid_transition_prop;
  @ (posedge clock) 
    disable iff (reset)
  U0.state==U0.GNT0 |=> (U0.state==U0.GNT0 || U0.state==U0.IDLE); // cannot be GNT1
endproperty
  
  valid_transition_assert : assert property (valid_transition_prop)
                 else
                 $display("@%0dns Assertion Failed", $time);
    
property valid_transition_prop_2;
  @ (posedge clock) 
    disable iff (reset)
     U0.state==U0.GNT0 |-> (U0.next_state==U0.GNT0 || U0.next_state==U0.IDLE); // cannot be GNT1
endproperty
  
    valid_transition_2_assert : assert property (valid_transition_prop_2)
                 else
                 $display("@%0dns Assertion Failed", $time);

property gnt0_1_mutex_prop;
  @ (posedge clock) 
    disable iff (reset)
    !(U0.gnt_0 && U0.gnt_1); // cannot gnt0 and gnt1 cannot be 1 at same time
endproperty
  
    gnt0_1_mutex_assert : assert property (gnt0_1_mutex_prop)
                 else
                 $display("@%0dns Assertion Failed", $time);

// assert !(U0.gnt_0 && U0.gnt_1) else $display("@%0dns Assertion Failed", $time);

endmodule
