library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--------------------------------------------------------
--ir , el decoder enables ,flag enable ,el read -> mux,  wmfc ,mfc
---------------------------------------------------------
Entity system is
port (  SelectSourceA : in std_logic_vector (3 downto 0);
	SelectSourceB : in std_logic_vector (3 downto 0);
	SelectDistRn&temp : in std_logic_vector (3 downto 0);
	SelectDistMAR&MDR&Flag : in std_logic_vector (1 downto 0);
	SelectReadWrite : in std_logic_vector (1 downto 0);
	DecoderEnSrcA: in std_logic;
    DecoderEnSrcB: in std_logic;
	DecoderEnRn&temp: in std_logic;
	DecoderEnMAR&MDR&Flag: in std_logic;
	DecoderEnReadWrite: in std_logic;
	clk: in std_logic;
    rst: in std_logic;
	clkram: in std_logic;
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
Signal Rn&tempInDecoder: std_logic_vector (15 downto 0); -->(0-7)R0-7 (8) temp1   (9) temp2 (10) IR (11) no operation
Signal MAR&Mdr&FlagINDecoder: std_logic_vector (3 downto 0); -->  (0) Mar (1) mdr (2) flag (3) no operation
Signal ReadWriteDecoder: std_logic_vector (3 downto 0);  --->  (0) read(muxselect) (1) write (2) no operatin    
----------------------------------------------------------
signal outReg0TriIn : std_logic_vector(15 downto 0); 
signal outReg1TriIn : std_logic_vector(15 downto 0);
signal outReg2TriIn : std_logic_vector(15 downto 0);
signal outReg3TriIn : std_logic_vector(15 downto 0);
signal outReg4TriIn : std_logic_vector(15 downto 0); --reg
signal outReg5TriIn : std_logic_vector(15 downto 0);
signal outRegPcTriIn : std_logic_vector(15 downto 0);
signal outRegSpTriIn : std_logic_vector(15 downto 0);
signal outRegTemp1TriIn : std_logic_vector(15 downto 0);
signal outRegTemp2TriIn : std_logic_vector(15 downto 0);
signal outRegMDRTriIn : std_logic_vector(15 downto 0);
signal outRegFlagTriIn : std_logic_vector(15 downto 0);
signal outRegIRTriIn : std_logic_vector(15 downto 0);
--------------------------------------------------------
signal address : std_logic_vector(15 downto 0);
signal ramout:std_logic_vector(15 downto 0); --ram
signal muxout:std_logic_vector(15 downto 0); 
signal flags :std_logic_vector(15 downto 0); 
-----------------------------------------------------------------
Begin-------------------------------------------------------------
------------------------------------------------------------------
DecSrcA : entity work.Decoder4x16 port map (decSel=>SelectSourceA,decOut=>busADecOutTriEn,decEn=>DecoderEnSrcA);
DecSrcB : entity work.Decoder4x16 port map (decSel=>SelectSourceB,decOut=>busBDecOutTriEn,decEn=>DecoderEnSrcB); --decoders
DecDistR&temp : entity work.Decoder4x16 port map (decSel=>SelectDistRn&temp,decOut=>Rn&tempInDecoder,decEn=>DecoderEnRn&temp);
DecDistMAR&MDR&flagin : entity work.Decoder2x4 port map (SelectDistMAR&MDR&Flag ,MAR&Mdr&FlagINDecoder,DecoderEnMAR&MDR&Flag);
DecReadWrite: entity work.Decoder2x4 port map (SelectReadWrite,ReadWriteDecoder,DecoderEnReadWrite);
--------------------------------------------------------------------------------------------
Reg0:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg0TriIn,Rn&tempInDecoder(0));
tri0A: entity work.tri_state_buffer port map (outReg0TriIn,busADecOutTriEn(0),busA );
tri0B: entity work.tri_state_buffer port map (outReg0TriIn,busBDecOutTriEn(0),busB );
---
Reg1:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg1TriIn,Rn&tempInDecoder(1));
tri1A: entity work.tri_state_buffer port map (outReg1TriIn,busADecOutTriEn(1),busA );
tri1B: entity work.tri_state_buffer port map (outReg1TriIn,busBDecOutTriEn(1),busB );
--
Reg2:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg2TriIn,Rn&tempInDecoder(2));
tri2A: entity work.tri_state_buffer port map (outReg2TriIn,busADecOutTriEn(2),busA );
tri2B: entity work.tri_state_buffer port map (outReg2TriIn,busBDecOutTriEn(2),busB );
--
Reg3:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg3TriIn,Rn&tempInDecoder(3)); -- reg
tri3A: entity work.tri_state_buffer port map (outReg3TriIn,busADecOutTriEn(3),busA );
tri3B: entity work.tri_state_buffer port map (outReg3TriIn,busBDecOutTriEn(3),busB );
--
Reg4:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg4TriIn,Rn&tempInDecoder(4));
tri4A: entity work.tri_state_buffer port map (outReg4TriIn,busADecOutTriEn(4),busA );
tri4B: entity work.tri_state_buffer port map (outReg4TriIn,busBDecOutTriEn(4),busB );
--
Reg5:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outReg5TriIn,Rn&tempInDecoder(5));
tri5A: entity work.tri_state_buffer port map (outReg5TriIn,busADecOutTriEn(5),busA );
tri5B: entity work.tri_state_buffer port map (outReg5TriIn,busBDecOutTriEn(5),busB );
--
Reg6pc:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegPcTriIn,Rn&tempInDecoder(6));
tri6A: entity work.tri_state_buffer port map (outRegPcTriIn,busADecOutTriEn(6),busA );
--
Reg7sp:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegSpTriIn,Rn&tempInDecoder(7));
tri7A: entity work.tri_state_buffer port map (outRegSpTriIn,busADecOutTriEn(7),busA );
tri7B: entity work.tri_state_buffer port map (outRegSpTriIn,busBDecOutTriEn(6),busB );
-----------------------------------------------------------------------------------------------------------------
mar:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, address,MAR&Mdr&FlagINDecoder(0));
----
mdr:entity work.my_nDFF  generic map (16) port map ( clk , rst ,muxout, outRegMDRTriIn,MAR&Mdr&FlagINDecoder(1));    --ram components
tri9A: entity work.tri_state_buffer port map (outRegMDRTriIn,busADecOutTriEn(8),busA );
tri9B: entity work.tri_state_buffer port map (outRegMDRTriIn,busBDecOutTriEn(7),busB );
----
mux :entity work.mux2x1 port map(ReadWriteDecoder(0),ramout,busC,muxout);
ram: entity work.ram port map (clkram, ReadWriteDecoder(1),address(10 downto 0),outRegMDRTriIn,ramout);
------------------------------------------------------------------------------------------------------------------.
Regtemp1:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegTemp1TriIn,Rn&tempInDecoder(8));
tri10A: entity work.tri_state_buffer port map (outRegTemp1TriIn,busADecOutTriEn(9),busA );
tri10B: entity work.tri_state_buffer port map (outRegTemp1TriIn,busBDecOutTriEn(8),busB );
--
Regtemp2:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegTemp2TriIn,Rn&tempInDecoder(9));
tri11A: entity work.tri_state_buffer port map (outRegTemp2TriIn,busADecOutTriEn(10),busA );
tri11B: entity work.tri_state_buffer port map (outRegTemp2TriIn,busBDecOutTriEn(9),busB );
--
RegIR:entity work.my_nDFF  generic map (16) port map ( clk , rst ,busC, outRegIRTriIn,Rn&tempInDecoder(10)); -- temp ,flag ,ir
tri12B: entity work.tri_state_buffer port map (outRegIRTriIn,busBDecOutTriEn(10),busB );
--
Regflag:entity work.my_nDFF  generic map (16) port map ( clk , rst ,flags, outRegFlagTriIn,MAR&Mdr&FlagINDecoder(2));
tri13A: entity work.tri_state_buffer port map (outRegFlagTriIn,busADecOutTriEn(11),busA);
tri13B: entity work.tri_state_buffer port map (outRegFlagTriIn,busBDecOutTriEn(11),busB);
--------------------------------------------------------------------------------------------------------------------
alu : entity work.ALU port map (busA,busB,outRegFlagTriIn(0),aluSel,busC, flags(0)); --alu
flags(1) <='1' when busC =x"0000" else '0';
flags(2) <='1' when busC(15) ='1' else '0';
flags(3)<= not(busC(0));
flags(15 downto 5) <="00000000000";
---------------------------------------------------------------------------------------------------------------
end Architecture;



