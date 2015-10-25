//enable global interrupts and also enable interrupt on change
INTCON = INTCON || 136; //8bit binary: 10001000
//set port A, pin 4 to look for rising edges to interrupt
IOCAP = IOCAP || 16; //8bit binary: 00010000

//set timer prescaler, based on clock speed, so it won't overflow. 
?????

//set constant TIMEOUT, = 2.6785ms, in terms of clock cycles / prescale
TIMEOUT = ????

//set boolean stop variable to know when to timeout
bool stop = false

void interrupt() //begin ISR
{
    //reset timer
    ???? = 0;
    
    while(PORTAbits.RA4 && !stop) //wait until the start bursts end
    {
        if(???? >= TIMEOUT) stop=true;
    }
    
    if(!stop)
    {
        //reset timer
        ???? = 0;
        
        while(!PORTAbits.RA4 && !stop) //wait until the first data bursts starts
        {
            if(???? >= TIMEOUT) stop=true;
        }
    }
    
    if(!stop)
    {
        //reset timer
        ???? = 0;
        
        while(PORTAbits.RA4 && !stop) //wait until the first data bursts end
        {
            if(???? >= TIMEOUT) stop=true;
        }
        //record the length of the first data bursts in number of cycles
        D1cycles = ????
    }
    
    if(!stop)
    {
        //reset timer
        ???? = 0;
        
        while(!PORTAbits.RA4 && !stop) //wait until the redundant data bursts starts
        {
            if(???? >= TIMEOUT) stop=true;
        }
    }
    
    if(!stop)
    {
        //reset timer
        ???? = 0;
        
        while(PORTAbits.RA4 && !stop) //wait until the redundant data bursts end
        {
            if(???? >= TIMEOUT) stop=true;
        }
        //record the length of the redundant data bursts in number of cycles
        D2cycles = ????
    }
    
    //now both lengths have been recorded, assuming no timeouts have occurred
    //check to see if the two data lengths are reasonably close to each other in length
    if (!stop)
    {
        if(D1cycles > D2cycles * 1.1 || D2cycles > D1cycles * 1.1) stop=true; //if the two lengths are not within 10% of each other, discard
    }
    
    if(!stop)
    {
        //if this point has been reached, the two data lengths have been recovered successfully. Average the two lengths. 
        Davgcycles = (D1cycles + D2cycles) / 2;
        numPackets = Davgcycles * ????? //Convert the average lengths of the data bursts in clock cyles into number of on-pulses, knowing that each pulse lasts 17.8us and the program frequency is ____
        
        if(numPackets >= 15 && numPackets < 25) HealthPoints-- //damage received! Decrement HP!
        else if(numPackets >= 25 && numPackets < 35) HealthPoints++ //heal received! Increment HP!
        else if(numPackets >= 35 && numPackets < 45) stunCount++ //stun received! Increment counter for length of stun in main loop!
        else stop=true; //unknown data received, discard it!
        
        
    }
}