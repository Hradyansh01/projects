module apb_controller(
    Hclk,
    Hresetn,
    valid,
    Hwrite,
    Haddr,
    Hwdata,
    Haddr1,
    Haddr2,
    Hwdata1,
    Hwdata2,
    Hwritereg,
    tempselx,
    Hreadyout,
    Pwrite, Penable, Pselx, Pwdata, 
    Paddr
);

input valid, Hwritereg, Hclk, Hresetn, Hwrite;
input [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
input [31:0] Haddr, Hwdata;
input [2:0] tempselx;

output reg Pwrite, Penable;
output reg [2:0] Pselx;
output reg Hreadyout;
output reg [31:0] Pwdata, Paddr;

parameter st_idle   = 3'b000,
          st_wait   = 3'b001,
          st_write  = 3'b010,
          st_writep = 3'b011,
          st_wenablep= 3'b100,
          st_wenable=3'b101,
          st_read   = 3'b110,
          st_renable= 3'b111;

reg [2:0] state, next_state;

reg [31:0] Paddr_temp, Pwdata_temp;
reg Penable_temp, Pwrite_temp, Hreadyout_temp;
reg [2:0] Psel_temp;


// Present State Logic
always @(posedge Hclk)
begin
    if(!Hresetn)
        state <= st_idle;
    else
        state <= next_state;
end


// Next State Logic
always @(*)
begin
    case(state)

        st_idle:
        begin
            if(valid && Hwrite)
                next_state = st_wait;
            else if(valid && !Hwrite)
                next_state = st_read;
            else
                next_state = st_idle;
        end

        st_wait:
        begin
            if(valid)
                next_state = st_writep;
            else
                next_state = st_write;
        end

        st_writep:
        begin
            next_state = st_wenablep;
        end

        st_write:
        begin
            if(valid)
                next_state = st_wenablep;
            else
                next_state = st_wenable;
        end

        st_wenablep:
        begin
            if(valid && Hwritereg)
                next_state = st_writep;
            else if(~Hwritereg)
                next_state = st_read;
            else if(~valid)
                next_state = st_write;
        end

        st_wenable:
        begin
            if(valid && ~Hwrite)
                next_state = st_read;
            else if(~valid)
                next_state = st_idle;
            else
                next_state = st_wenable;
        end

        st_read:
        begin
            next_state = st_renable;
        end

        st_renable:
        begin
            if(valid && ~Hwrite)
                next_state = st_read;
            else if(valid && Hwrite)
                next_state = st_wait;
            else if(~valid)
                next_state = st_idle;
            else
                next_state = st_renable;
        end

        default:
            next_state = st_idle;

    endcase
end

// Temp Logic
always @(*)
begin
    case(state)

        st_idle:
        begin
            if(valid && !Hwrite)
            begin
                Paddr_temp      = Haddr;
                Pwrite_temp     = Hwrite;
                Psel_temp       = tempselx;
                Penable_temp    = 0;
                Hreadyout_temp  = 0;
            end
            else if(valid && Hwrite)
            begin
                Psel_temp       = 0;
                Penable_temp    = 0;
                Hreadyout_temp  = 1;
            end
            else
            begin
                Psel_temp       = 0;
                Penable_temp    = 0;
                Hreadyout_temp  = 1;
            end
        end

        st_read:
        begin
            Penable_temp   = 1;
            Hreadyout_temp = 1;
        end

        st_renable:
        begin
            if(valid && !Hwrite)
            begin
                Paddr_temp      = Haddr;
                Pwrite_temp     = Hwrite;
                Psel_temp       = tempselx;
                Penable_temp    = 0;
                Hreadyout_temp  = 0;
            end
            else if(valid && Hwrite)
            begin
                Psel_temp       = 0;
                Penable_temp    = 0;
                Hreadyout_temp  = 1;
            end
            else
            begin
                Psel_temp       = 0;
                Penable_temp    = 0;
                Hreadyout_temp  = 1;
            end
        end

        st_wait:
        begin
            Paddr_temp      = Haddr1;
            Pwdata_temp     = Hwdata;
            Pwrite_temp     = Hwrite;
            Psel_temp       = tempselx;
            Penable_temp    = 0;
            Hreadyout_temp  = 0;
        end

        st_write:
        begin
            Penable_temp   = 1;
            Hreadyout_temp = 1;
        end

        st_wenable:
        begin
            if(valid && !Hwrite)
            begin
                Hreadyout_temp = 1;
                Psel_temp      = 0;
                Penable_temp   = 0;
            end
            else if(valid && Hwrite)
            begin
                Paddr_temp      = Haddr1;
                Pwrite_temp     = Hwritereg;
                Psel_temp       = tempselx;
                Penable_temp    = 0;
                Hreadyout_temp  = 0;
            end
            else
            begin
                Hreadyout_temp = 1;
                Psel_temp      = 0;
                Penable_temp   = 0;
            end
        end

        st_writep:
        begin
            Penable_temp   = 1;
            Hreadyout_temp = 1;
        end

        st_wenablep:
        begin
            Paddr_temp      = Haddr1;
            Pwdata_temp     = Hwdata;
            Pwrite_temp     = Hwrite;
            Psel_temp       = tempselx;
            Penable_temp    = 0;
            Hreadyout_temp  = 0;
        end

    endcase
end

// Output Logic
always @(posedge Hclk)
begin
    if(!Hresetn)
    begin
        Paddr     <= 0;
        Pwdata    <= 0;
        Pwrite    <= 0;
        Pselx     <= 0;
        Penable   <= 0;
        Hreadyout <= 1;
    end
    else
    begin
        Paddr     <= Paddr_temp;
        Pwdata    <= Pwdata_temp;
        Pwrite    <= Pwrite_temp;
        Pselx     <= Psel_temp;
        Penable   <= Penable_temp;
        Hreadyout <= Hreadyout_temp;
    end
end

endmodule


