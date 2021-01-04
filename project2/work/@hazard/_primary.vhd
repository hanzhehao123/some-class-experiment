library verilog;
use verilog.vl_types.all;
entity Hazard is
    port(
        clk             : in     vl_logic;
        IDEX_MemR       : in     vl_logic;
        IDEX_Rt         : in     vl_logic_vector(4 downto 0);
        IFID_Rs         : in     vl_logic_vector(4 downto 0);
        IFID_Rt         : in     vl_logic_vector(4 downto 0);
        Branch          : in     vl_logic;
        jump            : in     vl_logic;
        Zero            : in     vl_logic;
        IDEXWr          : out    vl_logic;
        IFIDwr          : out    vl_logic;
        rstIFID         : out    vl_logic;
        rstIDEX         : out    vl_logic;
        PCWr            : out    vl_logic;
        rstEXMEM        : out    vl_logic
    );
end Hazard;
