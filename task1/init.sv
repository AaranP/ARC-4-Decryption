`define reset_start     2'd1 //set address location and value to zero, and turn enable 
`define load  		2'd2 //increment addresst location and wrdata until its at 256, sets rdy signal to 0
`define stop  		2'd3 //no longer increments value and sets rdy signal to 1
module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

// your code here
reg [1:0] current_state;
always_ff@(posedge clk or negedge rst_n) begin
	
	if(~rst_n) begin
		{rdy, wren, addr, wrdata, current_state} = {1'b1, 1'b0, 8'd0, 8'd0, `reset_start};
	end else begin

	case(current_state) 
		`reset_start : begin
					{rdy, wren, addr, wrdata} = {1'b1, 1'b0, 8'd0, 8'd0};
					if (en) begin
						{rdy, wren, addr, wrdata} = {1'b1, 1'b1, addr + 8'd1, wrdata + 8'd1};
						current_state = `load;
					end else begin
						current_state = `reset_start;
					end
					end
		
		`load : begin	
				if (addr == 8'b11111111) begin	
					current_state = `stop;
				end else begin	
					{rdy, wren, addr, wrdata} = {1'b1, 1'b1, addr + 8'd1, wrdata + 8'd1};
					current_state = `load;
				end
				end

		`stop : begin	
				{rdy, wren, addr, wrdata} = {1'b1, 1'b0, 8'd0, 8'd0};
				current_state = `stop;
				end
		default : current_state = `stop;
	endcase

	end
end
endmodule: init
