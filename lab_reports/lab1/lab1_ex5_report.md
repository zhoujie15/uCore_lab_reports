# 练习五

## 通过函数调用堆栈跟踪函数

实现print_stackframe函数，可以通过函数print_stackframe来跟踪函数调用堆栈中记录的返回地址。

找到该函数，发现文件注释中的提示。

发现可以直接调用的read_ebp()、read_ip()和print_debuginfo()函数。

通过观察标准输出格式，得到如下代码：

```
void
print_stackframe(void) {
     /* LAB1 YOUR CODE : STEP 1 */
     /* (1) call read_ebp() to get the value of ebp. the type is (uint32_t);
      * (2) call read_eip() to get the value of eip. the type is (uint32_t);
      * (3) from 0 .. STACKFRAME_DEPTH
      *    (3.1) printf value of ebp, eip
      *    (3.2) (uint32_t)calling arguments [0..4] = the contents in address (unit32_t)ebp +2 [0..4]
      *    (3.3) cprintf("\n");
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
    int i, j;

    for (i=0; i < STACKFRAME_DEPTH, ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        for (j = 0; j< 4; j++)
            cprintf("0x%08x ", *(uint32_t*)(ebp + (j + 2) * 4));
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = *(uint32_t*)(ebp + 4);
        ebp = *(uint32_t*)ebp;

    }
}
```

主要执行步骤如下：

1. 通过调用函数得到eip和ebp的值。
2. 输出当前ebp和eip的值。
3. 输出当前栈帧之上的四个参数。地址分别为ebp+8 ebp+12 ebp+16 ebp+20
4. 输出当前函数的信息。
5. 通过栈内内容得到调用函数的eip和ebp，再次回到2迭代输出。

通过运行之后的结果如下：
```
ebp:0x00007b18 eip:0x0010095f args:0x00010074 0x0010ee00 0x00007b48 0x0010007f 
    kern/debug/kdebug.c:305: print_stackframe+21
ebp:0x00007b28 eip:0x00100c42 args:0x00000000 0x00000000 0x00000000 0x00007b98 
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b48 eip:0x0010007f args:0x00000000 0x00007b70 0xffff0000 0x00007b74 
    kern/init/init.c:48: grade_backtrace2+19
ebp:0x00007b68 eip:0x001000a0 args:0x00000000 0xffff0000 0x00007b94 0x00000029 
    kern/init/init.c:53: grade_backtrace1+27
ebp:0x00007b88 eip:0x001000bc args:0x00000000 0x00100000 0xffff0000 0x00100043 
    kern/init/init.c:58: grade_backtrace0+19
ebp:0x00007ba8 eip:0x001000dc args:0x00000000 0x00000000 0x00000000 0x00103160 
    kern/init/init.c:63: grade_backtrace+26
ebp:0x00007bc8 eip:0x00100050 args:0x00000000 0x00000000 0x00010074 0x0010ed20 
    kern/init/init.c:28: kern_init+79
ebp:0x00007bf8 eip:0x00007d68 args:0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8 
    <unknow>: -- 0x00007d67 --
```
发现和运行答案的结果不一致，观察答案的代码发现一致。

把答案的代码粘贴到函数中发现输出一致。

可能结果不一样的原因是当前还没有完成整个lab1的编写，所以和答案中的输出不同。

最后的数字是当前eip和函数起始地址的差值。
