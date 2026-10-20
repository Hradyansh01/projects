module top_tb();
reg Hclk, Hresetn;
wire [31:0] Haddr, Hwdata, Hrdata, Paddr, Pwdata, Pwdata_out, Paddr_out, Prdata;
wire [1:0] Hresp, Htrans;
wire [2:0] Pselx, Psel_out;
wire Hreadyout, Hwrite, Hreadyin, Penable, Pwrite_out, Penable_out;

AHB_Master ahb(Hclk, Hresetn, Hreadyout, Hrdata, Haddr, Hwdata, Hwrite, Hreadyin, Htrans);

APB_Interface apb(Pwrite, Penable, Pselx, Paddr, Pwdata, Pwrite_out, Penable_out, Psel_out, Paddr_out, Pwdata_out, Prdata);

Bridge_top bridge(Hclk, Hresetn, Hwrite, Hreadyin, Hwdata, Haddr, Prdata, Htrans, Pwrite, Penable, Hreadyout, Pselx, Paddr, Pwdata, Hrdata, Hresp);

initial
begin
Hclk = 1'b0;
forever #10 Hclk = ~Hclk;
end

task reset();
begin
@(negedge Hclk);
Hresetn = 1'b0;
@(negedge Hclk);
Hresetn = 1'b1;
end
endtask

initial
begin
reset;
//ahb.single_write();
ahb.burst_write();
//ahb.single_read();
#200 $finish;
end
endmodule

