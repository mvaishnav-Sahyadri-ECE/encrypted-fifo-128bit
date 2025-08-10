module simple_decrypt(
    input [127:0] encrypted_data, // Scrambled data from FIFO
    input [127:0] key,           // Same secret key
    output [127:0] plain_data    // Your original data back
);

// XOR decryption: encrypted XOR key = original data
assign plain_data = encrypted_data ^ key;

endmodule

