# 练习二
## 单步跟踪BIOS的执行

修改文件lab1init，去掉continue及之后的语句

在命令行中运行 make lab1-mon，

则程序会在BIOS的第一条指令处，

可以进行单步调试。

## 初始化位置0x7c00设置实地址断点,测试断点正常

运行make lab1-mon即可在0x7c00处设置断点，程序会在这里停止。

执行continue后程序会运行。

## 从0x7c00开始跟踪代码运行,将单步跟踪反汇编得到的代码与bootasm.S和 bootblock.asm进行比较。

不修改lab1init，运行make lab1-mon后输入n可以进行单步调试。

之后通过x命令可以看到反汇编代码。

或者在q.log中观察0x7c00处的反汇编代码，

发现其与bootasm.S和bootblock.asm中的代码相同。

## 找一个bootloader或内核中的代码位置，设置断点并进行测试。

只需要使用b指令设置断点，进行调试即可。 
