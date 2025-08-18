#ifndef __UART_H__
#define __UART_H__
#include "s3c24xx.h"

void uart0_init();

void send_byte(int c);


int receive_byte(void);


int putchar(int c);


int getchar();


int puts(const char *s);

#endif
