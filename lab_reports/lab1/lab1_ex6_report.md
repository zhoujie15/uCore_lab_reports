# 练习六
## 问题一
每个表项占用8字节。

其中63-48位是偏移offset的高16位。

15-0位是偏移offset的低16位。

31-16位是段选择子。

两者结合查询段表，得到对中断处理程序的入口地址。

## 问题二

对IDT进行初始化，根据注释中的提示进行代码编写。
```
void
idt_init(void) {
     /* LAB1 YOUR CODE : STEP 2 */
     /* (1) Where are the entry addrs of each Interrupt Service Routine (ISR)?
      *     All ISR's entry addrs are stored in __vectors. where is uintptr_t __vectors[] ?
      *     __vectors[] is in kern/trap/vector.S which is produced by tools/vector.c
      *     (try "make" command in lab1, then you will find vector.S in kern/trap DIR)
      *     You can use  "extern uintptr_t __vectors[];" to define this extern variable which will be used later.
      * (2) Now you should setup the entries of ISR in Interrupt Description Table (IDT).
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    
    int i;
    for (i=0; i< 32; i++)
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], 0);
    for (i=32; i< 256; i++)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);
    
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT, __vectors[T_SYSCALL], 3);
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], 3);
    
    lidt(&idt_pd);
}
```
首先得到__vector向量，得到offset。

之后用SETGATE对IDT进行初始化，这里的实现和答案稍有不同。

首先是前0-31个表项为异常，所以其istrap应该设置为1.

后面的表项为中断，istrap设置为0即可。

还有两个特殊的中断T_SYSCALL和T_SWITCH_TOK，都是从用户态转到内核态，其最后的DPL应该设置为3。

其他的表项都运行在内核态，DPL应该设置为0。

最后使用LIDT加载即可。

## 问题三
在对时钟中断的处理中设置计数器，满足100后调用print_ticks()函数即可，代码如下。
```
    case IRQ_OFFSET + IRQ_TIMER:
        /* LAB1 YOUR CODE : STEP 3 */
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
        if (ticks % TICK_NUM == 0)
            print_ticks();
        break;
```

其中ticks是全局变量，这一问的实现比较简单。