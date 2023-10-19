`define reset 3'd1
`define start 3'd2
`define decrypt 3'd3
`define done 3'd4
//`define randomnum = 3'd5;
//`define done = 3'd6;

module task3(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

            logic en, rdy,current_state, pt_wren;

            logic[7:0] ct_addr, ct_rdata;
            logic[7:0] pt_addr, pt_wrdata, pt_rdata;
	    logic [23:0] key;

            ct_mem ct(.address(ct_addr), .clock(CLOCK_50),.data(8'd0), .wren(1'b0), .q(ct_rdata));

            pt_mem pt(.address(pt_addr), .clock(CLOCK_50), .data(pt_wrdata), .wren(pt_wren), .q(pt_rdata));

            arc4 a4(.clk(CLOCK_50), .rst_n(rst_n), .en(en), .rdy(rdy), .key(key), .ct_addr(ct_addr), .ct_rddata(ct_rdata), .pt_addr(pt_addr), 
                  .pt_rddata(pt_rdata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));
            
            assign rst_n = KEY[3];
            assign key = {14'b00011110010001, SW[9:0]};

            always@(posedge CLOCK_50 or negedge rst_n) begin
                if(~rst_n) begin
                  en <= 1'b1;
                  current_state <= `start;
                end else begin
                  case(current_state) 
                  
                  `start: begin
                          
                          if(rdy) begin
			     en<= 1'b1;
                            current_state <= `decrypt;
                          end
                          else current_state <= `start;
                  	end
                  
                  `decrypt: begin
			    en <= 1'b0;
                            if(rdy) begin
                              current_state<= `done;
                              en <= 0;
                            end
                            else current_state<= `decrypt;
                  	end

                  `done: begin
                         current_state <= `done;
                         en<=0;
                  end

                  default: current_state <= `done;
                  endcase
                  end

                end
endmodule: task3

