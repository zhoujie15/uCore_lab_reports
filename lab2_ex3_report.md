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

