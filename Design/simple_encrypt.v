module simple_encrypt(
    input [127:0] plain_data,     // Your original data
    input [127:0] key,           // Secret key
    output [127:0] encrypted_data // Scrambled data
);

// XOR encryption: data XOR key = encrypted
assign encrypted_data = plain_data ^ key;

endmodule
