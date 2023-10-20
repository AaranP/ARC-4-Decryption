`define start 3'd1
`define found_key 3'd2
`define start_arc4 3'd3
`define check 3'd4
`define done 3'd5
`define done_arc4 3'd6

module doublecrack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here
    //different wirings for each ptmem instantiation
    logic [7:0] pt_addr, pt_rddata, pt_wrdata, ct_addr1, ct_addr2;
    logic pt_wren;

    logic arc4en, arcrdy;

    logic rdy1, rdy2, kv1, kv2;
    logic [23:0] key1, key2;

    logic [2:0] current_state, flag;
    // this memory must have the length-prefixed plaintext if key_valid
    
    //Three PT module, pt 1 and pt 2 for the two crack. pt3 for the final completed crack
    pt_mem pt1(.address(pt_addr), .clock(clk), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

    // for this task only, you may ADD ports to crack
    crack c1(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy1),
             .key_start(24'h000000), .key(key1), .key_valid(kv1),
             .ct_addr(ct_addr), .ct_rddata(ct_rddata), .kv(kv2));

    crack c2(.clk(clk), .rst_n(rst_n), .en(en), .rdy(rdy2), 
             .key_start(24'h000001), .key(key2), .key_valid(kv2), 
             .ct_addr(ct_addr), .ct_rddata(ct_rddata), .kv(kv1));

    arc4 a4(.clk(clk), .rst_n(rst_n),
            .en(arc4en), .rdy(arcrdy), .key(key), .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));


    // your code here
    always_ff@(posedge clk) begin
            if(~rst_n) begin
                    {arc4en}  <= {1'b0};
                    rdy <= 1'b1;
                    key_valid <= 1'b0;
		    current_state <= `start;
            end else begin
                    case(current_state) 

                        `start: begin
                                if(en) begin
                                    rdy <= 1'b0;  
                                    current_state <= `found_key;
                                end else begin
                                    current_state <= `start;
                                end
                                                        end
                        `found_key: begin
                                    if (kv1) begin
                                            key<= key1;
                                            arc4en <= 1'b1;
                                            key_valid <= 1'b1;
                                            current_state <= `start_arc4;
                                    end
                                    else if (kv2) begin
                                            key<= key2;
                                            arc4en <= 1'b1;
                                            key_valid <= 1'b1;
                                            current_state <= `start_arc4;
                                    end 
                                    else begin
                                        current_state <= `check;
                                    end
                                    end
                        `check : begin
                                if ( (rdy1 && rdy2) && (~kv1 && ~kv2)) begin
                                    
                                    key_valid <= 1'b0;
                                    current_state <= `done;
                                end else current_state <= `found_key;
                                end

                        `start_arc4 : begin
                                      arc4en <= 1'b0;
                                      current_state<= `done_arc4;
                                      end

                        `done_arc4: begin
                                    if (arcrdy) begin
                                        current_state <= `done; 
                                    end else begin
                                        current_state <= `done_arc4;
                                    end
                                    end
                        `done: begin
                                rdy<= 1;
                                current_state <= `done;
                                end

                        
                        default: current_state <= `done;            
                    endcase

            end
    end
  

endmodule: doublecrack 
