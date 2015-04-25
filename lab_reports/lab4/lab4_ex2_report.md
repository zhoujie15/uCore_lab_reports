# 练习二
## 为新创建的内核线程分配资源

在do_fork中完成具体内核线程的创建工作，根据注释和实验指导书中的内容，得到大致的执行步骤包括：

- 调用alloc_proc，首先获得一块用户信息块
- 为进程分配一个内核栈
- 复制原进程上下文到新进程
- 将新进程添加到进程列表
- 唤醒新进程
- 返回新进程号

具体实现如下
 
```
intdo_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {    int ret = -E_NO_FREE_PROC;    struct proc_struct *proc;    if (nr_process >= MAX_PROCESS) {        goto fork_out;    }    ret = -E_NO_MEM;    //LAB4:EXERCISE2 2012011394    /*     * Some Useful MACROs, Functions and DEFINEs, you can use them in below implementation.     * MACROs or Functions:     *   alloc_proc:   create a proc struct and init fields (lab4:exercise1)     *   setup_kstack: alloc pages with size KSTACKPAGE as process kernel stack     *   copy_mm:      process "proc" duplicate OR share process "current"'s mm according clone_flags     *                 if clone_flags & CLONE_VM, then "share" ; else "duplicate"     *   copy_thread:  setup the trapframe on the  process's kernel stack top and     *                 setup the kernel entry point and stack of process     *   hash_proc:    add proc into proc hash_list     *   get_pid:      alloc a unique pid for process     *   wakup_proc:   set proc->state = PROC_RUNNABLE     * VARIABLES:     *   proc_list:    the process set's list     *   nr_process:   the number of process set     */    if ((proc = alloc_proc()) == NULL){		// 1. call alloc_proc to allocate a proc_struct    	goto fork_out;    }    if (setup_kstack(proc) < 0){	    	// 2. call setup_kstack to allocate a kernel stack for child process    	goto bad_fork_cleanup_proc;    }    if (copy_mm(clone_flags, proc) != 0){ 	// 3. call copy_mm to dup OR share mm according clone_flag    	goto bad_fork_cleanup_kstack;    }    proc->parent = current;    copy_thread(proc, stack, tf); 			// 4. call copy_thread to setup tf & context in proc_struct    proc->pid = get_pid();    hash_proc(proc);						// 5. insert proc_struct into hash_list && proc_list    list_add(&proc_list, &(proc->list_link));    nr_process ++;    wakeup_proc(proc);						// 6. call wakup_proc to make the new child process RUNNABLE    ret = proc->pid;						// 7. set ret vaule using child proc's pidfork_out:    return ret;bad_fork_cleanup_kstack:    put_kstack(proc);bad_fork_cleanup_proc:    kfree(proc);    goto fork_out;}
```

## 思考题
