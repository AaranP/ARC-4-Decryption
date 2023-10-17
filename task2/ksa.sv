`define start 3'd1
`define state1 3'd2
`define state2 3'd3
`define state3 3'd4
`define state4 3'd6
`define done 3'd5

module ksa(input logic clk, input logic rst_n,
           input logic en, output logic rdy,
           input logic [23:0] key,
           output logic [7:0] addr, input logic [7:0] rddata, output logic [7:0] wrdata, output logic wren);

    logic [2:0] current_state;
    logic [7:0] j, k, m;
    logic [8:0] i;
    reg [7:0] vali;
    // your code here
    always_ff@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            {rdy, addr, wrdata, wren} <= {1'b1, 8'd0, 8'd0, 1'b0};
            current_state <= `start;
            i = 9'd0;
            j = 8'd0;
            k = 8'd0;
	    m = 8'd0;
            vali = 8'd0;

        end else begin
            case(current_state)
            
            `start : begin  
                     if (en) begin
                        {rdy, addr, wrdata, wren} <= {1'b0, i, 8'd0, 1'b0};
                        current_state <= `state1;
                        k <= k + 8'd1;
                     end else begin
                        current_state <= `start;
                     end
                    end
            `state1 : begin
		      vali = 8'd1;
			{rdy, addr, wrdata, wren} <= {1'b0, i, 8'd0, 1'b0};
                      if ( i < 9'd256) begin
                        {rdy, addr, wrdata, wren} <= {1'b0, i, 8'd0, 1'b0};
			m <= i % 3;
                        if(k < 8'd2) begin
                            {rdy, addr, wrdata, wren} <= {1'b0, i, 8'd0, 1'b0};
                            current_state <= `state1;
                            k <= k + 8'd1;
                        end else begin
                            vali = rddata;
                            k <= 8'd0;
			    if (m == 8'd0) begin
                            	j <= (j + rddata + key[23:16]) % 256;
			    end else if (m == 8'd1) begin
				j <= (j + rddata + key[15:8]) % 256;
			    end else begin
				j <= (j + rddata + key[7:0]) % 256;
			    end
                            current_state <= `state2;
                        end
                      end else begin
                        current_state <= `done;
                      end
                      end
            `state2 : begin
                      if (k < 8'd2) begin   
                        {rdy, addr, wrdata, wren} <= {1'b0, j, 8'd0, 1'b0};
                        current_state <= `state2;
                        k <= k + 8'd1;
                      end else begin
                        current_state <= `state3;
                        k <= 8'd0;
                      end
                      end
	    `state3 : begin
			{rdy, addr, wrdata, wren} <= {1'b0, i, rddata, 1'b1};
			current_state <= `state4;
			end
            `state4 : begin 
                      {rdy, addr, wrdata, wren} <= {1'b0, j, vali, 1'b1};
                      i <= i + 9'd1;
                      k <= 8'd0;
                      current_state <= `state1;
                      end
            `done : begin 
                    {rdy, addr, wrdata, wren} <= {1'b1, 8'd0, 8'd0, 1'b0};
                    current_state <= `done;
                    end
            default : current_state <= `done;
            endcase
        end
    end
                      



                        


endmodule: ksa
