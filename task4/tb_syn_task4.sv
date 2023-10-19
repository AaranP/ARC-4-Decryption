`timescale 1 ps / 1 ps
module tb_syn_task4();

// Your testbench goes here.
reg CLOCK_50;
reg [3:0] KEY;
reg [9:0] SW;

wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [9:0] LEDR;

task4 dut(.CLOCK_50(CLOCK_50), .KEY(KEY), .SW(SW),
             .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
             .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
             .LEDR(LEDR));

initial begin
	CLOCK_50 <= 1'b0;
	forever #5 CLOCK_50 <= ~CLOCK_50;
end

initial begin
  //put your own directory here, and make sure it's forward slashes not backward slashes
	$readmemh("C:/Users/idara/Documents/Lab-3-CPEN311/task3/test2.memh", dut.ct.altsyncram_component.m_default.altsyncram_inst.mem_data);
	KEY[3] = 1'b0;
	#10;
	KEY[3] = 1'b1;

		#100000;
		
	$stop;
end


endmodule: tb_syn_task4
