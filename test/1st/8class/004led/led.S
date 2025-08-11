	.arch armv4t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 18, 4
	.file	"led.c"
	.text
	.align	2
	.global	delay
	.type	delay, %function
delay:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
.L2:
	ldr	r2, [fp, #-8]
	cmp	r2, #0
	moveq	r3, #0
	movne	r3, #1
	and	r1, r3, #255
	sub	r3, r2, #1
	str	r3, [fp, #-8]
	cmp	r1, #0
	bne	.L2
	add	sp, fp, #0
	ldmfd	sp!, {fp}
	bx	lr
	.size	delay, .-delay
	.align	2
	.global	led_on
	.type	led_on, %function
led_on:
	@ Function supports interworking.
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #20
	str	r0, [fp, #-16]
	mov	r3, #1442840576
	add	r3, r3, #80
	str	r3, [fp, #-12]
	mov	r3, #1442840576
	add	r3, r3, #84
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-16]
	cmp	r3, #4
	bne	.L5
	ldr	r2, [fp, #-12]
	mov	r3, #256
	str	r3, [r2, #0]
	b	.L6
.L5:
	ldr	r3, [fp, #-16]
	cmp	r3, #5
	bne	.L6
	ldr	r2, [fp, #-12]
	mov	r3, #1024
	str	r3, [r2, #0]
.L6:
	ldr	r2, [fp, #-8]
	mov	r3, #0
	str	r3, [r2, #0]
	mov	r3, #0
	mov	r0, r3
	add	sp, fp, #0
	ldmfd	sp!, {fp}
	bx	lr
	.size	led_on, .-led_on
	.ident	"GCC: (Sourcery G++ Lite 2008q3-72) 4.3.2"
	.section	.note.GNU-stack,"",%progbits
