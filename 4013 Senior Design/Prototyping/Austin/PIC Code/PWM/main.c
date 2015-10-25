/*====================================================================================
File:   main_header.h
Author: bjesper

Created on October 12, 2015
====================================================================================*/
#define _XTAL_FREQ 32000000 
#include "main_header.h"
//void main_loop_individual();
//void main_loop_omega();

int main()
{
    init_pic();
    init_RGB();	
    while(1){
		//****************Turn full red
	
		//Changing Red DC to 100%
		PSMC2DCH  = 0xFF;//PSMC2 Duty Cycle High-byte
		PSMC2DCL  = 0xFF;//PSMC2 Duty Cycle Low-byte
		
		//Green to 0%
		PSMC3DCH  = 0x00;//PSMC3 Duty Cycle High-byte
		PSMC3DCL  = 0x00;//PSMC3 Duty Cycle Low-byte
		//Blue to 0%
		PSMC4DCH  = 0x00;//PSMC4 Duty Cycle High-byte
		PSMC4DCL  = 0x00;//PSMC4 Duty Cycle Low-byte
		
		//Set Load Bit to load duty cycle values
		PSMC2LD = 1; //PSMC 2 Load
		PSMC3LD = 1; //PSMC 3 Load
		PSMC4LD = 1; //PSMC 4 Load
		
		//wait 3 seconds
		__delay_ms(3000);
		
		//****************Turn full green
	
		//Changing Red DC to 100%
		PSMC2DCH  = 0x00;
		PSMC2DCL  = 0x00;
		
		//Green to 0%
		PSMC3DCH  = 0xFF;
		PSMC3DCL  = 0xFF;
		//Blue to 0%
		PSMC4DCH  = 0x00;
		PSMC4DCL  = 0x00;
		
		//Set Load Bit to load duty cycle values
		PSMC2LD = 1;
		PSMC3LD = 1;
		PSMC4LD = 1;
		
		//wait 3 seconds
		__delay_ms(3000);
		
		//****************Turn full blue
	
		//Changing Red DC to 100%
		PSMC2DCH  = 0x00;
		PSMC2DCL  = 0x00;
		
		//Green to 0%
		PSMC3DCH  = 0x00;
		PSMC3DCL  = 0x00;
		//Blue to 0%
		PSMC4DCH  = 0xFF;
		PSMC4DCL  = 0xFF;
		
		//Set Load Bit to load duty cycle values
		PSMC2LD = 1;
		PSMC3LD = 1;
		PSMC4LD = 1;
		
		//wait 3 seconds
		__delay_ms(3000);
    }
  
}

// Initialize TRISX registers and set oscillator frequency
void init_pic(){
    // Configure for 32MHz operation with internal oscillator
    OSCCON |= 0b11111000;
    
    // Set pin RB3 to output
    TRISCbits.TRISC4 = 0;
	TRISCbits.TRISC5 = 0;
    TRISCbits.TRISC6 = 0;
    
    // Enable interrupts
    GIE = 1;
}

void init_RGB(){

//RED
	PSMC2CON  = 0x00;
	PSMC2MDL  = 0x00;
	PSMC2SYNC = 0x00;
	PSMC2CLK  = 0x00;
	PSMC2POL  = 0x00;
	PSMC2BLNK = 0x00;
	PSMC2REBS = 0x00;
	PSMC2FEBS = 0x00;
	PSMC2PHS  = 0x01;
	PSMC2DCS  = 0x01;
	PSMC2PRS  = 0x01;
	PSMC2ASDC = 0x00;
	PSMC2ASDL = 0x01;
	PSMC2ASDS = 0x00;
	PSMC2PHH  = 0x00;
	PSMC2PHL  = 0x00;
	PSMC2DCH  = 0x01;
	PSMC2DCL  = 0xF4;
	PSMC2PRH  = 0x03;
	PSMC2PRL  = 0xE7;
	PSMC2DBR  = 0x00;
	PSMC2DBF  = 0x00;
	PSMC2FFA  = 0x00;
	PSMC2BLKR = 0x00;
	PSMC2BLKF = 0x00;
	PSMC2STR0 = 0x01;
	PSMC2STR1 = 0x00;
	PSMC2INT  = 0x00;
	PSMC2OEN  = 0x01;
	PSMC2CON  = 0x80;
	PIE4     &= 0xDD;
	PIE4     |= 0x00;
	
//GREEN
	PSMC3CON  = 0x00;
	PSMC3MDL  = 0x00;
	PSMC3SYNC = 0x02;
	PSMC3CLK  = 0x00;
	PSMC3POL  = 0x00;
	PSMC3BLNK = 0x00;
	PSMC3REBS = 0x00;
	PSMC3FEBS = 0x00;
	PSMC3PHS  = 0x01;
	PSMC3DCS  = 0x01;
	PSMC3PRS  = 0x01;
	PSMC3ASDC = 0x00;
	PSMC3ASDL = 0x01;
	PSMC3ASDS = 0x00;
	PSMC3PHH  = 0x00;
	PSMC3PHL  = 0x00;
	PSMC3DCH  = 0x01;
	PSMC3DCL  = 0xF4;
	PSMC3PRH  = 0x03;
	PSMC3PRL  = 0xE7;
	PSMC3DBR  = 0x00;
	PSMC3DBF  = 0x00;
	PSMC3FFA  = 0x00;
	PSMC3BLKR = 0x00;
	PSMC3BLKF = 0x00;
	PSMC3STR0 = 0x01;
	PSMC3STR1 = 0x00;
	PSMC3INT  = 0x00;
	PSMC3OEN  = 0x01;
	PSMC3CON  = 0x80;
	PIE4     &= 0xBB;
	PIE4     |= 0x00;

	
//BLUE
	PSMC4CON  = 0x00;
	PSMC4MDL  = 0x00;
	PSMC4SYNC = 0x02;
	PSMC4CLK  = 0x00;
	PSMC4POL  = 0x00;
	PSMC4BLNK = 0x00;
	PSMC4REBS = 0x00;
	PSMC4FEBS = 0x00;
	PSMC4PHS  = 0x01;
	PSMC4DCS  = 0x01;
	PSMC4PRS  = 0x01;
	PSMC4ASDC = 0x00;
	PSMC4ASDL = 0x02;
	PSMC4ASDS = 0x00;
	PSMC4PHH  = 0x00;
	PSMC4PHL  = 0x00;
	PSMC4DCH  = 0x01;
	PSMC4DCL  = 0xF4;
	PSMC4PRH  = 0x03;
	PSMC4PRL  = 0xE7;
	PSMC4DBR  = 0x00;
	PSMC4DBF  = 0x00;
	PSMC4FFA  = 0x00;
	PSMC4BLKR = 0x00;
	PSMC4BLKF = 0x00;
	PSMC4STR0 = 0x02;
	PSMC4STR1 = 0x00;
	PSMC4INT  = 0x00;
	PSMC4OEN  = 0x02;
	PSMC4CON  = 0x80;
	PIE4     &= 0x77;
	PIE4     |= 0x00;
	}