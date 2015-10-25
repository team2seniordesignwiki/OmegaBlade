int main()
{
    int i = 0;
    
    init_pic();
	
    init_ir();
    
    while(1)
    {
        __delay_ms(1000);
        PSMC4EN = 0;
        PSMC4PRH = 0xFF;
        PSMC4PRL = 0xFF;
        PSMC4EN = 1;
        
        __delay_ms(1000);
        PSMC4EN = 0;
        PSMC4PRH = 0x00;
        PSMC4PRL = 0x00;
        PSMC4EN = 1;
    }
}

void init_ir()
{   
    // Set period
    PSMC4PRH = 0x00;
    PSMC4PRL = 0x00;
    
    // Set duty cycle
    //PSMC4DCH = 0x80;
    //PSMC4DCL = 0x00;
    
    // No phase offset
    PSMC4PHH = 0;
    PSMC4PHL = 0;
    
    // PSMC clock = FOSC / 8 = 4 MHz
    PSMC4CLK = 0b00110000;
    
    // Output on A, normal polarity
    P4STRA  = 1;
    P4POLA = 0;
    P4OEA = 1;
    
    // Set time base as source for all events
    P4PRST = 1;
    P4PHST = 1;
    P4DCST = 1;
    
    // Enable PSMC in fixed duty cycle, variable frequency mode
    // and load steering and time buffers
    PSMC4CON = 0b11001010;
    
    // Enable pin driver
    TRISC3 = 0;
}