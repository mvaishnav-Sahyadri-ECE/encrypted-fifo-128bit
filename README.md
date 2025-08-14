# encrypted-fifo-128bit


128‑bit FIFO that stores only encrypted data internally and returns the original plaintext on read. The design is kept simple for learning: encryption/decryption is an XOR with a 128‑bit key, placed before/after a synchronous FIFO. Includes an easy “monitor” testbench that prints plaintext, ciphertext-at-write, ciphertext-at-read, and decrypted plaintext so behavior is crystal clear in simulation.


## Repo structure
beginner_encrypted_fifo.v — top-level (encrypt → FIFO → decrypt)

simple_encrypt.v — combinational XOR cipher (plaintext ^ key)

simple_decrypt.v — combinational XOR (ciphertext ^ key)

simple_fifo_128.v — synchronous 128‑bit FIFO

tb_beginner_encrypted_fifo_monitor.v — print-focused testbench (recommended to start)

README.md — this file

# Design 

<img width="1043" height="366" alt="Elaborate_design" src="https://github.com/user-attachments/assets/c3413d7e-79fb-4b28-96fc-e6409ac14435" />


## How it works
Write path: encrypted_data = plain_data_in ^ secret_key; FIFO writes encrypted_data to mem[wr_ptr] when wr_en=1 and not full.

Read path: stored_data = FIFO mem[rd_ptr] (ciphertext); plain_data_out = stored_data ^ secret_key.

Because (P ^ K) ^ K = P, output equals original input if the same key is used for write and read

# Outputs 

#### Simulation : 

<img width="1550" height="603" alt="Simulation_FIFO" src="https://github.com/user-attachments/assets/425050db-ffae-4fbd-96c6-f10bf63529ee" />


- The Write Operation happens inside the FIFO when wr_en is enabled.
- Plan_data_in is written inside the FIFO after encryption | When wr_en is turned on.
- similarly, Read operation happens when rd_en is turned on and the encrypted data is decrypted to get plain_data_out.
- For encryption I used simple XOR operation on the *Input Data* with *secret_key* - as shown below 

*Below shows the encrypted data inside the FIFO* 

<img width="1291" height="188" alt="Write_operation_encrypteddata_stored" src="https://github.com/user-attachments/assets/647b9a8b-3739-4f04-ae75-ef7ed9355f9c" />

- Write Operation : The arrow indicated show encrypted data stored in the fifo_synchronous. Which is CIPH=(P^K) meaning P = plain_data and K=         secret_key. This is only visible in test bench as i have writen display function.


<img width="1400" height="112" alt="read_operation_decrypteddata_out" src="https://github.com/user-attachments/assets/8a33b61c-6796-4d3f-8a1a-ccfb9eadb53b" />

- Read Operation : Similarly, we see the encrypted_data stored as CIPH=(P^K) in fifo. Later is decrypted and plain_data is obtained which is          plain_data_out  == plain_data_in.

In conclusion, The Data inside the fifo remain Encrtypted. I used  XOR with a 128‑bit key Technique. 
we  can improve this design to much advance level, such as AES (Advanced Encryption Standard). 

