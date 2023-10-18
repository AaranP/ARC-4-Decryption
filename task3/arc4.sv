`define reset 3'd1;
`define start 3'd2;
`define initialize 3'd3;
`define keyschedule 3'd4;
`define randomnum 3'd5;
`define done 3'd6;

module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here
    logic [2:0] current_state
    logic [7:0] sm_addr, sm_wren, sm_rdata, sm_wrdata; //system memory 
    logic [7:0] en_init, rdy_init, init_addr, init_wrdata, init_wren; //initialization
    logic [7:0] en_ksa, rdy_ksa, ksa_addr, ksa_rdata, ksa_wrdata, ksa_wren; //KSA
    logic [7:0] en_prga, rdy_prga, prga_addr, prga_rdata, prga_wrdata, prga_wren; //PRGA


   s_mem s(.address(sm_addr), .clock(clk), .data(sm_wrdata), .wren(sm_wren), .q(sm_rdata));

    init i(.clk(clk), .rst_n(rst_n),.en(en_init), .rdy(rdy_init), .addr(init_addr), .wrdata(init_wrdata), .wren(init_wren));

	ksa k(.clk(clk), .rst_n(rst_n), .en(en_ksa), .rdy(rdy_ksa), .key(key), .addr(ksa_addr), .rdata(sm_rdata), .wrdata(ksa_wrdata), .wren(ksa_wren));

    prga p(.clk(clk), .rst_n(rst_n), .en(en_prga), .rdy(rdy_prga),
	   .key(key), .s_addr(prga_addr), .s_rddata(sm_rdata), .s_wrdata(prga_wrdata), .s_wren(prga_wren),
            .ct_addr(ct_adder), .ct_rddata(ct_rddata), .pt_addr(pt_addr),
	    .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here=

    always@(posedge clk or negedge rst_n)begin
        if(~reset_n) begin
		{en_init, en_ksa, en_prga} <= {1,0,0};
		{sm_wrdata} <={init_wrdata};
		{sm_wren, sm_addr} <= {init_wren,init_addr};

                current_state <= `start; 

        else begin
                case(current_state)
                `start: begin
                        rdy <= 1;
                        if(en) begin
                                rdy <= 0;
                                current_state <= `initialize;
				{en_init, en_ksa, en_prga} <= {0,1,0};
				{sm_wrdata} <={init_wrdata};
				{sm_wren, sm_addr} <= {init_wren, init_addr};

                        end
                        else current_state <= `start;

                end

                ` initialize: begin
			en_init <= 1'b0;
                        if(rdy_init) begin //not ready

                                current_state = `keyschedule;
                                {en_init, en_ksa, en_prga} <= {0,1,0};
				{sm_wrdata} <= {ksa_wrdata};
				{sm_wren, sm_addr} <= {ksa_wren,ksa_addr};
        
                        end
                        else begin
                                current_state = `initialize;
                        end
                end

                `keyschedule: begin
			en_ksa <= 1'b0;
			if(rdy_ksa) begin
                                current_state = `randomnum;
                                {en_init, en_ksa, en_prga} <= {0,0,1};
				{sm_wrdata} <={prga_wrdata};
				{sm_wren, sm_addr} <= {prga_wren,prga_addr};

                        end
                        else current_state = `keyschedule;
                end

                `randomnum: begin
			en_prga <= 1'b0;
                        if(rdy_prga) begin
                                current_state = `done;
                                {en_init, en_ksa, en_prga} <= {0,0,0};
				{sm_wrdata} <={8'd0};
                                {sm_wren, sm_addr} <= {ksa_wren,ksa_addr};
                        end
                        else current_state = `randomnum;

                end
                
                `done: begin

                        current_state <= `done;
                        {en_init, en_ksa, en_prga} <= {0,0,0};
			{sm_wrdata} <={0};
                        {sm_wren, sm_addr} <= {0,0};
                        rdy <= 1;

                end

                default: current_state <= `done;
        
                endcase
        end
        end

    end

endmodule: arc4
