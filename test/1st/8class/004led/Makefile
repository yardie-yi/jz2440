all:
	arm-linux-gcc -S led.c -o led.S
	arm-linux-gcc -c led.S -o led.o
	arm-linux-gcc -c start.S -o start.o
	arm-linux-ld -Ttext 0 start.o led.o -o led.elf
	arm-linux-objcopy -O binary -S led.elf led.bin
	arm-linux-objdump -D led.elf > led.dis

clean:
	rm *.bin *.o *.elf
