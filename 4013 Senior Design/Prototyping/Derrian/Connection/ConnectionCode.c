/* 
 * File:   ConnectionCode.c
 * Author: Derrian Glynn
 *
 * Created on October 17, 2015, 12:28 AM
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

/*int determine_omega_mode_active();
 As the 4 blades each have connectors on the outsides of them that when 
 * connected complete a circuit to initialize Omega Mode. The connectors send a 
 * high voltage signal to a pin which this function checks. When th function 
 * checks and finds the pin is high, it will send a value to the main program to 
 * say that the four blades are connected. 
 * 
 * If the pin ever goes low, the function will return a 0 to the main program to 
 * get the blades out of Omega Mode.
 */
int determine_omega_mode_active();



/*void connected();
 * By having one pin set high, when it connects to the other through the 
 connectors, it will output a voltage to turn on an LED on the other side of the
 PIC. Prototype
 */

void connected();




/*
 * 
 */
int main(int argc, char** argv) 
{
    while(1)
    {
        connected();
    }
    return (EXIT_SUCCESS);
}

void connected()
{
    /*if (pin is high)
     {
     output voltage to another pin to light LED
     
     
     }
     */


}
int determine_omega_mode_active()
{
    int omega;
    
    /*if (pin is high)
     *{
     * omega = 1
     * 
     * }
     else
     {
       omega = 0;
     }
     */
    
    return omega;


}