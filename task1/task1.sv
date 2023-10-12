module task1(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here

    wire [7:0] wdata, rdata, address;
    wire wren, en, rdy; 
    reg enx;

    assign rst_n = KEY[3];
    assign en = enx;
 
    s_mem s(.address(address), .clock(CLOCK_50), .data(wdata), .wren(wren), .q(rdata) );

    init init(.clk(CLOCK_50), .rst_n(rst_n),
            .en(en), .rdy(rdy), .addr(address), .wrdata(wdata), .wren(wren));


/*always_ff@(posedge CLOCK_50 or negedge rst_n) begin
        if(rdy == 1'b1) begin
                enx = 1'b1;
        end else begin 
                enx = 1'b0;
        end
end
*/

always@(*) begin
        if(rdy) begin
                enx = 1'b1;
        end else begin  
                enx = 1'b0;
        end
end

endmodule: task1
