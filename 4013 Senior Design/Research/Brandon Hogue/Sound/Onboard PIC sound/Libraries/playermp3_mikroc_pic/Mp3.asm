
_MP3_Init:

;Mp3.c,227 :: 		void MP3_Init()
;Mp3.c,230 :: 		DCLK_Direction  = 0;
	BCF         TRISH3_bit+0, 3 
;Mp3.c,231 :: 		SDATA_Direction = 0;
	BCF         TRISD2_bit+0, 2 
;Mp3.c,232 :: 		DCLK  = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,233 :: 		SDATA = 0;
	BCF         LATD2_bit+0, 2 
;Mp3.c,235 :: 		MP3_CS_Direction  = 0;
	BCF         TRISB4_bit+0, 4 
;Mp3.c,236 :: 		MP3_CS            = 1;
	BSF         LATB4_bit+0, 4 
;Mp3.c,237 :: 		MP3_RST_Direction = 0;
	BCF         TRISH0_bit+0, 0 
;Mp3.c,238 :: 		MP3_RST           = 1;
	BSF         LATH0_bit+0, 0 
;Mp3.c,240 :: 		DREQ_Direction  = 1;
	BSF         TRISH7_bit+0, 7 
;Mp3.c,241 :: 		BSYNC_Direction = 0;
	BCF         TRISB5_bit+0, 5 
;Mp3.c,242 :: 		BSYNC           = 0;
	BCF         LATB5_bit+0, 5 
;Mp3.c,244 :: 		}
L_end_MP3_Init:
	RETURN      0
; end of _MP3_Init

_MP3_LoadSpectrumPlugin:

;Mp3.c,248 :: 		void MP3_LoadSpectrumPlugin()
;Mp3.c,252 :: 		for (i=0;i<CODE_SIZE;i++)
	CLRF        MP3_LoadSpectrumPlugin_i_L0+0 
	CLRF        MP3_LoadSpectrumPlugin_i_L0+1 
L_MP3_LoadSpectrumPlugin0:
	MOVLW       128
	XORWF       MP3_LoadSpectrumPlugin_i_L0+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       3
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__MP3_LoadSpectrumPlugin30
	MOVLW       212
	SUBWF       MP3_LoadSpectrumPlugin_i_L0+0, 0 
L__MP3_LoadSpectrumPlugin30:
	BTFSC       STATUS+0, 0 
	GOTO        L_MP3_LoadSpectrumPlugin1
;Mp3.c,254 :: 		MP3_SCI_Write(atab[i], dtab[i]);
	MOVLW       _atab+0
	ADDWF       MP3_LoadSpectrumPlugin_i_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_atab+0)
	ADDWFC      MP3_LoadSpectrumPlugin_i_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_atab+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	BTFSC       MP3_LoadSpectrumPlugin_i_L0+1, 7 
	MOVLW       255
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_MP3_SCI_Write_address+0
	MOVF        MP3_LoadSpectrumPlugin_i_L0+0, 0 
	MOVWF       R0 
	MOVF        MP3_LoadSpectrumPlugin_i_L0+1, 0 
	MOVWF       R1 
	MOVLW       0
	BTFSC       MP3_LoadSpectrumPlugin_i_L0+1, 7 
	MOVLW       255
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVLW       _dtab+0
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_dtab+0)
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_dtab+0)
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_MP3_SCI_Write_data_in+0
	TBLRD*+
	MOVFF       TABLAT+0, FARG_MP3_SCI_Write_data_in+1
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,252 :: 		for (i=0;i<CODE_SIZE;i++)
	INFSNZ      MP3_LoadSpectrumPlugin_i_L0+0, 1 
	INCF        MP3_LoadSpectrumPlugin_i_L0+1, 1 
;Mp3.c,255 :: 		}
	GOTO        L_MP3_LoadSpectrumPlugin0
L_MP3_LoadSpectrumPlugin1:
;Mp3.c,256 :: 		MP3_SCI_Write(0x07, 0x1381);
	MOVLW       7
	MOVWF       FARG_MP3_SCI_Write_address+0 
	MOVLW       129
	MOVWF       FARG_MP3_SCI_Write_data_in+0 
	MOVLW       19
	MOVWF       FARG_MP3_SCI_Write_data_in+1 
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,257 :: 		MP3_SCI_Write(0x06, 0);
	MOVLW       6
	MOVWF       FARG_MP3_SCI_Write_address+0 
	CLRF        FARG_MP3_SCI_Write_data_in+0 
	CLRF        FARG_MP3_SCI_Write_data_in+1 
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,258 :: 		}
L_end_MP3_LoadSpectrumPlugin:
	RETURN      0
; end of _MP3_LoadSpectrumPlugin

_MP3_Soft_Reset:

;Mp3.c,263 :: 		void MP3_Soft_Reset(char fill_zeros)
;Mp3.c,268 :: 		MP3_SCI_Write(MODE_ADDR,0x0204);
	CLRF        FARG_MP3_SCI_Write_address+0 
	MOVLW       4
	MOVWF       FARG_MP3_SCI_Write_data_in+0 
	MOVLW       2
	MOVWF       FARG_MP3_SCI_Write_data_in+1 
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,270 :: 		Delay_us(2);
	MOVLW       7
	MOVWF       R13, 0
L_MP3_Soft_Reset3:
	DECFSZ      R13, 1, 1
	BRA         L_MP3_Soft_Reset3
	NOP
	NOP
;Mp3.c,271 :: 		while (DREQ == 0);
L_MP3_Soft_Reset4:
	BTFSC       RH7_bit+0, 7 
	GOTO        L_MP3_Soft_Reset5
	GOTO        L_MP3_Soft_Reset4
L_MP3_Soft_Reset5:
;Mp3.c,272 :: 		if (fill_zeros)
	MOVF        FARG_MP3_Soft_Reset_fill_zeros+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_MP3_Soft_Reset6
;Mp3.c,274 :: 		for (i=0; i<32; i++)
	CLRF        MP3_Soft_Reset_i_L0+0 
L_MP3_Soft_Reset7:
	MOVLW       32
	SUBWF       MP3_Soft_Reset_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MP3_Soft_Reset8
;Mp3.c,276 :: 		data_buffer_32[i] = 0;
	MOVLW       _data_buffer_32+0
	MOVWF       FSR1L 
	MOVLW       hi_addr(_data_buffer_32+0)
	MOVWF       FSR1H 
	MOVF        MP3_Soft_Reset_i_L0+0, 0 
	ADDWF       FSR1L, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Mp3.c,274 :: 		for (i=0; i<32; i++)
	INCF        MP3_Soft_Reset_i_L0+0, 1 
;Mp3.c,277 :: 		}
	GOTO        L_MP3_Soft_Reset7
L_MP3_Soft_Reset8:
;Mp3.c,278 :: 		for (i=0; i < 2048/32; i++)
	CLRF        MP3_Soft_Reset_i_L0+0 
L_MP3_Soft_Reset10:
	MOVLW       64
	SUBWF       MP3_Soft_Reset_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MP3_Soft_Reset11
;Mp3.c,280 :: 		MP3_SDI_Write_32(data_buffer_32);
	MOVLW       _data_buffer_32+0
	MOVWF       FARG_MP3_SDI_Write_32_data_+0 
	MOVLW       hi_addr(_data_buffer_32+0)
	MOVWF       FARG_MP3_SDI_Write_32_data_+1 
	CALL        _MP3_SDI_Write_32+0, 0
;Mp3.c,278 :: 		for (i=0; i < 2048/32; i++)
	INCF        MP3_Soft_Reset_i_L0+0, 1 
;Mp3.c,281 :: 		}
	GOTO        L_MP3_Soft_Reset10
L_MP3_Soft_Reset11:
;Mp3.c,282 :: 		}
	GOTO        L_MP3_Soft_Reset13
L_MP3_Soft_Reset6:
;Mp3.c,284 :: 		MP3_SDI_Write(0);
	CLRF        FARG_MP3_SDI_Write_data_+0 
	CALL        _MP3_SDI_Write+0, 0
L_MP3_Soft_Reset13:
;Mp3.c,286 :: 		}
L_end_MP3_Soft_Reset:
	RETURN      0
; end of _MP3_Soft_Reset

_MP3_Set_Clock:

;Mp3.c,290 :: 		void MP3_Set_Clock(unsigned int clock_khz, char doubler)
;Mp3.c,293 :: 		clock_khz /= 2;
	RRCF        FARG_MP3_Set_Clock_clock_khz+1, 1 
	RRCF        FARG_MP3_Set_Clock_clock_khz+0, 1 
	BCF         FARG_MP3_Set_Clock_clock_khz+1, 7 
;Mp3.c,294 :: 		if (doubler)
	MOVF        FARG_MP3_Set_Clock_doubler+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_MP3_Set_Clock14
;Mp3.c,296 :: 		clock_khz |= 0x8000;
	BSF         FARG_MP3_Set_Clock_clock_khz+1, 7 
;Mp3.c,297 :: 		}
L_MP3_Set_Clock14:
;Mp3.c,298 :: 		MP3_SCI_Write(CLOCKF_ADDR, clock_khz);
	MOVLW       3
	MOVWF       FARG_MP3_SCI_Write_address+0 
	MOVF        FARG_MP3_Set_Clock_clock_khz+0, 0 
	MOVWF       FARG_MP3_SCI_Write_data_in+0 
	MOVF        FARG_MP3_Set_Clock_clock_khz+1, 0 
	MOVWF       FARG_MP3_SCI_Write_data_in+1 
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,300 :: 		}
L_end_MP3_Set_Clock:
	RETURN      0
; end of _MP3_Set_Clock

_MP3_Set_Volume:

;Mp3.c,304 :: 		void MP3_Set_Volume(char left,char right)
;Mp3.c,309 :: 		volume = (left<<8) + right;
	MOVF        FARG_MP3_Set_Volume_left+0, 0 
	MOVWF       FARG_MP3_SCI_Write_data_in+1 
	CLRF        FARG_MP3_SCI_Write_data_in+0 
	MOVF        FARG_MP3_Set_Volume_right+0, 0 
	ADDWF       FARG_MP3_SCI_Write_data_in+0, 1 
	MOVLW       0
	ADDWFC      FARG_MP3_SCI_Write_data_in+1, 1 
;Mp3.c,310 :: 		MP3_SCI_Write(VOL_ADDR, volume);
	MOVLW       11
	MOVWF       FARG_MP3_SCI_Write_address+0 
	CALL        _MP3_SCI_Write+0, 0
;Mp3.c,312 :: 		}
L_end_MP3_Set_Volume:
	RETURN      0
; end of _MP3_Set_Volume

_MP3_Reset:

;Mp3.c,316 :: 		void MP3_Reset(char volume)
;Mp3.c,318 :: 		MP3_Soft_Reset(0);
	CLRF        FARG_MP3_Soft_Reset_fill_zeros+0 
	CALL        _MP3_Soft_Reset+0, 0
;Mp3.c,319 :: 		MP3_Set_Clock(25000,0);
	MOVLW       168
	MOVWF       FARG_MP3_Set_Clock_clock_khz+0 
	MOVLW       97
	MOVWF       FARG_MP3_Set_Clock_clock_khz+1 
	CLRF        FARG_MP3_Set_Clock_doubler+0 
	CALL        _MP3_Set_Clock+0, 0
;Mp3.c,320 :: 		MP3_Set_Volume(volume,volume);
	MOVF        FARG_MP3_Reset_volume+0, 0 
	MOVWF       FARG_MP3_Set_Volume_left+0 
	MOVF        FARG_MP3_Reset_volume+0, 0 
	MOVWF       FARG_MP3_Set_Volume_right+0 
	CALL        _MP3_Set_Volume+0, 0
;Mp3.c,321 :: 		MP3_LoadSpectrumPlugin();
	CALL        _MP3_LoadSpectrumPlugin+0, 0
;Mp3.c,323 :: 		}
L_end_MP3_Reset:
	RETURN      0
; end of _MP3_Reset

_SW_SPI_Write:

;Mp3.c,327 :: 		void SW_SPI_Write(char data_)
;Mp3.c,329 :: 		BSYNC = 1;
	BSF         LATB5_bit+0, 5 
;Mp3.c,331 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,332 :: 		SDATA = data_;
	BTFSC       FARG_SW_SPI_Write_data_+0, 0 
	GOTO        L__SW_SPI_Write36
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write37
L__SW_SPI_Write36:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write37:
;Mp3.c,333 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,334 :: 		data_ >>= 1;
	MOVF        FARG_SW_SPI_Write_data_+0, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,336 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,337 :: 		SDATA = data_;
	BTFSC       R1, 0 
	GOTO        L__SW_SPI_Write38
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write39
L__SW_SPI_Write38:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write39:
;Mp3.c,338 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,339 :: 		data_ >>= 1;
	MOVF        R1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,341 :: 		BSYNC = 0;
	BCF         LATB5_bit+0, 5 
;Mp3.c,343 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,344 :: 		SDATA = data_;
	BTFSC       R2, 0 
	GOTO        L__SW_SPI_Write40
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write41
L__SW_SPI_Write40:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write41:
;Mp3.c,345 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,346 :: 		data_ >>= 1;
	MOVF        R2, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,348 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,349 :: 		SDATA = data_;
	BTFSC       R1, 0 
	GOTO        L__SW_SPI_Write42
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write43
L__SW_SPI_Write42:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write43:
;Mp3.c,350 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,351 :: 		data_ >>= 1;
	MOVF        R1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,353 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,354 :: 		SDATA = data_;
	BTFSC       R2, 0 
	GOTO        L__SW_SPI_Write44
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write45
L__SW_SPI_Write44:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write45:
;Mp3.c,355 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,356 :: 		data_ >>= 1;
	MOVF        R2, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,358 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,359 :: 		SDATA = data_;
	BTFSC       R1, 0 
	GOTO        L__SW_SPI_Write46
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write47
L__SW_SPI_Write46:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write47:
;Mp3.c,360 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,361 :: 		data_ >>= 1;
	MOVF        R1, 0 
	MOVWF       R2 
	RRCF        R2, 1 
	BCF         R2, 7 
	MOVF        R2, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,363 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,364 :: 		SDATA = data_;
	BTFSC       R2, 0 
	GOTO        L__SW_SPI_Write48
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write49
L__SW_SPI_Write48:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write49:
;Mp3.c,365 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,366 :: 		data_ >>= 1;
	MOVF        R2, 0 
	MOVWF       R1 
	RRCF        R1, 1 
	BCF         R1, 7 
	MOVF        R1, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
;Mp3.c,368 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,369 :: 		SDATA = data_;
	BTFSC       R1, 0 
	GOTO        L__SW_SPI_Write50
	BCF         LATD2_bit+0, 2 
	GOTO        L__SW_SPI_Write51
L__SW_SPI_Write50:
	BSF         LATD2_bit+0, 2 
L__SW_SPI_Write51:
;Mp3.c,370 :: 		DCLK = 1;
	BSF         LATH3_bit+0, 3 
;Mp3.c,371 :: 		data_ >>= 1;
	MOVF        R1, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
	RRCF        FARG_SW_SPI_Write_data_+0, 1 
	BCF         FARG_SW_SPI_Write_data_+0, 7 
;Mp3.c,373 :: 		DCLK = 0;
	BCF         LATH3_bit+0, 3 
;Mp3.c,374 :: 		}
L_end_SW_SPI_Write:
	RETURN      0
; end of _SW_SPI_Write

_MP3_SCI_Write:

;Mp3.c,378 :: 		void MP3_SCI_Write(char address, unsigned int data_in)
;Mp3.c,381 :: 		MP3_CS = 0;
	BCF         LATB4_bit+0, 4 
;Mp3.c,382 :: 		SPI1_Write(WRITE_CODE);
	MOVLW       2
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,383 :: 		SPI1_Write(address);
	MOVF        FARG_MP3_SCI_Write_address+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,384 :: 		SPI1_Write(Hi(data_in));
	MOVF        FARG_MP3_SCI_Write_data_in+1, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,385 :: 		SPI1_Write(Lo(data_in));
	MOVF        FARG_MP3_SCI_Write_data_in+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,386 :: 		MP3_CS = 1;
	BSF         LATB4_bit+0, 4 
;Mp3.c,388 :: 		while (DREQ == 0);
L_MP3_SCI_Write15:
	BTFSC       RH7_bit+0, 7 
	GOTO        L_MP3_SCI_Write16
	GOTO        L_MP3_SCI_Write15
L_MP3_SCI_Write16:
;Mp3.c,390 :: 		}
L_end_MP3_SCI_Write:
	RETURN      0
; end of _MP3_SCI_Write

_MP3_SCI_Read:

;Mp3.c,394 :: 		void MP3_SCI_Read(char start_address, char words_count, unsigned int *data_buffer)
;Mp3.c,399 :: 		MP3_CS = 0;
	BCF         LATB4_bit+0, 4 
;Mp3.c,401 :: 		SPI1_Write(READ_CODE);
	MOVLW       3
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,402 :: 		SPI1_Write(start_address);
	MOVF        FARG_MP3_SCI_Read_start_address+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;Mp3.c,404 :: 		while (words_count--)
L_MP3_SCI_Read17:
	MOVF        FARG_MP3_SCI_Read_words_count+0, 0 
	MOVWF       R0 
	DECF        FARG_MP3_SCI_Read_words_count+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_MP3_SCI_Read18
;Mp3.c,406 :: 		temp = SPI1_Read(0);
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       MP3_SCI_Read_temp_L0+0 
	MOVLW       0
	MOVWF       MP3_SCI_Read_temp_L0+1 
;Mp3.c,407 :: 		temp <<= 8;
	MOVF        MP3_SCI_Read_temp_L0+0, 0 
	MOVWF       MP3_SCI_Read_temp_L0+1 
	CLRF        MP3_SCI_Read_temp_L0+0 
;Mp3.c,408 :: 		temp += SPI1_Read(0);
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVLW       0
	MOVWF       R1 
	MOVF        MP3_SCI_Read_temp_L0+0, 0 
	ADDWF       R0, 1 
	MOVF        MP3_SCI_Read_temp_L0+1, 0 
	ADDWFC      R1, 1 
	MOVF        R0, 0 
	MOVWF       MP3_SCI_Read_temp_L0+0 
	MOVF        R1, 0 
	MOVWF       MP3_SCI_Read_temp_L0+1 
;Mp3.c,409 :: 		*(data_buffer++) = temp;
	MOVFF       FARG_MP3_SCI_Read_data_buffer+0, FSR1L
	MOVFF       FARG_MP3_SCI_Read_data_buffer+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVLW       2
	ADDWF       FARG_MP3_SCI_Read_data_buffer+0, 1 
	MOVLW       0
	ADDWFC      FARG_MP3_SCI_Read_data_buffer+1, 1 
;Mp3.c,410 :: 		}
	GOTO        L_MP3_SCI_Read17
L_MP3_SCI_Read18:
;Mp3.c,411 :: 		MP3_CS = 1;
	BSF         LATB4_bit+0, 4 
;Mp3.c,413 :: 		while (DREQ == 0);
L_MP3_SCI_Read19:
	BTFSC       RH7_bit+0, 7 
	GOTO        L_MP3_SCI_Read20
	GOTO        L_MP3_SCI_Read19
L_MP3_SCI_Read20:
;Mp3.c,415 :: 		}
L_end_MP3_SCI_Read:
	RETURN      0
; end of _MP3_SCI_Read

_MP3_SDI_Write:

;Mp3.c,419 :: 		void MP3_SDI_Write(char data_)
;Mp3.c,422 :: 		while (DREQ == 0);
L_MP3_SDI_Write21:
	BTFSC       RH7_bit+0, 7 
	GOTO        L_MP3_SDI_Write22
	GOTO        L_MP3_SDI_Write21
L_MP3_SDI_Write22:
;Mp3.c,423 :: 		SW_SPI_Write(data_);
	MOVF        FARG_MP3_SDI_Write_data_+0, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
	CALL        _SW_SPI_Write+0, 0
;Mp3.c,425 :: 		}
L_end_MP3_SDI_Write:
	RETURN      0
; end of _MP3_SDI_Write

_MP3_SDI_Write_32:

;Mp3.c,429 :: 		void MP3_SDI_Write_32(char *data_)
;Mp3.c,433 :: 		while (DREQ == 0);
L_MP3_SDI_Write_3223:
	BTFSC       RH7_bit+0, 7 
	GOTO        L_MP3_SDI_Write_3224
	GOTO        L_MP3_SDI_Write_3223
L_MP3_SDI_Write_3224:
;Mp3.c,435 :: 		for (i=0; i<32; i++)
	CLRF        MP3_SDI_Write_32_i_L0+0 
L_MP3_SDI_Write_3225:
	MOVLW       32
	SUBWF       MP3_SDI_Write_32_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_MP3_SDI_Write_3226
;Mp3.c,436 :: 		SW_SPI_Write(data_[i]);
	MOVF        MP3_SDI_Write_32_i_L0+0, 0 
	ADDWF       FARG_MP3_SDI_Write_32_data_+0, 0 
	MOVWF       FSR0L 
	MOVLW       0
	ADDWFC      FARG_MP3_SDI_Write_32_data_+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_SW_SPI_Write_data_+0 
	CALL        _SW_SPI_Write+0, 0
;Mp3.c,435 :: 		for (i=0; i<32; i++)
	INCF        MP3_SDI_Write_32_i_L0+0, 1 
;Mp3.c,436 :: 		SW_SPI_Write(data_[i]);
	GOTO        L_MP3_SDI_Write_3225
L_MP3_SDI_Write_3226:
;Mp3.c,438 :: 		}
L_end_MP3_SDI_Write_32:
	RETURN      0
; end of _MP3_SDI_Write_32

_MP3_Read_Time:

;Mp3.c,442 :: 		void MP3_Read_Time(unsigned int* seconds)
;Mp3.c,444 :: 		MP3_SCI_Read(DECODE_TIME, 1, seconds);
	MOVLW       4
	MOVWF       FARG_MP3_SCI_Read_start_address+0 
	MOVLW       1
	MOVWF       FARG_MP3_SCI_Read_words_count+0 
	MOVF        FARG_MP3_Read_Time_seconds+0, 0 
	MOVWF       FARG_MP3_SCI_Read_data_buffer+0 
	MOVF        FARG_MP3_Read_Time_seconds+1, 0 
	MOVWF       FARG_MP3_SCI_Read_data_buffer+1 
	CALL        _MP3_SCI_Read+0, 0
;Mp3.c,445 :: 		}
L_end_MP3_Read_Time:
	RETURN      0
; end of _MP3_Read_Time

Mp3____?ag:

L_end_Mp3___?ag:
	RETURN      0
; end of Mp3____?ag
