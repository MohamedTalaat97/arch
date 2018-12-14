library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
---------------------------------------------------------
Entity system is
port (  SelectSourceA : in std_logic_vector (3 downto 0);
	SelectSourceB : in std_logic_vector (3 downto 0);
	SelectDistC : in std_logic_vector (3 downto 0);
	DecoderEnSrcA: in std_logic;
        DecoderEnSrcB: in std_logic;
	DecoderEnDistC: in std_logic;
	clk: in std_logic;
        rst: in std_logic;
	clkram: in std_logic;
   	w:   in std_logic;
	muxselect:in std_logic;
	busA : inout std_logic_vector (15 downto 0);
	busB : inout std_logic_vector (15 downto 0);
	busC : inout std_logic_vector (15 downto 0);
	aluSel :in std_logic_vector (4 downto 0));
end system;
------------------------------------------------------------
Architecture myRegisterFile of system is--------------------
-----------------------------------------------------------
Signal busADecOutTriEn: std_logic_vector (15 downto 0); 
Signal busBDecOutTriEn: std_logic_vector (15 downto 0); --bus
Signal busCDecOutRegEn: std_logic_vector (15 downto 0); 
----------------------------------------------------------
signal outReg0TriIn : std_logic_vector(15 downto 0); 
signal outReg1TriIn : std_logic_vector(15 downto 0);
signal outReg2TriIn : std_logic_vector(15 downto 0);
signal outReg3TriIn : std_logic_vector(15 downto 0);
signal outReg4TriIn : std_logic_vector(15 downto 0); --reg
signal outReg5TriIn : std_logic_vector(15 downto 0);
signal outRegPcTriIn : std_logic_vector(15 downto 0);
signal outRegSpTriIn : std_logic_vector(15 downto 0);
signal outRegTempTriIn : std_logic_vector(15 downto 0);
signal outRegMDRTriIn : std_logic_vector(15 downto 0);
signal outRegFlagTriIn : std_logic_vector(15 downto 0);
signal outRegIRTriIn : std_logic_vector(15 downto 0);
--------------------------------------------------------
signal address : std_logic_vector(15 downto 0);
signal ramout:std_logic_vector(15 downto 0); --ram
signal muxout:std_logic_vector(15 downto 0); 
signal flags :std_logic_vector(15 downto 0); 
------------------------------------------------------
Begin-------------------------------------------------------------
------------------------------------------------------------------
DecSrcA : entity work.Decoder4x16 port map (decSel=>SelectSourceA,decOut=>busADecOutTriEn,decEn=>DecoderEnSrcA);
DecSrcB : entity work.Decoder4x16 port map (decSel=>SelectSourceB,decOut=>busBDecOutTriEn,decEn=>DecoderEnSrcB); --decoders
DecDistC : entity work.Decoder4x16 port map (decSel=>SelectDistC,decOut=>busCDecOutRegEn,decEn=>DecoderEnDistC);
--------------------------------------------------------------------------------------------
Reg0:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg0TriIn,busCDecOutRegEn(0));
tri0A: entity work.tri_state_buffer port map (outReg0TriIn,busADecOutTriEn(0),busA );
tri0B: entity work.tri_state_buffer port map (outReg0TriIn,busBDecOutTriEn(0),busB );
---
Reg1:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg1TriIn,busCDecOutRegEn(1));
tri1A: entity work.tri_state_buffer port map (outReg1TriIn,busADecOutTriEn(1),busA );
tri1B: entity work.tri_state_buffer port map (outReg1TriIn,busBDecOutTriEn(1),busB );
--
Reg2:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg2TriIn,busCDecOutRegEn(2));
tri2A: entity work.tri_state_buffer port map (outReg2TriIn,busADecOutTriEn(2),busA );
tri2B: entity work.tri_state_buffer port map (outReg2TriIn,busBDecOutTriEn(2),busB );
--
Reg3:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg3TriIn,busCDecOutRegEn(3)); -- reg
tri3A: entity work.tri_state_buffer port map (outReg3TriIn,busADecOutTriEn(3),busA );
tri3B: entity work.tri_state_buffer port map (outReg3TriIn,busBDecOutTriEn(3),busB );
--
Reg4:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg4TriIn,busCDecOutRegEn(4));
tri4A: entity work.tri_state_buffer port map (outReg4TriIn,busADecOutTriEn(4),busA );
tri4B: entity work.tri_state_buffer port map (outReg4TriIn,busBDecOutTriEn(4),busB );
--
Reg5:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg5TriIn,busCDecOutRegEn(5));
tri5A: entity work.tri_state_buffer port map (outReg5TriIn,busADecOutTriEn(5),busA );
tri5B: entity work.tri_state_buffer port map (outReg5TriIn,busBDecOutTriEn(5),busB );
--
Reg6pc:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegPcTriIn,busCDecOutRegEn(6));
tri6A: entity work.tri_state_buffer port map (outRegPcTriIn,busADecOutTriEn(6),busA );
--
Reg7sp:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegSpTriIn,busCDecOutRegEn(7));
tri7A: entity work.tri_state_buffer port map (outRegSpTriIn,busADecOutTriEn(7),busA );
tri7B: entity work.tri_state_buffer port map (outRegSpTriIn,busBDecOutTriEn(7),busB );
-----------------------------------------------------------------------------------------------------------------
mar:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, address,busCDecOutRegEn(8));
----
mdr:entity work.my_nDFF  generic map (16) port map ( clk , rst ,muxout, outRegMDRTriIn,busCDecOutRegEn(9));    --ram components
tri9A: entity work.tri_state_buffer port map (outRegMDRTriIn,busADecOutTriEn(9),busA );
tri9B: entity work.tri_state_buffer port map (outRegMDRTriIn,busBDecOutTriEn(9),busB );
----
mux :entity work.mux2x1 port map(muxselect,busC,ramout,muxout);
ram: entity work.ram port map (clkram,w,address(10 downto 0),outRegMDRTriIn,ramout);
------------------------------------------------------------------------------------------------------------------.
Regtemp:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegTempTriIn,busCDecOutRegEn(10));
tri10A: entity work.tri_state_buffer port map (outRegTempTriIn,busADecOutTriEn(10),busA );
tri10B: entity work.tri_state_buffer port map (outRegTempTriIn,busBDecOutTriEn(10),busB );
--
RegIR:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegIRTriIn,busCDecOutRegEn(11)); -- temp ,flag ,ir
tri11B: entity work.tri_state_buffer port map (outRegIRTriIn,busBDecOutTriEn(11),busB );
--
Regflag:entity work.my_nDFF  generic map (16) port map ( clk , rst ,flags, outRegFlagTriIn,flags(5));
tri12A: entity work.tri_state_buffer port map (outRegFlagTriIn,busADecOutTriEn(12),busA );
tri12B: entity work.tri_state_buffer port map (outRegFlagTriIn,busBDecOutTriEn(12),busB );
--------------------------------------------------------------------------------------------------------------------
alu : entity work.ALU port map (busA,busB,outRegFlagTriIn(0),aluSel,busC, flags(0)); --alu
flags(1) <='1' when busC =x"0000" else '0';
flags(2) <='1' when busC(15) ='1' else '0';
flags(3)<= not(busC(0));
flags(5)<='1'; -- flag register enable

flags(15 downto 6) <="0000000000";
---------------------------------------------------------------------------------------------------------------
end Architecture;



