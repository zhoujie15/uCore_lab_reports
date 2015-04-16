# 练习二
## 补充完成基于FIFO的页面替换算法

在swap_fifo.c中完成map_swappable和swap_out_victim函数，实现FIFO算法。

根据实现的FIFO算法，在do_pgfault中进行调用，实现页的替换。

map_swappable
```
static int_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in){    list_entry_t *head=(list_entry_t*) mm->sm_priv;    list_entry_t *entry=&(page->pra_page_link);     assert(entry != NULL && head != NULL);    //record the page access situlation    /*LAB3 EXERCISE 2: 2012011394*/    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.    list_add_before(head, entry);    return 0;}
```
将新换入的页加入到head的前面，加入链表，这样便历时通过head->next即可进行遍历。

swap_out_victim
```
static int_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick){     list_entry_t *head=(list_entry_t*) mm->sm_priv;         assert(head != NULL);     assert(in_tick==0);     /* Select the victim */     /*LAB3 EXERCISE 2: 2012011394*/     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue     //(2)  set the addr of addr of this page to ptr_page     list_entry_t* item = head->next;     struct Page* page = le2page(item, pra_page_link);     list_del(item);     *ptr_page = page;     return 0;}
```
从链表头找到第一个页进行替换，将其从链表中移除，这就是FIFO算法的替换方式。

do_pgfault

```
   ptep = get_pte(mm->pgdir, addr, 1);    if (*ptep == 0) {                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr    	pgdir_alloc_page(mm->pgdir, addr, perm);    }    else {    /*LAB3 EXERCISE 2: 2012011394    * Now we think this pte is a  swap entry, we should load data from disk to a page with phy addr,    * and map the phy addr with logical addr, trigger swap manager to record the access situation of this page.    *    *  Some Useful MACROs and DEFINEs, you can use them in below implementation.    *  MACROs or Functions:    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,    *                               find the addr of disk page, read the content of disk page into this memroy page    *    page_insert ： build the map of phy addr of an Page with the linear addr la    *    swap_map_swappable ： set the page swappable    */        if(swap_init_ok) {            struct Page *page=NULL;            swap_in(mm, addr, &page);            page_insert(mm->pgdir, page, addr, perm);            swap_map_swappable(mm, addr, page, 1);                                    //(1）According to the mm AND addr, try to load the content of right disk page                                    //    into the memory which page managed.                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr                                    //(3) make the page swappable.        }        else {            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);            goto failed;        }
```
在出现page fault时，如果当前页不为空，那么需要将该地址对应的页换出，将新的页换入；然后将页的物理地址和线性地址建立好映射，最后设置被换入的页可以被替换，则需要的操作完成。