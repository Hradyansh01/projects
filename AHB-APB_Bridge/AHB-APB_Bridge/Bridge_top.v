module Bridge_top(input Hclk, Hresetn, Hwrite, Hreadyin,
		  input [31:0]Hwdata, Haddr, Prdata,
		  input  [1:0]Htrans,
		  output Pwrite, Penable, Hreadyout,
		  output [2:0]Psel,
		  output [31:0]Paddr, Pwdata, Hrdata, 
		  output [1:0] Hresp ); 
		
		wire valid;
		wire Hwritereg, Hwritereg1;
		wire [31:0]Hwdata1, Hwdata2, Haddr1, Haddr2;
		wire [2:0]temp_selx;

	ahb_slave_interface ahb_s(Hclk, Hresetn, Hwrite, Hreadyin, Htrans, Haddr, Hwdata, Prdata,
                  Hresp, Hrdata, valid, Haddr1, Haddr2, Hwdata1, Hwdata2,
                  Hwritereg, Hwritereg1, temp_selx);

	apb_controller apb_c(Hclk, Hresetn, valid, Hwrite, Haddr, Hwdata, Haddr1,
				Haddr2, Hwdata1, Hwdata2, Hwritereg, temp_selx, 
				Hreadyout, Pwrite, Penable, Psel, Pwdata, Paddr );

endmodule
