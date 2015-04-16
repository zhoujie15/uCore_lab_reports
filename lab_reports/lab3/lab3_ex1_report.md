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