----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.02.2021 02:11:02
-- Design Name: 
-- Module Name: audio_recorder_tb - Structural
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity audio_recorder_tb is
end audio_recorder_tb;

architecture Structural of audio_recorder_tb is
--Se�ales y constantes necesarias
 signal M_CLK_IN, ENABLE, DONE, M_DATA, RESET_REC :  std_logic;
constant clk_period : time := 420 ns;
constant n_bits : integer := 16;
signal DATA_OUTPUT : std_logic_vector(n_bits-1 downto 0);
--Declaro componente audio_recorder
component audio_recorder is
    Generic(
    M_N_Bits : integer := 16
    );
    Port (
    --Puertos Microfono
    M_CLK : out std_logic; --reloj a 2.38 MHz
    M_LR : out std_logic; --si est� a 0, los datos se leen en flanco de subida del reloj anterior
    M_DATA : in std_logic; --entrada de datos del micro a la FPGA
    
    M_CLK_IN : in std_logic; --Proviene del clk_freq_ctrl, hay que conectarlo a M_CLK
    ENABLE : in std_logic; --Activa la grabaci�n
    DONE : out std_logic; --Indica que los datos ya se han deserializado
    DATA_OUTPUT : out std_logic_vector(M_N_Bits-1 downto 0); --Salida de datos deserializados
    RESET_REC : in std_logic
     );
end component;

begin
-- Component Instantiation
          uut:  audio_recorder PORT MAP(
                  M_CLK_IN => M_CLK_IN,
                  ENABLE => ENABLE,
                  DONE => DONE,
                  M_DATA => M_DATA,
                  DATA_OUTPUT => DATA_OUTPUT,
                  RESET_REC => RESET_REC
                );
--Reseteo y enable
rst_process : process
begin
    RESET_REC <= '1';
    ENABLE <= '0';
    wait for clk_period*3;
    RESET_REC <= '0';
    wait for clk_period*3;
    ENABLE <= '1';
    wait;
  end process;
            
--Generar reloj 2,4 MHz
clk_process :process  --generates a 2,4 MHz clock.
   begin
        M_CLK_IN <= '0';
        wait for clk_period/2;  --for 210 ns signal is '0'.
        M_CLK_IN <= '1';
        wait for clk_period/2;  --for next 210 ns signal is '1'.
   end process;
--Generar M_DATA de prueba
data_process : process  --genera una se�al PDM similar a la que se obtendr�a del micro
   begin
        M_DATA <= '0';
        wait for clk_period/5;  
        M_DATA <= '1';
        wait for clk_period/3;
        M_DATA <= '0';
        wait for clk_period/4;  
        M_DATA <= '1';
        wait for clk_period/2;
   end process;
end Structural;
