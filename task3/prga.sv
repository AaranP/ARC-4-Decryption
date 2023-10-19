`define reset       4'd1 //length of message is read
`define start       4'd2
`define state1      4'd3
`define state2      4'd4
`define state3      4'd5
`define state4      4'd6 
`define state5      4'd7
`define state6      4'd8
`define done        4'd9
`define state7     4'd10 
`define statea     4'd11
`define stateb     4'd12

module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

logic [3:0] current_state;
	logic [7:0] length, i, j, k, count, data, data1, data2, value, value2, value3;
    // your code here

    always_ff@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            current_state <= `reset;
            i <= 1'b0;
            j <= 1'b0;
            count <= 1'b0;
	    {data, data1, data2, value, value2, value3} <= {6 *{8'd0}};
            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
        end else begin
            case(current_state)
            
                `reset : begin  
                            i <= 8'd0;
                            j <= 8'd0;
		            k <= 8'd0;
                            count <= 1'b0;  
                            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
			    if (en) begin 
                           current_state <= `start;
                           rdy <= 1'b0;
                       	   end else begin  
                            current_state <= `reset;
			    
                           end             
                         end
                `start : begin
			if( k < 8'd2) begin
                         length <= ct_rddata;
			 {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};  
			 k <= k + 8'd1;
		        current_state <= `start;
			end else begin
			   k <= 8'd0;
			   current_state <= `state1;
                         end
			 end
                `state1 : begin
                          if (count < length) begin
				i <= (i + 8'd1) % 256;
                             {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, i, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                              current_state <= `state2;
				k <= 8'd0;
                          end else begin
                            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};  
                            current_state <= `state7;
                          end
                          end
                
                `state2 : begin
			if (k < 8'd2) begin
				current_state <= `state2;
				k <= k + 8'd1;
                          	data1 = s_rddata;
			end else begin
                          j <= (j + data1) % 256;
                          {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, j, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                          current_state <= `state3;
			  k <= 8'd0;
			end
			end  
                `state3 : begin 
			if (k< 8'd2) begin
				current_state <= `state3;
				data2 = s_rddata;
				k <= k + 8'd1;
			end else begin
                          
                          {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, i, data2, 1'b1, 8'd0, 8'd0, 8'd0, 1'b0};
                          //{rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, (data1 + data2) % 256, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                          current_state <= `statea;
			  k <= 8'd0;
			end  
			end
                `statea : begin
			  {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, j, data1, 1'b1, 8'd0, 8'd0, 8'd0, 1'b0};
                         current_state <= `stateb;
			end
		`stateb : begin
			  {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, (data1 + data2) % 256, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                         current_state <= `state4;
			end
                `state4 : begin 
			if( k < 8'd2) begin
				current_state <= `state4;
				value = s_rddata;
				k <= k + 8'd1;
			end else begin
			  {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count + 8'd1, count, 8'd0, 1'b0};
                          current_state <= `state5;
			   k <= 8'd0;
                          end
			 end
                `state5 : begin 
			if (k < 8'd3) begin
				current_state <= `state5;
				value2 <= ct_rddata;
				k <= k + 8'd1;
			end else begin
			  {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count+8'd1, count+8'd1, value2 ^ value, 1'b1};
                          current_state <= `state6;
			  k <= 8'd0;
                          end     
			end
                `state6 : begin
			{rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count, count, value2 ^ value, 1'b0};
                          count <= count + 8'd1;
                          current_state <= `state1;
                          end
		`state7 : begin
			  {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count, 8'd0, length, 1'b1};
			  current_state <= `done;
			  end
                `done : begin
                        {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                        current_state <= `done;
                        end

                
                default : current_state <= `done;
            endcase
        end
    end 
                               
                

endmodule: prga
