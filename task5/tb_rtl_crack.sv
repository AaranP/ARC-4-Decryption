`timescale 1 ps / 1 ps
module tb_rtl_crack();

reg clk, rst_n, en, kv;
reg [7:0] ct_rddata;
reg [23:0] key_start;

wire rdy, key_valid, flagk;
wire [23:0] key;
wire [7:0] ct_addr;

// Your testbench goes here.
crack dut (.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .key_start(key_start),
             .key(key), .key_valid(key_valid), .ct_addr(ct_addr),
             .ct_rddata(ct_rddata), .kv(kv), .flagk(flagk));

initial begin
	clk <= 1'b0;
	forever #5 clk <= ~clk;
end

task printvalues;
	$display("rdy: %b, key_valid: %b, key: %h, ct_addr: %h", rdy, key_valid, key, ct_addr);
endtask

initial begin
	key_start = 24'h000000;
	rst_n = 1'b0;
	#10;
	rst_n = 1'b1;
	ct_rddata = 8'd2;
	printvalues;

	en = 1'b1;
	#10;
	en = 1'b0;

	#28000;
	printvalues;

	#28000;
	printvalues;


	#28000;
	printvalues;

	#28000;
	printvalues;

	dut.key = 24'hfffff0;
	
	#24000;
	printvalues;
	
	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	rst_n = 1'b0;
	key_start = 24'h000001;
	#10;
	rst_n = 1'b1;
	ct_rddata = 8'd2;
	printvalues;

	en = 1'b1;
	#10;
	en = 1'b0;

	#28000;
	printvalues;

	#28000;
	printvalues;


	#28000;
	printvalues;

	#28000;
	printvalues;

	dut.key = 24'hfffff1;
	
	#24000;
	printvalues;
	
	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;

	#24000;
	printvalues;



	$stop;
end

endmodule: tb_rtl_crack
