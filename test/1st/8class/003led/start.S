.text
.global _start

_start:
    ldr sp, =4096 //nand
    //ldr sp, =0x400000000+4096 //nor

    bl main

halt:
    b halt

