`timescale 1ps/1ps

module tb_rtl_init();
        logic clk, rst_n, en;
        logic rdy;
        logic[7:0] addr, wrdata, wren;
    
        init DUT(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .addr(addr), .wr(data), .wren(wren));\

        

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
                #10;
                printvalues;
                #10;
                addr = 8'b11111111
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
    

// Your testbench goes here.

endmodule: tb_rtl_init
