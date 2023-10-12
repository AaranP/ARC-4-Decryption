module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata
         /* any other ports you need to add */);

    // For Task 5, you may modify the crack port list above,
    // but ONLY by adding new ports. All predefined ports must be identical.

    // your code here

    // this memory must have the length-prefixed plaintext if key_valid
    pt_mem pt( /* connect ports */ );
    arc4 a4( /* connect ports */ );

    // your code here

endmodule: crack
