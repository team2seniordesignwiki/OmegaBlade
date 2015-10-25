
_Fat16_Init:

;Fat16.c,57 :: 		bool Fat16_Init()
;Fat16.c,72 :: 		bFat16Initialized = false;
	CLRF        _bFat16Initialized+0 
;Fat16.c,74 :: 		SPI1_Init_Advanced(_SPI_MASTER_OSC_DIV16, _SPI_DATA_SAMPLE_MIDDLE, _SPI_CLK_IDLE_LOW, _SPI_LOW_2_HIGH);
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_master+0 
	CLRF        FARG_SPI1_Init_Advanced_data_sample+0 
	CLRF        FARG_SPI1_Init_Advanced_clock_idle+0 
	MOVLW       1
	MOVWF       FARG_SPI1_Init_Advanced_transmit_edge+0 
	CALL        _SPI1_Init_Advanced+0, 0
;Fat16.c,75 :: 		Mmc_Init();
	CALL        _Mmc_Init+0, 0
;Fat16.c,77 :: 		sectorNum = 0;
	CLRF        Fat16_Init_sectorNum_L0+0 
	CLRF        Fat16_Init_sectorNum_L0+1 
	CLRF        Fat16_Init_sectorNum_L0+2 
	CLRF        Fat16_Init_sectorNum_L0+3 
;Fat16.c,78 :: 		error = Mmc_Read_Sector(sectorNum, DataBuffer);
	CLRF        FARG_Mmc_Read_Sector_sector+0 
	CLRF        FARG_Mmc_Read_Sector_sector+1 
	CLRF        FARG_Mmc_Read_Sector_sector+2 
	CLRF        FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _DataBuffer+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_DataBuffer+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;Fat16.c,79 :: 		if ( error == 1 )
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Init0
;Fat16.c,80 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init0:
;Fat16.c,82 :: 		if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
	MOVF        _DataBuffer+510, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Init94
	MOVF        _DataBuffer+511, 0 
	XORLW       170
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Init94
	GOTO        L_Fat16_Init3
L__Fat16_Init94:
;Fat16.c,83 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init3:
;Fat16.c,85 :: 		if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
	MOVF        _DataBuffer+0, 0 
	XORLW       235
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_Init6
	MOVF        _DataBuffer+0, 0 
	XORLW       233
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_Init6
L__Fat16_Init93:
;Fat16.c,87 :: 		bPartition = false;
	CLRF        Fat16_Init_bPartition_L0+0 
;Fat16.c,88 :: 		i = 0;
	CLRF        Fat16_Init_i_L0+0 
	CLRF        Fat16_Init_i_L0+1 
;Fat16.c,90 :: 		while ((i < 4) && (bPartition==false))
L_Fat16_Init7:
	MOVLW       128
	XORWF       Fat16_Init_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Init97
	MOVLW       4
	SUBWF       Fat16_Init_i_L0+0, 0 
L__Fat16_Init97:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_Init8
	MOVF        Fat16_Init_bPartition_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Init8
L__Fat16_Init92:
;Fat16.c,92 :: 		offsetTypePartition = 0x1C2 + (i * 16);
	MOVLW       4
	MOVWF       R2 
	MOVF        Fat16_Init_i_L0+0, 0 
	MOVWF       R0 
	MOVF        Fat16_Init_i_L0+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
L__Fat16_Init98:
	BZ          L__Fat16_Init99
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	ADDLW       255
	GOTO        L__Fat16_Init98
L__Fat16_Init99:
	MOVLW       194
	ADDWF       R0, 1 
	MOVLW       1
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       Fat16_Init_offsetTypePartition_L0+0 
	MOVF        R1, 0 
	MOVWF       Fat16_Init_offsetTypePartition_L0+1 
;Fat16.c,93 :: 		tmp = DataBuffer[offsetTypePartition];
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Fat16_Init_tmp_L0+0 
;Fat16.c,94 :: 		if ((tmp == 4) || (tmp == 6) || (tmp == 0x0E))
	MOVF        R1, 0 
	XORLW       4
	BTFSC       STATUS+0, 2 
	GOTO        L__Fat16_Init91
	MOVF        Fat16_Init_tmp_L0+0, 0 
	XORLW       6
	BTFSC       STATUS+0, 2 
	GOTO        L__Fat16_Init91
	MOVF        Fat16_Init_tmp_L0+0, 0 
	XORLW       14
	BTFSC       STATUS+0, 2 
	GOTO        L__Fat16_Init91
	GOTO        L_Fat16_Init13
L__Fat16_Init91:
;Fat16.c,95 :: 		bPartition = true;
	MOVLW       1
	MOVWF       Fat16_Init_bPartition_L0+0 
L_Fat16_Init13:
;Fat16.c,96 :: 		i++;
	INFSNZ      Fat16_Init_i_L0+0, 1 
	INCF        Fat16_Init_i_L0+1, 1 
;Fat16.c,97 :: 		}
	GOTO        L_Fat16_Init7
L_Fat16_Init8:
;Fat16.c,99 :: 		if ( bPartition == false )
	MOVF        Fat16_Init_bPartition_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Init14
;Fat16.c,100 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init14:
;Fat16.c,102 :: 		ptrLong = &DataBuffer[offsetTypePartition+4];
	MOVLW       4
	ADDWF       Fat16_Init_offsetTypePartition_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Fat16_Init_offsetTypePartition_L0+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;Fat16.c,103 :: 		sectorNum = *ptrLong;
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        POSTINC0+0, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       Fat16_Init_sectorNum_L0+0 
	MOVF        R1, 0 
	MOVWF       Fat16_Init_sectorNum_L0+1 
	MOVF        R2, 0 
	MOVWF       Fat16_Init_sectorNum_L0+2 
	MOVF        R3, 0 
	MOVWF       Fat16_Init_sectorNum_L0+3 
;Fat16.c,105 :: 		error = Mmc_Read_Sector(sectorNum, DataBuffer);
	MOVF        R0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        R1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        R2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        R3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _DataBuffer+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_DataBuffer+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;Fat16.c,106 :: 		if ( error == 1 )
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Init15
;Fat16.c,107 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init15:
;Fat16.c,109 :: 		if ((DataBuffer[0x1FE] != 0x55) || (DataBuffer[0x1FF] != 0xAA))
	MOVF        _DataBuffer+510, 0 
	XORLW       85
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Init90
	MOVF        _DataBuffer+511, 0 
	XORLW       170
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Init90
	GOTO        L_Fat16_Init18
L__Fat16_Init90:
;Fat16.c,110 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init18:
;Fat16.c,112 :: 		if ((DataBuffer[0] != 0xEB) && (DataBuffer[0] != 0xE9))
	MOVF        _DataBuffer+0, 0 
	XORLW       235
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_Init21
	MOVF        _DataBuffer+0, 0 
	XORLW       233
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_Init21
L__Fat16_Init89:
;Fat16.c,113 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Init
L_Fat16_Init21:
;Fat16.c,114 :: 		}
L_Fat16_Init6:
;Fat16.c,116 :: 		ptrInt = &DataBuffer[0x0B];
	MOVLW       _DataBuffer+11
	MOVWF       Fat16_Init_ptrInt_L0+0 
	MOVLW       hi_addr(_DataBuffer+11)
	MOVWF       Fat16_Init_ptrInt_L0+1 
;Fat16.c,117 :: 		BytesPerSector = *ptrInt;
	MOVFF       Fat16_Init_ptrInt_L0+0, FSR0L
	MOVFF       Fat16_Init_ptrInt_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       Fat16_Init_BytesPerSector_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Fat16_Init_BytesPerSector_L0+1 
	MOVLW       0
	MOVWF       Fat16_Init_BytesPerSector_L0+2 
	MOVWF       Fat16_Init_BytesPerSector_L0+3 
	MOVLW       0
	MOVWF       Fat16_Init_BytesPerSector_L0+2 
	MOVWF       Fat16_Init_BytesPerSector_L0+3 
;Fat16.c,118 :: 		SectorsPerCluster = DataBuffer[0x0D];
	MOVF        _DataBuffer+13, 0 
	MOVWF       _SectorsPerCluster+0 
	MOVLW       0
	MOVWF       _SectorsPerCluster+1 
	MOVWF       _SectorsPerCluster+2 
	MOVWF       _SectorsPerCluster+3 
;Fat16.c,119 :: 		ptrInt = &DataBuffer[0x0E];
	MOVLW       _DataBuffer+14
	MOVWF       Fat16_Init_ptrInt_L0+0 
	MOVLW       hi_addr(_DataBuffer+14)
	MOVWF       Fat16_Init_ptrInt_L0+1 
;Fat16.c,120 :: 		ReservedSectors = *ptrInt;
	MOVFF       Fat16_Init_ptrInt_L0+0, FSR0L
	MOVFF       Fat16_Init_ptrInt_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       Fat16_Init_ReservedSectors_L0+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       Fat16_Init_ReservedSectors_L0+1 
	MOVLW       0
	MOVWF       Fat16_Init_ReservedSectors_L0+2 
	MOVWF       Fat16_Init_ReservedSectors_L0+3 
	MOVLW       0
	MOVWF       Fat16_Init_ReservedSectors_L0+2 
	MOVWF       Fat16_Init_ReservedSectors_L0+3 
;Fat16.c,121 :: 		NumberFats = DataBuffer[0x10];
	MOVF        _DataBuffer+16, 0 
	MOVWF       Fat16_Init_NumberFats_L0+0 
	MOVLW       0
	MOVWF       Fat16_Init_NumberFats_L0+1 
	MOVWF       Fat16_Init_NumberFats_L0+2 
	MOVWF       Fat16_Init_NumberFats_L0+3 
;Fat16.c,122 :: 		ptrInt = &DataBuffer[0x16];
	MOVLW       _DataBuffer+22
	MOVWF       Fat16_Init_ptrInt_L0+0 
	MOVLW       hi_addr(_DataBuffer+22)
	MOVWF       Fat16_Init_ptrInt_L0+1 
;Fat16.c,123 :: 		SectorsPerFat = *ptrInt;
	MOVFF       Fat16_Init_ptrInt_L0+0, FSR0L
	MOVFF       Fat16_Init_ptrInt_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       _SectorsPerFat+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       _SectorsPerFat+1 
	MOVLW       0
	MOVWF       _SectorsPerFat+2 
	MOVWF       _SectorsPerFat+3 
	MOVLW       0
	MOVWF       _SectorsPerFat+2 
	MOVWF       _SectorsPerFat+3 
;Fat16.c,125 :: 		FirstFatSector = sectorNum + ReservedSectors;
	MOVF        Fat16_Init_ReservedSectors_L0+0, 0 
	ADDWF       Fat16_Init_sectorNum_L0+0, 0 
	MOVWF       _FirstFatSector+0 
	MOVF        Fat16_Init_ReservedSectors_L0+1, 0 
	ADDWFC      Fat16_Init_sectorNum_L0+1, 0 
	MOVWF       _FirstFatSector+1 
	MOVF        Fat16_Init_ReservedSectors_L0+2, 0 
	ADDWFC      Fat16_Init_sectorNum_L0+2, 0 
	MOVWF       _FirstFatSector+2 
	MOVF        Fat16_Init_ReservedSectors_L0+3, 0 
	ADDWFC      Fat16_Init_sectorNum_L0+3, 0 
	MOVWF       _FirstFatSector+3 
;Fat16.c,126 :: 		MaxFatEntries = BytesPerSector * SectorsPerFat / 2;
	MOVF        Fat16_Init_BytesPerSector_L0+0, 0 
	MOVWF       R0 
	MOVF        Fat16_Init_BytesPerSector_L0+1, 0 
	MOVWF       R1 
	MOVF        Fat16_Init_BytesPerSector_L0+2, 0 
	MOVWF       R2 
	MOVF        Fat16_Init_BytesPerSector_L0+3, 0 
	MOVWF       R3 
	MOVF        _SectorsPerFat+0, 0 
	MOVWF       R4 
	MOVF        _SectorsPerFat+1, 0 
	MOVWF       R5 
	MOVF        _SectorsPerFat+2, 0 
	MOVWF       R6 
	MOVF        _SectorsPerFat+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       _MaxFatEntries+0 
	MOVF        R1, 0 
	MOVWF       _MaxFatEntries+1 
	MOVF        R2, 0 
	MOVWF       _MaxFatEntries+2 
	MOVF        R3, 0 
	MOVWF       _MaxFatEntries+3 
	RRCF        _MaxFatEntries+3, 1 
	RRCF        _MaxFatEntries+2, 1 
	RRCF        _MaxFatEntries+1, 1 
	RRCF        _MaxFatEntries+0, 1 
	BCF         _MaxFatEntries+3, 7 
;Fat16.c,127 :: 		FirstDirSector = FirstFatSector + (SectorsPerFat * NumberFats);
	MOVF        _SectorsPerFat+0, 0 
	MOVWF       R0 
	MOVF        _SectorsPerFat+1, 0 
	MOVWF       R1 
	MOVF        _SectorsPerFat+2, 0 
	MOVWF       R2 
	MOVF        _SectorsPerFat+3, 0 
	MOVWF       R3 
	MOVF        Fat16_Init_NumberFats_L0+0, 0 
	MOVWF       R4 
	MOVF        Fat16_Init_NumberFats_L0+1, 0 
	MOVWF       R5 
	MOVF        Fat16_Init_NumberFats_L0+2, 0 
	MOVWF       R6 
	MOVF        Fat16_Init_NumberFats_L0+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	ADDWF       _FirstFatSector+0, 0 
	MOVWF       _FirstDirSector+0 
	MOVF        R1, 0 
	ADDWFC      _FirstFatSector+1, 0 
	MOVWF       _FirstDirSector+1 
	MOVF        R2, 0 
	ADDWFC      _FirstFatSector+2, 0 
	MOVWF       _FirstDirSector+2 
	MOVF        R3, 0 
	ADDWFC      _FirstFatSector+3, 0 
	MOVWF       _FirstDirSector+3 
;Fat16.c,128 :: 		DirEntriesPerSector = BytesPerSector / 32;
	MOVLW       5
	MOVWF       R0 
	MOVF        Fat16_Init_BytesPerSector_L0+0, 0 
	MOVWF       _DirEntriesPerSector+0 
	MOVF        Fat16_Init_BytesPerSector_L0+1, 0 
	MOVWF       _DirEntriesPerSector+1 
	MOVF        Fat16_Init_BytesPerSector_L0+2, 0 
	MOVWF       _DirEntriesPerSector+2 
	MOVF        Fat16_Init_BytesPerSector_L0+3, 0 
	MOVWF       _DirEntriesPerSector+3 
	MOVF        R0, 0 
L__Fat16_Init100:
	BZ          L__Fat16_Init101
	RRCF        _DirEntriesPerSector+3, 1 
	RRCF        _DirEntriesPerSector+2, 1 
	RRCF        _DirEntriesPerSector+1, 1 
	RRCF        _DirEntriesPerSector+0, 1 
	BCF         _DirEntriesPerSector+3, 7 
	BTFSC       _DirEntriesPerSector+3, 6 
	BSF         _DirEntriesPerSector+3, 7 
	ADDLW       255
	GOTO        L__Fat16_Init100
L__Fat16_Init101:
;Fat16.c,130 :: 		SectorInBuffer = -1;
	MOVLW       255
	MOVWF       _SectorInBuffer+0 
	MOVLW       255
	MOVWF       _SectorInBuffer+1 
	MOVWF       _SectorInBuffer+2 
	MOVWF       _SectorInBuffer+3 
;Fat16.c,131 :: 		FirstDirCluster = 0;
	CLRF        _FirstDirCluster+0 
	CLRF        _FirstDirCluster+1 
;Fat16.c,133 :: 		bFat16Initialized = true;
	MOVLW       1
	MOVWF       _bFat16Initialized+0 
;Fat16.c,135 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;Fat16.c,137 :: 		}
L_end_Fat16_Init:
	RETURN      0
; end of _Fat16_Init

_Fat16_ReadFatSector:

;Fat16.c,141 :: 		bool Fat16_ReadFatSector(unsigned int Entry)
;Fat16.c,147 :: 		if ( Entry >= MaxFatEntries )
	MOVF        _MaxFatEntries+3, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector103
	MOVF        _MaxFatEntries+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector103
	MOVF        _MaxFatEntries+1, 0 
	SUBWF       FARG_Fat16_ReadFatSector_Entry+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector103
	MOVF        _MaxFatEntries+0, 0 
	SUBWF       FARG_Fat16_ReadFatSector_Entry+0, 0 
L__Fat16_ReadFatSector103:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_ReadFatSector22
;Fat16.c,148 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_ReadFatSector
L_Fat16_ReadFatSector22:
;Fat16.c,150 :: 		DesiredSector = Entry / 256;
	MOVF        FARG_Fat16_ReadFatSector_Entry+1, 0 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+0 
	CLRF        Fat16_ReadFatSector_DesiredSector_L0+1 
	CLRF        Fat16_ReadFatSector_DesiredSector_L0+2 
	CLRF        Fat16_ReadFatSector_DesiredSector_L0+3 
	MOVLW       0
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+2 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+3 
;Fat16.c,151 :: 		DesiredSector = DesiredSector + FirstFatSector;
	MOVF        _FirstFatSector+0, 0 
	ADDWF       Fat16_ReadFatSector_DesiredSector_L0+0, 0 
	MOVWF       R1 
	MOVF        _FirstFatSector+1, 0 
	ADDWFC      Fat16_ReadFatSector_DesiredSector_L0+1, 0 
	MOVWF       R2 
	MOVF        _FirstFatSector+2, 0 
	ADDWFC      Fat16_ReadFatSector_DesiredSector_L0+2, 0 
	MOVWF       R3 
	MOVF        _FirstFatSector+3, 0 
	ADDWFC      Fat16_ReadFatSector_DesiredSector_L0+3, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+0 
	MOVF        R2, 0 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+1 
	MOVF        R3, 0 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+2 
	MOVF        R4, 0 
	MOVWF       Fat16_ReadFatSector_DesiredSector_L0+3 
;Fat16.c,152 :: 		OffsetFatBuffer = (Entry % 256) * 2;
	MOVLW       255
	ANDWF       FARG_Fat16_ReadFatSector_Entry+0, 0 
	MOVWF       _OffsetFatBuffer+0 
	MOVF        FARG_Fat16_ReadFatSector_Entry+1, 0 
	MOVWF       _OffsetFatBuffer+1 
	MOVLW       0
	ANDWF       _OffsetFatBuffer+1, 1 
	RLCF        _OffsetFatBuffer+0, 1 
	BCF         _OffsetFatBuffer+0, 0 
	RLCF        _OffsetFatBuffer+1, 1 
;Fat16.c,154 :: 		if ( SectorInBuffer != DesiredSector )
	MOVF        _SectorInBuffer+3, 0 
	XORWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector104
	MOVF        _SectorInBuffer+2, 0 
	XORWF       R3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector104
	MOVF        _SectorInBuffer+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadFatSector104
	MOVF        _SectorInBuffer+0, 0 
	XORWF       R1, 0 
L__Fat16_ReadFatSector104:
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_ReadFatSector23
;Fat16.c,156 :: 		error = Mmc_Read_Sector(DesiredSector, DataBuffer);
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _DataBuffer+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_DataBuffer+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;Fat16.c,157 :: 		if ( error == 1 )
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_ReadFatSector24
;Fat16.c,158 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_ReadFatSector
L_Fat16_ReadFatSector24:
;Fat16.c,160 :: 		SectorInBuffer = DesiredSector;
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+0, 0 
	MOVWF       _SectorInBuffer+0 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+1, 0 
	MOVWF       _SectorInBuffer+1 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+2, 0 
	MOVWF       _SectorInBuffer+2 
	MOVF        Fat16_ReadFatSector_DesiredSector_L0+3, 0 
	MOVWF       _SectorInBuffer+3 
;Fat16.c,162 :: 		}
L_Fat16_ReadFatSector23:
;Fat16.c,164 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;Fat16.c,166 :: 		}
L_end_Fat16_ReadFatSector:
	RETURN      0
; end of _Fat16_ReadFatSector

_Fat16_ReadDirEntry:

;Fat16.c,170 :: 		bool Fat16_ReadDirEntry(int Entry)
;Fat16.c,180 :: 		sectorIndex = Entry / DirEntriesPerSector;
	MOVF        _DirEntriesPerSector+0, 0 
	MOVWF       R4 
	MOVF        _DirEntriesPerSector+1, 0 
	MOVWF       R5 
	MOVF        _DirEntriesPerSector+2, 0 
	MOVWF       R6 
	MOVF        _DirEntriesPerSector+3, 0 
	MOVWF       R7 
	MOVF        FARG_Fat16_ReadDirEntry_Entry+0, 0 
	MOVWF       R0 
	MOVF        FARG_Fat16_ReadDirEntry_Entry+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_Fat16_ReadDirEntry_Entry+1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_ReadDirEntry_sectorIndex_L0+0 
	MOVF        R1, 0 
	MOVWF       Fat16_ReadDirEntry_sectorIndex_L0+1 
	MOVF        R2, 0 
	MOVWF       Fat16_ReadDirEntry_sectorIndex_L0+2 
	MOVF        R3, 0 
	MOVWF       Fat16_ReadDirEntry_sectorIndex_L0+3 
;Fat16.c,181 :: 		clusterIndex = sectorIndex / SectorsPerCluster;
	MOVF        _SectorsPerCluster+0, 0 
	MOVWF       R4 
	MOVF        _SectorsPerCluster+1, 0 
	MOVWF       R5 
	MOVF        _SectorsPerCluster+2, 0 
	MOVWF       R6 
	MOVF        _SectorsPerCluster+3, 0 
	MOVWF       R7 
	CALL        _Div_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_ReadDirEntry_clusterIndex_L0+0 
	MOVF        R1, 0 
	MOVWF       Fat16_ReadDirEntry_clusterIndex_L0+1 
;Fat16.c,182 :: 		cluster = FirstDirCluster;
	MOVF        _FirstDirCluster+0, 0 
	MOVWF       Fat16_ReadDirEntry_cluster_L0+0 
	MOVF        _FirstDirCluster+1, 0 
	MOVWF       Fat16_ReadDirEntry_cluster_L0+1 
;Fat16.c,183 :: 		while (clusterIndex > 0 )
L_Fat16_ReadDirEntry25:
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       Fat16_ReadDirEntry_clusterIndex_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadDirEntry106
	MOVF        Fat16_ReadDirEntry_clusterIndex_L0+0, 0 
	SUBLW       0
L__Fat16_ReadDirEntry106:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_ReadDirEntry26
;Fat16.c,185 :: 		clusterIndex--;
	MOVLW       1
	SUBWF       Fat16_ReadDirEntry_clusterIndex_L0+0, 1 
	MOVLW       0
	SUBWFB      Fat16_ReadDirEntry_clusterIndex_L0+1, 1 
;Fat16.c,186 :: 		Fat16_ReadFatSector(cluster+1);
	MOVLW       1
	ADDWF       Fat16_ReadDirEntry_cluster_L0+0, 0 
	MOVWF       FARG_Fat16_ReadFatSector_Entry+0 
	MOVLW       0
	ADDWFC      Fat16_ReadDirEntry_cluster_L0+1, 0 
	MOVWF       FARG_Fat16_ReadFatSector_Entry+1 
	CALL        _Fat16_ReadFatSector+0, 0
;Fat16.c,187 :: 		ptrInt = &DataBuffer[OffsetFatBuffer];
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetFatBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetFatBuffer+1, 0 
	MOVWF       FSR0H 
;Fat16.c,188 :: 		cluster = *ptrInt;
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       Fat16_ReadDirEntry_cluster_L0+0 
	MOVF        R2, 0 
	MOVWF       Fat16_ReadDirEntry_cluster_L0+1 
;Fat16.c,189 :: 		if ( cluster >= 0xfff8 )
	MOVLW       255
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadDirEntry107
	MOVLW       248
	SUBWF       R1, 0 
L__Fat16_ReadDirEntry107:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_ReadDirEntry27
;Fat16.c,190 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_ReadDirEntry
L_Fat16_ReadDirEntry27:
;Fat16.c,191 :: 		cluster--;
	MOVLW       1
	SUBWF       Fat16_ReadDirEntry_cluster_L0+0, 1 
	MOVLW       0
	SUBWFB      Fat16_ReadDirEntry_cluster_L0+1, 1 
;Fat16.c,192 :: 		}
	GOTO        L_Fat16_ReadDirEntry25
L_Fat16_ReadDirEntry26:
;Fat16.c,193 :: 		DesiredSector = cluster * SectorsPerCluster;
	MOVF        Fat16_ReadDirEntry_cluster_L0+0, 0 
	MOVWF       R0 
	MOVF        Fat16_ReadDirEntry_cluster_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVF        _SectorsPerCluster+0, 0 
	MOVWF       R4 
	MOVF        _SectorsPerCluster+1, 0 
	MOVWF       R5 
	MOVF        _SectorsPerCluster+2, 0 
	MOVWF       R6 
	MOVF        _SectorsPerCluster+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_ReadDirEntry_DesiredSector_L0+0 
	MOVF        R1, 0 
	MOVWF       Fat16_ReadDirEntry_DesiredSector_L0+1 
	MOVF        R2, 0 
	MOVWF       Fat16_ReadDirEntry_DesiredSector_L0+2 
	MOVF        R3, 0 
	MOVWF       Fat16_ReadDirEntry_DesiredSector_L0+3 
;Fat16.c,194 :: 		DesiredSector = DesiredSector + sectorIndex % SectorsPerCluster;
	MOVF        _SectorsPerCluster+0, 0 
	MOVWF       R4 
	MOVF        _SectorsPerCluster+1, 0 
	MOVWF       R5 
	MOVF        _SectorsPerCluster+2, 0 
	MOVWF       R6 
	MOVF        _SectorsPerCluster+3, 0 
	MOVWF       R7 
	MOVF        Fat16_ReadDirEntry_sectorIndex_L0+0, 0 
	MOVWF       R0 
	MOVF        Fat16_ReadDirEntry_sectorIndex_L0+1, 0 
	MOVWF       R1 
	MOVF        Fat16_ReadDirEntry_sectorIndex_L0+2, 0 
	MOVWF       R2 
	MOVF        Fat16_ReadDirEntry_sectorIndex_L0+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	ADDWF       Fat16_ReadDirEntry_DesiredSector_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+1, 1 
	MOVF        R2, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+2, 1 
	MOVF        R3, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+3, 1 
;Fat16.c,195 :: 		DesiredSector  = DesiredSector + FirstDirSector;
	MOVF        _FirstDirSector+0, 0 
	ADDWF       Fat16_ReadDirEntry_DesiredSector_L0+0, 1 
	MOVF        _FirstDirSector+1, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+1, 1 
	MOVF        _FirstDirSector+2, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+2, 1 
	MOVF        _FirstDirSector+3, 0 
	ADDWFC      Fat16_ReadDirEntry_DesiredSector_L0+3, 1 
;Fat16.c,196 :: 		OffsetDirBuffer = (Entry % DirEntriesPerSector) * 32;
	MOVF        _DirEntriesPerSector+0, 0 
	MOVWF       R4 
	MOVF        _DirEntriesPerSector+1, 0 
	MOVWF       R5 
	MOVF        _DirEntriesPerSector+2, 0 
	MOVWF       R6 
	MOVF        _DirEntriesPerSector+3, 0 
	MOVWF       R7 
	MOVF        FARG_Fat16_ReadDirEntry_Entry+0, 0 
	MOVWF       R0 
	MOVF        FARG_Fat16_ReadDirEntry_Entry+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       FARG_Fat16_ReadDirEntry_Entry+1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	CALL        _Div_32x32_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       5
	MOVWF       R4 
	MOVF        R0, 0 
	MOVWF       _OffsetDirBuffer+0 
	MOVF        R1, 0 
	MOVWF       _OffsetDirBuffer+1 
	MOVF        R4, 0 
L__Fat16_ReadDirEntry108:
	BZ          L__Fat16_ReadDirEntry109
	RLCF        _OffsetDirBuffer+0, 1 
	BCF         _OffsetDirBuffer+0, 0 
	RLCF        _OffsetDirBuffer+1, 1 
	ADDLW       255
	GOTO        L__Fat16_ReadDirEntry108
L__Fat16_ReadDirEntry109:
;Fat16.c,198 :: 		if ( SectorInBuffer != DesiredSector )
	MOVF        _SectorInBuffer+3, 0 
	XORWF       Fat16_ReadDirEntry_DesiredSector_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadDirEntry110
	MOVF        _SectorInBuffer+2, 0 
	XORWF       Fat16_ReadDirEntry_DesiredSector_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadDirEntry110
	MOVF        _SectorInBuffer+1, 0 
	XORWF       Fat16_ReadDirEntry_DesiredSector_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ReadDirEntry110
	MOVF        _SectorInBuffer+0, 0 
	XORWF       Fat16_ReadDirEntry_DesiredSector_L0+0, 0 
L__Fat16_ReadDirEntry110:
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_ReadDirEntry28
;Fat16.c,201 :: 		error = Mmc_Read_Sector(DesiredSector, DataBuffer);
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
	MOVLW       _DataBuffer+0
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVLW       hi_addr(_DataBuffer+0)
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;Fat16.c,202 :: 		if ( error == 1 )
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_ReadDirEntry29
;Fat16.c,203 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_ReadDirEntry
L_Fat16_ReadDirEntry29:
;Fat16.c,205 :: 		SectorInBuffer = DesiredSector;
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+0, 0 
	MOVWF       _SectorInBuffer+0 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+1, 0 
	MOVWF       _SectorInBuffer+1 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+2, 0 
	MOVWF       _SectorInBuffer+2 
	MOVF        Fat16_ReadDirEntry_DesiredSector_L0+3, 0 
	MOVWF       _SectorInBuffer+3 
;Fat16.c,207 :: 		}
L_Fat16_ReadDirEntry28:
;Fat16.c,209 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;Fat16.c,211 :: 		}
L_end_Fat16_ReadDirEntry:
	RETURN      0
; end of _Fat16_ReadDirEntry

_Fat16_FindCurrent:

;Fat16.c,215 :: 		bool Fat16_FindCurrent()
;Fat16.c,227 :: 		iLFN = 0;
	CLRF        Fat16_FindCurrent_iLFN_L0+0 
	CLRF        Fat16_FindCurrent_iLFN_L0+1 
;Fat16.c,228 :: 		bLongFileNameSeen = false;
	CLRF        Fat16_FindCurrent_bLongFileNameSeen_L0+0 
;Fat16.c,229 :: 		while (bEndDir == false)
L_Fat16_FindCurrent30:
	MOVF        _bEndDir+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent31
;Fat16.c,232 :: 		if (DataBuffer[OffsetDirBuffer] == 0x00)
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent32
;Fat16.c,234 :: 		bEndDir = true;
	MOVLW       1
	MOVWF       _bEndDir+0 
;Fat16.c,235 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindCurrent
;Fat16.c,236 :: 		}
L_Fat16_FindCurrent32:
;Fat16.c,238 :: 		if (DataBuffer[OffsetDirBuffer] != 0xE5)
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       229
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent33
;Fat16.c,240 :: 		if (DataBuffer[OffsetDirBuffer + 11] == 0x0F)
	MOVLW       11
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       15
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent34
;Fat16.c,242 :: 		if ((DataBuffer[OffsetDirBuffer] & 0x40) > 0 )
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       FSR0H 
	MOVLW       64
	ANDWF       POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	SUBLW       0
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent35
;Fat16.c,244 :: 		bLongFileNameSeen = true;
	MOVLW       1
	MOVWF       Fat16_FindCurrent_bLongFileNameSeen_L0+0 
;Fat16.c,245 :: 		}
L_Fat16_FindCurrent35:
;Fat16.c,247 :: 		nbr=0;
	CLRF        Fat16_FindCurrent_nbr_L0+0 
	CLRF        Fat16_FindCurrent_nbr_L0+1 
;Fat16.c,248 :: 		for (i=0; i<LFNameChunkSize; i++)
	CLRF        Fat16_FindCurrent_i_L0+0 
	CLRF        Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent36:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent112
	MOVLW       13
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent112:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent37
;Fat16.c,250 :: 		ch = DataBuffer[OffsetDirBuffer + LFNamePositions[i]];
	MOVLW       _LFNamePositions+0
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR2L 
	MOVLW       hi_addr(_LFNamePositions+0)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Fat16_FindCurrent_ch_L0+0 
;Fat16.c,251 :: 		if ( ch == 0 )
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent39
;Fat16.c,252 :: 		break;
	GOTO        L_Fat16_FindCurrent37
L_Fat16_FindCurrent39:
;Fat16.c,253 :: 		nbr++;
	INFSNZ      Fat16_FindCurrent_nbr_L0+0, 1 
	INCF        Fat16_FindCurrent_nbr_L0+1, 1 
;Fat16.c,248 :: 		for (i=0; i<LFNameChunkSize; i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,254 :: 		}
	GOTO        L_Fat16_FindCurrent36
L_Fat16_FindCurrent37:
;Fat16.c,256 :: 		for (i=iLFN-1; i>=0; i--)
	MOVLW       1
	SUBWF       Fat16_FindCurrent_iLFN_L0+0, 0 
	MOVWF       Fat16_FindCurrent_i_L0+0 
	MOVLW       0
	SUBWFB      Fat16_FindCurrent_iLFN_L0+1, 0 
	MOVWF       Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent40:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent113
	MOVLW       0
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent113:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent41
;Fat16.c,258 :: 		dirItem.LongFileName[i+nbr] = dirItem.LongFileName[i];
	MOVF        Fat16_FindCurrent_nbr_L0+0, 0 
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       R0 
	MOVF        Fat16_FindCurrent_nbr_L0+1, 0 
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       _dirItem+0
	ADDWF       R0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+0)
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       _dirItem+0
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_dirItem+0)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Fat16.c,256 :: 		for (i=iLFN-1; i>=0; i--)
	MOVLW       1
	SUBWF       Fat16_FindCurrent_i_L0+0, 1 
	MOVLW       0
	SUBWFB      Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,259 :: 		}
	GOTO        L_Fat16_FindCurrent40
L_Fat16_FindCurrent41:
;Fat16.c,260 :: 		iLFN += nbr;
	MOVF        Fat16_FindCurrent_nbr_L0+0, 0 
	ADDWF       Fat16_FindCurrent_iLFN_L0+0, 1 
	MOVF        Fat16_FindCurrent_nbr_L0+1, 0 
	ADDWFC      Fat16_FindCurrent_iLFN_L0+1, 1 
;Fat16.c,262 :: 		j = 0;
	CLRF        Fat16_FindCurrent_j_L0+0 
	CLRF        Fat16_FindCurrent_j_L0+1 
;Fat16.c,263 :: 		for (i=0; i<LFNameChunkSize; i++)
	CLRF        Fat16_FindCurrent_i_L0+0 
	CLRF        Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent43:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent114
	MOVLW       13
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent114:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent44
;Fat16.c,265 :: 		ch = DataBuffer[OffsetDirBuffer + LFNamePositions[i]];
	MOVLW       _LFNamePositions+0
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR2L 
	MOVLW       hi_addr(_LFNamePositions+0)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Fat16_FindCurrent_ch_L0+0 
;Fat16.c,266 :: 		if ( ch == 0 )
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent46
;Fat16.c,267 :: 		break;
	GOTO        L_Fat16_FindCurrent44
L_Fat16_FindCurrent46:
;Fat16.c,268 :: 		dirItem.LongFileName[j++] = ch;
	MOVLW       _dirItem+0
	ADDWF       Fat16_FindCurrent_j_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+0)
	ADDWFC      Fat16_FindCurrent_j_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        Fat16_FindCurrent_ch_L0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      Fat16_FindCurrent_j_L0+0, 1 
	INCF        Fat16_FindCurrent_j_L0+1, 1 
;Fat16.c,263 :: 		for (i=0; i<LFNameChunkSize; i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,269 :: 		}
	GOTO        L_Fat16_FindCurrent43
L_Fat16_FindCurrent44:
;Fat16.c,271 :: 		if ((DataBuffer[OffsetDirBuffer] & 0xBF ) == 1 )
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       FSR0H 
	MOVLW       191
	ANDWF       POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent47
;Fat16.c,273 :: 		dirItem.LongFileNamePresent = true;
	MOVLW       1
	MOVWF       _dirItem+256 
;Fat16.c,274 :: 		}
L_Fat16_FindCurrent47:
;Fat16.c,275 :: 		}
	GOTO        L_Fat16_FindCurrent48
L_Fat16_FindCurrent34:
;Fat16.c,278 :: 		for (i=iLFN; i<256; i++)
	MOVF        Fat16_FindCurrent_iLFN_L0+0, 0 
	MOVWF       Fat16_FindCurrent_i_L0+0 
	MOVF        Fat16_FindCurrent_iLFN_L0+1, 0 
	MOVWF       Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent49:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent115
	MOVLW       0
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent115:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent50
;Fat16.c,279 :: 		dirItem.LongFileName[i] = 0;
	MOVLW       _dirItem+0
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+0)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Fat16.c,278 :: 		for (i=iLFN; i<256; i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,279 :: 		dirItem.LongFileName[i] = 0;
	GOTO        L_Fat16_FindCurrent49
L_Fat16_FindCurrent50:
;Fat16.c,281 :: 		if ( bLongFileNameSeen == false )
	MOVF        Fat16_FindCurrent_bLongFileNameSeen_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent52
;Fat16.c,283 :: 		dirItem.LongFileNamePresent = false;
	CLRF        _dirItem+256 
;Fat16.c,284 :: 		}
L_Fat16_FindCurrent52:
;Fat16.c,286 :: 		iSFN = 0;
	CLRF        Fat16_FindCurrent_iSFN_L0+0 
	CLRF        Fat16_FindCurrent_iSFN_L0+1 
;Fat16.c,287 :: 		for (i = 0; i<8;i++)
	CLRF        Fat16_FindCurrent_i_L0+0 
	CLRF        Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent53:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent116
	MOVLW       8
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent116:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent54
;Fat16.c,288 :: 		if (DataBuffer[OffsetDirBuffer + i] != ' ' )
	MOVF        Fat16_FindCurrent_i_L0+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVF        Fat16_FindCurrent_i_L0+1, 0 
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent56
;Fat16.c,289 :: 		dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i];
	MOVLW       _dirItem+257
	ADDWF       Fat16_FindCurrent_iSFN_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+257)
	ADDWFC      Fat16_FindCurrent_iSFN_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        Fat16_FindCurrent_i_L0+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVF        Fat16_FindCurrent_i_L0+1, 0 
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      Fat16_FindCurrent_iSFN_L0+0, 1 
	INCF        Fat16_FindCurrent_iSFN_L0+1, 1 
L_Fat16_FindCurrent56:
;Fat16.c,287 :: 		for (i = 0; i<8;i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,289 :: 		dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i];
	GOTO        L_Fat16_FindCurrent53
L_Fat16_FindCurrent54:
;Fat16.c,291 :: 		if ( DataBuffer[OffsetDirBuffer + 8] != ' ' )
	MOVLW       8
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent57
;Fat16.c,292 :: 		dirItem.ShortFileName[iSFN++] = '.';
	MOVLW       _dirItem+257
	ADDWF       Fat16_FindCurrent_iSFN_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+257)
	ADDWFC      Fat16_FindCurrent_iSFN_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       46
	MOVWF       POSTINC1+0 
	INFSNZ      Fat16_FindCurrent_iSFN_L0+0, 1 
	INCF        Fat16_FindCurrent_iSFN_L0+1, 1 
L_Fat16_FindCurrent57:
;Fat16.c,293 :: 		for (i = 0; i<3; i++)
	CLRF        Fat16_FindCurrent_i_L0+0 
	CLRF        Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent58:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent117
	MOVLW       3
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent117:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent59
;Fat16.c,294 :: 		if (DataBuffer[OffsetDirBuffer + i + 8] != ' ' )
	MOVF        Fat16_FindCurrent_i_L0+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVF        Fat16_FindCurrent_i_L0+1, 0 
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent61
;Fat16.c,295 :: 		dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i + 8];
	MOVLW       _dirItem+257
	ADDWF       Fat16_FindCurrent_iSFN_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+257)
	ADDWFC      Fat16_FindCurrent_iSFN_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        Fat16_FindCurrent_i_L0+0, 0 
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVF        Fat16_FindCurrent_i_L0+1, 0 
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       8
	ADDWF       R0, 1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INFSNZ      Fat16_FindCurrent_iSFN_L0+0, 1 
	INCF        Fat16_FindCurrent_iSFN_L0+1, 1 
L_Fat16_FindCurrent61:
;Fat16.c,293 :: 		for (i = 0; i<3; i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,295 :: 		dirItem.ShortFileName[iSFN++] = DataBuffer[OffsetDirBuffer + i + 8];
	GOTO        L_Fat16_FindCurrent58
L_Fat16_FindCurrent59:
;Fat16.c,297 :: 		dirItem.ShortFileName[iSFN] = 0;
	MOVLW       _dirItem+257
	ADDWF       Fat16_FindCurrent_iSFN_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+257)
	ADDWFC      Fat16_FindCurrent_iSFN_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;Fat16.c,299 :: 		ptrLong = &DataBuffer[OffsetDirBuffer+28];
	MOVLW       28
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;Fat16.c,300 :: 		dirItem.FileSize = *ptrLong;
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+271 
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+272 
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+273 
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+274 
;Fat16.c,302 :: 		dirItem.FileAttr = DataBuffer[OffsetDirBuffer+11];
	MOVLW       11
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+270 
;Fat16.c,303 :: 		ptrInt = &DataBuffer[OffsetDirBuffer+26];
	MOVLW       26
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
;Fat16.c,304 :: 		dirItem.FirstCluster = *ptrInt;
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+275 
	MOVF        POSTINC0+0, 0 
	MOVWF       _dirItem+276 
;Fat16.c,306 :: 		if ( bLongFileNameSeen == false )
	MOVF        Fat16_FindCurrent_bLongFileNameSeen_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindCurrent62
;Fat16.c,308 :: 		for (i=0; i<13; i++)
	CLRF        Fat16_FindCurrent_i_L0+0 
	CLRF        Fat16_FindCurrent_i_L0+1 
L_Fat16_FindCurrent63:
	MOVLW       128
	XORWF       Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent118
	MOVLW       13
	SUBWF       Fat16_FindCurrent_i_L0+0, 0 
L__Fat16_FindCurrent118:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_FindCurrent64
;Fat16.c,310 :: 		dirItem.LongFileName[i] = dirItem.ShortFileName[i];
	MOVLW       _dirItem+0
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR1L 
	MOVLW       hi_addr(_dirItem+0)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR1H 
	MOVLW       _dirItem+257
	ADDWF       Fat16_FindCurrent_i_L0+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_dirItem+257)
	ADDWFC      Fat16_FindCurrent_i_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;Fat16.c,308 :: 		for (i=0; i<13; i++)
	INFSNZ      Fat16_FindCurrent_i_L0+0, 1 
	INCF        Fat16_FindCurrent_i_L0+1, 1 
;Fat16.c,311 :: 		}
	GOTO        L_Fat16_FindCurrent63
L_Fat16_FindCurrent64:
;Fat16.c,312 :: 		}
L_Fat16_FindCurrent62:
;Fat16.c,313 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Fat16_FindCurrent
;Fat16.c,314 :: 		}
L_Fat16_FindCurrent48:
;Fat16.c,315 :: 		}
L_Fat16_FindCurrent33:
;Fat16.c,317 :: 		if ((DataBuffer[OffsetDirBuffer] == 0xE5) ||
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       FSR0H 
;Fat16.c,318 :: 		(DataBuffer[OffsetDirBuffer + 11] == 0x0F))
	MOVF        POSTINC0+0, 0 
	XORLW       229
	BTFSC       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent95
	MOVLW       11
	ADDWF       _OffsetDirBuffer+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _OffsetDirBuffer+1, 0 
	MOVWF       R1 
	MOVLW       _DataBuffer+0
	ADDWF       R0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       15
	BTFSC       STATUS+0, 2 
	GOTO        L__Fat16_FindCurrent95
	GOTO        L_Fat16_FindCurrent68
L__Fat16_FindCurrent95:
;Fat16.c,320 :: 		DirEntry++;
	INFSNZ      _DirEntry+0, 1 
	INCF        _DirEntry+1, 1 
;Fat16.c,321 :: 		bStatut= Fat16_ReadDirEntry(DirEntry);
	MOVF        _DirEntry+0, 0 
	MOVWF       FARG_Fat16_ReadDirEntry_Entry+0 
	MOVF        _DirEntry+1, 0 
	MOVWF       FARG_Fat16_ReadDirEntry_Entry+1 
	CALL        _Fat16_ReadDirEntry+0, 0
;Fat16.c,326 :: 		}
L_Fat16_FindCurrent69:
;Fat16.c,327 :: 		}
L_Fat16_FindCurrent68:
;Fat16.c,328 :: 		}
	GOTO        L_Fat16_FindCurrent30
L_Fat16_FindCurrent31:
;Fat16.c,329 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;Fat16.c,330 :: 		}
L_end_Fat16_FindCurrent:
	RETURN      0
; end of _Fat16_FindCurrent

_Fat16_FindFirst:

;Fat16.c,334 :: 		bool Fat16_FindFirst()
;Fat16.c,338 :: 		if (bFat16Initialized == false)
	MOVF        _bFat16Initialized+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindFirst70
;Fat16.c,339 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindFirst
L_Fat16_FindFirst70:
;Fat16.c,341 :: 		bEndDir = false;
	CLRF        _bEndDir+0 
;Fat16.c,343 :: 		DirEntry = 0;
	CLRF        _DirEntry+0 
	CLRF        _DirEntry+1 
;Fat16.c,344 :: 		SectorInBuffer = -1;
	MOVLW       255
	MOVWF       _SectorInBuffer+0 
	MOVLW       255
	MOVWF       _SectorInBuffer+1 
	MOVWF       _SectorInBuffer+2 
	MOVWF       _SectorInBuffer+3 
;Fat16.c,346 :: 		bStatut = Fat16_ReadDirEntry(DirEntry);
	CLRF        FARG_Fat16_ReadDirEntry_Entry+0 
	CLRF        FARG_Fat16_ReadDirEntry_Entry+1 
	CALL        _Fat16_ReadDirEntry+0, 0
;Fat16.c,347 :: 		if ( bStatut == false )
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindFirst71
;Fat16.c,349 :: 		bEndDir = true;
	MOVLW       1
	MOVWF       _bEndDir+0 
;Fat16.c,350 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindFirst
;Fat16.c,351 :: 		}
L_Fat16_FindFirst71:
;Fat16.c,353 :: 		bStatut = Fat16_FindCurrent();
	CALL        _Fat16_FindCurrent+0, 0
;Fat16.c,355 :: 		return bStatut;
;Fat16.c,357 :: 		}
L_end_Fat16_FindFirst:
	RETURN      0
; end of _Fat16_FindFirst

_Fat16_FindNext:

;Fat16.c,361 :: 		bool Fat16_FindNext()
;Fat16.c,365 :: 		if (bFat16Initialized == false)
	MOVF        _bFat16Initialized+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindNext72
;Fat16.c,366 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindNext
L_Fat16_FindNext72:
;Fat16.c,367 :: 		if (bEndDir == true )
	MOVF        _bEndDir+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindNext73
;Fat16.c,368 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindNext
L_Fat16_FindNext73:
;Fat16.c,370 :: 		DirEntry++;
	INFSNZ      _DirEntry+0, 1 
	INCF        _DirEntry+1, 1 
;Fat16.c,371 :: 		bStatut = Fat16_ReadDirEntry(DirEntry);
	MOVF        _DirEntry+0, 0 
	MOVWF       FARG_Fat16_ReadDirEntry_Entry+0 
	MOVF        _DirEntry+1, 0 
	MOVWF       FARG_Fat16_ReadDirEntry_Entry+1 
	CALL        _Fat16_ReadDirEntry+0, 0
;Fat16.c,372 :: 		if ( bStatut == false )
	MOVF        R0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_FindNext74
;Fat16.c,374 :: 		bEndDir = true;
	MOVLW       1
	MOVWF       _bEndDir+0 
;Fat16.c,375 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_FindNext
;Fat16.c,376 :: 		}
L_Fat16_FindNext74:
;Fat16.c,378 :: 		bStatut = Fat16_FindCurrent();
	CALL        _Fat16_FindCurrent+0, 0
;Fat16.c,380 :: 		return bStatut;
;Fat16.c,382 :: 		}
L_end_Fat16_FindNext:
	RETURN      0
; end of _Fat16_FindNext

_Fat16_ChangeDir:

;Fat16.c,386 :: 		bool Fat16_ChangeDir(char* strDir)
;Fat16.c,392 :: 		if (bFat16Initialized == false)
	MOVF        _bFat16Initialized+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_ChangeDir75
;Fat16.c,393 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_ChangeDir
L_Fat16_ChangeDir75:
;Fat16.c,395 :: 		bStatut = Fat16_FindFirst();
	CALL        _Fat16_FindFirst+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_ChangeDir_bStatut_L0+0 
;Fat16.c,396 :: 		while ( bStatut == true )
L_Fat16_ChangeDir76:
	MOVF        Fat16_ChangeDir_bStatut_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_ChangeDir77
;Fat16.c,398 :: 		res = strcmp(dirItem.ShortFileName, strDir);
	MOVLW       _dirItem+257
	MOVWF       FARG_strcmp_s1+0 
	MOVLW       hi_addr(_dirItem+257)
	MOVWF       FARG_strcmp_s1+1 
	MOVF        FARG_Fat16_ChangeDir_strDir+0, 0 
	MOVWF       FARG_strcmp_s2+0 
	MOVF        FARG_Fat16_ChangeDir_strDir+1, 0 
	MOVWF       FARG_strcmp_s2+1 
	CALL        _strcmp+0, 0
;Fat16.c,399 :: 		if ( res == 0 )
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ChangeDir122
	MOVLW       0
	XORWF       R0, 0 
L__Fat16_ChangeDir122:
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_ChangeDir78
;Fat16.c,401 :: 		FirstDirCluster = dirItem.FirstCluster;
	MOVF        _dirItem+275, 0 
	MOVWF       _FirstDirCluster+0 
	MOVF        _dirItem+276, 0 
	MOVWF       _FirstDirCluster+1 
;Fat16.c,402 :: 		if ( FirstDirCluster > 0 )
	MOVLW       0
	MOVWF       R0 
	MOVF        _dirItem+276, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_ChangeDir123
	MOVF        _dirItem+275, 0 
	SUBLW       0
L__Fat16_ChangeDir123:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_ChangeDir79
;Fat16.c,403 :: 		FirstDirCluster--;
	MOVLW       1
	SUBWF       _FirstDirCluster+0, 1 
	MOVLW       0
	SUBWFB      _FirstDirCluster+1, 1 
L_Fat16_ChangeDir79:
;Fat16.c,404 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Fat16_ChangeDir
;Fat16.c,405 :: 		}
L_Fat16_ChangeDir78:
;Fat16.c,406 :: 		bStatut = Fat16_FindNext();
	CALL        _Fat16_FindNext+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_ChangeDir_bStatut_L0+0 
;Fat16.c,407 :: 		}
	GOTO        L_Fat16_ChangeDir76
L_Fat16_ChangeDir77:
;Fat16.c,409 :: 		return false;
	CLRF        R0 
;Fat16.c,411 :: 		}
L_end_Fat16_ChangeDir:
	RETURN      0
; end of _Fat16_ChangeDir

_Fat16_Assign:

;Fat16.c,415 :: 		unsigned long Fat16_Assign(char* strFic)
;Fat16.c,421 :: 		if (bFat16Initialized == false)
	MOVF        _bFat16Initialized+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Assign80
;Fat16.c,422 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
	GOTO        L_end_Fat16_Assign
L_Fat16_Assign80:
;Fat16.c,424 :: 		bStatut = Fat16_FindFirst();
	CALL        _Fat16_FindFirst+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_Assign_bStatut_L0+0 
;Fat16.c,425 :: 		while ( bStatut == true )
L_Fat16_Assign81:
	MOVF        Fat16_Assign_bStatut_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Assign82
;Fat16.c,427 :: 		res = strcmp(dirItem.LongFileName, strFic);
	MOVLW       _dirItem+0
	MOVWF       FARG_strcmp_s1+0 
	MOVLW       hi_addr(_dirItem+0)
	MOVWF       FARG_strcmp_s1+1 
	MOVF        FARG_Fat16_Assign_strFic+0, 0 
	MOVWF       FARG_strcmp_s2+0 
	MOVF        FARG_Fat16_Assign_strFic+1, 0 
	MOVWF       FARG_strcmp_s2+1 
	CALL        _strcmp+0, 0
;Fat16.c,428 :: 		if ( res == 0 )
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Assign125
	MOVLW       0
	XORWF       R0, 0 
L__Fat16_Assign125:
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Assign83
;Fat16.c,430 :: 		FileLength = dirItem.FileSize;
	MOVF        _dirItem+271, 0 
	MOVWF       _FileLength+0 
	MOVF        _dirItem+272, 0 
	MOVWF       _FileLength+1 
	MOVF        _dirItem+273, 0 
	MOVWF       _FileLength+2 
	MOVF        _dirItem+274, 0 
	MOVWF       _FileLength+3 
;Fat16.c,431 :: 		FilePos = 0;
	CLRF        _FilePos+0 
	CLRF        _FilePos+1 
	CLRF        _FilePos+2 
	CLRF        _FilePos+3 
;Fat16.c,432 :: 		FileClusterPos = 0;
	CLRF        _FileClusterPos+0 
	CLRF        _FileClusterPos+1 
;Fat16.c,433 :: 		FileCluster = dirItem.FirstCluster;
	MOVF        _dirItem+275, 0 
	MOVWF       _FileCluster+0 
	MOVF        _dirItem+276, 0 
	MOVWF       _FileCluster+1 
;Fat16.c,434 :: 		if ( FileCluster > 0 )
	MOVLW       0
	MOVWF       R0 
	MOVF        _dirItem+276, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Assign126
	MOVF        _dirItem+275, 0 
	SUBLW       0
L__Fat16_Assign126:
	BTFSC       STATUS+0, 0 
	GOTO        L_Fat16_Assign84
;Fat16.c,435 :: 		FileCluster--;
	MOVLW       1
	SUBWF       _FileCluster+0, 1 
	MOVLW       0
	SUBWFB      _FileCluster+1, 1 
L_Fat16_Assign84:
;Fat16.c,436 :: 		return FileLength;
	MOVF        _FileLength+0, 0 
	MOVWF       R0 
	MOVF        _FileLength+1, 0 
	MOVWF       R1 
	MOVF        _FileLength+2, 0 
	MOVWF       R2 
	MOVF        _FileLength+3, 0 
	MOVWF       R3 
	GOTO        L_end_Fat16_Assign
;Fat16.c,437 :: 		}
L_Fat16_Assign83:
;Fat16.c,438 :: 		bStatut = Fat16_FindNext();
	CALL        _Fat16_FindNext+0, 0
	MOVF        R0, 0 
	MOVWF       Fat16_Assign_bStatut_L0+0 
;Fat16.c,439 :: 		}
	GOTO        L_Fat16_Assign81
L_Fat16_Assign82:
;Fat16.c,441 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
	CLRF        R2 
	CLRF        R3 
;Fat16.c,443 :: 		}
L_end_Fat16_Assign:
	RETURN      0
; end of _Fat16_Assign

_Fat16_Read:

;Fat16.c,447 :: 		bool Fat16_Read(unsigned char * buff)
;Fat16.c,454 :: 		if ( FilePos >= FileLength )
	MOVF        _FileLength+3, 0 
	SUBWF       _FilePos+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read128
	MOVF        _FileLength+2, 0 
	SUBWF       _FilePos+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read128
	MOVF        _FileLength+1, 0 
	SUBWF       _FilePos+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read128
	MOVF        _FileLength+0, 0 
	SUBWF       _FilePos+0, 0 
L__Fat16_Read128:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_Read85
;Fat16.c,455 :: 		return false;
	CLRF        R0 
	GOTO        L_end_Fat16_Read
L_Fat16_Read85:
;Fat16.c,457 :: 		DesiredSector = FileCluster * SectorsPerCluster;
	MOVF        _FileCluster+0, 0 
	MOVWF       R0 
	MOVF        _FileCluster+1, 0 
	MOVWF       R1 
	MOVLW       0
	MOVWF       R2 
	MOVWF       R3 
	MOVF        _SectorsPerCluster+0, 0 
	MOVWF       R4 
	MOVF        _SectorsPerCluster+1, 0 
	MOVWF       R5 
	MOVF        _SectorsPerCluster+2, 0 
	MOVWF       R6 
	MOVF        _SectorsPerCluster+3, 0 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
;Fat16.c,458 :: 		DesiredSector = DesiredSector + FileClusterPos;
	MOVF        _FileClusterPos+0, 0 
	ADDWF       R0, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+0 
	MOVF        _FileClusterPos+1, 0 
	ADDWFC      R1, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+1 
	MOVLW       0
	ADDWFC      R2, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+2 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       FARG_Mmc_Read_Sector_sector+3 
;Fat16.c,459 :: 		DesiredSector = DesiredSector + FirstDirSector;
	MOVF        _FirstDirSector+0, 0 
	ADDWF       FARG_Mmc_Read_Sector_sector+0, 1 
	MOVF        _FirstDirSector+1, 0 
	ADDWFC      FARG_Mmc_Read_Sector_sector+1, 1 
	MOVF        _FirstDirSector+2, 0 
	ADDWFC      FARG_Mmc_Read_Sector_sector+2, 1 
	MOVF        _FirstDirSector+3, 0 
	ADDWFC      FARG_Mmc_Read_Sector_sector+3, 1 
;Fat16.c,461 :: 		error = Mmc_Read_Sector(DesiredSector, buff);
	MOVF        FARG_Fat16_Read_buff+0, 0 
	MOVWF       FARG_Mmc_Read_Sector_dbuff+0 
	MOVF        FARG_Fat16_Read_buff+1, 0 
	MOVWF       FARG_Mmc_Read_Sector_dbuff+1 
	CALL        _Mmc_Read_Sector+0, 0
;Fat16.c,462 :: 		if ( error == 1 )
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_Fat16_Read86
;Fat16.c,464 :: 		FilePos = FileLength;
	MOVF        _FileLength+0, 0 
	MOVWF       _FilePos+0 
	MOVF        _FileLength+1, 0 
	MOVWF       _FilePos+1 
	MOVF        _FileLength+2, 0 
	MOVWF       _FilePos+2 
	MOVF        _FileLength+3, 0 
	MOVWF       _FilePos+3 
;Fat16.c,465 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Fat16_Read
;Fat16.c,466 :: 		}
L_Fat16_Read86:
;Fat16.c,468 :: 		FilePos+=512;
	MOVLW       0
	ADDWF       _FilePos+0, 1 
	MOVLW       2
	ADDWFC      _FilePos+1, 1 
	MOVLW       0
	ADDWFC      _FilePos+2, 1 
	ADDWFC      _FilePos+3, 1 
;Fat16.c,470 :: 		FileClusterPos++;
	INFSNZ      _FileClusterPos+0, 1 
	INCF        _FileClusterPos+1, 1 
;Fat16.c,471 :: 		if ( FileClusterPos >= SectorsPerCluster )
	MOVF        _SectorsPerCluster+3, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read129
	MOVF        _SectorsPerCluster+2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read129
	MOVF        _SectorsPerCluster+1, 0 
	SUBWF       _FileClusterPos+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read129
	MOVF        _SectorsPerCluster+0, 0 
	SUBWF       _FileClusterPos+0, 0 
L__Fat16_Read129:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_Read87
;Fat16.c,473 :: 		FileClusterPos=0;
	CLRF        _FileClusterPos+0 
	CLRF        _FileClusterPos+1 
;Fat16.c,474 :: 		Fat16_ReadFatSector(FileCluster+1);
	MOVLW       1
	ADDWF       _FileCluster+0, 0 
	MOVWF       FARG_Fat16_ReadFatSector_Entry+0 
	MOVLW       0
	ADDWFC      _FileCluster+1, 0 
	MOVWF       FARG_Fat16_ReadFatSector_Entry+1 
	CALL        _Fat16_ReadFatSector+0, 0
;Fat16.c,475 :: 		ptrInt = &DataBuffer[OffsetFatBuffer];
	MOVLW       _DataBuffer+0
	ADDWF       _OffsetFatBuffer+0, 0 
	MOVWF       FSR0L 
	MOVLW       hi_addr(_DataBuffer+0)
	ADDWFC      _OffsetFatBuffer+1, 0 
	MOVWF       FSR0H 
;Fat16.c,476 :: 		FileCluster = *ptrInt;
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       _FileCluster+0 
	MOVF        R2, 0 
	MOVWF       _FileCluster+1 
;Fat16.c,477 :: 		if ( FileCluster >= 0xfff8 )
	MOVLW       255
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Fat16_Read130
	MOVLW       248
	SUBWF       R1, 0 
L__Fat16_Read130:
	BTFSS       STATUS+0, 0 
	GOTO        L_Fat16_Read88
;Fat16.c,479 :: 		FilePos = FileLength;
	MOVF        _FileLength+0, 0 
	MOVWF       _FilePos+0 
	MOVF        _FileLength+1, 0 
	MOVWF       _FilePos+1 
	MOVF        _FileLength+2, 0 
	MOVWF       _FilePos+2 
	MOVF        _FileLength+3, 0 
	MOVWF       _FilePos+3 
;Fat16.c,480 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_Fat16_Read
;Fat16.c,481 :: 		}
L_Fat16_Read88:
;Fat16.c,482 :: 		FileCluster--;
	MOVLW       1
	SUBWF       _FileCluster+0, 1 
	MOVLW       0
	SUBWFB      _FileCluster+1, 1 
;Fat16.c,483 :: 		}
L_Fat16_Read87:
;Fat16.c,485 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;Fat16.c,487 :: 		}
L_end_Fat16_Read:
	RETURN      0
; end of _Fat16_Read

Fat16____?ag:

L_end_Fat16___?ag:
	RETURN      0
; end of Fat16____?ag
