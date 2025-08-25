#ifndef __UART_H__
#define __UART_H__
#include "s3c24xx.h"


// ================== 可变参数支持 ==================
typedef char* va_list;

// 下面这段代码是对C语言可变参数（varargs）机制的简单实现，通常用于实现类似printf这样的函数。
// va_list被定义为char*，用于指向参数列表中的当前位置。

// _VA_ALIGN(type)用于计算类型type在栈上的对齐大小，保证每次取参数时都能正确对齐。
// 例如，如果type是int且int为4字节，则对齐后还是4字节；如果type是double且int为4字节，则对齐后是8字节。
#define _VA_ALIGN(type)    (((sizeof(type) + sizeof(int) - 1) / sizeof(int)) * sizeof(int))

// va_start宏初始化ap，使其指向可变参数列表的第一个参数。
// &last是最后一个已知参数的地址，加上对齐后就指向第一个可变参数。
#define va_start(ap, last) (ap = (va_list)&last + _VA_ALIGN(last))

// va_arg宏用于获取参数列表中的下一个参数。
// ap先向后移动一个type类型的对齐长度，然后返回该位置的type类型的值。
#define va_arg(ap, type)   (*(type*)((ap += _VA_ALIGN(type)) - _VA_ALIGN(type)))

// va_end宏用于结束可变参数的获取，将ap置为0，表示不再使用。
#define va_end(ap)         (ap = (va_list)0)


void uart0_init();

void send_byte(int c);


int receive_byte(void);


int putchar(int c);


int getchar();


int puts(const char *s);

#endif
