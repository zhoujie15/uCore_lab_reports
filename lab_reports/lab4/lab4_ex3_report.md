# 练习三
## 阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的。
```
voidproc_run(struct proc_struct *proc) {    if (proc != current) {        bool intr_flag;        struct proc_struct *prev = current, *next = proc;        local_intr_save(intr_flag);        {            current = proc;            load_esp0(next->kstack + KSTACKSIZE);            lcr3(next->cr3);            switch_to(&(prev->context), &(next->context));        }        local_intr_restore(intr_flag);    }}
```

proc_run函数进行了进程切换操作，将当前运行进程切换到proc进程。

首先，根据flag的值判断是否需要屏蔽中断，之后进行进程切换操作。如果之前没有屏蔽中断，那么先暂时屏蔽。
然后将当前进程设置为proc，设置内核堆栈地址，并且切换进程页表，然后调用switch_to进行两个进程上下文的切换。
最后再恢复中断屏蔽的设置，如果之前不屏蔽中断，那么再将设置恢复。

## 思考题
1. 在本实验的执行过程中，创建且运行了几个内核线程？

这里创建且运行了两个内核线程，第一个是idleproc，第二个是initproc。

2. 语句local_intr_save(intr_flag);....local_intr_restore(intr_flag);在这里有何作用?请说明理由

local_intr_save检查flags中的位IF是否为1，即是否进行中断响应，如果之前为1，那么进行中断响应，这里先将中断屏蔽。

之后进行进程切换，不会受到中断的影响。

进程切换后再将之前的设置恢复。如果之前为1，那么进行恢复。