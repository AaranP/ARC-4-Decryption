module tb_rtl_prga();

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

        /*task printvalues;
                $display("rdy:%b, wren: %b, addr: %h, ct_addr: %h, ptaddr:%h, pt_wrdata: %h", 
                            rdy, wren, addr,ct_addr, pt_addr, pt_wrdata);

        endtask
        */

          initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                ct_rddata = 8'b0011001;
                #10;
                assert(dut.length == 8'b0011001)
                else $error("message length is not read properly");
                #2500;
                assert(dut.k == 8'b0011001)
                else $error("k length is not read properly");
                #50;
                $stop;
       
               
        end
endmodule: tb_rtl_prga