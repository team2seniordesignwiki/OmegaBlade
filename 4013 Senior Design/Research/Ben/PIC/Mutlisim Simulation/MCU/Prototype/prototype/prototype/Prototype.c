void main()
{
  TRISB=0X86;
  PORTB=0X06;
  while(1)
  { 
    PORTB=0XFF;
    __delay_ms(1000);
    PORTB=0X00;
    __delay_ms(1000);
  }
}