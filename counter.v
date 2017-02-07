//Lab 8 : 4-bit Counter implementation in verilog

// Top level stimulus module
module testbed;

	// Declare variables for stimulating input
	reg CLK, CLEAR_BAR;
	wire [3:0] NUM;
	
	initial
		$monitor($time," Count : %d",NUM);
		
	//Instantiate the design block counter	
	//NUM is the 4-bit output from the counter
	//CLK is the clock signal
	//The counter should increment at each falling edge of the clock cycle 
	//CLEAR_BAR is the signal that asynchronously clears the counter. A CLEAR_BAR=0 should clear the counter.
	rippleCounter4 mycounter(NUM,CLK,CLEAR_BAR);	
		
	// reset	
	initial
	begin	
		CLEAR_BAR=1'b0;	
		#5 CLEAR_BAR=1'b1;
		#500 CLEAR_BAR=1'b0;
		#50 CLEAR_BAR=1'b1;
	end		
		
	// Set up the clock to toggle every 10 time units	
	initial
	begin
		
		//generate files needed to plot the waveform
		//you can plot the waveform generated after running the simulator by using gtkwave	
		$dumpfile("wavedata.vcd");
		$dumpvars(0,testbed);	
		CLK = 1'b0;
		forever #10 CLK = ~CLK;
		
		
	end

	// Finish the simulation at time 400
	initial
	begin
		#700 $finish;
	end
	
endmodule


//you code goes here

module rippleCounter4(NUM,CLK,CLEAR_BAR);
	input CLK,CLEAR_BAR;
	output [3:0] NUM;
	assign T = 1'b1;
	wire r1,r2,re,r4;
	//assign NUM[3] = r1;
	//assign NUM[2] = r2;
	//assign NUM[1] = r3;
	//assign NUM[0] = r4;
	
	T_flip_flop t1(NUM[0],T,CLK,CLEAR_BAR);
	T_flip_flop t2(NUM[1],T,NUM[0],CLEAR_BAR);
	T_flip_flop t3(NUM[2],T,NUM[1],CLEAR_BAR);
	T_flip_flop t4(NUM[3],T,NUM[2],CLEAR_BAR);
                                             
endmodule 

module SR_latch(Q,Q1,RESET,R,S);
	output Q,Q1;
	input S,R,RESET;
	nand (Q,R,Q1);
	nand (Q1,RESET,S,Q);
endmodule 
module D_latch(Q,Q1,D,En,RESET);
	input D,En,RESET;
	output Q,Q1;
	wire w1,w2,nD;
	not (nD,D);
	nand (w1,D,En);
	nand (w2,En,nD);
	SR_latch s1(Q,Q1,RESET,w1,w2);
endmodule 
module master_slave_D_flip_flop(Q,D,clk,RESET);
	input D,clk,RESET;
	output Q;
	wire nclk,w3,w4,w5,w6;
	not (nclk,clk);
	D_latch master(w3,w4,D,clk,RESET);
	D_latch slave(Q,w6,w3,nclk,RESET);
endmodule 
module T_flip_flop(Q,T,clk,RESET);
	input T,clk,RESET;
	output Q;
	wire w7;
	xor (w7,Q,T);
	master_slave_D_flip_flop d1(Q,w7,clk,RESET);
endmodule 
