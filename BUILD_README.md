# JZ2440 通用构建系统

这是一个为 JZ2440 开发板设计的通用构建系统，支持多个项目的构建，可以灵活添加 SDK 驱动和项目。

## 目录结构

```
jz2440/
├── Makefile              # 通用构建系统
├── sdk/                  # SDK 核心文件
│   ├── start.S          # 启动文件
│   └── driver/          # 驱动程序
│       ├── s3c24xx.h    # 硬件寄存器定义
│       └── uart/        # UART 驱动
│           ├── uart.c
│           ├── uart.h
│           └── s3c24xx.h
├── project/             # 项目文件
│   ├── test/           # 测试项目
│   │   └── test.c
│   └── led/            # LED 项目
│       └── led.c
├── build/              # 构建输出目录
│   ├── test/          # test 项目的构建目录
│   └── led/           # led 项目的构建目录
└── test/              # 其他测试目录
```

## 使用方法

### 基本用法

```bash
# 构建默认项目（test）
make

# 构建指定项目
make PROJECT_NAME=led

# 清理所有构建文件
make clean

# 清理指定项目的构建文件
make clean-test
make clean-led

# 显示构建配置信息
make debug

# 显示帮助信息
make help
```

### 项目构建示例

```bash
# 构建 test 项目
make PROJECT_NAME=test

# 构建 led 项目
make PROJECT_NAME=led

# 构建 key 项目（如果存在）
make PROJECT_NAME=key
```

## 添加新项目

### 1. 创建项目目录

```bash
mkdir -p project/my_project
```

### 2. 添加项目源文件

在 `project/my_project/` 目录下创建你的源文件：

```c
// project/my_project/main.c
#include "s3c24xx.h"
#include "uart.h"

int main(void)
{
    uart0_init();
    puts("My Project Starting...\n");
    
    while(1)
    {
        // 你的代码
    }
    
    return 0;
}
```

### 3. 构建项目

```bash
make PROJECT_NAME=my_project
```

## 添加新的 SDK 驱动

### 1. 创建驱动目录

```bash
mkdir -p sdk/driver/led
```

### 2. 添加驱动文件

```c
// sdk/driver/led/led.c
#include "s3c24xx.h"

void led_init(void)
{
    // LED 初始化代码
}

void led_on(int led_num)
{
    // 点亮 LED
}

void led_off(int led_num)
{
    // 熄灭 LED
}
```

```c
// sdk/driver/led/led.h
#ifndef __LED_H__
#define __LED_H__

void led_init(void);
void led_on(int led_num);
void led_off(int led_num);

#endif
```

### 3. 更新头文件路径

如果需要，可以在 Makefile 中添加新的头文件路径：

```makefile
# 在 Makefile 中找到这一行
SDK_INCLUDE = -I$(SDK_DIR)/driver -I$(SDK_DIR)/driver/uart

# 添加新的驱动路径
SDK_INCLUDE = -I$(SDK_DIR)/driver -I$(SDK_DIR)/driver/uart -I$(SDK_DIR)/driver/led
```

## 构建输出

每个项目都会在 `build/项目名/` 目录下生成以下文件：

- `项目名.elf` - ELF 格式的可执行文件
- `项目名.bin` - 二进制文件（用于烧录）
- `项目名.dis` - 反汇编文件
- `*.o` - 目标文件
- `*.S` - 汇编文件（中间文件）
- `*.d` - 依赖文件

## 特性

### 1. 自动依赖管理
- 使用 `-MMD` 选项自动生成依赖文件
- 当头文件改变时，相关的源文件会自动重新编译

### 2. 增量编译
- 只编译发生变化的文件
- 提高编译效率

### 3. 清晰的构建过程
- 每个编译步骤都有详细的输出信息
- 便于调试和问题定位

### 4. 灵活的配置
- 支持多个项目
- 易于扩展新的驱动和功能

## 故障排除

### 1. 找不到头文件
确保在 Makefile 中添加了正确的头文件路径：

```makefile
SDK_INCLUDE = -I$(SDK_DIR)/driver -I$(SDK_DIR)/driver/uart -I$(SDK_DIR)/driver/your_driver
```

### 2. 链接错误
检查是否包含了所有必要的源文件，确保 `main` 函数存在。

### 3. 编译警告
检查代码中的类型转换和函数声明。

## 扩展功能

### 添加项目特定的编译选项

在 Makefile 中可以添加项目特定的规则：

```makefile
# 项目特定规则
ifeq ($(PROJECT_NAME),led)
    CFLAGS += -DLED_PROJECT
endif

ifeq ($(PROJECT_NAME),key)
    CFLAGS += -DKEY_PROJECT
endif
```

### 添加新的工具链

如果需要使用不同的工具链，可以修改 Makefile 开头的工具链配置：

```makefile
CC = your-arm-gcc
OBJDUMP = your-arm-objdump
OBJCOPY = your-arm-objcopy
LD = your-arm-ld
```

这个构建系统设计得足够灵活，可以满足大多数 JZ2440 开发需求。
