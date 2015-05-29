# 练习一
## 完成读文件操作的实现

首先了解打开文件的处理流程，然后参考本实验后续的文件读写操作的过程分析，编写在sfs_inode.c中sfs_io_nolock读文件中数据的实现代码。

```
if ((blkoff = offset % SFS_BLKSIZE) != 0){
    	size = (nblks != 0) ? (SFS_BLKSIZE - blkoff): (endpos - offset);

    	if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno , &ino)) != 0)
    		goto out;
    	//sfs_bmap_load_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, uint32_t *ino_store) {
    	if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff))  != 0)
			goto out;
    	//    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    	alen += size;
    	if (nblks == 0) goto out;
    	buf += size;
    	blkno ++;
    	nblks --;
    }

    size = SFS_BLKSIZE;
    while (nblks != 0){
    	if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino))  != 0)
    		goto out;
    	if ((ret = sfs_block_op(sfs, buf, ino, 1) != 0))
			goto out;
    	alen += size;
    	buf += size;
    	blkno++;
    	nblks--;
    }

    if ((size = endpos % SFS_BLKSIZE ) != 0){
    	if ((ret = (sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) ) != 0)
    		goto out;
    	if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0)
    		goto out;
    	alen += size;
    }

```
这里实现了打开文件的处理，先处理起始的没有对齐到块的部分，再以块为单位循环处理中间的部分，最后处理末尾剩余的部分。每部分中都调用sfs_bmap_load_nolock函数得到blkno对应的inode编号，并调用sfs_rbuf或sfs_rblock函数读取数据（中间部分调用sfs_rblock，起始和末尾部分调用sfs_rbuf），调整相关变量。

## 给出设计实现”UNIX的PIPE机制“的概要设方案，鼓励给出详细设计方案

可以设计一个pipe用的pipefs，在系统调用时创建两个file，一个只读，一个只写，并使这两个file连接到同一个inode上。这样便简单实现了pipe机制，使用一个临时保存输出的文件，当程序1输出时，将内存保存到这个文件；当程序2读入时，读取这个文件的内容即可。