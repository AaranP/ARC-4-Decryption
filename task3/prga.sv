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
`define state8     4'd11
`define state9     4'd12
`define donea 4'd13

module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    logic [3:0] current_state;
	logic [7:0] length, i, j, k, si, sj, padk, ctk, pause;
    // your code here

    always_ff@(posedge clk or negedge rst_n) begin
        if(~rst_n) begin
            current_state <= `start;
            i <= 8'd0;
            j <= 8'd0;
            k <= 8'd0;
	        {length, i, j, k, si, sj, padk, ctk, pause} <= {9 *{8'd0}};
            {rdy, s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {1'b1, 8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
      
        end else begin
        
            case(current_state)

            `start : begin 
                     if (en) begin
                        rdy <= 1'b0;
                        current_state <= `state1;
                        {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {8'd0, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                     end else begin
                        current_state <= `start;
                     end
                    end

            `state1 : begin // read and record length from ct
                     if (pause < 8'd2) begin
                        pause <= pause + 8'd1;
                        current_state <= `state1;
                     end else begin
                        pause <= 8'd0;
                        length <= ct_rddata;
                        current_state <= `state2;
                     end 
                    end

            `state2 : begin // initialize i
                      {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd0};
                      if (k < (length + 8'd1)) begin
                        current_state <= `state3;
                        i <= (i+8'd1) % 256;
                        
                      end else begin
                        current_state <= `done;
                      end
                     end

            `state3 : begin // rread from s[i]
                      {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {i, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                       if (pause < 8'd2) begin
                            current_state <= `state3;
                            {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd1 + pause};
                       end else begin
                            j <= ((j + s_rddata) % 256);
                            {length, i, k, si, sj, padk, ctk, pause} <= {length, i, k, s_rddata, sj, padk, ctk, 8'd0};
                            current_state <= `state4;
                       end
                        end

            `state4 : begin 
                        {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {j, 8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                       if (pause < 8'd2) begin
                            current_state <= `state4;
                            {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, pause + 8'd1};
                       
                       end else begin
                            {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, s_rddata, padk, ctk, 8'd0};
                            {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {j, si, 1'b1, 8'd0, 8'd0, 8'd0, 1'b0};
                            current_state <= `state5;
                       end
                        end

            `state5 : begin
                      {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd0};
                      {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {i, sj, 1'b1, 8'd0, 8'd0, 8'd0, 1'b0};
                       current_state <= `state6;
                    end
            
            `state6 : begin
                      s_addr <= ((si + sj) % 256);
                      {s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {8'd0, 1'b0, 8'd0, 8'd0, 8'd0, 1'b0};
                      if (pause < 8'd2) begin
                          current_state <= `state6;
                          {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, pause + 8'd1};
                      end else begin
                          {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, s_rddata, ctk, 8'd0};
                          {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {k, 8'd0, 1'b0, k + 8'd1, 8'd0, 8'd0, 1'b0};
                           current_state <= `state7;
                      end
                    end
            
            `state7 : begin 
                      {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} = {k, 8'd0, 1'b0, k + 8'd1, 8'd0, 8'd0, 1'b0};
                        if (pause < 8'd2) begin
                          current_state <= `state7;
                          {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, pause + 8'd1};
                      end else begin
                          {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ct_rddata, 8'd0};
                           current_state <= `state8;
                      end
                    end
            
            `state8 : begin
                      {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd0};
                      {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wren} <= {8'd0, 8'd0, 1'b0, 8'd0, k + 8'd1, 1'b1};
                      pt_wrdata <= padk ^ ctk;
                      current_state <= `state9;
                    end

            `state9 : begin
                      {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {8'd0, 8'd0, 1'b0, 8'd0, k, pt_wrdata , 1'b0};
                      {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k + 8'd1, si, sj, padk, ctk, 8'd0};
                      current_state <= `state2;
                    end

            `done : begin
                    {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd0};
                    {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {8'd0, 8'd0, 1'b0, 8'd0, 8'd0, length , 1'b1};
                    current_state <= `donea;
                    end
	    `donea : begin
		     {length, i, j, k, si, sj, padk, ctk, pause} <= {length, i, j, k, si, sj, padk, ctk, 8'd0};
                     {s_addr, s_wrdata, s_wren, ct_addr, pt_addr, pt_wrdata, pt_wren} <= {8'd0, 8'd0, 1'b0, 8'd0, 8'd0, length , 1'b0};
                     current_state <= `donea;
		     end
            default : current_state <= `donea;
            endcase
        end
    end
                      

                               
                

endmodule: prga

