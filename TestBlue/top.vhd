library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity top is
  port ( clk : in std_logic;
         led : out std_logic );
end entity;

architecture behavioral of top is
  signal clk_reduced : std_logic;
begin
  
  divide_clock : process (clk)
    variable count : integer range 0 to 16#FFFFFF#;
  begin
    if clk'event and clk = '1' then
      count := count - 1;
      if count < 16#7FFFFF# then
        clk_reduced <= '1';
      else
        clk_reduced <= '0';
      end if;
      if count = 0 then
        count := 16#FFFFFF#;
      end if;
    end if;
  end process;
  
  led <= clk_reduced;
end architecture;
