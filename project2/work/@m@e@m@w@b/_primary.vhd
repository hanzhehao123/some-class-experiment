library verilog;
use verilog.vl_types.all;
entity MEMWB is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        EXMEM_M2R       : in     vl_logic;
        EXMEM_RegWr     : in     vl_logic;
        MEMData_in      : in     vl_logic_vector(31 downto 0);
        ALUOut_in       : in     vl_logic_vector(31 downto 0);
        EXMEM_Rd        : in     vl_logic_vector(4 downto 0);
        M2R             : out    vl_logic;
        RegWr           : out    vl_logic;
        MEMData_out     : out    vl_logic_vector(31 downto 0);
        ALUOut_out      : out    vl_logic_vector(31 downto 0);
        MEMWB_Rd        : out    vl_logic_vector(4 downto 0)
    );
end MEMWB;
