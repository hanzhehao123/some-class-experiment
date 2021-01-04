library verilog;
use verilog.vl_types.all;
entity PC is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        PCBra           : in     vl_logic;
        PC              : out    vl_logic_vector(31 downto 0);
        jump            : in     vl_logic;
        IMM             : in     vl_logic_vector(25 downto 0);
        PCnew           : in     vl_logic_vector(31 downto 0);
        PCWr            : in     vl_logic
    );
end PC;
