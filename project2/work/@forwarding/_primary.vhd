library verilog;
use verilog.vl_types.all;
entity Forwarding is
    port(
        EXMEM_Rd        : in     vl_logic_vector(4 downto 0);
        MEMWB_Rd        : in     vl_logic_vector(4 downto 0);
        IDEX_Rs         : in     vl_logic_vector(4 downto 0);
        IDEX_Rt         : in     vl_logic_vector(4 downto 0);
        MEMWB_RegWr     : in     vl_logic;
        EXMEM_RegWr     : in     vl_logic;
        EXMEM_MemWr     : in     vl_logic;
        Branch          : in     vl_logic;
        clk             : in     vl_logic;
        ForwardA        : out    vl_logic_vector(1 downto 0);
        ForwardB        : out    vl_logic_vector(1 downto 0);
        BForwardA       : out    vl_logic_vector(1 downto 0);
        BForwardB       : out    vl_logic_vector(1 downto 0)
    );
end Forwarding;
