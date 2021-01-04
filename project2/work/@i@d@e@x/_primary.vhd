library verilog;
use verilog.vl_types.all;
entity IDEX is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        IDEXrst         : in     vl_logic;
        IDEXWr          : in     vl_logic;
        Ctrl_WB         : in     vl_logic_vector(1 downto 0);
        Ctrl_M          : in     vl_logic_vector(1 downto 0);
        EXT_in          : in     vl_logic_vector(31 downto 0);
        IFID_Rs         : in     vl_logic_vector(4 downto 0);
        IFID_Rt         : in     vl_logic_vector(4 downto 0);
        IFID_Rd         : in     vl_logic_vector(4 downto 0);
        ALUOp_in        : in     vl_logic_vector(4 downto 0);
        Alusrc_in       : in     vl_logic;
        RegDst_in       : in     vl_logic;
        RD1_in          : in     vl_logic_vector(31 downto 0);
        RD2_in          : in     vl_logic_vector(31 downto 0);
        IDEX_WB         : out    vl_logic_vector(1 downto 0);
        IDEX_M          : out    vl_logic_vector(1 downto 0);
        ALUOp_out       : out    vl_logic_vector(5 downto 0);
        Alusrc_out      : out    vl_logic;
        RegDst_out      : out    vl_logic;
        IDEX_RD1out     : out    vl_logic_vector(31 downto 0);
        IDEX_RD2out     : out    vl_logic_vector(31 downto 0);
        EXT_out         : out    vl_logic_vector(31 downto 0);
        IDEX_Rs         : out    vl_logic_vector(4 downto 0);
        IDEX_Rt         : out    vl_logic_vector(4 downto 0);
        IDEX_Rd         : out    vl_logic_vector(4 downto 0)
    );
end IDEX;
