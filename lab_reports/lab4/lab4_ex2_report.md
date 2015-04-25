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
int
```

实验中需要注意的是要记得对proc的parent变量进行赋值，以及在hash_proc调用前为进程分配进程号，因为在hash_proc中会用到；还应该注意到框架中包含了fork_out, bad_fork_cleanup_kstack和bad_fork_cleanup_proc三个分支，在前面三步失败时，要选择合适的分支返回退出。

## 思考题

请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由。

能够做到。在代码中的get_pid函数中进行了对于id的分配。

```
static int
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