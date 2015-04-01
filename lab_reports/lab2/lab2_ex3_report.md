# 练习三
## 释放某虚地址所在的页并取消对应二级页表项的映射

观察代码中的注释和提示进行实现。
```
    if (*ptep & PTE_P) {
        struct Page *page = pte2page(*ptep);
        if (page_ref_dec(page) == 0) {
            free_page(page);
        }
        *ptep = 0;
        tlb_invalidate(pgdir, la);
    }
```

如果ptep存在，PRESENCE的位为1。

那么得到当前ptep对应的页，调用free_page进行释放。

删除页表项。

删除页目录项。

### 数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？

### 如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？ 鼓励通过编程来具体完成这个问题
