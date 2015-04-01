# 练习一
## 实现first－fit连续内存物理分配算法

参考default_pmm.c中的详细注释。

下面分别介绍first－fit中需要的各个函数的实现。

### default_init
```
static void
default_init(void) {
    list_init(&free_list);
    nr_free = 0;
}
```
实现采用了之前的实现，主要是对空闲页链表进行初始化，设置nr_free变量为0。

### default_init_memmap
```
static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);

        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
    nr_free += n;
}
```
将从base开始的n个页加入空闲页链表。

首先遍历其中的每个页，将它们的flags和property设为0，将ref设置为0。然后将p设置为Property，表示该页空闲。

然后使用函数list_add_before将它们加到空闲页链表中。

注意：因为使用的是双向循环链表，所以&free_page实际上位于链表的最后，之后将空闲页加到它的前面。

最后设置base页的property为n，表示该页开始有长为n的空闲页。

最后将计数器nr_free加上n。


### default_alloc_pages
```
static struct Page *
default_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > nr_free) {
        return NULL;
    }

    list_entry_t *le, *nextle;
    le = &free_list;

    struct Page *p, *pp;
    while ((le = list_next(le)) != &free_list){
    	p =  le2page(le, page_link);

    	if (p -> property>= n) {
    			int i= 0;
    			for (i=0; i < n; i++){
    				nextle = list_next(le);
    				pp = le2page(le, page_link);
    				SetPageReserved(pp);
    				ClearPageProperty(pp);
    				list_del(le);
    				le = nextle;
    			}
    			if (p->property > n){
    				(le2page(le, page_link))->property = p->property - n;
    			}
    			ClearPageProperty(p);
    			SetPageReserved(p);
    			nr_free -= n;
    			return p;
    			}
    	}
    return NULL;
}
```

首先如果请求的页面数比现有的空闲页多，那么分配失败，返回NULL。

接下来遍历free_list中的每个项，如果该页当前的property大于等于n，那么根据first fit原则，就将这一段空闲页进行分配。

分配过程中将从首页开始的n个页设置Reserved，取消Property，在链表中删除。

如果property大于n，那么要修改接下来的页的property，将其修改为原property大小和n的差。

最后修改首页p，设置其为Reserved，取消Property。减去空闲页数目，返回p的地址即可。

### default_free_pages
```
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);

    list_entry_t *le = &free_list;
    list_entry_t *bef;

    struct Page* p;
    while ((le = list_next(le)) != &free_list){
    	p = le2page(le, page_link);
    	if (p > base) break;
    }

    for (p = base; p< base+n; p++){
    	list_add_before(le, &(p->page_link));
    }

    base ->flags = 0;
    set_page_ref(base, 0);
    ClearPageReserved(base);		//
    SetPageProperty(base);
    base->property = n;

    p = le2page(le, page_link);
    if (base + n == p){
    	base->property += p->property;
    	p->property = 0;
    }

    bef = list_prev(&(base->page_link));
    p = le2page(bef, page_link);
    if (bef != &free_list && p == base-1){
    		while (bef != &free_list){
    			if (p -> property != 0){
    				p->property += base->property;
    				base->property = 0;
    				break;
    			}
    			bef = list_prev(bef);
    			p = le2page(bef, page_link);
    		}
    }
    nr_free += n;
    return;
}
```

首先遍历链表，找到当前页需要插入的位置。

然后将这n个页插入到当前位置前。

之后考虑是否需要进行合并操作。

如果base＋n＝p，那么需要和后面的页进行合并，那么只需要修改base和p的property的值即可。

如果前面页和base相连，那么还需要向前进行合并，不断向前查找直到property不为0，修改该页和base页的property集合即可。

### first fit改进空间
鉴于循环双向链表的数据结构，我们发现

在合并过程中需要向前不断遍历，花销较大。

我们可以在page中设立一个head域，每一段连续页空间中的页的head值都指向首个页，这样在向前查找时，

使用O(1)的时间就可以找到前面区间的头，而不必进行遍历。