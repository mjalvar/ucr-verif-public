interface counter_if;
	
		logic clk;
    	logic reset_L;

    	logic en;
    	logic clr;
    	logic [4-1:0] inc;

    	logic overflow;
    	logic non_zero;
    	logic [4-1:0] val;
	
	
endinterface: counter_if
