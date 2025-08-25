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

void printf(const char *fmt, ...)
{
    va_list ap;
    va_start(ap, fmt);

    while(*fmt)
    {
        if (*fmt = '%'){
            fmt++;
            switch(*fmt){
                case 's':
                    break;
                case 'd':
                    break;
                case 'x':
                    break;
                case 'c':
                    break;
                case '%':
                    break;
                default:
                    break;
            }
        }
        else{
            //put char str
        }
        fmt++;
    }

    va_end(ap);

}