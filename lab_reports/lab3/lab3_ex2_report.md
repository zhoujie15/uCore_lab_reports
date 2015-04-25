# 练习二
## 补充完成基于FIFO的页面替换算法

在swap_fifo.c中完成map_swappable和swap_out_victim函数，实现FIFO算法。

根据实现的FIFO算法，在do_pgfault中进行调用，实现页的替换。

map_swappable
```
static int
```
将新换入的页加入到head的前面，加入链表，这样便历时通过head->next即可进行遍历。

swap_out_victim
```
static int
```
从链表头找到第一个页进行替换，将其从链表中移除，这就是FIFO算法的替换方式。

do_pgfault

```
   ptep = get_pte(mm->pgdir, addr, 1);
```
在出现page fault时，如果当前页不为空，那么需要将该地址对应的页换出，将新的页换入；然后将页的物理地址和线性地址建立好映射，最后设置被换入的页可以被替换，则需要的操作完成。

### 课后练习题

可以支持在ucore中实现这个算法，因为ucore的表项中已经有了需要使用到的dirty位和accessed位来表示是否修改和访问。需要在swap_manager中维护一个页表项链表和时钟指针，进行算法的相关操作。

- 需要被换出的页其表项的修改位和访问位都必须为0。 
- 查找页表项中的accessed位和dirty位，都为0便可以换出。
- 在发生了缺页异常，而且物理内存已经满了的情况下进行换入换出操作。