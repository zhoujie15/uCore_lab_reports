# 练习一
## 使用 Round Robin 调度算法

#### 请理解并分析sched_class中各个函数指针的用法，并接合Round Robin 调度算法描ucore的调度执行过程。

对于sched_class中的各个函数类都采用了函数指针来实现，并且使用的是RR调度算法的实现。
- void (*init)(struct run_queue *rq); 对等待队列进行初始化操作。
- void (*enqueue)(struct run_queue *rq, struct proc_struct *proc); 将某一个进程放入到队列中。
- void (*dequeue)(struct run_queue *rq, struct proc_struct *proc); 让某一个进程出队。
- struct proc_struct *(*pick_next)(struct run_queue *rq); 进程选取，这里选择的不同进程表示了不同了调度算法。
- void (*proc_tick)(struct run_queue *rq, struct proc_struct *proc); 对于时钟进行响应和处理。对于时间片用完的情况进行处理。

ucore的调度执行过程

当运行到一个内核抢占点或者时间片用完时，ucore会进行调度，主要的实现参见schedule()函数，它会将当前进程入队，然后选择下一个进程，将该进程出队，进行进程切换。

#### 请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“，给出概要设计，鼓励给出详细设计。

在当前的进程控制块中，设置多个队列，每个队列对应不同的时间片长度，以及设置一个变量，表示当前运行进程所在的队列Q。

enqueue

- 新产生的进程入队时，进入Q1队列进行等待。
- 如果当前进程因为时间片用完而进行调度，假设当前进程所在的队列为Q，那么将其加入到下一个队列中。

pick_next

- 在进行进程调度时，优先从Q1队列按照FIFO方式进行选择，然后再依次从后续队列中进行选择。

dequeue

出队操作并无不同，只是简单将pick_next选择的进程出队。

proc_tick

在进行处理时，需要根据当前进程所在队列Q设置的相应的时间进行处理。

