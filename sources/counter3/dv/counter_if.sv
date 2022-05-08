interface counter_if;
	
	
		localparam WIDTH_P = 4;
		
		logic clk;
    	logic reset_L;

    	logic en;
    	logic clr;
    	logic [WIDTH_P-1:0] inc;

    	logic overflow;
    	logic non_zero;
    	logic [WIDTH_P-1:0] val;
	
	
endinterface: counter_if
