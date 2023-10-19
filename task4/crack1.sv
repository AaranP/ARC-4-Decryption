`define start 3'd1
`define state1 3'd2
`define state2 3'd3
`define state3 3'd4
`define statea 3'd5
module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here

        logic [7:0] pt_addr, pt_wrdata, pt_rddata, pause;
        logic wren, arc4en, arcrdy, arcrst_n, pt_wren, k;
        logic [3:0] current_state, next_state;
    // this memory must have the length-prefixed plaintext if key_valid
        pt_mem pt(.address(pt_addr), .clock(clk), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

        arc4 a4(.clk(clk), .rst_n(arcrst_n),
            .en(arc4en), .rdy(arcrdy), .key(key), .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here
        always_ff@(posedge clk or negedge rst_n) begin

                if(~rst_n) begin
                        {rdy, key, key_valid, arcrst_n} <= {1'b1, 24'd0, 1'b0, 8'd0, 1'b0};
                        k <= 1'b0;
                        current_state <= `start;
                end else begin
                        case(current_state)
                        
                        `start : begin  
                                {rdy, key, key_valid, arcrst_n} <= {1'b1, 24'd0, 1'b0, 1'b1};
                                if (arcrdy && en) begin
                                        arcrst_n <= 1'b1;
                                        arc4en <= 1'b1;
                                        rdy <= 1'b0;
                                        current_state <= `state2;
                                end else begin
                                        current_state <= `start;
                                end
                                end
                        `state1 : {current_state, arcrst_n, arc4en} <= {`state2, 1'b1, 1'b0};
			`statea : {current_state, arcrst_n, arc4en} <= {`state2, 1'b1, 1'b1};
			`state2 : begin
                                arc4en <= 1'b0;
                                if (~arcrdy) begin
                                        if(pt_wren) begin
                                                if((pt_wrdata < 8'h20 || pt_wrdata > 8'h7E) && pt_addr != 8'd0) begin
                                                        {key, key_valid, arcrst_n, arc4en} <= {key + 24'd1, 1'b0, 1'b0, 1'b1};
                                                        current_state <= `statea;
                                                end else begin
                                                        current_state <= `state2;
                                                end
                                        end else begin
                                                current_state <= `state2;
                                        end
                                end else if (arcrdy == 1'b1 && key == 24'd255) begin
                                        key_valid <= 1'b0;
                                        current_state <= `state3;
                                end else begin
                                        key_valid <= 1'b1;
                                        current_state <= `state3;
                                end 
			        end    
                        `state3 : begin
                                rdy <= 1'b1;
                                current_state <= `state3;
                                end
                        default : current_state <= `state3;
                        endcase
                end
        end

always@(*) begin

case(current_state) 

`start: begin
	


endmodule: crack
