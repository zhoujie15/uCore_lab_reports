# 练习一
## 加载应用程序并执行

使用icode_load函数来加载并解析一个处于内存中的ELF执行文件格式的应用程序。本实验需要对其中的trapframe进行正确的设置。代码如下。

```
    /* LAB5:EXERCISE1 2012011394     * should set tf_cs,tf_ds,tf_es,tf_ss,tf_esp,tf_eip,tf_eflags     * NOTICE: If we set trapframe correctly, then the user level process can return to USER MODE from kernel. So     *          tf_cs should be USER_CS segment (see memlayout.h)     *          tf_ds=tf_es=tf_ss should be USER_DS segment     *          tf_esp should be the top addr of user stack (USTACKTOP)     *          tf_eip should be the entry point of this binary program (elf->e_entry)     *          tf_eflags should be set to enable computer to produce Interrupt     */    tf->tf_cs = USER_CS;    tf->tf_ds = USER_DS;    tf->tf_es = USER_DS;    tf->tf_ss = USER_DS;    tf->tf_esp = USTACKTOP;    tf->tf_eip = elf->e_entry;    tf->tf_eflags = FL_IF;    ret = 0;
```
主要设置如下：
- 将代码段cs寄存器设置为用户代码段地址。
- 将数据段ds es ss寄存器设置为用户数据段地址。
- 将esp设置为用户堆栈顶。
- 将eip设置为二进制代码的起始地址，即为elf->entry
- 将eflags设置为能够开中断。

## 思考题
请在实验报告中描述当创建一个用户态进程并加载了应用程序后，CPU是如何让这个应用程序最终在用户态执行起来的。即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。

当最后的用户进程的用户环境搭建完毕时，initproc将按产生系统调用的函数调用路径原路返回，执行中断返回指令“iret”（位于trapentry.S的最后一句）后，将切换到用户进程hello的第一条语句位置_start处（位于user/libs/initcode.S的第三句）开始执行。

具体在代码中可以看到，当initproc创建完用户进程时，会不断调用schedule()，schedule会找到用户进程进行切换，从用户进程处开始执行。