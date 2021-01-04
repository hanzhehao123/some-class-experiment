library verilog;
use verilog.vl_types.all;
entity Ctrl is
    port(
        jump            : out    vl_logic;
        RegDst          : out    vl_logic;
        Branch          : out    vl_logic;
        MemR            : out    vl_logic;
        Mem2R           : out    vl_logic;
        MemW            : out    vl_logic;
        RegW            : out    vl_logic;
        Alusrc          : out    vl_logic;
        EXtOp           : out    vl_logic_vector(1 downto 0);
        ALUOp           : out    vl_logic_vector(4 downto 0);
        OpCode          : in     vl_logic_vector(5 downto 0);
        Funct           : in     vl_logic_vector(5 downto 0)
    );
end Ctrl;
