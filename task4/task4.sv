`define start 3'd0
`define state1 3'd1
`define state2 3'd2
`define state3 3'd3
`define done 3'd4
`define blank 7'b1111111
`define dash  7'b0111111
`define zero  7'b1000000
`define one   7'b1111001
`define two   7'b0100100
`define three 7'b0110000
`define four  7'b0011001
`define five  7'b0010010
`define six   7'b0000010
`define seven 7'b1111000
`define eight 7'b0000000
`define nine  7'b0010000
`define a     7'b0001000
`define b     7'b0000011
`define c     7'b0100111
`define d     7'b0100001
`define e     7'b0000110
`define f     7'b0001110
module task4(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    // your code here
    logic [23:0] key;
    logic key_valid, en, rdy, rst_n;
    logic [7:0] ct_addr, ct_rddata;
    integer i, j;
    logic [2:0] current_state;
    logic [6:0] hex0, hex1, hex2, hex3, hex4, hex5;

    assign rst_n = KEY[3];
 
    ct_mem ct(.address(ct_addr), .clock(CLOCK_50), .data(8'd0), .wren(1'b0), .q(ct_rddata));
    crack c(.clk(CLOCK_50), .rst_n(KEY[3]), .en(en), .rdy(rdy),
             .key(key), .key_valid(key_valid), .ct_addr(ct_addr), .ct_rddata(ct_rddata));
    
    display d0(.key(key[3:0]), .HEX(hex0));
    display d1(.key(key[7:4]), .HEX(hex1));
    display d2(.key(key[11:8]), .HEX(hex2));
    display d3(.key(key[15:12]), .HEX(hex3));
    display d4(.key(key[19:16]), .HEX(hex4));
    display d5(.key(key[23:20]), .HEX(hex5));
    
    // your code here
    always_ff@(posedge CLOCK_50 or negedge rst_n) begin

        if (~rst_n) begin
            en <= 1'b1;
            current_state <= `start;
            {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} <= {`blank, `blank, `blank, `blank, `blank, `blank};
                      
        end else begin
            case(current_state)
            `start : {current_state, en} <= {`state1, 1'b1};
            `state1 : begin
                      en <= 1'b0;
                      if (rdy && key_valid == 1'b0) begin
                        current_state <= `state2;
                      end else if (rdy && key_valid == 1'b1) begin
                        current_state <= `state3;
                      end else begin
                        current_state <= `state1;
                      end
                    end 
            `state2 : begin
                      {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} <= {`dash, `dash, `dash, `dash, `dash, `dash};
                      current_state <= `done;
                    end
            `state3 : begin
                      {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} <= {hex5, hex4, hex3, hex2, hex1, hex0};
                      current_state <= `state3;
                        end
            `done :   {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0, current_state} <= {`blank, `blank, `blank, `blank, `blank, `blank, `done};
            default : current_state <= `done;
            endcase
        end
    end


                     
endmodule: task4

module display (input [3:0]key, output [6:0] HEX);

   
    reg [6:0] hex;

   assign HEX = hex;

   always_comb begin
	case(key)
		4'd0 : hex = `zero;
        	4'd1 : hex = `one;
		4'd2 : hex = `two;
		4'd3 : hex = `three;
		4'd4 : hex = `four;
		4'd5: hex = `five;
		4'd6: hex = `six;
		4'd7: hex = `seven;
		4'd8 : hex = `eight;
		4'd9 : hex = `nine;
		4'd10 : hex = `a;
		4'd11 : hex = `b;
		4'd12 : hex = `c;
		4'd13 : hex = `d;
		4'd14 : hex = `e;	
        4'd15 : hex = `f;
		default : hex = `blank;
	endcase
   end
		

endmodule
