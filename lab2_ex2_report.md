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
|| Bits	|| 内容				||
|| 31-12	|| 下一级索引地址			||
｜ 11－9	｜ Available for software use	｜
｜ 8-7	｜ Must be Zero，其中7为Page Size	｜
｜ 6	｜ Dirty				｜
｜ 5	｜ Accessed			｜
｜ 4	｜ Cache-Disable			｜
｜ 3	｜ Write-Through，是否采用写直达	｜
｜ 2	｜ User				｜
｜ 1	｜ Writeable，是否可写		｜
｜ 0	｜ Present，是否存在		｜

### 如果ucore执行过程中访问内存，出现了页访问异常，请问硬件要做哪些事情？