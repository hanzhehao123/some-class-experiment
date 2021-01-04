library verilog;
use verilog.vl_types.all;
entity dm_4k is
    port(
        addr            : in     vl_logic_vector(4 downto 0);
        din             : in     vl_logic_vector(31 downto 0);
        DMWr            : in     vl_logic;
        clk             : in     vl_logic;
        dout            : out    vl_logic_vector(31 downto 0);
        MemR            : in     vl_logic
    );
end dm_4k;
