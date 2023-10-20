`timescale 1 ps / 1 ps

module tb_rtl_arc4();

// Your testbench goes here.
        logic clk, rst_n, en, rdy, pt_wren;
        logic [23:0] key;
        logic [7:0] ct_addr, ct_rddata, pt_addr, pt_rddata, pt_wrdata;

        arc4 dut(.*);

        initial begin
	    CLOCK_50 <= 1'b0;
	    forever #5 CLOCK_50 <= ~CLOCK_50;
        end

        task printvalues;
                $display("rdy:%b, wren: %b, addr: %h, ct_addr: %h, ptaddr:%h, pt_wrdata: %h", 
                            rdy, wren, addr,ct_addr, pt_addr, pt_wrdata);

        endtask

          initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                rddata = 8'b0011001;
                #10;
                printvalues;
                #10;
                rddata = 8'b11111111
                printvalues;


       
                rst_n =0; 
                en= 0;
                #10;
                printvalues;
                #10;
       
                rst_n =1; 
                en= 0;
                #10;
                printvalues;
                #10;
       
                rst_n =0; 
                en= 1;
                #10;
                printvalues;
                #10;
        end

        initial begin
                rst_n = 1;
                en = 1;
                addr = 8'b0;
                key = 24'h000000;
                #10;
                 for (int i = 0; i < 256; i = i + 1) begin
            // Change the key for each test vector
                key = {24'h000000, i};

                $display(" Test vector: %d, rdy:%b, wren: %b, addr: %h, ct_addr: %h, ptaddr:%h, pt_wrdata: %h", 
                            i, rdy, wren, addr,ct_addr, pt_addr, pt_wrdata);
                end

                asserrt(dut.)

                $finish;
        end

        

        





endmodule: tb_rtl_arc4
