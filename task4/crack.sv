`define reset 3'd1
`define start 3'd2
`define read_word 3'd3
`define key_check 3'd4
`define key_process 3'd5
`define key_isvalid 3'd6
`define key_notvalid 3'd7
`define done 3'd8


module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata);

    // your code here

    // this memory must have the length-prefixed plaintext if key_valid
            logic current_state, en_arc4, rdy_arc4;
            logic[7:0] pt_addr, pt_wrdata, pt_wren, pt_rddata, count_pt;

            logic[7:0] pt_arc4addr, pt_arc4wrdata, pt_arc4wren, pt_arc4rddata, ct_arc4addr;

            pt_mem pt(.address(pt_addr), .clock(CLOCK_50), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

            arc4 a4(.clk(clk), .rst_n(rst_n), .en(en_arc4), .rdy(rdy_arc4), .key(key), .ct_addr(ct_arc4addr), .ct_rddata(ct_rddata), .pt_addr(pt_arc4addr), 
                        .pt_rddata(pt_arc4rddata), .pt_wrdata(pt_arc4wrdata), .pt_wren(pt_arc4wren));
    // your code here

            always@(posedge clk, negedge rest_n) begin
                if(~reset_n) begin
                    {pt_addr, pt_wrdata} <= {0,0};
                    {pt_wren, pt_rddata} <= {0,0};
                    rdy <= 0; 
                     current_state <= `start
                end
                else begin
                    case(current_state)
                    `start: begin
                            if(en) begin
                                {pt_addr, pt_wrdata} <= {0,0};
                                {pt_wren, pt_rddata, ct_addr} <= {0,0,0};
                                rdy <= 0;
                                en_arc4 <= 1;
                                current_state <= `read_word;
                            end
                            else begin
                                current_state <= `start;
                            end
                                
                        
                    end
                    `read_word: begin
                                if(rdy_arc4) begin
                                    en_arc4 <= 0;
                                    {pt_addr, pt_wrdata} <= {pt_arc4addr, pt_arc4wrdata};
                                    {pt_wren, pt_rddata, ct_addr} <= {pt_arc4wren, pt_arc4rddata, ct_arc4addr};
                                    rdy <= 0;
                                    current_state <=  `check_word;

                                end
                                else begin
                                    current_state <= `read_word;
                                end
                    end
                    `key_check: begin
                                if((pt_rddata >= 'h20) && (pt_rddata <= 'h7E)) begin
                                    if(count_pt == (ct_rddata - 1'b1)) begin
                                            current_state <= `key_isvalid;                                          
                                    end
                                    else begin
                                            current_state <= `read_word;
                                            count_pt <= count_pt + 1'b1;
                                end
                                else begin 
                                    current_state <= `key_process;
                                    count_pt <= 0;

                                end

                    end

                    end

                    `key_process: begin
                                if(key < 24'b1) begin
                                    key <= key + 1'b1;
                                    current_state <= `read_word;
                                end
                                else begin

                                    current_state <= `key_notvalid;
                                end
                    end

                    `key_isvalid: begin
                                    key_valid <= 1;
                                    rdy <= 1;
                    end

                    `key_notvalid: begin
                                    key_valid <=0;
                                    rdy<= 1; 
                                    current_state <= `start; 
                    end
                    
                    default: current_state <= `start;
                   
                    endcase
                end

            end

endmodule: crack
                      