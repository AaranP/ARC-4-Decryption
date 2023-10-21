
`timescale 1 ps / 1 ps
module tb_rtl_ksa();

// Your testbench goes here.

        logic clk,  rst_n;
        logic en,  rdy,wren;
        logic [23:0] key;
        logic [7:0] addr, rddata,  wrdata;

        ksa DUT(
            .clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .key(key), .addr(addr),
            .rddata(rddata), .wrdata(wrdata), .wren(wren)
        );

        initial begin  //reset
                clk = 0;
                forever#5 clk = ~clk;
        end

        task printvalues;
                $display("rdy:%b, wrdata: %h, wren: %b, addr: %h", rdy, wrdata, wren, addr);

        endtask

        initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                rddata = 8'b0011001;
                #10;
                printvalues;
                #10;
                rddata = 8'b11111111;
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

            

endmodule: tb_rtl_ksa