# 练习零
## 填写已有实验

本实验依赖实验1/2/3/4/5/6。请把你做的实验1/2/3/4/5/6的代码填入本实验中代码中有“LAB1”/“LAB2”/“LAB3”/“LAB4”/“LAB5”/“LAB6”的注释相应部分。并确保编译通过。注意：为了能够正确执行lab7的测试应用程序，可能需对已完成的实验1/2/3/4/5/6的代码进行进一步改进。

在LAB1的trap.c中需要进行相关内容的修改。修改如下：
```
    case IRQ_OFFSET + IRQ_TIMER:#if 0    LAB3 : If some page replacement algorithm(such as CLOCK PRA) need tick to change the priority of pages,    then you can add code here. #endif        /* LAB1 YOUR CODE : STEP 3 */        /* handle the timer interrupt */        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().         * (3) Too Simple? Yes, I think so!         */        /* LAB5 YOUR CODE */        /* you should upate you lab1 code (just add ONE or TWO lines of code):         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1         */        ticks ++;    	assert(current != NULL);        run_timer_list();        /* LAB6 2012011394 */        /* you should update you lab5 code         * IMPORTANT FUNCTIONS:	     * sched_class_proc_tick         */                 /* LAB7 2012011394 */        /* you should upate you lab6 code         * IMPORTANT FUNCTIONS:	     * run_timer_list         */        break;
```

在这里参考注释，调用了run_timer_list对于tick进行了处理。

修改代码后，运行make grade，所有的测试都能够通过。
