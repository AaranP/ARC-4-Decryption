`define reset 4'd1
`define start 4'd2
`define initialize 4'd3
`define keyschedule 4'd4
`define randomnum 4'd5
`define done 4'd6
`define pause 4'd7
`define keyschedule2 4'd8
`define randomnum2 4'd9

module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
    logic [3:0] current_state;
    reg [7:0] sm_addr, sm_rdata, sm_wrdata; //system memory 
    reg[7:0] init_addr, init_wrdata; //initialization
    reg [7:0] ksa_addr, ksa_rdata;// ksa_wrdata; //KSA
    wire [7:0] ksa_wrdata;
    reg [7:0] prga_addr, prga_rdata, prga_wrdata; //PRGA
    reg sm_wren, en_init, rdy_init, init_wren, en_ksa, rdy_ksa, ksa_wren, en_prga, rdy_prga, prga_wren;
    logic [2:0] flag;
 
assign ksa_rdata = sm_rdata;
   s_mem s(.address(sm_addr), .clock(clk), .data(sm_wrdata), .wren(sm_wren), .q(sm_rdata));

    init i(.clk(clk), .rst_n(rst_n),.en(en_init), .rdy(rdy_init), .addr(init_addr), .wrdata(init_wrdata), .wren(init_wren));
    ksa k(.clk(clk), .rst_n(rst_n), .en(en_ksa), .rdy(rdy_ksa), .key(key), .addr(ksa_addr), .rddata(sm_rdata), .wrdata(ksa_wrdata), .wren(ksa_wren));

    prga p(.clk(clk), .rst_n(rst_n), .en(en_prga), .rdy(rdy_prga),
	   .key(key), .s_addr(prga_addr), .s_rddata(sm_rdata), .s_wrdata(prga_wrdata), .s_wren(prga_wren),
            .ct_addr(ct_addr), .ct_rddata(ct_rddata), .pt_addr(pt_addr),
	    .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here=

    always@(posedge clk or negedge rst_n)begin

        if(~rst_n) begin
		{en_init, en_ksa, en_prga} <= {1'b1,1'b0,1'b0};
		rdy <= 1'b1;
                current_state <= `start; 
		flag = 3'd0;

        end else begin

                case(current_state)
                `start: begin
                        rdy <= 1'b1;
			flag = 3'd0;
                        if(en) begin
				flag = 3'd0;
                                rdy <= 1'b0;
                                current_state <= `initialize;
				{en_init, en_ksa, en_prga} <= {1'b0,1'b0,1'b0};
			end
                        else begin 
			current_state <= `start;

               			 end
			end
		` initialize: begin
			en_init <= 1'b0;
			flag = 3'd0;
                        if(rdy_init) begin //not ready
				current_state = `keyschedule;
                                {en_init, en_ksa, en_prga} <= {1'b0,1'b1,1'b0};
				flag = 3'd1;
                        end else begin
                                current_state = `initialize;
                        end
                end

                `keyschedule: begin
				en_ksa <= 1'b0;
				current_state <= `keyschedule2;
				flag = 3'd1;
				end
		`keyschedule2: 	begin
				en_ksa <= 1'b0;
				flag = 3'd2;
				if(rdy_ksa) begin
                                	current_state = `randomnum;
					flag = 3'd3;
                                	{en_init, en_ksa, en_prga} <= {1'b0,1'b0,1'b1};
				end
            			else current_state = `keyschedule2;
                		end
		`randomnum: begin
				en_prga <= 1'b0;
				flag = 3'd4;
				current_state <= `randomnum2;
			    end
                `randomnum2: begin
			en_prga <= 1'b0;
			flag = 3'd4;

                        if(rdy_prga) begin
                                current_state = `done;
				flag = 3'd5;
                                {en_init, en_ksa, en_prga} <= {1'b0,1'b0,1'b0};
                        end else begin
				current_state = `randomnum;
			end
                end
                
                `done: begin
			flag = 3'd6;
                        current_state <= `done;
                        {en_init, en_ksa, en_prga} <= {1'b0,1'b0,1'b0};
			rdy <= 1;

                end

                default: current_state <= `done;
        
                endcase
        end
        end

always_comb begin
	case(flag)
	3'd0: begin
		{sm_wrdata} ={init_wrdata};
		{sm_wren, sm_addr} = {init_wren,init_addr};
		end
	3'd1: begin
		{sm_wrdata} = {ksa_wrdata};
		{sm_wren, sm_addr} = {ksa_wren, ksa_addr};
		end
	3'd2: begin
		{sm_wrdata} = {ksa_wrdata};
		{sm_wren, sm_addr} = {ksa_wren, ksa_addr};
		end
	3'd3: begin
		{sm_wrdata} ={prga_wrdata};
		{sm_wren, sm_addr} = {prga_wren, prga_addr};
	       end
	3'd4: begin
		{sm_wrdata} ={prga_wrdata};
		{sm_wren, sm_addr} = {prga_wren, prga_addr};
	      end
	3'd5: begin
		{sm_wrdata} ={8'd0};
                {sm_wren, sm_addr} = {1'b0, 8'd0};
	     end
	3'd6: begin
		{sm_wrdata} ={8'd0};
              	{sm_wren, sm_addr} = {1'b0, 8'd0};
		end
	default: begin
		{sm_wrdata} <={8'd0};
                {sm_wren, sm_addr} = {1'b0, 8'd0};
		end
	endcase
end
		
	
	
   

endmodule: arc4
