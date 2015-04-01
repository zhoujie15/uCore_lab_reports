# 练习二
## 寻找虚拟地址对应的页表项

通过参考代码中的注释，实现对于一个给定虚拟地址的页表项的查找。

```
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
	pde_t *pdep = &pgdir[PDX(la)];
	if (!(*pdep & PTE_P)){
		struct Page* page;
		if (!create) return NULL;
		page = alloc_page();
		if (page == NULL) return NULL;
		set_page_ref(page, 1);
		uintptr_t pa = page2pa(page);
		memset(KADDR(pa), 0, PGSIZE);
		*pdep = pa | PTE_U | PTE_W | PTE_P;
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
}
```
首先得到pdep，此为虚拟地址对应的页目录表的指针。使用宏PDX可以得到虚拟地址la在页目录中的索引。

如果页表项不存在，那么考察create，如果create为false，那么退出。

如果create为true，那么分配页面。设置页面的ref值，将页面内容清空为0。设置pdep页表项。

最后通过统一的语句查找页表项并返回。

即先从pdep指针中得到PTE的物理地址，然后访问PTE中la中index的位置并返回。

### 请描述页目录项（Page Director Entry）和页表（Page Table Entry）中每个组成部分的含义和以及对ucore而言的潜在用处。
页目录项和页表项的组成部分如下
{|
|Bits
|内容
|-
|31-12
|下一级索引地址
|
|-
|11－9
|Available for software use
|
|-
|8-7
|Must be Zero，其中7为Page Size
|
|-
|6
|Dirty
|
|-
|5
|Accessed
|
|-
|4
|Cache-Disable
|
|-
|3
|Write-Through，是否采用写直达
|
|-
|2
|User
|1
|Writeable，是否可写
|
|-
|0
|Present，是否存在
|
|}

位0是存在（Present）标志，用于指明表项对地址转换是否有效。P=1表示有效；P=0表示无效。在页转换过程中，如果说涉及的页目录或页表的表项无效，则会导致一个异常。如果P=0，那么除表示表项无效外，其余位可供程序自由使用。

位1是读/写（Read/Write）标志。如果等于1，表示页面可以被读、写或执行。如果为0，表示页面只读或可执行。当处理器运行在超级用户特权级（级别0、1或2）时，则R/W位不起作用。页目录项中的R/W位对其所映射的所有页面起作用。

位2是用户/超级用户（User/Supervisor）标志。如果为1，那么运行在任何特权级上的程序都可以访问该页面。如果为0，那么页面只能被运行在超级用户特权级（0、1或2）上的程序访问。页目录项中的U/S位对其所映射的所有页面起作用。

位5是已访问（Accessed）标志。当处理器访问页表项映射的页面时，页表表项的这个标志就会被置为1。当处理器访问页目录表项映射的任何页面时，页目录表项的这个标志就会被置为1。处理器只负责设置该标志，操作系统可通过定期地复位该标志来统计页面的使用情况。

位6是页面已被修改（Dirty）标志。当处理器对一个页面执行写操作时，就会设置对应页表表项的D标志。处理器并不会修改页目录项中的D标志。

11-9位该字段保留专供程序使用。处理器不会修改这几位，以后的升级处理器也不会。

### 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？