all:
	arm-linux-gcc -c led_on.S -o led_on.o
	arm-linux-ld -Ttext 0 led_on.o -o led_on.elf
	arm-linux-objcopy -O binary -S led_on.elf led_on.bin

clean:
	rm *.bin *.o *.elf

