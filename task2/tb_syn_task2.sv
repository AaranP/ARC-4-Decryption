`define state1 4'd1
`define state2 4'd2
`define state3 4'd3
`define state4 4'd4
`define state5 4'd5
`define state6 4'd6
`define statex 4'd8
`define state7 4'd9
`define done 4'd7

`timescale 1 ps / 1 ps


module tb_syn_task2();

// Your testbench goes here.

reg CLOCK_50;
reg [3:0] KEY;
reg [9:0] SW;

wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
wire [9:0] LEDR;

task2 dut(.CLOCK_50(CLOCK_50), .KEY(KEY), .SW(SW),
             .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
             .HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
             .LEDR(LEDR));

      

        initial begin
            CLOCK_50 <= 1'b0;
            forever #5 CLOCK_50 <= ~CLOCK_50;
        end

        initial begin
            KEY[3] = 1'b0;
            #10;
            KEY[3] = 1'b1;
                #3000;
            $stop;
        end
        task printvalues;
	        $display("HEX0: %b, HEX1: %b, HEX2: %b, HEX3: %b, HEX4: %b, HEX5: %b, key: %h", HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, dut.key);
            $display("rdy:%b, wrdata: %h, wren: %b, addr: %h", rdy, wrdata, wren, addr);
        endtask


        initial begin
                KEY[3] = 1;
                //en = 1;
                SW[9:0] = 10'b0000011000;
                #10;
                printvalues;
                #10;
                //rddata = 8'b11111111
                printvalues;

       
                KEY[3] =0; 
                //en= 0;
                #10;
                printvalues;
                #10;
       
                KEY[3] =1; 
                //en= 0;
                #10;
                printvalues;
                #10;
       
                KEY[3] =0; 
                //en= 1;
                #10;
                printvalues;
                #10;
        end

        initial begin
                KEY[3] = 1;
                //en = 1;
                //addr = 8'b0;
                SW[9:0] = 10'b0000011000;
                #10;
                 for (int i = 0; i < 256; i = i + 1) begin
                SW[9:0] = {10'b0000011000,i}; 

                $display("Test vector %d, addr: %h, rddata: %h, rdy:%b, wrdata: %b, wren: %b", 
                          i, addr, rddata, rdy, wrdata, wren);
                printvalues; 
                end

                $finish;
        end
    

endmodule: tb_syn_task2
