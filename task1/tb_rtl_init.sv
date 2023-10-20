module tb_rtl_init();
        logic clk, rst_n, en;
        logic rdy;
        logic[7:0] addr, wrdata, wren;
    
        init DUT(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .addr(addr), .wr(data), .wren(wren));\

        

        initial begin  //reset
                clk = 0;
                forever#5 clk = ~clk;
        end

        initial begin
                rst_n = 1;
                en = 0;
        end
    

// Your testbench goes here.

endmodule: tb_rtl_init
