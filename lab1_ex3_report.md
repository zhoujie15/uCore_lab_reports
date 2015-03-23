# 练习三
首先程序会初始化寄存器，将它们赋值为0。
```
    cli                                             # Disable interrupts
    cld                                             # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    xorw %ax, %ax                                   # Segment number zero
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment
```

## 开启A20

通过键盘控制器将A20线置于高电位，使32位地址线可用。
 
```
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

```

可以看出首先等待8042键盘控制器输入缓存为空，之后通过写入0x64表示要向P2端口写入数据。

之后继续等待输入缓存为空，然后将0x60端口赋值为0xdf，这样便将A20位赋值为1，开启了A20。

## 初始化gdt表
通过载入语句初始化gdt表。
```
lgdt gdtdesc
```
## 进入保护模式
通过将cr0寄存器的PE位置1，即可开启保护模式。
```
movl %cr0, %eax
orl $CR0_PE_ON, %eax
movl %eax, %cr0
```
通过长跳转更新cs的基地址后设立段寄存器，建立堆栈
```
```
 则转到保护模式完成，进入bootmain方法开始执行。
```
call bootmain
```