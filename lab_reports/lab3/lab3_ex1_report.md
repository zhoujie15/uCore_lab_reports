# 练习一
## 给未被映射的地址映射上物理页

主要需要修改do_pgfault中相关的部分。

根据注释中的提示，首先需要找到地址对应的页表项。

如果页表项为0，则该地址未被映射上物理页，通过调用函数进行物理页的映射。

```
ptep = get_pte(mm->pgdir, addr, 1);

if (*ptep == 0){
	struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
} 
else {
	// need to do in ex2
}
```

### 请描述页目录项（Page Director Entry）和页表（Page Table Entry）中每个组成部分的含义和以及对ucore而言的潜在用处。
查看mmu.h可以得到关于组成内容的宏定义。页目录项和页表项的组成部分如下


－ 31-12 下一级索引地址

－ 11-9 Available for software use

－ 8-7 Must be Zero，其中7为Page Size

－ 6 Dirty

－ 5 Accessed

－ 4 Cache-Disable

－ 3 Write-Through，是否采用写直达

－ 2 User

－ 1 Writeable，是否可写

－ 0 Present，是否存在


位0是存在（Present）标志，用于指明表项对地址转换是否有效。P=1表示有效；P=0表示无效。在页转换过程中，如果说涉及的页目录或页表的表项无效，则会导致一个异常。如果P=0，那么除表示表项无效外，其余位可供程序自由使用。可以作为缺页异常的判定位。

位1是读/写（Read/Write）标志。如果等于1，表示页面可以被读、写或执行。如果为0，表示页面只读或可执行。当处理器运行在超级用户特权级（级别0、1或2）时，则R/W位不起作用。页目录项中的R/W位对其所映射的所有页面起作用。

位2是用户/超级用户（User/Supervisor）标志。如果为1，那么运行在任何特权级上的程序都可以访问该页面。如果为0，那么页面只能被运行在超级用户特权级（0、1或2）上的程序访问。页目录项中的U/S位对其所映射的所有页面起作用。用于对于内存访问的保护，确保固定特权级访问相应的数据。

位5是已访问（Accessed）标志。当处理器访问页表项映射的页面时，页表表项的这个标志就会被置为1。当处理器访问页目录表项映射的任何页面时，页目录表项的这个标志就会被置为1。处理器只负责设置该标志，操作系统可通过定期地复位该标志来统计页面的使用情况。可以用在相关置换算法中，比如clock算法等等。

位6是页面已被修改（Dirty）标志。当处理器对一个页面执行写操作时，就会设置对应页表表项的D标志。处理器并不会修改页目录项中的D标志。用于在置换算法中被换出的页是否写入内存的判定。

11-9位该字段保留专供程序使用。

### 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？

1. 从CPU收到中断事件后，打断当前程序或任务的执行，根据某种机制跳转到中断服务例程去执行。CPU会根据中断向量查找IDT，找到中断描述符中的段选择子。之后从GDT取得相应的段描述符，这样便得到了中断服务例程的起始地址。然后CPU会根据CPL和DPL确认是否发生了特权级的转换。之后保存现场，开始执行中断服务例程。

2. 发生缺页异常时，中断服务例程会将缺失的页调入到内存中，有些情况下会进行页置换。根据情况修改页表。

3. 每个中断服务例程在有中断处理工作完成后需要通过iret（或iretd）指令恢复被打断的程序的执行。恢复现场保存信息，并完成特权级的转换。回到出现异常的语句继续执行。
