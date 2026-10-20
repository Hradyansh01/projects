module tb_apb_controller;

reg         Hclk, Hresetn;
reg         valid, Hwrite, Hwritereg;
reg  [31:0] Haddr, Hwdata;
reg  [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
reg  [2:0]  tempselx;

wire        Pwrite, Penable, Hreadyout;
wire [2:0]  Pselx;
wire [31:0] Pwdata, Paddr;

apb_controller dut(
    .Hclk(Hclk), .Hresetn(Hresetn),
    .valid(valid), .Hwrite(Hwrite), .Hwritereg(Hwritereg),
    .Haddr(Haddr), .Hwdata(Hwdata),
    .Haddr1(Haddr1), .Haddr2(Haddr2),
    .Hwdata1(Hwdata1), .Hwdata2(Hwdata2),
    .tempselx(tempselx),
    .Hreadyout(Hreadyout),
    .Pwrite(Pwrite), .Penable(Penable),
    .Pselx(Pselx), .Pwdata(Pwdata), .Paddr(Paddr)
);

always #5 Hclk = ~Hclk;

// Reset task
task do_reset;
begin
    Hresetn=0; valid=0; Hwrite=0; Hwritereg=0;
    Haddr=0; Hwdata=0;
    Haddr1=0; Haddr2=0;
    Hwdata1=0; Hwdata2=0;
    tempselx=3'b001;
    #22; Hresetn=1;
end
endtask

initial begin
    Hclk=0;
    do_reset;

    //===========================================
    // OPERATION 1: SINGLE WRITE
    // Expected: IDLE?st_wait?st_write?st_wenable?IDLE
    //===========================================
    $display("--- Single Write ---");
    @(posedge Hclk); #1;
    valid=1; Hwrite=1;
    Haddr=32'h8000_0004;
    Haddr1=32'h8000_0004;
    Hwdata=32'hDEAD_BEEF;
    Hwdata1=32'hDEAD_BEEF;
    tempselx=3'b001;

    @(posedge Hclk); #1;
    valid=0;           // no next transfer queued
    Hwritereg=1;       // registered write signal

    @(posedge Hclk); #1;
    @(posedge Hclk); #1;
    Hwritereg=0;
    @(posedge Hclk); #1;
    #30;

    //===========================================
    // OPERATION 2: SINGLE READ
    // Expected: IDLE?st_read?st_renable?IDLE
    //===========================================
    $display("--- Single Read ---");
    @(posedge Hclk); #1;
    valid=1; Hwrite=0; Hwritereg=0;
    Haddr=32'h8400_0008;
    Haddr1=32'h8400_0008;
    tempselx=3'b010;

    @(posedge Hclk); #1;
    valid=0;

    @(posedge Hclk); #1;
    @(posedge Hclk); #1;
    #30;

    //===========================================
    // OPERATION 3: BURST WRITE (3 beats)
    // Expected: IDLE?st_wait?st_writep?st_wenablep
    //           ?st_writep?st_wenablep?st_write?st_wenable?IDLE
    //===========================================
    $display("--- Burst Write ---");
    @(posedge Hclk); #1;
    valid=1; Hwrite=1; Hwritereg=0;
    Haddr=32'h8000_0010;
    Haddr1=32'h8000_0010;
    Hwdata=32'h1111_1111;
    Hwdata1=32'h1111_1111;
    Haddr2=32'h8000_0014;
    Hwdata2=32'h2222_2222;
    tempselx=3'b001;

    // beat 2 arrives while beat 1 still in progress
    @(posedge Hclk); #1;
    valid=1; Hwritereg=1;
    Haddr=32'h8000_0014;
    Haddr1=32'h8000_0014;
    Hwdata=32'h2222_2222;
    Hwdata1=32'h2222_2222;
    Haddr2=32'h8000_0018;
    Hwdata2=32'h3333_3333;

    // beat 3 ? last beat, no more after
    @(posedge Hclk); #1;
    valid=0; Hwritereg=1;
    Haddr=32'h8000_0018;
    Haddr1=32'h8000_0018;
    Hwdata=32'h3333_3333;
    Hwdata1=32'h3333_3333;

    @(posedge Hclk); #1;
    Hwritereg=0;
    @(posedge Hclk); #1;
    @(posedge Hclk); #1;
    @(posedge Hclk); #1;
    @(posedge Hclk); #1;
    #50;

    $display("--- Done ---");
    $stop;
end

endmodule
