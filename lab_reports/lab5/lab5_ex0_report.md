# 练习零
## 填写已有实验

本实验依赖实验1/2/3/4。请把你做的实验1/2/3/4的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”的注释相应部分。注意：为了能够正确执行lab5的测试应用程序，可能需对已完成的实验1/2/3/4的代码进行进一步改进。

和之前的实验不同，此次实验需要根据需要对前四个实验的代码进行修改。

根据代码中的注释进行相应的修改。主要有以下几处。

LAB1: 增加中断门，让用户态程序能够进行系统调用。
```
void
```

LAB1: 在这里更改对于时钟中断的处理，每当到一个时间片结束，将当前进程的need_resched设置为1，表示需要进行进程切换。这里注意必须要去掉之前的print_ticks()语句，否则make grade检查过程中会出错。

```
    /* LAB1 YOUR CODE : STEP 3 */
```

LAB4: 更新PCB中新增添的成员变量的初始值。主要有wait_state, cptr, yptr, optr。
```
// alloc_proc - alloc a proc_struct and init all fields of proc_struct
```
LAB4: 更新do_fork函数，主要更新其中的第一步和第五步，设置parent，调用set_links函数，函数中包含了之前的一些操作，这里需要去掉。

```
int
```