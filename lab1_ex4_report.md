# 练习四
观察代码bootmain.c。
## 读取扇区
```
* readsect - read a single sector at @secno into @dst */
static void
readsect(void *dst, uint32_t secno) {
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1);                         // count = 1
    outb(0x1F3, secno & 0xFF);
    outb(0x1F4, (secno >> 8) & 0xFF);
    outb(0x1F5, (secno >> 16) & 0xFF);
    outb(0x1F6, ((secno >> 24) & 0xF) | 0xE0);
    outb(0x1F7, 0x20);                      // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}

```
readsect实现了对磁盘扇区的读取，将secno处的内容读入到dst中。执行以下操作：
1. 等待磁盘响应。
2. 进行读扇区前的相关初始化，通过在指定IO地址发送内容进行设置。
包括0x1F2到0x1F7的相关设置，详细设置可以参考上面的代码。
3. 等待磁盘响应。
4. 读取扇区。

## 读取连续的扇区
```
static void
readseg(uintptr_t va, uint32_t count, uint32_t offset) {
    uintptr_t end_va = va + count;

    // round down to sector boundary
    va -= offset % SECTSIZE;

    // translate from bytes to sectors; kernel starts at sector 1
    uint32_t secno = (offset / SECTSIZE) + 1;

    // If this is too slow, we could read lots of sectors at a time.
    // We'd write more to memory than asked, but it doesn't matter --
    // we load in increasing order.
    for (; va < end_va; va += SECTSIZE, secno ++) {
        readsect((void *)va, secno);
    }
}
```
readseg函数从offset处读连续count个字节到虚拟地址va。

首先计算得到结束地址end_va，

然后将va和扇区边界对齐。

之后将offset转换成扇区的编号。

之后调用readsect函数读取连续的扇区直到结束。

## bootmain主过程
```
void
bootmain(void) {
    // read the 1st page off disk
    readseg((uintptr_t)ELFHDR, SECTSIZE * 8, 0);

    // is this a valid ELF?
    if (ELFHDR->e_magic != ELF_MAGIC) {
        goto bad;
    }

    struct proghdr *ph, *eph;

    // load each program segment (ignores ph flags)
    ph = (struct proghdr *)((uintptr_t)ELFHDR + ELFHDR->e_phoff);
    eph = ph + ELFHDR->e_phnum;
    for (; ph < eph; ph ++) {
        readseg(ph->p_va & 0xFFFFFF, ph->p_memsz, ph->p_offset);
    }

    // call the entry point from the ELF header
    // note: does not return
    ((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);

    /* do nothing */
    while (1);
}

```
首先从地址0开始，读取8个扇区的内容到ELFHDR中。

然后判断ELFHDR中的e_magic值是否合法，如果不合法跳到bad处进行相关处理。

之后根据ELFHDR中的值找到每个段的段头。

然后根据每个段的段头信息从磁盘读入数据到指定内存地址。

最后跳到程序入口处开始执行程序。
