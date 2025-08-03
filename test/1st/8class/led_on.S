.test
.global _start

_start:
    ldr r1, =0x56000050
    ldr r0, =0x100
    str r0, [r1]

    ldr r1, =0x56000054
    ldr r0, =0
    srt r0, [r1]

hatl:
    b hatl
