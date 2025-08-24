CC = arm-linux-gcc
OBJDUMP = arm-linux-objdump
OBJCOPY = arm-linux-objcopy
LD = arm-linux-ld

INCLUDE_DIR = -I../../sdk/driver -I../../sdk/driver/uart

CFLAGS = -Wall -O2 -MMD $(INCLUDE_DIR)  #-MMD output depence
LDFLAGS = -Ttext 0

SRC_DIRS = ../../sdk ../../sdk/driver/uart ../../project/test
# 下面两行代码的作用是自动查找所有源文件
# C_SRC 变量会遍历 SRC_DIRS 中指定的每个目录，查找所有以 .c 结尾的 C 源文件，并将它们的路径收集起来
C_SRC = $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.c))
# ASM_SRC 变量同理，查找所有以 .S 结尾的汇编源文件
ASM_SRC = $(foreach dir,$(SRC_DIRS),$(wildcard $(dir)/*.S))

$(info C_SRC = $(C_SRC))
$(info ASM_SRC = $(ASM_SRC))



# C_ARM 变量将所有 C 源文件（.c）扩展为对应的汇编文件（.S），即把每个 .c 文件名后缀替换为 .S
C_ARM = $(C_SRC:.c=.S)

# OBJ 变量包含所有需要编译的目标文件（.o），包括：
# 1. 所有汇编源文件（.S）对应的目标文件（.o）
# 2. 所有 C 源文件生成的汇编文件（.S）再编译成的目标文件（.o）
OBJ = $(ASM_SRC:.S=.o) $(C_ARM:.S=.o)

# DEP 变量用于依赖管理，将所有目标文件（.o）的后缀替换为依赖文件（.d），
# 这样可以自动包含依赖关系，便于增量编译
DEP = $(OBJ:.o=.d)

TARGET = test
DIS = $(TARGET).dis
BIN = $(TARGET).bin
ELF = $(TARGET).elf

# 默认目标：构建所有文件
all: $(BIN) $(DIS)


$(DIS) : $(ELF)
	@echo "OBJDUMP $< -> $@"
	$(OBJDUMP) -D $< > $@
	
$(BIN) : $(ELF)
	@echo "OBJCOPY $< -> $@"
	$(OBJCOPY) -O binary -S $< $@

$(ELF) : $(OBJ)
	@echo "LD $^ -> $@"
	$(LD) $(LDFLAGS) $^ -o $@

%.o : %.S
	@echo "CC $< -> $@"
	$(CC) -c $< -o $@

#%.o : %.c
#	@echo "CC -S $< -> $(<:.c=.S)"
#	$(CC) -S $(CFLAGS) $< -o $(<:.c=.S)
#	@echo "CC $(<:.c=.S) -> $@"
#	$(CC) -c $(<:.c=.S) -o $@

%.S : %.c
	@echo "CC -S $< -> $@"
	$(CC) -S $(CFLAGS) $< -o $@

-include $(DEP)





# test.dis : test.elf
#	arm-linux-objdump -D test.elf > test.dis
#
# test.bin : test.elf
#	arm-linux-objcopy -O binary -S test.elf test.bin
#
# test.elf : test.o uart.o start.o
#	arm-linux-ld -Ttext 0 test.o uart.o start.o -o test.elf
#
# start.o : start.S
#	arm-linux-gcc -c start.S -o start.S
#
# test.o : test.S
#	arm-linux-gcc -c test.S -o test.o
#
# uart.o : uart.S
#	arm-linux-gcc -c uart.S -o uart.o
#
# test.S : test.c uart.h s3c24xx.h
#	arm-linux-gcc -S test.c -o test.S
#
# uart.S : uart.c uart.h
#	arm-linux-gcc -S uart.c -o uart.S


.PHONY : clean debug
clean:
	rm -f $(OBJ) $(ELF) $(BIN) $(DEP) *.o *.elf *.bin *.dis

debug:
	@echo "=== Debug Information ==="
	@echo "C_SRC = $(C_SRC)"
	@echo "ASM_SRC = $(ASM_SRC)"
	@echo "C_ARM = $(C_ARM)"
	@echo "OBJ = $(OBJ)"
	@echo "DEP = $(DEP)"
	@echo "TARGET = $(TARGET)"
	@echo "ELF = $(ELF)"
	@echo "BIN = $(BIN)"
	@echo "DIS = $(DIS)"
	@echo "CFLAGS = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"
