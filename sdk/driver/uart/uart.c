#include "uart.h"

void uart0_init()
{
    //set goio to uart
    GPHCON &= ((2 << 4) | (2 << 6));
    GPHCON |= ((2 << 4) | (2 << 6));

    GPHUP &= ((1 << 2) | (1 << 3));

    //set bound rete
    UCON0 = 0x00000005;
    UBRDIV0 = 26;

    //set data type
    ULCON0 = 0X00000003;



}

void send_byte(int c)
{
    while(!(UTRSTAT0 & (1 << 2)));
    UTXH0 = (unsigned char)c;
}

int receive_byte(void)
{
    while(!(UTRSTAT0 & (1 << 0)));
    return URXH0;
}

int putchar(int c)
{
    send_byte(c);
    return c;
}

int getchar()
{
    return receive_byte();
}

int puts(const char *s)
{
    while(*s != '\0')
    {
        putchar(*s);
        s++;
    }
    return 0;
}
