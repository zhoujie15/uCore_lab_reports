# 练习二
## 实现 Stride Scheduling 调度算法

通过对于实验框架的理解，替换掉之前的RR调度算法，使用了链表和skew_heap对进行了实现。每个函数的实现如下：


#### strid_init函数
```
static voidstride_init(struct run_queue *rq) {     /* LAB6: 2012011394      * (1) init the ready process list: rq->run_list      * (2) init the run pool: rq->lab6_run_pool      * (3) set number of process: rq->proc_num to 0      */	list_init(&(rq->run_list));	rq->lab6_run_pool = NULL;	rq->proc_num = 0;}
```
进行初始化操作，按要求进行即可。

#### enqueue

```
static voidstride_enqueue(struct run_queue *rq, struct proc_struct *proc) {     /* LAB6: 2012011394      * (1) insert the proc into rq correctly      * NOTICE: you can use skew_heap or list. Important functions      *         skew_heap_insert: insert a entry into skew_heap      *         list_add_before: insert  a entry into the last of list      * (2) recalculate proc->time_slice      * (3) set proc->rq pointer to rq      * (4) increase rq->proc_num      */#if USE_SKEW_HEAP	rq->lab6_run_pool = skew_heap_insert(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f);#else	list_add_before(&(rq->run_list), &(proc->run_link));#endif	if (proc->time_slice == 0 || proc->time_slice > rq->max_time_slice)			proc->time_slice = rq->max_time_slice;	proc->rq = rq;	rq->proc_num ++;}
```
如果使用堆时，采用skew_heap_insert函数进行插入操作，采用链表时使用list_add_before进行插入操作。

更新入队进程所需要占用的时间片。

设置proc的rq变量，增加进程数。

#### dequeue

```
static voidstride_dequeue(struct run_queue *rq, struct proc_struct *proc) {     /* LAB6: 2012011394      * (1) remove the proc from rq correctly      * NOTICE: you can use skew_heap or list. Important functions      *         skew_heap_remove: remove a entry from skew_heap      *         list_del_init: remove a entry from the  list      */#if USE_SKEW_HEAP	rq->lab6_run_pool = skew_heap_remove(rq->lab6_run_pool, &(proc->lab6_run_pool), proc_stride_comp_f );#else	list_del_init(&(proc->run_link));#endif	rq->proc_num --;}
```
两种方法分别使用skew_heap_remove和list_del_init方法进行删除。

#### pick_next

```
static struct proc_struct *stride_pick_next(struct run_queue *rq) {     /* LAB6: 2012011394      * (1) get a  proc_struct pointer p  with the minimum value of stride             (1.1) If using skew_heap, we can use le2proc get the p from rq->lab6_run_poll             (1.2) If using list, we have to search list to find the p with minimum stride value      * (2) update p;s stride value: p->lab6_stride      * (3) return p      */#if USE_SKEW_HEAP	if (rq->lab6_run_pool == NULL) return NULL;	struct proc_struct *p = le2proc(rq->lab6_run_pool, lab6_run_pool);#else	struct proc_struct *p = le2proc(&(rq->run_list), run_link);	list_entry_t* next = &rq->run_list;	if (next == list_next(next))		return NULL;	while ((next = list_next(next)) != &rq->run_list){		struct proc_struct *q = le2proc(next, run_link);		if (q->stride < p->stride)			p = q;	}#endif	if (p->lab6_priority == 0)		p->lab6_stride += BIG_STRIDE;	else p->lab6_stride += BIG_STRIDE / p->lab6_priority;	return p;}
```

这是调度算法的核心，使用堆时，堆顶元素即为最小值。采用链表的话需要便历练表才能找到最小值。

找到之后根据该进程的priority对步长stride进行增加。

#### proc_tick

```
static voidstride_proc_tick(struct run_queue *rq, struct proc_struct *proc) {     /* LAB6: 2012011394 */	if (proc->time_slice > 0){		proc->time_slice --;	} else if (proc->time_slice == 0) {		proc->need_resched = 1;	}}
```
对于时间片进行处理，每次时钟中断时减一，值为0时则进行相关调度。