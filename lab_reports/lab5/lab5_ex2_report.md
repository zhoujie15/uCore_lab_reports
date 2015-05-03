# 练习二
## 父进程复制自己的内存空间给子进程

在fork过程中将父进程的用户地址空间的合法内容复制到子进程中，完成资源的复制。在这里补充copy_range函数的实现。

```
        /* LAB5:EXERCISE2 2012011394         * replicate content of page to npage, build the map of phy addr of nage with the linear addr start         *         * Some Useful MACROs and DEFINEs, you can use them in below implementation.         * MACROs or Functions:         *    page2kva(struct Page *page): return the kernel vritual addr of memory which page managed (SEE pmm.h)         *    page_insert: build the map of phy addr of an Page with the linear addr la         *    memcpy: typical memory copy function         *         * (1) find src_kvaddr: the kernel virtual address of page         * (2) find dst_kvaddr: the kernel virtual address of npage         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE         * (4) build the map of phy addr of  npage with the linear addr start         */        void* src_kvaddr = page2kva(page);        void* dst_kvaddr = page2kva(npage);        memcpy(dst_kvaddr, src_kvaddr, PGSIZE);        ret = page_insert(to, npage, start, perm);        assert(ret == 0);        }
```
在这里，首先根据page和npage得到复制的内存地址，然后进行内存中内容的复制。

之后设置页和线性地址的物理映射。这样便完成了内存内容的复制。


## 思考题

请在实验报告中简要说明如何设计实现”Copy on Write 机制“，给出概要设计，鼓励给出详细设计。

在调用copy_range时，只是仅仅将各页表项的指针的值赋给子进程，并在该页表项中设置一个计数，表示该页进行共享了的该页的进程数。当程序需要写这个页的时候，如果发现该标志位不为0，那么将该计数减一，并会产生一个缺页异常，得到一个复制之后的页进行写操作。