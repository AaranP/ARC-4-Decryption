`define reset       3'd1 //length of message is read
`define start       3'd2
`define state1      3'd3
`define state2      3'd4
`define state3      3'd5
`define state4      3'd6 
`define state5      3'd7
`define state6      3'd8
`define done        3'd9
`define dummy       3'd10 //dummy state to delay for memory reading

module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

logic [2:0] current_state;
integer k;
logic [7:0] length, i, j, count, data1, data2, value, value2, value3;
    // your code here

    always_ff@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            current_state <= `reset;
            i <= 1'b0;
            j <= 1'b0;
            count <= 1'b0;
            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
        end else begin
            case(current_state)
            
                `reset : begin  
                            i <= 1'b0;
                            j <= 1'b0;
                            count <= 1'b0;  
                            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                            current_state <= `start;
                         end
                `start : begin
                         length <= ct_rddata - 8'd1;
			            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};  
                         if (en) begin 
                           current_state <= `state1;
                           rdy <= 1'b1;
                         end else begin  
                            current_state <= `start;
                         end
                         end
                `state1 : begin
                          if (count <= length) begin
                             i <= (i + 8'b1) % 256;
                             {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, i, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                              current_state <= `state2;
                          end else begin
                            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};  
                            current_state <= `done;
                          end
                          end
                
                `state2 : begin
                          j <= (j + s_rddata) % 256;
                          data1 <= s_rddata;
                          {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, j, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                          current_state <= `state3;
                          end
                
                `state3 : begin 
                          data2 <= s_rddata;
                          {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b0, (data1 + data2) % 256, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                          current_state <= `state4;
                          end
                
                `state4 : begin 
                          value <= s_rddata;
                          {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count, count+8'd1, 8'd0, 1'b0};
                          current_state <= `state5;
                          end
                `state5 : begin 
                          value2 <= ct_rddata;
			            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count, count, value2 ^ value, 1'b1};
                          current_state <= `state6;
                          end     
                `state6 : begin
			            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {1'b0, s_addr, 8'd0, 1'b0, count, count, value3, 1'b0};
                          count <= count + 1;
                          current_state <= `state1;
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
