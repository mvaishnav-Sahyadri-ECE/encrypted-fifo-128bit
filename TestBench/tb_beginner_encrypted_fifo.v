`timescale 1ns/1ps
module tb_beginner_encrypted_fifo_monitor;

  // 100 MHz clock (10ns period)
  reg clk = 1'b0;
  always #5 clk = ~clk;

  // DUT I/O
  reg          rst_n         = 1'b0;
  reg  [127:0] secret_key    = 128'hDEADBEEF_CAFEBABE_0123_4567_89AB_CDEF;
  reg  [127:0] plain_data_in = 128'd0;
  reg          wr_en         = 1'b0;
  reg          rd_en         = 1'b0;

  wire [127:0] plain_data_out;
  wire         full_o;
  wire         empty_o;

  // Instantiate your top module
  beginner_encrypted_fifo dut (
      .clk            (clk),
      .rst_n          (rst_n),
      .secret_key     (secret_key),
      .plain_data_in  (plain_data_in),
      .wr_en          (wr_en),
      .full_o         (full_o),
      .rd_en          (rd_en),
      .plain_data_out (plain_data_out),
      .empty_o        (empty_o)
  );

  integer i;

  // Show plaintext and ciphertext at the WRITE cycle (what goes into FIFO)
  always @(posedge clk) begin
    if (wr_en) begin
      // dut.encrypted_data is the ciphertext that gets written into FIFO this cycle
      $display("[WRITE] t=%0t  PLAIN=%032h  KEY=%032h  CIPH=(P^K)=%032h",
               $time, plain_data_in, secret_key, dut.encrypted_data);
    end
  end

  // Show ciphertext coming OUT of FIFO and the decrypted plaintext at READ cycle
  always @(posedge clk) begin
    if (rd_en) begin
      // dut.stored_data is the FIFO data_out (still encrypted)
      $display("[READ ] t=%0t  CIPH(FIFO_out)=%032h  KEY=%032h  PLAIN=(C^K)=%032h",
               $time, dut.stored_data, secret_key, plain_data_out);
    end
  end

  initial begin
    // Reset for 2 cycles, then release
    repeat (2) @(posedge clk);
    rst_n = 1'b1;
    @(posedge clk);

    // Phase 1: Write 8 words (0..7)
    $display("\n-- WRITE 8 (0..7) --");
    for (i = 0; i < 8; i = i + 1) begin
      @(posedge clk);
      wr_en         <= 1'b1;
      rd_en         <= 1'b0;
      plain_data_in <= {120'd0, i[7:0]};
    end
    @(posedge clk) wr_en <= 1'b0;

    // Phase 2: Read 8 words (expect 0..7)
    $display("\n-- READ 8 (expect 0..7) --");
    for (i = 0; i < 8; i = i + 1) begin
      @(posedge clk);
      rd_en <= 1'b1;
      @(negedge clk);
      $display("       t=%0t  PLAIN_OUT=%032h", $time, plain_data_out);
    end
    @(posedge clk) rd_en <= 1'b0;

    // Phase 3: Write 4 words (100..103)
    $display("\n-- WRITE 4 (100..103) --");
    for (i = 0; i < 4; i = i + 1) begin
      @(posedge clk);
      wr_en         <= 1'b1;
      plain_data_in <= 128'd100 + i;
    end
    @(posedge clk) wr_en <= 1'b0;

    // Phase 4: Read 4 words (expect 100..103)
    $display("\n-- READ 4 (expect 100..103) --");
    for (i = 0; i < 4; i = i + 1) begin
      @(posedge clk);
      rd_en <= 1'b1;
      @(negedge clk);
      $display("       t=%0t  PLAIN_OUT=%032h", $time, plain_data_out);
    end
    @(posedge clk) rd_en <= 1'b0;

    $display("\n-- DONE --");
    #20 $finish;
  end

endmodule
