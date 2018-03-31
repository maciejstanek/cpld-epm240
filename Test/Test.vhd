library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity test is
  port ( clk : in std_logic;
         sseg : out std_logic_vector (7 downto 0);
         sseg_sel : out std_logic_vector (7 downto 0);
         sw : in std_logic_vector (3 downto 0);
         led : out std_logic_vector (7 downto 0);
         bell : out std_logic );
end test;

architecture behavioral of test is
  signal clk1, clk2 : std_logic;
  type hex_digits_array is array (15 downto 0) of std_logic_vector (3 downto 0);
  signal hex_digits: hex_digits_array := (
    "0000", "0001", "0010", "0011",
    "0100", "0101", "0110", "0111",
    "1000", "1001", "1010", "1011",
    "1100", "1101", "1110", "1111");
  
  function bin_to_sseg(bin : std_logic_vector(3 downto 0))
    return std_logic_vector is
  begin
    case bin is
      when "0000" => return "11000000";
      when "0001" => return "11111001";
      when "0010" => return "10100100";
      when "0011" => return "10110000";
      when "0100" => return "10011001";
      when "0101" => return "10010010";
      when "0110" => return "10000010";
      when "0111" => return "11111000";
      when "1000" => return "10000000";
      when "1001" => return "10010000";
      when "1010" => return "10001000";
      when "1011" => return "10000011";
      when "1100" => return "11000110";
      when "1101" => return "10100001";
      when "1110" => return "10000110";
      when "1111" => return "10001110";
      when others => return "11111111";
    end case;
  end function;
  
  function bin_to_one_hot(bin : integer)
    return std_logic_vector is
  begin
    case bin is
      when      0 => return "00000001";
      when      1 => return "00000010";
      when      2 => return "00000100";
      when      3 => return "00001000";
      when      4 => return "00010000";
      when      5 => return "00100000";
      when      6 => return "01000000";
      when      7 => return "10000000";
      when others => return "00000000";      
    end case;
  end function;

begin
  bell <= '1'; --Turn off this goddamn buzzer at pin 50!
  led(3 downto 0) <= sw;
  
  sseg_display : process (clk)
    variable count : integer range 0 to 16#1FFF#;
    variable sseg_sel_index : integer range 0 to 7 := 0;
    variable cycles_count : integer range 0 to 16#3FFF#;
  begin
    if clk'event and clk = '1' then
      if count = 0 then
        sseg_sel_index := sseg_sel_index + 1;
        cycles_count := cycles_count + 1;
      end if;
      count := count + 1;
    end if;
    sseg_sel <= bin_to_one_hot(sseg_sel_index) xor "11111111";
    if cycles_count < 16#2000# then
      sseg <= bin_to_sseg(hex_digits(sseg_sel_index));
    else
      sseg <= bin_to_sseg(hex_digits(sseg_sel_index + 8));
    end if;
  end process;

  p1 : process (clk)
    variable count : integer range 0 to 16#FFFFF#;
  begin
    if clk'event and clk = '1' then
      count := count - 1;
      if count < 16#7FFFF# then
        clk1 <= '0';
      else
        clk1 <= '1';
      end if;
      if count = 0 then
        count := 16#FFFFF#;
      end if;
    end if;
  end process;

  p3 : process (clk1)
  begin
    if clk1'event and clk1 = '1' then
      clk2 <= not clk2;
    end if;
  end process p3;

  p2 : process (clk2)
    variable count : integer range 0 to 15;
  begin
    if clk2'event and clk2 = '1' then
      case count is
        when      0 => led(7 downto 4) <= "1110";
        when      1 => led(7 downto 4) <= "1100";
        when      2 => led(7 downto 4) <= "1000";
        when      3 => led(7 downto 4) <= "0001";
        when      4 => led(7 downto 4) <= "0011";
        when      5 => led(7 downto 4) <= "0111";
        when others => led(7 downto 4) <= "1111";
      end case;
      count := count + 1;
    end if;
  end process;
end architecture;

