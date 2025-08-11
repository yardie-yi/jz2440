.text
.global _start

_start:
    /*关看门狗*/
    ldr r0, =0x53000000
    mov r1, #0
    str r1, [r0]

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

