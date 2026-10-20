module tb_ahb_slave_interface;

    reg         Hclk, Hresetn, Hwrite, Hreadyin;
    reg  [1:0]  Htrans;
    reg  [31:0] Haddr, Hwdata, Prdata;

    wire [1:0]  Hresp;
    wire [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2, Hrdata;
    wire [2:0]  tempselx;
    wire        valid, Hwritereg, Hwritereg1;

    ahb_slave_interface dut (
        .Hclk(Hclk), .Hresetn(Hresetn), .Hwrite(Hwrite), .Hreadyin(Hreadyin),
        .Htrans(Htrans), .Haddr(Haddr), .Hwdata(Hwdata), .Prdata(Prdata),
        .Hresp(Hresp), .Hrdata(Hrdata), .valid(valid),
        .Haddr1(Haddr1), .Haddr2(Haddr2), .Hwdata1(Hwdata1), .Hwdata2(Hwdata2),
        .Hwritereg(Hwritereg), .Hwritereg1(Hwritereg1), .tempselx(tempselx)
    );

    // clock
    always #5 Hclk = ~Hclk;

    initial begin
        Hclk = 0; Hresetn = 0; Hwrite = 0; Hreadyin = 1;
        Htrans = 2'b00; Haddr = 0; Hwdata = 0; Prdata = 32'hAABB_CCDD;

        #12 Hresetn = 1;   // release reset

        // Transfer 1: write to slave 0 region
        @(posedge Hclk);
        Haddr  = 32'h8000_0010;
        Hwrite = 1;
        Htrans = 2'b10;        // NONSEQ
        Hwdata = 32'h1111_1111;

        @(posedge Hclk);
        Htrans = 2'b00;        // IDLE, end this transfer
        Hwdata = 32'h2222_2222; // next data on bus (irrelevant here)

        // Transfer 2: read from slave 1 region
        @(posedge Hclk);
        Haddr  = 32'h8400_0020;
        Hwrite = 0;
        Htrans = 2'b10;

        @(posedge Hclk);
        Htrans = 2'b00;

        #50 $stop;
    end

endmodule
