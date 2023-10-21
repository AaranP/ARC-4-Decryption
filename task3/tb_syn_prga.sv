`define reset       4'd1 //length of message is read
`define start       4'd2
`define state1      4'd3
`define state2      4'd4
`define state3      4'd5
`define state4      4'd6 
`define state5      4'd7
`define state6      4'd8
`define done        4'd9
`define state7     4'd10 
`define state8     4'd11
`define state9     4'd12
`define donea 4'd13

module tb_syn_prga();

// Your testbench goes here.


logic clk, rst_n, en, rdy;
logic [23:0] key;
logic [7:0] s_addr, s_rddata, s_wrdata;
logic s_wren;
logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata; 
logic pt_wren;

        prga dut(.*);

        initial begin
	    clk <= 1'b0;
	    forever #5 clk <= ~clk;
        end

        task printvalues;
                $display("rdy:%b, wren: %b, addr: %h, ct_addr: %h, ptaddr:%h, pt_wrdata: %h", 
                            rdy, wren, addr,ct_addr, pt_addr, pt_wrdata);

        endtask

          initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                ct_rddata = 8'b0011001;
                #10;
                assert(dut.current_state == `start)
                else $error("state not in start mode");
                printvalues;

                #2500;
                assert(dut.current_state == `donea)
                else $error("enable is still on");
                printvalues;

                #2500;
                assert(dut.current_state == `done)
                else $error("state is not in done");
                printvalues; 
                #50;

                rst_n=0;
                assert(dut.current_state == `reset && rdy ==1)
                else $error("state is not reset and ready is not set to 1 ");


                $stop;


       
               
        end
endmodule: tb_syn_prga