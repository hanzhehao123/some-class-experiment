library verilog;
use verilog.vl_types.all;
entity IFID is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        rstIFID         : in     vl_logic;
        IFIDWr          : in     vl_logic;
        IFID_out        : out    vl_logic_vector(63 downto 0);
        IFID_in         : in     vl_logic_vector(63 downto 0)
    );
end IFID;
