`timescale 1ns/1ps
module beginner_encrypted_fifo (
    input              clk,
    input              rst_n,           // active-low reset

    // Secret key (same key for encrypt/decrypt)
    input      [127:0] secret_key,

    // Write side: plaintext in
    input      [127:0] plain_data_in,
    input              wr_en,
    output             full_o,          // FIFO full flag

    // Read side: plaintext out
    input              rd_en,
    output     [127:0] plain_data_out,
    output             empty_o          // FIFO empty flag
);

    // Internal wires
    wire [127:0] encrypted_data;  // after encrypt
    wire [127:0] stored_data;     // from FIFO (still encrypted)

    // 1) Encrypt plaintext (XOR demo cipher)
    simple_encrypt u_encrypt (
        .plain_data     (plain_data_in),
        .key            (secret_key),
        .encrypted_data (encrypted_data)
    );

    // 2) FIFO stores encrypted data (uses its own default DEPTH=8)
    simple_fifo_128 u_fifo (
        .clk      (clk),
        .rst_n    (rst_n),
        .data_in  (encrypted_data),
        .wr_en    (wr_en),          // FIFO ignores writes when full
        .rd_en    (rd_en),          // FIFO ignores reads when empty
        .data_out (stored_data),
        .full_o   (full_o),
        .emty_o   (empty_o)
    );

    // 3) Decrypt on output (XOR demo cipher)
    simple_decrypt u_decrypt (
        .encrypted_data (stored_data),
        .key            (secret_key),
        .plain_data     (plain_data_out)
    );

endmodule
