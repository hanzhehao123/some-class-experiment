library verilog;
use verilog.vl_types.all;
entity EXMEM is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        IDEX_WB         : in     vl_logic_vector(1 downto 0);
        IDEX_M          : in     vl_logic_vector(1 downto 0);
        EXMEM_Rd_in     : in     vl_logic_vector(4 downto 0);
        ALUOut          : in     vl_logic_vector(31 downto 0);
        RD2_in          : in     vl_logic_vector(31 downto 0);
        EXMEM_M2R       : out    vl_logic;
        EXMEM_RegWr     : out    vl_logic;
        EXMEM_aluout    : out    vl_logic_vector(31 downto 0);
        MEMData         : out    vl_logic_vector(31 downto 0);
        EXMEM_Rd        : out    vl_logic_vector(4 downto 0);
        MemWr           : out    vl_logic;
        MemR            : out    vl_logic;
        rstEXMEM        : in     vl_logic
    );
end EXMEM;
