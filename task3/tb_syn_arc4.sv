`timescale 1 ps / 1 ps
`define reset 4'd1
`define start 4'd2
`define initialize 4'd3
`define keyschedule 4'd4
`define randomnum 4'd5
`define done 4'd6
`define pause 4'd7
`define keyschedule2 4'd8
`define randomnum2 4'd9

module tb_syn_arc4();

// Your testbench goes here.
        logic clk, rst_n, en, rdy, pt_wren;
        logic [23:0] key;
        logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata;

        arc4 dut(.*);

        initial begin
	    clk <= 1'b0;
	    forever #5 clk <= ~clk;
        end

        //task printvalues;
       //         $display("rdy:%b, wren: %b, addr: %h, ct_addr: %h, ptaddr:%h, pt_wrdata: %h", 
                            //rdy, wren, addr,ct_addr, pt_addr, pt_wrdata);

        //endtask

          initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                ct_rddata = 8'b0011001;
                #10;
                assert(dut.current_state == `start)
                else $error ("module didn't start");
                #2500;

                assert(dut.current_state == `initialize)
                else $error ("module not in initialize state");
                #2500;

                assert(dut.current_state == `keyschedule)
                else $error ("KSA did not start");
                #2500;

                assert(dut.current_state == `randomnum)
                else $error("prga is not started");

                $stop;
               


       
               
        end

       




endmodule: tb_syn_arc4