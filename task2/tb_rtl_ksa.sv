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

        initial begin
                rst_n = 1;
                en = 1;
                key = 24'h000000;
                rddata = 8'b0011001;
                #10;
                $display("rdy:%b, wrdata: %b, wren: %b, addr: %b", rdy, wrdata, wren, addr);
                #10;
                rddata = 8'b11111111
                $display("rdy:%b, wrdata: %b, wren: %b, addr: %b", rdy, wrdata, wren, addr);


       
                rst_n =0; 
                en= 0;
                #10;
                $display("rdy:%b, wrdata: %b, wren: %b, addr: %b", rdy, wrdata, wren, addr);
                #10;
       
                rst_n =1; 
                en= 0;
                #10;
                $display("rdy:%b, wrdata: %b, wren: %b, addr: %b", rdy, wrdata, wren, addr);
                #10;
       
                rst_n =0; 
                en= 1;
                #10;
                $display("rdy:%b, wrdata: %b, wren: %b, addr: %b", rdy, wrdata, wren, addr);
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

                $display("Test vector %d, addr: %h, rddata: %h, rdy:%b, wrdata: %b, wren: %b", 
                          i, addr, rddata, rdy, wrdata, wren);
                end

                $finish;
        end
    

endmodule: tb_rtl_ksa
