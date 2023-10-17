`define state1 4'd1
`define state2 4'd2
`define state3 4'd3
`define state4 4'd4
`define state5 4'd5
`define state6 4'd6
`define statex 4'd8
`define state7 4'd9
`define done 4'd7


module task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    reg [7:0] addr, wrdata;
    wire [7:0] rddata;
    reg wren;
    wire ksardy, initrdy, rst_n;
    wire [23:0] key;

    reg initen, ksaen;
    integer k;
    wire [7:0] wdata_i, wdata_k, addr_i, addr_k;
    wire wren_i, wren_k;
    logic flag;
   reg [3:0] current_state;

    assign rst_n = KEY[3];
    assign key = {14'b0, SW[9:0]};

    s_mem s(.address(addr), .clock(CLOCK_50), .data(wrdata), .wren(wren), .q(rddata));
	
    // your code here
    ksa ksa(.clk(CLOCK_50), .rst_n(rst_n), .en(ksaen), .rdy(ksardy),
           .key(key), .addr(addr_k), .rddata(rddata), .wrdata(wdata_k), .wren(wren_k));

    init init(.clk(CLOCK_50), .rst_n(rst_n), .en(initen), .rdy(initrdy),
            .addr(addr_i), .wrdata(wdata_i), .wren(wren_i));


always_ff@(posedge CLOCK_50 or negedge rst_n) begin
	if (~rst_n) begin
		flag = 1'b1;
		current_state <= `state1;
	end else begin
		case (current_state)
			`state1 : current_state <= `state2;
			`state2 : current_state <= `statex;
			`statex : begin
				     if (initrdy == 1'b1) begin
					current_state <= `state4;
			             end else begin
					current_state <= `statex;
				     end
				  end	
			`state4: {current_state, flag} <= {`state5, 1'b0};
			`state5 : current_state <= `state6;
			`state6 : current_state <= `state7;
			`state7 : begin
				  if (ksardy == 1'b1) begin
					current_state <= `done;
				  end else begin
				  	current_state <= `state7;
				  end
				  end
			`done : current_state <= `done;
			default : current_state <= `done;
        	endcase
	end		
end	

always@(*) begin
	if(flag) begin

		if(current_state == `state1) begin
			{ksaen, initen, wrdata, addr, wren} <= {1'b0, 1'b1, wdata_i, addr_i, wren_i};
		end else begin
			{initen, wrdata, addr, wren} <= {1'b0, wdata_i, addr_i, wren_i};
		end

        end else begin

		if(current_state == `state5) begin
			{ksaen, wrdata, addr, wren} <= {1'b1, wdata_k, addr_k, wren_k};
		end else begin
			{ksaen, wrdata, addr, wren} <= {1'b0, wdata_k, addr_k, wren_k};
		end

        end
end  
		
		
endmodule: task2
