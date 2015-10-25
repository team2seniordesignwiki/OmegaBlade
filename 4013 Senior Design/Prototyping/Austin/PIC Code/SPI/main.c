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
    init_SPI();	
    while(1){
	//32-bit start frame
		SSPBUF = 0b00000000;
		SSPBUF = 0b00000000;
		SSPBUF = 0b00000000;
		SSPBUF = 0b00000000;
	
	//LED 1
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b11111111;//BLUE
		SSPBUF = 0b00000000;//GREEN
		SSPBUF = 0b00000000;//RED
	//LED 2
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b00111111;//BLUE
		SSPBUF = 0b00000011;//GREEN
		SSPBUF = 0b00000000;//RED	
	//LED 3
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b00001111;//BLUE
		SSPBUF = 0b00000111;//GREEN
		SSPBUF = 0b00000111;//RED	
	//LED 4
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b00000011;//BLUE
		SSPBUF = 0b00001111;//GREEN
		SSPBUF = 0b00001111;//RED	
	//LED 5
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b00000000;//BLUE
		SSPBUF = 0b00111111;//GREEN
		SSPBUF = 0b00011111;//RED	
	//LED 6
		SSPBUF = 0b11111111;//3 bit 111 and 5 bit global brightness
		SSPBUF = 0b00000000;//BLUE
		SSPBUF = 0b11111111;//GREEN
		SSPBUF = 0b00000011;//RED
	//32-bit end frame
		SSPBUF = 0b11111111;
		SSPBUF = 0b11111111;
		SSPBUF = 0b11111111;
		SSPBUF = 0b11111111;
    }
  
}

// Initialize TRISX registers and set oscillator frequency
void init_pic(){
    // Configure for 32MHz operation with internal oscillator
    OSCCON |= 0b11111000;
    
    // Set pin RB3 to output
    TRISBbits.TRISB7 = 0;
	TRISBbits.TRISB5 = 0;

    
    // Enable interrupts
    GIE = 1;
}

void init_SPI(){

//Clear SSP Enable to config
SSPEN = 0;
SSPCON = 0b00100010;
SCKSEL = 1; //Setting MSSP Serial Clock to RB7
SDOSEL = 1; //Setting MSSP Seruil Data Out to RB5
SDISEL = 1; //Setting MSSP Serial Data In to RB6 (not used though)
SSPEN = 1;

//Set SSP to enable SPI
	}