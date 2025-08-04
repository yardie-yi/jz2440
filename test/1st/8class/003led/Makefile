all:
	arm-linux-gcc -S main.c -o main.S
	arm-linux-gcc -c main.S -o main.o
	arm-linux-gcc -c start.S -o start.o
	arm-linux-ld -Ttext 0 start.o main.o -o main.elf
	arm-linux-objcopy -O binary -S main.elf main.bin
	arm-linux-objdump -D main.elf > mian.dis

clean:
	rm *.bin *.o *.elf
