module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here

    wire smadd, swen;
    wire [7:0] srdata, swdata;
    wire rdyksa, rdyprga;
    wire enksa, enprga;

    s_mem s(.address(smadd), .clock(clk), .data(swdata), .wren(swen), .q(srdata));
    init i(.clk(clk), .rst_n(rst_n),.en(en), .rdy(rdy), .addr(smadd), .wrdata(swdata), .wren(swen));


    ksa k(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy), .key(key), .addr(ct_addr), .rdata(ct_rddata), .wrdata(pt_wrdata), .wren(pt_wren));

    prga p(.clk(clk), .rst_n(rst_n), .en(enprga), .rdy(rdyprga),
            .key(key), .s_addr(smadd), .s_rddata(srdata), .s_wrdata(swdata), .s_wren(swen),
            .ct_addr(ct_adder), .ct_rddata(ct_rddata), .pt_addr(pt_addr),
	    .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));



    // your code here=

endmodule: arc4
