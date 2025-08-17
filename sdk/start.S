.text
.global _start

_start:
    /*关看门狗*/
    ldr r0, =0x53000000
    mov r1, #0
    str r1, [r0]

    /* set clock */
    /* 1 set LOCKTIME */
    ldr r0, =0x4C000000
    ldr r1, =0xFFFFFFFF
    str r1, [r0]

    /* 2 set CLKDIVN*/
    ldr r0, =0x4C000014
    ldr r1, =0x5
    str r1, [r0]

    /* 3 set asynchronous */
    mrc p15,0,r0,c1,c0,0
    orr r0,r0,#0xc0000000   //R1_nF:OR:R1_iA
    mcr p15,0,r0,c1,c0,0

    /* 4 set mpll */
    ldr r0, =0x4C000004
    ldr r1, =(92<<12) | (1 << 4) | (1 << 0)
    str r1, [r0]

    /* 自动识别nor or nand 启动 */
    mov r1, #0
    ldr r0, [r1]
    str r1, [r1]
    ldr r2, [r1]
    cmp r1, r2
    ldr sp, =0x40000000+4096 //nor
    moveq sp, #4096
    streq r0, [r1]
    

    bl main

halt:
    b halt

