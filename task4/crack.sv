`define startc 4'd0
`define state1c 4'd1
`define state2c 4'd2
`define state3c 4'd3
`define state4c 4'd4
`define stateac 4'd6
`define state5c 4'd5
module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here

        logic [7:0] pt_addr, pt_wrdata, pt_rddata, pause, arcaddr, length, k;
        logic wren, arc4en, arcrdy, arcrst_n, pt_wren;
        logic [3:0] current_state, next_state, flag;
    // this memory must have the length-prefixed plaintext if key_valid
        pt_mem pt(.address(pt_addr), .clock(clk), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

        arc4 a4(.clk(clk), .rst_n(arcrst_n),
            .en(arc4en), .rdy(arcrdy), .key(key), .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here
    always_ff@(posedge clk or negedge rst_n) begin
        
        if (~rst_n) begin

                arcrst_n <= 1'b0;
                current_state <= `startc;
                key <= 24'h000000;
                key_valid <= 1'b0;
                {pause, k, length, arc4en} <= {8'd0, 8'd0, 8'd0, 1'b0};
		rdy <= 1'b1;

        end else begin

                case (current_state)

                `startc : begin //check for enable signal to start crack, and turn off arc reset
                        arcrst_n <= 1'b1;
                        if (en) begin
                                current_state <= `state1c;
				
                        end else begin
                                current_state <= `startc;
                        end
                        end

                `state1c : begin //assign length to ctrddata and checkin if arcrdy is on
                          rdy <= 1'b0;
			  length <= ct_rddata;
                          
                          if (arcrdy) begin
                                arc4en <= 1'b1;
                                current_state <= `stateac;
                          end else begin
                                current_state <= `state1c;
                          end
                        end
		`stateac : begin
			  arc4en <= 1'b0;
			  current_state <= `state2c;
			  end
                `state2c : begin //check if arc is writing to plaintext mem, or has reached end of memory
                          
                          if (flag == 4'd1) begin
                                current_state <= `state5c;
                                key_valid <= 1'b0;
                          end else if (flag == 4'd2) begin
                                current_state <= `state3c;
                                key <= key + 24'h000001;
                                arcrst_n <= 1'b0;
                          end else if (flag == 4'd3) begin
                                current_state <= `state2c;
                          end else if (flag == 4'd4) begin
                                key_valid <= 1'b1;
                                current_state <= `state5c;
                          end else if (flag == 4'd5) begin
                                current_state <= `state2c;
                          end else begin
                                current_state <= current_state;
                          end
                        end

                `state3c: begin  //after incrementing key, and arcrstn
                         arcrst_n <= 1'b1;
                         current_state <= `state1c;
                         end

                `state5c: begin
                         rdy <= 1'b1;
                         current_state <= `state5c;
                        end

                default: current_state <= `state5c;
                endcase
        end
        end

always_comb begin
	if(current_state == `state2c) begin
                if (pt_wren ) begin
                                        
                        if ((pt_wrdata < 8'h20) || (pt_wrdata > 8'h7E) && (pt_addr != 8'd0)) begin //check if wrdata is not within the ascii range
                                if(key == 24'hffffff) begin //if at max key don't increment and finish
                                        flag <= 4'd1;
                                end else begin //else increment key and check again
                                        
                                        flag = 4'd2;
                                end
                                                
                        end else begin //if in ascii range check again from beginning of state2
                                flag = 4'd3;
                        end
                end else if (arcrdy) begin //if arcrdy and not moved to a diff state yet, then valid key is the current key value
                        flag = 4'd4;
                end else begin
                        flag = 4'd5;
                end
        end else begin
		flag = 4'd0;
	end
end

endmodule: crack
