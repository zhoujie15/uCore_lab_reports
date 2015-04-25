# 练习一
## 分配并初始化一个进程控制块

通过阅读代码和实验指导书中的相关部分，在proc.c的alloc_proc函数中对proc_struct的各个内容进行初始化。

代码如下

```
static struct proc_struct *alloc_proc(void) {    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));    if (proc != NULL) {    //LAB4:EXERCISE1 2012011394    /*     * below fields in proc_struct need to be initialized     *       enum proc_state state;                      // Process state     *       int pid;                                    // Process ID     *       int runs;                                   // the running times of Proces     *       uintptr_t kstack;                           // Process kernel stack     *       volatile bool need_resched;                 // bool value: need to be rescheduled to release CPU?     *       struct proc_struct *parent;                 // the parent process     *       struct mm_struct *mm;                       // Process's memory management field     *       struct context context;                     // Switch here to run process     *       struct trapframe *tf;                       // Trap frame for current interrupt     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)     *       uint32_t flags;                             // Process flag     *       char name[PROC_NAME_LEN + 1];               // Process name     */    	proc->state = PROC_UNINIT;    	proc->pid = -1;    	proc->runs = 0;    	proc->kstack = 0;    	proc->need_resched = 0;    	proc->parent = NULL;    	proc->mm = NULL;    	memset(&(proc->context), 0, sizeof(struct context));    	proc->tf = NULL;    	proc->cr3 = boot_cr3;    	proc->flags = 0;    	memset(proc->name, 0, PROC_NAME_LEN);    }    return proc;}
```

对其中的各项内容清零，有几个特殊的表项需要注意：

- pid，即进程的id号，因为还没有进行分配，所以设置为－1。
- cr3，该内核线程在内核中运行，故采用为uCore内核已经建立的页表，即设置为在uCore内核页表的起始地址boot_cr3。
- state，设置进程的状态为“初始”态

这样便完成了对于进程控制块的分配和初始化。