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

实验中需要注意的是要记得对proc的parent变量进行赋值，以及在hash_proc调用前为进程分配进程号，因为在hash_proc中会用到；还应该注意到框架中包含了fork_out, bad_fork_cleanup_kstack和bad_fork_cleanup_proc三个分支，在前面三步失败时，要选择合适的分支返回退出。

## 思考题

请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

能够做到。在代码中的get_pid函数中进行了对于id的分配。

```
static intget_pid(void) {    static_assert(MAX_PID > MAX_PROCESS);    struct proc_struct *proc;    list_entry_t *list = &proc_list, *le;    static int next_safe = MAX_PID, last_pid = MAX_PID;    if (++ last_pid >= MAX_PID) {        last_pid = 1;        goto inside;    }    if (last_pid >= next_safe) {    inside:        next_safe = MAX_PID;    repeat:        le = list;        while ((le = list_next(le)) != list) {            proc = le2proc(le, list_link);            if (proc->pid == last_pid) {                if (++ last_pid >= next_safe) {                    if (last_pid >= MAX_PID) {                        last_pid = 1;                    }                    next_safe = MAX_PID;                    goto repeat;                }            }            else if (proc->pid > last_pid && next_safe > proc->pid) {                next_safe = proc->pid;            }        }    }    return last_pid;}
```

观察代码我们可以看出其中有last_pid和next_safe两个标志，下面简记为last和next。

last设置为1，next设置为MAX_PID分别表示进程号序列的两个端点。

下面开始进程列表的遍历，满足以下条件：

- 如果pid == last，那么last++
- pid在last和next之间，那么将next的值设为pid
- 如果last＋＋后比next大，那么将next改为MAX_PID，last不变，继续从头开始遍历

从上面的条件中我们可以看出

last是从1开始依次遍历每一个用过的id号直到找到一个没有用过的为止。

但是如果采用“pid == last，那么last++”的判断那么可能需要多次遍历才能得到last的确切值，

所以在这里设置了next，next会对是否再次进行遍历进行约束。

next为遍历过程中比last大的最小的pid值。

如果出现++ last >＝ next，那么说明next取值太小，需要再次进行一遍遍历。

这样下去直到程序退出后，能够确保找到了唯一的id值。
