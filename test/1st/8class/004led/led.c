void delay(volatile int d)
{
    while (d--);
}


int led_on(int which)
{
    
    unsigned int *pGPFCON = (unsigned int *)0x56000050;
    unsigned int *pGPFDAT = (unsigned int *)0x56000054;
    if (which == 4)
    {
        *pGPFCON = 0x100;
    }
    else if (which == 5)
    {
        *pGPFCON = 0x400;
    }
    *pGPFDAT = 0;
    return 0;
}


