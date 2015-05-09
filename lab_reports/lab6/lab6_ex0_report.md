# 练习零
## 填写已有实验

本实验依赖实验1/2/3/4/5。请把你做的实验2/3/4/5的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”“LAB5”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab6的测试应用程序，可能需对已完成的实验1/2/3/4/5的代码进行进一步改进。

在这里，需要在对前几个阶段实验内容更新的同时，对其中的相应内容进行修改。具体的修改如下：

```
static struct proc_struct *alloc_proc(void) {    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));    if (proc != NULL) {    	proc->state = PROC_UNINIT;    	proc->pid = -1;    	proc->runs = 0;    	proc->kstack = 0;    	proc->need_resched = 0;    	proc->parent = NULL;    	proc->mm = NULL;    	memset(&(proc->context), 0, sizeof(struct context));    	proc->tf = NULL;    	proc->cr3 = boot_cr3;    	proc->flags = 0;    	proc->wait_state = 0;    	proc->cptr = NULL;    	proc->yptr = NULL;    	proc->optr = NULL;    	proc->rq = NULL;    	proc->run_link.next =  &proc->run_link;    	proc->run_link.prev =  &proc->run_link;		proc->time_slice = 0;    	proc->lab6_run_pool.left = proc->lab6_run_pool.right = proc->lab6_run_pool.parent = NULL;    	proc->lab6_stride = 0;    	proc->lab6_priority = 0;    	memset(proc->name, 0, PROC_NAME_LEN);    }    return proc;}
```
这里对于进程控制块内部新增加的变量内容进行了初始化。如rq, run_link, lab6_run_pool, lab6_stride, lab6_priority等。