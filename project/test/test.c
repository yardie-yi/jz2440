#include "s3c24xx.h"
#include "uart.h"
int main(void)
{
    unsigned char c;
    uart0_init();
    puts("hello word!\n\r");

    while(1)
    {
        c = getchar();
        if (c == "\r")
        {
            putchar("\n");
        }
        if (c == "\n")
        {
            putchar("\r");
        }
        putchar(c);
    }
    
    return 0;
}


