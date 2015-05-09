# 练习二
## 实现 Stride Scheduling 调度算法

通过对于实验框架的理解，替换掉之前的RR调度算法，使用了链表和skew_heap对进行了实现。每个函数的实现如下：


#### strid_init函数
```
static void
```
进行初始化操作，按要求进行即可。

#### enqueue

```
static void
```
如果使用堆时，采用skew_heap_insert函数进行插入操作，采用链表时使用list_add_before进行插入操作。

更新入队进程所需要占用的时间片。

设置proc的rq变量，增加进程数。

#### dequeue

```
static void
```
两种方法分别使用skew_heap_remove和list_del_init方法进行删除。

#### pick_next

```
static struct proc_struct *
```

这是调度算法的核心，使用堆时，堆顶元素即为最小值。采用链表的话需要便历练表才能找到最小值。

找到之后根据该进程的priority对步长stride进行增加。

#### proc_tick

```
static void
```
对于时间片进行处理，每次时钟中断时减一，值为0时则进行相关调度。