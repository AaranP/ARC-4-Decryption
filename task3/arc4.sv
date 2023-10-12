module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    // your code here

    s_mem s( /* connect ports */ );
    init i( /* connect ports */ );
    ksa k( /* connect ports */ );
    prga p( /* connect ports */ );

    // your code here

endmodule: arc4
