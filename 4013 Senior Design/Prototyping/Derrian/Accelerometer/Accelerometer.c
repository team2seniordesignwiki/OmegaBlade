/* 
 * File:   Accelerometer.c
 * Author: Derrian Glynn
 *
 * Created on October 17, 2015, 12:27 AM
 */

// CONFIG1
#pragma config FOSC = INTOSC    // Oscillator Selection (INTOSC oscillator: I/O function on CLKIN pin)
#pragma config WDTE = OFF       // Watchdog Timer Enable (WDT disabled)
#pragma config PWRTE = OFF      // Power-up Timer Enable (PWRT disabled)
#pragma config MCLRE = ON       // MCLR Pin Function Select (MCLR/VPP pin function is MCLR)
#pragma config CP = OFF         // Flash Program Memory Code Protection (Program memory code protection is disabled)
#pragma config CPD = OFF        // Data Memory Code Protection (Data memory code protection is disabled)
#pragma config BOREN = OFF      // Brown-out Reset Enable (Brown-out Reset enabled)
#pragma config CLKOUTEN = OFF   // Clock Out Enable (CLKOUT function is disabled. I/O or oscillator function on the CLKOUT pin)
#pragma config IESO = ON        // Internal/External Switchover (Internal/External Switchover mode is enabled)
#pragma config FCMEN = ON       // Fail-Safe Clock Monitor Enable (Fail-Safe Clock Monitor is enabled)

// CONFIG2
#pragma config WRT = OFF        // Flash Memory Self-Write Protection (Write protection off)
#pragma config VCAPEN = OFF     // Voltage Regulator Capacitor Enable bit (Vcap functionality is disabled on RA6.)
#pragma config PLLEN = OFF      // PLL Enable (4x PLL enabled)
#pragma config STVREN = ON      // Stack Overflow/Underflow Reset Enable (Stack Overflow or Underflow will cause a Reset)
#pragma config BORV = LO        // Brown-out Reset Voltage Selection (Brown-out Reset Voltage (Vbor), low trip point selected.)
#pragma config LPBOR = OFF      // Low Power Brown-Out Reset Enable Bit (Low power brown-out is disabled)
#pragma config LVP = OFF        // Low-Voltage Programming Enable (Low-voltage programming enabled)

#include <stdio.h>
#include <stdlib.h>

/* char ir_packets();
 When each of the blades are swung, this program will send a character array to 
 tell the main program what IR packets to send out from the IR LEDS
 
 Alpha: 2 Damage Packets
 Beta: 10 Stun Packets
 Gamma: 15 Damage Packets
 Delta: 5 Damage Packets and 5 Stun Packets
 Omega: 22 Damage Packets and 15 Stun Packets
 */

char *ir_packets(int, int);

//For Prototyping
/*int light_up_if_swung()
 * This function will output a high signal to a pin to light up a attached LED 
 * for a period of time when the section has been swung. 
 * Prototype function
 * 
 *  */

void light_up_if_swung();

/* int determine_sword_was_swung();
 * By taking in readings from the accelerometer, if the voltage reading from it
 * is past a certain voltage value, it will send a signal to the main program to 
 * activate the other elements of the program. The voltage value varies from 
 * blade to blade.
 * 
 * It will check for the value whenever called.
 
 
 */
int determine_sword_was_swung();


/*
 * 
 */
int main(int argc, char** argv) 
{
    while (1)
    {
        light_up_if_swung();
    }
    
    
    return (EXIT_SUCCESS);
}

int determine_sword_was_swung()
{
    int swung = 0;
    //Read from pin
    
    //if ( pin >= voltage reading)
    /*{
        swung = 1;
    }
     
     */
    
    return swung;

}
char *ir_packets(int swung, int omega)
{
    char *a ;
    // Sending a character to the main based off of the sword when swung.
    /*if (swung != 0)
     {
        //for alpha
           Alpha: 2 Damage Packets

    
        //for beta
           Beta: 10 Stun Packets
       
     
        // for Gamma  
           Gamma: 15 Damage Packets
    
    
     
        //for delta
            Delta: 5 Damage Packets and 5 Stun Packets
     
     
        // for Omega (on Delta)
           Omega: 22 Damage Packets and 15 Stun Packets 
    
     }
     */

    return a;
}

void light_up_if_swung()
{
    /*if (accelerometer is moved)
     {
        output 3 volts from a pin to a LED
     for(int i=0; i<200000; i++ )
     {
     output 3 volts for the loop
     } 
      
     }
     */


}