# JZ2440 通用构建系统
# 支持多个项目的构建，可扩展 SDK 驱动和项目

# ============================================================================
# 工具链配置
# ============================================================================
CC = arm-linux-gcc
OBJDUMP = arm-linux-objdump
OBJCOPY = arm-linux-objcopy
LD = arm-linux-ld

# ============================================================================
# 编译选项
# ============================================================================
CFLAGS = -Wall -O2 -MMD
LDFLAGS = -Ttext 0

# ============================================================================
# 目录配置
# ============================================================================
SDK_DIR = sdk
PROJECT_DIR = project
BUILD_DIR = build

# SDK 头文件路径
SDK_INCLUDE = -I$(SDK_DIR)/driver -I$(SDK_DIR)/driver/uart

# 添加 SDK 头文件路径到编译选项
CFLAGS += $(SDK_INCLUDE)

# ============================================================================
# 源文件收集
# ============================================================================
# SDK 源文件
SDK_ASM_SRC = $(wildcard $(SDK_DIR)/*.S)
SDK_C_SRC = $(wildcard $(SDK_DIR)/*.c)

# SDK 驱动源文件（递归查找所有子目录）
SDK_DRIVER_ASM_SRC = $(shell find $(SDK_DIR)/driver -name "*.S" 2>/dev/null)
SDK_DRIVER_C_SRC = $(shell find $(SDK_DIR)/driver -name "*.c" 2>/dev/null)

# 合并所有 SDK 源文件
SDK_ALL_ASM_SRC = $(SDK_ASM_SRC) $(SDK_DRIVER_ASM_SRC)
SDK_ALL_C_SRC = $(SDK_C_SRC) $(SDK_DRIVER_C_SRC)

# ============================================================================
# 项目配置
# ============================================================================
# 默认项目名称
PROJECT_NAME ?= test

# 项目源文件
PROJECT_C_SRC = $(wildcard $(PROJECT_DIR)/$(PROJECT_NAME)/*.c)
PROJECT_ASM_SRC = $(wildcard $(PROJECT_DIR)/$(PROJECT_NAME)/*.S)

# 合并所有源文件
ALL_C_SRC = $(SDK_ALL_C_SRC) $(PROJECT_C_SRC)
ALL_ASM_SRC = $(SDK_ALL_ASM_SRC) $(PROJECT_ASM_SRC)

# ============================================================================
# 目标文件配置
# ============================================================================
# 构建目录
BUILD_PROJECT_DIR = $(BUILD_DIR)/$(PROJECT_NAME)

# 目标文件（在当前构建目录下）
C_OBJ = $(addprefix $(BUILD_PROJECT_DIR)/, $(notdir $(ALL_C_SRC:.c=.o)))
ASM_OBJ = $(addprefix $(BUILD_PROJECT_DIR)/, $(notdir $(ALL_ASM_SRC:.S=.o)))
ALL_OBJ = $(C_OBJ) $(ASM_OBJ)

# 依赖文件
DEP_FILES = $(ALL_OBJ:.o=.d)

# 最终输出文件
TARGET_ELF = $(BUILD_PROJECT_DIR)/$(PROJECT_NAME).elf
TARGET_BIN = $(BUILD_PROJECT_DIR)/$(PROJECT_NAME).bin
TARGET_DIS = $(BUILD_PROJECT_DIR)/$(PROJECT_NAME).dis

# ============================================================================
# 构建规则
# ============================================================================
# 默认目标
.PHONY: all clean debug help
all: $(TARGET_BIN) $(TARGET_DIS)

# 创建构建目录
$(BUILD_PROJECT_DIR):
	@echo "Creating build directory: $@"
	@mkdir -p $@

# 二进制文件
$(TARGET_BIN): $(TARGET_ELF)
	@echo "OBJCOPY $< -> $@"
	$(OBJCOPY) -O binary -S $< $@

# 反汇编文件
$(TARGET_DIS): $(TARGET_ELF)
	@echo "OBJDUMP $< -> $@"
	$(OBJDUMP) -D $< > $@

# ELF 文件
$(TARGET_ELF): $(ALL_OBJ) | $(BUILD_PROJECT_DIR)
	@echo "LD $^ -> $@"
	$(LD) $(LDFLAGS) $^ -o $@

# 通用规则：处理不同路径的源文件
# 使用 vpath 来指定源文件搜索路径
vpath %.S $(SDK_DIR) $(SDK_DIR)/driver $(SDK_DIR)/driver/uart
vpath %.c $(SDK_DIR) $(SDK_DIR)/driver $(SDK_DIR)/driver/uart $(PROJECT_DIR)/$(PROJECT_NAME)

# 通用编译规则
$(BUILD_PROJECT_DIR)/%.o: %.S | $(BUILD_PROJECT_DIR)
	@echo "CC $< -> $@"
	$(CC) -c $< -o $@

$(BUILD_PROJECT_DIR)/%.o: %.c | $(BUILD_PROJECT_DIR)
	@echo "CC -S $< -> $(BUILD_PROJECT_DIR)/$(notdir $(<:.c=.S))"
	$(CC) -S $(CFLAGS) $< -o $(BUILD_PROJECT_DIR)/$(notdir $(<:.c=.S))
	@echo "CC $(BUILD_PROJECT_DIR)/$(notdir $(<:.c=.S)) -> $@"
	$(CC) -c $(BUILD_PROJECT_DIR)/$(notdir $(<:.c=.S)) -o $@

# 包含依赖文件
-include $(DEP_FILES)

# ============================================================================
# 清理规则
# ============================================================================
clean:
	@echo "Cleaning build files..."
	rm -rf $(BUILD_DIR)

# 为特定项目添加清理规则
clean-test:
	@echo "Cleaning test build files..."
	rm -rf build/test

clean-led:
	@echo "Cleaning led build files..."
	rm -rf build/led

# ============================================================================
# 调试和帮助
# ============================================================================
debug:
	@echo "=== Build Configuration ==="
	@echo "PROJECT_NAME = $(PROJECT_NAME)"
	@echo "BUILD_PROJECT_DIR = $(BUILD_PROJECT_DIR)"
	@echo ""
	@echo "=== Source Files ==="
	@echo "SDK_ASM_SRC = $(SDK_ASM_SRC)"
	@echo "SDK_C_SRC = $(SDK_C_SRC)"
	@echo "SDK_DRIVER_ASM_SRC = $(SDK_DRIVER_ASM_SRC)"
	@echo "SDK_DRIVER_C_SRC = $(SDK_DRIVER_C_SRC)"
	@echo "PROJECT_C_SRC = $(PROJECT_C_SRC)"
	@echo "PROJECT_ASM_SRC = $(PROJECT_ASM_SRC)"
	@echo ""
	@echo "=== Object Files ==="
	@echo "ALL_OBJ = $(ALL_OBJ)"
	@echo ""
	@echo "=== Output Files ==="
	@echo "TARGET_ELF = $(TARGET_ELF)"
	@echo "TARGET_BIN = $(TARGET_BIN)"
	@echo "TARGET_DIS = $(TARGET_DIS)"
	@echo ""
	@echo "=== Compiler Flags ==="
	@echo "CFLAGS = $(CFLAGS)"
	@echo "LDFLAGS = $(LDFLAGS)"

help:
	@echo "JZ2440 通用构建系统"
	@echo ""
	@echo "用法:"
	@echo "  make [PROJECT_NAME=project_name] [target]"
	@echo ""
	@echo "目标:"
	@echo "  all              - 构建所有文件 (默认)"
	@echo "  clean            - 清理所有构建文件"
	@echo "  clean-project    - 清理指定项目的构建文件"
	@echo "  debug            - 显示构建配置信息"
	@echo "  help             - 显示此帮助信息"
	@echo ""
	@echo "项目:"
	@echo "  PROJECT_NAME=test    - 构建 test 项目 (默认)"
	@echo "  PROJECT_NAME=led     - 构建 led 项目"
	@echo "  PROJECT_NAME=key     - 构建 key 项目"
	@echo ""
	@echo "示例:"
	@echo "  make                    # 构建 test 项目"
	@echo "  make PROJECT_NAME=led   # 构建 led 项目"
	@echo "  make clean              # 清理所有构建文件"
	@echo "  make debug              # 显示构建信息"

# ============================================================================
# 项目特定规则（可以在这里添加特定项目的规则）
# ============================================================================
# 示例：为特定项目添加特殊规则
# ifeq ($(PROJECT_NAME),led)
#     # LED 项目的特殊规则
#     CFLAGS += -DLED_PROJECT
# endif
