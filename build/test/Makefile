CC = arm-linux-gcc
OBJDUMP = arm-linux-objdump
OBJCOPY = arm-linux-objcopy
LD = arm-linux-ld

CFLAGS = -Wall -O2 -MMD  #-MMD output depence
LDFLAGS = -Ttext 0

C_SRC = $(wildcard *.c)
ASM_SRC = $(wildcard *.S)

C_ARM = $(C_SRC:.c=.S)
OBJ = $(ASM_SRC:.S=.o) $(C_ASM:.S=.o)
DEP = $(OGJ:.o=.d)

TARGET = test
DIS = $(TARGET).dis
BIN = $(TARGET).bin
ELF = $(TARGET).elf


$(DIS) : $(ELF)
	$(OBJDUMP) -D $< > $@
	
$(BIN) : $(ELF)
	$(OBJCOPY) -O binary -S $< $@

$(ELF) : $(OBJ)
	$(LD) $(LDFLAGS) $^ -o $@

%.o : %.S
	$(CC) -c $< -o $@

%.S : %.c
	$(CC) -S $(CFLAGS) $< -o $@

-include $(DEP)






test.dis : test.elf
	arm-linux-objdump -D test.elf > test.dis

test.bin : test.elf
	arm-linux-objcopy -O binary -S test.elf test.bin

test.elf : test.o uart.o start.o
	arm-linux-ld -Ttext 0 test.o uart.o start.o -o test.elf

start.o : start.S
	arm-linux-gcc -c start.S -o start.S

test.o : test.S
	arm-linux-gcc -c test.S -o test.o

uart.o : uart.S
	arm-linux-gcc -c uart.S -o uart.o

test.S : test.c uart.h s3c24xx.h
	arm-linux-gcc -S test.c -o test.S

uart.S : uart.c uart.h
	arm-linux-gcc -S uart.c -o uart.S


.PHONY : clean
clean:
	rm *.bin *.elf *.o *.dis
