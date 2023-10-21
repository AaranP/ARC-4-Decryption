
`timescale 1 ps / 1 ps
module tb_syn_ksa();

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

        initial begin
                rst_n = 1;
                en = 1;
                addr = 8'b0;
                key = 24'h000000;
                #10;
                 for (int i = 0; i < 256; i = i + 1) begin
            // Change the key for each test vector
                key = {24'h000000, i};

                $display("Test vector %d, addr: %h, rdy:%b, wrdata: %b, wren: %b", 
                          i, addr, rdy, wrdata, wren);
                end

                $finish;
        end
    

endmodule: tb_syn_ksa