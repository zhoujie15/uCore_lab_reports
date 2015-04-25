
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 f0 11 c0       	mov    $0xc011f000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba b0 0b 12 c0       	mov    $0xc0120bb0,%edx
c0100035:	b8 68 fa 11 c0       	mov    $0xc011fa68,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 68 fa 11 c0 	movl   $0xc011fa68,(%esp)
c0100051:	e8 d9 88 00 00       	call   c010892f <memset>

    cons_init();                // init the console
c0100056:	e8 80 15 00 00       	call   c01015db <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 8a 10 c0 	movl   $0xc0108ac0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 8a 10 c0 	movl   $0xc0108adc,(%esp)
c0100070:	e8 d6 02 00 00       	call   c010034b <cprintf>

    print_kerninfo();
c0100075:	e8 05 08 00 00       	call   c010087f <print_kerninfo>

    grade_backtrace();
c010007a:	e8 95 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 c8 4b 00 00       	call   c0104c4c <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 30 1f 00 00       	call   c0101fb9 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 82 20 00 00       	call   c0102110 <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 34 73 00 00       	call   c01073c7 <vmm_init>

    ide_init();                 // init ide devices
c0100093:	e8 74 16 00 00       	call   c010170c <ide_init>
    swap_init();                // init swap
c0100098:	e8 6b 5f 00 00       	call   c0106008 <swap_init>

    clock_init();               // init clock interrupt
c010009d:	e8 ef 0c 00 00       	call   c0100d91 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a2:	e8 80 1e 00 00       	call   c0101f27 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a7:	eb fe                	jmp    c01000a7 <kern_init+0x7d>

c01000a9 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a9:	55                   	push   %ebp
c01000aa:	89 e5                	mov    %esp,%ebp
c01000ac:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000af:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b6:	00 
c01000b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000be:	00 
c01000bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c6:	e8 f8 0b 00 00       	call   c0100cc3 <mon_backtrace>
}
c01000cb:	c9                   	leave  
c01000cc:	c3                   	ret    

c01000cd <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cd:	55                   	push   %ebp
c01000ce:	89 e5                	mov    %esp,%ebp
c01000d0:	53                   	push   %ebx
c01000d1:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d4:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000da:	8d 55 08             	lea    0x8(%ebp),%edx
c01000dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000ec:	89 04 24             	mov    %eax,(%esp)
c01000ef:	e8 b5 ff ff ff       	call   c01000a9 <grade_backtrace2>
}
c01000f4:	83 c4 14             	add    $0x14,%esp
c01000f7:	5b                   	pop    %ebx
c01000f8:	5d                   	pop    %ebp
c01000f9:	c3                   	ret    

c01000fa <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fa:	55                   	push   %ebp
c01000fb:	89 e5                	mov    %esp,%ebp
c01000fd:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100100:	8b 45 10             	mov    0x10(%ebp),%eax
c0100103:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100107:	8b 45 08             	mov    0x8(%ebp),%eax
c010010a:	89 04 24             	mov    %eax,(%esp)
c010010d:	e8 bb ff ff ff       	call   c01000cd <grade_backtrace1>
}
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c3 ff ff ff       	call   c01000fa <grade_backtrace0>
}
c0100137:	c9                   	leave  
c0100138:	c3                   	ret    

c0100139 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100139:	55                   	push   %ebp
c010013a:	89 e5                	mov    %esp,%ebp
c010013c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100142:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100145:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100148:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014f:	0f b7 c0             	movzwl %ax,%eax
c0100152:	83 e0 03             	and    $0x3,%eax
c0100155:	89 c2                	mov    %eax,%edx
c0100157:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010015c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100160:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100164:	c7 04 24 e1 8a 10 c0 	movl   $0xc0108ae1,(%esp)
c010016b:	e8 db 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100170:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100174:	0f b7 d0             	movzwl %ax,%edx
c0100177:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010017c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100180:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100184:	c7 04 24 ef 8a 10 c0 	movl   $0xc0108aef,(%esp)
c010018b:	e8 bb 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100190:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100194:	0f b7 d0             	movzwl %ax,%edx
c0100197:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c010019c:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a4:	c7 04 24 fd 8a 10 c0 	movl   $0xc0108afd,(%esp)
c01001ab:	e8 9b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b4:	0f b7 d0             	movzwl %ax,%edx
c01001b7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001bc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c4:	c7 04 24 0b 8b 10 c0 	movl   $0xc0108b0b,(%esp)
c01001cb:	e8 7b 01 00 00       	call   c010034b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d4:	0f b7 d0             	movzwl %ax,%edx
c01001d7:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001dc:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e4:	c7 04 24 19 8b 10 c0 	movl   $0xc0108b19,(%esp)
c01001eb:	e8 5b 01 00 00       	call   c010034b <cprintf>
    round ++;
c01001f0:	a1 80 fa 11 c0       	mov    0xc011fa80,%eax
c01001f5:	83 c0 01             	add    $0x1,%eax
c01001f8:	a3 80 fa 11 c0       	mov    %eax,0xc011fa80
}
c01001fd:	c9                   	leave  
c01001fe:	c3                   	ret    

c01001ff <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001ff:	55                   	push   %ebp
c0100200:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100207:	5d                   	pop    %ebp
c0100208:	c3                   	ret    

c0100209 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100209:	55                   	push   %ebp
c010020a:	89 e5                	mov    %esp,%ebp
c010020c:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020f:	e8 25 ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100214:	c7 04 24 28 8b 10 c0 	movl   $0xc0108b28,(%esp)
c010021b:	e8 2b 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_user();
c0100220:	e8 da ff ff ff       	call   c01001ff <lab1_switch_to_user>
    lab1_print_cur_status();
c0100225:	e8 0f ff ff ff       	call   c0100139 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022a:	c7 04 24 48 8b 10 c0 	movl   $0xc0108b48,(%esp)
c0100231:	e8 15 01 00 00       	call   c010034b <cprintf>
    lab1_switch_to_kernel();
c0100236:	e8 c9 ff ff ff       	call   c0100204 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023b:	e8 f9 fe ff ff       	call   c0100139 <lab1_print_cur_status>
}
c0100240:	c9                   	leave  
c0100241:	c3                   	ret    

c0100242 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100242:	55                   	push   %ebp
c0100243:	89 e5                	mov    %esp,%ebp
c0100245:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010024c:	74 13                	je     c0100261 <readline+0x1f>
        cprintf("%s", prompt);
c010024e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100251:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100255:	c7 04 24 67 8b 10 c0 	movl   $0xc0108b67,(%esp)
c010025c:	e8 ea 00 00 00       	call   c010034b <cprintf>
    }
    int i = 0, c;
c0100261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100268:	e8 66 01 00 00       	call   c01003d3 <getchar>
c010026d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100270:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100274:	79 07                	jns    c010027d <readline+0x3b>
            return NULL;
c0100276:	b8 00 00 00 00       	mov    $0x0,%eax
c010027b:	eb 79                	jmp    c01002f6 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010027d:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100281:	7e 28                	jle    c01002ab <readline+0x69>
c0100283:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010028a:	7f 1f                	jg     c01002ab <readline+0x69>
            cputchar(c);
c010028c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010028f:	89 04 24             	mov    %eax,(%esp)
c0100292:	e8 da 00 00 00       	call   c0100371 <cputchar>
            buf[i ++] = c;
c0100297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010029a:	8d 50 01             	lea    0x1(%eax),%edx
c010029d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002a3:	88 90 a0 fa 11 c0    	mov    %dl,-0x3fee0560(%eax)
c01002a9:	eb 46                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002ab:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002af:	75 17                	jne    c01002c8 <readline+0x86>
c01002b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002b5:	7e 11                	jle    c01002c8 <readline+0x86>
            cputchar(c);
c01002b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ba:	89 04 24             	mov    %eax,(%esp)
c01002bd:	e8 af 00 00 00       	call   c0100371 <cputchar>
            i --;
c01002c2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002c6:	eb 29                	jmp    c01002f1 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002c8:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002cc:	74 06                	je     c01002d4 <readline+0x92>
c01002ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002d2:	75 1d                	jne    c01002f1 <readline+0xaf>
            cputchar(c);
c01002d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d7:	89 04 24             	mov    %eax,(%esp)
c01002da:	e8 92 00 00 00       	call   c0100371 <cputchar>
            buf[i] = '\0';
c01002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002e2:	05 a0 fa 11 c0       	add    $0xc011faa0,%eax
c01002e7:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002ea:	b8 a0 fa 11 c0       	mov    $0xc011faa0,%eax
c01002ef:	eb 05                	jmp    c01002f6 <readline+0xb4>
        }
    }
c01002f1:	e9 72 ff ff ff       	jmp    c0100268 <readline+0x26>
}
c01002f6:	c9                   	leave  
c01002f7:	c3                   	ret    

c01002f8 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f8:	55                   	push   %ebp
c01002f9:	89 e5                	mov    %esp,%ebp
c01002fb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100301:	89 04 24             	mov    %eax,(%esp)
c0100304:	e8 fe 12 00 00       	call   c0101607 <cons_putc>
    (*cnt) ++;
c0100309:	8b 45 0c             	mov    0xc(%ebp),%eax
c010030c:	8b 00                	mov    (%eax),%eax
c010030e:	8d 50 01             	lea    0x1(%eax),%edx
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	89 10                	mov    %edx,(%eax)
}
c0100316:	c9                   	leave  
c0100317:	c3                   	ret    

c0100318 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100318:	55                   	push   %ebp
c0100319:	89 e5                	mov    %esp,%ebp
c010031b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010032c:	8b 45 08             	mov    0x8(%ebp),%eax
c010032f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100333:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100336:	89 44 24 04          	mov    %eax,0x4(%esp)
c010033a:	c7 04 24 f8 02 10 c0 	movl   $0xc01002f8,(%esp)
c0100341:	e8 2a 7d 00 00       	call   c0108070 <vprintfmt>
    return cnt;
c0100346:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100349:	c9                   	leave  
c010034a:	c3                   	ret    

c010034b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010034b:	55                   	push   %ebp
c010034c:	89 e5                	mov    %esp,%ebp
c010034e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100351:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100354:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010035a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100361:	89 04 24             	mov    %eax,(%esp)
c0100364:	e8 af ff ff ff       	call   c0100318 <vcprintf>
c0100369:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036f:	c9                   	leave  
c0100370:	c3                   	ret    

c0100371 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100371:	55                   	push   %ebp
c0100372:	89 e5                	mov    %esp,%ebp
c0100374:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100377:	8b 45 08             	mov    0x8(%ebp),%eax
c010037a:	89 04 24             	mov    %eax,(%esp)
c010037d:	e8 85 12 00 00       	call   c0101607 <cons_putc>
}
c0100382:	c9                   	leave  
c0100383:	c3                   	ret    

c0100384 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100384:	55                   	push   %ebp
c0100385:	89 e5                	mov    %esp,%ebp
c0100387:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010038a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100391:	eb 13                	jmp    c01003a6 <cputs+0x22>
        cputch(c, &cnt);
c0100393:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100397:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010039a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039e:	89 04 24             	mov    %eax,(%esp)
c01003a1:	e8 52 ff ff ff       	call   c01002f8 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a9:	8d 50 01             	lea    0x1(%eax),%edx
c01003ac:	89 55 08             	mov    %edx,0x8(%ebp)
c01003af:	0f b6 00             	movzbl (%eax),%eax
c01003b2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003b5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b9:	75 d8                	jne    c0100393 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bb:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003c9:	e8 2a ff ff ff       	call   c01002f8 <cputch>
    return cnt;
c01003ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d1:	c9                   	leave  
c01003d2:	c3                   	ret    

c01003d3 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d3:	55                   	push   %ebp
c01003d4:	89 e5                	mov    %esp,%ebp
c01003d6:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003d9:	e8 65 12 00 00       	call   c0101643 <cons_getc>
c01003de:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e5:	74 f2                	je     c01003d9 <getchar+0x6>
        /* do nothing */;
    return c;
c01003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f5:	8b 00                	mov    (%eax),%eax
c01003f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100402:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100409:	e9 d2 00 00 00       	jmp    c01004e0 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c010040e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100411:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100414:	01 d0                	add    %edx,%eax
c0100416:	89 c2                	mov    %eax,%edx
c0100418:	c1 ea 1f             	shr    $0x1f,%edx
c010041b:	01 d0                	add    %edx,%eax
c010041d:	d1 f8                	sar    %eax
c010041f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100422:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100425:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100428:	eb 04                	jmp    c010042e <stab_binsearch+0x42>
            m --;
c010042a:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100431:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100434:	7c 1f                	jl     c0100455 <stab_binsearch+0x69>
c0100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100439:	89 d0                	mov    %edx,%eax
c010043b:	01 c0                	add    %eax,%eax
c010043d:	01 d0                	add    %edx,%eax
c010043f:	c1 e0 02             	shl    $0x2,%eax
c0100442:	89 c2                	mov    %eax,%edx
c0100444:	8b 45 08             	mov    0x8(%ebp),%eax
c0100447:	01 d0                	add    %edx,%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d5                	jne    c010042a <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x7c>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 78                	jmp    c01004e0 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	89 c2                	mov    %eax,%edx
c010047d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100480:	01 d0                	add    %edx,%eax
c0100482:	8b 40 08             	mov    0x8(%eax),%eax
c0100485:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100488:	73 13                	jae    c010049d <stab_binsearch+0xb1>
            *region_left = m;
c010048a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010048d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100490:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100492:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100495:	83 c0 01             	add    $0x1,%eax
c0100498:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010049b:	eb 43                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010049d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a0:	89 d0                	mov    %edx,%eax
c01004a2:	01 c0                	add    %eax,%eax
c01004a4:	01 d0                	add    %edx,%eax
c01004a6:	c1 e0 02             	shl    $0x2,%eax
c01004a9:	89 c2                	mov    %eax,%edx
c01004ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01004ae:	01 d0                	add    %edx,%eax
c01004b0:	8b 40 08             	mov    0x8(%eax),%eax
c01004b3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004b6:	76 16                	jbe    c01004ce <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004be:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c6:	83 e8 01             	sub    $0x1,%eax
c01004c9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004cc:	eb 12                	jmp    c01004e0 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004d4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004dc:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004e3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004e6:	0f 8e 22 ff ff ff    	jle    c010040e <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f0:	75 0f                	jne    c0100501 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fd:	89 10                	mov    %edx,(%eax)
c01004ff:	eb 3f                	jmp    c0100540 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100501:	8b 45 10             	mov    0x10(%ebp),%eax
c0100504:	8b 00                	mov    (%eax),%eax
c0100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100509:	eb 04                	jmp    c010050f <stab_binsearch+0x123>
c010050b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010050f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100512:	8b 00                	mov    (%eax),%eax
c0100514:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100517:	7d 1f                	jge    c0100538 <stab_binsearch+0x14c>
c0100519:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010051c:	89 d0                	mov    %edx,%eax
c010051e:	01 c0                	add    %eax,%eax
c0100520:	01 d0                	add    %edx,%eax
c0100522:	c1 e0 02             	shl    $0x2,%eax
c0100525:	89 c2                	mov    %eax,%edx
c0100527:	8b 45 08             	mov    0x8(%ebp),%eax
c010052a:	01 d0                	add    %edx,%eax
c010052c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100530:	0f b6 c0             	movzbl %al,%eax
c0100533:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100536:	75 d3                	jne    c010050b <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100538:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010053e:	89 10                	mov    %edx,(%eax)
    }
}
c0100540:	c9                   	leave  
c0100541:	c3                   	ret    

c0100542 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100542:	55                   	push   %ebp
c0100543:	89 e5                	mov    %esp,%ebp
c0100545:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100548:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054b:	c7 00 6c 8b 10 c0    	movl   $0xc0108b6c,(%eax)
    info->eip_line = 0;
c0100551:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100554:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010055b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055e:	c7 40 08 6c 8b 10 c0 	movl   $0xc0108b6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100568:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010056f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100572:	8b 55 08             	mov    0x8(%ebp),%edx
c0100575:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100578:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100582:	c7 45 f4 a8 a9 10 c0 	movl   $0xc010a9a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100589:	c7 45 f0 9c 96 11 c0 	movl   $0xc011969c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100590:	c7 45 ec 9d 96 11 c0 	movl   $0xc011969d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100597:	c7 45 e8 32 cf 11 c0 	movl   $0xc011cf32,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010059e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a4:	76 0d                	jbe    c01005b3 <debuginfo_eip+0x71>
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	83 e8 01             	sub    $0x1,%eax
c01005ac:	0f b6 00             	movzbl (%eax),%eax
c01005af:	84 c0                	test   %al,%al
c01005b1:	74 0a                	je     c01005bd <debuginfo_eip+0x7b>
        return -1;
c01005b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005b8:	e9 c0 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005bd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ca:	29 c2                	sub    %eax,%edx
c01005cc:	89 d0                	mov    %edx,%eax
c01005ce:	c1 f8 02             	sar    $0x2,%eax
c01005d1:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005d7:	83 e8 01             	sub    $0x1,%eax
c01005da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005e4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005eb:	00 
c01005ec:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005f3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005fd:	89 04 24             	mov    %eax,(%esp)
c0100600:	e8 e7 fd ff ff       	call   c01003ec <stab_binsearch>
    if (lfile == 0)
c0100605:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100608:	85 c0                	test   %eax,%eax
c010060a:	75 0a                	jne    c0100616 <debuginfo_eip+0xd4>
        return -1;
c010060c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100611:	e9 67 02 00 00       	jmp    c010087d <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100619:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010061c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100622:	8b 45 08             	mov    0x8(%ebp),%eax
c0100625:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100629:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100630:	00 
c0100631:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100634:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100638:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010063b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	89 04 24             	mov    %eax,(%esp)
c0100645:	e8 a2 fd ff ff       	call   c01003ec <stab_binsearch>

    if (lfun <= rfun) {
c010064a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010064d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100650:	39 c2                	cmp    %eax,%edx
c0100652:	7f 7c                	jg     c01006d0 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100654:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100657:	89 c2                	mov    %eax,%edx
c0100659:	89 d0                	mov    %edx,%eax
c010065b:	01 c0                	add    %eax,%eax
c010065d:	01 d0                	add    %edx,%eax
c010065f:	c1 e0 02             	shl    $0x2,%eax
c0100662:	89 c2                	mov    %eax,%edx
c0100664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100667:	01 d0                	add    %edx,%eax
c0100669:	8b 10                	mov    (%eax),%edx
c010066b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	29 c1                	sub    %eax,%ecx
c0100673:	89 c8                	mov    %ecx,%eax
c0100675:	39 c2                	cmp    %eax,%edx
c0100677:	73 22                	jae    c010069b <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100679:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010067c:	89 c2                	mov    %eax,%edx
c010067e:	89 d0                	mov    %edx,%eax
c0100680:	01 c0                	add    %eax,%eax
c0100682:	01 d0                	add    %edx,%eax
c0100684:	c1 e0 02             	shl    $0x2,%eax
c0100687:	89 c2                	mov    %eax,%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	01 d0                	add    %edx,%eax
c010068e:	8b 10                	mov    (%eax),%edx
c0100690:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100693:	01 c2                	add    %eax,%edx
c0100695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100698:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069e:	89 c2                	mov    %eax,%edx
c01006a0:	89 d0                	mov    %edx,%eax
c01006a2:	01 c0                	add    %eax,%eax
c01006a4:	01 d0                	add    %edx,%eax
c01006a6:	c1 e0 02             	shl    $0x2,%eax
c01006a9:	89 c2                	mov    %eax,%edx
c01006ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006ae:	01 d0                	add    %edx,%eax
c01006b0:	8b 50 08             	mov    0x8(%eax),%edx
c01006b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b6:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bc:	8b 40 10             	mov    0x10(%eax),%eax
c01006bf:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006ce:	eb 15                	jmp    c01006e5 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d3:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d6:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e8:	8b 40 08             	mov    0x8(%eax),%eax
c01006eb:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f2:	00 
c01006f3:	89 04 24             	mov    %eax,(%esp)
c01006f6:	e8 a8 80 00 00       	call   c01087a3 <strfind>
c01006fb:	89 c2                	mov    %eax,%edx
c01006fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100700:	8b 40 08             	mov    0x8(%eax),%eax
c0100703:	29 c2                	sub    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010070b:	8b 45 08             	mov    0x8(%ebp),%eax
c010070e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100712:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100719:	00 
c010071a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100721:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100724:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010072b:	89 04 24             	mov    %eax,(%esp)
c010072e:	e8 b9 fc ff ff       	call   c01003ec <stab_binsearch>
    if (lline <= rline) {
c0100733:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100736:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100739:	39 c2                	cmp    %eax,%edx
c010073b:	7f 24                	jg     c0100761 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010073d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100740:	89 c2                	mov    %eax,%edx
c0100742:	89 d0                	mov    %edx,%eax
c0100744:	01 c0                	add    %eax,%eax
c0100746:	01 d0                	add    %edx,%eax
c0100748:	c1 e0 02             	shl    $0x2,%eax
c010074b:	89 c2                	mov    %eax,%edx
c010074d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100750:	01 d0                	add    %edx,%eax
c0100752:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100756:	0f b7 d0             	movzwl %ax,%edx
c0100759:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075c:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075f:	eb 13                	jmp    c0100774 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100761:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100766:	e9 12 01 00 00       	jmp    c010087d <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076e:	83 e8 01             	sub    $0x1,%eax
c0100771:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100774:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100777:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077a:	39 c2                	cmp    %eax,%edx
c010077c:	7c 56                	jl     c01007d4 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010077e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100781:	89 c2                	mov    %eax,%edx
c0100783:	89 d0                	mov    %edx,%eax
c0100785:	01 c0                	add    %eax,%eax
c0100787:	01 d0                	add    %edx,%eax
c0100789:	c1 e0 02             	shl    $0x2,%eax
c010078c:	89 c2                	mov    %eax,%edx
c010078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100791:	01 d0                	add    %edx,%eax
c0100793:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100797:	3c 84                	cmp    $0x84,%al
c0100799:	74 39                	je     c01007d4 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010079b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079e:	89 c2                	mov    %eax,%edx
c01007a0:	89 d0                	mov    %edx,%eax
c01007a2:	01 c0                	add    %eax,%eax
c01007a4:	01 d0                	add    %edx,%eax
c01007a6:	c1 e0 02             	shl    $0x2,%eax
c01007a9:	89 c2                	mov    %eax,%edx
c01007ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007ae:	01 d0                	add    %edx,%eax
c01007b0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007b4:	3c 64                	cmp    $0x64,%al
c01007b6:	75 b3                	jne    c010076b <debuginfo_eip+0x229>
c01007b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	89 d0                	mov    %edx,%eax
c01007bf:	01 c0                	add    %eax,%eax
c01007c1:	01 d0                	add    %edx,%eax
c01007c3:	c1 e0 02             	shl    $0x2,%eax
c01007c6:	89 c2                	mov    %eax,%edx
c01007c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007cb:	01 d0                	add    %edx,%eax
c01007cd:	8b 40 08             	mov    0x8(%eax),%eax
c01007d0:	85 c0                	test   %eax,%eax
c01007d2:	74 97                	je     c010076b <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007d4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	7c 46                	jl     c0100824 <debuginfo_eip+0x2e2>
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	89 c2                	mov    %eax,%edx
c01007ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f1:	01 d0                	add    %edx,%eax
c01007f3:	8b 10                	mov    (%eax),%edx
c01007f5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007fb:	29 c1                	sub    %eax,%ecx
c01007fd:	89 c8                	mov    %ecx,%eax
c01007ff:	39 c2                	cmp    %eax,%edx
c0100801:	73 21                	jae    c0100824 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c0100803:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100806:	89 c2                	mov    %eax,%edx
c0100808:	89 d0                	mov    %edx,%eax
c010080a:	01 c0                	add    %eax,%eax
c010080c:	01 d0                	add    %edx,%eax
c010080e:	c1 e0 02             	shl    $0x2,%eax
c0100811:	89 c2                	mov    %eax,%edx
c0100813:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100816:	01 d0                	add    %edx,%eax
c0100818:	8b 10                	mov    (%eax),%edx
c010081a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010081d:	01 c2                	add    %eax,%edx
c010081f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100822:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100824:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100827:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010082a:	39 c2                	cmp    %eax,%edx
c010082c:	7d 4a                	jge    c0100878 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010082e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100831:	83 c0 01             	add    $0x1,%eax
c0100834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100837:	eb 18                	jmp    c0100851 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100839:	8b 45 0c             	mov    0xc(%ebp),%eax
c010083c:	8b 40 14             	mov    0x14(%eax),%eax
c010083f:	8d 50 01             	lea    0x1(%eax),%edx
c0100842:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100845:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100848:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084b:	83 c0 01             	add    $0x1,%eax
c010084e:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100851:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100854:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100857:	39 c2                	cmp    %eax,%edx
c0100859:	7d 1d                	jge    c0100878 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010085b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085e:	89 c2                	mov    %eax,%edx
c0100860:	89 d0                	mov    %edx,%eax
c0100862:	01 c0                	add    %eax,%eax
c0100864:	01 d0                	add    %edx,%eax
c0100866:	c1 e0 02             	shl    $0x2,%eax
c0100869:	89 c2                	mov    %eax,%edx
c010086b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086e:	01 d0                	add    %edx,%eax
c0100870:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100874:	3c a0                	cmp    $0xa0,%al
c0100876:	74 c1                	je     c0100839 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100878:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010087d:	c9                   	leave  
c010087e:	c3                   	ret    

c010087f <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010087f:	55                   	push   %ebp
c0100880:	89 e5                	mov    %esp,%ebp
c0100882:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100885:	c7 04 24 76 8b 10 c0 	movl   $0xc0108b76,(%esp)
c010088c:	e8 ba fa ff ff       	call   c010034b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100891:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100898:	c0 
c0100899:	c7 04 24 8f 8b 10 c0 	movl   $0xc0108b8f,(%esp)
c01008a0:	e8 a6 fa ff ff       	call   c010034b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008a5:	c7 44 24 04 b8 8a 10 	movl   $0xc0108ab8,0x4(%esp)
c01008ac:	c0 
c01008ad:	c7 04 24 a7 8b 10 c0 	movl   $0xc0108ba7,(%esp)
c01008b4:	e8 92 fa ff ff       	call   c010034b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008b9:	c7 44 24 04 68 fa 11 	movl   $0xc011fa68,0x4(%esp)
c01008c0:	c0 
c01008c1:	c7 04 24 bf 8b 10 c0 	movl   $0xc0108bbf,(%esp)
c01008c8:	e8 7e fa ff ff       	call   c010034b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008cd:	c7 44 24 04 b0 0b 12 	movl   $0xc0120bb0,0x4(%esp)
c01008d4:	c0 
c01008d5:	c7 04 24 d7 8b 10 c0 	movl   $0xc0108bd7,(%esp)
c01008dc:	e8 6a fa ff ff       	call   c010034b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e1:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f1:	29 c2                	sub    %eax,%edx
c01008f3:	89 d0                	mov    %edx,%eax
c01008f5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008fb:	85 c0                	test   %eax,%eax
c01008fd:	0f 48 c2             	cmovs  %edx,%eax
c0100900:	c1 f8 0a             	sar    $0xa,%eax
c0100903:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100907:	c7 04 24 f0 8b 10 c0 	movl   $0xc0108bf0,(%esp)
c010090e:	e8 38 fa ff ff       	call   c010034b <cprintf>
}
c0100913:	c9                   	leave  
c0100914:	c3                   	ret    

c0100915 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100915:	55                   	push   %ebp
c0100916:	89 e5                	mov    %esp,%ebp
c0100918:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010091e:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100921:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 04 24             	mov    %eax,(%esp)
c010092b:	e8 12 fc ff ff       	call   c0100542 <debuginfo_eip>
c0100930:	85 c0                	test   %eax,%eax
c0100932:	74 15                	je     c0100949 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100934:	8b 45 08             	mov    0x8(%ebp),%eax
c0100937:	89 44 24 04          	mov    %eax,0x4(%esp)
c010093b:	c7 04 24 1a 8c 10 c0 	movl   $0xc0108c1a,(%esp)
c0100942:	e8 04 fa ff ff       	call   c010034b <cprintf>
c0100947:	eb 6d                	jmp    c01009b6 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100949:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100950:	eb 1c                	jmp    c010096e <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100952:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100958:	01 d0                	add    %edx,%eax
c010095a:	0f b6 00             	movzbl (%eax),%eax
c010095d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100963:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100966:	01 ca                	add    %ecx,%edx
c0100968:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010096a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010096e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100974:	7f dc                	jg     c0100952 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100976:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010097c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010097f:	01 d0                	add    %edx,%eax
c0100981:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100984:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	8b 55 08             	mov    0x8(%ebp),%edx
c010098a:	89 d1                	mov    %edx,%ecx
c010098c:	29 c1                	sub    %eax,%ecx
c010098e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100991:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100994:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100998:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010099e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009a2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009aa:	c7 04 24 36 8c 10 c0 	movl   $0xc0108c36,(%esp)
c01009b1:	e8 95 f9 ff ff       	call   c010034b <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009b6:	c9                   	leave  
c01009b7:	c3                   	ret    

c01009b8 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009b8:	55                   	push   %ebp
c01009b9:	89 e5                	mov    %esp,%ebp
c01009bb:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009be:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009c7:	c9                   	leave  
c01009c8:	c3                   	ret    

c01009c9 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009c9:	55                   	push   %ebp
c01009ca:	89 e5                	mov    %esp,%ebp
c01009cc:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009cf:	89 e8                	mov    %ebp,%eax
c01009d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009da:	e8 d9 ff ff ff       	call   c01009b8 <read_eip>
c01009df:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e9:	e9 88 00 00 00       	jmp    c0100a76 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fc:	c7 04 24 48 8c 10 c0 	movl   $0xc0108c48,(%esp)
c0100a03:	e8 43 f9 ff ff       	call   c010034b <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a0b:	83 c0 08             	add    $0x8,%eax
c0100a0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a11:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a18:	eb 25                	jmp    c0100a3f <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a1d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a27:	01 d0                	add    %edx,%eax
c0100a29:	8b 00                	mov    (%eax),%eax
c0100a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a2f:	c7 04 24 64 8c 10 c0 	movl   $0xc0108c64,(%esp)
c0100a36:	e8 10 f9 ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a3b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a3f:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a43:	7e d5                	jle    c0100a1a <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a45:	c7 04 24 6c 8c 10 c0 	movl   $0xc0108c6c,(%esp)
c0100a4c:	e8 fa f8 ff ff       	call   c010034b <cprintf>
        print_debuginfo(eip - 1);
c0100a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a54:	83 e8 01             	sub    $0x1,%eax
c0100a57:	89 04 24             	mov    %eax,(%esp)
c0100a5a:	e8 b6 fe ff ff       	call   c0100915 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a62:	83 c0 04             	add    $0x4,%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a72:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a7a:	74 0a                	je     c0100a86 <print_stackframe+0xbd>
c0100a7c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a80:	0f 8e 68 ff ff ff    	jle    c01009ee <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a86:	c9                   	leave  
c0100a87:	c3                   	ret    

c0100a88 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a88:	55                   	push   %ebp
c0100a89:	89 e5                	mov    %esp,%ebp
c0100a8b:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a8e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a95:	eb 0c                	jmp    c0100aa3 <parse+0x1b>
            *buf ++ = '\0';
c0100a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a9d:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa0:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa6:	0f b6 00             	movzbl (%eax),%eax
c0100aa9:	84 c0                	test   %al,%al
c0100aab:	74 1d                	je     c0100aca <parse+0x42>
c0100aad:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab0:	0f b6 00             	movzbl (%eax),%eax
c0100ab3:	0f be c0             	movsbl %al,%eax
c0100ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aba:	c7 04 24 f0 8c 10 c0 	movl   $0xc0108cf0,(%esp)
c0100ac1:	e8 aa 7c 00 00       	call   c0108770 <strchr>
c0100ac6:	85 c0                	test   %eax,%eax
c0100ac8:	75 cd                	jne    c0100a97 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aca:	8b 45 08             	mov    0x8(%ebp),%eax
c0100acd:	0f b6 00             	movzbl (%eax),%eax
c0100ad0:	84 c0                	test   %al,%al
c0100ad2:	75 02                	jne    c0100ad6 <parse+0x4e>
            break;
c0100ad4:	eb 67                	jmp    c0100b3d <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ad6:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ada:	75 14                	jne    c0100af0 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100adc:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ae3:	00 
c0100ae4:	c7 04 24 f5 8c 10 c0 	movl   $0xc0108cf5,(%esp)
c0100aeb:	e8 5b f8 ff ff       	call   c010034b <cprintf>
        }
        argv[argc ++] = buf;
c0100af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af3:	8d 50 01             	lea    0x1(%eax),%edx
c0100af6:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b03:	01 c2                	add    %eax,%edx
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b0a:	eb 04                	jmp    c0100b10 <parse+0x88>
            buf ++;
c0100b0c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b13:	0f b6 00             	movzbl (%eax),%eax
c0100b16:	84 c0                	test   %al,%al
c0100b18:	74 1d                	je     c0100b37 <parse+0xaf>
c0100b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1d:	0f b6 00             	movzbl (%eax),%eax
c0100b20:	0f be c0             	movsbl %al,%eax
c0100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b27:	c7 04 24 f0 8c 10 c0 	movl   $0xc0108cf0,(%esp)
c0100b2e:	e8 3d 7c 00 00       	call   c0108770 <strchr>
c0100b33:	85 c0                	test   %eax,%eax
c0100b35:	74 d5                	je     c0100b0c <parse+0x84>
            buf ++;
        }
    }
c0100b37:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b38:	e9 66 ff ff ff       	jmp    c0100aa3 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b40:	c9                   	leave  
c0100b41:	c3                   	ret    

c0100b42 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b42:	55                   	push   %ebp
c0100b43:	89 e5                	mov    %esp,%ebp
c0100b45:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b48:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	89 04 24             	mov    %eax,(%esp)
c0100b55:	e8 2e ff ff ff       	call   c0100a88 <parse>
c0100b5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b61:	75 0a                	jne    c0100b6d <runcmd+0x2b>
        return 0;
c0100b63:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b68:	e9 85 00 00 00       	jmp    c0100bf2 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b6d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b74:	eb 5c                	jmp    c0100bd2 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b76:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b7c:	89 d0                	mov    %edx,%eax
c0100b7e:	01 c0                	add    %eax,%eax
c0100b80:	01 d0                	add    %edx,%eax
c0100b82:	c1 e0 02             	shl    $0x2,%eax
c0100b85:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100b8a:	8b 00                	mov    (%eax),%eax
c0100b8c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b90:	89 04 24             	mov    %eax,(%esp)
c0100b93:	e8 39 7b 00 00       	call   c01086d1 <strcmp>
c0100b98:	85 c0                	test   %eax,%eax
c0100b9a:	75 32                	jne    c0100bce <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9f:	89 d0                	mov    %edx,%eax
c0100ba1:	01 c0                	add    %eax,%eax
c0100ba3:	01 d0                	add    %edx,%eax
c0100ba5:	c1 e0 02             	shl    $0x2,%eax
c0100ba8:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100bad:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bb3:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb9:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bbd:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc0:	83 c2 04             	add    $0x4,%edx
c0100bc3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bc7:	89 0c 24             	mov    %ecx,(%esp)
c0100bca:	ff d0                	call   *%eax
c0100bcc:	eb 24                	jmp    c0100bf2 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bd5:	83 f8 02             	cmp    $0x2,%eax
c0100bd8:	76 9c                	jbe    c0100b76 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be1:	c7 04 24 13 8d 10 c0 	movl   $0xc0108d13,(%esp)
c0100be8:	e8 5e f7 ff ff       	call   c010034b <cprintf>
    return 0;
c0100bed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf2:	c9                   	leave  
c0100bf3:	c3                   	ret    

c0100bf4 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bf4:	55                   	push   %ebp
c0100bf5:	89 e5                	mov    %esp,%ebp
c0100bf7:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bfa:	c7 04 24 2c 8d 10 c0 	movl   $0xc0108d2c,(%esp)
c0100c01:	e8 45 f7 ff ff       	call   c010034b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c06:	c7 04 24 54 8d 10 c0 	movl   $0xc0108d54,(%esp)
c0100c0d:	e8 39 f7 ff ff       	call   c010034b <cprintf>

    if (tf != NULL) {
c0100c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c16:	74 0b                	je     c0100c23 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c1b:	89 04 24             	mov    %eax,(%esp)
c0100c1e:	e8 26 16 00 00       	call   c0102249 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c23:	c7 04 24 79 8d 10 c0 	movl   $0xc0108d79,(%esp)
c0100c2a:	e8 13 f6 ff ff       	call   c0100242 <readline>
c0100c2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c36:	74 18                	je     c0100c50 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c42:	89 04 24             	mov    %eax,(%esp)
c0100c45:	e8 f8 fe ff ff       	call   c0100b42 <runcmd>
c0100c4a:	85 c0                	test   %eax,%eax
c0100c4c:	79 02                	jns    c0100c50 <kmonitor+0x5c>
                break;
c0100c4e:	eb 02                	jmp    c0100c52 <kmonitor+0x5e>
            }
        }
    }
c0100c50:	eb d1                	jmp    c0100c23 <kmonitor+0x2f>
}
c0100c52:	c9                   	leave  
c0100c53:	c3                   	ret    

c0100c54 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c54:	55                   	push   %ebp
c0100c55:	89 e5                	mov    %esp,%ebp
c0100c57:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c61:	eb 3f                	jmp    c0100ca2 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c63:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c66:	89 d0                	mov    %edx,%eax
c0100c68:	01 c0                	add    %eax,%eax
c0100c6a:	01 d0                	add    %edx,%eax
c0100c6c:	c1 e0 02             	shl    $0x2,%eax
c0100c6f:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c74:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c77:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c7a:	89 d0                	mov    %edx,%eax
c0100c7c:	01 c0                	add    %eax,%eax
c0100c7e:	01 d0                	add    %edx,%eax
c0100c80:	c1 e0 02             	shl    $0x2,%eax
c0100c83:	05 20 f0 11 c0       	add    $0xc011f020,%eax
c0100c88:	8b 00                	mov    (%eax),%eax
c0100c8a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c92:	c7 04 24 7d 8d 10 c0 	movl   $0xc0108d7d,(%esp)
c0100c99:	e8 ad f6 ff ff       	call   c010034b <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c9e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca5:	83 f8 02             	cmp    $0x2,%eax
c0100ca8:	76 b9                	jbe    c0100c63 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100caa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100caf:	c9                   	leave  
c0100cb0:	c3                   	ret    

c0100cb1 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb1:	55                   	push   %ebp
c0100cb2:	89 e5                	mov    %esp,%ebp
c0100cb4:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cb7:	e8 c3 fb ff ff       	call   c010087f <print_kerninfo>
    return 0;
c0100cbc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc1:	c9                   	leave  
c0100cc2:	c3                   	ret    

c0100cc3 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cc3:	55                   	push   %ebp
c0100cc4:	89 e5                	mov    %esp,%ebp
c0100cc6:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc9:	e8 fb fc ff ff       	call   c01009c9 <print_stackframe>
    return 0;
c0100cce:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd3:	c9                   	leave  
c0100cd4:	c3                   	ret    

c0100cd5 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cd5:	55                   	push   %ebp
c0100cd6:	89 e5                	mov    %esp,%ebp
c0100cd8:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cdb:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
c0100ce0:	85 c0                	test   %eax,%eax
c0100ce2:	74 02                	je     c0100ce6 <__panic+0x11>
        goto panic_dead;
c0100ce4:	eb 48                	jmp    c0100d2e <__panic+0x59>
    }
    is_panic = 1;
c0100ce6:	c7 05 a0 fe 11 c0 01 	movl   $0x1,0xc011fea0
c0100ced:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf0:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d04:	c7 04 24 86 8d 10 c0 	movl   $0xc0108d86,(%esp)
c0100d0b:	e8 3b f6 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d17:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d1a:	89 04 24             	mov    %eax,(%esp)
c0100d1d:	e8 f6 f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d22:	c7 04 24 a2 8d 10 c0 	movl   $0xc0108da2,(%esp)
c0100d29:	e8 1d f6 ff ff       	call   c010034b <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d2e:	e8 fa 11 00 00       	call   c0101f2d <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d3a:	e8 b5 fe ff ff       	call   c0100bf4 <kmonitor>
    }
c0100d3f:	eb f2                	jmp    c0100d33 <__panic+0x5e>

c0100d41 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d41:	55                   	push   %ebp
c0100d42:	89 e5                	mov    %esp,%ebp
c0100d44:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d47:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d50:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d54:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5b:	c7 04 24 a4 8d 10 c0 	movl   $0xc0108da4,(%esp)
c0100d62:	e8 e4 f5 ff ff       	call   c010034b <cprintf>
    vcprintf(fmt, ap);
c0100d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d6e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d71:	89 04 24             	mov    %eax,(%esp)
c0100d74:	e8 9f f5 ff ff       	call   c0100318 <vcprintf>
    cprintf("\n");
c0100d79:	c7 04 24 a2 8d 10 c0 	movl   $0xc0108da2,(%esp)
c0100d80:	e8 c6 f5 ff ff       	call   c010034b <cprintf>
    va_end(ap);
}
c0100d85:	c9                   	leave  
c0100d86:	c3                   	ret    

c0100d87 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d87:	55                   	push   %ebp
c0100d88:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d8a:	a1 a0 fe 11 c0       	mov    0xc011fea0,%eax
}
c0100d8f:	5d                   	pop    %ebp
c0100d90:	c3                   	ret    

c0100d91 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d91:	55                   	push   %ebp
c0100d92:	89 e5                	mov    %esp,%ebp
c0100d94:	83 ec 28             	sub    $0x28,%esp
c0100d97:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d9d:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100da5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da9:	ee                   	out    %al,(%dx)
c0100daa:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db0:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100db4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dbc:	ee                   	out    %al,(%dx)
c0100dbd:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dc3:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dc7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dcb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dcf:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd0:	c7 05 bc 0a 12 c0 00 	movl   $0x0,0xc0120abc
c0100dd7:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dda:	c7 04 24 c2 8d 10 c0 	movl   $0xc0108dc2,(%esp)
c0100de1:	e8 65 f5 ff ff       	call   c010034b <cprintf>
    pic_enable(IRQ_TIMER);
c0100de6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ded:	e8 99 11 00 00       	call   c0101f8b <pic_enable>
}
c0100df2:	c9                   	leave  
c0100df3:	c3                   	ret    

c0100df4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100df4:	55                   	push   %ebp
c0100df5:	89 e5                	mov    %esp,%ebp
c0100df7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dfa:	9c                   	pushf  
c0100dfb:	58                   	pop    %eax
c0100dfc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e02:	25 00 02 00 00       	and    $0x200,%eax
c0100e07:	85 c0                	test   %eax,%eax
c0100e09:	74 0c                	je     c0100e17 <__intr_save+0x23>
        intr_disable();
c0100e0b:	e8 1d 11 00 00       	call   c0101f2d <intr_disable>
        return 1;
c0100e10:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e15:	eb 05                	jmp    c0100e1c <__intr_save+0x28>
    }
    return 0;
c0100e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e1c:	c9                   	leave  
c0100e1d:	c3                   	ret    

c0100e1e <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e1e:	55                   	push   %ebp
c0100e1f:	89 e5                	mov    %esp,%ebp
c0100e21:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e28:	74 05                	je     c0100e2f <__intr_restore+0x11>
        intr_enable();
c0100e2a:	e8 f8 10 00 00       	call   c0101f27 <intr_enable>
    }
}
c0100e2f:	c9                   	leave  
c0100e30:	c3                   	ret    

c0100e31 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e31:	55                   	push   %ebp
c0100e32:	89 e5                	mov    %esp,%ebp
c0100e34:	83 ec 10             	sub    $0x10,%esp
c0100e37:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e3d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e41:	89 c2                	mov    %eax,%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e47:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e4d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e51:	89 c2                	mov    %eax,%edx
c0100e53:	ec                   	in     (%dx),%al
c0100e54:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e57:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e5d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e61:	89 c2                	mov    %eax,%edx
c0100e63:	ec                   	in     (%dx),%al
c0100e64:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e67:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e6d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e71:	89 c2                	mov    %eax,%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e77:	c9                   	leave  
c0100e78:	c3                   	ret    

c0100e79 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e79:	55                   	push   %ebp
c0100e7a:	89 e5                	mov    %esp,%ebp
c0100e7c:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e7f:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e86:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e89:	0f b7 00             	movzwl (%eax),%eax
c0100e8c:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	0f b7 00             	movzwl (%eax),%eax
c0100e9e:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea2:	74 12                	je     c0100eb6 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ea4:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eab:	66 c7 05 c6 fe 11 c0 	movw   $0x3b4,0xc011fec6
c0100eb2:	b4 03 
c0100eb4:	eb 13                	jmp    c0100ec9 <cga_init+0x50>
    } else {
        *cp = was;
c0100eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb9:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ebd:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec0:	66 c7 05 c6 fe 11 c0 	movw   $0x3d4,0xc011fec6
c0100ec7:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec9:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100ed0:	0f b7 c0             	movzwl %ax,%eax
c0100ed3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ed7:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100edb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100edf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ee3:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ee4:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100eeb:	83 c0 01             	add    $0x1,%eax
c0100eee:	0f b7 c0             	movzwl %ax,%eax
c0100ef1:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ef5:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef9:	89 c2                	mov    %eax,%edx
c0100efb:	ec                   	in     (%dx),%al
c0100efc:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100eff:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f03:	0f b6 c0             	movzbl %al,%eax
c0100f06:	c1 e0 08             	shl    $0x8,%eax
c0100f09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f0c:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f13:	0f b7 c0             	movzwl %ax,%eax
c0100f16:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f1a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f1e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f22:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f26:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f27:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0100f2e:	83 c0 01             	add    $0x1,%eax
c0100f31:	0f b7 c0             	movzwl %ax,%eax
c0100f34:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f38:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f3c:	89 c2                	mov    %eax,%edx
c0100f3e:	ec                   	in     (%dx),%al
c0100f3f:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f42:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f46:	0f b6 c0             	movzbl %al,%eax
c0100f49:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f4f:	a3 c0 fe 11 c0       	mov    %eax,0xc011fec0
    crt_pos = pos;
c0100f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f57:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
}
c0100f5d:	c9                   	leave  
c0100f5e:	c3                   	ret    

c0100f5f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f5f:	55                   	push   %ebp
c0100f60:	89 e5                	mov    %esp,%ebp
c0100f62:	83 ec 48             	sub    $0x48,%esp
c0100f65:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f6b:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f6f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f73:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f77:	ee                   	out    %al,(%dx)
c0100f78:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f7e:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f82:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f8a:	ee                   	out    %al,(%dx)
c0100f8b:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f91:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f9d:	ee                   	out    %al,(%dx)
c0100f9e:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fa4:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb0:	ee                   	out    %al,(%dx)
c0100fb1:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fb7:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fbb:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fbf:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fc3:	ee                   	out    %al,(%dx)
c0100fc4:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fca:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fce:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fd2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fd6:	ee                   	out    %al,(%dx)
c0100fd7:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fdd:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe1:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fe5:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe9:	ee                   	out    %al,(%dx)
c0100fea:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff0:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ff4:	89 c2                	mov    %eax,%edx
c0100ff6:	ec                   	in     (%dx),%al
c0100ff7:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ffa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ffe:	3c ff                	cmp    $0xff,%al
c0101000:	0f 95 c0             	setne  %al
c0101003:	0f b6 c0             	movzbl %al,%eax
c0101006:	a3 c8 fe 11 c0       	mov    %eax,0xc011fec8
c010100b:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101011:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101015:	89 c2                	mov    %eax,%edx
c0101017:	ec                   	in     (%dx),%al
c0101018:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010101b:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101021:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101025:	89 c2                	mov    %eax,%edx
c0101027:	ec                   	in     (%dx),%al
c0101028:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010102b:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0101030:	85 c0                	test   %eax,%eax
c0101032:	74 0c                	je     c0101040 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101034:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010103b:	e8 4b 0f 00 00       	call   c0101f8b <pic_enable>
    }
}
c0101040:	c9                   	leave  
c0101041:	c3                   	ret    

c0101042 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101042:	55                   	push   %ebp
c0101043:	89 e5                	mov    %esp,%ebp
c0101045:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101048:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010104f:	eb 09                	jmp    c010105a <lpt_putc_sub+0x18>
        delay();
c0101051:	e8 db fd ff ff       	call   c0100e31 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101056:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010105a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101060:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101064:	89 c2                	mov    %eax,%edx
c0101066:	ec                   	in     (%dx),%al
c0101067:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010106a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010106e:	84 c0                	test   %al,%al
c0101070:	78 09                	js     c010107b <lpt_putc_sub+0x39>
c0101072:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101079:	7e d6                	jle    c0101051 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010107b:	8b 45 08             	mov    0x8(%ebp),%eax
c010107e:	0f b6 c0             	movzbl %al,%eax
c0101081:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101087:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010108a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010108e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101092:	ee                   	out    %al,(%dx)
c0101093:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101099:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010109d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010a5:	ee                   	out    %al,(%dx)
c01010a6:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ac:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010b4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b8:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b9:	c9                   	leave  
c01010ba:	c3                   	ret    

c01010bb <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010bb:	55                   	push   %ebp
c01010bc:	89 e5                	mov    %esp,%ebp
c01010be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010c5:	74 0d                	je     c01010d4 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ca:	89 04 24             	mov    %eax,(%esp)
c01010cd:	e8 70 ff ff ff       	call   c0101042 <lpt_putc_sub>
c01010d2:	eb 24                	jmp    c01010f8 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010db:	e8 62 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010e7:	e8 56 ff ff ff       	call   c0101042 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f3:	e8 4a ff ff ff       	call   c0101042 <lpt_putc_sub>
    }
}
c01010f8:	c9                   	leave  
c01010f9:	c3                   	ret    

c01010fa <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010fa:	55                   	push   %ebp
c01010fb:	89 e5                	mov    %esp,%ebp
c01010fd:	53                   	push   %ebx
c01010fe:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101101:	8b 45 08             	mov    0x8(%ebp),%eax
c0101104:	b0 00                	mov    $0x0,%al
c0101106:	85 c0                	test   %eax,%eax
c0101108:	75 07                	jne    c0101111 <cga_putc+0x17>
        c |= 0x0700;
c010110a:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101111:	8b 45 08             	mov    0x8(%ebp),%eax
c0101114:	0f b6 c0             	movzbl %al,%eax
c0101117:	83 f8 0a             	cmp    $0xa,%eax
c010111a:	74 4c                	je     c0101168 <cga_putc+0x6e>
c010111c:	83 f8 0d             	cmp    $0xd,%eax
c010111f:	74 57                	je     c0101178 <cga_putc+0x7e>
c0101121:	83 f8 08             	cmp    $0x8,%eax
c0101124:	0f 85 88 00 00 00    	jne    c01011b2 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010112a:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101131:	66 85 c0             	test   %ax,%ax
c0101134:	74 30                	je     c0101166 <cga_putc+0x6c>
            crt_pos --;
c0101136:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010113d:	83 e8 01             	sub    $0x1,%eax
c0101140:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101146:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c010114b:	0f b7 15 c4 fe 11 c0 	movzwl 0xc011fec4,%edx
c0101152:	0f b7 d2             	movzwl %dx,%edx
c0101155:	01 d2                	add    %edx,%edx
c0101157:	01 c2                	add    %eax,%edx
c0101159:	8b 45 08             	mov    0x8(%ebp),%eax
c010115c:	b0 00                	mov    $0x0,%al
c010115e:	83 c8 20             	or     $0x20,%eax
c0101161:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101164:	eb 72                	jmp    c01011d8 <cga_putc+0xde>
c0101166:	eb 70                	jmp    c01011d8 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101168:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c010116f:	83 c0 50             	add    $0x50,%eax
c0101172:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101178:	0f b7 1d c4 fe 11 c0 	movzwl 0xc011fec4,%ebx
c010117f:	0f b7 0d c4 fe 11 c0 	movzwl 0xc011fec4,%ecx
c0101186:	0f b7 c1             	movzwl %cx,%eax
c0101189:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c010118f:	c1 e8 10             	shr    $0x10,%eax
c0101192:	89 c2                	mov    %eax,%edx
c0101194:	66 c1 ea 06          	shr    $0x6,%dx
c0101198:	89 d0                	mov    %edx,%eax
c010119a:	c1 e0 02             	shl    $0x2,%eax
c010119d:	01 d0                	add    %edx,%eax
c010119f:	c1 e0 04             	shl    $0x4,%eax
c01011a2:	29 c1                	sub    %eax,%ecx
c01011a4:	89 ca                	mov    %ecx,%edx
c01011a6:	89 d8                	mov    %ebx,%eax
c01011a8:	29 d0                	sub    %edx,%eax
c01011aa:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
        break;
c01011b0:	eb 26                	jmp    c01011d8 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011b2:	8b 0d c0 fe 11 c0    	mov    0xc011fec0,%ecx
c01011b8:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011bf:	8d 50 01             	lea    0x1(%eax),%edx
c01011c2:	66 89 15 c4 fe 11 c0 	mov    %dx,0xc011fec4
c01011c9:	0f b7 c0             	movzwl %ax,%eax
c01011cc:	01 c0                	add    %eax,%eax
c01011ce:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01011d4:	66 89 02             	mov    %ax,(%edx)
        break;
c01011d7:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d8:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01011df:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011e3:	76 5b                	jbe    c0101240 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011e5:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011ea:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f0:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c01011f5:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011fc:	00 
c01011fd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101201:	89 04 24             	mov    %eax,(%esp)
c0101204:	e8 65 77 00 00       	call   c010896e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101209:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101210:	eb 15                	jmp    c0101227 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101212:	a1 c0 fe 11 c0       	mov    0xc011fec0,%eax
c0101217:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010121a:	01 d2                	add    %edx,%edx
c010121c:	01 d0                	add    %edx,%eax
c010121e:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101223:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101227:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010122e:	7e e2                	jle    c0101212 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101230:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101237:	83 e8 50             	sub    $0x50,%eax
c010123a:	66 a3 c4 fe 11 c0    	mov    %ax,0xc011fec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101240:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c0101247:	0f b7 c0             	movzwl %ax,%eax
c010124a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010124e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101252:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101256:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010125a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010125b:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c0101262:	66 c1 e8 08          	shr    $0x8,%ax
c0101266:	0f b6 c0             	movzbl %al,%eax
c0101269:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c0101270:	83 c2 01             	add    $0x1,%edx
c0101273:	0f b7 d2             	movzwl %dx,%edx
c0101276:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010127a:	88 45 ed             	mov    %al,-0x13(%ebp)
c010127d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101281:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101285:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101286:	0f b7 05 c6 fe 11 c0 	movzwl 0xc011fec6,%eax
c010128d:	0f b7 c0             	movzwl %ax,%eax
c0101290:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101294:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101298:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010129c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a0:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a1:	0f b7 05 c4 fe 11 c0 	movzwl 0xc011fec4,%eax
c01012a8:	0f b6 c0             	movzbl %al,%eax
c01012ab:	0f b7 15 c6 fe 11 c0 	movzwl 0xc011fec6,%edx
c01012b2:	83 c2 01             	add    $0x1,%edx
c01012b5:	0f b7 d2             	movzwl %dx,%edx
c01012b8:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012bc:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012bf:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012c3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012c7:	ee                   	out    %al,(%dx)
}
c01012c8:	83 c4 34             	add    $0x34,%esp
c01012cb:	5b                   	pop    %ebx
c01012cc:	5d                   	pop    %ebp
c01012cd:	c3                   	ret    

c01012ce <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012ce:	55                   	push   %ebp
c01012cf:	89 e5                	mov    %esp,%ebp
c01012d1:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012db:	eb 09                	jmp    c01012e6 <serial_putc_sub+0x18>
        delay();
c01012dd:	e8 4f fb ff ff       	call   c0100e31 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012e6:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012ec:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f0:	89 c2                	mov    %eax,%edx
c01012f2:	ec                   	in     (%dx),%al
c01012f3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012f6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012fa:	0f b6 c0             	movzbl %al,%eax
c01012fd:	83 e0 20             	and    $0x20,%eax
c0101300:	85 c0                	test   %eax,%eax
c0101302:	75 09                	jne    c010130d <serial_putc_sub+0x3f>
c0101304:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010130b:	7e d0                	jle    c01012dd <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c010130d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101310:	0f b6 c0             	movzbl %al,%eax
c0101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101319:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010131c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101320:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101324:	ee                   	out    %al,(%dx)
}
c0101325:	c9                   	leave  
c0101326:	c3                   	ret    

c0101327 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101327:	55                   	push   %ebp
c0101328:	89 e5                	mov    %esp,%ebp
c010132a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010132d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101331:	74 0d                	je     c0101340 <serial_putc+0x19>
        serial_putc_sub(c);
c0101333:	8b 45 08             	mov    0x8(%ebp),%eax
c0101336:	89 04 24             	mov    %eax,(%esp)
c0101339:	e8 90 ff ff ff       	call   c01012ce <serial_putc_sub>
c010133e:	eb 24                	jmp    c0101364 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101340:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101347:	e8 82 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub(' ');
c010134c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101353:	e8 76 ff ff ff       	call   c01012ce <serial_putc_sub>
        serial_putc_sub('\b');
c0101358:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010135f:	e8 6a ff ff ff       	call   c01012ce <serial_putc_sub>
    }
}
c0101364:	c9                   	leave  
c0101365:	c3                   	ret    

c0101366 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101366:	55                   	push   %ebp
c0101367:	89 e5                	mov    %esp,%ebp
c0101369:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010136c:	eb 33                	jmp    c01013a1 <cons_intr+0x3b>
        if (c != 0) {
c010136e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101372:	74 2d                	je     c01013a1 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101374:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101379:	8d 50 01             	lea    0x1(%eax),%edx
c010137c:	89 15 e4 00 12 c0    	mov    %edx,0xc01200e4
c0101382:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101385:	88 90 e0 fe 11 c0    	mov    %dl,-0x3fee0120(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010138b:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c0101390:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101395:	75 0a                	jne    c01013a1 <cons_intr+0x3b>
                cons.wpos = 0;
c0101397:	c7 05 e4 00 12 c0 00 	movl   $0x0,0xc01200e4
c010139e:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a4:	ff d0                	call   *%eax
c01013a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013ad:	75 bf                	jne    c010136e <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013af:	c9                   	leave  
c01013b0:	c3                   	ret    

c01013b1 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b1:	55                   	push   %ebp
c01013b2:	89 e5                	mov    %esp,%ebp
c01013b4:	83 ec 10             	sub    $0x10,%esp
c01013b7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013bd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c1:	89 c2                	mov    %eax,%edx
c01013c3:	ec                   	in     (%dx),%al
c01013c4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013c7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013cb:	0f b6 c0             	movzbl %al,%eax
c01013ce:	83 e0 01             	and    $0x1,%eax
c01013d1:	85 c0                	test   %eax,%eax
c01013d3:	75 07                	jne    c01013dc <serial_proc_data+0x2b>
        return -1;
c01013d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013da:	eb 2a                	jmp    c0101406 <serial_proc_data+0x55>
c01013dc:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013e2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013e6:	89 c2                	mov    %eax,%edx
c01013e8:	ec                   	in     (%dx),%al
c01013e9:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013ec:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f0:	0f b6 c0             	movzbl %al,%eax
c01013f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013f6:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013fa:	75 07                	jne    c0101403 <serial_proc_data+0x52>
        c = '\b';
c01013fc:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c0101403:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0101406:	c9                   	leave  
c0101407:	c3                   	ret    

c0101408 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101408:	55                   	push   %ebp
c0101409:	89 e5                	mov    %esp,%ebp
c010140b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010140e:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c0101413:	85 c0                	test   %eax,%eax
c0101415:	74 0c                	je     c0101423 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101417:	c7 04 24 b1 13 10 c0 	movl   $0xc01013b1,(%esp)
c010141e:	e8 43 ff ff ff       	call   c0101366 <cons_intr>
    }
}
c0101423:	c9                   	leave  
c0101424:	c3                   	ret    

c0101425 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101425:	55                   	push   %ebp
c0101426:	89 e5                	mov    %esp,%ebp
c0101428:	83 ec 38             	sub    $0x38,%esp
c010142b:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101431:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101435:	89 c2                	mov    %eax,%edx
c0101437:	ec                   	in     (%dx),%al
c0101438:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010143b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c010143f:	0f b6 c0             	movzbl %al,%eax
c0101442:	83 e0 01             	and    $0x1,%eax
c0101445:	85 c0                	test   %eax,%eax
c0101447:	75 0a                	jne    c0101453 <kbd_proc_data+0x2e>
        return -1;
c0101449:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144e:	e9 59 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
c0101453:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101459:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010145d:	89 c2                	mov    %eax,%edx
c010145f:	ec                   	in     (%dx),%al
c0101460:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101463:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101467:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010146a:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010146e:	75 17                	jne    c0101487 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101470:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101475:	83 c8 40             	or     $0x40,%eax
c0101478:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c010147d:	b8 00 00 00 00       	mov    $0x0,%eax
c0101482:	e9 25 01 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010148b:	84 c0                	test   %al,%al
c010148d:	79 47                	jns    c01014d6 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010148f:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101494:	83 e0 40             	and    $0x40,%eax
c0101497:	85 c0                	test   %eax,%eax
c0101499:	75 09                	jne    c01014a4 <kbd_proc_data+0x7f>
c010149b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149f:	83 e0 7f             	and    $0x7f,%eax
c01014a2:	eb 04                	jmp    c01014a8 <kbd_proc_data+0x83>
c01014a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a8:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014ab:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014af:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01014b6:	83 c8 40             	or     $0x40,%eax
c01014b9:	0f b6 c0             	movzbl %al,%eax
c01014bc:	f7 d0                	not    %eax
c01014be:	89 c2                	mov    %eax,%edx
c01014c0:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014c5:	21 d0                	and    %edx,%eax
c01014c7:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
        return 0;
c01014cc:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d1:	e9 d6 00 00 00       	jmp    c01015ac <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014d6:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014db:	83 e0 40             	and    $0x40,%eax
c01014de:	85 c0                	test   %eax,%eax
c01014e0:	74 11                	je     c01014f3 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014e2:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014e6:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c01014eb:	83 e0 bf             	and    $0xffffffbf,%eax
c01014ee:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    }

    shift |= shiftcode[data];
c01014f3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014f7:	0f b6 80 60 f0 11 c0 	movzbl -0x3fee0fa0(%eax),%eax
c01014fe:	0f b6 d0             	movzbl %al,%edx
c0101501:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101506:	09 d0                	or     %edx,%eax
c0101508:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8
    shift ^= togglecode[data];
c010150d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101511:	0f b6 80 60 f1 11 c0 	movzbl -0x3fee0ea0(%eax),%eax
c0101518:	0f b6 d0             	movzbl %al,%edx
c010151b:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101520:	31 d0                	xor    %edx,%eax
c0101522:	a3 e8 00 12 c0       	mov    %eax,0xc01200e8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101527:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010152c:	83 e0 03             	and    $0x3,%eax
c010152f:	8b 14 85 60 f5 11 c0 	mov    -0x3fee0aa0(,%eax,4),%edx
c0101536:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153a:	01 d0                	add    %edx,%eax
c010153c:	0f b6 00             	movzbl (%eax),%eax
c010153f:	0f b6 c0             	movzbl %al,%eax
c0101542:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101545:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c010154a:	83 e0 08             	and    $0x8,%eax
c010154d:	85 c0                	test   %eax,%eax
c010154f:	74 22                	je     c0101573 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101551:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101555:	7e 0c                	jle    c0101563 <kbd_proc_data+0x13e>
c0101557:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010155b:	7f 06                	jg     c0101563 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010155d:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101561:	eb 10                	jmp    c0101573 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101563:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101567:	7e 0a                	jle    c0101573 <kbd_proc_data+0x14e>
c0101569:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010156d:	7f 04                	jg     c0101573 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c010156f:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101573:	a1 e8 00 12 c0       	mov    0xc01200e8,%eax
c0101578:	f7 d0                	not    %eax
c010157a:	83 e0 06             	and    $0x6,%eax
c010157d:	85 c0                	test   %eax,%eax
c010157f:	75 28                	jne    c01015a9 <kbd_proc_data+0x184>
c0101581:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101588:	75 1f                	jne    c01015a9 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010158a:	c7 04 24 dd 8d 10 c0 	movl   $0xc0108ddd,(%esp)
c0101591:	e8 b5 ed ff ff       	call   c010034b <cprintf>
c0101596:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010159c:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a0:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015a4:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a8:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015ac:	c9                   	leave  
c01015ad:	c3                   	ret    

c01015ae <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015ae:	55                   	push   %ebp
c01015af:	89 e5                	mov    %esp,%ebp
c01015b1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015b4:	c7 04 24 25 14 10 c0 	movl   $0xc0101425,(%esp)
c01015bb:	e8 a6 fd ff ff       	call   c0101366 <cons_intr>
}
c01015c0:	c9                   	leave  
c01015c1:	c3                   	ret    

c01015c2 <kbd_init>:

static void
kbd_init(void) {
c01015c2:	55                   	push   %ebp
c01015c3:	89 e5                	mov    %esp,%ebp
c01015c5:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c8:	e8 e1 ff ff ff       	call   c01015ae <kbd_intr>
    pic_enable(IRQ_KBD);
c01015cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015d4:	e8 b2 09 00 00       	call   c0101f8b <pic_enable>
}
c01015d9:	c9                   	leave  
c01015da:	c3                   	ret    

c01015db <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015db:	55                   	push   %ebp
c01015dc:	89 e5                	mov    %esp,%ebp
c01015de:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e1:	e8 93 f8 ff ff       	call   c0100e79 <cga_init>
    serial_init();
c01015e6:	e8 74 f9 ff ff       	call   c0100f5f <serial_init>
    kbd_init();
c01015eb:	e8 d2 ff ff ff       	call   c01015c2 <kbd_init>
    if (!serial_exists) {
c01015f0:	a1 c8 fe 11 c0       	mov    0xc011fec8,%eax
c01015f5:	85 c0                	test   %eax,%eax
c01015f7:	75 0c                	jne    c0101605 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f9:	c7 04 24 e9 8d 10 c0 	movl   $0xc0108de9,(%esp)
c0101600:	e8 46 ed ff ff       	call   c010034b <cprintf>
    }
}
c0101605:	c9                   	leave  
c0101606:	c3                   	ret    

c0101607 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101607:	55                   	push   %ebp
c0101608:	89 e5                	mov    %esp,%ebp
c010160a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010160d:	e8 e2 f7 ff ff       	call   c0100df4 <__intr_save>
c0101612:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101615:	8b 45 08             	mov    0x8(%ebp),%eax
c0101618:	89 04 24             	mov    %eax,(%esp)
c010161b:	e8 9b fa ff ff       	call   c01010bb <lpt_putc>
        cga_putc(c);
c0101620:	8b 45 08             	mov    0x8(%ebp),%eax
c0101623:	89 04 24             	mov    %eax,(%esp)
c0101626:	e8 cf fa ff ff       	call   c01010fa <cga_putc>
        serial_putc(c);
c010162b:	8b 45 08             	mov    0x8(%ebp),%eax
c010162e:	89 04 24             	mov    %eax,(%esp)
c0101631:	e8 f1 fc ff ff       	call   c0101327 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101639:	89 04 24             	mov    %eax,(%esp)
c010163c:	e8 dd f7 ff ff       	call   c0100e1e <__intr_restore>
}
c0101641:	c9                   	leave  
c0101642:	c3                   	ret    

c0101643 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101649:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101650:	e8 9f f7 ff ff       	call   c0100df4 <__intr_save>
c0101655:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101658:	e8 ab fd ff ff       	call   c0101408 <serial_intr>
        kbd_intr();
c010165d:	e8 4c ff ff ff       	call   c01015ae <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101662:	8b 15 e0 00 12 c0    	mov    0xc01200e0,%edx
c0101668:	a1 e4 00 12 c0       	mov    0xc01200e4,%eax
c010166d:	39 c2                	cmp    %eax,%edx
c010166f:	74 31                	je     c01016a2 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101671:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c0101676:	8d 50 01             	lea    0x1(%eax),%edx
c0101679:	89 15 e0 00 12 c0    	mov    %edx,0xc01200e0
c010167f:	0f b6 80 e0 fe 11 c0 	movzbl -0x3fee0120(%eax),%eax
c0101686:	0f b6 c0             	movzbl %al,%eax
c0101689:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010168c:	a1 e0 00 12 c0       	mov    0xc01200e0,%eax
c0101691:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101696:	75 0a                	jne    c01016a2 <cons_getc+0x5f>
                cons.rpos = 0;
c0101698:	c7 05 e0 00 12 c0 00 	movl   $0x0,0xc01200e0
c010169f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016a5:	89 04 24             	mov    %eax,(%esp)
c01016a8:	e8 71 f7 ff ff       	call   c0100e1e <__intr_restore>
    return c;
c01016ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b0:	c9                   	leave  
c01016b1:	c3                   	ret    

c01016b2 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016b2:	55                   	push   %ebp
c01016b3:	89 e5                	mov    %esp,%ebp
c01016b5:	83 ec 14             	sub    $0x14,%esp
c01016b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016bf:	90                   	nop
c01016c0:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c4:	83 c0 07             	add    $0x7,%eax
c01016c7:	0f b7 c0             	movzwl %ax,%eax
c01016ca:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016ce:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016d2:	89 c2                	mov    %eax,%edx
c01016d4:	ec                   	in     (%dx),%al
c01016d5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016d8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016dc:	0f b6 c0             	movzbl %al,%eax
c01016df:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016e5:	25 80 00 00 00       	and    $0x80,%eax
c01016ea:	85 c0                	test   %eax,%eax
c01016ec:	75 d2                	jne    c01016c0 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016f2:	74 11                	je     c0101705 <ide_wait_ready+0x53>
c01016f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016f7:	83 e0 21             	and    $0x21,%eax
c01016fa:	85 c0                	test   %eax,%eax
c01016fc:	74 07                	je     c0101705 <ide_wait_ready+0x53>
        return -1;
c01016fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101703:	eb 05                	jmp    c010170a <ide_wait_ready+0x58>
    }
    return 0;
c0101705:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010170a:	c9                   	leave  
c010170b:	c3                   	ret    

c010170c <ide_init>:

void
ide_init(void) {
c010170c:	55                   	push   %ebp
c010170d:	89 e5                	mov    %esp,%ebp
c010170f:	57                   	push   %edi
c0101710:	53                   	push   %ebx
c0101711:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101717:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c010171d:	e9 d6 02 00 00       	jmp    c01019f8 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c0101722:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101726:	c1 e0 03             	shl    $0x3,%eax
c0101729:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101730:	29 c2                	sub    %eax,%edx
c0101732:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101738:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c010173b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010173f:	66 d1 e8             	shr    %ax
c0101742:	0f b7 c0             	movzwl %ax,%eax
c0101745:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c010174c:	c0 
c010174d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101751:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101755:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010175c:	00 
c010175d:	89 04 24             	mov    %eax,(%esp)
c0101760:	e8 4d ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101765:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101769:	83 e0 01             	and    $0x1,%eax
c010176c:	c1 e0 04             	shl    $0x4,%eax
c010176f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101772:	0f b6 c0             	movzbl %al,%eax
c0101775:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101779:	83 c2 06             	add    $0x6,%edx
c010177c:	0f b7 d2             	movzwl %dx,%edx
c010177f:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101783:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101786:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010178a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010178e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010178f:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101793:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010179a:	00 
c010179b:	89 04 24             	mov    %eax,(%esp)
c010179e:	e8 0f ff ff ff       	call   c01016b2 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017a3:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017a7:	83 c0 07             	add    $0x7,%eax
c01017aa:	0f b7 c0             	movzwl %ax,%eax
c01017ad:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b1:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017b5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017b9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017be:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017c9:	00 
c01017ca:	89 04 24             	mov    %eax,(%esp)
c01017cd:	e8 e0 fe ff ff       	call   c01016b2 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017d2:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017d6:	83 c0 07             	add    $0x7,%eax
c01017d9:	0f b7 c0             	movzwl %ax,%eax
c01017dc:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e0:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017e4:	89 c2                	mov    %eax,%edx
c01017e6:	ec                   	in     (%dx),%al
c01017e7:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017ea:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017ee:	84 c0                	test   %al,%al
c01017f0:	0f 84 f7 01 00 00    	je     c01019ed <ide_init+0x2e1>
c01017f6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101801:	00 
c0101802:	89 04 24             	mov    %eax,(%esp)
c0101805:	e8 a8 fe ff ff       	call   c01016b2 <ide_wait_ready>
c010180a:	85 c0                	test   %eax,%eax
c010180c:	0f 85 db 01 00 00    	jne    c01019ed <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c0101812:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101816:	c1 e0 03             	shl    $0x3,%eax
c0101819:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101820:	29 c2                	sub    %eax,%edx
c0101822:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101828:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c010182b:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010182f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c0101832:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101838:	89 45 c0             	mov    %eax,-0x40(%ebp)
c010183b:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101842:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0101845:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101848:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010184b:	89 cb                	mov    %ecx,%ebx
c010184d:	89 df                	mov    %ebx,%edi
c010184f:	89 c1                	mov    %eax,%ecx
c0101851:	fc                   	cld    
c0101852:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101854:	89 c8                	mov    %ecx,%eax
c0101856:	89 fb                	mov    %edi,%ebx
c0101858:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c010185b:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c010185e:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010186a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101870:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101873:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101876:	25 00 00 00 04       	and    $0x4000000,%eax
c010187b:	85 c0                	test   %eax,%eax
c010187d:	74 0e                	je     c010188d <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c010187f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101882:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101888:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010188b:	eb 09                	jmp    c0101896 <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010188d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101890:	8b 40 78             	mov    0x78(%eax),%eax
c0101893:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101896:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010189a:	c1 e0 03             	shl    $0x3,%eax
c010189d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018a4:	29 c2                	sub    %eax,%edx
c01018a6:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018af:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018b2:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018b6:	c1 e0 03             	shl    $0x3,%eax
c01018b9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c0:	29 c2                	sub    %eax,%edx
c01018c2:	81 c2 00 01 12 c0    	add    $0xc0120100,%edx
c01018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018cb:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d1:	83 c0 62             	add    $0x62,%eax
c01018d4:	0f b7 00             	movzwl (%eax),%eax
c01018d7:	0f b7 c0             	movzwl %ax,%eax
c01018da:	25 00 02 00 00       	and    $0x200,%eax
c01018df:	85 c0                	test   %eax,%eax
c01018e1:	75 24                	jne    c0101907 <ide_init+0x1fb>
c01018e3:	c7 44 24 0c 10 8e 10 	movl   $0xc0108e10,0xc(%esp)
c01018ea:	c0 
c01018eb:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01018fa:	00 
c01018fb:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101902:	e8 ce f3 ff ff       	call   c0100cd5 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101907:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010190b:	c1 e0 03             	shl    $0x3,%eax
c010190e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101915:	29 c2                	sub    %eax,%edx
c0101917:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c010191d:	83 c0 0c             	add    $0xc,%eax
c0101920:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0101923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101926:	83 c0 36             	add    $0x36,%eax
c0101929:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c010192c:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101933:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010193a:	eb 34                	jmp    c0101970 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c010193c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010193f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101942:	01 c2                	add    %eax,%edx
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8d 48 01             	lea    0x1(%eax),%ecx
c010194a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010194d:	01 c8                	add    %ecx,%eax
c010194f:	0f b6 00             	movzbl (%eax),%eax
c0101952:	88 02                	mov    %al,(%edx)
c0101954:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101957:	8d 50 01             	lea    0x1(%eax),%edx
c010195a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010195d:	01 c2                	add    %eax,%edx
c010195f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101962:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c0101965:	01 c8                	add    %ecx,%eax
c0101967:	0f b6 00             	movzbl (%eax),%eax
c010196a:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c010196c:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101970:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101973:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c0101976:	72 c4                	jb     c010193c <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010197e:	01 d0                	add    %edx,%eax
c0101980:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101986:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101989:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010198c:	85 c0                	test   %eax,%eax
c010198e:	74 0f                	je     c010199f <ide_init+0x293>
c0101990:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101993:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101996:	01 d0                	add    %edx,%eax
c0101998:	0f b6 00             	movzbl (%eax),%eax
c010199b:	3c 20                	cmp    $0x20,%al
c010199d:	74 d9                	je     c0101978 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c010199f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019a3:	c1 e0 03             	shl    $0x3,%eax
c01019a6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ad:	29 c2                	sub    %eax,%edx
c01019af:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019b5:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019b8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019bc:	c1 e0 03             	shl    $0x3,%eax
c01019bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c6:	29 c2                	sub    %eax,%edx
c01019c8:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c01019ce:	8b 50 08             	mov    0x8(%eax),%edx
c01019d1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019d5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e1:	c7 04 24 7a 8e 10 c0 	movl   $0xc0108e7a,(%esp)
c01019e8:	e8 5e e9 ff ff       	call   c010034b <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019ed:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f1:	83 c0 01             	add    $0x1,%eax
c01019f4:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c01019f8:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c01019fd:	0f 86 1f fd ff ff    	jbe    c0101722 <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a03:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a0a:	e8 7c 05 00 00       	call   c0101f8b <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a0f:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a16:	e8 70 05 00 00       	call   c0101f8b <pic_enable>
}
c0101a1b:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a21:	5b                   	pop    %ebx
c0101a22:	5f                   	pop    %edi
c0101a23:	5d                   	pop    %ebp
c0101a24:	c3                   	ret    

c0101a25 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a25:	55                   	push   %ebp
c0101a26:	89 e5                	mov    %esp,%ebp
c0101a28:	83 ec 04             	sub    $0x4,%esp
c0101a2b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2e:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a32:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a37:	77 24                	ja     c0101a5d <ide_device_valid+0x38>
c0101a39:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a3d:	c1 e0 03             	shl    $0x3,%eax
c0101a40:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a47:	29 c2                	sub    %eax,%edx
c0101a49:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a4f:	0f b6 00             	movzbl (%eax),%eax
c0101a52:	84 c0                	test   %al,%al
c0101a54:	74 07                	je     c0101a5d <ide_device_valid+0x38>
c0101a56:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a5b:	eb 05                	jmp    c0101a62 <ide_device_valid+0x3d>
c0101a5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a62:	c9                   	leave  
c0101a63:	c3                   	ret    

c0101a64 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a64:	55                   	push   %ebp
c0101a65:	89 e5                	mov    %esp,%ebp
c0101a67:	83 ec 08             	sub    $0x8,%esp
c0101a6a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a71:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a75:	89 04 24             	mov    %eax,(%esp)
c0101a78:	e8 a8 ff ff ff       	call   c0101a25 <ide_device_valid>
c0101a7d:	85 c0                	test   %eax,%eax
c0101a7f:	74 1b                	je     c0101a9c <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a81:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a85:	c1 e0 03             	shl    $0x3,%eax
c0101a88:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a8f:	29 c2                	sub    %eax,%edx
c0101a91:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101a97:	8b 40 08             	mov    0x8(%eax),%eax
c0101a9a:	eb 05                	jmp    c0101aa1 <ide_device_size+0x3d>
    }
    return 0;
c0101a9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa1:	c9                   	leave  
c0101aa2:	c3                   	ret    

c0101aa3 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aa3:	55                   	push   %ebp
c0101aa4:	89 e5                	mov    %esp,%ebp
c0101aa6:	57                   	push   %edi
c0101aa7:	53                   	push   %ebx
c0101aa8:	83 ec 50             	sub    $0x50,%esp
c0101aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aae:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ab2:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ab9:	77 24                	ja     c0101adf <ide_read_secs+0x3c>
c0101abb:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac0:	77 1d                	ja     c0101adf <ide_read_secs+0x3c>
c0101ac2:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ac6:	c1 e0 03             	shl    $0x3,%eax
c0101ac9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad0:	29 c2                	sub    %eax,%edx
c0101ad2:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101ad8:	0f b6 00             	movzbl (%eax),%eax
c0101adb:	84 c0                	test   %al,%al
c0101add:	75 24                	jne    c0101b03 <ide_read_secs+0x60>
c0101adf:	c7 44 24 0c 98 8e 10 	movl   $0xc0108e98,0xc(%esp)
c0101ae6:	c0 
c0101ae7:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101af6:	00 
c0101af7:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101afe:	e8 d2 f1 ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b03:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b0a:	77 0f                	ja     c0101b1b <ide_read_secs+0x78>
c0101b0c:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b0f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b12:	01 d0                	add    %edx,%eax
c0101b14:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b19:	76 24                	jbe    c0101b3f <ide_read_secs+0x9c>
c0101b1b:	c7 44 24 0c c0 8e 10 	movl   $0xc0108ec0,0xc(%esp)
c0101b22:	c0 
c0101b23:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b32:	00 
c0101b33:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101b3a:	e8 96 f1 ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b3f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b43:	66 d1 e8             	shr    %ax
c0101b46:	0f b7 c0             	movzwl %ax,%eax
c0101b49:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c0101b50:	c0 
c0101b51:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b55:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b59:	66 d1 e8             	shr    %ax
c0101b5c:	0f b7 c0             	movzwl %ax,%eax
c0101b5f:	0f b7 04 85 0a 8e 10 	movzwl -0x3fef71f6(,%eax,4),%eax
c0101b66:	c0 
c0101b67:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b6b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b6f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b76:	00 
c0101b77:	89 04 24             	mov    %eax,(%esp)
c0101b7a:	e8 33 fb ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b7f:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b83:	83 c0 02             	add    $0x2,%eax
c0101b86:	0f b7 c0             	movzwl %ax,%eax
c0101b89:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b8d:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b91:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b95:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101b99:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101b9a:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b9d:	0f b6 c0             	movzbl %al,%eax
c0101ba0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ba4:	83 c2 02             	add    $0x2,%edx
c0101ba7:	0f b7 d2             	movzwl %dx,%edx
c0101baa:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bae:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bb5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bb9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bba:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bbd:	0f b6 c0             	movzbl %al,%eax
c0101bc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bc4:	83 c2 03             	add    $0x3,%edx
c0101bc7:	0f b7 d2             	movzwl %dx,%edx
c0101bca:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bce:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bd5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101bd9:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101bda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bdd:	c1 e8 08             	shr    $0x8,%eax
c0101be0:	0f b6 c0             	movzbl %al,%eax
c0101be3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101be7:	83 c2 04             	add    $0x4,%edx
c0101bea:	0f b7 d2             	movzwl %dx,%edx
c0101bed:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf1:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bf4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101bf8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101bfc:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101bfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c00:	c1 e8 10             	shr    $0x10,%eax
c0101c03:	0f b6 c0             	movzbl %al,%eax
c0101c06:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c0a:	83 c2 05             	add    $0x5,%edx
c0101c0d:	0f b7 d2             	movzwl %dx,%edx
c0101c10:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c14:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c17:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c1b:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c1f:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c20:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c24:	83 e0 01             	and    $0x1,%eax
c0101c27:	c1 e0 04             	shl    $0x4,%eax
c0101c2a:	89 c2                	mov    %eax,%edx
c0101c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c2f:	c1 e8 18             	shr    $0x18,%eax
c0101c32:	83 e0 0f             	and    $0xf,%eax
c0101c35:	09 d0                	or     %edx,%eax
c0101c37:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c3a:	0f b6 c0             	movzbl %al,%eax
c0101c3d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c41:	83 c2 06             	add    $0x6,%edx
c0101c44:	0f b7 d2             	movzwl %dx,%edx
c0101c47:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c4b:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c4e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c52:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c56:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c57:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c5b:	83 c0 07             	add    $0x7,%eax
c0101c5e:	0f b7 c0             	movzwl %ax,%eax
c0101c61:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c65:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c69:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c6d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c71:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c79:	eb 5a                	jmp    c0101cd5 <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c7b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c86:	00 
c0101c87:	89 04 24             	mov    %eax,(%esp)
c0101c8a:	e8 23 fa ff ff       	call   c01016b2 <ide_wait_ready>
c0101c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c96:	74 02                	je     c0101c9a <ide_read_secs+0x1f7>
            goto out;
c0101c98:	eb 41                	jmp    c0101cdb <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101c9a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c9e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca1:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ca4:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ca7:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb1:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cb4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cb7:	89 cb                	mov    %ecx,%ebx
c0101cb9:	89 df                	mov    %ebx,%edi
c0101cbb:	89 c1                	mov    %eax,%ecx
c0101cbd:	fc                   	cld    
c0101cbe:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc0:	89 c8                	mov    %ecx,%eax
c0101cc2:	89 fb                	mov    %edi,%ebx
c0101cc4:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101cc7:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cca:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cce:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cd5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101cd9:	75 a0                	jne    c0101c7b <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101cde:	83 c4 50             	add    $0x50,%esp
c0101ce1:	5b                   	pop    %ebx
c0101ce2:	5f                   	pop    %edi
c0101ce3:	5d                   	pop    %ebp
c0101ce4:	c3                   	ret    

c0101ce5 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ce5:	55                   	push   %ebp
c0101ce6:	89 e5                	mov    %esp,%ebp
c0101ce8:	56                   	push   %esi
c0101ce9:	53                   	push   %ebx
c0101cea:	83 ec 50             	sub    $0x50,%esp
c0101ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf0:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cf4:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101cfb:	77 24                	ja     c0101d21 <ide_write_secs+0x3c>
c0101cfd:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d02:	77 1d                	ja     c0101d21 <ide_write_secs+0x3c>
c0101d04:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d08:	c1 e0 03             	shl    $0x3,%eax
c0101d0b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d12:	29 c2                	sub    %eax,%edx
c0101d14:	8d 82 00 01 12 c0    	lea    -0x3fedff00(%edx),%eax
c0101d1a:	0f b6 00             	movzbl (%eax),%eax
c0101d1d:	84 c0                	test   %al,%al
c0101d1f:	75 24                	jne    c0101d45 <ide_write_secs+0x60>
c0101d21:	c7 44 24 0c 98 8e 10 	movl   $0xc0108e98,0xc(%esp)
c0101d28:	c0 
c0101d29:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d38:	00 
c0101d39:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101d40:	e8 90 ef ff ff       	call   c0100cd5 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d45:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d4c:	77 0f                	ja     c0101d5d <ide_write_secs+0x78>
c0101d4e:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d54:	01 d0                	add    %edx,%eax
c0101d56:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d5b:	76 24                	jbe    c0101d81 <ide_write_secs+0x9c>
c0101d5d:	c7 44 24 0c c0 8e 10 	movl   $0xc0108ec0,0xc(%esp)
c0101d64:	c0 
c0101d65:	c7 44 24 08 53 8e 10 	movl   $0xc0108e53,0x8(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d74:	00 
c0101d75:	c7 04 24 68 8e 10 c0 	movl   $0xc0108e68,(%esp)
c0101d7c:	e8 54 ef ff ff       	call   c0100cd5 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d81:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d85:	66 d1 e8             	shr    %ax
c0101d88:	0f b7 c0             	movzwl %ax,%eax
c0101d8b:	0f b7 04 85 08 8e 10 	movzwl -0x3fef71f8(,%eax,4),%eax
c0101d92:	c0 
c0101d93:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d97:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d9b:	66 d1 e8             	shr    %ax
c0101d9e:	0f b7 c0             	movzwl %ax,%eax
c0101da1:	0f b7 04 85 0a 8e 10 	movzwl -0x3fef71f6(,%eax,4),%eax
c0101da8:	c0 
c0101da9:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101dad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101db8:	00 
c0101db9:	89 04 24             	mov    %eax,(%esp)
c0101dbc:	e8 f1 f8 ff ff       	call   c01016b2 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dc5:	83 c0 02             	add    $0x2,%eax
c0101dc8:	0f b7 c0             	movzwl %ax,%eax
c0101dcb:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dcf:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101dd3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101dd7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ddb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ddc:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ddf:	0f b6 c0             	movzbl %al,%eax
c0101de2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101de6:	83 c2 02             	add    $0x2,%edx
c0101de9:	0f b7 d2             	movzwl %dx,%edx
c0101dec:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df0:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101df3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101df7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101dfb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101dff:	0f b6 c0             	movzbl %al,%eax
c0101e02:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e06:	83 c2 03             	add    $0x3,%edx
c0101e09:	0f b7 d2             	movzwl %dx,%edx
c0101e0c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e10:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e13:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e17:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e1b:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e1f:	c1 e8 08             	shr    $0x8,%eax
c0101e22:	0f b6 c0             	movzbl %al,%eax
c0101e25:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e29:	83 c2 04             	add    $0x4,%edx
c0101e2c:	0f b7 d2             	movzwl %dx,%edx
c0101e2f:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e33:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e36:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e3a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e3e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e42:	c1 e8 10             	shr    $0x10,%eax
c0101e45:	0f b6 c0             	movzbl %al,%eax
c0101e48:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e4c:	83 c2 05             	add    $0x5,%edx
c0101e4f:	0f b7 d2             	movzwl %dx,%edx
c0101e52:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e56:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e59:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e5d:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e61:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e62:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e66:	83 e0 01             	and    $0x1,%eax
c0101e69:	c1 e0 04             	shl    $0x4,%eax
c0101e6c:	89 c2                	mov    %eax,%edx
c0101e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e71:	c1 e8 18             	shr    $0x18,%eax
c0101e74:	83 e0 0f             	and    $0xf,%eax
c0101e77:	09 d0                	or     %edx,%eax
c0101e79:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e7c:	0f b6 c0             	movzbl %al,%eax
c0101e7f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e83:	83 c2 06             	add    $0x6,%edx
c0101e86:	0f b7 d2             	movzwl %dx,%edx
c0101e89:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e8d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e90:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e94:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101e98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101e99:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e9d:	83 c0 07             	add    $0x7,%eax
c0101ea0:	0f b7 c0             	movzwl %ax,%eax
c0101ea3:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101ea7:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eab:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eaf:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101eb3:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101eb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ebb:	eb 5a                	jmp    c0101f17 <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ebd:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ec8:	00 
c0101ec9:	89 04 24             	mov    %eax,(%esp)
c0101ecc:	e8 e1 f7 ff ff       	call   c01016b2 <ide_wait_ready>
c0101ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101ed4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ed8:	74 02                	je     c0101edc <ide_write_secs+0x1f7>
            goto out;
c0101eda:	eb 41                	jmp    c0101f1d <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101edc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ee3:	8b 45 10             	mov    0x10(%ebp),%eax
c0101ee6:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ee9:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101ef3:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101ef6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101ef9:	89 cb                	mov    %ecx,%ebx
c0101efb:	89 de                	mov    %ebx,%esi
c0101efd:	89 c1                	mov    %eax,%ecx
c0101eff:	fc                   	cld    
c0101f00:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f02:	89 c8                	mov    %ecx,%eax
c0101f04:	89 f3                	mov    %esi,%ebx
c0101f06:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f09:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f0c:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f10:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f17:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f1b:	75 a0                	jne    c0101ebd <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f20:	83 c4 50             	add    $0x50,%esp
c0101f23:	5b                   	pop    %ebx
c0101f24:	5e                   	pop    %esi
c0101f25:	5d                   	pop    %ebp
c0101f26:	c3                   	ret    

c0101f27 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f27:	55                   	push   %ebp
c0101f28:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f2a:	fb                   	sti    
    sti();
}
c0101f2b:	5d                   	pop    %ebp
c0101f2c:	c3                   	ret    

c0101f2d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f2d:	55                   	push   %ebp
c0101f2e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f30:	fa                   	cli    
    cli();
}
c0101f31:	5d                   	pop    %ebp
c0101f32:	c3                   	ret    

c0101f33 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f33:	55                   	push   %ebp
c0101f34:	89 e5                	mov    %esp,%ebp
c0101f36:	83 ec 14             	sub    $0x14,%esp
c0101f39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f3c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f40:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f44:	66 a3 70 f5 11 c0    	mov    %ax,0xc011f570
    if (did_init) {
c0101f4a:	a1 e0 01 12 c0       	mov    0xc01201e0,%eax
c0101f4f:	85 c0                	test   %eax,%eax
c0101f51:	74 36                	je     c0101f89 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f53:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f57:	0f b6 c0             	movzbl %al,%eax
c0101f5a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f60:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f63:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f67:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f6b:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f6c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f70:	66 c1 e8 08          	shr    $0x8,%ax
c0101f74:	0f b6 c0             	movzbl %al,%eax
c0101f77:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f7d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f80:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f84:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f88:	ee                   	out    %al,(%dx)
    }
}
c0101f89:	c9                   	leave  
c0101f8a:	c3                   	ret    

c0101f8b <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f8b:	55                   	push   %ebp
c0101f8c:	89 e5                	mov    %esp,%ebp
c0101f8e:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f91:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f94:	ba 01 00 00 00       	mov    $0x1,%edx
c0101f99:	89 c1                	mov    %eax,%ecx
c0101f9b:	d3 e2                	shl    %cl,%edx
c0101f9d:	89 d0                	mov    %edx,%eax
c0101f9f:	f7 d0                	not    %eax
c0101fa1:	89 c2                	mov    %eax,%edx
c0101fa3:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c0101faa:	21 d0                	and    %edx,%eax
c0101fac:	0f b7 c0             	movzwl %ax,%eax
c0101faf:	89 04 24             	mov    %eax,(%esp)
c0101fb2:	e8 7c ff ff ff       	call   c0101f33 <pic_setmask>
}
c0101fb7:	c9                   	leave  
c0101fb8:	c3                   	ret    

c0101fb9 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fb9:	55                   	push   %ebp
c0101fba:	89 e5                	mov    %esp,%ebp
c0101fbc:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fbf:	c7 05 e0 01 12 c0 01 	movl   $0x1,0xc01201e0
c0101fc6:	00 00 00 
c0101fc9:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fcf:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fd3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fd7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fdb:	ee                   	out    %al,(%dx)
c0101fdc:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fe2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fe6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101fea:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101fee:	ee                   	out    %al,(%dx)
c0101fef:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ff5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101ff9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101ffd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102001:	ee                   	out    %al,(%dx)
c0102002:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102008:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010200c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102010:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102014:	ee                   	out    %al,(%dx)
c0102015:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010201b:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010201f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0102023:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0102027:	ee                   	out    %al,(%dx)
c0102028:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010202e:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0102032:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0102036:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010203a:	ee                   	out    %al,(%dx)
c010203b:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102041:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102045:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102049:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010204d:	ee                   	out    %al,(%dx)
c010204e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102054:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102058:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010205c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102060:	ee                   	out    %al,(%dx)
c0102061:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102067:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010206b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010206f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102073:	ee                   	out    %al,(%dx)
c0102074:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010207a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010207e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102082:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102086:	ee                   	out    %al,(%dx)
c0102087:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010208d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102091:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102095:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102099:	ee                   	out    %al,(%dx)
c010209a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a0:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020a4:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020a8:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020ac:	ee                   	out    %al,(%dx)
c01020ad:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020b3:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020b7:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020bb:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020bf:	ee                   	out    %al,(%dx)
c01020c0:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020c6:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020ca:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020ce:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020d2:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020d3:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020da:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020de:	74 12                	je     c01020f2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e0:	0f b7 05 70 f5 11 c0 	movzwl 0xc011f570,%eax
c01020e7:	0f b7 c0             	movzwl %ax,%eax
c01020ea:	89 04 24             	mov    %eax,(%esp)
c01020ed:	e8 41 fe ff ff       	call   c0101f33 <pic_setmask>
    }
}
c01020f2:	c9                   	leave  
c01020f3:	c3                   	ret    

c01020f4 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020f4:	55                   	push   %ebp
c01020f5:	89 e5                	mov    %esp,%ebp
c01020f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01020fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102101:	00 
c0102102:	c7 04 24 00 8f 10 c0 	movl   $0xc0108f00,(%esp)
c0102109:	e8 3d e2 ff ff       	call   c010034b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c010210e:	c9                   	leave  
c010210f:	c3                   	ret    

c0102110 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0102110:	55                   	push   %ebp
c0102111:	89 e5                	mov    %esp,%ebp
c0102113:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102116:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010211d:	e9 c3 00 00 00       	jmp    c01021e5 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102122:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102125:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c010212c:	89 c2                	mov    %eax,%edx
c010212e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102131:	66 89 14 c5 00 02 12 	mov    %dx,-0x3fedfe00(,%eax,8)
c0102138:	c0 
c0102139:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010213c:	66 c7 04 c5 02 02 12 	movw   $0x8,-0x3fedfdfe(,%eax,8)
c0102143:	c0 08 00 
c0102146:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102149:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c0102150:	c0 
c0102151:	83 e2 e0             	and    $0xffffffe0,%edx
c0102154:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c010215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215e:	0f b6 14 c5 04 02 12 	movzbl -0x3fedfdfc(,%eax,8),%edx
c0102165:	c0 
c0102166:	83 e2 1f             	and    $0x1f,%edx
c0102169:	88 14 c5 04 02 12 c0 	mov    %dl,-0x3fedfdfc(,%eax,8)
c0102170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102173:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c010217a:	c0 
c010217b:	83 e2 f0             	and    $0xfffffff0,%edx
c010217e:	83 ca 0e             	or     $0xe,%edx
c0102181:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c0102188:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218b:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c0102192:	c0 
c0102193:	83 e2 ef             	and    $0xffffffef,%edx
c0102196:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c010219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a0:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021a7:	c0 
c01021a8:	83 e2 9f             	and    $0xffffff9f,%edx
c01021ab:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b5:	0f b6 14 c5 05 02 12 	movzbl -0x3fedfdfb(,%eax,8),%edx
c01021bc:	c0 
c01021bd:	83 ca 80             	or     $0xffffff80,%edx
c01021c0:	88 14 c5 05 02 12 c0 	mov    %dl,-0x3fedfdfb(,%eax,8)
c01021c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ca:	8b 04 85 00 f6 11 c0 	mov    -0x3fee0a00(,%eax,4),%eax
c01021d1:	c1 e8 10             	shr    $0x10,%eax
c01021d4:	89 c2                	mov    %eax,%edx
c01021d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021d9:	66 89 14 c5 06 02 12 	mov    %dx,-0x3fedfdfa(,%eax,8)
c01021e0:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01021e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e8:	3d ff 00 00 00       	cmp    $0xff,%eax
c01021ed:	0f 86 2f ff ff ff    	jbe    c0102122 <idt_init+0x12>
c01021f3:	c7 45 f8 80 f5 11 c0 	movl   $0xc011f580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01021fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01021fd:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c0102200:	c9                   	leave  
c0102201:	c3                   	ret    

c0102202 <trapname>:

static const char *
trapname(int trapno) {
c0102202:	55                   	push   %ebp
c0102203:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102205:	8b 45 08             	mov    0x8(%ebp),%eax
c0102208:	83 f8 13             	cmp    $0x13,%eax
c010220b:	77 0c                	ja     c0102219 <trapname+0x17>
        return excnames[trapno];
c010220d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102210:	8b 04 85 e0 92 10 c0 	mov    -0x3fef6d20(,%eax,4),%eax
c0102217:	eb 18                	jmp    c0102231 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102219:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010221d:	7e 0d                	jle    c010222c <trapname+0x2a>
c010221f:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102223:	7f 07                	jg     c010222c <trapname+0x2a>
        return "Hardware Interrupt";
c0102225:	b8 0a 8f 10 c0       	mov    $0xc0108f0a,%eax
c010222a:	eb 05                	jmp    c0102231 <trapname+0x2f>
    }
    return "(unknown trap)";
c010222c:	b8 1d 8f 10 c0       	mov    $0xc0108f1d,%eax
}
c0102231:	5d                   	pop    %ebp
c0102232:	c3                   	ret    

c0102233 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102233:	55                   	push   %ebp
c0102234:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102236:	8b 45 08             	mov    0x8(%ebp),%eax
c0102239:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010223d:	66 83 f8 08          	cmp    $0x8,%ax
c0102241:	0f 94 c0             	sete   %al
c0102244:	0f b6 c0             	movzbl %al,%eax
}
c0102247:	5d                   	pop    %ebp
c0102248:	c3                   	ret    

c0102249 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102249:	55                   	push   %ebp
c010224a:	89 e5                	mov    %esp,%ebp
c010224c:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010224f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102252:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102256:	c7 04 24 5e 8f 10 c0 	movl   $0xc0108f5e,(%esp)
c010225d:	e8 e9 e0 ff ff       	call   c010034b <cprintf>
    print_regs(&tf->tf_regs);
c0102262:	8b 45 08             	mov    0x8(%ebp),%eax
c0102265:	89 04 24             	mov    %eax,(%esp)
c0102268:	e8 a1 01 00 00       	call   c010240e <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010226d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102270:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0102274:	0f b7 c0             	movzwl %ax,%eax
c0102277:	89 44 24 04          	mov    %eax,0x4(%esp)
c010227b:	c7 04 24 6f 8f 10 c0 	movl   $0xc0108f6f,(%esp)
c0102282:	e8 c4 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0102287:	8b 45 08             	mov    0x8(%ebp),%eax
c010228a:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c010228e:	0f b7 c0             	movzwl %ax,%eax
c0102291:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102295:	c7 04 24 82 8f 10 c0 	movl   $0xc0108f82,(%esp)
c010229c:	e8 aa e0 ff ff       	call   c010034b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01022a4:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022a8:	0f b7 c0             	movzwl %ax,%eax
c01022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022af:	c7 04 24 95 8f 10 c0 	movl   $0xc0108f95,(%esp)
c01022b6:	e8 90 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01022be:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022c2:	0f b7 c0             	movzwl %ax,%eax
c01022c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022c9:	c7 04 24 a8 8f 10 c0 	movl   $0xc0108fa8,(%esp)
c01022d0:	e8 76 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01022d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d8:	8b 40 30             	mov    0x30(%eax),%eax
c01022db:	89 04 24             	mov    %eax,(%esp)
c01022de:	e8 1f ff ff ff       	call   c0102202 <trapname>
c01022e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01022e6:	8b 52 30             	mov    0x30(%edx),%edx
c01022e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01022ed:	89 54 24 04          	mov    %edx,0x4(%esp)
c01022f1:	c7 04 24 bb 8f 10 c0 	movl   $0xc0108fbb,(%esp)
c01022f8:	e8 4e e0 ff ff       	call   c010034b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01022fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0102300:	8b 40 34             	mov    0x34(%eax),%eax
c0102303:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102307:	c7 04 24 cd 8f 10 c0 	movl   $0xc0108fcd,(%esp)
c010230e:	e8 38 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102313:	8b 45 08             	mov    0x8(%ebp),%eax
c0102316:	8b 40 38             	mov    0x38(%eax),%eax
c0102319:	89 44 24 04          	mov    %eax,0x4(%esp)
c010231d:	c7 04 24 dc 8f 10 c0 	movl   $0xc0108fdc,(%esp)
c0102324:	e8 22 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102329:	8b 45 08             	mov    0x8(%ebp),%eax
c010232c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102330:	0f b7 c0             	movzwl %ax,%eax
c0102333:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102337:	c7 04 24 eb 8f 10 c0 	movl   $0xc0108feb,(%esp)
c010233e:	e8 08 e0 ff ff       	call   c010034b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102343:	8b 45 08             	mov    0x8(%ebp),%eax
c0102346:	8b 40 40             	mov    0x40(%eax),%eax
c0102349:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234d:	c7 04 24 fe 8f 10 c0 	movl   $0xc0108ffe,(%esp)
c0102354:	e8 f2 df ff ff       	call   c010034b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102359:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102360:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102367:	eb 3e                	jmp    c01023a7 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102369:	8b 45 08             	mov    0x8(%ebp),%eax
c010236c:	8b 50 40             	mov    0x40(%eax),%edx
c010236f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102372:	21 d0                	and    %edx,%eax
c0102374:	85 c0                	test   %eax,%eax
c0102376:	74 28                	je     c01023a0 <print_trapframe+0x157>
c0102378:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010237b:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c0102382:	85 c0                	test   %eax,%eax
c0102384:	74 1a                	je     c01023a0 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102389:	8b 04 85 a0 f5 11 c0 	mov    -0x3fee0a60(,%eax,4),%eax
c0102390:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102394:	c7 04 24 0d 90 10 c0 	movl   $0xc010900d,(%esp)
c010239b:	e8 ab df ff ff       	call   c010034b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023a0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023a4:	d1 65 f0             	shll   -0x10(%ebp)
c01023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023aa:	83 f8 17             	cmp    $0x17,%eax
c01023ad:	76 ba                	jbe    c0102369 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023af:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b2:	8b 40 40             	mov    0x40(%eax),%eax
c01023b5:	25 00 30 00 00       	and    $0x3000,%eax
c01023ba:	c1 e8 0c             	shr    $0xc,%eax
c01023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c1:	c7 04 24 11 90 10 c0 	movl   $0xc0109011,(%esp)
c01023c8:	e8 7e df ff ff       	call   c010034b <cprintf>

    if (!trap_in_kernel(tf)) {
c01023cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d0:	89 04 24             	mov    %eax,(%esp)
c01023d3:	e8 5b fe ff ff       	call   c0102233 <trap_in_kernel>
c01023d8:	85 c0                	test   %eax,%eax
c01023da:	75 30                	jne    c010240c <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01023dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023df:	8b 40 44             	mov    0x44(%eax),%eax
c01023e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e6:	c7 04 24 1a 90 10 c0 	movl   $0xc010901a,(%esp)
c01023ed:	e8 59 df ff ff       	call   c010034b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01023f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f5:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01023f9:	0f b7 c0             	movzwl %ax,%eax
c01023fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102400:	c7 04 24 29 90 10 c0 	movl   $0xc0109029,(%esp)
c0102407:	e8 3f df ff ff       	call   c010034b <cprintf>
    }
}
c010240c:	c9                   	leave  
c010240d:	c3                   	ret    

c010240e <print_regs>:

void
print_regs(struct pushregs *regs) {
c010240e:	55                   	push   %ebp
c010240f:	89 e5                	mov    %esp,%ebp
c0102411:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102414:	8b 45 08             	mov    0x8(%ebp),%eax
c0102417:	8b 00                	mov    (%eax),%eax
c0102419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241d:	c7 04 24 3c 90 10 c0 	movl   $0xc010903c,(%esp)
c0102424:	e8 22 df ff ff       	call   c010034b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102429:	8b 45 08             	mov    0x8(%ebp),%eax
c010242c:	8b 40 04             	mov    0x4(%eax),%eax
c010242f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102433:	c7 04 24 4b 90 10 c0 	movl   $0xc010904b,(%esp)
c010243a:	e8 0c df ff ff       	call   c010034b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010243f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102442:	8b 40 08             	mov    0x8(%eax),%eax
c0102445:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102449:	c7 04 24 5a 90 10 c0 	movl   $0xc010905a,(%esp)
c0102450:	e8 f6 de ff ff       	call   c010034b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102455:	8b 45 08             	mov    0x8(%ebp),%eax
c0102458:	8b 40 0c             	mov    0xc(%eax),%eax
c010245b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010245f:	c7 04 24 69 90 10 c0 	movl   $0xc0109069,(%esp)
c0102466:	e8 e0 de ff ff       	call   c010034b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c010246b:	8b 45 08             	mov    0x8(%ebp),%eax
c010246e:	8b 40 10             	mov    0x10(%eax),%eax
c0102471:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102475:	c7 04 24 78 90 10 c0 	movl   $0xc0109078,(%esp)
c010247c:	e8 ca de ff ff       	call   c010034b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0102481:	8b 45 08             	mov    0x8(%ebp),%eax
c0102484:	8b 40 14             	mov    0x14(%eax),%eax
c0102487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248b:	c7 04 24 87 90 10 c0 	movl   $0xc0109087,(%esp)
c0102492:	e8 b4 de ff ff       	call   c010034b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102497:	8b 45 08             	mov    0x8(%ebp),%eax
c010249a:	8b 40 18             	mov    0x18(%eax),%eax
c010249d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a1:	c7 04 24 96 90 10 c0 	movl   $0xc0109096,(%esp)
c01024a8:	e8 9e de ff ff       	call   c010034b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b7:	c7 04 24 a5 90 10 c0 	movl   $0xc01090a5,(%esp)
c01024be:	e8 88 de ff ff       	call   c010034b <cprintf>
}
c01024c3:	c9                   	leave  
c01024c4:	c3                   	ret    

c01024c5 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024c5:	55                   	push   %ebp
c01024c6:	89 e5                	mov    %esp,%ebp
c01024c8:	53                   	push   %ebx
c01024c9:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01024cf:	8b 40 34             	mov    0x34(%eax),%eax
c01024d2:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024d5:	85 c0                	test   %eax,%eax
c01024d7:	74 07                	je     c01024e0 <print_pgfault+0x1b>
c01024d9:	b9 b4 90 10 c0       	mov    $0xc01090b4,%ecx
c01024de:	eb 05                	jmp    c01024e5 <print_pgfault+0x20>
c01024e0:	b9 c5 90 10 c0       	mov    $0xc01090c5,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c01024e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024e8:	8b 40 34             	mov    0x34(%eax),%eax
c01024eb:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c01024ee:	85 c0                	test   %eax,%eax
c01024f0:	74 07                	je     c01024f9 <print_pgfault+0x34>
c01024f2:	ba 57 00 00 00       	mov    $0x57,%edx
c01024f7:	eb 05                	jmp    c01024fe <print_pgfault+0x39>
c01024f9:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c01024fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102501:	8b 40 34             	mov    0x34(%eax),%eax
c0102504:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102507:	85 c0                	test   %eax,%eax
c0102509:	74 07                	je     c0102512 <print_pgfault+0x4d>
c010250b:	b8 55 00 00 00       	mov    $0x55,%eax
c0102510:	eb 05                	jmp    c0102517 <print_pgfault+0x52>
c0102512:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102517:	0f 20 d3             	mov    %cr2,%ebx
c010251a:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010251d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102520:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102524:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102528:	89 44 24 08          	mov    %eax,0x8(%esp)
c010252c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102530:	c7 04 24 d4 90 10 c0 	movl   $0xc01090d4,(%esp)
c0102537:	e8 0f de ff ff       	call   c010034b <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010253c:	83 c4 34             	add    $0x34,%esp
c010253f:	5b                   	pop    %ebx
c0102540:	5d                   	pop    %ebp
c0102541:	c3                   	ret    

c0102542 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102542:	55                   	push   %ebp
c0102543:	89 e5                	mov    %esp,%ebp
c0102545:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102548:	8b 45 08             	mov    0x8(%ebp),%eax
c010254b:	89 04 24             	mov    %eax,(%esp)
c010254e:	e8 72 ff ff ff       	call   c01024c5 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102553:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0102558:	85 c0                	test   %eax,%eax
c010255a:	74 28                	je     c0102584 <pgfault_handler+0x42>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010255c:	0f 20 d0             	mov    %cr2,%eax
c010255f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c0102562:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c0102565:	89 c1                	mov    %eax,%ecx
c0102567:	8b 45 08             	mov    0x8(%ebp),%eax
c010256a:	8b 50 34             	mov    0x34(%eax),%edx
c010256d:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0102572:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0102576:	89 54 24 04          	mov    %edx,0x4(%esp)
c010257a:	89 04 24             	mov    %eax,(%esp)
c010257d:	e8 b2 55 00 00       	call   c0107b34 <do_pgfault>
c0102582:	eb 1c                	jmp    c01025a0 <pgfault_handler+0x5e>
    }
    panic("unhandled page fault.\n");
c0102584:	c7 44 24 08 f7 90 10 	movl   $0xc01090f7,0x8(%esp)
c010258b:	c0 
c010258c:	c7 44 24 04 a5 00 00 	movl   $0xa5,0x4(%esp)
c0102593:	00 
c0102594:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c010259b:	e8 35 e7 ff ff       	call   c0100cd5 <__panic>
}
c01025a0:	c9                   	leave  
c01025a1:	c3                   	ret    

c01025a2 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025a2:	55                   	push   %ebp
c01025a3:	89 e5                	mov    %esp,%ebp
c01025a5:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ab:	8b 40 30             	mov    0x30(%eax),%eax
c01025ae:	83 f8 24             	cmp    $0x24,%eax
c01025b1:	0f 84 c2 00 00 00    	je     c0102679 <trap_dispatch+0xd7>
c01025b7:	83 f8 24             	cmp    $0x24,%eax
c01025ba:	77 18                	ja     c01025d4 <trap_dispatch+0x32>
c01025bc:	83 f8 20             	cmp    $0x20,%eax
c01025bf:	74 7d                	je     c010263e <trap_dispatch+0x9c>
c01025c1:	83 f8 21             	cmp    $0x21,%eax
c01025c4:	0f 84 d5 00 00 00    	je     c010269f <trap_dispatch+0xfd>
c01025ca:	83 f8 0e             	cmp    $0xe,%eax
c01025cd:	74 28                	je     c01025f7 <trap_dispatch+0x55>
c01025cf:	e9 0d 01 00 00       	jmp    c01026e1 <trap_dispatch+0x13f>
c01025d4:	83 f8 2e             	cmp    $0x2e,%eax
c01025d7:	0f 82 04 01 00 00    	jb     c01026e1 <trap_dispatch+0x13f>
c01025dd:	83 f8 2f             	cmp    $0x2f,%eax
c01025e0:	0f 86 33 01 00 00    	jbe    c0102719 <trap_dispatch+0x177>
c01025e6:	83 e8 78             	sub    $0x78,%eax
c01025e9:	83 f8 01             	cmp    $0x1,%eax
c01025ec:	0f 87 ef 00 00 00    	ja     c01026e1 <trap_dispatch+0x13f>
c01025f2:	e9 ce 00 00 00       	jmp    c01026c5 <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01025f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01025fa:	89 04 24             	mov    %eax,(%esp)
c01025fd:	e8 40 ff ff ff       	call   c0102542 <pgfault_handler>
c0102602:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102605:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102609:	74 2e                	je     c0102639 <trap_dispatch+0x97>
            print_trapframe(tf);
c010260b:	8b 45 08             	mov    0x8(%ebp),%eax
c010260e:	89 04 24             	mov    %eax,(%esp)
c0102611:	e8 33 fc ff ff       	call   c0102249 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102616:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102619:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010261d:	c7 44 24 08 1f 91 10 	movl   $0xc010911f,0x8(%esp)
c0102624:	c0 
c0102625:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010262c:	00 
c010262d:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c0102634:	e8 9c e6 ff ff       	call   c0100cd5 <__panic>
        }
        break;
c0102639:	e9 dc 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c010263e:	a1 bc 0a 12 c0       	mov    0xc0120abc,%eax
c0102643:	83 c0 01             	add    $0x1,%eax
c0102646:	a3 bc 0a 12 c0       	mov    %eax,0xc0120abc
        if (ticks % TICK_NUM == 0) {
c010264b:	8b 0d bc 0a 12 c0    	mov    0xc0120abc,%ecx
c0102651:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102656:	89 c8                	mov    %ecx,%eax
c0102658:	f7 e2                	mul    %edx
c010265a:	89 d0                	mov    %edx,%eax
c010265c:	c1 e8 05             	shr    $0x5,%eax
c010265f:	6b c0 64             	imul   $0x64,%eax,%eax
c0102662:	29 c1                	sub    %eax,%ecx
c0102664:	89 c8                	mov    %ecx,%eax
c0102666:	85 c0                	test   %eax,%eax
c0102668:	75 0a                	jne    c0102674 <trap_dispatch+0xd2>
            print_ticks();
c010266a:	e8 85 fa ff ff       	call   c01020f4 <print_ticks>
        }
        break;
c010266f:	e9 a6 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
c0102674:	e9 a1 00 00 00       	jmp    c010271a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0102679:	e8 c5 ef ff ff       	call   c0101643 <cons_getc>
c010267e:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0102681:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102685:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102689:	89 54 24 08          	mov    %edx,0x8(%esp)
c010268d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102691:	c7 04 24 3a 91 10 c0 	movl   $0xc010913a,(%esp)
c0102698:	e8 ae dc ff ff       	call   c010034b <cprintf>
        break;
c010269d:	eb 7b                	jmp    c010271a <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010269f:	e8 9f ef ff ff       	call   c0101643 <cons_getc>
c01026a4:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026a7:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026ab:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026af:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026b7:	c7 04 24 4c 91 10 c0 	movl   $0xc010914c,(%esp)
c01026be:	e8 88 dc ff ff       	call   c010034b <cprintf>
        break;
c01026c3:	eb 55                	jmp    c010271a <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026c5:	c7 44 24 08 5b 91 10 	movl   $0xc010915b,0x8(%esp)
c01026cc:	c0 
c01026cd:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01026d4:	00 
c01026d5:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c01026dc:	e8 f4 e5 ff ff       	call   c0100cd5 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c01026e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01026e8:	0f b7 c0             	movzwl %ax,%eax
c01026eb:	83 e0 03             	and    $0x3,%eax
c01026ee:	85 c0                	test   %eax,%eax
c01026f0:	75 28                	jne    c010271a <trap_dispatch+0x178>
            print_trapframe(tf);
c01026f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026f5:	89 04 24             	mov    %eax,(%esp)
c01026f8:	e8 4c fb ff ff       	call   c0102249 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c01026fd:	c7 44 24 08 6b 91 10 	movl   $0xc010916b,0x8(%esp)
c0102704:	c0 
c0102705:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c010270c:	00 
c010270d:	c7 04 24 0e 91 10 c0 	movl   $0xc010910e,(%esp)
c0102714:	e8 bc e5 ff ff       	call   c0100cd5 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102719:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010271a:	c9                   	leave  
c010271b:	c3                   	ret    

c010271c <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010271c:	55                   	push   %ebp
c010271d:	89 e5                	mov    %esp,%ebp
c010271f:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102722:	8b 45 08             	mov    0x8(%ebp),%eax
c0102725:	89 04 24             	mov    %eax,(%esp)
c0102728:	e8 75 fe ff ff       	call   c01025a2 <trap_dispatch>
}
c010272d:	c9                   	leave  
c010272e:	c3                   	ret    

c010272f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c010272f:	1e                   	push   %ds
    pushl %es
c0102730:	06                   	push   %es
    pushl %fs
c0102731:	0f a0                	push   %fs
    pushl %gs
c0102733:	0f a8                	push   %gs
    pushal
c0102735:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102736:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010273b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010273d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c010273f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102740:	e8 d7 ff ff ff       	call   c010271c <trap>

    # pop the pushed stack pointer
    popl %esp
c0102745:	5c                   	pop    %esp

c0102746 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102746:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102747:	0f a9                	pop    %gs
    popl %fs
c0102749:	0f a1                	pop    %fs
    popl %es
c010274b:	07                   	pop    %es
    popl %ds
c010274c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c010274d:	83 c4 08             	add    $0x8,%esp
    iret
c0102750:	cf                   	iret   

c0102751 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102751:	6a 00                	push   $0x0
  pushl $0
c0102753:	6a 00                	push   $0x0
  jmp __alltraps
c0102755:	e9 d5 ff ff ff       	jmp    c010272f <__alltraps>

c010275a <vector1>:
.globl vector1
vector1:
  pushl $0
c010275a:	6a 00                	push   $0x0
  pushl $1
c010275c:	6a 01                	push   $0x1
  jmp __alltraps
c010275e:	e9 cc ff ff ff       	jmp    c010272f <__alltraps>

c0102763 <vector2>:
.globl vector2
vector2:
  pushl $0
c0102763:	6a 00                	push   $0x0
  pushl $2
c0102765:	6a 02                	push   $0x2
  jmp __alltraps
c0102767:	e9 c3 ff ff ff       	jmp    c010272f <__alltraps>

c010276c <vector3>:
.globl vector3
vector3:
  pushl $0
c010276c:	6a 00                	push   $0x0
  pushl $3
c010276e:	6a 03                	push   $0x3
  jmp __alltraps
c0102770:	e9 ba ff ff ff       	jmp    c010272f <__alltraps>

c0102775 <vector4>:
.globl vector4
vector4:
  pushl $0
c0102775:	6a 00                	push   $0x0
  pushl $4
c0102777:	6a 04                	push   $0x4
  jmp __alltraps
c0102779:	e9 b1 ff ff ff       	jmp    c010272f <__alltraps>

c010277e <vector5>:
.globl vector5
vector5:
  pushl $0
c010277e:	6a 00                	push   $0x0
  pushl $5
c0102780:	6a 05                	push   $0x5
  jmp __alltraps
c0102782:	e9 a8 ff ff ff       	jmp    c010272f <__alltraps>

c0102787 <vector6>:
.globl vector6
vector6:
  pushl $0
c0102787:	6a 00                	push   $0x0
  pushl $6
c0102789:	6a 06                	push   $0x6
  jmp __alltraps
c010278b:	e9 9f ff ff ff       	jmp    c010272f <__alltraps>

c0102790 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102790:	6a 00                	push   $0x0
  pushl $7
c0102792:	6a 07                	push   $0x7
  jmp __alltraps
c0102794:	e9 96 ff ff ff       	jmp    c010272f <__alltraps>

c0102799 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102799:	6a 08                	push   $0x8
  jmp __alltraps
c010279b:	e9 8f ff ff ff       	jmp    c010272f <__alltraps>

c01027a0 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027a0:	6a 09                	push   $0x9
  jmp __alltraps
c01027a2:	e9 88 ff ff ff       	jmp    c010272f <__alltraps>

c01027a7 <vector10>:
.globl vector10
vector10:
  pushl $10
c01027a7:	6a 0a                	push   $0xa
  jmp __alltraps
c01027a9:	e9 81 ff ff ff       	jmp    c010272f <__alltraps>

c01027ae <vector11>:
.globl vector11
vector11:
  pushl $11
c01027ae:	6a 0b                	push   $0xb
  jmp __alltraps
c01027b0:	e9 7a ff ff ff       	jmp    c010272f <__alltraps>

c01027b5 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027b5:	6a 0c                	push   $0xc
  jmp __alltraps
c01027b7:	e9 73 ff ff ff       	jmp    c010272f <__alltraps>

c01027bc <vector13>:
.globl vector13
vector13:
  pushl $13
c01027bc:	6a 0d                	push   $0xd
  jmp __alltraps
c01027be:	e9 6c ff ff ff       	jmp    c010272f <__alltraps>

c01027c3 <vector14>:
.globl vector14
vector14:
  pushl $14
c01027c3:	6a 0e                	push   $0xe
  jmp __alltraps
c01027c5:	e9 65 ff ff ff       	jmp    c010272f <__alltraps>

c01027ca <vector15>:
.globl vector15
vector15:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $15
c01027cc:	6a 0f                	push   $0xf
  jmp __alltraps
c01027ce:	e9 5c ff ff ff       	jmp    c010272f <__alltraps>

c01027d3 <vector16>:
.globl vector16
vector16:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $16
c01027d5:	6a 10                	push   $0x10
  jmp __alltraps
c01027d7:	e9 53 ff ff ff       	jmp    c010272f <__alltraps>

c01027dc <vector17>:
.globl vector17
vector17:
  pushl $17
c01027dc:	6a 11                	push   $0x11
  jmp __alltraps
c01027de:	e9 4c ff ff ff       	jmp    c010272f <__alltraps>

c01027e3 <vector18>:
.globl vector18
vector18:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $18
c01027e5:	6a 12                	push   $0x12
  jmp __alltraps
c01027e7:	e9 43 ff ff ff       	jmp    c010272f <__alltraps>

c01027ec <vector19>:
.globl vector19
vector19:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $19
c01027ee:	6a 13                	push   $0x13
  jmp __alltraps
c01027f0:	e9 3a ff ff ff       	jmp    c010272f <__alltraps>

c01027f5 <vector20>:
.globl vector20
vector20:
  pushl $0
c01027f5:	6a 00                	push   $0x0
  pushl $20
c01027f7:	6a 14                	push   $0x14
  jmp __alltraps
c01027f9:	e9 31 ff ff ff       	jmp    c010272f <__alltraps>

c01027fe <vector21>:
.globl vector21
vector21:
  pushl $0
c01027fe:	6a 00                	push   $0x0
  pushl $21
c0102800:	6a 15                	push   $0x15
  jmp __alltraps
c0102802:	e9 28 ff ff ff       	jmp    c010272f <__alltraps>

c0102807 <vector22>:
.globl vector22
vector22:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $22
c0102809:	6a 16                	push   $0x16
  jmp __alltraps
c010280b:	e9 1f ff ff ff       	jmp    c010272f <__alltraps>

c0102810 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $23
c0102812:	6a 17                	push   $0x17
  jmp __alltraps
c0102814:	e9 16 ff ff ff       	jmp    c010272f <__alltraps>

c0102819 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102819:	6a 00                	push   $0x0
  pushl $24
c010281b:	6a 18                	push   $0x18
  jmp __alltraps
c010281d:	e9 0d ff ff ff       	jmp    c010272f <__alltraps>

c0102822 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102822:	6a 00                	push   $0x0
  pushl $25
c0102824:	6a 19                	push   $0x19
  jmp __alltraps
c0102826:	e9 04 ff ff ff       	jmp    c010272f <__alltraps>

c010282b <vector26>:
.globl vector26
vector26:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $26
c010282d:	6a 1a                	push   $0x1a
  jmp __alltraps
c010282f:	e9 fb fe ff ff       	jmp    c010272f <__alltraps>

c0102834 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $27
c0102836:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102838:	e9 f2 fe ff ff       	jmp    c010272f <__alltraps>

c010283d <vector28>:
.globl vector28
vector28:
  pushl $0
c010283d:	6a 00                	push   $0x0
  pushl $28
c010283f:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102841:	e9 e9 fe ff ff       	jmp    c010272f <__alltraps>

c0102846 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102846:	6a 00                	push   $0x0
  pushl $29
c0102848:	6a 1d                	push   $0x1d
  jmp __alltraps
c010284a:	e9 e0 fe ff ff       	jmp    c010272f <__alltraps>

c010284f <vector30>:
.globl vector30
vector30:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $30
c0102851:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102853:	e9 d7 fe ff ff       	jmp    c010272f <__alltraps>

c0102858 <vector31>:
.globl vector31
vector31:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $31
c010285a:	6a 1f                	push   $0x1f
  jmp __alltraps
c010285c:	e9 ce fe ff ff       	jmp    c010272f <__alltraps>

c0102861 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102861:	6a 00                	push   $0x0
  pushl $32
c0102863:	6a 20                	push   $0x20
  jmp __alltraps
c0102865:	e9 c5 fe ff ff       	jmp    c010272f <__alltraps>

c010286a <vector33>:
.globl vector33
vector33:
  pushl $0
c010286a:	6a 00                	push   $0x0
  pushl $33
c010286c:	6a 21                	push   $0x21
  jmp __alltraps
c010286e:	e9 bc fe ff ff       	jmp    c010272f <__alltraps>

c0102873 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $34
c0102875:	6a 22                	push   $0x22
  jmp __alltraps
c0102877:	e9 b3 fe ff ff       	jmp    c010272f <__alltraps>

c010287c <vector35>:
.globl vector35
vector35:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $35
c010287e:	6a 23                	push   $0x23
  jmp __alltraps
c0102880:	e9 aa fe ff ff       	jmp    c010272f <__alltraps>

c0102885 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102885:	6a 00                	push   $0x0
  pushl $36
c0102887:	6a 24                	push   $0x24
  jmp __alltraps
c0102889:	e9 a1 fe ff ff       	jmp    c010272f <__alltraps>

c010288e <vector37>:
.globl vector37
vector37:
  pushl $0
c010288e:	6a 00                	push   $0x0
  pushl $37
c0102890:	6a 25                	push   $0x25
  jmp __alltraps
c0102892:	e9 98 fe ff ff       	jmp    c010272f <__alltraps>

c0102897 <vector38>:
.globl vector38
vector38:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $38
c0102899:	6a 26                	push   $0x26
  jmp __alltraps
c010289b:	e9 8f fe ff ff       	jmp    c010272f <__alltraps>

c01028a0 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $39
c01028a2:	6a 27                	push   $0x27
  jmp __alltraps
c01028a4:	e9 86 fe ff ff       	jmp    c010272f <__alltraps>

c01028a9 <vector40>:
.globl vector40
vector40:
  pushl $0
c01028a9:	6a 00                	push   $0x0
  pushl $40
c01028ab:	6a 28                	push   $0x28
  jmp __alltraps
c01028ad:	e9 7d fe ff ff       	jmp    c010272f <__alltraps>

c01028b2 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028b2:	6a 00                	push   $0x0
  pushl $41
c01028b4:	6a 29                	push   $0x29
  jmp __alltraps
c01028b6:	e9 74 fe ff ff       	jmp    c010272f <__alltraps>

c01028bb <vector42>:
.globl vector42
vector42:
  pushl $0
c01028bb:	6a 00                	push   $0x0
  pushl $42
c01028bd:	6a 2a                	push   $0x2a
  jmp __alltraps
c01028bf:	e9 6b fe ff ff       	jmp    c010272f <__alltraps>

c01028c4 <vector43>:
.globl vector43
vector43:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $43
c01028c6:	6a 2b                	push   $0x2b
  jmp __alltraps
c01028c8:	e9 62 fe ff ff       	jmp    c010272f <__alltraps>

c01028cd <vector44>:
.globl vector44
vector44:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $44
c01028cf:	6a 2c                	push   $0x2c
  jmp __alltraps
c01028d1:	e9 59 fe ff ff       	jmp    c010272f <__alltraps>

c01028d6 <vector45>:
.globl vector45
vector45:
  pushl $0
c01028d6:	6a 00                	push   $0x0
  pushl $45
c01028d8:	6a 2d                	push   $0x2d
  jmp __alltraps
c01028da:	e9 50 fe ff ff       	jmp    c010272f <__alltraps>

c01028df <vector46>:
.globl vector46
vector46:
  pushl $0
c01028df:	6a 00                	push   $0x0
  pushl $46
c01028e1:	6a 2e                	push   $0x2e
  jmp __alltraps
c01028e3:	e9 47 fe ff ff       	jmp    c010272f <__alltraps>

c01028e8 <vector47>:
.globl vector47
vector47:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $47
c01028ea:	6a 2f                	push   $0x2f
  jmp __alltraps
c01028ec:	e9 3e fe ff ff       	jmp    c010272f <__alltraps>

c01028f1 <vector48>:
.globl vector48
vector48:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $48
c01028f3:	6a 30                	push   $0x30
  jmp __alltraps
c01028f5:	e9 35 fe ff ff       	jmp    c010272f <__alltraps>

c01028fa <vector49>:
.globl vector49
vector49:
  pushl $0
c01028fa:	6a 00                	push   $0x0
  pushl $49
c01028fc:	6a 31                	push   $0x31
  jmp __alltraps
c01028fe:	e9 2c fe ff ff       	jmp    c010272f <__alltraps>

c0102903 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102903:	6a 00                	push   $0x0
  pushl $50
c0102905:	6a 32                	push   $0x32
  jmp __alltraps
c0102907:	e9 23 fe ff ff       	jmp    c010272f <__alltraps>

c010290c <vector51>:
.globl vector51
vector51:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $51
c010290e:	6a 33                	push   $0x33
  jmp __alltraps
c0102910:	e9 1a fe ff ff       	jmp    c010272f <__alltraps>

c0102915 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102915:	6a 00                	push   $0x0
  pushl $52
c0102917:	6a 34                	push   $0x34
  jmp __alltraps
c0102919:	e9 11 fe ff ff       	jmp    c010272f <__alltraps>

c010291e <vector53>:
.globl vector53
vector53:
  pushl $0
c010291e:	6a 00                	push   $0x0
  pushl $53
c0102920:	6a 35                	push   $0x35
  jmp __alltraps
c0102922:	e9 08 fe ff ff       	jmp    c010272f <__alltraps>

c0102927 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102927:	6a 00                	push   $0x0
  pushl $54
c0102929:	6a 36                	push   $0x36
  jmp __alltraps
c010292b:	e9 ff fd ff ff       	jmp    c010272f <__alltraps>

c0102930 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102930:	6a 00                	push   $0x0
  pushl $55
c0102932:	6a 37                	push   $0x37
  jmp __alltraps
c0102934:	e9 f6 fd ff ff       	jmp    c010272f <__alltraps>

c0102939 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102939:	6a 00                	push   $0x0
  pushl $56
c010293b:	6a 38                	push   $0x38
  jmp __alltraps
c010293d:	e9 ed fd ff ff       	jmp    c010272f <__alltraps>

c0102942 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102942:	6a 00                	push   $0x0
  pushl $57
c0102944:	6a 39                	push   $0x39
  jmp __alltraps
c0102946:	e9 e4 fd ff ff       	jmp    c010272f <__alltraps>

c010294b <vector58>:
.globl vector58
vector58:
  pushl $0
c010294b:	6a 00                	push   $0x0
  pushl $58
c010294d:	6a 3a                	push   $0x3a
  jmp __alltraps
c010294f:	e9 db fd ff ff       	jmp    c010272f <__alltraps>

c0102954 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102954:	6a 00                	push   $0x0
  pushl $59
c0102956:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102958:	e9 d2 fd ff ff       	jmp    c010272f <__alltraps>

c010295d <vector60>:
.globl vector60
vector60:
  pushl $0
c010295d:	6a 00                	push   $0x0
  pushl $60
c010295f:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102961:	e9 c9 fd ff ff       	jmp    c010272f <__alltraps>

c0102966 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102966:	6a 00                	push   $0x0
  pushl $61
c0102968:	6a 3d                	push   $0x3d
  jmp __alltraps
c010296a:	e9 c0 fd ff ff       	jmp    c010272f <__alltraps>

c010296f <vector62>:
.globl vector62
vector62:
  pushl $0
c010296f:	6a 00                	push   $0x0
  pushl $62
c0102971:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102973:	e9 b7 fd ff ff       	jmp    c010272f <__alltraps>

c0102978 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $63
c010297a:	6a 3f                	push   $0x3f
  jmp __alltraps
c010297c:	e9 ae fd ff ff       	jmp    c010272f <__alltraps>

c0102981 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $64
c0102983:	6a 40                	push   $0x40
  jmp __alltraps
c0102985:	e9 a5 fd ff ff       	jmp    c010272f <__alltraps>

c010298a <vector65>:
.globl vector65
vector65:
  pushl $0
c010298a:	6a 00                	push   $0x0
  pushl $65
c010298c:	6a 41                	push   $0x41
  jmp __alltraps
c010298e:	e9 9c fd ff ff       	jmp    c010272f <__alltraps>

c0102993 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102993:	6a 00                	push   $0x0
  pushl $66
c0102995:	6a 42                	push   $0x42
  jmp __alltraps
c0102997:	e9 93 fd ff ff       	jmp    c010272f <__alltraps>

c010299c <vector67>:
.globl vector67
vector67:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $67
c010299e:	6a 43                	push   $0x43
  jmp __alltraps
c01029a0:	e9 8a fd ff ff       	jmp    c010272f <__alltraps>

c01029a5 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $68
c01029a7:	6a 44                	push   $0x44
  jmp __alltraps
c01029a9:	e9 81 fd ff ff       	jmp    c010272f <__alltraps>

c01029ae <vector69>:
.globl vector69
vector69:
  pushl $0
c01029ae:	6a 00                	push   $0x0
  pushl $69
c01029b0:	6a 45                	push   $0x45
  jmp __alltraps
c01029b2:	e9 78 fd ff ff       	jmp    c010272f <__alltraps>

c01029b7 <vector70>:
.globl vector70
vector70:
  pushl $0
c01029b7:	6a 00                	push   $0x0
  pushl $70
c01029b9:	6a 46                	push   $0x46
  jmp __alltraps
c01029bb:	e9 6f fd ff ff       	jmp    c010272f <__alltraps>

c01029c0 <vector71>:
.globl vector71
vector71:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $71
c01029c2:	6a 47                	push   $0x47
  jmp __alltraps
c01029c4:	e9 66 fd ff ff       	jmp    c010272f <__alltraps>

c01029c9 <vector72>:
.globl vector72
vector72:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $72
c01029cb:	6a 48                	push   $0x48
  jmp __alltraps
c01029cd:	e9 5d fd ff ff       	jmp    c010272f <__alltraps>

c01029d2 <vector73>:
.globl vector73
vector73:
  pushl $0
c01029d2:	6a 00                	push   $0x0
  pushl $73
c01029d4:	6a 49                	push   $0x49
  jmp __alltraps
c01029d6:	e9 54 fd ff ff       	jmp    c010272f <__alltraps>

c01029db <vector74>:
.globl vector74
vector74:
  pushl $0
c01029db:	6a 00                	push   $0x0
  pushl $74
c01029dd:	6a 4a                	push   $0x4a
  jmp __alltraps
c01029df:	e9 4b fd ff ff       	jmp    c010272f <__alltraps>

c01029e4 <vector75>:
.globl vector75
vector75:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $75
c01029e6:	6a 4b                	push   $0x4b
  jmp __alltraps
c01029e8:	e9 42 fd ff ff       	jmp    c010272f <__alltraps>

c01029ed <vector76>:
.globl vector76
vector76:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $76
c01029ef:	6a 4c                	push   $0x4c
  jmp __alltraps
c01029f1:	e9 39 fd ff ff       	jmp    c010272f <__alltraps>

c01029f6 <vector77>:
.globl vector77
vector77:
  pushl $0
c01029f6:	6a 00                	push   $0x0
  pushl $77
c01029f8:	6a 4d                	push   $0x4d
  jmp __alltraps
c01029fa:	e9 30 fd ff ff       	jmp    c010272f <__alltraps>

c01029ff <vector78>:
.globl vector78
vector78:
  pushl $0
c01029ff:	6a 00                	push   $0x0
  pushl $78
c0102a01:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a03:	e9 27 fd ff ff       	jmp    c010272f <__alltraps>

c0102a08 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $79
c0102a0a:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a0c:	e9 1e fd ff ff       	jmp    c010272f <__alltraps>

c0102a11 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $80
c0102a13:	6a 50                	push   $0x50
  jmp __alltraps
c0102a15:	e9 15 fd ff ff       	jmp    c010272f <__alltraps>

c0102a1a <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a1a:	6a 00                	push   $0x0
  pushl $81
c0102a1c:	6a 51                	push   $0x51
  jmp __alltraps
c0102a1e:	e9 0c fd ff ff       	jmp    c010272f <__alltraps>

c0102a23 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a23:	6a 00                	push   $0x0
  pushl $82
c0102a25:	6a 52                	push   $0x52
  jmp __alltraps
c0102a27:	e9 03 fd ff ff       	jmp    c010272f <__alltraps>

c0102a2c <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $83
c0102a2e:	6a 53                	push   $0x53
  jmp __alltraps
c0102a30:	e9 fa fc ff ff       	jmp    c010272f <__alltraps>

c0102a35 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $84
c0102a37:	6a 54                	push   $0x54
  jmp __alltraps
c0102a39:	e9 f1 fc ff ff       	jmp    c010272f <__alltraps>

c0102a3e <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a3e:	6a 00                	push   $0x0
  pushl $85
c0102a40:	6a 55                	push   $0x55
  jmp __alltraps
c0102a42:	e9 e8 fc ff ff       	jmp    c010272f <__alltraps>

c0102a47 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a47:	6a 00                	push   $0x0
  pushl $86
c0102a49:	6a 56                	push   $0x56
  jmp __alltraps
c0102a4b:	e9 df fc ff ff       	jmp    c010272f <__alltraps>

c0102a50 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a50:	6a 00                	push   $0x0
  pushl $87
c0102a52:	6a 57                	push   $0x57
  jmp __alltraps
c0102a54:	e9 d6 fc ff ff       	jmp    c010272f <__alltraps>

c0102a59 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $88
c0102a5b:	6a 58                	push   $0x58
  jmp __alltraps
c0102a5d:	e9 cd fc ff ff       	jmp    c010272f <__alltraps>

c0102a62 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102a62:	6a 00                	push   $0x0
  pushl $89
c0102a64:	6a 59                	push   $0x59
  jmp __alltraps
c0102a66:	e9 c4 fc ff ff       	jmp    c010272f <__alltraps>

c0102a6b <vector90>:
.globl vector90
vector90:
  pushl $0
c0102a6b:	6a 00                	push   $0x0
  pushl $90
c0102a6d:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102a6f:	e9 bb fc ff ff       	jmp    c010272f <__alltraps>

c0102a74 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102a74:	6a 00                	push   $0x0
  pushl $91
c0102a76:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102a78:	e9 b2 fc ff ff       	jmp    c010272f <__alltraps>

c0102a7d <vector92>:
.globl vector92
vector92:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $92
c0102a7f:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102a81:	e9 a9 fc ff ff       	jmp    c010272f <__alltraps>

c0102a86 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102a86:	6a 00                	push   $0x0
  pushl $93
c0102a88:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102a8a:	e9 a0 fc ff ff       	jmp    c010272f <__alltraps>

c0102a8f <vector94>:
.globl vector94
vector94:
  pushl $0
c0102a8f:	6a 00                	push   $0x0
  pushl $94
c0102a91:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102a93:	e9 97 fc ff ff       	jmp    c010272f <__alltraps>

c0102a98 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102a98:	6a 00                	push   $0x0
  pushl $95
c0102a9a:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102a9c:	e9 8e fc ff ff       	jmp    c010272f <__alltraps>

c0102aa1 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $96
c0102aa3:	6a 60                	push   $0x60
  jmp __alltraps
c0102aa5:	e9 85 fc ff ff       	jmp    c010272f <__alltraps>

c0102aaa <vector97>:
.globl vector97
vector97:
  pushl $0
c0102aaa:	6a 00                	push   $0x0
  pushl $97
c0102aac:	6a 61                	push   $0x61
  jmp __alltraps
c0102aae:	e9 7c fc ff ff       	jmp    c010272f <__alltraps>

c0102ab3 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102ab3:	6a 00                	push   $0x0
  pushl $98
c0102ab5:	6a 62                	push   $0x62
  jmp __alltraps
c0102ab7:	e9 73 fc ff ff       	jmp    c010272f <__alltraps>

c0102abc <vector99>:
.globl vector99
vector99:
  pushl $0
c0102abc:	6a 00                	push   $0x0
  pushl $99
c0102abe:	6a 63                	push   $0x63
  jmp __alltraps
c0102ac0:	e9 6a fc ff ff       	jmp    c010272f <__alltraps>

c0102ac5 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $100
c0102ac7:	6a 64                	push   $0x64
  jmp __alltraps
c0102ac9:	e9 61 fc ff ff       	jmp    c010272f <__alltraps>

c0102ace <vector101>:
.globl vector101
vector101:
  pushl $0
c0102ace:	6a 00                	push   $0x0
  pushl $101
c0102ad0:	6a 65                	push   $0x65
  jmp __alltraps
c0102ad2:	e9 58 fc ff ff       	jmp    c010272f <__alltraps>

c0102ad7 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ad7:	6a 00                	push   $0x0
  pushl $102
c0102ad9:	6a 66                	push   $0x66
  jmp __alltraps
c0102adb:	e9 4f fc ff ff       	jmp    c010272f <__alltraps>

c0102ae0 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102ae0:	6a 00                	push   $0x0
  pushl $103
c0102ae2:	6a 67                	push   $0x67
  jmp __alltraps
c0102ae4:	e9 46 fc ff ff       	jmp    c010272f <__alltraps>

c0102ae9 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $104
c0102aeb:	6a 68                	push   $0x68
  jmp __alltraps
c0102aed:	e9 3d fc ff ff       	jmp    c010272f <__alltraps>

c0102af2 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102af2:	6a 00                	push   $0x0
  pushl $105
c0102af4:	6a 69                	push   $0x69
  jmp __alltraps
c0102af6:	e9 34 fc ff ff       	jmp    c010272f <__alltraps>

c0102afb <vector106>:
.globl vector106
vector106:
  pushl $0
c0102afb:	6a 00                	push   $0x0
  pushl $106
c0102afd:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102aff:	e9 2b fc ff ff       	jmp    c010272f <__alltraps>

c0102b04 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b04:	6a 00                	push   $0x0
  pushl $107
c0102b06:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b08:	e9 22 fc ff ff       	jmp    c010272f <__alltraps>

c0102b0d <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $108
c0102b0f:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b11:	e9 19 fc ff ff       	jmp    c010272f <__alltraps>

c0102b16 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b16:	6a 00                	push   $0x0
  pushl $109
c0102b18:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b1a:	e9 10 fc ff ff       	jmp    c010272f <__alltraps>

c0102b1f <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b1f:	6a 00                	push   $0x0
  pushl $110
c0102b21:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b23:	e9 07 fc ff ff       	jmp    c010272f <__alltraps>

c0102b28 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b28:	6a 00                	push   $0x0
  pushl $111
c0102b2a:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b2c:	e9 fe fb ff ff       	jmp    c010272f <__alltraps>

c0102b31 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $112
c0102b33:	6a 70                	push   $0x70
  jmp __alltraps
c0102b35:	e9 f5 fb ff ff       	jmp    c010272f <__alltraps>

c0102b3a <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b3a:	6a 00                	push   $0x0
  pushl $113
c0102b3c:	6a 71                	push   $0x71
  jmp __alltraps
c0102b3e:	e9 ec fb ff ff       	jmp    c010272f <__alltraps>

c0102b43 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b43:	6a 00                	push   $0x0
  pushl $114
c0102b45:	6a 72                	push   $0x72
  jmp __alltraps
c0102b47:	e9 e3 fb ff ff       	jmp    c010272f <__alltraps>

c0102b4c <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b4c:	6a 00                	push   $0x0
  pushl $115
c0102b4e:	6a 73                	push   $0x73
  jmp __alltraps
c0102b50:	e9 da fb ff ff       	jmp    c010272f <__alltraps>

c0102b55 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $116
c0102b57:	6a 74                	push   $0x74
  jmp __alltraps
c0102b59:	e9 d1 fb ff ff       	jmp    c010272f <__alltraps>

c0102b5e <vector117>:
.globl vector117
vector117:
  pushl $0
c0102b5e:	6a 00                	push   $0x0
  pushl $117
c0102b60:	6a 75                	push   $0x75
  jmp __alltraps
c0102b62:	e9 c8 fb ff ff       	jmp    c010272f <__alltraps>

c0102b67 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102b67:	6a 00                	push   $0x0
  pushl $118
c0102b69:	6a 76                	push   $0x76
  jmp __alltraps
c0102b6b:	e9 bf fb ff ff       	jmp    c010272f <__alltraps>

c0102b70 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102b70:	6a 00                	push   $0x0
  pushl $119
c0102b72:	6a 77                	push   $0x77
  jmp __alltraps
c0102b74:	e9 b6 fb ff ff       	jmp    c010272f <__alltraps>

c0102b79 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $120
c0102b7b:	6a 78                	push   $0x78
  jmp __alltraps
c0102b7d:	e9 ad fb ff ff       	jmp    c010272f <__alltraps>

c0102b82 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102b82:	6a 00                	push   $0x0
  pushl $121
c0102b84:	6a 79                	push   $0x79
  jmp __alltraps
c0102b86:	e9 a4 fb ff ff       	jmp    c010272f <__alltraps>

c0102b8b <vector122>:
.globl vector122
vector122:
  pushl $0
c0102b8b:	6a 00                	push   $0x0
  pushl $122
c0102b8d:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102b8f:	e9 9b fb ff ff       	jmp    c010272f <__alltraps>

c0102b94 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102b94:	6a 00                	push   $0x0
  pushl $123
c0102b96:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102b98:	e9 92 fb ff ff       	jmp    c010272f <__alltraps>

c0102b9d <vector124>:
.globl vector124
vector124:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $124
c0102b9f:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102ba1:	e9 89 fb ff ff       	jmp    c010272f <__alltraps>

c0102ba6 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102ba6:	6a 00                	push   $0x0
  pushl $125
c0102ba8:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102baa:	e9 80 fb ff ff       	jmp    c010272f <__alltraps>

c0102baf <vector126>:
.globl vector126
vector126:
  pushl $0
c0102baf:	6a 00                	push   $0x0
  pushl $126
c0102bb1:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bb3:	e9 77 fb ff ff       	jmp    c010272f <__alltraps>

c0102bb8 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bb8:	6a 00                	push   $0x0
  pushl $127
c0102bba:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bbc:	e9 6e fb ff ff       	jmp    c010272f <__alltraps>

c0102bc1 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $128
c0102bc3:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102bc8:	e9 62 fb ff ff       	jmp    c010272f <__alltraps>

c0102bcd <vector129>:
.globl vector129
vector129:
  pushl $0
c0102bcd:	6a 00                	push   $0x0
  pushl $129
c0102bcf:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102bd4:	e9 56 fb ff ff       	jmp    c010272f <__alltraps>

c0102bd9 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102bd9:	6a 00                	push   $0x0
  pushl $130
c0102bdb:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102be0:	e9 4a fb ff ff       	jmp    c010272f <__alltraps>

c0102be5 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102be5:	6a 00                	push   $0x0
  pushl $131
c0102be7:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102bec:	e9 3e fb ff ff       	jmp    c010272f <__alltraps>

c0102bf1 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102bf1:	6a 00                	push   $0x0
  pushl $132
c0102bf3:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102bf8:	e9 32 fb ff ff       	jmp    c010272f <__alltraps>

c0102bfd <vector133>:
.globl vector133
vector133:
  pushl $0
c0102bfd:	6a 00                	push   $0x0
  pushl $133
c0102bff:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c04:	e9 26 fb ff ff       	jmp    c010272f <__alltraps>

c0102c09 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c09:	6a 00                	push   $0x0
  pushl $134
c0102c0b:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c10:	e9 1a fb ff ff       	jmp    c010272f <__alltraps>

c0102c15 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c15:	6a 00                	push   $0x0
  pushl $135
c0102c17:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c1c:	e9 0e fb ff ff       	jmp    c010272f <__alltraps>

c0102c21 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c21:	6a 00                	push   $0x0
  pushl $136
c0102c23:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c28:	e9 02 fb ff ff       	jmp    c010272f <__alltraps>

c0102c2d <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c2d:	6a 00                	push   $0x0
  pushl $137
c0102c2f:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c34:	e9 f6 fa ff ff       	jmp    c010272f <__alltraps>

c0102c39 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c39:	6a 00                	push   $0x0
  pushl $138
c0102c3b:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c40:	e9 ea fa ff ff       	jmp    c010272f <__alltraps>

c0102c45 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c45:	6a 00                	push   $0x0
  pushl $139
c0102c47:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c4c:	e9 de fa ff ff       	jmp    c010272f <__alltraps>

c0102c51 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $140
c0102c53:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c58:	e9 d2 fa ff ff       	jmp    c010272f <__alltraps>

c0102c5d <vector141>:
.globl vector141
vector141:
  pushl $0
c0102c5d:	6a 00                	push   $0x0
  pushl $141
c0102c5f:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102c64:	e9 c6 fa ff ff       	jmp    c010272f <__alltraps>

c0102c69 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102c69:	6a 00                	push   $0x0
  pushl $142
c0102c6b:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102c70:	e9 ba fa ff ff       	jmp    c010272f <__alltraps>

c0102c75 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $143
c0102c77:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102c7c:	e9 ae fa ff ff       	jmp    c010272f <__alltraps>

c0102c81 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102c81:	6a 00                	push   $0x0
  pushl $144
c0102c83:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102c88:	e9 a2 fa ff ff       	jmp    c010272f <__alltraps>

c0102c8d <vector145>:
.globl vector145
vector145:
  pushl $0
c0102c8d:	6a 00                	push   $0x0
  pushl $145
c0102c8f:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102c94:	e9 96 fa ff ff       	jmp    c010272f <__alltraps>

c0102c99 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102c99:	6a 00                	push   $0x0
  pushl $146
c0102c9b:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ca0:	e9 8a fa ff ff       	jmp    c010272f <__alltraps>

c0102ca5 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102ca5:	6a 00                	push   $0x0
  pushl $147
c0102ca7:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cac:	e9 7e fa ff ff       	jmp    c010272f <__alltraps>

c0102cb1 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cb1:	6a 00                	push   $0x0
  pushl $148
c0102cb3:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cb8:	e9 72 fa ff ff       	jmp    c010272f <__alltraps>

c0102cbd <vector149>:
.globl vector149
vector149:
  pushl $0
c0102cbd:	6a 00                	push   $0x0
  pushl $149
c0102cbf:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102cc4:	e9 66 fa ff ff       	jmp    c010272f <__alltraps>

c0102cc9 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102cc9:	6a 00                	push   $0x0
  pushl $150
c0102ccb:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102cd0:	e9 5a fa ff ff       	jmp    c010272f <__alltraps>

c0102cd5 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102cd5:	6a 00                	push   $0x0
  pushl $151
c0102cd7:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102cdc:	e9 4e fa ff ff       	jmp    c010272f <__alltraps>

c0102ce1 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102ce1:	6a 00                	push   $0x0
  pushl $152
c0102ce3:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102ce8:	e9 42 fa ff ff       	jmp    c010272f <__alltraps>

c0102ced <vector153>:
.globl vector153
vector153:
  pushl $0
c0102ced:	6a 00                	push   $0x0
  pushl $153
c0102cef:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102cf4:	e9 36 fa ff ff       	jmp    c010272f <__alltraps>

c0102cf9 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102cf9:	6a 00                	push   $0x0
  pushl $154
c0102cfb:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d00:	e9 2a fa ff ff       	jmp    c010272f <__alltraps>

c0102d05 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d05:	6a 00                	push   $0x0
  pushl $155
c0102d07:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d0c:	e9 1e fa ff ff       	jmp    c010272f <__alltraps>

c0102d11 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d11:	6a 00                	push   $0x0
  pushl $156
c0102d13:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d18:	e9 12 fa ff ff       	jmp    c010272f <__alltraps>

c0102d1d <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d1d:	6a 00                	push   $0x0
  pushl $157
c0102d1f:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d24:	e9 06 fa ff ff       	jmp    c010272f <__alltraps>

c0102d29 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d29:	6a 00                	push   $0x0
  pushl $158
c0102d2b:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d30:	e9 fa f9 ff ff       	jmp    c010272f <__alltraps>

c0102d35 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d35:	6a 00                	push   $0x0
  pushl $159
c0102d37:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d3c:	e9 ee f9 ff ff       	jmp    c010272f <__alltraps>

c0102d41 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d41:	6a 00                	push   $0x0
  pushl $160
c0102d43:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d48:	e9 e2 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d4d <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d4d:	6a 00                	push   $0x0
  pushl $161
c0102d4f:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d54:	e9 d6 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d59 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d59:	6a 00                	push   $0x0
  pushl $162
c0102d5b:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102d60:	e9 ca f9 ff ff       	jmp    c010272f <__alltraps>

c0102d65 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102d65:	6a 00                	push   $0x0
  pushl $163
c0102d67:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102d6c:	e9 be f9 ff ff       	jmp    c010272f <__alltraps>

c0102d71 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102d71:	6a 00                	push   $0x0
  pushl $164
c0102d73:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102d78:	e9 b2 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d7d <vector165>:
.globl vector165
vector165:
  pushl $0
c0102d7d:	6a 00                	push   $0x0
  pushl $165
c0102d7f:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102d84:	e9 a6 f9 ff ff       	jmp    c010272f <__alltraps>

c0102d89 <vector166>:
.globl vector166
vector166:
  pushl $0
c0102d89:	6a 00                	push   $0x0
  pushl $166
c0102d8b:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102d90:	e9 9a f9 ff ff       	jmp    c010272f <__alltraps>

c0102d95 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102d95:	6a 00                	push   $0x0
  pushl $167
c0102d97:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102d9c:	e9 8e f9 ff ff       	jmp    c010272f <__alltraps>

c0102da1 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102da1:	6a 00                	push   $0x0
  pushl $168
c0102da3:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102da8:	e9 82 f9 ff ff       	jmp    c010272f <__alltraps>

c0102dad <vector169>:
.globl vector169
vector169:
  pushl $0
c0102dad:	6a 00                	push   $0x0
  pushl $169
c0102daf:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102db4:	e9 76 f9 ff ff       	jmp    c010272f <__alltraps>

c0102db9 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102db9:	6a 00                	push   $0x0
  pushl $170
c0102dbb:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102dc0:	e9 6a f9 ff ff       	jmp    c010272f <__alltraps>

c0102dc5 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102dc5:	6a 00                	push   $0x0
  pushl $171
c0102dc7:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102dcc:	e9 5e f9 ff ff       	jmp    c010272f <__alltraps>

c0102dd1 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102dd1:	6a 00                	push   $0x0
  pushl $172
c0102dd3:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102dd8:	e9 52 f9 ff ff       	jmp    c010272f <__alltraps>

c0102ddd <vector173>:
.globl vector173
vector173:
  pushl $0
c0102ddd:	6a 00                	push   $0x0
  pushl $173
c0102ddf:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102de4:	e9 46 f9 ff ff       	jmp    c010272f <__alltraps>

c0102de9 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102de9:	6a 00                	push   $0x0
  pushl $174
c0102deb:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102df0:	e9 3a f9 ff ff       	jmp    c010272f <__alltraps>

c0102df5 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102df5:	6a 00                	push   $0x0
  pushl $175
c0102df7:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102dfc:	e9 2e f9 ff ff       	jmp    c010272f <__alltraps>

c0102e01 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e01:	6a 00                	push   $0x0
  pushl $176
c0102e03:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e08:	e9 22 f9 ff ff       	jmp    c010272f <__alltraps>

c0102e0d <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e0d:	6a 00                	push   $0x0
  pushl $177
c0102e0f:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e14:	e9 16 f9 ff ff       	jmp    c010272f <__alltraps>

c0102e19 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e19:	6a 00                	push   $0x0
  pushl $178
c0102e1b:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e20:	e9 0a f9 ff ff       	jmp    c010272f <__alltraps>

c0102e25 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e25:	6a 00                	push   $0x0
  pushl $179
c0102e27:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e2c:	e9 fe f8 ff ff       	jmp    c010272f <__alltraps>

c0102e31 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e31:	6a 00                	push   $0x0
  pushl $180
c0102e33:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e38:	e9 f2 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e3d <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e3d:	6a 00                	push   $0x0
  pushl $181
c0102e3f:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e44:	e9 e6 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e49 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e49:	6a 00                	push   $0x0
  pushl $182
c0102e4b:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e50:	e9 da f8 ff ff       	jmp    c010272f <__alltraps>

c0102e55 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e55:	6a 00                	push   $0x0
  pushl $183
c0102e57:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e5c:	e9 ce f8 ff ff       	jmp    c010272f <__alltraps>

c0102e61 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102e61:	6a 00                	push   $0x0
  pushl $184
c0102e63:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102e68:	e9 c2 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e6d <vector185>:
.globl vector185
vector185:
  pushl $0
c0102e6d:	6a 00                	push   $0x0
  pushl $185
c0102e6f:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102e74:	e9 b6 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e79 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102e79:	6a 00                	push   $0x0
  pushl $186
c0102e7b:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102e80:	e9 aa f8 ff ff       	jmp    c010272f <__alltraps>

c0102e85 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102e85:	6a 00                	push   $0x0
  pushl $187
c0102e87:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102e8c:	e9 9e f8 ff ff       	jmp    c010272f <__alltraps>

c0102e91 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102e91:	6a 00                	push   $0x0
  pushl $188
c0102e93:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102e98:	e9 92 f8 ff ff       	jmp    c010272f <__alltraps>

c0102e9d <vector189>:
.globl vector189
vector189:
  pushl $0
c0102e9d:	6a 00                	push   $0x0
  pushl $189
c0102e9f:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ea4:	e9 86 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ea9 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102ea9:	6a 00                	push   $0x0
  pushl $190
c0102eab:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102eb0:	e9 7a f8 ff ff       	jmp    c010272f <__alltraps>

c0102eb5 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102eb5:	6a 00                	push   $0x0
  pushl $191
c0102eb7:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102ebc:	e9 6e f8 ff ff       	jmp    c010272f <__alltraps>

c0102ec1 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102ec1:	6a 00                	push   $0x0
  pushl $192
c0102ec3:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102ec8:	e9 62 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ecd <vector193>:
.globl vector193
vector193:
  pushl $0
c0102ecd:	6a 00                	push   $0x0
  pushl $193
c0102ecf:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102ed4:	e9 56 f8 ff ff       	jmp    c010272f <__alltraps>

c0102ed9 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102ed9:	6a 00                	push   $0x0
  pushl $194
c0102edb:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102ee0:	e9 4a f8 ff ff       	jmp    c010272f <__alltraps>

c0102ee5 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102ee5:	6a 00                	push   $0x0
  pushl $195
c0102ee7:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102eec:	e9 3e f8 ff ff       	jmp    c010272f <__alltraps>

c0102ef1 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102ef1:	6a 00                	push   $0x0
  pushl $196
c0102ef3:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102ef8:	e9 32 f8 ff ff       	jmp    c010272f <__alltraps>

c0102efd <vector197>:
.globl vector197
vector197:
  pushl $0
c0102efd:	6a 00                	push   $0x0
  pushl $197
c0102eff:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f04:	e9 26 f8 ff ff       	jmp    c010272f <__alltraps>

c0102f09 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f09:	6a 00                	push   $0x0
  pushl $198
c0102f0b:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f10:	e9 1a f8 ff ff       	jmp    c010272f <__alltraps>

c0102f15 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f15:	6a 00                	push   $0x0
  pushl $199
c0102f17:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f1c:	e9 0e f8 ff ff       	jmp    c010272f <__alltraps>

c0102f21 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f21:	6a 00                	push   $0x0
  pushl $200
c0102f23:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f28:	e9 02 f8 ff ff       	jmp    c010272f <__alltraps>

c0102f2d <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f2d:	6a 00                	push   $0x0
  pushl $201
c0102f2f:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f34:	e9 f6 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f39 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f39:	6a 00                	push   $0x0
  pushl $202
c0102f3b:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f40:	e9 ea f7 ff ff       	jmp    c010272f <__alltraps>

c0102f45 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f45:	6a 00                	push   $0x0
  pushl $203
c0102f47:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f4c:	e9 de f7 ff ff       	jmp    c010272f <__alltraps>

c0102f51 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f51:	6a 00                	push   $0x0
  pushl $204
c0102f53:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f58:	e9 d2 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f5d <vector205>:
.globl vector205
vector205:
  pushl $0
c0102f5d:	6a 00                	push   $0x0
  pushl $205
c0102f5f:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102f64:	e9 c6 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f69 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102f69:	6a 00                	push   $0x0
  pushl $206
c0102f6b:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102f70:	e9 ba f7 ff ff       	jmp    c010272f <__alltraps>

c0102f75 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102f75:	6a 00                	push   $0x0
  pushl $207
c0102f77:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102f7c:	e9 ae f7 ff ff       	jmp    c010272f <__alltraps>

c0102f81 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102f81:	6a 00                	push   $0x0
  pushl $208
c0102f83:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102f88:	e9 a2 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f8d <vector209>:
.globl vector209
vector209:
  pushl $0
c0102f8d:	6a 00                	push   $0x0
  pushl $209
c0102f8f:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102f94:	e9 96 f7 ff ff       	jmp    c010272f <__alltraps>

c0102f99 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102f99:	6a 00                	push   $0x0
  pushl $210
c0102f9b:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fa0:	e9 8a f7 ff ff       	jmp    c010272f <__alltraps>

c0102fa5 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fa5:	6a 00                	push   $0x0
  pushl $211
c0102fa7:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fac:	e9 7e f7 ff ff       	jmp    c010272f <__alltraps>

c0102fb1 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102fb1:	6a 00                	push   $0x0
  pushl $212
c0102fb3:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102fb8:	e9 72 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fbd <vector213>:
.globl vector213
vector213:
  pushl $0
c0102fbd:	6a 00                	push   $0x0
  pushl $213
c0102fbf:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102fc4:	e9 66 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fc9 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102fc9:	6a 00                	push   $0x0
  pushl $214
c0102fcb:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102fd0:	e9 5a f7 ff ff       	jmp    c010272f <__alltraps>

c0102fd5 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102fd5:	6a 00                	push   $0x0
  pushl $215
c0102fd7:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102fdc:	e9 4e f7 ff ff       	jmp    c010272f <__alltraps>

c0102fe1 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102fe1:	6a 00                	push   $0x0
  pushl $216
c0102fe3:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102fe8:	e9 42 f7 ff ff       	jmp    c010272f <__alltraps>

c0102fed <vector217>:
.globl vector217
vector217:
  pushl $0
c0102fed:	6a 00                	push   $0x0
  pushl $217
c0102fef:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102ff4:	e9 36 f7 ff ff       	jmp    c010272f <__alltraps>

c0102ff9 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102ff9:	6a 00                	push   $0x0
  pushl $218
c0102ffb:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103000:	e9 2a f7 ff ff       	jmp    c010272f <__alltraps>

c0103005 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103005:	6a 00                	push   $0x0
  pushl $219
c0103007:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010300c:	e9 1e f7 ff ff       	jmp    c010272f <__alltraps>

c0103011 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103011:	6a 00                	push   $0x0
  pushl $220
c0103013:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0103018:	e9 12 f7 ff ff       	jmp    c010272f <__alltraps>

c010301d <vector221>:
.globl vector221
vector221:
  pushl $0
c010301d:	6a 00                	push   $0x0
  pushl $221
c010301f:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103024:	e9 06 f7 ff ff       	jmp    c010272f <__alltraps>

c0103029 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103029:	6a 00                	push   $0x0
  pushl $222
c010302b:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103030:	e9 fa f6 ff ff       	jmp    c010272f <__alltraps>

c0103035 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103035:	6a 00                	push   $0x0
  pushl $223
c0103037:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010303c:	e9 ee f6 ff ff       	jmp    c010272f <__alltraps>

c0103041 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103041:	6a 00                	push   $0x0
  pushl $224
c0103043:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0103048:	e9 e2 f6 ff ff       	jmp    c010272f <__alltraps>

c010304d <vector225>:
.globl vector225
vector225:
  pushl $0
c010304d:	6a 00                	push   $0x0
  pushl $225
c010304f:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103054:	e9 d6 f6 ff ff       	jmp    c010272f <__alltraps>

c0103059 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103059:	6a 00                	push   $0x0
  pushl $226
c010305b:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103060:	e9 ca f6 ff ff       	jmp    c010272f <__alltraps>

c0103065 <vector227>:
.globl vector227
vector227:
  pushl $0
c0103065:	6a 00                	push   $0x0
  pushl $227
c0103067:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010306c:	e9 be f6 ff ff       	jmp    c010272f <__alltraps>

c0103071 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103071:	6a 00                	push   $0x0
  pushl $228
c0103073:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0103078:	e9 b2 f6 ff ff       	jmp    c010272f <__alltraps>

c010307d <vector229>:
.globl vector229
vector229:
  pushl $0
c010307d:	6a 00                	push   $0x0
  pushl $229
c010307f:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103084:	e9 a6 f6 ff ff       	jmp    c010272f <__alltraps>

c0103089 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103089:	6a 00                	push   $0x0
  pushl $230
c010308b:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103090:	e9 9a f6 ff ff       	jmp    c010272f <__alltraps>

c0103095 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103095:	6a 00                	push   $0x0
  pushl $231
c0103097:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010309c:	e9 8e f6 ff ff       	jmp    c010272f <__alltraps>

c01030a1 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030a1:	6a 00                	push   $0x0
  pushl $232
c01030a3:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030a8:	e9 82 f6 ff ff       	jmp    c010272f <__alltraps>

c01030ad <vector233>:
.globl vector233
vector233:
  pushl $0
c01030ad:	6a 00                	push   $0x0
  pushl $233
c01030af:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030b4:	e9 76 f6 ff ff       	jmp    c010272f <__alltraps>

c01030b9 <vector234>:
.globl vector234
vector234:
  pushl $0
c01030b9:	6a 00                	push   $0x0
  pushl $234
c01030bb:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01030c0:	e9 6a f6 ff ff       	jmp    c010272f <__alltraps>

c01030c5 <vector235>:
.globl vector235
vector235:
  pushl $0
c01030c5:	6a 00                	push   $0x0
  pushl $235
c01030c7:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01030cc:	e9 5e f6 ff ff       	jmp    c010272f <__alltraps>

c01030d1 <vector236>:
.globl vector236
vector236:
  pushl $0
c01030d1:	6a 00                	push   $0x0
  pushl $236
c01030d3:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01030d8:	e9 52 f6 ff ff       	jmp    c010272f <__alltraps>

c01030dd <vector237>:
.globl vector237
vector237:
  pushl $0
c01030dd:	6a 00                	push   $0x0
  pushl $237
c01030df:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01030e4:	e9 46 f6 ff ff       	jmp    c010272f <__alltraps>

c01030e9 <vector238>:
.globl vector238
vector238:
  pushl $0
c01030e9:	6a 00                	push   $0x0
  pushl $238
c01030eb:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01030f0:	e9 3a f6 ff ff       	jmp    c010272f <__alltraps>

c01030f5 <vector239>:
.globl vector239
vector239:
  pushl $0
c01030f5:	6a 00                	push   $0x0
  pushl $239
c01030f7:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01030fc:	e9 2e f6 ff ff       	jmp    c010272f <__alltraps>

c0103101 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103101:	6a 00                	push   $0x0
  pushl $240
c0103103:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0103108:	e9 22 f6 ff ff       	jmp    c010272f <__alltraps>

c010310d <vector241>:
.globl vector241
vector241:
  pushl $0
c010310d:	6a 00                	push   $0x0
  pushl $241
c010310f:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103114:	e9 16 f6 ff ff       	jmp    c010272f <__alltraps>

c0103119 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103119:	6a 00                	push   $0x0
  pushl $242
c010311b:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103120:	e9 0a f6 ff ff       	jmp    c010272f <__alltraps>

c0103125 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103125:	6a 00                	push   $0x0
  pushl $243
c0103127:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010312c:	e9 fe f5 ff ff       	jmp    c010272f <__alltraps>

c0103131 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103131:	6a 00                	push   $0x0
  pushl $244
c0103133:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0103138:	e9 f2 f5 ff ff       	jmp    c010272f <__alltraps>

c010313d <vector245>:
.globl vector245
vector245:
  pushl $0
c010313d:	6a 00                	push   $0x0
  pushl $245
c010313f:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103144:	e9 e6 f5 ff ff       	jmp    c010272f <__alltraps>

c0103149 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103149:	6a 00                	push   $0x0
  pushl $246
c010314b:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103150:	e9 da f5 ff ff       	jmp    c010272f <__alltraps>

c0103155 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103155:	6a 00                	push   $0x0
  pushl $247
c0103157:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010315c:	e9 ce f5 ff ff       	jmp    c010272f <__alltraps>

c0103161 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103161:	6a 00                	push   $0x0
  pushl $248
c0103163:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0103168:	e9 c2 f5 ff ff       	jmp    c010272f <__alltraps>

c010316d <vector249>:
.globl vector249
vector249:
  pushl $0
c010316d:	6a 00                	push   $0x0
  pushl $249
c010316f:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0103174:	e9 b6 f5 ff ff       	jmp    c010272f <__alltraps>

c0103179 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103179:	6a 00                	push   $0x0
  pushl $250
c010317b:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103180:	e9 aa f5 ff ff       	jmp    c010272f <__alltraps>

c0103185 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103185:	6a 00                	push   $0x0
  pushl $251
c0103187:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010318c:	e9 9e f5 ff ff       	jmp    c010272f <__alltraps>

c0103191 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103191:	6a 00                	push   $0x0
  pushl $252
c0103193:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0103198:	e9 92 f5 ff ff       	jmp    c010272f <__alltraps>

c010319d <vector253>:
.globl vector253
vector253:
  pushl $0
c010319d:	6a 00                	push   $0x0
  pushl $253
c010319f:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031a4:	e9 86 f5 ff ff       	jmp    c010272f <__alltraps>

c01031a9 <vector254>:
.globl vector254
vector254:
  pushl $0
c01031a9:	6a 00                	push   $0x0
  pushl $254
c01031ab:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031b0:	e9 7a f5 ff ff       	jmp    c010272f <__alltraps>

c01031b5 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031b5:	6a 00                	push   $0x0
  pushl $255
c01031b7:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031bc:	e9 6e f5 ff ff       	jmp    c010272f <__alltraps>

c01031c1 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01031c1:	55                   	push   %ebp
c01031c2:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01031c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01031c7:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01031cc:	29 c2                	sub    %eax,%edx
c01031ce:	89 d0                	mov    %edx,%eax
c01031d0:	c1 f8 05             	sar    $0x5,%eax
}
c01031d3:	5d                   	pop    %ebp
c01031d4:	c3                   	ret    

c01031d5 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01031d5:	55                   	push   %ebp
c01031d6:	89 e5                	mov    %esp,%ebp
c01031d8:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01031db:	8b 45 08             	mov    0x8(%ebp),%eax
c01031de:	89 04 24             	mov    %eax,(%esp)
c01031e1:	e8 db ff ff ff       	call   c01031c1 <page2ppn>
c01031e6:	c1 e0 0c             	shl    $0xc,%eax
}
c01031e9:	c9                   	leave  
c01031ea:	c3                   	ret    

c01031eb <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01031eb:	55                   	push   %ebp
c01031ec:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01031ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01031f1:	8b 00                	mov    (%eax),%eax
}
c01031f3:	5d                   	pop    %ebp
c01031f4:	c3                   	ret    

c01031f5 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01031f5:	55                   	push   %ebp
c01031f6:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01031f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01031fb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01031fe:	89 10                	mov    %edx,(%eax)
}
c0103200:	5d                   	pop    %ebp
c0103201:	c3                   	ret    

c0103202 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103202:	55                   	push   %ebp
c0103203:	89 e5                	mov    %esp,%ebp
c0103205:	83 ec 10             	sub    $0x10,%esp
c0103208:	c7 45 fc c0 0a 12 c0 	movl   $0xc0120ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010320f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103212:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103215:	89 50 04             	mov    %edx,0x4(%eax)
c0103218:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010321b:	8b 50 04             	mov    0x4(%eax),%edx
c010321e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103221:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103223:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c010322a:	00 00 00 
}
c010322d:	c9                   	leave  
c010322e:	c3                   	ret    

c010322f <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010322f:	55                   	push   %ebp
c0103230:	89 e5                	mov    %esp,%ebp
c0103232:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103235:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103239:	75 24                	jne    c010325f <default_init_memmap+0x30>
c010323b:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c0103242:	c0 
c0103243:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010324a:	c0 
c010324b:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103252:	00 
c0103253:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010325a:	e8 76 da ff ff       	call   c0100cd5 <__panic>
    struct Page *p = base;
c010325f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103262:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0103265:	e9 dc 00 00 00       	jmp    c0103346 <default_init_memmap+0x117>
        assert(PageReserved(p));
c010326a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010326d:	83 c0 04             	add    $0x4,%eax
c0103270:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103277:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010327a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010327d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103280:	0f a3 10             	bt     %edx,(%eax)
c0103283:	19 c0                	sbb    %eax,%eax
c0103285:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0103288:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010328c:	0f 95 c0             	setne  %al
c010328f:	0f b6 c0             	movzbl %al,%eax
c0103292:	85 c0                	test   %eax,%eax
c0103294:	75 24                	jne    c01032ba <default_init_memmap+0x8b>
c0103296:	c7 44 24 0c 61 93 10 	movl   $0xc0109361,0xc(%esp)
c010329d:	c0 
c010329e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01032ad:	00 
c01032ae:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01032b5:	e8 1b da ff ff       	call   c0100cd5 <__panic>
        p->flags = 0;
c01032ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01032c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c7:	83 c0 04             	add    $0x4,%eax
c01032ca:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01032d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01032d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01032da:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01032dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01032e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032ee:	00 
c01032ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032f2:	89 04 24             	mov    %eax,(%esp)
c01032f5:	e8 fb fe ff ff       	call   c01031f5 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01032fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032fd:	83 c0 0c             	add    $0xc,%eax
c0103300:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
c0103307:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010330a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010330d:	8b 00                	mov    (%eax),%eax
c010330f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103312:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103315:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103318:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010331b:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010331e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103321:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103324:	89 10                	mov    %edx,(%eax)
c0103326:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103329:	8b 10                	mov    (%eax),%edx
c010332b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010332e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103331:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103334:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103337:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010333a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010333d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103340:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103342:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103346:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103349:	c1 e0 05             	shl    $0x5,%eax
c010334c:	89 c2                	mov    %eax,%edx
c010334e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103351:	01 d0                	add    %edx,%eax
c0103353:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103356:	0f 85 0e ff ff ff    	jne    c010326a <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c010335c:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c0103362:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103365:	01 d0                	add    %edx,%eax
c0103367:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    //first block
    base->property = n;
c010336c:	8b 45 08             	mov    0x8(%ebp),%eax
c010336f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103372:	89 50 08             	mov    %edx,0x8(%eax)
}
c0103375:	c9                   	leave  
c0103376:	c3                   	ret    

c0103377 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0103377:	55                   	push   %ebp
c0103378:	89 e5                	mov    %esp,%ebp
c010337a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010337d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103381:	75 24                	jne    c01033a7 <default_alloc_pages+0x30>
c0103383:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c010338a:	c0 
c010338b:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103392:	c0 
c0103393:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c010339a:	00 
c010339b:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01033a2:	e8 2e d9 ff ff       	call   c0100cd5 <__panic>
    if (n > nr_free) {
c01033a7:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01033ac:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033af:	73 0a                	jae    c01033bb <default_alloc_pages+0x44>
        return NULL;
c01033b1:	b8 00 00 00 00       	mov    $0x0,%eax
c01033b6:	e9 37 01 00 00       	jmp    c01034f2 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c01033bb:	c7 45 f4 c0 0a 12 c0 	movl   $0xc0120ac0,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c01033c2:	e9 0a 01 00 00       	jmp    c01034d1 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c01033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ca:	83 e8 0c             	sub    $0xc,%eax
c01033cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c01033d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033d3:	8b 40 08             	mov    0x8(%eax),%eax
c01033d6:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033d9:	0f 82 f2 00 00 00    	jb     c01034d1 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c01033df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01033e6:	eb 7c                	jmp    c0103464 <default_alloc_pages+0xed>
c01033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01033f1:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c01033f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c01033f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033fa:	83 e8 0c             	sub    $0xc,%eax
c01033fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0103400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103403:	83 c0 04             	add    $0x4,%eax
c0103406:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010340d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103410:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103413:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103416:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c0103419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010341c:	83 c0 04             	add    $0x4,%eax
c010341f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103426:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103429:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010342c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010342f:	0f b3 10             	btr    %edx,(%eax)
c0103432:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103435:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0103438:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010343b:	8b 40 04             	mov    0x4(%eax),%eax
c010343e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103441:	8b 12                	mov    (%edx),%edx
c0103443:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103446:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103449:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010344c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010344f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103452:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103455:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103458:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c010345a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010345d:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0103460:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0103464:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103467:	3b 45 08             	cmp    0x8(%ebp),%eax
c010346a:	0f 82 78 ff ff ff    	jb     c01033e8 <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0103470:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103473:	8b 40 08             	mov    0x8(%eax),%eax
c0103476:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103479:	76 12                	jbe    c010348d <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c010347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010347e:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103481:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103484:	8b 40 08             	mov    0x8(%eax),%eax
c0103487:	2b 45 08             	sub    0x8(%ebp),%eax
c010348a:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c010348d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103490:	83 c0 04             	add    $0x4,%eax
c0103493:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010349a:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010349d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034a0:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034a3:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c01034a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034a9:	83 c0 04             	add    $0x4,%eax
c01034ac:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01034b3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034b6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034b9:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034bc:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c01034bf:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01034c4:	2b 45 08             	sub    0x8(%ebp),%eax
c01034c7:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
        return p;
c01034cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034cf:	eb 21                	jmp    c01034f2 <default_alloc_pages+0x17b>
c01034d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034d4:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01034d7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034da:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c01034dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01034e0:	81 7d f4 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0xc(%ebp)
c01034e7:	0f 85 da fe ff ff    	jne    c01033c7 <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c01034ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01034f2:	c9                   	leave  
c01034f3:	c3                   	ret    

c01034f4 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01034f4:	55                   	push   %ebp
c01034f5:	89 e5                	mov    %esp,%ebp
c01034f7:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01034fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01034fe:	75 24                	jne    c0103524 <default_free_pages+0x30>
c0103500:	c7 44 24 0c 30 93 10 	movl   $0xc0109330,0xc(%esp)
c0103507:	c0 
c0103508:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010350f:	c0 
c0103510:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c0103517:	00 
c0103518:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010351f:	e8 b1 d7 ff ff       	call   c0100cd5 <__panic>
    assert(PageReserved(base));
c0103524:	8b 45 08             	mov    0x8(%ebp),%eax
c0103527:	83 c0 04             	add    $0x4,%eax
c010352a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103531:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103534:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103537:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010353a:	0f a3 10             	bt     %edx,(%eax)
c010353d:	19 c0                	sbb    %eax,%eax
c010353f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103546:	0f 95 c0             	setne  %al
c0103549:	0f b6 c0             	movzbl %al,%eax
c010354c:	85 c0                	test   %eax,%eax
c010354e:	75 24                	jne    c0103574 <default_free_pages+0x80>
c0103550:	c7 44 24 0c 71 93 10 	movl   $0xc0109371,0xc(%esp)
c0103557:	c0 
c0103558:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010355f:	c0 
c0103560:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c0103567:	00 
c0103568:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010356f:	e8 61 d7 ff ff       	call   c0100cd5 <__panic>

    list_entry_t *le = &free_list;
c0103574:	c7 45 f4 c0 0a 12 c0 	movl   $0xc0120ac0,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010357b:	eb 13                	jmp    c0103590 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c010357d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103580:	83 e8 0c             	sub    $0xc,%eax
c0103583:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0103586:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103589:	3b 45 08             	cmp    0x8(%ebp),%eax
c010358c:	76 02                	jbe    c0103590 <default_free_pages+0x9c>
        break;
c010358e:	eb 18                	jmp    c01035a8 <default_free_pages+0xb4>
c0103590:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103593:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103596:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103599:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010359c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010359f:	81 7d f4 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0xc(%ebp)
c01035a6:	75 d5                	jne    c010357d <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01035a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035ae:	eb 4b                	jmp    c01035fb <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c01035b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035b3:	8d 50 0c             	lea    0xc(%eax),%edx
c01035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035bc:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01035bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035c2:	8b 00                	mov    (%eax),%eax
c01035c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01035c7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01035ca:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01035cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01035d0:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01035d3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035d6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035d9:	89 10                	mov    %edx,(%eax)
c01035db:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035de:	8b 10                	mov    (%eax),%edx
c01035e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035e3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01035e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035e9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035ec:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01035ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01035f2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01035f5:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01035f7:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c01035fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035fe:	c1 e0 05             	shl    $0x5,%eax
c0103601:	89 c2                	mov    %eax,%edx
c0103603:	8b 45 08             	mov    0x8(%ebp),%eax
c0103606:	01 d0                	add    %edx,%eax
c0103608:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010360b:	77 a3                	ja     c01035b0 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010360d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103610:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103617:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010361e:	00 
c010361f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103622:	89 04 24             	mov    %eax,(%esp)
c0103625:	e8 cb fb ff ff       	call   c01031f5 <set_page_ref>
    ClearPageProperty(base);
c010362a:	8b 45 08             	mov    0x8(%ebp),%eax
c010362d:	83 c0 04             	add    $0x4,%eax
c0103630:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103637:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010363a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010363d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103640:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0103643:	8b 45 08             	mov    0x8(%ebp),%eax
c0103646:	83 c0 04             	add    $0x4,%eax
c0103649:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103650:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103653:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103656:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103659:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c010365c:	8b 45 08             	mov    0x8(%ebp),%eax
c010365f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103662:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0103665:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103668:	83 e8 0c             	sub    $0xc,%eax
c010366b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c010366e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103671:	c1 e0 05             	shl    $0x5,%eax
c0103674:	89 c2                	mov    %eax,%edx
c0103676:	8b 45 08             	mov    0x8(%ebp),%eax
c0103679:	01 d0                	add    %edx,%eax
c010367b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010367e:	75 1e                	jne    c010369e <default_free_pages+0x1aa>
      base->property += p->property;
c0103680:	8b 45 08             	mov    0x8(%ebp),%eax
c0103683:	8b 50 08             	mov    0x8(%eax),%edx
c0103686:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103689:	8b 40 08             	mov    0x8(%eax),%eax
c010368c:	01 c2                	add    %eax,%edx
c010368e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103691:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0103694:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103697:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c010369e:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a1:	83 c0 0c             	add    $0xc,%eax
c01036a4:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01036a7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036aa:	8b 00                	mov    (%eax),%eax
c01036ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c01036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b2:	83 e8 0c             	sub    $0xc,%eax
c01036b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c01036b8:	81 7d f4 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0xc(%ebp)
c01036bf:	74 57                	je     c0103718 <default_free_pages+0x224>
c01036c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c4:	83 e8 20             	sub    $0x20,%eax
c01036c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036ca:	75 4c                	jne    c0103718 <default_free_pages+0x224>
      while(le!=&free_list){
c01036cc:	eb 41                	jmp    c010370f <default_free_pages+0x21b>
        if(p->property){
c01036ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036d1:	8b 40 08             	mov    0x8(%eax),%eax
c01036d4:	85 c0                	test   %eax,%eax
c01036d6:	74 20                	je     c01036f8 <default_free_pages+0x204>
          p->property += base->property;
c01036d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036db:	8b 50 08             	mov    0x8(%eax),%edx
c01036de:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e1:	8b 40 08             	mov    0x8(%eax),%eax
c01036e4:	01 c2                	add    %eax,%edx
c01036e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036e9:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c01036ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c01036f6:	eb 20                	jmp    c0103718 <default_free_pages+0x224>
c01036f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01036fe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103701:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103703:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103709:	83 e8 0c             	sub    $0xc,%eax
c010370c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c010370f:	81 7d f4 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0xc(%ebp)
c0103716:	75 b6                	jne    c01036ce <default_free_pages+0x1da>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c0103718:	8b 15 c8 0a 12 c0    	mov    0xc0120ac8,%edx
c010371e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103721:	01 d0                	add    %edx,%eax
c0103723:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
    return ;
c0103728:	90                   	nop
}
c0103729:	c9                   	leave  
c010372a:	c3                   	ret    

c010372b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010372b:	55                   	push   %ebp
c010372c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010372e:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
}
c0103733:	5d                   	pop    %ebp
c0103734:	c3                   	ret    

c0103735 <basic_check>:

static void
basic_check(void) {
c0103735:	55                   	push   %ebp
c0103736:	89 e5                	mov    %esp,%ebp
c0103738:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010373b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103742:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103745:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103748:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010374b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010374e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103755:	e8 bf 0e 00 00       	call   c0104619 <alloc_pages>
c010375a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010375d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103761:	75 24                	jne    c0103787 <basic_check+0x52>
c0103763:	c7 44 24 0c 84 93 10 	movl   $0xc0109384,0xc(%esp)
c010376a:	c0 
c010376b:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103772:	c0 
c0103773:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c010377a:	00 
c010377b:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103782:	e8 4e d5 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103787:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010378e:	e8 86 0e 00 00       	call   c0104619 <alloc_pages>
c0103793:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103796:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010379a:	75 24                	jne    c01037c0 <basic_check+0x8b>
c010379c:	c7 44 24 0c a0 93 10 	movl   $0xc01093a0,0xc(%esp)
c01037a3:	c0 
c01037a4:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01037ab:	c0 
c01037ac:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01037b3:	00 
c01037b4:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01037bb:	e8 15 d5 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01037c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037c7:	e8 4d 0e 00 00       	call   c0104619 <alloc_pages>
c01037cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01037cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01037d3:	75 24                	jne    c01037f9 <basic_check+0xc4>
c01037d5:	c7 44 24 0c bc 93 10 	movl   $0xc01093bc,0xc(%esp)
c01037dc:	c0 
c01037dd:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01037e4:	c0 
c01037e5:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01037ec:	00 
c01037ed:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01037f4:	e8 dc d4 ff ff       	call   c0100cd5 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01037f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037fc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037ff:	74 10                	je     c0103811 <basic_check+0xdc>
c0103801:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103804:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103807:	74 08                	je     c0103811 <basic_check+0xdc>
c0103809:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010380c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010380f:	75 24                	jne    c0103835 <basic_check+0x100>
c0103811:	c7 44 24 0c d8 93 10 	movl   $0xc01093d8,0xc(%esp)
c0103818:	c0 
c0103819:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103820:	c0 
c0103821:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103828:	00 
c0103829:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103830:	e8 a0 d4 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103835:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103838:	89 04 24             	mov    %eax,(%esp)
c010383b:	e8 ab f9 ff ff       	call   c01031eb <page_ref>
c0103840:	85 c0                	test   %eax,%eax
c0103842:	75 1e                	jne    c0103862 <basic_check+0x12d>
c0103844:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103847:	89 04 24             	mov    %eax,(%esp)
c010384a:	e8 9c f9 ff ff       	call   c01031eb <page_ref>
c010384f:	85 c0                	test   %eax,%eax
c0103851:	75 0f                	jne    c0103862 <basic_check+0x12d>
c0103853:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103856:	89 04 24             	mov    %eax,(%esp)
c0103859:	e8 8d f9 ff ff       	call   c01031eb <page_ref>
c010385e:	85 c0                	test   %eax,%eax
c0103860:	74 24                	je     c0103886 <basic_check+0x151>
c0103862:	c7 44 24 0c fc 93 10 	movl   $0xc01093fc,0xc(%esp)
c0103869:	c0 
c010386a:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103871:	c0 
c0103872:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103879:	00 
c010387a:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103881:	e8 4f d4 ff ff       	call   c0100cd5 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103886:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103889:	89 04 24             	mov    %eax,(%esp)
c010388c:	e8 44 f9 ff ff       	call   c01031d5 <page2pa>
c0103891:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c0103897:	c1 e2 0c             	shl    $0xc,%edx
c010389a:	39 d0                	cmp    %edx,%eax
c010389c:	72 24                	jb     c01038c2 <basic_check+0x18d>
c010389e:	c7 44 24 0c 38 94 10 	movl   $0xc0109438,0xc(%esp)
c01038a5:	c0 
c01038a6:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01038ad:	c0 
c01038ae:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01038b5:	00 
c01038b6:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01038bd:	e8 13 d4 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01038c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c5:	89 04 24             	mov    %eax,(%esp)
c01038c8:	e8 08 f9 ff ff       	call   c01031d5 <page2pa>
c01038cd:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c01038d3:	c1 e2 0c             	shl    $0xc,%edx
c01038d6:	39 d0                	cmp    %edx,%eax
c01038d8:	72 24                	jb     c01038fe <basic_check+0x1c9>
c01038da:	c7 44 24 0c 55 94 10 	movl   $0xc0109455,0xc(%esp)
c01038e1:	c0 
c01038e2:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01038f1:	00 
c01038f2:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01038f9:	e8 d7 d3 ff ff       	call   c0100cd5 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01038fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103901:	89 04 24             	mov    %eax,(%esp)
c0103904:	e8 cc f8 ff ff       	call   c01031d5 <page2pa>
c0103909:	8b 15 20 0a 12 c0    	mov    0xc0120a20,%edx
c010390f:	c1 e2 0c             	shl    $0xc,%edx
c0103912:	39 d0                	cmp    %edx,%eax
c0103914:	72 24                	jb     c010393a <basic_check+0x205>
c0103916:	c7 44 24 0c 72 94 10 	movl   $0xc0109472,0xc(%esp)
c010391d:	c0 
c010391e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103925:	c0 
c0103926:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c010392d:	00 
c010392e:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103935:	e8 9b d3 ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c010393a:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c010393f:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0103945:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103948:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010394b:	c7 45 e0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103952:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103955:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103958:	89 50 04             	mov    %edx,0x4(%eax)
c010395b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010395e:	8b 50 04             	mov    0x4(%eax),%edx
c0103961:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103964:	89 10                	mov    %edx,(%eax)
c0103966:	c7 45 dc c0 0a 12 c0 	movl   $0xc0120ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010396d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103970:	8b 40 04             	mov    0x4(%eax),%eax
c0103973:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103976:	0f 94 c0             	sete   %al
c0103979:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010397c:	85 c0                	test   %eax,%eax
c010397e:	75 24                	jne    c01039a4 <basic_check+0x26f>
c0103980:	c7 44 24 0c 8f 94 10 	movl   $0xc010948f,0xc(%esp)
c0103987:	c0 
c0103988:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010398f:	c0 
c0103990:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103997:	00 
c0103998:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010399f:	e8 31 d3 ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c01039a4:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01039a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01039ac:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c01039b3:	00 00 00 

    assert(alloc_page() == NULL);
c01039b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01039bd:	e8 57 0c 00 00       	call   c0104619 <alloc_pages>
c01039c2:	85 c0                	test   %eax,%eax
c01039c4:	74 24                	je     c01039ea <basic_check+0x2b5>
c01039c6:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c01039cd:	c0 
c01039ce:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01039d5:	c0 
c01039d6:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c01039dd:	00 
c01039de:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01039e5:	e8 eb d2 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c01039ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01039f1:	00 
c01039f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f5:	89 04 24             	mov    %eax,(%esp)
c01039f8:	e8 87 0c 00 00       	call   c0104684 <free_pages>
    free_page(p1);
c01039fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a04:	00 
c0103a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a08:	89 04 24             	mov    %eax,(%esp)
c0103a0b:	e8 74 0c 00 00       	call   c0104684 <free_pages>
    free_page(p2);
c0103a10:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a17:	00 
c0103a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a1b:	89 04 24             	mov    %eax,(%esp)
c0103a1e:	e8 61 0c 00 00       	call   c0104684 <free_pages>
    assert(nr_free == 3);
c0103a23:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103a28:	83 f8 03             	cmp    $0x3,%eax
c0103a2b:	74 24                	je     c0103a51 <basic_check+0x31c>
c0103a2d:	c7 44 24 0c bb 94 10 	movl   $0xc01094bb,0xc(%esp)
c0103a34:	c0 
c0103a35:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103a3c:	c0 
c0103a3d:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103a44:	00 
c0103a45:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103a4c:	e8 84 d2 ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a58:	e8 bc 0b 00 00       	call   c0104619 <alloc_pages>
c0103a5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103a60:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103a64:	75 24                	jne    c0103a8a <basic_check+0x355>
c0103a66:	c7 44 24 0c 84 93 10 	movl   $0xc0109384,0xc(%esp)
c0103a6d:	c0 
c0103a6e:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103a75:	c0 
c0103a76:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103a7d:	00 
c0103a7e:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103a85:	e8 4b d2 ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103a8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a91:	e8 83 0b 00 00       	call   c0104619 <alloc_pages>
c0103a96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a9d:	75 24                	jne    c0103ac3 <basic_check+0x38e>
c0103a9f:	c7 44 24 0c a0 93 10 	movl   $0xc01093a0,0xc(%esp)
c0103aa6:	c0 
c0103aa7:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103aae:	c0 
c0103aaf:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103ab6:	00 
c0103ab7:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103abe:	e8 12 d2 ff ff       	call   c0100cd5 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103ac3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103aca:	e8 4a 0b 00 00       	call   c0104619 <alloc_pages>
c0103acf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ad2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ad6:	75 24                	jne    c0103afc <basic_check+0x3c7>
c0103ad8:	c7 44 24 0c bc 93 10 	movl   $0xc01093bc,0xc(%esp)
c0103adf:	c0 
c0103ae0:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103ae7:	c0 
c0103ae8:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103aef:	00 
c0103af0:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103af7:	e8 d9 d1 ff ff       	call   c0100cd5 <__panic>

    assert(alloc_page() == NULL);
c0103afc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b03:	e8 11 0b 00 00       	call   c0104619 <alloc_pages>
c0103b08:	85 c0                	test   %eax,%eax
c0103b0a:	74 24                	je     c0103b30 <basic_check+0x3fb>
c0103b0c:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c0103b13:	c0 
c0103b14:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103b1b:	c0 
c0103b1c:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103b23:	00 
c0103b24:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103b2b:	e8 a5 d1 ff ff       	call   c0100cd5 <__panic>

    free_page(p0);
c0103b30:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b37:	00 
c0103b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b3b:	89 04 24             	mov    %eax,(%esp)
c0103b3e:	e8 41 0b 00 00       	call   c0104684 <free_pages>
c0103b43:	c7 45 d8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x28(%ebp)
c0103b4a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b4d:	8b 40 04             	mov    0x4(%eax),%eax
c0103b50:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b53:	0f 94 c0             	sete   %al
c0103b56:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b59:	85 c0                	test   %eax,%eax
c0103b5b:	74 24                	je     c0103b81 <basic_check+0x44c>
c0103b5d:	c7 44 24 0c c8 94 10 	movl   $0xc01094c8,0xc(%esp)
c0103b64:	c0 
c0103b65:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103b6c:	c0 
c0103b6d:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103b74:	00 
c0103b75:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103b7c:	e8 54 d1 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103b81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b88:	e8 8c 0a 00 00       	call   c0104619 <alloc_pages>
c0103b8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b93:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103b96:	74 24                	je     c0103bbc <basic_check+0x487>
c0103b98:	c7 44 24 0c e0 94 10 	movl   $0xc01094e0,0xc(%esp)
c0103b9f:	c0 
c0103ba0:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103ba7:	c0 
c0103ba8:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103baf:	00 
c0103bb0:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103bb7:	e8 19 d1 ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103bbc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bc3:	e8 51 0a 00 00       	call   c0104619 <alloc_pages>
c0103bc8:	85 c0                	test   %eax,%eax
c0103bca:	74 24                	je     c0103bf0 <basic_check+0x4bb>
c0103bcc:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c0103bd3:	c0 
c0103bd4:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103bdb:	c0 
c0103bdc:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103be3:	00 
c0103be4:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103beb:	e8 e5 d0 ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c0103bf0:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103bf5:	85 c0                	test   %eax,%eax
c0103bf7:	74 24                	je     c0103c1d <basic_check+0x4e8>
c0103bf9:	c7 44 24 0c f9 94 10 	movl   $0xc01094f9,0xc(%esp)
c0103c00:	c0 
c0103c01:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103c08:	c0 
c0103c09:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103c10:	00 
c0103c11:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103c18:	e8 b8 d0 ff ff       	call   c0100cd5 <__panic>
    free_list = free_list_store;
c0103c1d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c20:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c23:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0103c28:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    nr_free = nr_free_store;
c0103c2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c31:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_page(p);
c0103c36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c3d:	00 
c0103c3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c41:	89 04 24             	mov    %eax,(%esp)
c0103c44:	e8 3b 0a 00 00       	call   c0104684 <free_pages>
    free_page(p1);
c0103c49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c50:	00 
c0103c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c54:	89 04 24             	mov    %eax,(%esp)
c0103c57:	e8 28 0a 00 00       	call   c0104684 <free_pages>
    free_page(p2);
c0103c5c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c63:	00 
c0103c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c67:	89 04 24             	mov    %eax,(%esp)
c0103c6a:	e8 15 0a 00 00       	call   c0104684 <free_pages>
}
c0103c6f:	c9                   	leave  
c0103c70:	c3                   	ret    

c0103c71 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103c71:	55                   	push   %ebp
c0103c72:	89 e5                	mov    %esp,%ebp
c0103c74:	53                   	push   %ebx
c0103c75:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103c7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103c89:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103c90:	eb 6b                	jmp    c0103cfd <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103c92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c95:	83 e8 0c             	sub    $0xc,%eax
c0103c98:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103c9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c9e:	83 c0 04             	add    $0x4,%eax
c0103ca1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103ca8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103cae:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103cb1:	0f a3 10             	bt     %edx,(%eax)
c0103cb4:	19 c0                	sbb    %eax,%eax
c0103cb6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103cb9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103cbd:	0f 95 c0             	setne  %al
c0103cc0:	0f b6 c0             	movzbl %al,%eax
c0103cc3:	85 c0                	test   %eax,%eax
c0103cc5:	75 24                	jne    c0103ceb <default_check+0x7a>
c0103cc7:	c7 44 24 0c 06 95 10 	movl   $0xc0109506,0xc(%esp)
c0103cce:	c0 
c0103ccf:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103cd6:	c0 
c0103cd7:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103cde:	00 
c0103cdf:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103ce6:	e8 ea cf ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c0103ceb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103cf2:	8b 50 08             	mov    0x8(%eax),%edx
c0103cf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cf8:	01 d0                	add    %edx,%eax
c0103cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d00:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d03:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d06:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d09:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d0c:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c0103d13:	0f 85 79 ff ff ff    	jne    c0103c92 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d19:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d1c:	e8 95 09 00 00       	call   c01046b6 <nr_free_pages>
c0103d21:	39 c3                	cmp    %eax,%ebx
c0103d23:	74 24                	je     c0103d49 <default_check+0xd8>
c0103d25:	c7 44 24 0c 16 95 10 	movl   $0xc0109516,0xc(%esp)
c0103d2c:	c0 
c0103d2d:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103d34:	c0 
c0103d35:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103d3c:	00 
c0103d3d:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103d44:	e8 8c cf ff ff       	call   c0100cd5 <__panic>

    basic_check();
c0103d49:	e8 e7 f9 ff ff       	call   c0103735 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d4e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d55:	e8 bf 08 00 00       	call   c0104619 <alloc_pages>
c0103d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103d5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103d61:	75 24                	jne    c0103d87 <default_check+0x116>
c0103d63:	c7 44 24 0c 2f 95 10 	movl   $0xc010952f,0xc(%esp)
c0103d6a:	c0 
c0103d6b:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103d72:	c0 
c0103d73:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103d7a:	00 
c0103d7b:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103d82:	e8 4e cf ff ff       	call   c0100cd5 <__panic>
    assert(!PageProperty(p0));
c0103d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d8a:	83 c0 04             	add    $0x4,%eax
c0103d8d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103d94:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103d97:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103d9a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103d9d:	0f a3 10             	bt     %edx,(%eax)
c0103da0:	19 c0                	sbb    %eax,%eax
c0103da2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103da5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103da9:	0f 95 c0             	setne  %al
c0103dac:	0f b6 c0             	movzbl %al,%eax
c0103daf:	85 c0                	test   %eax,%eax
c0103db1:	74 24                	je     c0103dd7 <default_check+0x166>
c0103db3:	c7 44 24 0c 3a 95 10 	movl   $0xc010953a,0xc(%esp)
c0103dba:	c0 
c0103dbb:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103dc2:	c0 
c0103dc3:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103dca:	00 
c0103dcb:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103dd2:	e8 fe ce ff ff       	call   c0100cd5 <__panic>

    list_entry_t free_list_store = free_list;
c0103dd7:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0103ddc:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0103de2:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103de5:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103de8:	c7 45 b4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103def:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103df2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df5:	89 50 04             	mov    %edx,0x4(%eax)
c0103df8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103dfb:	8b 50 04             	mov    0x4(%eax),%edx
c0103dfe:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e01:	89 10                	mov    %edx,(%eax)
c0103e03:	c7 45 b0 c0 0a 12 c0 	movl   $0xc0120ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e0a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e0d:	8b 40 04             	mov    0x4(%eax),%eax
c0103e10:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e13:	0f 94 c0             	sete   %al
c0103e16:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e19:	85 c0                	test   %eax,%eax
c0103e1b:	75 24                	jne    c0103e41 <default_check+0x1d0>
c0103e1d:	c7 44 24 0c 8f 94 10 	movl   $0xc010948f,0xc(%esp)
c0103e24:	c0 
c0103e25:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103e2c:	c0 
c0103e2d:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103e34:	00 
c0103e35:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103e3c:	e8 94 ce ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103e41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e48:	e8 cc 07 00 00       	call   c0104619 <alloc_pages>
c0103e4d:	85 c0                	test   %eax,%eax
c0103e4f:	74 24                	je     c0103e75 <default_check+0x204>
c0103e51:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c0103e58:	c0 
c0103e59:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103e60:	c0 
c0103e61:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103e68:	00 
c0103e69:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103e70:	e8 60 ce ff ff       	call   c0100cd5 <__panic>

    unsigned int nr_free_store = nr_free;
c0103e75:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0103e7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103e7d:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c0103e84:	00 00 00 

    free_pages(p0 + 2, 3);
c0103e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103e8a:	83 c0 40             	add    $0x40,%eax
c0103e8d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103e94:	00 
c0103e95:	89 04 24             	mov    %eax,(%esp)
c0103e98:	e8 e7 07 00 00       	call   c0104684 <free_pages>
    assert(alloc_pages(4) == NULL);
c0103e9d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103ea4:	e8 70 07 00 00       	call   c0104619 <alloc_pages>
c0103ea9:	85 c0                	test   %eax,%eax
c0103eab:	74 24                	je     c0103ed1 <default_check+0x260>
c0103ead:	c7 44 24 0c 4c 95 10 	movl   $0xc010954c,0xc(%esp)
c0103eb4:	c0 
c0103eb5:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103ebc:	c0 
c0103ebd:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103ec4:	00 
c0103ec5:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103ecc:	e8 04 ce ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103ed1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ed4:	83 c0 40             	add    $0x40,%eax
c0103ed7:	83 c0 04             	add    $0x4,%eax
c0103eda:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103ee1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103ee4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103ee7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103eea:	0f a3 10             	bt     %edx,(%eax)
c0103eed:	19 c0                	sbb    %eax,%eax
c0103eef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103ef2:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103ef6:	0f 95 c0             	setne  %al
c0103ef9:	0f b6 c0             	movzbl %al,%eax
c0103efc:	85 c0                	test   %eax,%eax
c0103efe:	74 0e                	je     c0103f0e <default_check+0x29d>
c0103f00:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f03:	83 c0 40             	add    $0x40,%eax
c0103f06:	8b 40 08             	mov    0x8(%eax),%eax
c0103f09:	83 f8 03             	cmp    $0x3,%eax
c0103f0c:	74 24                	je     c0103f32 <default_check+0x2c1>
c0103f0e:	c7 44 24 0c 64 95 10 	movl   $0xc0109564,0xc(%esp)
c0103f15:	c0 
c0103f16:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103f1d:	c0 
c0103f1e:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103f25:	00 
c0103f26:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f2d:	e8 a3 cd ff ff       	call   c0100cd5 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f32:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f39:	e8 db 06 00 00       	call   c0104619 <alloc_pages>
c0103f3e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f41:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f45:	75 24                	jne    c0103f6b <default_check+0x2fa>
c0103f47:	c7 44 24 0c 90 95 10 	movl   $0xc0109590,0xc(%esp)
c0103f4e:	c0 
c0103f4f:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103f56:	c0 
c0103f57:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103f5e:	00 
c0103f5f:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f66:	e8 6a cd ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c0103f6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f72:	e8 a2 06 00 00       	call   c0104619 <alloc_pages>
c0103f77:	85 c0                	test   %eax,%eax
c0103f79:	74 24                	je     c0103f9f <default_check+0x32e>
c0103f7b:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c0103f82:	c0 
c0103f83:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103f8a:	c0 
c0103f8b:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103f92:	00 
c0103f93:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103f9a:	e8 36 cd ff ff       	call   c0100cd5 <__panic>
    assert(p0 + 2 == p1);
c0103f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fa2:	83 c0 40             	add    $0x40,%eax
c0103fa5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103fa8:	74 24                	je     c0103fce <default_check+0x35d>
c0103faa:	c7 44 24 0c ae 95 10 	movl   $0xc01095ae,0xc(%esp)
c0103fb1:	c0 
c0103fb2:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0103fb9:	c0 
c0103fba:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103fc1:	00 
c0103fc2:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0103fc9:	e8 07 cd ff ff       	call   c0100cd5 <__panic>

    p2 = p0 + 1;
c0103fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fd1:	83 c0 20             	add    $0x20,%eax
c0103fd4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103fd7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fde:	00 
c0103fdf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe2:	89 04 24             	mov    %eax,(%esp)
c0103fe5:	e8 9a 06 00 00       	call   c0104684 <free_pages>
    free_pages(p1, 3);
c0103fea:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103ff1:	00 
c0103ff2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ff5:	89 04 24             	mov    %eax,(%esp)
c0103ff8:	e8 87 06 00 00       	call   c0104684 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104000:	83 c0 04             	add    $0x4,%eax
c0104003:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010400a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010400d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104010:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104013:	0f a3 10             	bt     %edx,(%eax)
c0104016:	19 c0                	sbb    %eax,%eax
c0104018:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010401b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010401f:	0f 95 c0             	setne  %al
c0104022:	0f b6 c0             	movzbl %al,%eax
c0104025:	85 c0                	test   %eax,%eax
c0104027:	74 0b                	je     c0104034 <default_check+0x3c3>
c0104029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010402c:	8b 40 08             	mov    0x8(%eax),%eax
c010402f:	83 f8 01             	cmp    $0x1,%eax
c0104032:	74 24                	je     c0104058 <default_check+0x3e7>
c0104034:	c7 44 24 0c bc 95 10 	movl   $0xc01095bc,0xc(%esp)
c010403b:	c0 
c010403c:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104043:	c0 
c0104044:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010404b:	00 
c010404c:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104053:	e8 7d cc ff ff       	call   c0100cd5 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104058:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010405b:	83 c0 04             	add    $0x4,%eax
c010405e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104065:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104068:	8b 45 90             	mov    -0x70(%ebp),%eax
c010406b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010406e:	0f a3 10             	bt     %edx,(%eax)
c0104071:	19 c0                	sbb    %eax,%eax
c0104073:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0104076:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010407a:	0f 95 c0             	setne  %al
c010407d:	0f b6 c0             	movzbl %al,%eax
c0104080:	85 c0                	test   %eax,%eax
c0104082:	74 0b                	je     c010408f <default_check+0x41e>
c0104084:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104087:	8b 40 08             	mov    0x8(%eax),%eax
c010408a:	83 f8 03             	cmp    $0x3,%eax
c010408d:	74 24                	je     c01040b3 <default_check+0x442>
c010408f:	c7 44 24 0c e4 95 10 	movl   $0xc01095e4,0xc(%esp)
c0104096:	c0 
c0104097:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010409e:	c0 
c010409f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01040a6:	00 
c01040a7:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01040ae:	e8 22 cc ff ff       	call   c0100cd5 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01040b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040ba:	e8 5a 05 00 00       	call   c0104619 <alloc_pages>
c01040bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01040c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01040c5:	83 e8 20             	sub    $0x20,%eax
c01040c8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01040cb:	74 24                	je     c01040f1 <default_check+0x480>
c01040cd:	c7 44 24 0c 0a 96 10 	movl   $0xc010960a,0xc(%esp)
c01040d4:	c0 
c01040d5:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01040dc:	c0 
c01040dd:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01040e4:	00 
c01040e5:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01040ec:	e8 e4 cb ff ff       	call   c0100cd5 <__panic>
    free_page(p0);
c01040f1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040f8:	00 
c01040f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040fc:	89 04 24             	mov    %eax,(%esp)
c01040ff:	e8 80 05 00 00       	call   c0104684 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104104:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010410b:	e8 09 05 00 00       	call   c0104619 <alloc_pages>
c0104110:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104113:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104116:	83 c0 20             	add    $0x20,%eax
c0104119:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010411c:	74 24                	je     c0104142 <default_check+0x4d1>
c010411e:	c7 44 24 0c 28 96 10 	movl   $0xc0109628,0xc(%esp)
c0104125:	c0 
c0104126:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010412d:	c0 
c010412e:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104135:	00 
c0104136:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010413d:	e8 93 cb ff ff       	call   c0100cd5 <__panic>

    free_pages(p0, 2);
c0104142:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0104149:	00 
c010414a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010414d:	89 04 24             	mov    %eax,(%esp)
c0104150:	e8 2f 05 00 00       	call   c0104684 <free_pages>
    free_page(p2);
c0104155:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010415c:	00 
c010415d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104160:	89 04 24             	mov    %eax,(%esp)
c0104163:	e8 1c 05 00 00       	call   c0104684 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104168:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010416f:	e8 a5 04 00 00       	call   c0104619 <alloc_pages>
c0104174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104177:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010417b:	75 24                	jne    c01041a1 <default_check+0x530>
c010417d:	c7 44 24 0c 48 96 10 	movl   $0xc0109648,0xc(%esp)
c0104184:	c0 
c0104185:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c010418c:	c0 
c010418d:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0104194:	00 
c0104195:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c010419c:	e8 34 cb ff ff       	call   c0100cd5 <__panic>
    assert(alloc_page() == NULL);
c01041a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041a8:	e8 6c 04 00 00       	call   c0104619 <alloc_pages>
c01041ad:	85 c0                	test   %eax,%eax
c01041af:	74 24                	je     c01041d5 <default_check+0x564>
c01041b1:	c7 44 24 0c a6 94 10 	movl   $0xc01094a6,0xc(%esp)
c01041b8:	c0 
c01041b9:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01041c0:	c0 
c01041c1:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01041c8:	00 
c01041c9:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01041d0:	e8 00 cb ff ff       	call   c0100cd5 <__panic>

    assert(nr_free == 0);
c01041d5:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01041da:	85 c0                	test   %eax,%eax
c01041dc:	74 24                	je     c0104202 <default_check+0x591>
c01041de:	c7 44 24 0c f9 94 10 	movl   $0xc01094f9,0xc(%esp)
c01041e5:	c0 
c01041e6:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01041ed:	c0 
c01041ee:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c01041f5:	00 
c01041f6:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01041fd:	e8 d3 ca ff ff       	call   c0100cd5 <__panic>
    nr_free = nr_free_store;
c0104202:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104205:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8

    free_list = free_list_store;
c010420a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010420d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104210:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0104215:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4
    free_pages(p0, 5);
c010421b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104222:	00 
c0104223:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104226:	89 04 24             	mov    %eax,(%esp)
c0104229:	e8 56 04 00 00       	call   c0104684 <free_pages>

    le = &free_list;
c010422e:	c7 45 ec c0 0a 12 c0 	movl   $0xc0120ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104235:	eb 1d                	jmp    c0104254 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0104237:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010423a:	83 e8 0c             	sub    $0xc,%eax
c010423d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104240:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104244:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104247:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010424a:	8b 40 08             	mov    0x8(%eax),%eax
c010424d:	29 c2                	sub    %eax,%edx
c010424f:	89 d0                	mov    %edx,%eax
c0104251:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104254:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104257:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010425a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010425d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104260:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104263:	81 7d ec c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x14(%ebp)
c010426a:	75 cb                	jne    c0104237 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010426c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104270:	74 24                	je     c0104296 <default_check+0x625>
c0104272:	c7 44 24 0c 66 96 10 	movl   $0xc0109666,0xc(%esp)
c0104279:	c0 
c010427a:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c0104281:	c0 
c0104282:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0104289:	00 
c010428a:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c0104291:	e8 3f ca ff ff       	call   c0100cd5 <__panic>
    assert(total == 0);
c0104296:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010429a:	74 24                	je     c01042c0 <default_check+0x64f>
c010429c:	c7 44 24 0c 71 96 10 	movl   $0xc0109671,0xc(%esp)
c01042a3:	c0 
c01042a4:	c7 44 24 08 36 93 10 	movl   $0xc0109336,0x8(%esp)
c01042ab:	c0 
c01042ac:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01042b3:	00 
c01042b4:	c7 04 24 4b 93 10 c0 	movl   $0xc010934b,(%esp)
c01042bb:	e8 15 ca ff ff       	call   c0100cd5 <__panic>
}
c01042c0:	81 c4 94 00 00 00    	add    $0x94,%esp
c01042c6:	5b                   	pop    %ebx
c01042c7:	5d                   	pop    %ebp
c01042c8:	c3                   	ret    

c01042c9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01042c9:	55                   	push   %ebp
c01042ca:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01042cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01042cf:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01042d4:	29 c2                	sub    %eax,%edx
c01042d6:	89 d0                	mov    %edx,%eax
c01042d8:	c1 f8 05             	sar    $0x5,%eax
}
c01042db:	5d                   	pop    %ebp
c01042dc:	c3                   	ret    

c01042dd <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01042dd:	55                   	push   %ebp
c01042de:	89 e5                	mov    %esp,%ebp
c01042e0:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01042e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01042e6:	89 04 24             	mov    %eax,(%esp)
c01042e9:	e8 db ff ff ff       	call   c01042c9 <page2ppn>
c01042ee:	c1 e0 0c             	shl    $0xc,%eax
}
c01042f1:	c9                   	leave  
c01042f2:	c3                   	ret    

c01042f3 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01042f3:	55                   	push   %ebp
c01042f4:	89 e5                	mov    %esp,%ebp
c01042f6:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01042f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01042fc:	c1 e8 0c             	shr    $0xc,%eax
c01042ff:	89 c2                	mov    %eax,%edx
c0104301:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104306:	39 c2                	cmp    %eax,%edx
c0104308:	72 1c                	jb     c0104326 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010430a:	c7 44 24 08 ac 96 10 	movl   $0xc01096ac,0x8(%esp)
c0104311:	c0 
c0104312:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0104319:	00 
c010431a:	c7 04 24 cb 96 10 c0 	movl   $0xc01096cb,(%esp)
c0104321:	e8 af c9 ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0104326:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c010432b:	8b 55 08             	mov    0x8(%ebp),%edx
c010432e:	c1 ea 0c             	shr    $0xc,%edx
c0104331:	c1 e2 05             	shl    $0x5,%edx
c0104334:	01 d0                	add    %edx,%eax
}
c0104336:	c9                   	leave  
c0104337:	c3                   	ret    

c0104338 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104338:	55                   	push   %ebp
c0104339:	89 e5                	mov    %esp,%ebp
c010433b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010433e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104341:	89 04 24             	mov    %eax,(%esp)
c0104344:	e8 94 ff ff ff       	call   c01042dd <page2pa>
c0104349:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010434c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434f:	c1 e8 0c             	shr    $0xc,%eax
c0104352:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104355:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010435a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010435d:	72 23                	jb     c0104382 <page2kva+0x4a>
c010435f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104362:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104366:	c7 44 24 08 dc 96 10 	movl   $0xc01096dc,0x8(%esp)
c010436d:	c0 
c010436e:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0104375:	00 
c0104376:	c7 04 24 cb 96 10 c0 	movl   $0xc01096cb,(%esp)
c010437d:	e8 53 c9 ff ff       	call   c0100cd5 <__panic>
c0104382:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104385:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010438a:	c9                   	leave  
c010438b:	c3                   	ret    

c010438c <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010438c:	55                   	push   %ebp
c010438d:	89 e5                	mov    %esp,%ebp
c010438f:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104392:	8b 45 08             	mov    0x8(%ebp),%eax
c0104395:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104398:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010439f:	77 23                	ja     c01043c4 <kva2page+0x38>
c01043a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043a8:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c01043af:	c0 
c01043b0:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01043b7:	00 
c01043b8:	c7 04 24 cb 96 10 c0 	movl   $0xc01096cb,(%esp)
c01043bf:	e8 11 c9 ff ff       	call   c0100cd5 <__panic>
c01043c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043c7:	05 00 00 00 40       	add    $0x40000000,%eax
c01043cc:	89 04 24             	mov    %eax,(%esp)
c01043cf:	e8 1f ff ff ff       	call   c01042f3 <pa2page>
}
c01043d4:	c9                   	leave  
c01043d5:	c3                   	ret    

c01043d6 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c01043d6:	55                   	push   %ebp
c01043d7:	89 e5                	mov    %esp,%ebp
c01043d9:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01043dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01043df:	83 e0 01             	and    $0x1,%eax
c01043e2:	85 c0                	test   %eax,%eax
c01043e4:	75 1c                	jne    c0104402 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01043e6:	c7 44 24 08 24 97 10 	movl   $0xc0109724,0x8(%esp)
c01043ed:	c0 
c01043ee:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01043f5:	00 
c01043f6:	c7 04 24 cb 96 10 c0 	movl   $0xc01096cb,(%esp)
c01043fd:	e8 d3 c8 ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104402:	8b 45 08             	mov    0x8(%ebp),%eax
c0104405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010440a:	89 04 24             	mov    %eax,(%esp)
c010440d:	e8 e1 fe ff ff       	call   c01042f3 <pa2page>
}
c0104412:	c9                   	leave  
c0104413:	c3                   	ret    

c0104414 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104414:	55                   	push   %ebp
c0104415:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104417:	8b 45 08             	mov    0x8(%ebp),%eax
c010441a:	8b 00                	mov    (%eax),%eax
}
c010441c:	5d                   	pop    %ebp
c010441d:	c3                   	ret    

c010441e <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010441e:	55                   	push   %ebp
c010441f:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104421:	8b 45 08             	mov    0x8(%ebp),%eax
c0104424:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104427:	89 10                	mov    %edx,(%eax)
}
c0104429:	5d                   	pop    %ebp
c010442a:	c3                   	ret    

c010442b <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c010442b:	55                   	push   %ebp
c010442c:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010442e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104431:	8b 00                	mov    (%eax),%eax
c0104433:	8d 50 01             	lea    0x1(%eax),%edx
c0104436:	8b 45 08             	mov    0x8(%ebp),%eax
c0104439:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010443b:	8b 45 08             	mov    0x8(%ebp),%eax
c010443e:	8b 00                	mov    (%eax),%eax
}
c0104440:	5d                   	pop    %ebp
c0104441:	c3                   	ret    

c0104442 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104442:	55                   	push   %ebp
c0104443:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104445:	8b 45 08             	mov    0x8(%ebp),%eax
c0104448:	8b 00                	mov    (%eax),%eax
c010444a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010444d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104450:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104452:	8b 45 08             	mov    0x8(%ebp),%eax
c0104455:	8b 00                	mov    (%eax),%eax
}
c0104457:	5d                   	pop    %ebp
c0104458:	c3                   	ret    

c0104459 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104459:	55                   	push   %ebp
c010445a:	89 e5                	mov    %esp,%ebp
c010445c:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010445f:	9c                   	pushf  
c0104460:	58                   	pop    %eax
c0104461:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104464:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104467:	25 00 02 00 00       	and    $0x200,%eax
c010446c:	85 c0                	test   %eax,%eax
c010446e:	74 0c                	je     c010447c <__intr_save+0x23>
        intr_disable();
c0104470:	e8 b8 da ff ff       	call   c0101f2d <intr_disable>
        return 1;
c0104475:	b8 01 00 00 00       	mov    $0x1,%eax
c010447a:	eb 05                	jmp    c0104481 <__intr_save+0x28>
    }
    return 0;
c010447c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104481:	c9                   	leave  
c0104482:	c3                   	ret    

c0104483 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104483:	55                   	push   %ebp
c0104484:	89 e5                	mov    %esp,%ebp
c0104486:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104489:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010448d:	74 05                	je     c0104494 <__intr_restore+0x11>
        intr_enable();
c010448f:	e8 93 da ff ff       	call   c0101f27 <intr_enable>
    }
}
c0104494:	c9                   	leave  
c0104495:	c3                   	ret    

c0104496 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104496:	55                   	push   %ebp
c0104497:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104499:	8b 45 08             	mov    0x8(%ebp),%eax
c010449c:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010449f:	b8 23 00 00 00       	mov    $0x23,%eax
c01044a4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01044a6:	b8 23 00 00 00       	mov    $0x23,%eax
c01044ab:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01044ad:	b8 10 00 00 00       	mov    $0x10,%eax
c01044b2:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01044b4:	b8 10 00 00 00       	mov    $0x10,%eax
c01044b9:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01044bb:	b8 10 00 00 00       	mov    $0x10,%eax
c01044c0:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01044c2:	ea c9 44 10 c0 08 00 	ljmp   $0x8,$0xc01044c9
}
c01044c9:	5d                   	pop    %ebp
c01044ca:	c3                   	ret    

c01044cb <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01044cb:	55                   	push   %ebp
c01044cc:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01044ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d1:	a3 44 0a 12 c0       	mov    %eax,0xc0120a44
}
c01044d6:	5d                   	pop    %ebp
c01044d7:	c3                   	ret    

c01044d8 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c01044d8:	55                   	push   %ebp
c01044d9:	89 e5                	mov    %esp,%ebp
c01044db:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c01044de:	b8 00 f0 11 c0       	mov    $0xc011f000,%eax
c01044e3:	89 04 24             	mov    %eax,(%esp)
c01044e6:	e8 e0 ff ff ff       	call   c01044cb <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c01044eb:	66 c7 05 48 0a 12 c0 	movw   $0x10,0xc0120a48
c01044f2:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c01044f4:	66 c7 05 28 fa 11 c0 	movw   $0x68,0xc011fa28
c01044fb:	68 00 
c01044fd:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c0104502:	66 a3 2a fa 11 c0    	mov    %ax,0xc011fa2a
c0104508:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c010450d:	c1 e8 10             	shr    $0x10,%eax
c0104510:	a2 2c fa 11 c0       	mov    %al,0xc011fa2c
c0104515:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c010451c:	83 e0 f0             	and    $0xfffffff0,%eax
c010451f:	83 c8 09             	or     $0x9,%eax
c0104522:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c0104527:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c010452e:	83 e0 ef             	and    $0xffffffef,%eax
c0104531:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c0104536:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c010453d:	83 e0 9f             	and    $0xffffff9f,%eax
c0104540:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c0104545:	0f b6 05 2d fa 11 c0 	movzbl 0xc011fa2d,%eax
c010454c:	83 c8 80             	or     $0xffffff80,%eax
c010454f:	a2 2d fa 11 c0       	mov    %al,0xc011fa2d
c0104554:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c010455b:	83 e0 f0             	and    $0xfffffff0,%eax
c010455e:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104563:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c010456a:	83 e0 ef             	and    $0xffffffef,%eax
c010456d:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104572:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104579:	83 e0 df             	and    $0xffffffdf,%eax
c010457c:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104581:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104588:	83 c8 40             	or     $0x40,%eax
c010458b:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c0104590:	0f b6 05 2e fa 11 c0 	movzbl 0xc011fa2e,%eax
c0104597:	83 e0 7f             	and    $0x7f,%eax
c010459a:	a2 2e fa 11 c0       	mov    %al,0xc011fa2e
c010459f:	b8 40 0a 12 c0       	mov    $0xc0120a40,%eax
c01045a4:	c1 e8 18             	shr    $0x18,%eax
c01045a7:	a2 2f fa 11 c0       	mov    %al,0xc011fa2f

    // reload all segment registers
    lgdt(&gdt_pd);
c01045ac:	c7 04 24 30 fa 11 c0 	movl   $0xc011fa30,(%esp)
c01045b3:	e8 de fe ff ff       	call   c0104496 <lgdt>
c01045b8:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01045be:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01045c2:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01045c5:	c9                   	leave  
c01045c6:	c3                   	ret    

c01045c7 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01045c7:	55                   	push   %ebp
c01045c8:	89 e5                	mov    %esp,%ebp
c01045ca:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01045cd:	c7 05 cc 0a 12 c0 90 	movl   $0xc0109690,0xc0120acc
c01045d4:	96 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01045d7:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01045dc:	8b 00                	mov    (%eax),%eax
c01045de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045e2:	c7 04 24 50 97 10 c0 	movl   $0xc0109750,(%esp)
c01045e9:	e8 5d bd ff ff       	call   c010034b <cprintf>
    pmm_manager->init();
c01045ee:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01045f3:	8b 40 04             	mov    0x4(%eax),%eax
c01045f6:	ff d0                	call   *%eax
}
c01045f8:	c9                   	leave  
c01045f9:	c3                   	ret    

c01045fa <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c01045fa:	55                   	push   %ebp
c01045fb:	89 e5                	mov    %esp,%ebp
c01045fd:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104600:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104605:	8b 40 08             	mov    0x8(%eax),%eax
c0104608:	8b 55 0c             	mov    0xc(%ebp),%edx
c010460b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010460f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104612:	89 14 24             	mov    %edx,(%esp)
c0104615:	ff d0                	call   *%eax
}
c0104617:	c9                   	leave  
c0104618:	c3                   	ret    

c0104619 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104619:	55                   	push   %ebp
c010461a:	89 e5                	mov    %esp,%ebp
c010461c:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c010461f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104626:	e8 2e fe ff ff       	call   c0104459 <__intr_save>
c010462b:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c010462e:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104633:	8b 40 0c             	mov    0xc(%eax),%eax
c0104636:	8b 55 08             	mov    0x8(%ebp),%edx
c0104639:	89 14 24             	mov    %edx,(%esp)
c010463c:	ff d0                	call   *%eax
c010463e:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104641:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104644:	89 04 24             	mov    %eax,(%esp)
c0104647:	e8 37 fe ff ff       	call   c0104483 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c010464c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104650:	75 2d                	jne    c010467f <alloc_pages+0x66>
c0104652:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104656:	77 27                	ja     c010467f <alloc_pages+0x66>
c0104658:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c010465d:	85 c0                	test   %eax,%eax
c010465f:	74 1e                	je     c010467f <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104661:	8b 55 08             	mov    0x8(%ebp),%edx
c0104664:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0104669:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104670:	00 
c0104671:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104675:	89 04 24             	mov    %eax,(%esp)
c0104678:	e8 97 1a 00 00       	call   c0106114 <swap_out>
    }
c010467d:	eb a7                	jmp    c0104626 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010467f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104682:	c9                   	leave  
c0104683:	c3                   	ret    

c0104684 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104684:	55                   	push   %ebp
c0104685:	89 e5                	mov    %esp,%ebp
c0104687:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010468a:	e8 ca fd ff ff       	call   c0104459 <__intr_save>
c010468f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104692:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c0104697:	8b 40 10             	mov    0x10(%eax),%eax
c010469a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010469d:	89 54 24 04          	mov    %edx,0x4(%esp)
c01046a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01046a4:	89 14 24             	mov    %edx,(%esp)
c01046a7:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c01046a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ac:	89 04 24             	mov    %eax,(%esp)
c01046af:	e8 cf fd ff ff       	call   c0104483 <__intr_restore>
}
c01046b4:	c9                   	leave  
c01046b5:	c3                   	ret    

c01046b6 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01046b6:	55                   	push   %ebp
c01046b7:	89 e5                	mov    %esp,%ebp
c01046b9:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01046bc:	e8 98 fd ff ff       	call   c0104459 <__intr_save>
c01046c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01046c4:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c01046c9:	8b 40 14             	mov    0x14(%eax),%eax
c01046cc:	ff d0                	call   *%eax
c01046ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01046d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d4:	89 04 24             	mov    %eax,(%esp)
c01046d7:	e8 a7 fd ff ff       	call   c0104483 <__intr_restore>
    return ret;
c01046dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01046df:	c9                   	leave  
c01046e0:	c3                   	ret    

c01046e1 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c01046e1:	55                   	push   %ebp
c01046e2:	89 e5                	mov    %esp,%ebp
c01046e4:	57                   	push   %edi
c01046e5:	56                   	push   %esi
c01046e6:	53                   	push   %ebx
c01046e7:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c01046ed:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c01046f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c01046fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104702:	c7 04 24 67 97 10 c0 	movl   $0xc0109767,(%esp)
c0104709:	e8 3d bc ff ff       	call   c010034b <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010470e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104715:	e9 15 01 00 00       	jmp    c010482f <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010471a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010471d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104720:	89 d0                	mov    %edx,%eax
c0104722:	c1 e0 02             	shl    $0x2,%eax
c0104725:	01 d0                	add    %edx,%eax
c0104727:	c1 e0 02             	shl    $0x2,%eax
c010472a:	01 c8                	add    %ecx,%eax
c010472c:	8b 50 08             	mov    0x8(%eax),%edx
c010472f:	8b 40 04             	mov    0x4(%eax),%eax
c0104732:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104735:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104738:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010473b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010473e:	89 d0                	mov    %edx,%eax
c0104740:	c1 e0 02             	shl    $0x2,%eax
c0104743:	01 d0                	add    %edx,%eax
c0104745:	c1 e0 02             	shl    $0x2,%eax
c0104748:	01 c8                	add    %ecx,%eax
c010474a:	8b 48 0c             	mov    0xc(%eax),%ecx
c010474d:	8b 58 10             	mov    0x10(%eax),%ebx
c0104750:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104753:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104756:	01 c8                	add    %ecx,%eax
c0104758:	11 da                	adc    %ebx,%edx
c010475a:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010475d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104760:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104763:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104766:	89 d0                	mov    %edx,%eax
c0104768:	c1 e0 02             	shl    $0x2,%eax
c010476b:	01 d0                	add    %edx,%eax
c010476d:	c1 e0 02             	shl    $0x2,%eax
c0104770:	01 c8                	add    %ecx,%eax
c0104772:	83 c0 14             	add    $0x14,%eax
c0104775:	8b 00                	mov    (%eax),%eax
c0104777:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c010477d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104780:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104783:	83 c0 ff             	add    $0xffffffff,%eax
c0104786:	83 d2 ff             	adc    $0xffffffff,%edx
c0104789:	89 c6                	mov    %eax,%esi
c010478b:	89 d7                	mov    %edx,%edi
c010478d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104790:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104793:	89 d0                	mov    %edx,%eax
c0104795:	c1 e0 02             	shl    $0x2,%eax
c0104798:	01 d0                	add    %edx,%eax
c010479a:	c1 e0 02             	shl    $0x2,%eax
c010479d:	01 c8                	add    %ecx,%eax
c010479f:	8b 48 0c             	mov    0xc(%eax),%ecx
c01047a2:	8b 58 10             	mov    0x10(%eax),%ebx
c01047a5:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c01047ab:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01047af:	89 74 24 14          	mov    %esi,0x14(%esp)
c01047b3:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01047b7:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01047ba:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01047bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047c1:	89 54 24 10          	mov    %edx,0x10(%esp)
c01047c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01047c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01047cd:	c7 04 24 74 97 10 c0 	movl   $0xc0109774,(%esp)
c01047d4:	e8 72 bb ff ff       	call   c010034b <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01047d9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01047dc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01047df:	89 d0                	mov    %edx,%eax
c01047e1:	c1 e0 02             	shl    $0x2,%eax
c01047e4:	01 d0                	add    %edx,%eax
c01047e6:	c1 e0 02             	shl    $0x2,%eax
c01047e9:	01 c8                	add    %ecx,%eax
c01047eb:	83 c0 14             	add    $0x14,%eax
c01047ee:	8b 00                	mov    (%eax),%eax
c01047f0:	83 f8 01             	cmp    $0x1,%eax
c01047f3:	75 36                	jne    c010482b <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c01047f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01047fb:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01047fe:	77 2b                	ja     c010482b <page_init+0x14a>
c0104800:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104803:	72 05                	jb     c010480a <page_init+0x129>
c0104805:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104808:	73 21                	jae    c010482b <page_init+0x14a>
c010480a:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010480e:	77 1b                	ja     c010482b <page_init+0x14a>
c0104810:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104814:	72 09                	jb     c010481f <page_init+0x13e>
c0104816:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010481d:	77 0c                	ja     c010482b <page_init+0x14a>
                maxpa = end;
c010481f:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104822:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104825:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104828:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010482b:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010482f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104832:	8b 00                	mov    (%eax),%eax
c0104834:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104837:	0f 8f dd fe ff ff    	jg     c010471a <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010483d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104841:	72 1d                	jb     c0104860 <page_init+0x17f>
c0104843:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104847:	77 09                	ja     c0104852 <page_init+0x171>
c0104849:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104850:	76 0e                	jbe    c0104860 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104852:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104859:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104860:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104863:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104866:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010486a:	c1 ea 0c             	shr    $0xc,%edx
c010486d:	a3 20 0a 12 c0       	mov    %eax,0xc0120a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104872:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104879:	b8 b0 0b 12 c0       	mov    $0xc0120bb0,%eax
c010487e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104881:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104884:	01 d0                	add    %edx,%eax
c0104886:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104889:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010488c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104891:	f7 75 ac             	divl   -0x54(%ebp)
c0104894:	89 d0                	mov    %edx,%eax
c0104896:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104899:	29 c2                	sub    %eax,%edx
c010489b:	89 d0                	mov    %edx,%eax
c010489d:	a3 d4 0a 12 c0       	mov    %eax,0xc0120ad4

    for (i = 0; i < npage; i ++) {
c01048a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01048a9:	eb 27                	jmp    c01048d2 <page_init+0x1f1>
        SetPageReserved(pages + i);
c01048ab:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01048b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048b3:	c1 e2 05             	shl    $0x5,%edx
c01048b6:	01 d0                	add    %edx,%eax
c01048b8:	83 c0 04             	add    $0x4,%eax
c01048bb:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01048c2:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01048c5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01048c8:	8b 55 90             	mov    -0x70(%ebp),%edx
c01048cb:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01048ce:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01048d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048d5:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01048da:	39 c2                	cmp    %eax,%edx
c01048dc:	72 cd                	jb     c01048ab <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01048de:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01048e3:	c1 e0 05             	shl    $0x5,%eax
c01048e6:	89 c2                	mov    %eax,%edx
c01048e8:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c01048ed:	01 d0                	add    %edx,%eax
c01048ef:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c01048f2:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01048f9:	77 23                	ja     c010491e <page_init+0x23d>
c01048fb:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01048fe:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104902:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c0104909:	c0 
c010490a:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104911:	00 
c0104912:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104919:	e8 b7 c3 ff ff       	call   c0100cd5 <__panic>
c010491e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104921:	05 00 00 00 40       	add    $0x40000000,%eax
c0104926:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104929:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104930:	e9 74 01 00 00       	jmp    c0104aa9 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104935:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104938:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010493b:	89 d0                	mov    %edx,%eax
c010493d:	c1 e0 02             	shl    $0x2,%eax
c0104940:	01 d0                	add    %edx,%eax
c0104942:	c1 e0 02             	shl    $0x2,%eax
c0104945:	01 c8                	add    %ecx,%eax
c0104947:	8b 50 08             	mov    0x8(%eax),%edx
c010494a:	8b 40 04             	mov    0x4(%eax),%eax
c010494d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104950:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104953:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104956:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104959:	89 d0                	mov    %edx,%eax
c010495b:	c1 e0 02             	shl    $0x2,%eax
c010495e:	01 d0                	add    %edx,%eax
c0104960:	c1 e0 02             	shl    $0x2,%eax
c0104963:	01 c8                	add    %ecx,%eax
c0104965:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104968:	8b 58 10             	mov    0x10(%eax),%ebx
c010496b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010496e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104971:	01 c8                	add    %ecx,%eax
c0104973:	11 da                	adc    %ebx,%edx
c0104975:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104978:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010497b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010497e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104981:	89 d0                	mov    %edx,%eax
c0104983:	c1 e0 02             	shl    $0x2,%eax
c0104986:	01 d0                	add    %edx,%eax
c0104988:	c1 e0 02             	shl    $0x2,%eax
c010498b:	01 c8                	add    %ecx,%eax
c010498d:	83 c0 14             	add    $0x14,%eax
c0104990:	8b 00                	mov    (%eax),%eax
c0104992:	83 f8 01             	cmp    $0x1,%eax
c0104995:	0f 85 0a 01 00 00    	jne    c0104aa5 <page_init+0x3c4>
            if (begin < freemem) {
c010499b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010499e:	ba 00 00 00 00       	mov    $0x0,%edx
c01049a3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01049a6:	72 17                	jb     c01049bf <page_init+0x2de>
c01049a8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01049ab:	77 05                	ja     c01049b2 <page_init+0x2d1>
c01049ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01049b0:	76 0d                	jbe    c01049bf <page_init+0x2de>
                begin = freemem;
c01049b2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01049b5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01049b8:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01049bf:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01049c3:	72 1d                	jb     c01049e2 <page_init+0x301>
c01049c5:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01049c9:	77 09                	ja     c01049d4 <page_init+0x2f3>
c01049cb:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01049d2:	76 0e                	jbe    c01049e2 <page_init+0x301>
                end = KMEMSIZE;
c01049d4:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01049db:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01049e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01049e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01049e8:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01049eb:	0f 87 b4 00 00 00    	ja     c0104aa5 <page_init+0x3c4>
c01049f1:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01049f4:	72 09                	jb     c01049ff <page_init+0x31e>
c01049f6:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01049f9:	0f 83 a6 00 00 00    	jae    c0104aa5 <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c01049ff:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104a06:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104a09:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104a0c:	01 d0                	add    %edx,%eax
c0104a0e:	83 e8 01             	sub    $0x1,%eax
c0104a11:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104a14:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104a17:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a1c:	f7 75 9c             	divl   -0x64(%ebp)
c0104a1f:	89 d0                	mov    %edx,%eax
c0104a21:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104a24:	29 c2                	sub    %eax,%edx
c0104a26:	89 d0                	mov    %edx,%eax
c0104a28:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a30:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104a33:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a36:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104a39:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104a3c:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a41:	89 c7                	mov    %eax,%edi
c0104a43:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104a49:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104a4c:	89 d0                	mov    %edx,%eax
c0104a4e:	83 e0 00             	and    $0x0,%eax
c0104a51:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104a54:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104a57:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104a5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104a5d:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104a60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104a66:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a69:	77 3a                	ja     c0104aa5 <page_init+0x3c4>
c0104a6b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104a6e:	72 05                	jb     c0104a75 <page_init+0x394>
c0104a70:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104a73:	73 30                	jae    c0104aa5 <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104a75:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104a78:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104a7b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104a7e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104a81:	29 c8                	sub    %ecx,%eax
c0104a83:	19 da                	sbb    %ebx,%edx
c0104a85:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104a89:	c1 ea 0c             	shr    $0xc,%edx
c0104a8c:	89 c3                	mov    %eax,%ebx
c0104a8e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104a91:	89 04 24             	mov    %eax,(%esp)
c0104a94:	e8 5a f8 ff ff       	call   c01042f3 <pa2page>
c0104a99:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104a9d:	89 04 24             	mov    %eax,(%esp)
c0104aa0:	e8 55 fb ff ff       	call   c01045fa <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104aa5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104aa9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104aac:	8b 00                	mov    (%eax),%eax
c0104aae:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104ab1:	0f 8f 7e fe ff ff    	jg     c0104935 <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104ab7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104abd:	5b                   	pop    %ebx
c0104abe:	5e                   	pop    %esi
c0104abf:	5f                   	pop    %edi
c0104ac0:	5d                   	pop    %ebp
c0104ac1:	c3                   	ret    

c0104ac2 <enable_paging>:

static void
enable_paging(void) {
c0104ac2:	55                   	push   %ebp
c0104ac3:	89 e5                	mov    %esp,%ebp
c0104ac5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104ac8:	a1 d0 0a 12 c0       	mov    0xc0120ad0,%eax
c0104acd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104ad0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104ad3:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104ad6:	0f 20 c0             	mov    %cr0,%eax
c0104ad9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0104adc:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104adf:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104ae2:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104ae9:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104af3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af6:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104af9:	c9                   	leave  
c0104afa:	c3                   	ret    

c0104afb <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104afb:	55                   	push   %ebp
c0104afc:	89 e5                	mov    %esp,%ebp
c0104afe:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104b01:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b04:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b07:	31 d0                	xor    %edx,%eax
c0104b09:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b0e:	85 c0                	test   %eax,%eax
c0104b10:	74 24                	je     c0104b36 <boot_map_segment+0x3b>
c0104b12:	c7 44 24 0c b2 97 10 	movl   $0xc01097b2,0xc(%esp)
c0104b19:	c0 
c0104b1a:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0104b21:	c0 
c0104b22:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104b29:	00 
c0104b2a:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104b31:	e8 9f c1 ff ff       	call   c0100cd5 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104b36:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b40:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b45:	89 c2                	mov    %eax,%edx
c0104b47:	8b 45 10             	mov    0x10(%ebp),%eax
c0104b4a:	01 c2                	add    %eax,%edx
c0104b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b4f:	01 d0                	add    %edx,%eax
c0104b51:	83 e8 01             	sub    $0x1,%eax
c0104b54:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b5a:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b5f:	f7 75 f0             	divl   -0x10(%ebp)
c0104b62:	89 d0                	mov    %edx,%eax
c0104b64:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104b67:	29 c2                	sub    %eax,%edx
c0104b69:	89 d0                	mov    %edx,%eax
c0104b6b:	c1 e8 0c             	shr    $0xc,%eax
c0104b6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104b71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104b74:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104b77:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b7a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b7f:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104b82:	8b 45 14             	mov    0x14(%ebp),%eax
c0104b85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b90:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104b93:	eb 6b                	jmp    c0104c00 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104b95:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104b9c:	00 
c0104b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ba0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ba7:	89 04 24             	mov    %eax,(%esp)
c0104baa:	e8 cc 01 00 00       	call   c0104d7b <get_pte>
c0104baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104bb2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104bb6:	75 24                	jne    c0104bdc <boot_map_segment+0xe1>
c0104bb8:	c7 44 24 0c de 97 10 	movl   $0xc01097de,0xc(%esp)
c0104bbf:	c0 
c0104bc0:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0104bc7:	c0 
c0104bc8:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104bcf:	00 
c0104bd0:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104bd7:	e8 f9 c0 ff ff       	call   c0100cd5 <__panic>
        *ptep = pa | PTE_P | perm;
c0104bdc:	8b 45 18             	mov    0x18(%ebp),%eax
c0104bdf:	8b 55 14             	mov    0x14(%ebp),%edx
c0104be2:	09 d0                	or     %edx,%eax
c0104be4:	83 c8 01             	or     $0x1,%eax
c0104be7:	89 c2                	mov    %eax,%edx
c0104be9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104bec:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104bee:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104bf2:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104bf9:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c04:	75 8f                	jne    c0104b95 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104c06:	c9                   	leave  
c0104c07:	c3                   	ret    

c0104c08 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104c08:	55                   	push   %ebp
c0104c09:	89 e5                	mov    %esp,%ebp
c0104c0b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104c0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c15:	e8 ff f9 ff ff       	call   c0104619 <alloc_pages>
c0104c1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104c1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104c21:	75 1c                	jne    c0104c3f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104c23:	c7 44 24 08 eb 97 10 	movl   $0xc01097eb,0x8(%esp)
c0104c2a:	c0 
c0104c2b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104c32:	00 
c0104c33:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104c3a:	e8 96 c0 ff ff       	call   c0100cd5 <__panic>
    }
    return page2kva(p);
c0104c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c42:	89 04 24             	mov    %eax,(%esp)
c0104c45:	e8 ee f6 ff ff       	call   c0104338 <page2kva>
}
c0104c4a:	c9                   	leave  
c0104c4b:	c3                   	ret    

c0104c4c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104c4c:	55                   	push   %ebp
c0104c4d:	89 e5                	mov    %esp,%ebp
c0104c4f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104c52:	e8 70 f9 ff ff       	call   c01045c7 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104c57:	e8 85 fa ff ff       	call   c01046e1 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104c5c:	e8 31 05 00 00       	call   c0105192 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104c61:	e8 a2 ff ff ff       	call   c0104c08 <boot_alloc_page>
c0104c66:	a3 24 0a 12 c0       	mov    %eax,0xc0120a24
    memset(boot_pgdir, 0, PGSIZE);
c0104c6b:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104c77:	00 
c0104c78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c7f:	00 
c0104c80:	89 04 24             	mov    %eax,(%esp)
c0104c83:	e8 a7 3c 00 00       	call   c010892f <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104c88:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c90:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104c97:	77 23                	ja     c0104cbc <pmm_init+0x70>
c0104c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c9c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ca0:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c0104ca7:	c0 
c0104ca8:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104caf:	00 
c0104cb0:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104cb7:	e8 19 c0 ff ff       	call   c0100cd5 <__panic>
c0104cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cbf:	05 00 00 00 40       	add    $0x40000000,%eax
c0104cc4:	a3 d0 0a 12 c0       	mov    %eax,0xc0120ad0

    check_pgdir();
c0104cc9:	e8 e2 04 00 00       	call   c01051b0 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104cce:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104cd3:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104cd9:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104cde:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ce1:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104ce8:	77 23                	ja     c0104d0d <pmm_init+0xc1>
c0104cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ced:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104cf1:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c0104cf8:	c0 
c0104cf9:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104d00:	00 
c0104d01:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104d08:	e8 c8 bf ff ff       	call   c0100cd5 <__panic>
c0104d0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d10:	05 00 00 00 40       	add    $0x40000000,%eax
c0104d15:	83 c8 03             	or     $0x3,%eax
c0104d18:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104d1a:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d1f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104d26:	00 
c0104d27:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104d2e:	00 
c0104d2f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104d36:	38 
c0104d37:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104d3e:	c0 
c0104d3f:	89 04 24             	mov    %eax,(%esp)
c0104d42:	e8 b4 fd ff ff       	call   c0104afb <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104d47:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d4c:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0104d52:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104d58:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104d5a:	e8 63 fd ff ff       	call   c0104ac2 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104d5f:	e8 74 f7 ff ff       	call   c01044d8 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104d64:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0104d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104d6f:	e8 d7 0a 00 00       	call   c010584b <check_boot_pgdir>

    print_pgdir();
c0104d74:	e8 64 0f 00 00       	call   c0105cdd <print_pgdir>

}
c0104d79:	c9                   	leave  
c0104d7a:	c3                   	ret    

c0104d7b <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104d7b:	55                   	push   %ebp
c0104d7c:	89 e5                	mov    %esp,%ebp
c0104d7e:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104d81:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d84:	c1 e8 16             	shr    $0x16,%eax
c0104d87:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d91:	01 d0                	add    %edx,%eax
c0104d93:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d99:	8b 00                	mov    (%eax),%eax
c0104d9b:	83 e0 01             	and    $0x1,%eax
c0104d9e:	85 c0                	test   %eax,%eax
c0104da0:	0f 85 af 00 00 00    	jne    c0104e55 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104da6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104daa:	74 15                	je     c0104dc1 <get_pte+0x46>
c0104dac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104db3:	e8 61 f8 ff ff       	call   c0104619 <alloc_pages>
c0104db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104dbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104dbf:	75 0a                	jne    c0104dcb <get_pte+0x50>
            return NULL;
c0104dc1:	b8 00 00 00 00       	mov    $0x0,%eax
c0104dc6:	e9 e6 00 00 00       	jmp    c0104eb1 <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0104dcb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dd2:	00 
c0104dd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd6:	89 04 24             	mov    %eax,(%esp)
c0104dd9:	e8 40 f6 ff ff       	call   c010441e <set_page_ref>
        uintptr_t pa = page2pa(page);
c0104dde:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104de1:	89 04 24             	mov    %eax,(%esp)
c0104de4:	e8 f4 f4 ff ff       	call   c01042dd <page2pa>
c0104de9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0104dec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104def:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104df2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104df5:	c1 e8 0c             	shr    $0xc,%eax
c0104df8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104dfb:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104e00:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104e03:	72 23                	jb     c0104e28 <get_pte+0xad>
c0104e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e08:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e0c:	c7 44 24 08 dc 96 10 	movl   $0xc01096dc,0x8(%esp)
c0104e13:	c0 
c0104e14:	c7 44 24 04 94 01 00 	movl   $0x194,0x4(%esp)
c0104e1b:	00 
c0104e1c:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104e23:	e8 ad be ff ff       	call   c0100cd5 <__panic>
c0104e28:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e2b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e30:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e37:	00 
c0104e38:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e3f:	00 
c0104e40:	89 04 24             	mov    %eax,(%esp)
c0104e43:	e8 e7 3a 00 00       	call   c010892f <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104e48:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e4b:	83 c8 07             	or     $0x7,%eax
c0104e4e:	89 c2                	mov    %eax,%edx
c0104e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e53:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e58:	8b 00                	mov    (%eax),%eax
c0104e5a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e65:	c1 e8 0c             	shr    $0xc,%eax
c0104e68:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104e6b:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0104e70:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104e73:	72 23                	jb     c0104e98 <get_pte+0x11d>
c0104e75:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e78:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e7c:	c7 44 24 08 dc 96 10 	movl   $0xc01096dc,0x8(%esp)
c0104e83:	c0 
c0104e84:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0104e8b:	00 
c0104e8c:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0104e93:	e8 3d be ff ff       	call   c0100cd5 <__panic>
c0104e98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104e9b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104ea0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104ea3:	c1 ea 0c             	shr    $0xc,%edx
c0104ea6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104eac:	c1 e2 02             	shl    $0x2,%edx
c0104eaf:	01 d0                	add    %edx,%eax
}
c0104eb1:	c9                   	leave  
c0104eb2:	c3                   	ret    

c0104eb3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0104eb3:	55                   	push   %ebp
c0104eb4:	89 e5                	mov    %esp,%ebp
c0104eb6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104eb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ec0:	00 
c0104ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ec4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ec8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ecb:	89 04 24             	mov    %eax,(%esp)
c0104ece:	e8 a8 fe ff ff       	call   c0104d7b <get_pte>
c0104ed3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104ed6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104eda:	74 08                	je     c0104ee4 <get_page+0x31>
        *ptep_store = ptep;
c0104edc:	8b 45 10             	mov    0x10(%ebp),%eax
c0104edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ee2:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104ee8:	74 1b                	je     c0104f05 <get_page+0x52>
c0104eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eed:	8b 00                	mov    (%eax),%eax
c0104eef:	83 e0 01             	and    $0x1,%eax
c0104ef2:	85 c0                	test   %eax,%eax
c0104ef4:	74 0f                	je     c0104f05 <get_page+0x52>
        return pa2page(*ptep);
c0104ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ef9:	8b 00                	mov    (%eax),%eax
c0104efb:	89 04 24             	mov    %eax,(%esp)
c0104efe:	e8 f0 f3 ff ff       	call   c01042f3 <pa2page>
c0104f03:	eb 05                	jmp    c0104f0a <get_page+0x57>
    }
    return NULL;
c0104f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104f0a:	c9                   	leave  
c0104f0b:	c3                   	ret    

c0104f0c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0104f0c:	55                   	push   %ebp
c0104f0d:	89 e5                	mov    %esp,%ebp
c0104f0f:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0104f12:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f15:	8b 00                	mov    (%eax),%eax
c0104f17:	83 e0 01             	and    $0x1,%eax
c0104f1a:	85 c0                	test   %eax,%eax
c0104f1c:	74 4d                	je     c0104f6b <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c0104f1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f21:	8b 00                	mov    (%eax),%eax
c0104f23:	89 04 24             	mov    %eax,(%esp)
c0104f26:	e8 ab f4 ff ff       	call   c01043d6 <pte2page>
c0104f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c0104f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f31:	89 04 24             	mov    %eax,(%esp)
c0104f34:	e8 09 f5 ff ff       	call   c0104442 <page_ref_dec>
c0104f39:	85 c0                	test   %eax,%eax
c0104f3b:	75 13                	jne    c0104f50 <page_remove_pte+0x44>
            free_page(page);
c0104f3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f44:	00 
c0104f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f48:	89 04 24             	mov    %eax,(%esp)
c0104f4b:	e8 34 f7 ff ff       	call   c0104684 <free_pages>
        }
        *ptep = 0;
c0104f50:	8b 45 10             	mov    0x10(%ebp),%eax
c0104f53:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104f59:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f60:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f63:	89 04 24             	mov    %eax,(%esp)
c0104f66:	e8 ff 00 00 00       	call   c010506a <tlb_invalidate>
    }
}
c0104f6b:	c9                   	leave  
c0104f6c:	c3                   	ret    

c0104f6d <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104f6d:	55                   	push   %ebp
c0104f6e:	89 e5                	mov    %esp,%ebp
c0104f70:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104f73:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f7a:	00 
c0104f7b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f85:	89 04 24             	mov    %eax,(%esp)
c0104f88:	e8 ee fd ff ff       	call   c0104d7b <get_pte>
c0104f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104f90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f94:	74 19                	je     c0104faf <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f99:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104f9d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fa7:	89 04 24             	mov    %eax,(%esp)
c0104faa:	e8 5d ff ff ff       	call   c0104f0c <page_remove_pte>
    }
}
c0104faf:	c9                   	leave  
c0104fb0:	c3                   	ret    

c0104fb1 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104fb1:	55                   	push   %ebp
c0104fb2:	89 e5                	mov    %esp,%ebp
c0104fb4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104fb7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104fbe:	00 
c0104fbf:	8b 45 10             	mov    0x10(%ebp),%eax
c0104fc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104fc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc9:	89 04 24             	mov    %eax,(%esp)
c0104fcc:	e8 aa fd ff ff       	call   c0104d7b <get_pte>
c0104fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104fd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104fd8:	75 0a                	jne    c0104fe4 <page_insert+0x33>
        return -E_NO_MEM;
c0104fda:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104fdf:	e9 84 00 00 00       	jmp    c0105068 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104fe7:	89 04 24             	mov    %eax,(%esp)
c0104fea:	e8 3c f4 ff ff       	call   c010442b <page_ref_inc>
    if (*ptep & PTE_P) {
c0104fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ff2:	8b 00                	mov    (%eax),%eax
c0104ff4:	83 e0 01             	and    $0x1,%eax
c0104ff7:	85 c0                	test   %eax,%eax
c0104ff9:	74 3e                	je     c0105039 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0104ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ffe:	8b 00                	mov    (%eax),%eax
c0105000:	89 04 24             	mov    %eax,(%esp)
c0105003:	e8 ce f3 ff ff       	call   c01043d6 <pte2page>
c0105008:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010500b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010500e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105011:	75 0d                	jne    c0105020 <page_insert+0x6f>
            page_ref_dec(page);
c0105013:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105016:	89 04 24             	mov    %eax,(%esp)
c0105019:	e8 24 f4 ff ff       	call   c0104442 <page_ref_dec>
c010501e:	eb 19                	jmp    c0105039 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105020:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105023:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105027:	8b 45 10             	mov    0x10(%ebp),%eax
c010502a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010502e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105031:	89 04 24             	mov    %eax,(%esp)
c0105034:	e8 d3 fe ff ff       	call   c0104f0c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105039:	8b 45 0c             	mov    0xc(%ebp),%eax
c010503c:	89 04 24             	mov    %eax,(%esp)
c010503f:	e8 99 f2 ff ff       	call   c01042dd <page2pa>
c0105044:	0b 45 14             	or     0x14(%ebp),%eax
c0105047:	83 c8 01             	or     $0x1,%eax
c010504a:	89 c2                	mov    %eax,%edx
c010504c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010504f:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105051:	8b 45 10             	mov    0x10(%ebp),%eax
c0105054:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105058:	8b 45 08             	mov    0x8(%ebp),%eax
c010505b:	89 04 24             	mov    %eax,(%esp)
c010505e:	e8 07 00 00 00       	call   c010506a <tlb_invalidate>
    return 0;
c0105063:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105068:	c9                   	leave  
c0105069:	c3                   	ret    

c010506a <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010506a:	55                   	push   %ebp
c010506b:	89 e5                	mov    %esp,%ebp
c010506d:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105070:	0f 20 d8             	mov    %cr3,%eax
c0105073:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0105076:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105079:	89 c2                	mov    %eax,%edx
c010507b:	8b 45 08             	mov    0x8(%ebp),%eax
c010507e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105081:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105088:	77 23                	ja     c01050ad <tlb_invalidate+0x43>
c010508a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010508d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105091:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c0105098:	c0 
c0105099:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c01050a0:	00 
c01050a1:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01050a8:	e8 28 bc ff ff       	call   c0100cd5 <__panic>
c01050ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050b0:	05 00 00 00 40       	add    $0x40000000,%eax
c01050b5:	39 c2                	cmp    %eax,%edx
c01050b7:	75 0c                	jne    c01050c5 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01050b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01050bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01050c2:	0f 01 38             	invlpg (%eax)
    }
}
c01050c5:	c9                   	leave  
c01050c6:	c3                   	ret    

c01050c7 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c01050c7:	55                   	push   %ebp
c01050c8:	89 e5                	mov    %esp,%ebp
c01050ca:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c01050cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01050d4:	e8 40 f5 ff ff       	call   c0104619 <alloc_pages>
c01050d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01050dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01050e0:	0f 84 a7 00 00 00    	je     c010518d <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01050e6:	8b 45 10             	mov    0x10(%ebp),%eax
c01050e9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01050f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01050fe:	89 04 24             	mov    %eax,(%esp)
c0105101:	e8 ab fe ff ff       	call   c0104fb1 <page_insert>
c0105106:	85 c0                	test   %eax,%eax
c0105108:	74 1a                	je     c0105124 <pgdir_alloc_page+0x5d>
            free_page(page);
c010510a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105111:	00 
c0105112:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105115:	89 04 24             	mov    %eax,(%esp)
c0105118:	e8 67 f5 ff ff       	call   c0104684 <free_pages>
            return NULL;
c010511d:	b8 00 00 00 00       	mov    $0x0,%eax
c0105122:	eb 6c                	jmp    c0105190 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105124:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0105129:	85 c0                	test   %eax,%eax
c010512b:	74 60                	je     c010518d <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010512d:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0105132:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105139:	00 
c010513a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010513d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105141:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105144:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105148:	89 04 24             	mov    %eax,(%esp)
c010514b:	e8 78 0f 00 00       	call   c01060c8 <swap_map_swappable>
            page->pra_vaddr=la;
c0105150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105153:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105156:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105159:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010515c:	89 04 24             	mov    %eax,(%esp)
c010515f:	e8 b0 f2 ff ff       	call   c0104414 <page_ref>
c0105164:	83 f8 01             	cmp    $0x1,%eax
c0105167:	74 24                	je     c010518d <pgdir_alloc_page+0xc6>
c0105169:	c7 44 24 0c 04 98 10 	movl   $0xc0109804,0xc(%esp)
c0105170:	c0 
c0105171:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105178:	c0 
c0105179:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0105180:	00 
c0105181:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105188:	e8 48 bb ff ff       	call   c0100cd5 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c010518d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105190:	c9                   	leave  
c0105191:	c3                   	ret    

c0105192 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105192:	55                   	push   %ebp
c0105193:	89 e5                	mov    %esp,%ebp
c0105195:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105198:	a1 cc 0a 12 c0       	mov    0xc0120acc,%eax
c010519d:	8b 40 18             	mov    0x18(%eax),%eax
c01051a0:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01051a2:	c7 04 24 18 98 10 c0 	movl   $0xc0109818,(%esp)
c01051a9:	e8 9d b1 ff ff       	call   c010034b <cprintf>
}
c01051ae:	c9                   	leave  
c01051af:	c3                   	ret    

c01051b0 <check_pgdir>:

static void
check_pgdir(void) {
c01051b0:	55                   	push   %ebp
c01051b1:	89 e5                	mov    %esp,%ebp
c01051b3:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01051b6:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c01051bb:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01051c0:	76 24                	jbe    c01051e6 <check_pgdir+0x36>
c01051c2:	c7 44 24 0c 37 98 10 	movl   $0xc0109837,0xc(%esp)
c01051c9:	c0 
c01051ca:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01051d1:	c0 
c01051d2:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01051d9:	00 
c01051da:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01051e1:	e8 ef ba ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01051e6:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01051eb:	85 c0                	test   %eax,%eax
c01051ed:	74 0e                	je     c01051fd <check_pgdir+0x4d>
c01051ef:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01051f4:	25 ff 0f 00 00       	and    $0xfff,%eax
c01051f9:	85 c0                	test   %eax,%eax
c01051fb:	74 24                	je     c0105221 <check_pgdir+0x71>
c01051fd:	c7 44 24 0c 54 98 10 	movl   $0xc0109854,0xc(%esp)
c0105204:	c0 
c0105205:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c010520c:	c0 
c010520d:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0105214:	00 
c0105215:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010521c:	e8 b4 ba ff ff       	call   c0100cd5 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105221:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105226:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010522d:	00 
c010522e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105235:	00 
c0105236:	89 04 24             	mov    %eax,(%esp)
c0105239:	e8 75 fc ff ff       	call   c0104eb3 <get_page>
c010523e:	85 c0                	test   %eax,%eax
c0105240:	74 24                	je     c0105266 <check_pgdir+0xb6>
c0105242:	c7 44 24 0c 8c 98 10 	movl   $0xc010988c,0xc(%esp)
c0105249:	c0 
c010524a:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105251:	c0 
c0105252:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105259:	00 
c010525a:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105261:	e8 6f ba ff ff       	call   c0100cd5 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105266:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010526d:	e8 a7 f3 ff ff       	call   c0104619 <alloc_pages>
c0105272:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105275:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010527a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105281:	00 
c0105282:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105289:	00 
c010528a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010528d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105291:	89 04 24             	mov    %eax,(%esp)
c0105294:	e8 18 fd ff ff       	call   c0104fb1 <page_insert>
c0105299:	85 c0                	test   %eax,%eax
c010529b:	74 24                	je     c01052c1 <check_pgdir+0x111>
c010529d:	c7 44 24 0c b4 98 10 	movl   $0xc01098b4,0xc(%esp)
c01052a4:	c0 
c01052a5:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01052ac:	c0 
c01052ad:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c01052b4:	00 
c01052b5:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01052bc:	e8 14 ba ff ff       	call   c0100cd5 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01052c1:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01052c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01052cd:	00 
c01052ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01052d5:	00 
c01052d6:	89 04 24             	mov    %eax,(%esp)
c01052d9:	e8 9d fa ff ff       	call   c0104d7b <get_pte>
c01052de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01052e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01052e5:	75 24                	jne    c010530b <check_pgdir+0x15b>
c01052e7:	c7 44 24 0c e0 98 10 	movl   $0xc01098e0,0xc(%esp)
c01052ee:	c0 
c01052ef:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01052f6:	c0 
c01052f7:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01052fe:	00 
c01052ff:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105306:	e8 ca b9 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c010530b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010530e:	8b 00                	mov    (%eax),%eax
c0105310:	89 04 24             	mov    %eax,(%esp)
c0105313:	e8 db ef ff ff       	call   c01042f3 <pa2page>
c0105318:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010531b:	74 24                	je     c0105341 <check_pgdir+0x191>
c010531d:	c7 44 24 0c 0d 99 10 	movl   $0xc010990d,0xc(%esp)
c0105324:	c0 
c0105325:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c010532c:	c0 
c010532d:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0105334:	00 
c0105335:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010533c:	e8 94 b9 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 1);
c0105341:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105344:	89 04 24             	mov    %eax,(%esp)
c0105347:	e8 c8 f0 ff ff       	call   c0104414 <page_ref>
c010534c:	83 f8 01             	cmp    $0x1,%eax
c010534f:	74 24                	je     c0105375 <check_pgdir+0x1c5>
c0105351:	c7 44 24 0c 22 99 10 	movl   $0xc0109922,0xc(%esp)
c0105358:	c0 
c0105359:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105360:	c0 
c0105361:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105368:	00 
c0105369:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105370:	e8 60 b9 ff ff       	call   c0100cd5 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105375:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010537a:	8b 00                	mov    (%eax),%eax
c010537c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105381:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105384:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105387:	c1 e8 0c             	shr    $0xc,%eax
c010538a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010538d:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105392:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105395:	72 23                	jb     c01053ba <check_pgdir+0x20a>
c0105397:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010539a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010539e:	c7 44 24 08 dc 96 10 	movl   $0xc01096dc,0x8(%esp)
c01053a5:	c0 
c01053a6:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01053ad:	00 
c01053ae:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01053b5:	e8 1b b9 ff ff       	call   c0100cd5 <__panic>
c01053ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053bd:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01053c2:	83 c0 04             	add    $0x4,%eax
c01053c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01053c8:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01053cd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053d4:	00 
c01053d5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01053dc:	00 
c01053dd:	89 04 24             	mov    %eax,(%esp)
c01053e0:	e8 96 f9 ff ff       	call   c0104d7b <get_pte>
c01053e5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01053e8:	74 24                	je     c010540e <check_pgdir+0x25e>
c01053ea:	c7 44 24 0c 34 99 10 	movl   $0xc0109934,0xc(%esp)
c01053f1:	c0 
c01053f2:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01053f9:	c0 
c01053fa:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105401:	00 
c0105402:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105409:	e8 c7 b8 ff ff       	call   c0100cd5 <__panic>

    p2 = alloc_page();
c010540e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105415:	e8 ff f1 ff ff       	call   c0104619 <alloc_pages>
c010541a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010541d:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105422:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105429:	00 
c010542a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105431:	00 
c0105432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105435:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105439:	89 04 24             	mov    %eax,(%esp)
c010543c:	e8 70 fb ff ff       	call   c0104fb1 <page_insert>
c0105441:	85 c0                	test   %eax,%eax
c0105443:	74 24                	je     c0105469 <check_pgdir+0x2b9>
c0105445:	c7 44 24 0c 5c 99 10 	movl   $0xc010995c,0xc(%esp)
c010544c:	c0 
c010544d:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105454:	c0 
c0105455:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c010545c:	00 
c010545d:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105464:	e8 6c b8 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105469:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010546e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105475:	00 
c0105476:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010547d:	00 
c010547e:	89 04 24             	mov    %eax,(%esp)
c0105481:	e8 f5 f8 ff ff       	call   c0104d7b <get_pte>
c0105486:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105489:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010548d:	75 24                	jne    c01054b3 <check_pgdir+0x303>
c010548f:	c7 44 24 0c 94 99 10 	movl   $0xc0109994,0xc(%esp)
c0105496:	c0 
c0105497:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c010549e:	c0 
c010549f:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c01054a6:	00 
c01054a7:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01054ae:	e8 22 b8 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_U);
c01054b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b6:	8b 00                	mov    (%eax),%eax
c01054b8:	83 e0 04             	and    $0x4,%eax
c01054bb:	85 c0                	test   %eax,%eax
c01054bd:	75 24                	jne    c01054e3 <check_pgdir+0x333>
c01054bf:	c7 44 24 0c c4 99 10 	movl   $0xc01099c4,0xc(%esp)
c01054c6:	c0 
c01054c7:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01054ce:	c0 
c01054cf:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01054d6:	00 
c01054d7:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01054de:	e8 f2 b7 ff ff       	call   c0100cd5 <__panic>
    assert(*ptep & PTE_W);
c01054e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054e6:	8b 00                	mov    (%eax),%eax
c01054e8:	83 e0 02             	and    $0x2,%eax
c01054eb:	85 c0                	test   %eax,%eax
c01054ed:	75 24                	jne    c0105513 <check_pgdir+0x363>
c01054ef:	c7 44 24 0c d2 99 10 	movl   $0xc01099d2,0xc(%esp)
c01054f6:	c0 
c01054f7:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01054fe:	c0 
c01054ff:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105506:	00 
c0105507:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010550e:	e8 c2 b7 ff ff       	call   c0100cd5 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105513:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105518:	8b 00                	mov    (%eax),%eax
c010551a:	83 e0 04             	and    $0x4,%eax
c010551d:	85 c0                	test   %eax,%eax
c010551f:	75 24                	jne    c0105545 <check_pgdir+0x395>
c0105521:	c7 44 24 0c e0 99 10 	movl   $0xc01099e0,0xc(%esp)
c0105528:	c0 
c0105529:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105530:	c0 
c0105531:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105538:	00 
c0105539:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105540:	e8 90 b7 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 1);
c0105545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105548:	89 04 24             	mov    %eax,(%esp)
c010554b:	e8 c4 ee ff ff       	call   c0104414 <page_ref>
c0105550:	83 f8 01             	cmp    $0x1,%eax
c0105553:	74 24                	je     c0105579 <check_pgdir+0x3c9>
c0105555:	c7 44 24 0c f6 99 10 	movl   $0xc01099f6,0xc(%esp)
c010555c:	c0 
c010555d:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105564:	c0 
c0105565:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010556c:	00 
c010556d:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105574:	e8 5c b7 ff ff       	call   c0100cd5 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105579:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010557e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105585:	00 
c0105586:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010558d:	00 
c010558e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105591:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105595:	89 04 24             	mov    %eax,(%esp)
c0105598:	e8 14 fa ff ff       	call   c0104fb1 <page_insert>
c010559d:	85 c0                	test   %eax,%eax
c010559f:	74 24                	je     c01055c5 <check_pgdir+0x415>
c01055a1:	c7 44 24 0c 08 9a 10 	movl   $0xc0109a08,0xc(%esp)
c01055a8:	c0 
c01055a9:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01055b0:	c0 
c01055b1:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c01055b8:	00 
c01055b9:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01055c0:	e8 10 b7 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p1) == 2);
c01055c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055c8:	89 04 24             	mov    %eax,(%esp)
c01055cb:	e8 44 ee ff ff       	call   c0104414 <page_ref>
c01055d0:	83 f8 02             	cmp    $0x2,%eax
c01055d3:	74 24                	je     c01055f9 <check_pgdir+0x449>
c01055d5:	c7 44 24 0c 34 9a 10 	movl   $0xc0109a34,0xc(%esp)
c01055dc:	c0 
c01055dd:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01055e4:	c0 
c01055e5:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c01055ec:	00 
c01055ed:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01055f4:	e8 dc b6 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c01055f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055fc:	89 04 24             	mov    %eax,(%esp)
c01055ff:	e8 10 ee ff ff       	call   c0104414 <page_ref>
c0105604:	85 c0                	test   %eax,%eax
c0105606:	74 24                	je     c010562c <check_pgdir+0x47c>
c0105608:	c7 44 24 0c 46 9a 10 	movl   $0xc0109a46,0xc(%esp)
c010560f:	c0 
c0105610:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105617:	c0 
c0105618:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010561f:	00 
c0105620:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105627:	e8 a9 b6 ff ff       	call   c0100cd5 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010562c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105631:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105638:	00 
c0105639:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105640:	00 
c0105641:	89 04 24             	mov    %eax,(%esp)
c0105644:	e8 32 f7 ff ff       	call   c0104d7b <get_pte>
c0105649:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010564c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105650:	75 24                	jne    c0105676 <check_pgdir+0x4c6>
c0105652:	c7 44 24 0c 94 99 10 	movl   $0xc0109994,0xc(%esp)
c0105659:	c0 
c010565a:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105661:	c0 
c0105662:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105669:	00 
c010566a:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105671:	e8 5f b6 ff ff       	call   c0100cd5 <__panic>
    assert(pa2page(*ptep) == p1);
c0105676:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105679:	8b 00                	mov    (%eax),%eax
c010567b:	89 04 24             	mov    %eax,(%esp)
c010567e:	e8 70 ec ff ff       	call   c01042f3 <pa2page>
c0105683:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105686:	74 24                	je     c01056ac <check_pgdir+0x4fc>
c0105688:	c7 44 24 0c 0d 99 10 	movl   $0xc010990d,0xc(%esp)
c010568f:	c0 
c0105690:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105697:	c0 
c0105698:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c010569f:	00 
c01056a0:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01056a7:	e8 29 b6 ff ff       	call   c0100cd5 <__panic>
    assert((*ptep & PTE_U) == 0);
c01056ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056af:	8b 00                	mov    (%eax),%eax
c01056b1:	83 e0 04             	and    $0x4,%eax
c01056b4:	85 c0                	test   %eax,%eax
c01056b6:	74 24                	je     c01056dc <check_pgdir+0x52c>
c01056b8:	c7 44 24 0c 58 9a 10 	movl   $0xc0109a58,0xc(%esp)
c01056bf:	c0 
c01056c0:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01056c7:	c0 
c01056c8:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01056cf:	00 
c01056d0:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01056d7:	e8 f9 b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, 0x0);
c01056dc:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01056e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01056e8:	00 
c01056e9:	89 04 24             	mov    %eax,(%esp)
c01056ec:	e8 7c f8 ff ff       	call   c0104f6d <page_remove>
    assert(page_ref(p1) == 1);
c01056f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056f4:	89 04 24             	mov    %eax,(%esp)
c01056f7:	e8 18 ed ff ff       	call   c0104414 <page_ref>
c01056fc:	83 f8 01             	cmp    $0x1,%eax
c01056ff:	74 24                	je     c0105725 <check_pgdir+0x575>
c0105701:	c7 44 24 0c 22 99 10 	movl   $0xc0109922,0xc(%esp)
c0105708:	c0 
c0105709:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105710:	c0 
c0105711:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105718:	00 
c0105719:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105720:	e8 b0 b5 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c0105725:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105728:	89 04 24             	mov    %eax,(%esp)
c010572b:	e8 e4 ec ff ff       	call   c0104414 <page_ref>
c0105730:	85 c0                	test   %eax,%eax
c0105732:	74 24                	je     c0105758 <check_pgdir+0x5a8>
c0105734:	c7 44 24 0c 46 9a 10 	movl   $0xc0109a46,0xc(%esp)
c010573b:	c0 
c010573c:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105743:	c0 
c0105744:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c010574b:	00 
c010574c:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105753:	e8 7d b5 ff ff       	call   c0100cd5 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105758:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010575d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105764:	00 
c0105765:	89 04 24             	mov    %eax,(%esp)
c0105768:	e8 00 f8 ff ff       	call   c0104f6d <page_remove>
    assert(page_ref(p1) == 0);
c010576d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105770:	89 04 24             	mov    %eax,(%esp)
c0105773:	e8 9c ec ff ff       	call   c0104414 <page_ref>
c0105778:	85 c0                	test   %eax,%eax
c010577a:	74 24                	je     c01057a0 <check_pgdir+0x5f0>
c010577c:	c7 44 24 0c 6d 9a 10 	movl   $0xc0109a6d,0xc(%esp)
c0105783:	c0 
c0105784:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c010578b:	c0 
c010578c:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105793:	00 
c0105794:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010579b:	e8 35 b5 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p2) == 0);
c01057a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a3:	89 04 24             	mov    %eax,(%esp)
c01057a6:	e8 69 ec ff ff       	call   c0104414 <page_ref>
c01057ab:	85 c0                	test   %eax,%eax
c01057ad:	74 24                	je     c01057d3 <check_pgdir+0x623>
c01057af:	c7 44 24 0c 46 9a 10 	movl   $0xc0109a46,0xc(%esp)
c01057b6:	c0 
c01057b7:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01057be:	c0 
c01057bf:	c7 44 24 04 42 02 00 	movl   $0x242,0x4(%esp)
c01057c6:	00 
c01057c7:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01057ce:	e8 02 b5 ff ff       	call   c0100cd5 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01057d3:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01057d8:	8b 00                	mov    (%eax),%eax
c01057da:	89 04 24             	mov    %eax,(%esp)
c01057dd:	e8 11 eb ff ff       	call   c01042f3 <pa2page>
c01057e2:	89 04 24             	mov    %eax,(%esp)
c01057e5:	e8 2a ec ff ff       	call   c0104414 <page_ref>
c01057ea:	83 f8 01             	cmp    $0x1,%eax
c01057ed:	74 24                	je     c0105813 <check_pgdir+0x663>
c01057ef:	c7 44 24 0c 80 9a 10 	movl   $0xc0109a80,0xc(%esp)
c01057f6:	c0 
c01057f7:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01057fe:	c0 
c01057ff:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105806:	00 
c0105807:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010580e:	e8 c2 b4 ff ff       	call   c0100cd5 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105813:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105818:	8b 00                	mov    (%eax),%eax
c010581a:	89 04 24             	mov    %eax,(%esp)
c010581d:	e8 d1 ea ff ff       	call   c01042f3 <pa2page>
c0105822:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105829:	00 
c010582a:	89 04 24             	mov    %eax,(%esp)
c010582d:	e8 52 ee ff ff       	call   c0104684 <free_pages>
    boot_pgdir[0] = 0;
c0105832:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010583d:	c7 04 24 a6 9a 10 c0 	movl   $0xc0109aa6,(%esp)
c0105844:	e8 02 ab ff ff       	call   c010034b <cprintf>
}
c0105849:	c9                   	leave  
c010584a:	c3                   	ret    

c010584b <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010584b:	55                   	push   %ebp
c010584c:	89 e5                	mov    %esp,%ebp
c010584e:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105851:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105858:	e9 ca 00 00 00       	jmp    c0105927 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010585d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105860:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105863:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105866:	c1 e8 0c             	shr    $0xc,%eax
c0105869:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010586c:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105871:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105874:	72 23                	jb     c0105899 <check_boot_pgdir+0x4e>
c0105876:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105879:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010587d:	c7 44 24 08 dc 96 10 	movl   $0xc01096dc,0x8(%esp)
c0105884:	c0 
c0105885:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c010588c:	00 
c010588d:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105894:	e8 3c b4 ff ff       	call   c0100cd5 <__panic>
c0105899:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010589c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01058a1:	89 c2                	mov    %eax,%edx
c01058a3:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01058a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01058af:	00 
c01058b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01058b4:	89 04 24             	mov    %eax,(%esp)
c01058b7:	e8 bf f4 ff ff       	call   c0104d7b <get_pte>
c01058bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058bf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01058c3:	75 24                	jne    c01058e9 <check_boot_pgdir+0x9e>
c01058c5:	c7 44 24 0c c0 9a 10 	movl   $0xc0109ac0,0xc(%esp)
c01058cc:	c0 
c01058cd:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01058d4:	c0 
c01058d5:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c01058dc:	00 
c01058dd:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01058e4:	e8 ec b3 ff ff       	call   c0100cd5 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01058e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058ec:	8b 00                	mov    (%eax),%eax
c01058ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01058f3:	89 c2                	mov    %eax,%edx
c01058f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058f8:	39 c2                	cmp    %eax,%edx
c01058fa:	74 24                	je     c0105920 <check_boot_pgdir+0xd5>
c01058fc:	c7 44 24 0c fd 9a 10 	movl   $0xc0109afd,0xc(%esp)
c0105903:	c0 
c0105904:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c010590b:	c0 
c010590c:	c7 44 24 04 51 02 00 	movl   $0x251,0x4(%esp)
c0105913:	00 
c0105914:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c010591b:	e8 b5 b3 ff ff       	call   c0100cd5 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105920:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105927:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010592a:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c010592f:	39 c2                	cmp    %eax,%edx
c0105931:	0f 82 26 ff ff ff    	jb     c010585d <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105937:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010593c:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105941:	8b 00                	mov    (%eax),%eax
c0105943:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105948:	89 c2                	mov    %eax,%edx
c010594a:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c010594f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105952:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105959:	77 23                	ja     c010597e <check_boot_pgdir+0x133>
c010595b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010595e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105962:	c7 44 24 08 00 97 10 	movl   $0xc0109700,0x8(%esp)
c0105969:	c0 
c010596a:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0105971:	00 
c0105972:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105979:	e8 57 b3 ff ff       	call   c0100cd5 <__panic>
c010597e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105981:	05 00 00 00 40       	add    $0x40000000,%eax
c0105986:	39 c2                	cmp    %eax,%edx
c0105988:	74 24                	je     c01059ae <check_boot_pgdir+0x163>
c010598a:	c7 44 24 0c 14 9b 10 	movl   $0xc0109b14,0xc(%esp)
c0105991:	c0 
c0105992:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105999:	c0 
c010599a:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c01059a1:	00 
c01059a2:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01059a9:	e8 27 b3 ff ff       	call   c0100cd5 <__panic>

    assert(boot_pgdir[0] == 0);
c01059ae:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01059b3:	8b 00                	mov    (%eax),%eax
c01059b5:	85 c0                	test   %eax,%eax
c01059b7:	74 24                	je     c01059dd <check_boot_pgdir+0x192>
c01059b9:	c7 44 24 0c 48 9b 10 	movl   $0xc0109b48,0xc(%esp)
c01059c0:	c0 
c01059c1:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c01059c8:	c0 
c01059c9:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c01059d0:	00 
c01059d1:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c01059d8:	e8 f8 b2 ff ff       	call   c0100cd5 <__panic>

    struct Page *p;
    p = alloc_page();
c01059dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059e4:	e8 30 ec ff ff       	call   c0104619 <alloc_pages>
c01059e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01059ec:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c01059f1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01059f8:	00 
c01059f9:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105a00:	00 
c0105a01:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a04:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a08:	89 04 24             	mov    %eax,(%esp)
c0105a0b:	e8 a1 f5 ff ff       	call   c0104fb1 <page_insert>
c0105a10:	85 c0                	test   %eax,%eax
c0105a12:	74 24                	je     c0105a38 <check_boot_pgdir+0x1ed>
c0105a14:	c7 44 24 0c 5c 9b 10 	movl   $0xc0109b5c,0xc(%esp)
c0105a1b:	c0 
c0105a1c:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105a23:	c0 
c0105a24:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105a2b:	00 
c0105a2c:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105a33:	e8 9d b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 1);
c0105a38:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a3b:	89 04 24             	mov    %eax,(%esp)
c0105a3e:	e8 d1 e9 ff ff       	call   c0104414 <page_ref>
c0105a43:	83 f8 01             	cmp    $0x1,%eax
c0105a46:	74 24                	je     c0105a6c <check_boot_pgdir+0x221>
c0105a48:	c7 44 24 0c 8a 9b 10 	movl   $0xc0109b8a,0xc(%esp)
c0105a4f:	c0 
c0105a50:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105a57:	c0 
c0105a58:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0105a5f:	00 
c0105a60:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105a67:	e8 69 b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105a6c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105a71:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105a78:	00 
c0105a79:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105a80:	00 
c0105a81:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105a84:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a88:	89 04 24             	mov    %eax,(%esp)
c0105a8b:	e8 21 f5 ff ff       	call   c0104fb1 <page_insert>
c0105a90:	85 c0                	test   %eax,%eax
c0105a92:	74 24                	je     c0105ab8 <check_boot_pgdir+0x26d>
c0105a94:	c7 44 24 0c 9c 9b 10 	movl   $0xc0109b9c,0xc(%esp)
c0105a9b:	c0 
c0105a9c:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105aa3:	c0 
c0105aa4:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105aab:	00 
c0105aac:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105ab3:	e8 1d b2 ff ff       	call   c0100cd5 <__panic>
    assert(page_ref(p) == 2);
c0105ab8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105abb:	89 04 24             	mov    %eax,(%esp)
c0105abe:	e8 51 e9 ff ff       	call   c0104414 <page_ref>
c0105ac3:	83 f8 02             	cmp    $0x2,%eax
c0105ac6:	74 24                	je     c0105aec <check_boot_pgdir+0x2a1>
c0105ac8:	c7 44 24 0c d3 9b 10 	movl   $0xc0109bd3,0xc(%esp)
c0105acf:	c0 
c0105ad0:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105ad7:	c0 
c0105ad8:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0105adf:	00 
c0105ae0:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105ae7:	e8 e9 b1 ff ff       	call   c0100cd5 <__panic>

    const char *str = "ucore: Hello world!!";
c0105aec:	c7 45 dc e4 9b 10 c0 	movl   $0xc0109be4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105af3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105af6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105afa:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b01:	e8 52 2b 00 00       	call   c0108658 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105b06:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105b0d:	00 
c0105b0e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b15:	e8 b7 2b 00 00       	call   c01086d1 <strcmp>
c0105b1a:	85 c0                	test   %eax,%eax
c0105b1c:	74 24                	je     c0105b42 <check_boot_pgdir+0x2f7>
c0105b1e:	c7 44 24 0c fc 9b 10 	movl   $0xc0109bfc,0xc(%esp)
c0105b25:	c0 
c0105b26:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105b2d:	c0 
c0105b2e:	c7 44 24 04 61 02 00 	movl   $0x261,0x4(%esp)
c0105b35:	00 
c0105b36:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105b3d:	e8 93 b1 ff ff       	call   c0100cd5 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105b42:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b45:	89 04 24             	mov    %eax,(%esp)
c0105b48:	e8 eb e7 ff ff       	call   c0104338 <page2kva>
c0105b4d:	05 00 01 00 00       	add    $0x100,%eax
c0105b52:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105b55:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105b5c:	e8 9f 2a 00 00       	call   c0108600 <strlen>
c0105b61:	85 c0                	test   %eax,%eax
c0105b63:	74 24                	je     c0105b89 <check_boot_pgdir+0x33e>
c0105b65:	c7 44 24 0c 34 9c 10 	movl   $0xc0109c34,0xc(%esp)
c0105b6c:	c0 
c0105b6d:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105b74:	c0 
c0105b75:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0105b7c:	00 
c0105b7d:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105b84:	e8 4c b1 ff ff       	call   c0100cd5 <__panic>

    free_page(p);
c0105b89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105b90:	00 
c0105b91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b94:	89 04 24             	mov    %eax,(%esp)
c0105b97:	e8 e8 ea ff ff       	call   c0104684 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0105b9c:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105ba1:	8b 00                	mov    (%eax),%eax
c0105ba3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ba8:	89 04 24             	mov    %eax,(%esp)
c0105bab:	e8 43 e7 ff ff       	call   c01042f3 <pa2page>
c0105bb0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105bb7:	00 
c0105bb8:	89 04 24             	mov    %eax,(%esp)
c0105bbb:	e8 c4 ea ff ff       	call   c0104684 <free_pages>
    boot_pgdir[0] = 0;
c0105bc0:	a1 24 0a 12 c0       	mov    0xc0120a24,%eax
c0105bc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105bcb:	c7 04 24 58 9c 10 c0 	movl   $0xc0109c58,(%esp)
c0105bd2:	e8 74 a7 ff ff       	call   c010034b <cprintf>
}
c0105bd7:	c9                   	leave  
c0105bd8:	c3                   	ret    

c0105bd9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105bd9:	55                   	push   %ebp
c0105bda:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105bdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdf:	83 e0 04             	and    $0x4,%eax
c0105be2:	85 c0                	test   %eax,%eax
c0105be4:	74 07                	je     c0105bed <perm2str+0x14>
c0105be6:	b8 75 00 00 00       	mov    $0x75,%eax
c0105beb:	eb 05                	jmp    c0105bf2 <perm2str+0x19>
c0105bed:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105bf2:	a2 a8 0a 12 c0       	mov    %al,0xc0120aa8
    str[1] = 'r';
c0105bf7:	c6 05 a9 0a 12 c0 72 	movb   $0x72,0xc0120aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c01:	83 e0 02             	and    $0x2,%eax
c0105c04:	85 c0                	test   %eax,%eax
c0105c06:	74 07                	je     c0105c0f <perm2str+0x36>
c0105c08:	b8 77 00 00 00       	mov    $0x77,%eax
c0105c0d:	eb 05                	jmp    c0105c14 <perm2str+0x3b>
c0105c0f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105c14:	a2 aa 0a 12 c0       	mov    %al,0xc0120aaa
    str[3] = '\0';
c0105c19:	c6 05 ab 0a 12 c0 00 	movb   $0x0,0xc0120aab
    return str;
c0105c20:	b8 a8 0a 12 c0       	mov    $0xc0120aa8,%eax
}
c0105c25:	5d                   	pop    %ebp
c0105c26:	c3                   	ret    

c0105c27 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105c27:	55                   	push   %ebp
c0105c28:	89 e5                	mov    %esp,%ebp
c0105c2a:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105c2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c30:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c33:	72 0a                	jb     c0105c3f <get_pgtable_items+0x18>
        return 0;
c0105c35:	b8 00 00 00 00       	mov    $0x0,%eax
c0105c3a:	e9 9c 00 00 00       	jmp    c0105cdb <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105c3f:	eb 04                	jmp    c0105c45 <get_pgtable_items+0x1e>
        start ++;
c0105c41:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105c45:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c48:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c4b:	73 18                	jae    c0105c65 <get_pgtable_items+0x3e>
c0105c4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c57:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c5a:	01 d0                	add    %edx,%eax
c0105c5c:	8b 00                	mov    (%eax),%eax
c0105c5e:	83 e0 01             	and    $0x1,%eax
c0105c61:	85 c0                	test   %eax,%eax
c0105c63:	74 dc                	je     c0105c41 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105c65:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c68:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105c6b:	73 69                	jae    c0105cd6 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0105c6d:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105c71:	74 08                	je     c0105c7b <get_pgtable_items+0x54>
            *left_store = start;
c0105c73:	8b 45 18             	mov    0x18(%ebp),%eax
c0105c76:	8b 55 10             	mov    0x10(%ebp),%edx
c0105c79:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105c7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c7e:	8d 50 01             	lea    0x1(%eax),%edx
c0105c81:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c84:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105c8b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c8e:	01 d0                	add    %edx,%eax
c0105c90:	8b 00                	mov    (%eax),%eax
c0105c92:	83 e0 07             	and    $0x7,%eax
c0105c95:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105c98:	eb 04                	jmp    c0105c9e <get_pgtable_items+0x77>
            start ++;
c0105c9a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105c9e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105ca4:	73 1d                	jae    c0105cc3 <get_pgtable_items+0x9c>
c0105ca6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105cb0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cb3:	01 d0                	add    %edx,%eax
c0105cb5:	8b 00                	mov    (%eax),%eax
c0105cb7:	83 e0 07             	and    $0x7,%eax
c0105cba:	89 c2                	mov    %eax,%edx
c0105cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cbf:	39 c2                	cmp    %eax,%edx
c0105cc1:	74 d7                	je     c0105c9a <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0105cc3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105cc7:	74 08                	je     c0105cd1 <get_pgtable_items+0xaa>
            *right_store = start;
c0105cc9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105ccc:	8b 55 10             	mov    0x10(%ebp),%edx
c0105ccf:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105cd4:	eb 05                	jmp    c0105cdb <get_pgtable_items+0xb4>
    }
    return 0;
c0105cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105cdb:	c9                   	leave  
c0105cdc:	c3                   	ret    

c0105cdd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105cdd:	55                   	push   %ebp
c0105cde:	89 e5                	mov    %esp,%ebp
c0105ce0:	57                   	push   %edi
c0105ce1:	56                   	push   %esi
c0105ce2:	53                   	push   %ebx
c0105ce3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105ce6:	c7 04 24 78 9c 10 c0 	movl   $0xc0109c78,(%esp)
c0105ced:	e8 59 a6 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
c0105cf2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105cf9:	e9 fa 00 00 00       	jmp    c0105df8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d01:	89 04 24             	mov    %eax,(%esp)
c0105d04:	e8 d0 fe ff ff       	call   c0105bd9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105d09:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105d0c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d0f:	29 d1                	sub    %edx,%ecx
c0105d11:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105d13:	89 d6                	mov    %edx,%esi
c0105d15:	c1 e6 16             	shl    $0x16,%esi
c0105d18:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105d1b:	89 d3                	mov    %edx,%ebx
c0105d1d:	c1 e3 16             	shl    $0x16,%ebx
c0105d20:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d23:	89 d1                	mov    %edx,%ecx
c0105d25:	c1 e1 16             	shl    $0x16,%ecx
c0105d28:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105d2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105d2e:	29 d7                	sub    %edx,%edi
c0105d30:	89 fa                	mov    %edi,%edx
c0105d32:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105d36:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105d3a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d3e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105d42:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d46:	c7 04 24 a9 9c 10 c0 	movl   $0xc0109ca9,(%esp)
c0105d4d:	e8 f9 a5 ff ff       	call   c010034b <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105d52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d55:	c1 e0 0a             	shl    $0xa,%eax
c0105d58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105d5b:	eb 54                	jmp    c0105db1 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d60:	89 04 24             	mov    %eax,(%esp)
c0105d63:	e8 71 fe ff ff       	call   c0105bd9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105d68:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105d6b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d6e:	29 d1                	sub    %edx,%ecx
c0105d70:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105d72:	89 d6                	mov    %edx,%esi
c0105d74:	c1 e6 0c             	shl    $0xc,%esi
c0105d77:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105d7a:	89 d3                	mov    %edx,%ebx
c0105d7c:	c1 e3 0c             	shl    $0xc,%ebx
c0105d7f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d82:	c1 e2 0c             	shl    $0xc,%edx
c0105d85:	89 d1                	mov    %edx,%ecx
c0105d87:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105d8a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105d8d:	29 d7                	sub    %edx,%edi
c0105d8f:	89 fa                	mov    %edi,%edx
c0105d91:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105d95:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105d99:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105da1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105da5:	c7 04 24 c8 9c 10 c0 	movl   $0xc0109cc8,(%esp)
c0105dac:	e8 9a a5 ff ff       	call   c010034b <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105db1:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105db6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105db9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105dbc:	89 ce                	mov    %ecx,%esi
c0105dbe:	c1 e6 0a             	shl    $0xa,%esi
c0105dc1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105dc4:	89 cb                	mov    %ecx,%ebx
c0105dc6:	c1 e3 0a             	shl    $0xa,%ebx
c0105dc9:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105dcc:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105dd0:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105dd3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105dd7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105ddb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ddf:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105de3:	89 1c 24             	mov    %ebx,(%esp)
c0105de6:	e8 3c fe ff ff       	call   c0105c27 <get_pgtable_items>
c0105deb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105dee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105df2:	0f 85 65 ff ff ff    	jne    c0105d5d <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105df8:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105dfd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e00:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105e03:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105e07:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105e0a:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105e0e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105e12:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e16:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105e1d:	00 
c0105e1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105e25:	e8 fd fd ff ff       	call   c0105c27 <get_pgtable_items>
c0105e2a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e2d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e31:	0f 85 c7 fe ff ff    	jne    c0105cfe <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105e37:	c7 04 24 ec 9c 10 c0 	movl   $0xc0109cec,(%esp)
c0105e3e:	e8 08 a5 ff ff       	call   c010034b <cprintf>
}
c0105e43:	83 c4 4c             	add    $0x4c,%esp
c0105e46:	5b                   	pop    %ebx
c0105e47:	5e                   	pop    %esi
c0105e48:	5f                   	pop    %edi
c0105e49:	5d                   	pop    %ebp
c0105e4a:	c3                   	ret    

c0105e4b <kmalloc>:

void *
kmalloc(size_t n) {
c0105e4b:	55                   	push   %ebp
c0105e4c:	89 e5                	mov    %esp,%ebp
c0105e4e:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105e51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105e58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105e5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105e63:	74 09                	je     c0105e6e <kmalloc+0x23>
c0105e65:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c0105e6c:	76 24                	jbe    c0105e92 <kmalloc+0x47>
c0105e6e:	c7 44 24 0c 1d 9d 10 	movl   $0xc0109d1d,0xc(%esp)
c0105e75:	c0 
c0105e76:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105e7d:	c0 
c0105e7e:	c7 44 24 04 b0 02 00 	movl   $0x2b0,0x4(%esp)
c0105e85:	00 
c0105e86:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105e8d:	e8 43 ae ff ff       	call   c0100cd5 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105e92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e95:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105e9a:	c1 e8 0c             	shr    $0xc,%eax
c0105e9d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c0105ea0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ea3:	89 04 24             	mov    %eax,(%esp)
c0105ea6:	e8 6e e7 ff ff       	call   c0104619 <alloc_pages>
c0105eab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c0105eae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105eb2:	75 24                	jne    c0105ed8 <kmalloc+0x8d>
c0105eb4:	c7 44 24 0c 34 9d 10 	movl   $0xc0109d34,0xc(%esp)
c0105ebb:	c0 
c0105ebc:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105ec3:	c0 
c0105ec4:	c7 44 24 04 b3 02 00 	movl   $0x2b3,0x4(%esp)
c0105ecb:	00 
c0105ecc:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105ed3:	e8 fd ad ff ff       	call   c0100cd5 <__panic>
    ptr=page2kva(base);
c0105ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105edb:	89 04 24             	mov    %eax,(%esp)
c0105ede:	e8 55 e4 ff ff       	call   c0104338 <page2kva>
c0105ee3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0105ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105ee9:	c9                   	leave  
c0105eea:	c3                   	ret    

c0105eeb <kfree>:

void 
kfree(void *ptr, size_t n) {
c0105eeb:	55                   	push   %ebp
c0105eec:	89 e5                	mov    %esp,%ebp
c0105eee:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0105ef1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105ef5:	74 09                	je     c0105f00 <kfree+0x15>
c0105ef7:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c0105efe:	76 24                	jbe    c0105f24 <kfree+0x39>
c0105f00:	c7 44 24 0c 1d 9d 10 	movl   $0xc0109d1d,0xc(%esp)
c0105f07:	c0 
c0105f08:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105f0f:	c0 
c0105f10:	c7 44 24 04 ba 02 00 	movl   $0x2ba,0x4(%esp)
c0105f17:	00 
c0105f18:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105f1f:	e8 b1 ad ff ff       	call   c0100cd5 <__panic>
    assert(ptr != NULL);
c0105f24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105f28:	75 24                	jne    c0105f4e <kfree+0x63>
c0105f2a:	c7 44 24 0c 41 9d 10 	movl   $0xc0109d41,0xc(%esp)
c0105f31:	c0 
c0105f32:	c7 44 24 08 c9 97 10 	movl   $0xc01097c9,0x8(%esp)
c0105f39:	c0 
c0105f3a:	c7 44 24 04 bb 02 00 	movl   $0x2bb,0x4(%esp)
c0105f41:	00 
c0105f42:	c7 04 24 a4 97 10 c0 	movl   $0xc01097a4,(%esp)
c0105f49:	e8 87 ad ff ff       	call   c0100cd5 <__panic>
    struct Page *base=NULL;
c0105f4e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0105f55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f58:	05 ff 0f 00 00       	add    $0xfff,%eax
c0105f5d:	c1 e8 0c             	shr    $0xc,%eax
c0105f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0105f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f66:	89 04 24             	mov    %eax,(%esp)
c0105f69:	e8 1e e4 ff ff       	call   c010438c <kva2page>
c0105f6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0105f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f7b:	89 04 24             	mov    %eax,(%esp)
c0105f7e:	e8 01 e7 ff ff       	call   c0104684 <free_pages>
}
c0105f83:	c9                   	leave  
c0105f84:	c3                   	ret    

c0105f85 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0105f85:	55                   	push   %ebp
c0105f86:	89 e5                	mov    %esp,%ebp
c0105f88:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0105f8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8e:	c1 e8 0c             	shr    $0xc,%eax
c0105f91:	89 c2                	mov    %eax,%edx
c0105f93:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0105f98:	39 c2                	cmp    %eax,%edx
c0105f9a:	72 1c                	jb     c0105fb8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0105f9c:	c7 44 24 08 50 9d 10 	movl   $0xc0109d50,0x8(%esp)
c0105fa3:	c0 
c0105fa4:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0105fab:	00 
c0105fac:	c7 04 24 6f 9d 10 c0 	movl   $0xc0109d6f,(%esp)
c0105fb3:	e8 1d ad ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0105fb8:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0105fbd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105fc0:	c1 ea 0c             	shr    $0xc,%edx
c0105fc3:	c1 e2 05             	shl    $0x5,%edx
c0105fc6:	01 d0                	add    %edx,%eax
}
c0105fc8:	c9                   	leave  
c0105fc9:	c3                   	ret    

c0105fca <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0105fca:	55                   	push   %ebp
c0105fcb:	89 e5                	mov    %esp,%ebp
c0105fcd:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0105fd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd3:	83 e0 01             	and    $0x1,%eax
c0105fd6:	85 c0                	test   %eax,%eax
c0105fd8:	75 1c                	jne    c0105ff6 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0105fda:	c7 44 24 08 80 9d 10 	movl   $0xc0109d80,0x8(%esp)
c0105fe1:	c0 
c0105fe2:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0105fe9:	00 
c0105fea:	c7 04 24 6f 9d 10 c0 	movl   $0xc0109d6f,(%esp)
c0105ff1:	e8 df ac ff ff       	call   c0100cd5 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0105ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ff9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ffe:	89 04 24             	mov    %eax,(%esp)
c0106001:	e8 7f ff ff ff       	call   c0105f85 <pa2page>
}
c0106006:	c9                   	leave  
c0106007:	c3                   	ret    

c0106008 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106008:	55                   	push   %ebp
c0106009:	89 e5                	mov    %esp,%ebp
c010600b:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c010600e:	e8 68 1d 00 00       	call   c0107d7b <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106013:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0106018:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c010601d:	76 0c                	jbe    c010602b <swap_init+0x23>
c010601f:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0106024:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106029:	76 25                	jbe    c0106050 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010602b:	a1 7c 0b 12 c0       	mov    0xc0120b7c,%eax
c0106030:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106034:	c7 44 24 08 a1 9d 10 	movl   $0xc0109da1,0x8(%esp)
c010603b:	c0 
c010603c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106043:	00 
c0106044:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010604b:	e8 85 ac ff ff       	call   c0100cd5 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106050:	c7 05 b4 0a 12 c0 40 	movl   $0xc011fa40,0xc0120ab4
c0106057:	fa 11 c0 
     int r = sm->init();
c010605a:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010605f:	8b 40 04             	mov    0x4(%eax),%eax
c0106062:	ff d0                	call   *%eax
c0106064:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106067:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010606b:	75 26                	jne    c0106093 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010606d:	c7 05 ac 0a 12 c0 01 	movl   $0x1,0xc0120aac
c0106074:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106077:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010607c:	8b 00                	mov    (%eax),%eax
c010607e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106082:	c7 04 24 cb 9d 10 c0 	movl   $0xc0109dcb,(%esp)
c0106089:	e8 bd a2 ff ff       	call   c010034b <cprintf>
          check_swap();
c010608e:	e8 a4 04 00 00       	call   c0106537 <check_swap>
     }

     return r;
c0106093:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106096:	c9                   	leave  
c0106097:	c3                   	ret    

c0106098 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106098:	55                   	push   %ebp
c0106099:	89 e5                	mov    %esp,%ebp
c010609b:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010609e:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060a3:	8b 40 08             	mov    0x8(%eax),%eax
c01060a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01060a9:	89 14 24             	mov    %edx,(%esp)
c01060ac:	ff d0                	call   *%eax
}
c01060ae:	c9                   	leave  
c01060af:	c3                   	ret    

c01060b0 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01060b0:	55                   	push   %ebp
c01060b1:	89 e5                	mov    %esp,%ebp
c01060b3:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01060b6:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060bb:	8b 40 0c             	mov    0xc(%eax),%eax
c01060be:	8b 55 08             	mov    0x8(%ebp),%edx
c01060c1:	89 14 24             	mov    %edx,(%esp)
c01060c4:	ff d0                	call   *%eax
}
c01060c6:	c9                   	leave  
c01060c7:	c3                   	ret    

c01060c8 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01060c8:	55                   	push   %ebp
c01060c9:	89 e5                	mov    %esp,%ebp
c01060cb:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01060ce:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01060d3:	8b 40 10             	mov    0x10(%eax),%eax
c01060d6:	8b 55 14             	mov    0x14(%ebp),%edx
c01060d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01060dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01060e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01060e4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01060ee:	89 14 24             	mov    %edx,(%esp)
c01060f1:	ff d0                	call   *%eax
}
c01060f3:	c9                   	leave  
c01060f4:	c3                   	ret    

c01060f5 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01060f5:	55                   	push   %ebp
c01060f6:	89 e5                	mov    %esp,%ebp
c01060f8:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c01060fb:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c0106100:	8b 40 14             	mov    0x14(%eax),%eax
c0106103:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106106:	89 54 24 04          	mov    %edx,0x4(%esp)
c010610a:	8b 55 08             	mov    0x8(%ebp),%edx
c010610d:	89 14 24             	mov    %edx,(%esp)
c0106110:	ff d0                	call   *%eax
}
c0106112:	c9                   	leave  
c0106113:	c3                   	ret    

c0106114 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106114:	55                   	push   %ebp
c0106115:	89 e5                	mov    %esp,%ebp
c0106117:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010611a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106121:	e9 5a 01 00 00       	jmp    c0106280 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106126:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010612b:	8b 40 18             	mov    0x18(%eax),%eax
c010612e:	8b 55 10             	mov    0x10(%ebp),%edx
c0106131:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106135:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c0106138:	89 54 24 04          	mov    %edx,0x4(%esp)
c010613c:	8b 55 08             	mov    0x8(%ebp),%edx
c010613f:	89 14 24             	mov    %edx,(%esp)
c0106142:	ff d0                	call   *%eax
c0106144:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106147:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010614b:	74 18                	je     c0106165 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c010614d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106150:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106154:	c7 04 24 e0 9d 10 c0 	movl   $0xc0109de0,(%esp)
c010615b:	e8 eb a1 ff ff       	call   c010034b <cprintf>
c0106160:	e9 27 01 00 00       	jmp    c010628c <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106165:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106168:	8b 40 1c             	mov    0x1c(%eax),%eax
c010616b:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010616e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106171:	8b 40 0c             	mov    0xc(%eax),%eax
c0106174:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010617b:	00 
c010617c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010617f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106183:	89 04 24             	mov    %eax,(%esp)
c0106186:	e8 f0 eb ff ff       	call   c0104d7b <get_pte>
c010618b:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010618e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106191:	8b 00                	mov    (%eax),%eax
c0106193:	83 e0 01             	and    $0x1,%eax
c0106196:	85 c0                	test   %eax,%eax
c0106198:	75 24                	jne    c01061be <swap_out+0xaa>
c010619a:	c7 44 24 0c 0d 9e 10 	movl   $0xc0109e0d,0xc(%esp)
c01061a1:	c0 
c01061a2:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01061a9:	c0 
c01061aa:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01061b1:	00 
c01061b2:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01061b9:	e8 17 ab ff ff       	call   c0100cd5 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01061be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01061c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061c4:	8b 52 1c             	mov    0x1c(%edx),%edx
c01061c7:	c1 ea 0c             	shr    $0xc,%edx
c01061ca:	83 c2 01             	add    $0x1,%edx
c01061cd:	c1 e2 08             	shl    $0x8,%edx
c01061d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01061d4:	89 14 24             	mov    %edx,(%esp)
c01061d7:	e8 59 1c 00 00       	call   c0107e35 <swapfs_write>
c01061dc:	85 c0                	test   %eax,%eax
c01061de:	74 34                	je     c0106214 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01061e0:	c7 04 24 37 9e 10 c0 	movl   $0xc0109e37,(%esp)
c01061e7:	e8 5f a1 ff ff       	call   c010034b <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01061ec:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c01061f1:	8b 40 10             	mov    0x10(%eax),%eax
c01061f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01061f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01061fe:	00 
c01061ff:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106203:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106206:	89 54 24 04          	mov    %edx,0x4(%esp)
c010620a:	8b 55 08             	mov    0x8(%ebp),%edx
c010620d:	89 14 24             	mov    %edx,(%esp)
c0106210:	ff d0                	call   *%eax
c0106212:	eb 68                	jmp    c010627c <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106217:	8b 40 1c             	mov    0x1c(%eax),%eax
c010621a:	c1 e8 0c             	shr    $0xc,%eax
c010621d:	83 c0 01             	add    $0x1,%eax
c0106220:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106224:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106227:	89 44 24 08          	mov    %eax,0x8(%esp)
c010622b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010622e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106232:	c7 04 24 50 9e 10 c0 	movl   $0xc0109e50,(%esp)
c0106239:	e8 0d a1 ff ff       	call   c010034b <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c010623e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106241:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106244:	c1 e8 0c             	shr    $0xc,%eax
c0106247:	83 c0 01             	add    $0x1,%eax
c010624a:	c1 e0 08             	shl    $0x8,%eax
c010624d:	89 c2                	mov    %eax,%edx
c010624f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106252:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106254:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106257:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010625e:	00 
c010625f:	89 04 24             	mov    %eax,(%esp)
c0106262:	e8 1d e4 ff ff       	call   c0104684 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106267:	8b 45 08             	mov    0x8(%ebp),%eax
c010626a:	8b 40 0c             	mov    0xc(%eax),%eax
c010626d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106270:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106274:	89 04 24             	mov    %eax,(%esp)
c0106277:	e8 ee ed ff ff       	call   c010506a <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010627c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106280:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106283:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106286:	0f 85 9a fe ff ff    	jne    c0106126 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010628c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010628f:	c9                   	leave  
c0106290:	c3                   	ret    

c0106291 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106291:	55                   	push   %ebp
c0106292:	89 e5                	mov    %esp,%ebp
c0106294:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106297:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010629e:	e8 76 e3 ff ff       	call   c0104619 <alloc_pages>
c01062a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01062a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01062aa:	75 24                	jne    c01062d0 <swap_in+0x3f>
c01062ac:	c7 44 24 0c 90 9e 10 	movl   $0xc0109e90,0xc(%esp)
c01062b3:	c0 
c01062b4:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01062bb:	c0 
c01062bc:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01062c3:	00 
c01062c4:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01062cb:	e8 05 aa ff ff       	call   c0100cd5 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01062d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01062d3:	8b 40 0c             	mov    0xc(%eax),%eax
c01062d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01062dd:	00 
c01062de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01062e1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062e5:	89 04 24             	mov    %eax,(%esp)
c01062e8:	e8 8e ea ff ff       	call   c0104d7b <get_pte>
c01062ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c01062f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01062f3:	8b 00                	mov    (%eax),%eax
c01062f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01062f8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062fc:	89 04 24             	mov    %eax,(%esp)
c01062ff:	e8 bf 1a 00 00       	call   c0107dc3 <swapfs_read>
c0106304:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106307:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010630b:	74 2a                	je     c0106337 <swap_in+0xa6>
     {
        assert(r!=0);
c010630d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106311:	75 24                	jne    c0106337 <swap_in+0xa6>
c0106313:	c7 44 24 0c 9d 9e 10 	movl   $0xc0109e9d,0xc(%esp)
c010631a:	c0 
c010631b:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106322:	c0 
c0106323:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010632a:	00 
c010632b:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106332:	e8 9e a9 ff ff       	call   c0100cd5 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106337:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010633a:	8b 00                	mov    (%eax),%eax
c010633c:	c1 e8 08             	shr    $0x8,%eax
c010633f:	89 c2                	mov    %eax,%edx
c0106341:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106344:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106348:	89 54 24 04          	mov    %edx,0x4(%esp)
c010634c:	c7 04 24 a4 9e 10 c0 	movl   $0xc0109ea4,(%esp)
c0106353:	e8 f3 9f ff ff       	call   c010034b <cprintf>
     *ptr_result=result;
c0106358:	8b 45 10             	mov    0x10(%ebp),%eax
c010635b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010635e:	89 10                	mov    %edx,(%eax)
     return 0;
c0106360:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106365:	c9                   	leave  
c0106366:	c3                   	ret    

c0106367 <check_content_set>:



static inline void
check_content_set(void)
{
c0106367:	55                   	push   %ebp
c0106368:	89 e5                	mov    %esp,%ebp
c010636a:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010636d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106372:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106375:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010637a:	83 f8 01             	cmp    $0x1,%eax
c010637d:	74 24                	je     c01063a3 <check_content_set+0x3c>
c010637f:	c7 44 24 0c e2 9e 10 	movl   $0xc0109ee2,0xc(%esp)
c0106386:	c0 
c0106387:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c010638e:	c0 
c010638f:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106396:	00 
c0106397:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010639e:	e8 32 a9 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01063a3:	b8 10 10 00 00       	mov    $0x1010,%eax
c01063a8:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01063ab:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01063b0:	83 f8 01             	cmp    $0x1,%eax
c01063b3:	74 24                	je     c01063d9 <check_content_set+0x72>
c01063b5:	c7 44 24 0c e2 9e 10 	movl   $0xc0109ee2,0xc(%esp)
c01063bc:	c0 
c01063bd:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01063c4:	c0 
c01063c5:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01063cc:	00 
c01063cd:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01063d4:	e8 fc a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01063d9:	b8 00 20 00 00       	mov    $0x2000,%eax
c01063de:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01063e1:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01063e6:	83 f8 02             	cmp    $0x2,%eax
c01063e9:	74 24                	je     c010640f <check_content_set+0xa8>
c01063eb:	c7 44 24 0c f1 9e 10 	movl   $0xc0109ef1,0xc(%esp)
c01063f2:	c0 
c01063f3:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01063fa:	c0 
c01063fb:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106402:	00 
c0106403:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010640a:	e8 c6 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c010640f:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106414:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106417:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c010641c:	83 f8 02             	cmp    $0x2,%eax
c010641f:	74 24                	je     c0106445 <check_content_set+0xde>
c0106421:	c7 44 24 0c f1 9e 10 	movl   $0xc0109ef1,0xc(%esp)
c0106428:	c0 
c0106429:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106430:	c0 
c0106431:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106438:	00 
c0106439:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106440:	e8 90 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106445:	b8 00 30 00 00       	mov    $0x3000,%eax
c010644a:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c010644d:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106452:	83 f8 03             	cmp    $0x3,%eax
c0106455:	74 24                	je     c010647b <check_content_set+0x114>
c0106457:	c7 44 24 0c 00 9f 10 	movl   $0xc0109f00,0xc(%esp)
c010645e:	c0 
c010645f:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106466:	c0 
c0106467:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010646e:	00 
c010646f:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106476:	e8 5a a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c010647b:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106480:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106483:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106488:	83 f8 03             	cmp    $0x3,%eax
c010648b:	74 24                	je     c01064b1 <check_content_set+0x14a>
c010648d:	c7 44 24 0c 00 9f 10 	movl   $0xc0109f00,0xc(%esp)
c0106494:	c0 
c0106495:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c010649c:	c0 
c010649d:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01064a4:	00 
c01064a5:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01064ac:	e8 24 a8 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01064b1:	b8 00 40 00 00       	mov    $0x4000,%eax
c01064b6:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01064b9:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01064be:	83 f8 04             	cmp    $0x4,%eax
c01064c1:	74 24                	je     c01064e7 <check_content_set+0x180>
c01064c3:	c7 44 24 0c 0f 9f 10 	movl   $0xc0109f0f,0xc(%esp)
c01064ca:	c0 
c01064cb:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01064d2:	c0 
c01064d3:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01064da:	00 
c01064db:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01064e2:	e8 ee a7 ff ff       	call   c0100cd5 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c01064e7:	b8 10 40 00 00       	mov    $0x4010,%eax
c01064ec:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01064ef:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c01064f4:	83 f8 04             	cmp    $0x4,%eax
c01064f7:	74 24                	je     c010651d <check_content_set+0x1b6>
c01064f9:	c7 44 24 0c 0f 9f 10 	movl   $0xc0109f0f,0xc(%esp)
c0106500:	c0 
c0106501:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106508:	c0 
c0106509:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106510:	00 
c0106511:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106518:	e8 b8 a7 ff ff       	call   c0100cd5 <__panic>
}
c010651d:	c9                   	leave  
c010651e:	c3                   	ret    

c010651f <check_content_access>:

static inline int
check_content_access(void)
{
c010651f:	55                   	push   %ebp
c0106520:	89 e5                	mov    %esp,%ebp
c0106522:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106525:	a1 b4 0a 12 c0       	mov    0xc0120ab4,%eax
c010652a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010652d:	ff d0                	call   *%eax
c010652f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106532:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106535:	c9                   	leave  
c0106536:	c3                   	ret    

c0106537 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106537:	55                   	push   %ebp
c0106538:	89 e5                	mov    %esp,%ebp
c010653a:	53                   	push   %ebx
c010653b:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c010653e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106545:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010654c:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106553:	eb 6b                	jmp    c01065c0 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106555:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106558:	83 e8 0c             	sub    $0xc,%eax
c010655b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c010655e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106561:	83 c0 04             	add    $0x4,%eax
c0106564:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010656b:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010656e:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106571:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106574:	0f a3 10             	bt     %edx,(%eax)
c0106577:	19 c0                	sbb    %eax,%eax
c0106579:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c010657c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106580:	0f 95 c0             	setne  %al
c0106583:	0f b6 c0             	movzbl %al,%eax
c0106586:	85 c0                	test   %eax,%eax
c0106588:	75 24                	jne    c01065ae <check_swap+0x77>
c010658a:	c7 44 24 0c 1e 9f 10 	movl   $0xc0109f1e,0xc(%esp)
c0106591:	c0 
c0106592:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106599:	c0 
c010659a:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01065a1:	00 
c01065a2:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01065a9:	e8 27 a7 ff ff       	call   c0100cd5 <__panic>
        count ++, total += p->property;
c01065ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01065b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065b5:	8b 50 08             	mov    0x8(%eax),%edx
c01065b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065bb:	01 d0                	add    %edx,%eax
c01065bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01065c3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01065c6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01065c9:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01065cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01065cf:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c01065d6:	0f 85 79 ff ff ff    	jne    c0106555 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c01065dc:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01065df:	e8 d2 e0 ff ff       	call   c01046b6 <nr_free_pages>
c01065e4:	39 c3                	cmp    %eax,%ebx
c01065e6:	74 24                	je     c010660c <check_swap+0xd5>
c01065e8:	c7 44 24 0c 2e 9f 10 	movl   $0xc0109f2e,0xc(%esp)
c01065ef:	c0 
c01065f0:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01065f7:	c0 
c01065f8:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01065ff:	00 
c0106600:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106607:	e8 c9 a6 ff ff       	call   c0100cd5 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010660c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010660f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106613:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106616:	89 44 24 04          	mov    %eax,0x4(%esp)
c010661a:	c7 04 24 48 9f 10 c0 	movl   $0xc0109f48,(%esp)
c0106621:	e8 25 9d ff ff       	call   c010034b <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106626:	e8 e5 09 00 00       	call   c0107010 <mm_create>
c010662b:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c010662e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106632:	75 24                	jne    c0106658 <check_swap+0x121>
c0106634:	c7 44 24 0c 6e 9f 10 	movl   $0xc0109f6e,0xc(%esp)
c010663b:	c0 
c010663c:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106643:	c0 
c0106644:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010664b:	00 
c010664c:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106653:	e8 7d a6 ff ff       	call   c0100cd5 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106658:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c010665d:	85 c0                	test   %eax,%eax
c010665f:	74 24                	je     c0106685 <check_swap+0x14e>
c0106661:	c7 44 24 0c 79 9f 10 	movl   $0xc0109f79,0xc(%esp)
c0106668:	c0 
c0106669:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106670:	c0 
c0106671:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106678:	00 
c0106679:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106680:	e8 50 a6 ff ff       	call   c0100cd5 <__panic>

     check_mm_struct = mm;
c0106685:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106688:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010668d:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0106693:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106696:	89 50 0c             	mov    %edx,0xc(%eax)
c0106699:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010669c:	8b 40 0c             	mov    0xc(%eax),%eax
c010669f:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01066a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066a5:	8b 00                	mov    (%eax),%eax
c01066a7:	85 c0                	test   %eax,%eax
c01066a9:	74 24                	je     c01066cf <check_swap+0x198>
c01066ab:	c7 44 24 0c 91 9f 10 	movl   $0xc0109f91,0xc(%esp)
c01066b2:	c0 
c01066b3:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01066ba:	c0 
c01066bb:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01066c2:	00 
c01066c3:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01066ca:	e8 06 a6 ff ff       	call   c0100cd5 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c01066cf:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c01066d6:	00 
c01066d7:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c01066de:	00 
c01066df:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c01066e6:	e8 9d 09 00 00       	call   c0107088 <vma_create>
c01066eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c01066ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01066f2:	75 24                	jne    c0106718 <check_swap+0x1e1>
c01066f4:	c7 44 24 0c 9f 9f 10 	movl   $0xc0109f9f,0xc(%esp)
c01066fb:	c0 
c01066fc:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106703:	c0 
c0106704:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010670b:	00 
c010670c:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106713:	e8 bd a5 ff ff       	call   c0100cd5 <__panic>

     insert_vma_struct(mm, vma);
c0106718:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010671b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010671f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106722:	89 04 24             	mov    %eax,(%esp)
c0106725:	e8 ee 0a 00 00       	call   c0107218 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010672a:	c7 04 24 ac 9f 10 c0 	movl   $0xc0109fac,(%esp)
c0106731:	e8 15 9c ff ff       	call   c010034b <cprintf>
     pte_t *temp_ptep=NULL;
c0106736:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c010673d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106740:	8b 40 0c             	mov    0xc(%eax),%eax
c0106743:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010674a:	00 
c010674b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106752:	00 
c0106753:	89 04 24             	mov    %eax,(%esp)
c0106756:	e8 20 e6 ff ff       	call   c0104d7b <get_pte>
c010675b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c010675e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106762:	75 24                	jne    c0106788 <check_swap+0x251>
c0106764:	c7 44 24 0c e0 9f 10 	movl   $0xc0109fe0,0xc(%esp)
c010676b:	c0 
c010676c:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106773:	c0 
c0106774:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010677b:	00 
c010677c:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106783:	e8 4d a5 ff ff       	call   c0100cd5 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106788:	c7 04 24 f4 9f 10 c0 	movl   $0xc0109ff4,(%esp)
c010678f:	e8 b7 9b ff ff       	call   c010034b <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106794:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010679b:	e9 a3 00 00 00       	jmp    c0106843 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01067a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01067a7:	e8 6d de ff ff       	call   c0104619 <alloc_pages>
c01067ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01067af:	89 04 95 e0 0a 12 c0 	mov    %eax,-0x3fedf520(,%edx,4)
          assert(check_rp[i] != NULL );
c01067b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067b9:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01067c0:	85 c0                	test   %eax,%eax
c01067c2:	75 24                	jne    c01067e8 <check_swap+0x2b1>
c01067c4:	c7 44 24 0c 18 a0 10 	movl   $0xc010a018,0xc(%esp)
c01067cb:	c0 
c01067cc:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01067d3:	c0 
c01067d4:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01067db:	00 
c01067dc:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01067e3:	e8 ed a4 ff ff       	call   c0100cd5 <__panic>
          assert(!PageProperty(check_rp[i]));
c01067e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01067eb:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01067f2:	83 c0 04             	add    $0x4,%eax
c01067f5:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01067fc:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01067ff:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106802:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106805:	0f a3 10             	bt     %edx,(%eax)
c0106808:	19 c0                	sbb    %eax,%eax
c010680a:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c010680d:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106811:	0f 95 c0             	setne  %al
c0106814:	0f b6 c0             	movzbl %al,%eax
c0106817:	85 c0                	test   %eax,%eax
c0106819:	74 24                	je     c010683f <check_swap+0x308>
c010681b:	c7 44 24 0c 2c a0 10 	movl   $0xc010a02c,0xc(%esp)
c0106822:	c0 
c0106823:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c010682a:	c0 
c010682b:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106832:	00 
c0106833:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010683a:	e8 96 a4 ff ff       	call   c0100cd5 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010683f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106843:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106847:	0f 8e 53 ff ff ff    	jle    c01067a0 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c010684d:	a1 c0 0a 12 c0       	mov    0xc0120ac0,%eax
c0106852:	8b 15 c4 0a 12 c0    	mov    0xc0120ac4,%edx
c0106858:	89 45 98             	mov    %eax,-0x68(%ebp)
c010685b:	89 55 9c             	mov    %edx,-0x64(%ebp)
c010685e:	c7 45 a8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106865:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106868:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010686b:	89 50 04             	mov    %edx,0x4(%eax)
c010686e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106871:	8b 50 04             	mov    0x4(%eax),%edx
c0106874:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106877:	89 10                	mov    %edx,(%eax)
c0106879:	c7 45 a4 c0 0a 12 c0 	movl   $0xc0120ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106880:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106883:	8b 40 04             	mov    0x4(%eax),%eax
c0106886:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106889:	0f 94 c0             	sete   %al
c010688c:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c010688f:	85 c0                	test   %eax,%eax
c0106891:	75 24                	jne    c01068b7 <check_swap+0x380>
c0106893:	c7 44 24 0c 47 a0 10 	movl   $0xc010a047,0xc(%esp)
c010689a:	c0 
c010689b:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c01068a2:	c0 
c01068a3:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c01068aa:	00 
c01068ab:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c01068b2:	e8 1e a4 ff ff       	call   c0100cd5 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01068b7:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01068bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01068bf:	c7 05 c8 0a 12 c0 00 	movl   $0x0,0xc0120ac8
c01068c6:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068c9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01068d0:	eb 1e                	jmp    c01068f0 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c01068d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01068d5:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c01068dc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01068e3:	00 
c01068e4:	89 04 24             	mov    %eax,(%esp)
c01068e7:	e8 98 dd ff ff       	call   c0104684 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01068ec:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01068f0:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01068f4:	7e dc                	jle    c01068d2 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c01068f6:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c01068fb:	83 f8 04             	cmp    $0x4,%eax
c01068fe:	74 24                	je     c0106924 <check_swap+0x3ed>
c0106900:	c7 44 24 0c 60 a0 10 	movl   $0xc010a060,0xc(%esp)
c0106907:	c0 
c0106908:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c010690f:	c0 
c0106910:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106917:	00 
c0106918:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c010691f:	e8 b1 a3 ff ff       	call   c0100cd5 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106924:	c7 04 24 84 a0 10 c0 	movl   $0xc010a084,(%esp)
c010692b:	e8 1b 9a ff ff       	call   c010034b <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106930:	c7 05 b8 0a 12 c0 00 	movl   $0x0,0xc0120ab8
c0106937:	00 00 00 
     
     check_content_set();
c010693a:	e8 28 fa ff ff       	call   c0106367 <check_content_set>
     assert( nr_free == 0);         
c010693f:	a1 c8 0a 12 c0       	mov    0xc0120ac8,%eax
c0106944:	85 c0                	test   %eax,%eax
c0106946:	74 24                	je     c010696c <check_swap+0x435>
c0106948:	c7 44 24 0c ab a0 10 	movl   $0xc010a0ab,0xc(%esp)
c010694f:	c0 
c0106950:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106957:	c0 
c0106958:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010695f:	00 
c0106960:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106967:	e8 69 a3 ff ff       	call   c0100cd5 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010696c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106973:	eb 26                	jmp    c010699b <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106978:	c7 04 85 00 0b 12 c0 	movl   $0xffffffff,-0x3fedf500(,%eax,4)
c010697f:	ff ff ff ff 
c0106983:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106986:	8b 14 85 00 0b 12 c0 	mov    -0x3fedf500(,%eax,4),%edx
c010698d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106990:	89 14 85 40 0b 12 c0 	mov    %edx,-0x3fedf4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106997:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010699b:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c010699f:	7e d4                	jle    c0106975 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01069a8:	e9 eb 00 00 00       	jmp    c0106a98 <check_swap+0x561>
         check_ptep[i]=0;
c01069ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069b0:	c7 04 85 94 0b 12 c0 	movl   $0x0,-0x3fedf46c(,%eax,4)
c01069b7:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01069bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069be:	83 c0 01             	add    $0x1,%eax
c01069c1:	c1 e0 0c             	shl    $0xc,%eax
c01069c4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01069cb:	00 
c01069cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069d0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01069d3:	89 04 24             	mov    %eax,(%esp)
c01069d6:	e8 a0 e3 ff ff       	call   c0104d7b <get_pte>
c01069db:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01069de:	89 04 95 94 0b 12 c0 	mov    %eax,-0x3fedf46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c01069e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069e8:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c01069ef:	85 c0                	test   %eax,%eax
c01069f1:	75 24                	jne    c0106a17 <check_swap+0x4e0>
c01069f3:	c7 44 24 0c b8 a0 10 	movl   $0xc010a0b8,0xc(%esp)
c01069fa:	c0 
c01069fb:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106a02:	c0 
c0106a03:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106a0a:	00 
c0106a0b:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106a12:	e8 be a2 ff ff       	call   c0100cd5 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a1a:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106a21:	8b 00                	mov    (%eax),%eax
c0106a23:	89 04 24             	mov    %eax,(%esp)
c0106a26:	e8 9f f5 ff ff       	call   c0105fca <pte2page>
c0106a2b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a2e:	8b 14 95 e0 0a 12 c0 	mov    -0x3fedf520(,%edx,4),%edx
c0106a35:	39 d0                	cmp    %edx,%eax
c0106a37:	74 24                	je     c0106a5d <check_swap+0x526>
c0106a39:	c7 44 24 0c d0 a0 10 	movl   $0xc010a0d0,0xc(%esp)
c0106a40:	c0 
c0106a41:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106a48:	c0 
c0106a49:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106a50:	00 
c0106a51:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106a58:	e8 78 a2 ff ff       	call   c0100cd5 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a60:	8b 04 85 94 0b 12 c0 	mov    -0x3fedf46c(,%eax,4),%eax
c0106a67:	8b 00                	mov    (%eax),%eax
c0106a69:	83 e0 01             	and    $0x1,%eax
c0106a6c:	85 c0                	test   %eax,%eax
c0106a6e:	75 24                	jne    c0106a94 <check_swap+0x55d>
c0106a70:	c7 44 24 0c f8 a0 10 	movl   $0xc010a0f8,0xc(%esp)
c0106a77:	c0 
c0106a78:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106a7f:	c0 
c0106a80:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106a87:	00 
c0106a88:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106a8f:	e8 41 a2 ff ff       	call   c0100cd5 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a94:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a98:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106a9c:	0f 8e 0b ff ff ff    	jle    c01069ad <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106aa2:	c7 04 24 14 a1 10 c0 	movl   $0xc010a114,(%esp)
c0106aa9:	e8 9d 98 ff ff       	call   c010034b <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106aae:	e8 6c fa ff ff       	call   c010651f <check_content_access>
c0106ab3:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106ab6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106aba:	74 24                	je     c0106ae0 <check_swap+0x5a9>
c0106abc:	c7 44 24 0c 3a a1 10 	movl   $0xc010a13a,0xc(%esp)
c0106ac3:	c0 
c0106ac4:	c7 44 24 08 22 9e 10 	movl   $0xc0109e22,0x8(%esp)
c0106acb:	c0 
c0106acc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106ad3:	00 
c0106ad4:	c7 04 24 bc 9d 10 c0 	movl   $0xc0109dbc,(%esp)
c0106adb:	e8 f5 a1 ff ff       	call   c0100cd5 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ae0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106ae7:	eb 1e                	jmp    c0106b07 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106aec:	8b 04 85 e0 0a 12 c0 	mov    -0x3fedf520(,%eax,4),%eax
c0106af3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106afa:	00 
c0106afb:	89 04 24             	mov    %eax,(%esp)
c0106afe:	e8 81 db ff ff       	call   c0104684 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b03:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b07:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106b0b:	7e dc                	jle    c0106ae9 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106b0d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106b10:	89 04 24             	mov    %eax,(%esp)
c0106b13:	e8 30 08 00 00       	call   c0107348 <mm_destroy>
         
     nr_free = nr_free_store;
c0106b18:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106b1b:	a3 c8 0a 12 c0       	mov    %eax,0xc0120ac8
     free_list = free_list_store;
c0106b20:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106b23:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106b26:	a3 c0 0a 12 c0       	mov    %eax,0xc0120ac0
c0106b2b:	89 15 c4 0a 12 c0    	mov    %edx,0xc0120ac4

     
     le = &free_list;
c0106b31:	c7 45 e8 c0 0a 12 c0 	movl   $0xc0120ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b38:	eb 1d                	jmp    c0106b57 <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c0106b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b3d:	83 e8 0c             	sub    $0xc,%eax
c0106b40:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106b43:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106b47:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106b4a:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106b4d:	8b 40 08             	mov    0x8(%eax),%eax
c0106b50:	29 c2                	sub    %eax,%edx
c0106b52:	89 d0                	mov    %edx,%eax
c0106b54:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106b57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b5a:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106b5d:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106b60:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106b63:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106b66:	81 7d e8 c0 0a 12 c0 	cmpl   $0xc0120ac0,-0x18(%ebp)
c0106b6d:	75 cb                	jne    c0106b3a <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106b72:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106b79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b7d:	c7 04 24 41 a1 10 c0 	movl   $0xc010a141,(%esp)
c0106b84:	e8 c2 97 ff ff       	call   c010034b <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106b89:	c7 04 24 5b a1 10 c0 	movl   $0xc010a15b,(%esp)
c0106b90:	e8 b6 97 ff ff       	call   c010034b <cprintf>
}
c0106b95:	83 c4 74             	add    $0x74,%esp
c0106b98:	5b                   	pop    %ebx
c0106b99:	5d                   	pop    %ebp
c0106b9a:	c3                   	ret    

c0106b9b <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106b9b:	55                   	push   %ebp
c0106b9c:	89 e5                	mov    %esp,%ebp
c0106b9e:	83 ec 10             	sub    $0x10,%esp
c0106ba1:	c7 45 fc a4 0b 12 c0 	movl   $0xc0120ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106ba8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bab:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106bae:	89 50 04             	mov    %edx,0x4(%eax)
c0106bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bb4:	8b 50 04             	mov    0x4(%eax),%edx
c0106bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106bba:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bbf:	c7 40 14 a4 0b 12 c0 	movl   $0xc0120ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106bc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106bcb:	c9                   	leave  
c0106bcc:	c3                   	ret    

c0106bcd <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106bcd:	55                   	push   %ebp
c0106bce:	89 e5                	mov    %esp,%ebp
c0106bd0:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106bd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0106bd6:	8b 40 14             	mov    0x14(%eax),%eax
c0106bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106bdc:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bdf:	83 c0 14             	add    $0x14,%eax
c0106be2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106be5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106be9:	74 06                	je     c0106bf1 <_fifo_map_swappable+0x24>
c0106beb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106bef:	75 24                	jne    c0106c15 <_fifo_map_swappable+0x48>
c0106bf1:	c7 44 24 0c 74 a1 10 	movl   $0xc010a174,0xc(%esp)
c0106bf8:	c0 
c0106bf9:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106c00:	c0 
c0106c01:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106c08:	00 
c0106c09:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106c10:	e8 c0 a0 ff ff       	call   c0100cd5 <__panic>
c0106c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c18:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c1e:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0106c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c24:	8b 00                	mov    (%eax),%eax
c0106c26:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106c29:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106c2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c32:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106c3b:	89 10                	mov    %edx,(%eax)
c0106c3d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106c40:	8b 10                	mov    (%eax),%edx
c0106c42:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c45:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106c48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c4b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c4e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106c51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c54:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c57:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2012011394*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c0106c59:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c5e:	c9                   	leave  
c0106c5f:	c3                   	ret    

c0106c60 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106c60:	55                   	push   %ebp
c0106c61:	89 e5                	mov    %esp,%ebp
c0106c63:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0106c69:	8b 40 14             	mov    0x14(%eax),%eax
c0106c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106c6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106c73:	75 24                	jne    c0106c99 <_fifo_swap_out_victim+0x39>
c0106c75:	c7 44 24 0c bb a1 10 	movl   $0xc010a1bb,0xc(%esp)
c0106c7c:	c0 
c0106c7d:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106c84:	c0 
c0106c85:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106c8c:	00 
c0106c8d:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106c94:	e8 3c a0 ff ff       	call   c0100cd5 <__panic>
     assert(in_tick==0);
c0106c99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106c9d:	74 24                	je     c0106cc3 <_fifo_swap_out_victim+0x63>
c0106c9f:	c7 44 24 0c c8 a1 10 	movl   $0xc010a1c8,0xc(%esp)
c0106ca6:	c0 
c0106ca7:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106cae:	c0 
c0106caf:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106cb6:	00 
c0106cb7:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106cbe:	e8 12 a0 ff ff       	call   c0100cd5 <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2012011394*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t* item = head->next;
c0106cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106cc6:	8b 40 04             	mov    0x4(%eax),%eax
c0106cc9:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(item, pra_page_link);
c0106ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ccf:	83 e8 14             	sub    $0x14,%eax
c0106cd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106cd8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106cde:	8b 40 04             	mov    0x4(%eax),%eax
c0106ce1:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106ce4:	8b 12                	mov    (%edx),%edx
c0106ce6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106ce9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106cf2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106cf8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106cfb:	89 10                	mov    %edx,(%eax)
     list_del(item);
     *ptr_page = page;
c0106cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106d00:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106d03:	89 10                	mov    %edx,(%eax)
     return 0;
c0106d05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d0a:	c9                   	leave  
c0106d0b:	c3                   	ret    

c0106d0c <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106d0c:	55                   	push   %ebp
c0106d0d:	89 e5                	mov    %esp,%ebp
c0106d0f:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106d12:	c7 04 24 d4 a1 10 c0 	movl   $0xc010a1d4,(%esp)
c0106d19:	e8 2d 96 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106d1e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106d23:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106d26:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106d2b:	83 f8 04             	cmp    $0x4,%eax
c0106d2e:	74 24                	je     c0106d54 <_fifo_check_swap+0x48>
c0106d30:	c7 44 24 0c fa a1 10 	movl   $0xc010a1fa,0xc(%esp)
c0106d37:	c0 
c0106d38:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106d3f:	c0 
c0106d40:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c0106d47:	00 
c0106d48:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106d4f:	e8 81 9f ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106d54:	c7 04 24 0c a2 10 c0 	movl   $0xc010a20c,(%esp)
c0106d5b:	e8 eb 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106d60:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106d65:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106d68:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106d6d:	83 f8 04             	cmp    $0x4,%eax
c0106d70:	74 24                	je     c0106d96 <_fifo_check_swap+0x8a>
c0106d72:	c7 44 24 0c fa a1 10 	movl   $0xc010a1fa,0xc(%esp)
c0106d79:	c0 
c0106d7a:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106d81:	c0 
c0106d82:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0106d89:	00 
c0106d8a:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106d91:	e8 3f 9f ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106d96:	c7 04 24 34 a2 10 c0 	movl   $0xc010a234,(%esp)
c0106d9d:	e8 a9 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106da2:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106da7:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106daa:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106daf:	83 f8 04             	cmp    $0x4,%eax
c0106db2:	74 24                	je     c0106dd8 <_fifo_check_swap+0xcc>
c0106db4:	c7 44 24 0c fa a1 10 	movl   $0xc010a1fa,0xc(%esp)
c0106dbb:	c0 
c0106dbc:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106dc3:	c0 
c0106dc4:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c0106dcb:	00 
c0106dcc:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106dd3:	e8 fd 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106dd8:	c7 04 24 5c a2 10 c0 	movl   $0xc010a25c,(%esp)
c0106ddf:	e8 67 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106de4:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106de9:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106dec:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106df1:	83 f8 04             	cmp    $0x4,%eax
c0106df4:	74 24                	je     c0106e1a <_fifo_check_swap+0x10e>
c0106df6:	c7 44 24 0c fa a1 10 	movl   $0xc010a1fa,0xc(%esp)
c0106dfd:	c0 
c0106dfe:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106e05:	c0 
c0106e06:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106e0d:	00 
c0106e0e:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106e15:	e8 bb 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0106e1a:	c7 04 24 84 a2 10 c0 	movl   $0xc010a284,(%esp)
c0106e21:	e8 25 95 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0106e26:	b8 00 50 00 00       	mov    $0x5000,%eax
c0106e2b:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0106e2e:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e33:	83 f8 05             	cmp    $0x5,%eax
c0106e36:	74 24                	je     c0106e5c <_fifo_check_swap+0x150>
c0106e38:	c7 44 24 0c aa a2 10 	movl   $0xc010a2aa,0xc(%esp)
c0106e3f:	c0 
c0106e40:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106e47:	c0 
c0106e48:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106e4f:	00 
c0106e50:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106e57:	e8 79 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106e5c:	c7 04 24 5c a2 10 c0 	movl   $0xc010a25c,(%esp)
c0106e63:	e8 e3 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106e68:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106e6d:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0106e70:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106e75:	83 f8 05             	cmp    $0x5,%eax
c0106e78:	74 24                	je     c0106e9e <_fifo_check_swap+0x192>
c0106e7a:	c7 44 24 0c aa a2 10 	movl   $0xc010a2aa,0xc(%esp)
c0106e81:	c0 
c0106e82:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106e89:	c0 
c0106e8a:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0106e91:	00 
c0106e92:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106e99:	e8 37 9e ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106e9e:	c7 04 24 0c a2 10 c0 	movl   $0xc010a20c,(%esp)
c0106ea5:	e8 a1 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106eaa:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106eaf:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0106eb2:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106eb7:	83 f8 06             	cmp    $0x6,%eax
c0106eba:	74 24                	je     c0106ee0 <_fifo_check_swap+0x1d4>
c0106ebc:	c7 44 24 0c b9 a2 10 	movl   $0xc010a2b9,0xc(%esp)
c0106ec3:	c0 
c0106ec4:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106ecb:	c0 
c0106ecc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0106ed3:	00 
c0106ed4:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106edb:	e8 f5 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106ee0:	c7 04 24 5c a2 10 c0 	movl   $0xc010a25c,(%esp)
c0106ee7:	e8 5f 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106eec:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106ef1:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0106ef4:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106ef9:	83 f8 07             	cmp    $0x7,%eax
c0106efc:	74 24                	je     c0106f22 <_fifo_check_swap+0x216>
c0106efe:	c7 44 24 0c c8 a2 10 	movl   $0xc010a2c8,0xc(%esp)
c0106f05:	c0 
c0106f06:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106f0d:	c0 
c0106f0e:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106f15:	00 
c0106f16:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106f1d:	e8 b3 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106f22:	c7 04 24 d4 a1 10 c0 	movl   $0xc010a1d4,(%esp)
c0106f29:	e8 1d 94 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106f2e:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106f33:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0106f36:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f3b:	83 f8 08             	cmp    $0x8,%eax
c0106f3e:	74 24                	je     c0106f64 <_fifo_check_swap+0x258>
c0106f40:	c7 44 24 0c d7 a2 10 	movl   $0xc010a2d7,0xc(%esp)
c0106f47:	c0 
c0106f48:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106f4f:	c0 
c0106f50:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0106f57:	00 
c0106f58:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106f5f:	e8 71 9d ff ff       	call   c0100cd5 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106f64:	c7 04 24 34 a2 10 c0 	movl   $0xc010a234,(%esp)
c0106f6b:	e8 db 93 ff ff       	call   c010034b <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f70:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106f75:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0106f78:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0106f7d:	83 f8 09             	cmp    $0x9,%eax
c0106f80:	74 24                	je     c0106fa6 <_fifo_check_swap+0x29a>
c0106f82:	c7 44 24 0c e6 a2 10 	movl   $0xc010a2e6,0xc(%esp)
c0106f89:	c0 
c0106f8a:	c7 44 24 08 92 a1 10 	movl   $0xc010a192,0x8(%esp)
c0106f91:	c0 
c0106f92:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106f99:	00 
c0106f9a:	c7 04 24 a7 a1 10 c0 	movl   $0xc010a1a7,(%esp)
c0106fa1:	e8 2f 9d ff ff       	call   c0100cd5 <__panic>
    return 0;
c0106fa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fab:	c9                   	leave  
c0106fac:	c3                   	ret    

c0106fad <_fifo_init>:


static int
_fifo_init(void)
{
c0106fad:	55                   	push   %ebp
c0106fae:	89 e5                	mov    %esp,%ebp
    return 0;
c0106fb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fb5:	5d                   	pop    %ebp
c0106fb6:	c3                   	ret    

c0106fb7 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106fb7:	55                   	push   %ebp
c0106fb8:	89 e5                	mov    %esp,%ebp
    return 0;
c0106fba:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106fbf:	5d                   	pop    %ebp
c0106fc0:	c3                   	ret    

c0106fc1 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0106fc1:	55                   	push   %ebp
c0106fc2:	89 e5                	mov    %esp,%ebp
c0106fc4:	b8 00 00 00 00       	mov    $0x0,%eax
c0106fc9:	5d                   	pop    %ebp
c0106fca:	c3                   	ret    

c0106fcb <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106fcb:	55                   	push   %ebp
c0106fcc:	89 e5                	mov    %esp,%ebp
c0106fce:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106fd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fd4:	c1 e8 0c             	shr    $0xc,%eax
c0106fd7:	89 c2                	mov    %eax,%edx
c0106fd9:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0106fde:	39 c2                	cmp    %eax,%edx
c0106fe0:	72 1c                	jb     c0106ffe <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106fe2:	c7 44 24 08 08 a3 10 	movl   $0xc010a308,0x8(%esp)
c0106fe9:	c0 
c0106fea:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0106ff1:	00 
c0106ff2:	c7 04 24 27 a3 10 c0 	movl   $0xc010a327,(%esp)
c0106ff9:	e8 d7 9c ff ff       	call   c0100cd5 <__panic>
    }
    return &pages[PPN(pa)];
c0106ffe:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0107003:	8b 55 08             	mov    0x8(%ebp),%edx
c0107006:	c1 ea 0c             	shr    $0xc,%edx
c0107009:	c1 e2 05             	shl    $0x5,%edx
c010700c:	01 d0                	add    %edx,%eax
}
c010700e:	c9                   	leave  
c010700f:	c3                   	ret    

c0107010 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107010:	55                   	push   %ebp
c0107011:	89 e5                	mov    %esp,%ebp
c0107013:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107016:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010701d:	e8 29 ee ff ff       	call   c0105e4b <kmalloc>
c0107022:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107029:	74 58                	je     c0107083 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c010702b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010702e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107031:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107034:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107037:	89 50 04             	mov    %edx,0x4(%eax)
c010703a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010703d:	8b 50 04             	mov    0x4(%eax),%edx
c0107040:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107043:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107045:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107048:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c010704f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107052:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107059:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010705c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107063:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0107068:	85 c0                	test   %eax,%eax
c010706a:	74 0d                	je     c0107079 <mm_create+0x69>
c010706c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010706f:	89 04 24             	mov    %eax,(%esp)
c0107072:	e8 21 f0 ff ff       	call   c0106098 <swap_init_mm>
c0107077:	eb 0a                	jmp    c0107083 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107079:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010707c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107083:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107086:	c9                   	leave  
c0107087:	c3                   	ret    

c0107088 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107088:	55                   	push   %ebp
c0107089:	89 e5                	mov    %esp,%ebp
c010708b:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010708e:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107095:	e8 b1 ed ff ff       	call   c0105e4b <kmalloc>
c010709a:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010709d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070a1:	74 1b                	je     c01070be <vma_create+0x36>
        vma->vm_start = vm_start;
c01070a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070a6:	8b 55 08             	mov    0x8(%ebp),%edx
c01070a9:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01070ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070af:	8b 55 0c             	mov    0xc(%ebp),%edx
c01070b2:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01070b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070b8:	8b 55 10             	mov    0x10(%ebp),%edx
c01070bb:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01070be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01070c1:	c9                   	leave  
c01070c2:	c3                   	ret    

c01070c3 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01070c3:	55                   	push   %ebp
c01070c4:	89 e5                	mov    %esp,%ebp
c01070c6:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01070c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01070d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01070d4:	0f 84 95 00 00 00    	je     c010716f <find_vma+0xac>
        vma = mm->mmap_cache;
c01070da:	8b 45 08             	mov    0x8(%ebp),%eax
c01070dd:	8b 40 08             	mov    0x8(%eax),%eax
c01070e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01070e3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01070e7:	74 16                	je     c01070ff <find_vma+0x3c>
c01070e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070ec:	8b 40 04             	mov    0x4(%eax),%eax
c01070ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070f2:	77 0b                	ja     c01070ff <find_vma+0x3c>
c01070f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01070f7:	8b 40 08             	mov    0x8(%eax),%eax
c01070fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070fd:	77 61                	ja     c0107160 <find_vma+0x9d>
                bool found = 0;
c01070ff:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107106:	8b 45 08             	mov    0x8(%ebp),%eax
c0107109:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010710c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010710f:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107112:	eb 28                	jmp    c010713c <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107114:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107117:	83 e8 10             	sub    $0x10,%eax
c010711a:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c010711d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107120:	8b 40 04             	mov    0x4(%eax),%eax
c0107123:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107126:	77 14                	ja     c010713c <find_vma+0x79>
c0107128:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010712b:	8b 40 08             	mov    0x8(%eax),%eax
c010712e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107131:	76 09                	jbe    c010713c <find_vma+0x79>
                        found = 1;
c0107133:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010713a:	eb 17                	jmp    c0107153 <find_vma+0x90>
c010713c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010713f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107142:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107145:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107148:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010714b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010714e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107151:	75 c1                	jne    c0107114 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107153:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107157:	75 07                	jne    c0107160 <find_vma+0x9d>
                    vma = NULL;
c0107159:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107160:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107164:	74 09                	je     c010716f <find_vma+0xac>
            mm->mmap_cache = vma;
c0107166:	8b 45 08             	mov    0x8(%ebp),%eax
c0107169:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010716c:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c010716f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107172:	c9                   	leave  
c0107173:	c3                   	ret    

c0107174 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107174:	55                   	push   %ebp
c0107175:	89 e5                	mov    %esp,%ebp
c0107177:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010717a:	8b 45 08             	mov    0x8(%ebp),%eax
c010717d:	8b 50 04             	mov    0x4(%eax),%edx
c0107180:	8b 45 08             	mov    0x8(%ebp),%eax
c0107183:	8b 40 08             	mov    0x8(%eax),%eax
c0107186:	39 c2                	cmp    %eax,%edx
c0107188:	72 24                	jb     c01071ae <check_vma_overlap+0x3a>
c010718a:	c7 44 24 0c 35 a3 10 	movl   $0xc010a335,0xc(%esp)
c0107191:	c0 
c0107192:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107199:	c0 
c010719a:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c01071a1:	00 
c01071a2:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01071a9:	e8 27 9b ff ff       	call   c0100cd5 <__panic>
    assert(prev->vm_end <= next->vm_start);
c01071ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01071b1:	8b 50 08             	mov    0x8(%eax),%edx
c01071b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071b7:	8b 40 04             	mov    0x4(%eax),%eax
c01071ba:	39 c2                	cmp    %eax,%edx
c01071bc:	76 24                	jbe    c01071e2 <check_vma_overlap+0x6e>
c01071be:	c7 44 24 0c 78 a3 10 	movl   $0xc010a378,0xc(%esp)
c01071c5:	c0 
c01071c6:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01071cd:	c0 
c01071ce:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01071d5:	00 
c01071d6:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01071dd:	e8 f3 9a ff ff       	call   c0100cd5 <__panic>
    assert(next->vm_start < next->vm_end);
c01071e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071e5:	8b 50 04             	mov    0x4(%eax),%edx
c01071e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01071eb:	8b 40 08             	mov    0x8(%eax),%eax
c01071ee:	39 c2                	cmp    %eax,%edx
c01071f0:	72 24                	jb     c0107216 <check_vma_overlap+0xa2>
c01071f2:	c7 44 24 0c 97 a3 10 	movl   $0xc010a397,0xc(%esp)
c01071f9:	c0 
c01071fa:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107201:	c0 
c0107202:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107209:	00 
c010720a:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107211:	e8 bf 9a ff ff       	call   c0100cd5 <__panic>
}
c0107216:	c9                   	leave  
c0107217:	c3                   	ret    

c0107218 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107218:	55                   	push   %ebp
c0107219:	89 e5                	mov    %esp,%ebp
c010721b:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c010721e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107221:	8b 50 04             	mov    0x4(%eax),%edx
c0107224:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107227:	8b 40 08             	mov    0x8(%eax),%eax
c010722a:	39 c2                	cmp    %eax,%edx
c010722c:	72 24                	jb     c0107252 <insert_vma_struct+0x3a>
c010722e:	c7 44 24 0c b5 a3 10 	movl   $0xc010a3b5,0xc(%esp)
c0107235:	c0 
c0107236:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c010723d:	c0 
c010723e:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0107245:	00 
c0107246:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010724d:	e8 83 9a ff ff       	call   c0100cd5 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107252:	8b 45 08             	mov    0x8(%ebp),%eax
c0107255:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107258:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010725b:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010725e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107261:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107264:	eb 21                	jmp    c0107287 <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107266:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107269:	83 e8 10             	sub    $0x10,%eax
c010726c:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c010726f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107272:	8b 50 04             	mov    0x4(%eax),%edx
c0107275:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107278:	8b 40 04             	mov    0x4(%eax),%eax
c010727b:	39 c2                	cmp    %eax,%edx
c010727d:	76 02                	jbe    c0107281 <insert_vma_struct+0x69>
                break;
c010727f:	eb 1d                	jmp    c010729e <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107281:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107284:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107287:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010728a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010728d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107290:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107293:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107296:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107299:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010729c:	75 c8                	jne    c0107266 <insert_vma_struct+0x4e>
c010729e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01072a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01072a7:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01072aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01072ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072b0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072b3:	74 15                	je     c01072ca <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01072b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072b8:	8d 50 f0             	lea    -0x10(%eax),%edx
c01072bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072c2:	89 14 24             	mov    %edx,(%esp)
c01072c5:	e8 aa fe ff ff       	call   c0107174 <check_vma_overlap>
    }
    if (le_next != list) {
c01072ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072cd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01072d0:	74 15                	je     c01072e7 <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01072d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01072d5:	83 e8 10             	sub    $0x10,%eax
c01072d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01072dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072df:	89 04 24             	mov    %eax,(%esp)
c01072e2:	e8 8d fe ff ff       	call   c0107174 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01072e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072ea:	8b 55 08             	mov    0x8(%ebp),%edx
c01072ed:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01072ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01072f2:	8d 50 10             	lea    0x10(%eax),%edx
c01072f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072f8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01072fb:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01072fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107301:	8b 40 04             	mov    0x4(%eax),%eax
c0107304:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107307:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010730a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010730d:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107310:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107313:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107316:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107319:	89 10                	mov    %edx,(%eax)
c010731b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010731e:	8b 10                	mov    (%eax),%edx
c0107320:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107323:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107326:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107329:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010732c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010732f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107332:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107335:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107337:	8b 45 08             	mov    0x8(%ebp),%eax
c010733a:	8b 40 10             	mov    0x10(%eax),%eax
c010733d:	8d 50 01             	lea    0x1(%eax),%edx
c0107340:	8b 45 08             	mov    0x8(%ebp),%eax
c0107343:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107346:	c9                   	leave  
c0107347:	c3                   	ret    

c0107348 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107348:	55                   	push   %ebp
c0107349:	89 e5                	mov    %esp,%ebp
c010734b:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c010734e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107351:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107354:	eb 3e                	jmp    c0107394 <mm_destroy+0x4c>
c0107356:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107359:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010735c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010735f:	8b 40 04             	mov    0x4(%eax),%eax
c0107362:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107365:	8b 12                	mov    (%edx),%edx
c0107367:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010736a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010736d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107370:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107373:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107376:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107379:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010737c:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c010737e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107381:	83 e8 10             	sub    $0x10,%eax
c0107384:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010738b:	00 
c010738c:	89 04 24             	mov    %eax,(%esp)
c010738f:	e8 57 eb ff ff       	call   c0105eeb <kfree>
c0107394:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107397:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010739a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010739d:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01073a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073a6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01073a9:	75 ab                	jne    c0107356 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c01073ab:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c01073b2:	00 
c01073b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01073b6:	89 04 24             	mov    %eax,(%esp)
c01073b9:	e8 2d eb ff ff       	call   c0105eeb <kfree>
    mm=NULL;
c01073be:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01073c5:	c9                   	leave  
c01073c6:	c3                   	ret    

c01073c7 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01073c7:	55                   	push   %ebp
c01073c8:	89 e5                	mov    %esp,%ebp
c01073ca:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01073cd:	e8 02 00 00 00       	call   c01073d4 <check_vmm>
}
c01073d2:	c9                   	leave  
c01073d3:	c3                   	ret    

c01073d4 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01073d4:	55                   	push   %ebp
c01073d5:	89 e5                	mov    %esp,%ebp
c01073d7:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01073da:	e8 d7 d2 ff ff       	call   c01046b6 <nr_free_pages>
c01073df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01073e2:	e8 41 00 00 00       	call   c0107428 <check_vma_struct>
    check_pgfault();
c01073e7:	e8 03 05 00 00       	call   c01078ef <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01073ec:	e8 c5 d2 ff ff       	call   c01046b6 <nr_free_pages>
c01073f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01073f4:	74 24                	je     c010741a <check_vmm+0x46>
c01073f6:	c7 44 24 0c d4 a3 10 	movl   $0xc010a3d4,0xc(%esp)
c01073fd:	c0 
c01073fe:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107405:	c0 
c0107406:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c010740d:	00 
c010740e:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107415:	e8 bb 98 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vmm() succeeded.\n");
c010741a:	c7 04 24 fb a3 10 c0 	movl   $0xc010a3fb,(%esp)
c0107421:	e8 25 8f ff ff       	call   c010034b <cprintf>
}
c0107426:	c9                   	leave  
c0107427:	c3                   	ret    

c0107428 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107428:	55                   	push   %ebp
c0107429:	89 e5                	mov    %esp,%ebp
c010742b:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010742e:	e8 83 d2 ff ff       	call   c01046b6 <nr_free_pages>
c0107433:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107436:	e8 d5 fb ff ff       	call   c0107010 <mm_create>
c010743b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c010743e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107442:	75 24                	jne    c0107468 <check_vma_struct+0x40>
c0107444:	c7 44 24 0c 13 a4 10 	movl   $0xc010a413,0xc(%esp)
c010744b:	c0 
c010744c:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107453:	c0 
c0107454:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c010745b:	00 
c010745c:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107463:	e8 6d 98 ff ff       	call   c0100cd5 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107468:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c010746f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107472:	89 d0                	mov    %edx,%eax
c0107474:	c1 e0 02             	shl    $0x2,%eax
c0107477:	01 d0                	add    %edx,%eax
c0107479:	01 c0                	add    %eax,%eax
c010747b:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c010747e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107481:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107484:	eb 70                	jmp    c01074f6 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107486:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107489:	89 d0                	mov    %edx,%eax
c010748b:	c1 e0 02             	shl    $0x2,%eax
c010748e:	01 d0                	add    %edx,%eax
c0107490:	83 c0 02             	add    $0x2,%eax
c0107493:	89 c1                	mov    %eax,%ecx
c0107495:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107498:	89 d0                	mov    %edx,%eax
c010749a:	c1 e0 02             	shl    $0x2,%eax
c010749d:	01 d0                	add    %edx,%eax
c010749f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01074a6:	00 
c01074a7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01074ab:	89 04 24             	mov    %eax,(%esp)
c01074ae:	e8 d5 fb ff ff       	call   c0107088 <vma_create>
c01074b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c01074b6:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01074ba:	75 24                	jne    c01074e0 <check_vma_struct+0xb8>
c01074bc:	c7 44 24 0c 1e a4 10 	movl   $0xc010a41e,0xc(%esp)
c01074c3:	c0 
c01074c4:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01074cb:	c0 
c01074cc:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01074d3:	00 
c01074d4:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01074db:	e8 f5 97 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c01074e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01074e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01074ea:	89 04 24             	mov    %eax,(%esp)
c01074ed:	e8 26 fd ff ff       	call   c0107218 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01074f2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01074f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01074fa:	7f 8a                	jg     c0107486 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01074fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074ff:	83 c0 01             	add    $0x1,%eax
c0107502:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107505:	eb 70                	jmp    c0107577 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107507:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010750a:	89 d0                	mov    %edx,%eax
c010750c:	c1 e0 02             	shl    $0x2,%eax
c010750f:	01 d0                	add    %edx,%eax
c0107511:	83 c0 02             	add    $0x2,%eax
c0107514:	89 c1                	mov    %eax,%ecx
c0107516:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107519:	89 d0                	mov    %edx,%eax
c010751b:	c1 e0 02             	shl    $0x2,%eax
c010751e:	01 d0                	add    %edx,%eax
c0107520:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107527:	00 
c0107528:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010752c:	89 04 24             	mov    %eax,(%esp)
c010752f:	e8 54 fb ff ff       	call   c0107088 <vma_create>
c0107534:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107537:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c010753b:	75 24                	jne    c0107561 <check_vma_struct+0x139>
c010753d:	c7 44 24 0c 1e a4 10 	movl   $0xc010a41e,0xc(%esp)
c0107544:	c0 
c0107545:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c010754c:	c0 
c010754d:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0107554:	00 
c0107555:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010755c:	e8 74 97 ff ff       	call   c0100cd5 <__panic>
        insert_vma_struct(mm, vma);
c0107561:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107564:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107568:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010756b:	89 04 24             	mov    %eax,(%esp)
c010756e:	e8 a5 fc ff ff       	call   c0107218 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107573:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010757a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010757d:	7e 88                	jle    c0107507 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c010757f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107582:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107585:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107588:	8b 40 04             	mov    0x4(%eax),%eax
c010758b:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c010758e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107595:	e9 97 00 00 00       	jmp    c0107631 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010759a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010759d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01075a0:	75 24                	jne    c01075c6 <check_vma_struct+0x19e>
c01075a2:	c7 44 24 0c 2a a4 10 	movl   $0xc010a42a,0xc(%esp)
c01075a9:	c0 
c01075aa:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01075b1:	c0 
c01075b2:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c01075b9:	00 
c01075ba:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01075c1:	e8 0f 97 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c01075c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01075c9:	83 e8 10             	sub    $0x10,%eax
c01075cc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c01075cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01075d2:	8b 48 04             	mov    0x4(%eax),%ecx
c01075d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075d8:	89 d0                	mov    %edx,%eax
c01075da:	c1 e0 02             	shl    $0x2,%eax
c01075dd:	01 d0                	add    %edx,%eax
c01075df:	39 c1                	cmp    %eax,%ecx
c01075e1:	75 17                	jne    c01075fa <check_vma_struct+0x1d2>
c01075e3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01075e6:	8b 48 08             	mov    0x8(%eax),%ecx
c01075e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01075ec:	89 d0                	mov    %edx,%eax
c01075ee:	c1 e0 02             	shl    $0x2,%eax
c01075f1:	01 d0                	add    %edx,%eax
c01075f3:	83 c0 02             	add    $0x2,%eax
c01075f6:	39 c1                	cmp    %eax,%ecx
c01075f8:	74 24                	je     c010761e <check_vma_struct+0x1f6>
c01075fa:	c7 44 24 0c 44 a4 10 	movl   $0xc010a444,0xc(%esp)
c0107601:	c0 
c0107602:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107609:	c0 
c010760a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0107611:	00 
c0107612:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107619:	e8 b7 96 ff ff       	call   c0100cd5 <__panic>
c010761e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107621:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107624:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107627:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010762a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010762d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107631:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107634:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107637:	0f 8e 5d ff ff ff    	jle    c010759a <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c010763d:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107644:	e9 cd 01 00 00       	jmp    c0107816 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107649:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010764c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107650:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107653:	89 04 24             	mov    %eax,(%esp)
c0107656:	e8 68 fa ff ff       	call   c01070c3 <find_vma>
c010765b:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c010765e:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107662:	75 24                	jne    c0107688 <check_vma_struct+0x260>
c0107664:	c7 44 24 0c 79 a4 10 	movl   $0xc010a479,0xc(%esp)
c010766b:	c0 
c010766c:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107673:	c0 
c0107674:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010767b:	00 
c010767c:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107683:	e8 4d 96 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107688:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768b:	83 c0 01             	add    $0x1,%eax
c010768e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107692:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107695:	89 04 24             	mov    %eax,(%esp)
c0107698:	e8 26 fa ff ff       	call   c01070c3 <find_vma>
c010769d:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c01076a0:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01076a4:	75 24                	jne    c01076ca <check_vma_struct+0x2a2>
c01076a6:	c7 44 24 0c 86 a4 10 	movl   $0xc010a486,0xc(%esp)
c01076ad:	c0 
c01076ae:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01076b5:	c0 
c01076b6:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c01076bd:	00 
c01076be:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01076c5:	e8 0b 96 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c01076ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076cd:	83 c0 02             	add    $0x2,%eax
c01076d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01076d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01076d7:	89 04 24             	mov    %eax,(%esp)
c01076da:	e8 e4 f9 ff ff       	call   c01070c3 <find_vma>
c01076df:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c01076e2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01076e6:	74 24                	je     c010770c <check_vma_struct+0x2e4>
c01076e8:	c7 44 24 0c 93 a4 10 	movl   $0xc010a493,0xc(%esp)
c01076ef:	c0 
c01076f0:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01076f7:	c0 
c01076f8:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01076ff:	00 
c0107700:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107707:	e8 c9 95 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c010770c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010770f:	83 c0 03             	add    $0x3,%eax
c0107712:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107716:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107719:	89 04 24             	mov    %eax,(%esp)
c010771c:	e8 a2 f9 ff ff       	call   c01070c3 <find_vma>
c0107721:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107724:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107728:	74 24                	je     c010774e <check_vma_struct+0x326>
c010772a:	c7 44 24 0c a0 a4 10 	movl   $0xc010a4a0,0xc(%esp)
c0107731:	c0 
c0107732:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107739:	c0 
c010773a:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107741:	00 
c0107742:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107749:	e8 87 95 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c010774e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107751:	83 c0 04             	add    $0x4,%eax
c0107754:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107758:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010775b:	89 04 24             	mov    %eax,(%esp)
c010775e:	e8 60 f9 ff ff       	call   c01070c3 <find_vma>
c0107763:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107766:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c010776a:	74 24                	je     c0107790 <check_vma_struct+0x368>
c010776c:	c7 44 24 0c ad a4 10 	movl   $0xc010a4ad,0xc(%esp)
c0107773:	c0 
c0107774:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c010777b:	c0 
c010777c:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107783:	00 
c0107784:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010778b:	e8 45 95 ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107790:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107793:	8b 50 04             	mov    0x4(%eax),%edx
c0107796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107799:	39 c2                	cmp    %eax,%edx
c010779b:	75 10                	jne    c01077ad <check_vma_struct+0x385>
c010779d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01077a0:	8b 50 08             	mov    0x8(%eax),%edx
c01077a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077a6:	83 c0 02             	add    $0x2,%eax
c01077a9:	39 c2                	cmp    %eax,%edx
c01077ab:	74 24                	je     c01077d1 <check_vma_struct+0x3a9>
c01077ad:	c7 44 24 0c bc a4 10 	movl   $0xc010a4bc,0xc(%esp)
c01077b4:	c0 
c01077b5:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01077bc:	c0 
c01077bd:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01077c4:	00 
c01077c5:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01077cc:	e8 04 95 ff ff       	call   c0100cd5 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c01077d1:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01077d4:	8b 50 04             	mov    0x4(%eax),%edx
c01077d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077da:	39 c2                	cmp    %eax,%edx
c01077dc:	75 10                	jne    c01077ee <check_vma_struct+0x3c6>
c01077de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01077e1:	8b 50 08             	mov    0x8(%eax),%edx
c01077e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01077e7:	83 c0 02             	add    $0x2,%eax
c01077ea:	39 c2                	cmp    %eax,%edx
c01077ec:	74 24                	je     c0107812 <check_vma_struct+0x3ea>
c01077ee:	c7 44 24 0c ec a4 10 	movl   $0xc010a4ec,0xc(%esp)
c01077f5:	c0 
c01077f6:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01077fd:	c0 
c01077fe:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107805:	00 
c0107806:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010780d:	e8 c3 94 ff ff       	call   c0100cd5 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107812:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107816:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107819:	89 d0                	mov    %edx,%eax
c010781b:	c1 e0 02             	shl    $0x2,%eax
c010781e:	01 d0                	add    %edx,%eax
c0107820:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107823:	0f 8d 20 fe ff ff    	jge    c0107649 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107829:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107830:	eb 70                	jmp    c01078a2 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107832:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107835:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107839:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010783c:	89 04 24             	mov    %eax,(%esp)
c010783f:	e8 7f f8 ff ff       	call   c01070c3 <find_vma>
c0107844:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107847:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010784b:	74 27                	je     c0107874 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c010784d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107850:	8b 50 08             	mov    0x8(%eax),%edx
c0107853:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107856:	8b 40 04             	mov    0x4(%eax),%eax
c0107859:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010785d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107864:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107868:	c7 04 24 1c a5 10 c0 	movl   $0xc010a51c,(%esp)
c010786f:	e8 d7 8a ff ff       	call   c010034b <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107874:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107878:	74 24                	je     c010789e <check_vma_struct+0x476>
c010787a:	c7 44 24 0c 41 a5 10 	movl   $0xc010a541,0xc(%esp)
c0107881:	c0 
c0107882:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107889:	c0 
c010788a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107891:	00 
c0107892:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107899:	e8 37 94 ff ff       	call   c0100cd5 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010789e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01078a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01078a6:	79 8a                	jns    c0107832 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c01078a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01078ab:	89 04 24             	mov    %eax,(%esp)
c01078ae:	e8 95 fa ff ff       	call   c0107348 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c01078b3:	e8 fe cd ff ff       	call   c01046b6 <nr_free_pages>
c01078b8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078bb:	74 24                	je     c01078e1 <check_vma_struct+0x4b9>
c01078bd:	c7 44 24 0c d4 a3 10 	movl   $0xc010a3d4,0xc(%esp)
c01078c4:	c0 
c01078c5:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01078cc:	c0 
c01078cd:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01078d4:	00 
c01078d5:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01078dc:	e8 f4 93 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c01078e1:	c7 04 24 58 a5 10 c0 	movl   $0xc010a558,(%esp)
c01078e8:	e8 5e 8a ff ff       	call   c010034b <cprintf>
}
c01078ed:	c9                   	leave  
c01078ee:	c3                   	ret    

c01078ef <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c01078ef:	55                   	push   %ebp
c01078f0:	89 e5                	mov    %esp,%ebp
c01078f2:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01078f5:	e8 bc cd ff ff       	call   c01046b6 <nr_free_pages>
c01078fa:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c01078fd:	e8 0e f7 ff ff       	call   c0107010 <mm_create>
c0107902:	a3 ac 0b 12 c0       	mov    %eax,0xc0120bac
    assert(check_mm_struct != NULL);
c0107907:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c010790c:	85 c0                	test   %eax,%eax
c010790e:	75 24                	jne    c0107934 <check_pgfault+0x45>
c0107910:	c7 44 24 0c 77 a5 10 	movl   $0xc010a577,0xc(%esp)
c0107917:	c0 
c0107918:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c010791f:	c0 
c0107920:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107927:	00 
c0107928:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c010792f:	e8 a1 93 ff ff       	call   c0100cd5 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107934:	a1 ac 0b 12 c0       	mov    0xc0120bac,%eax
c0107939:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c010793c:	8b 15 24 0a 12 c0    	mov    0xc0120a24,%edx
c0107942:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107945:	89 50 0c             	mov    %edx,0xc(%eax)
c0107948:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010794b:	8b 40 0c             	mov    0xc(%eax),%eax
c010794e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107954:	8b 00                	mov    (%eax),%eax
c0107956:	85 c0                	test   %eax,%eax
c0107958:	74 24                	je     c010797e <check_pgfault+0x8f>
c010795a:	c7 44 24 0c 8f a5 10 	movl   $0xc010a58f,0xc(%esp)
c0107961:	c0 
c0107962:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107969:	c0 
c010796a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107971:	00 
c0107972:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107979:	e8 57 93 ff ff       	call   c0100cd5 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c010797e:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107985:	00 
c0107986:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c010798d:	00 
c010798e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107995:	e8 ee f6 ff ff       	call   c0107088 <vma_create>
c010799a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c010799d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01079a1:	75 24                	jne    c01079c7 <check_pgfault+0xd8>
c01079a3:	c7 44 24 0c 1e a4 10 	movl   $0xc010a41e,0xc(%esp)
c01079aa:	c0 
c01079ab:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c01079b2:	c0 
c01079b3:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01079ba:	00 
c01079bb:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c01079c2:	e8 0e 93 ff ff       	call   c0100cd5 <__panic>

    insert_vma_struct(mm, vma);
c01079c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01079ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079d1:	89 04 24             	mov    %eax,(%esp)
c01079d4:	e8 3f f8 ff ff       	call   c0107218 <insert_vma_struct>

    uintptr_t addr = 0x100;
c01079d9:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c01079e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01079e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079ea:	89 04 24             	mov    %eax,(%esp)
c01079ed:	e8 d1 f6 ff ff       	call   c01070c3 <find_vma>
c01079f2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01079f5:	74 24                	je     c0107a1b <check_pgfault+0x12c>
c01079f7:	c7 44 24 0c 9d a5 10 	movl   $0xc010a59d,0xc(%esp)
c01079fe:	c0 
c01079ff:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107a06:	c0 
c0107a07:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107a0e:	00 
c0107a0f:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107a16:	e8 ba 92 ff ff       	call   c0100cd5 <__panic>

    int i, sum = 0;
c0107a1b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a29:	eb 17                	jmp    c0107a42 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107a2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a31:	01 d0                	add    %edx,%eax
c0107a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a36:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a3b:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107a3e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a42:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a46:	7e e3                	jle    c0107a2b <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a48:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107a4f:	eb 15                	jmp    c0107a66 <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107a51:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a54:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a57:	01 d0                	add    %edx,%eax
c0107a59:	0f b6 00             	movzbl (%eax),%eax
c0107a5c:	0f be c0             	movsbl %al,%eax
c0107a5f:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107a62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107a66:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107a6a:	7e e5                	jle    c0107a51 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a70:	74 24                	je     c0107a96 <check_pgfault+0x1a7>
c0107a72:	c7 44 24 0c b7 a5 10 	movl   $0xc010a5b7,0xc(%esp)
c0107a79:	c0 
c0107a7a:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107a81:	c0 
c0107a82:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107a89:	00 
c0107a8a:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107a91:	e8 3f 92 ff ff       	call   c0100cd5 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107a96:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107a99:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107a9c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107a9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107aa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107aab:	89 04 24             	mov    %eax,(%esp)
c0107aae:	e8 ba d4 ff ff       	call   c0104f6d <page_remove>
    free_page(pa2page(pgdir[0]));
c0107ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ab6:	8b 00                	mov    (%eax),%eax
c0107ab8:	89 04 24             	mov    %eax,(%esp)
c0107abb:	e8 0b f5 ff ff       	call   c0106fcb <pa2page>
c0107ac0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107ac7:	00 
c0107ac8:	89 04 24             	mov    %eax,(%esp)
c0107acb:	e8 b4 cb ff ff       	call   c0104684 <free_pages>
    pgdir[0] = 0;
c0107ad0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ad3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107ad9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107adc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107ae3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ae6:	89 04 24             	mov    %eax,(%esp)
c0107ae9:	e8 5a f8 ff ff       	call   c0107348 <mm_destroy>
    check_mm_struct = NULL;
c0107aee:	c7 05 ac 0b 12 c0 00 	movl   $0x0,0xc0120bac
c0107af5:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107af8:	e8 b9 cb ff ff       	call   c01046b6 <nr_free_pages>
c0107afd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b00:	74 24                	je     c0107b26 <check_pgfault+0x237>
c0107b02:	c7 44 24 0c d4 a3 10 	movl   $0xc010a3d4,0xc(%esp)
c0107b09:	c0 
c0107b0a:	c7 44 24 08 53 a3 10 	movl   $0xc010a353,0x8(%esp)
c0107b11:	c0 
c0107b12:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107b19:	00 
c0107b1a:	c7 04 24 68 a3 10 c0 	movl   $0xc010a368,(%esp)
c0107b21:	e8 af 91 ff ff       	call   c0100cd5 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107b26:	c7 04 24 c0 a5 10 c0 	movl   $0xc010a5c0,(%esp)
c0107b2d:	e8 19 88 ff ff       	call   c010034b <cprintf>
}
c0107b32:	c9                   	leave  
c0107b33:	c3                   	ret    

c0107b34 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107b34:	55                   	push   %ebp
c0107b35:	89 e5                	mov    %esp,%ebp
c0107b37:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107b3a:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107b41:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b48:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b4b:	89 04 24             	mov    %eax,(%esp)
c0107b4e:	e8 70 f5 ff ff       	call   c01070c3 <find_vma>
c0107b53:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107b56:	a1 b8 0a 12 c0       	mov    0xc0120ab8,%eax
c0107b5b:	83 c0 01             	add    $0x1,%eax
c0107b5e:	a3 b8 0a 12 c0       	mov    %eax,0xc0120ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107b63:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107b67:	74 0b                	je     c0107b74 <do_pgfault+0x40>
c0107b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b6c:	8b 40 04             	mov    0x4(%eax),%eax
c0107b6f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107b72:	76 18                	jbe    c0107b8c <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107b74:	8b 45 10             	mov    0x10(%ebp),%eax
c0107b77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b7b:	c7 04 24 dc a5 10 c0 	movl   $0xc010a5dc,(%esp)
c0107b82:	e8 c4 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107b87:	e9 6c 01 00 00       	jmp    c0107cf8 <do_pgfault+0x1c4>
    }
    //check the error_code
    switch (error_code & 3) {
c0107b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b8f:	83 e0 03             	and    $0x3,%eax
c0107b92:	85 c0                	test   %eax,%eax
c0107b94:	74 36                	je     c0107bcc <do_pgfault+0x98>
c0107b96:	83 f8 01             	cmp    $0x1,%eax
c0107b99:	74 20                	je     c0107bbb <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107b9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b9e:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ba1:	83 e0 02             	and    $0x2,%eax
c0107ba4:	85 c0                	test   %eax,%eax
c0107ba6:	75 11                	jne    c0107bb9 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107ba8:	c7 04 24 0c a6 10 c0 	movl   $0xc010a60c,(%esp)
c0107baf:	e8 97 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107bb4:	e9 3f 01 00 00       	jmp    c0107cf8 <do_pgfault+0x1c4>
        }
        break;
c0107bb9:	eb 2f                	jmp    c0107bea <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107bbb:	c7 04 24 6c a6 10 c0 	movl   $0xc010a66c,(%esp)
c0107bc2:	e8 84 87 ff ff       	call   c010034b <cprintf>
        goto failed;
c0107bc7:	e9 2c 01 00 00       	jmp    c0107cf8 <do_pgfault+0x1c4>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107bcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bcf:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bd2:	83 e0 05             	and    $0x5,%eax
c0107bd5:	85 c0                	test   %eax,%eax
c0107bd7:	75 11                	jne    c0107bea <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107bd9:	c7 04 24 a4 a6 10 c0 	movl   $0xc010a6a4,(%esp)
c0107be0:	e8 66 87 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107be5:	e9 0e 01 00 00       	jmp    c0107cf8 <do_pgfault+0x1c4>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107bea:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107bf1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107bf4:	8b 40 0c             	mov    0xc(%eax),%eax
c0107bf7:	83 e0 02             	and    $0x2,%eax
c0107bfa:	85 c0                	test   %eax,%eax
c0107bfc:	74 04                	je     c0107c02 <do_pgfault+0xce>
        perm |= PTE_W;
c0107bfe:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107c02:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107c08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107c10:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107c13:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107c1a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */
//#if 0
    /*LAB3 EXERCISE 1: 2012011394*/
    //ptep = ???              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    ptep = get_pte(mm->pgdir, addr, 1);
c0107c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c24:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c27:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107c2e:	00 
c0107c2f:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c32:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c36:	89 04 24             	mov    %eax,(%esp)
c0107c39:	e8 3d d1 ff ff       	call   c0104d7b <get_pte>
c0107c3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) {
c0107c41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c44:	8b 00                	mov    (%eax),%eax
c0107c46:	85 c0                	test   %eax,%eax
c0107c48:	75 21                	jne    c0107c6b <do_pgfault+0x137>
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    	pgdir_alloc_page(mm->pgdir, addr, perm);
c0107c4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c4d:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c50:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107c53:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107c57:	8b 55 10             	mov    0x10(%ebp),%edx
c0107c5a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107c5e:	89 04 24             	mov    %eax,(%esp)
c0107c61:	e8 61 d4 ff ff       	call   c01050c7 <pgdir_alloc_page>
c0107c66:	e9 86 00 00 00       	jmp    c0107cf1 <do_pgfault+0x1bd>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0107c6b:	a1 ac 0a 12 c0       	mov    0xc0120aac,%eax
c0107c70:	85 c0                	test   %eax,%eax
c0107c72:	74 66                	je     c0107cda <do_pgfault+0x1a6>
            struct Page *page=NULL;
c0107c74:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            swap_in(mm, addr, &page);
c0107c7b:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0107c7e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107c82:	8b 45 10             	mov    0x10(%ebp),%eax
c0107c85:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c89:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c8c:	89 04 24             	mov    %eax,(%esp)
c0107c8f:	e8 fd e5 ff ff       	call   c0106291 <swap_in>
            page_insert(mm->pgdir, page, addr, perm);
c0107c94:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107c97:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c9a:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c9d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107ca0:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107ca4:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107ca7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107cab:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107caf:	89 04 24             	mov    %eax,(%esp)
c0107cb2:	e8 fa d2 ff ff       	call   c0104fb1 <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c0107cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107cba:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107cc1:	00 
c0107cc2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107cc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0107cc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ccd:	8b 45 08             	mov    0x8(%ebp),%eax
c0107cd0:	89 04 24             	mov    %eax,(%esp)
c0107cd3:	e8 f0 e3 ff ff       	call   c01060c8 <swap_map_swappable>
c0107cd8:	eb 17                	jmp    c0107cf1 <do_pgfault+0x1bd>
                                    //    into the memory which page managed.
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                    //(3) make the page swappable.
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0107cda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107cdd:	8b 00                	mov    (%eax),%eax
c0107cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ce3:	c7 04 24 08 a7 10 c0 	movl   $0xc010a708,(%esp)
c0107cea:	e8 5c 86 ff ff       	call   c010034b <cprintf>
            goto failed;
c0107cef:	eb 07                	jmp    c0107cf8 <do_pgfault+0x1c4>
        }
   }
//#endif
   ret = 0;
c0107cf1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c0107cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107cfb:	c9                   	leave  
c0107cfc:	c3                   	ret    

c0107cfd <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0107cfd:	55                   	push   %ebp
c0107cfe:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0107d00:	8b 55 08             	mov    0x8(%ebp),%edx
c0107d03:	a1 d4 0a 12 c0       	mov    0xc0120ad4,%eax
c0107d08:	29 c2                	sub    %eax,%edx
c0107d0a:	89 d0                	mov    %edx,%eax
c0107d0c:	c1 f8 05             	sar    $0x5,%eax
}
c0107d0f:	5d                   	pop    %ebp
c0107d10:	c3                   	ret    

c0107d11 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0107d11:	55                   	push   %ebp
c0107d12:	89 e5                	mov    %esp,%ebp
c0107d14:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0107d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d1a:	89 04 24             	mov    %eax,(%esp)
c0107d1d:	e8 db ff ff ff       	call   c0107cfd <page2ppn>
c0107d22:	c1 e0 0c             	shl    $0xc,%eax
}
c0107d25:	c9                   	leave  
c0107d26:	c3                   	ret    

c0107d27 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c0107d27:	55                   	push   %ebp
c0107d28:	89 e5                	mov    %esp,%ebp
c0107d2a:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0107d2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107d30:	89 04 24             	mov    %eax,(%esp)
c0107d33:	e8 d9 ff ff ff       	call   c0107d11 <page2pa>
c0107d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d3e:	c1 e8 0c             	shr    $0xc,%eax
c0107d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107d44:	a1 20 0a 12 c0       	mov    0xc0120a20,%eax
c0107d49:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0107d4c:	72 23                	jb     c0107d71 <page2kva+0x4a>
c0107d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d51:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107d55:	c7 44 24 08 30 a7 10 	movl   $0xc010a730,0x8(%esp)
c0107d5c:	c0 
c0107d5d:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0107d64:	00 
c0107d65:	c7 04 24 53 a7 10 c0 	movl   $0xc010a753,(%esp)
c0107d6c:	e8 64 8f ff ff       	call   c0100cd5 <__panic>
c0107d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d74:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0107d79:	c9                   	leave  
c0107d7a:	c3                   	ret    

c0107d7b <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0107d7b:	55                   	push   %ebp
c0107d7c:	89 e5                	mov    %esp,%ebp
c0107d7e:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0107d81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107d88:	e8 98 9c ff ff       	call   c0101a25 <ide_device_valid>
c0107d8d:	85 c0                	test   %eax,%eax
c0107d8f:	75 1c                	jne    c0107dad <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0107d91:	c7 44 24 08 61 a7 10 	movl   $0xc010a761,0x8(%esp)
c0107d98:	c0 
c0107d99:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0107da0:	00 
c0107da1:	c7 04 24 7b a7 10 c0 	movl   $0xc010a77b,(%esp)
c0107da8:	e8 28 8f ff ff       	call   c0100cd5 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0107dad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107db4:	e8 ab 9c ff ff       	call   c0101a64 <ide_device_size>
c0107db9:	c1 e8 03             	shr    $0x3,%eax
c0107dbc:	a3 7c 0b 12 c0       	mov    %eax,0xc0120b7c
}
c0107dc1:	c9                   	leave  
c0107dc2:	c3                   	ret    

c0107dc3 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0107dc3:	55                   	push   %ebp
c0107dc4:	89 e5                	mov    %esp,%ebp
c0107dc6:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107dcc:	89 04 24             	mov    %eax,(%esp)
c0107dcf:	e8 53 ff ff ff       	call   c0107d27 <page2kva>
c0107dd4:	8b 55 08             	mov    0x8(%ebp),%edx
c0107dd7:	c1 ea 08             	shr    $0x8,%edx
c0107dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107de1:	74 0b                	je     c0107dee <swapfs_read+0x2b>
c0107de3:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107de9:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107dec:	72 23                	jb     c0107e11 <swapfs_read+0x4e>
c0107dee:	8b 45 08             	mov    0x8(%ebp),%eax
c0107df1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107df5:	c7 44 24 08 8c a7 10 	movl   $0xc010a78c,0x8(%esp)
c0107dfc:	c0 
c0107dfd:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0107e04:	00 
c0107e05:	c7 04 24 7b a7 10 c0 	movl   $0xc010a77b,(%esp)
c0107e0c:	e8 c4 8e ff ff       	call   c0100cd5 <__panic>
c0107e11:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e14:	c1 e2 03             	shl    $0x3,%edx
c0107e17:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107e1e:	00 
c0107e1f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e23:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107e2e:	e8 70 9c ff ff       	call   c0101aa3 <ide_read_secs>
}
c0107e33:	c9                   	leave  
c0107e34:	c3                   	ret    

c0107e35 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0107e35:	55                   	push   %ebp
c0107e36:	89 e5                	mov    %esp,%ebp
c0107e38:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0107e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e3e:	89 04 24             	mov    %eax,(%esp)
c0107e41:	e8 e1 fe ff ff       	call   c0107d27 <page2kva>
c0107e46:	8b 55 08             	mov    0x8(%ebp),%edx
c0107e49:	c1 ea 08             	shr    $0x8,%edx
c0107e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107e4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e53:	74 0b                	je     c0107e60 <swapfs_write+0x2b>
c0107e55:	8b 15 7c 0b 12 c0    	mov    0xc0120b7c,%edx
c0107e5b:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0107e5e:	72 23                	jb     c0107e83 <swapfs_write+0x4e>
c0107e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e63:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107e67:	c7 44 24 08 8c a7 10 	movl   $0xc010a78c,0x8(%esp)
c0107e6e:	c0 
c0107e6f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0107e76:	00 
c0107e77:	c7 04 24 7b a7 10 c0 	movl   $0xc010a77b,(%esp)
c0107e7e:	e8 52 8e ff ff       	call   c0100cd5 <__panic>
c0107e83:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e86:	c1 e2 03             	shl    $0x3,%edx
c0107e89:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0107e90:	00 
c0107e91:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e95:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107e99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0107ea0:	e8 40 9e ff ff       	call   c0101ce5 <ide_write_secs>
}
c0107ea5:	c9                   	leave  
c0107ea6:	c3                   	ret    

c0107ea7 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0107ea7:	55                   	push   %ebp
c0107ea8:	89 e5                	mov    %esp,%ebp
c0107eaa:	83 ec 58             	sub    $0x58,%esp
c0107ead:	8b 45 10             	mov    0x10(%ebp),%eax
c0107eb0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0107eb3:	8b 45 14             	mov    0x14(%ebp),%eax
c0107eb6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0107eb9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107ebc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107ebf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ec2:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0107ec5:	8b 45 18             	mov    0x18(%ebp),%eax
c0107ec8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0107ecb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ece:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107ed1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107ed4:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0107ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107eda:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107ee1:	74 1c                	je     c0107eff <printnum+0x58>
c0107ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ee6:	ba 00 00 00 00       	mov    $0x0,%edx
c0107eeb:	f7 75 e4             	divl   -0x1c(%ebp)
c0107eee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0107ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ef4:	ba 00 00 00 00       	mov    $0x0,%edx
c0107ef9:	f7 75 e4             	divl   -0x1c(%ebp)
c0107efc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107eff:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f02:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107f05:	f7 75 e4             	divl   -0x1c(%ebp)
c0107f08:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107f0b:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0107f0e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f11:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f14:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107f17:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0107f1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f1d:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0107f20:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f23:	ba 00 00 00 00       	mov    $0x0,%edx
c0107f28:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f2b:	77 56                	ja     c0107f83 <printnum+0xdc>
c0107f2d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0107f30:	72 05                	jb     c0107f37 <printnum+0x90>
c0107f32:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0107f35:	77 4c                	ja     c0107f83 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0107f37:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0107f3a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0107f3d:	8b 45 20             	mov    0x20(%ebp),%eax
c0107f40:	89 44 24 18          	mov    %eax,0x18(%esp)
c0107f44:	89 54 24 14          	mov    %edx,0x14(%esp)
c0107f48:	8b 45 18             	mov    0x18(%ebp),%eax
c0107f4b:	89 44 24 10          	mov    %eax,0x10(%esp)
c0107f4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f52:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107f55:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f59:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f64:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f67:	89 04 24             	mov    %eax,(%esp)
c0107f6a:	e8 38 ff ff ff       	call   c0107ea7 <printnum>
c0107f6f:	eb 1c                	jmp    c0107f8d <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0107f71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107f74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f78:	8b 45 20             	mov    0x20(%ebp),%eax
c0107f7b:	89 04 24             	mov    %eax,(%esp)
c0107f7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f81:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0107f83:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0107f87:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0107f8b:	7f e4                	jg     c0107f71 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0107f8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107f90:	05 2c a8 10 c0       	add    $0xc010a82c,%eax
c0107f95:	0f b6 00             	movzbl (%eax),%eax
c0107f98:	0f be c0             	movsbl %al,%eax
c0107f9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107f9e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fa2:	89 04 24             	mov    %eax,(%esp)
c0107fa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fa8:	ff d0                	call   *%eax
}
c0107faa:	c9                   	leave  
c0107fab:	c3                   	ret    

c0107fac <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0107fac:	55                   	push   %ebp
c0107fad:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107faf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0107fb3:	7e 14                	jle    c0107fc9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0107fb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fb8:	8b 00                	mov    (%eax),%eax
c0107fba:	8d 48 08             	lea    0x8(%eax),%ecx
c0107fbd:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fc0:	89 0a                	mov    %ecx,(%edx)
c0107fc2:	8b 50 04             	mov    0x4(%eax),%edx
c0107fc5:	8b 00                	mov    (%eax),%eax
c0107fc7:	eb 30                	jmp    c0107ff9 <getuint+0x4d>
    }
    else if (lflag) {
c0107fc9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0107fcd:	74 16                	je     c0107fe5 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0107fcf:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fd2:	8b 00                	mov    (%eax),%eax
c0107fd4:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fd7:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fda:	89 0a                	mov    %ecx,(%edx)
c0107fdc:	8b 00                	mov    (%eax),%eax
c0107fde:	ba 00 00 00 00       	mov    $0x0,%edx
c0107fe3:	eb 14                	jmp    c0107ff9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0107fe5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fe8:	8b 00                	mov    (%eax),%eax
c0107fea:	8d 48 04             	lea    0x4(%eax),%ecx
c0107fed:	8b 55 08             	mov    0x8(%ebp),%edx
c0107ff0:	89 0a                	mov    %ecx,(%edx)
c0107ff2:	8b 00                	mov    (%eax),%eax
c0107ff4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0107ff9:	5d                   	pop    %ebp
c0107ffa:	c3                   	ret    

c0107ffb <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0107ffb:	55                   	push   %ebp
c0107ffc:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0107ffe:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0108002:	7e 14                	jle    c0108018 <getint+0x1d>
        return va_arg(*ap, long long);
c0108004:	8b 45 08             	mov    0x8(%ebp),%eax
c0108007:	8b 00                	mov    (%eax),%eax
c0108009:	8d 48 08             	lea    0x8(%eax),%ecx
c010800c:	8b 55 08             	mov    0x8(%ebp),%edx
c010800f:	89 0a                	mov    %ecx,(%edx)
c0108011:	8b 50 04             	mov    0x4(%eax),%edx
c0108014:	8b 00                	mov    (%eax),%eax
c0108016:	eb 28                	jmp    c0108040 <getint+0x45>
    }
    else if (lflag) {
c0108018:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010801c:	74 12                	je     c0108030 <getint+0x35>
        return va_arg(*ap, long);
c010801e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108021:	8b 00                	mov    (%eax),%eax
c0108023:	8d 48 04             	lea    0x4(%eax),%ecx
c0108026:	8b 55 08             	mov    0x8(%ebp),%edx
c0108029:	89 0a                	mov    %ecx,(%edx)
c010802b:	8b 00                	mov    (%eax),%eax
c010802d:	99                   	cltd   
c010802e:	eb 10                	jmp    c0108040 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0108030:	8b 45 08             	mov    0x8(%ebp),%eax
c0108033:	8b 00                	mov    (%eax),%eax
c0108035:	8d 48 04             	lea    0x4(%eax),%ecx
c0108038:	8b 55 08             	mov    0x8(%ebp),%edx
c010803b:	89 0a                	mov    %ecx,(%edx)
c010803d:	8b 00                	mov    (%eax),%eax
c010803f:	99                   	cltd   
    }
}
c0108040:	5d                   	pop    %ebp
c0108041:	c3                   	ret    

c0108042 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0108042:	55                   	push   %ebp
c0108043:	89 e5                	mov    %esp,%ebp
c0108045:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0108048:	8d 45 14             	lea    0x14(%ebp),%eax
c010804b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010804e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108051:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108055:	8b 45 10             	mov    0x10(%ebp),%eax
c0108058:	89 44 24 08          	mov    %eax,0x8(%esp)
c010805c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010805f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108063:	8b 45 08             	mov    0x8(%ebp),%eax
c0108066:	89 04 24             	mov    %eax,(%esp)
c0108069:	e8 02 00 00 00       	call   c0108070 <vprintfmt>
    va_end(ap);
}
c010806e:	c9                   	leave  
c010806f:	c3                   	ret    

c0108070 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0108070:	55                   	push   %ebp
c0108071:	89 e5                	mov    %esp,%ebp
c0108073:	56                   	push   %esi
c0108074:	53                   	push   %ebx
c0108075:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108078:	eb 18                	jmp    c0108092 <vprintfmt+0x22>
            if (ch == '\0') {
c010807a:	85 db                	test   %ebx,%ebx
c010807c:	75 05                	jne    c0108083 <vprintfmt+0x13>
                return;
c010807e:	e9 d1 03 00 00       	jmp    c0108454 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0108083:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108086:	89 44 24 04          	mov    %eax,0x4(%esp)
c010808a:	89 1c 24             	mov    %ebx,(%esp)
c010808d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108090:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108092:	8b 45 10             	mov    0x10(%ebp),%eax
c0108095:	8d 50 01             	lea    0x1(%eax),%edx
c0108098:	89 55 10             	mov    %edx,0x10(%ebp)
c010809b:	0f b6 00             	movzbl (%eax),%eax
c010809e:	0f b6 d8             	movzbl %al,%ebx
c01080a1:	83 fb 25             	cmp    $0x25,%ebx
c01080a4:	75 d4                	jne    c010807a <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c01080a6:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c01080aa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c01080b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01080b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c01080b7:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01080be:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01080c1:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c01080c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01080c7:	8d 50 01             	lea    0x1(%eax),%edx
c01080ca:	89 55 10             	mov    %edx,0x10(%ebp)
c01080cd:	0f b6 00             	movzbl (%eax),%eax
c01080d0:	0f b6 d8             	movzbl %al,%ebx
c01080d3:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01080d6:	83 f8 55             	cmp    $0x55,%eax
c01080d9:	0f 87 44 03 00 00    	ja     c0108423 <vprintfmt+0x3b3>
c01080df:	8b 04 85 50 a8 10 c0 	mov    -0x3fef57b0(,%eax,4),%eax
c01080e6:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01080e8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01080ec:	eb d6                	jmp    c01080c4 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01080ee:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01080f2:	eb d0                	jmp    c01080c4 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01080f4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01080fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01080fe:	89 d0                	mov    %edx,%eax
c0108100:	c1 e0 02             	shl    $0x2,%eax
c0108103:	01 d0                	add    %edx,%eax
c0108105:	01 c0                	add    %eax,%eax
c0108107:	01 d8                	add    %ebx,%eax
c0108109:	83 e8 30             	sub    $0x30,%eax
c010810c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010810f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108112:	0f b6 00             	movzbl (%eax),%eax
c0108115:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108118:	83 fb 2f             	cmp    $0x2f,%ebx
c010811b:	7e 0b                	jle    c0108128 <vprintfmt+0xb8>
c010811d:	83 fb 39             	cmp    $0x39,%ebx
c0108120:	7f 06                	jg     c0108128 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0108122:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0108126:	eb d3                	jmp    c01080fb <vprintfmt+0x8b>
            goto process_precision;
c0108128:	eb 33                	jmp    c010815d <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c010812a:	8b 45 14             	mov    0x14(%ebp),%eax
c010812d:	8d 50 04             	lea    0x4(%eax),%edx
c0108130:	89 55 14             	mov    %edx,0x14(%ebp)
c0108133:	8b 00                	mov    (%eax),%eax
c0108135:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0108138:	eb 23                	jmp    c010815d <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010813a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010813e:	79 0c                	jns    c010814c <vprintfmt+0xdc>
                width = 0;
c0108140:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0108147:	e9 78 ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>
c010814c:	e9 73 ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0108151:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0108158:	e9 67 ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010815d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108161:	79 12                	jns    c0108175 <vprintfmt+0x105>
                width = precision, precision = -1;
c0108163:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108166:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108169:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0108170:	e9 4f ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>
c0108175:	e9 4a ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010817a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010817e:	e9 41 ff ff ff       	jmp    c01080c4 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0108183:	8b 45 14             	mov    0x14(%ebp),%eax
c0108186:	8d 50 04             	lea    0x4(%eax),%edx
c0108189:	89 55 14             	mov    %edx,0x14(%ebp)
c010818c:	8b 00                	mov    (%eax),%eax
c010818e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108191:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108195:	89 04 24             	mov    %eax,(%esp)
c0108198:	8b 45 08             	mov    0x8(%ebp),%eax
c010819b:	ff d0                	call   *%eax
            break;
c010819d:	e9 ac 02 00 00       	jmp    c010844e <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01081a2:	8b 45 14             	mov    0x14(%ebp),%eax
c01081a5:	8d 50 04             	lea    0x4(%eax),%edx
c01081a8:	89 55 14             	mov    %edx,0x14(%ebp)
c01081ab:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c01081ad:	85 db                	test   %ebx,%ebx
c01081af:	79 02                	jns    c01081b3 <vprintfmt+0x143>
                err = -err;
c01081b1:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c01081b3:	83 fb 06             	cmp    $0x6,%ebx
c01081b6:	7f 0b                	jg     c01081c3 <vprintfmt+0x153>
c01081b8:	8b 34 9d 10 a8 10 c0 	mov    -0x3fef57f0(,%ebx,4),%esi
c01081bf:	85 f6                	test   %esi,%esi
c01081c1:	75 23                	jne    c01081e6 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c01081c3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01081c7:	c7 44 24 08 3d a8 10 	movl   $0xc010a83d,0x8(%esp)
c01081ce:	c0 
c01081cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01081d9:	89 04 24             	mov    %eax,(%esp)
c01081dc:	e8 61 fe ff ff       	call   c0108042 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01081e1:	e9 68 02 00 00       	jmp    c010844e <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01081e6:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01081ea:	c7 44 24 08 46 a8 10 	movl   $0xc010a846,0x8(%esp)
c01081f1:	c0 
c01081f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01081f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01081fc:	89 04 24             	mov    %eax,(%esp)
c01081ff:	e8 3e fe ff ff       	call   c0108042 <printfmt>
            }
            break;
c0108204:	e9 45 02 00 00       	jmp    c010844e <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0108209:	8b 45 14             	mov    0x14(%ebp),%eax
c010820c:	8d 50 04             	lea    0x4(%eax),%edx
c010820f:	89 55 14             	mov    %edx,0x14(%ebp)
c0108212:	8b 30                	mov    (%eax),%esi
c0108214:	85 f6                	test   %esi,%esi
c0108216:	75 05                	jne    c010821d <vprintfmt+0x1ad>
                p = "(null)";
c0108218:	be 49 a8 10 c0       	mov    $0xc010a849,%esi
            }
            if (width > 0 && padc != '-') {
c010821d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108221:	7e 3e                	jle    c0108261 <vprintfmt+0x1f1>
c0108223:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0108227:	74 38                	je     c0108261 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108229:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010822c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010822f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108233:	89 34 24             	mov    %esi,(%esp)
c0108236:	e8 ed 03 00 00       	call   c0108628 <strnlen>
c010823b:	29 c3                	sub    %eax,%ebx
c010823d:	89 d8                	mov    %ebx,%eax
c010823f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108242:	eb 17                	jmp    c010825b <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0108244:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0108248:	8b 55 0c             	mov    0xc(%ebp),%edx
c010824b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010824f:	89 04 24             	mov    %eax,(%esp)
c0108252:	8b 45 08             	mov    0x8(%ebp),%eax
c0108255:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0108257:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010825b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010825f:	7f e3                	jg     c0108244 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108261:	eb 38                	jmp    c010829b <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0108263:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108267:	74 1f                	je     c0108288 <vprintfmt+0x218>
c0108269:	83 fb 1f             	cmp    $0x1f,%ebx
c010826c:	7e 05                	jle    c0108273 <vprintfmt+0x203>
c010826e:	83 fb 7e             	cmp    $0x7e,%ebx
c0108271:	7e 15                	jle    c0108288 <vprintfmt+0x218>
                    putch('?', putdat);
c0108273:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108276:	89 44 24 04          	mov    %eax,0x4(%esp)
c010827a:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0108281:	8b 45 08             	mov    0x8(%ebp),%eax
c0108284:	ff d0                	call   *%eax
c0108286:	eb 0f                	jmp    c0108297 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0108288:	8b 45 0c             	mov    0xc(%ebp),%eax
c010828b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010828f:	89 1c 24             	mov    %ebx,(%esp)
c0108292:	8b 45 08             	mov    0x8(%ebp),%eax
c0108295:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0108297:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010829b:	89 f0                	mov    %esi,%eax
c010829d:	8d 70 01             	lea    0x1(%eax),%esi
c01082a0:	0f b6 00             	movzbl (%eax),%eax
c01082a3:	0f be d8             	movsbl %al,%ebx
c01082a6:	85 db                	test   %ebx,%ebx
c01082a8:	74 10                	je     c01082ba <vprintfmt+0x24a>
c01082aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01082ae:	78 b3                	js     c0108263 <vprintfmt+0x1f3>
c01082b0:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c01082b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01082b8:	79 a9                	jns    c0108263 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01082ba:	eb 17                	jmp    c01082d3 <vprintfmt+0x263>
                putch(' ', putdat);
c01082bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082c3:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01082ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01082cd:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01082cf:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01082d3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01082d7:	7f e3                	jg     c01082bc <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01082d9:	e9 70 01 00 00       	jmp    c010844e <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01082de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01082e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082e5:	8d 45 14             	lea    0x14(%ebp),%eax
c01082e8:	89 04 24             	mov    %eax,(%esp)
c01082eb:	e8 0b fd ff ff       	call   c0107ffb <getint>
c01082f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01082f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01082f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01082fc:	85 d2                	test   %edx,%edx
c01082fe:	79 26                	jns    c0108326 <vprintfmt+0x2b6>
                putch('-', putdat);
c0108300:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108303:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108307:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010830e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108311:	ff d0                	call   *%eax
                num = -(long long)num;
c0108313:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108316:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108319:	f7 d8                	neg    %eax
c010831b:	83 d2 00             	adc    $0x0,%edx
c010831e:	f7 da                	neg    %edx
c0108320:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108323:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0108326:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010832d:	e9 a8 00 00 00       	jmp    c01083da <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0108332:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108335:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108339:	8d 45 14             	lea    0x14(%ebp),%eax
c010833c:	89 04 24             	mov    %eax,(%esp)
c010833f:	e8 68 fc ff ff       	call   c0107fac <getuint>
c0108344:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108347:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010834a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0108351:	e9 84 00 00 00       	jmp    c01083da <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0108356:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108359:	89 44 24 04          	mov    %eax,0x4(%esp)
c010835d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108360:	89 04 24             	mov    %eax,(%esp)
c0108363:	e8 44 fc ff ff       	call   c0107fac <getuint>
c0108368:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010836b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010836e:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0108375:	eb 63                	jmp    c01083da <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0108377:	8b 45 0c             	mov    0xc(%ebp),%eax
c010837a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010837e:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108385:	8b 45 08             	mov    0x8(%ebp),%eax
c0108388:	ff d0                	call   *%eax
            putch('x', putdat);
c010838a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010838d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108391:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108398:	8b 45 08             	mov    0x8(%ebp),%eax
c010839b:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010839d:	8b 45 14             	mov    0x14(%ebp),%eax
c01083a0:	8d 50 04             	lea    0x4(%eax),%edx
c01083a3:	89 55 14             	mov    %edx,0x14(%ebp)
c01083a6:	8b 00                	mov    (%eax),%eax
c01083a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c01083b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c01083b9:	eb 1f                	jmp    c01083da <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c01083bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c2:	8d 45 14             	lea    0x14(%ebp),%eax
c01083c5:	89 04 24             	mov    %eax,(%esp)
c01083c8:	e8 df fb ff ff       	call   c0107fac <getuint>
c01083cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083d0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01083d3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01083da:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01083de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083e1:	89 54 24 18          	mov    %edx,0x18(%esp)
c01083e5:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01083e8:	89 54 24 14          	mov    %edx,0x14(%esp)
c01083ec:	89 44 24 10          	mov    %eax,0x10(%esp)
c01083f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083fa:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01083fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108401:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108405:	8b 45 08             	mov    0x8(%ebp),%eax
c0108408:	89 04 24             	mov    %eax,(%esp)
c010840b:	e8 97 fa ff ff       	call   c0107ea7 <printnum>
            break;
c0108410:	eb 3c                	jmp    c010844e <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0108412:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108415:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108419:	89 1c 24             	mov    %ebx,(%esp)
c010841c:	8b 45 08             	mov    0x8(%ebp),%eax
c010841f:	ff d0                	call   *%eax
            break;
c0108421:	eb 2b                	jmp    c010844e <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0108423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010842a:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0108431:	8b 45 08             	mov    0x8(%ebp),%eax
c0108434:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0108436:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010843a:	eb 04                	jmp    c0108440 <vprintfmt+0x3d0>
c010843c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108440:	8b 45 10             	mov    0x10(%ebp),%eax
c0108443:	83 e8 01             	sub    $0x1,%eax
c0108446:	0f b6 00             	movzbl (%eax),%eax
c0108449:	3c 25                	cmp    $0x25,%al
c010844b:	75 ef                	jne    c010843c <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010844d:	90                   	nop
        }
    }
c010844e:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010844f:	e9 3e fc ff ff       	jmp    c0108092 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0108454:	83 c4 40             	add    $0x40,%esp
c0108457:	5b                   	pop    %ebx
c0108458:	5e                   	pop    %esi
c0108459:	5d                   	pop    %ebp
c010845a:	c3                   	ret    

c010845b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010845b:	55                   	push   %ebp
c010845c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010845e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108461:	8b 40 08             	mov    0x8(%eax),%eax
c0108464:	8d 50 01             	lea    0x1(%eax),%edx
c0108467:	8b 45 0c             	mov    0xc(%ebp),%eax
c010846a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010846d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108470:	8b 10                	mov    (%eax),%edx
c0108472:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108475:	8b 40 04             	mov    0x4(%eax),%eax
c0108478:	39 c2                	cmp    %eax,%edx
c010847a:	73 12                	jae    c010848e <sprintputch+0x33>
        *b->buf ++ = ch;
c010847c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010847f:	8b 00                	mov    (%eax),%eax
c0108481:	8d 48 01             	lea    0x1(%eax),%ecx
c0108484:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108487:	89 0a                	mov    %ecx,(%edx)
c0108489:	8b 55 08             	mov    0x8(%ebp),%edx
c010848c:	88 10                	mov    %dl,(%eax)
    }
}
c010848e:	5d                   	pop    %ebp
c010848f:	c3                   	ret    

c0108490 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0108490:	55                   	push   %ebp
c0108491:	89 e5                	mov    %esp,%ebp
c0108493:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108496:	8d 45 14             	lea    0x14(%ebp),%eax
c0108499:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010849c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010849f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01084a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01084a6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01084aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b4:	89 04 24             	mov    %eax,(%esp)
c01084b7:	e8 08 00 00 00       	call   c01084c4 <vsnprintf>
c01084bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01084bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084c2:	c9                   	leave  
c01084c3:	c3                   	ret    

c01084c4 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c01084c4:	55                   	push   %ebp
c01084c5:	89 e5                	mov    %esp,%ebp
c01084c7:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c01084ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01084cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01084d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01084d3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01084d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01084d9:	01 d0                	add    %edx,%eax
c01084db:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01084de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01084e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084e9:	74 0a                	je     c01084f5 <vsnprintf+0x31>
c01084eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01084ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01084f1:	39 c2                	cmp    %eax,%edx
c01084f3:	76 07                	jbe    c01084fc <vsnprintf+0x38>
        return -E_INVAL;
c01084f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01084fa:	eb 2a                	jmp    c0108526 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01084fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01084ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108503:	8b 45 10             	mov    0x10(%ebp),%eax
c0108506:	89 44 24 08          	mov    %eax,0x8(%esp)
c010850a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010850d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108511:	c7 04 24 5b 84 10 c0 	movl   $0xc010845b,(%esp)
c0108518:	e8 53 fb ff ff       	call   c0108070 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010851d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108520:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0108523:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108526:	c9                   	leave  
c0108527:	c3                   	ret    

c0108528 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0108528:	55                   	push   %ebp
c0108529:	89 e5                	mov    %esp,%ebp
c010852b:	57                   	push   %edi
c010852c:	56                   	push   %esi
c010852d:	53                   	push   %ebx
c010852e:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0108531:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108536:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c010853c:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0108542:	6b f0 05             	imul   $0x5,%eax,%esi
c0108545:	01 f7                	add    %esi,%edi
c0108547:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010854c:	f7 e6                	mul    %esi
c010854e:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0108551:	89 f2                	mov    %esi,%edx
c0108553:	83 c0 0b             	add    $0xb,%eax
c0108556:	83 d2 00             	adc    $0x0,%edx
c0108559:	89 c7                	mov    %eax,%edi
c010855b:	83 e7 ff             	and    $0xffffffff,%edi
c010855e:	89 f9                	mov    %edi,%ecx
c0108560:	0f b7 da             	movzwl %dx,%ebx
c0108563:	89 0d 60 fa 11 c0    	mov    %ecx,0xc011fa60
c0108569:	89 1d 64 fa 11 c0    	mov    %ebx,0xc011fa64
    unsigned long long result = (next >> 12);
c010856f:	a1 60 fa 11 c0       	mov    0xc011fa60,%eax
c0108574:	8b 15 64 fa 11 c0    	mov    0xc011fa64,%edx
c010857a:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010857e:	c1 ea 0c             	shr    $0xc,%edx
c0108581:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108584:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108587:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010858e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108591:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108594:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108597:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010859a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010859d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01085a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085a4:	74 1c                	je     c01085c2 <rand+0x9a>
c01085a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01085ae:	f7 75 dc             	divl   -0x24(%ebp)
c01085b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01085b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01085b7:	ba 00 00 00 00       	mov    $0x0,%edx
c01085bc:	f7 75 dc             	divl   -0x24(%ebp)
c01085bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01085c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01085c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01085c8:	f7 75 dc             	divl   -0x24(%ebp)
c01085cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01085ce:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01085d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01085d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01085d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01085da:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01085dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01085e0:	83 c4 24             	add    $0x24,%esp
c01085e3:	5b                   	pop    %ebx
c01085e4:	5e                   	pop    %esi
c01085e5:	5f                   	pop    %edi
c01085e6:	5d                   	pop    %ebp
c01085e7:	c3                   	ret    

c01085e8 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01085e8:	55                   	push   %ebp
c01085e9:	89 e5                	mov    %esp,%ebp
    next = seed;
c01085eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01085ee:	ba 00 00 00 00       	mov    $0x0,%edx
c01085f3:	a3 60 fa 11 c0       	mov    %eax,0xc011fa60
c01085f8:	89 15 64 fa 11 c0    	mov    %edx,0xc011fa64
}
c01085fe:	5d                   	pop    %ebp
c01085ff:	c3                   	ret    

c0108600 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0108600:	55                   	push   %ebp
c0108601:	89 e5                	mov    %esp,%ebp
c0108603:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0108606:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010860d:	eb 04                	jmp    c0108613 <strlen+0x13>
        cnt ++;
c010860f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0108613:	8b 45 08             	mov    0x8(%ebp),%eax
c0108616:	8d 50 01             	lea    0x1(%eax),%edx
c0108619:	89 55 08             	mov    %edx,0x8(%ebp)
c010861c:	0f b6 00             	movzbl (%eax),%eax
c010861f:	84 c0                	test   %al,%al
c0108621:	75 ec                	jne    c010860f <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0108623:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108626:	c9                   	leave  
c0108627:	c3                   	ret    

c0108628 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0108628:	55                   	push   %ebp
c0108629:	89 e5                	mov    %esp,%ebp
c010862b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010862e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0108635:	eb 04                	jmp    c010863b <strnlen+0x13>
        cnt ++;
c0108637:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010863b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010863e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108641:	73 10                	jae    c0108653 <strnlen+0x2b>
c0108643:	8b 45 08             	mov    0x8(%ebp),%eax
c0108646:	8d 50 01             	lea    0x1(%eax),%edx
c0108649:	89 55 08             	mov    %edx,0x8(%ebp)
c010864c:	0f b6 00             	movzbl (%eax),%eax
c010864f:	84 c0                	test   %al,%al
c0108651:	75 e4                	jne    c0108637 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108653:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108656:	c9                   	leave  
c0108657:	c3                   	ret    

c0108658 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108658:	55                   	push   %ebp
c0108659:	89 e5                	mov    %esp,%ebp
c010865b:	57                   	push   %edi
c010865c:	56                   	push   %esi
c010865d:	83 ec 20             	sub    $0x20,%esp
c0108660:	8b 45 08             	mov    0x8(%ebp),%eax
c0108663:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108666:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108669:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010866c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010866f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108672:	89 d1                	mov    %edx,%ecx
c0108674:	89 c2                	mov    %eax,%edx
c0108676:	89 ce                	mov    %ecx,%esi
c0108678:	89 d7                	mov    %edx,%edi
c010867a:	ac                   	lods   %ds:(%esi),%al
c010867b:	aa                   	stos   %al,%es:(%edi)
c010867c:	84 c0                	test   %al,%al
c010867e:	75 fa                	jne    c010867a <strcpy+0x22>
c0108680:	89 fa                	mov    %edi,%edx
c0108682:	89 f1                	mov    %esi,%ecx
c0108684:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108687:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010868a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010868d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108690:	83 c4 20             	add    $0x20,%esp
c0108693:	5e                   	pop    %esi
c0108694:	5f                   	pop    %edi
c0108695:	5d                   	pop    %ebp
c0108696:	c3                   	ret    

c0108697 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108697:	55                   	push   %ebp
c0108698:	89 e5                	mov    %esp,%ebp
c010869a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010869d:	8b 45 08             	mov    0x8(%ebp),%eax
c01086a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c01086a3:	eb 21                	jmp    c01086c6 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c01086a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086a8:	0f b6 10             	movzbl (%eax),%edx
c01086ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086ae:	88 10                	mov    %dl,(%eax)
c01086b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01086b3:	0f b6 00             	movzbl (%eax),%eax
c01086b6:	84 c0                	test   %al,%al
c01086b8:	74 04                	je     c01086be <strncpy+0x27>
            src ++;
c01086ba:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01086be:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01086c2:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01086c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01086ca:	75 d9                	jne    c01086a5 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01086cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01086cf:	c9                   	leave  
c01086d0:	c3                   	ret    

c01086d1 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01086d1:	55                   	push   %ebp
c01086d2:	89 e5                	mov    %esp,%ebp
c01086d4:	57                   	push   %edi
c01086d5:	56                   	push   %esi
c01086d6:	83 ec 20             	sub    $0x20,%esp
c01086d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01086dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01086e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086eb:	89 d1                	mov    %edx,%ecx
c01086ed:	89 c2                	mov    %eax,%edx
c01086ef:	89 ce                	mov    %ecx,%esi
c01086f1:	89 d7                	mov    %edx,%edi
c01086f3:	ac                   	lods   %ds:(%esi),%al
c01086f4:	ae                   	scas   %es:(%edi),%al
c01086f5:	75 08                	jne    c01086ff <strcmp+0x2e>
c01086f7:	84 c0                	test   %al,%al
c01086f9:	75 f8                	jne    c01086f3 <strcmp+0x22>
c01086fb:	31 c0                	xor    %eax,%eax
c01086fd:	eb 04                	jmp    c0108703 <strcmp+0x32>
c01086ff:	19 c0                	sbb    %eax,%eax
c0108701:	0c 01                	or     $0x1,%al
c0108703:	89 fa                	mov    %edi,%edx
c0108705:	89 f1                	mov    %esi,%ecx
c0108707:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010870a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010870d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108710:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108713:	83 c4 20             	add    $0x20,%esp
c0108716:	5e                   	pop    %esi
c0108717:	5f                   	pop    %edi
c0108718:	5d                   	pop    %ebp
c0108719:	c3                   	ret    

c010871a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010871a:	55                   	push   %ebp
c010871b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010871d:	eb 0c                	jmp    c010872b <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010871f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108723:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108727:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010872b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010872f:	74 1a                	je     c010874b <strncmp+0x31>
c0108731:	8b 45 08             	mov    0x8(%ebp),%eax
c0108734:	0f b6 00             	movzbl (%eax),%eax
c0108737:	84 c0                	test   %al,%al
c0108739:	74 10                	je     c010874b <strncmp+0x31>
c010873b:	8b 45 08             	mov    0x8(%ebp),%eax
c010873e:	0f b6 10             	movzbl (%eax),%edx
c0108741:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108744:	0f b6 00             	movzbl (%eax),%eax
c0108747:	38 c2                	cmp    %al,%dl
c0108749:	74 d4                	je     c010871f <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010874b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010874f:	74 18                	je     c0108769 <strncmp+0x4f>
c0108751:	8b 45 08             	mov    0x8(%ebp),%eax
c0108754:	0f b6 00             	movzbl (%eax),%eax
c0108757:	0f b6 d0             	movzbl %al,%edx
c010875a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010875d:	0f b6 00             	movzbl (%eax),%eax
c0108760:	0f b6 c0             	movzbl %al,%eax
c0108763:	29 c2                	sub    %eax,%edx
c0108765:	89 d0                	mov    %edx,%eax
c0108767:	eb 05                	jmp    c010876e <strncmp+0x54>
c0108769:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010876e:	5d                   	pop    %ebp
c010876f:	c3                   	ret    

c0108770 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108770:	55                   	push   %ebp
c0108771:	89 e5                	mov    %esp,%ebp
c0108773:	83 ec 04             	sub    $0x4,%esp
c0108776:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108779:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010877c:	eb 14                	jmp    c0108792 <strchr+0x22>
        if (*s == c) {
c010877e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108781:	0f b6 00             	movzbl (%eax),%eax
c0108784:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108787:	75 05                	jne    c010878e <strchr+0x1e>
            return (char *)s;
c0108789:	8b 45 08             	mov    0x8(%ebp),%eax
c010878c:	eb 13                	jmp    c01087a1 <strchr+0x31>
        }
        s ++;
c010878e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108792:	8b 45 08             	mov    0x8(%ebp),%eax
c0108795:	0f b6 00             	movzbl (%eax),%eax
c0108798:	84 c0                	test   %al,%al
c010879a:	75 e2                	jne    c010877e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010879c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01087a1:	c9                   	leave  
c01087a2:	c3                   	ret    

c01087a3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c01087a3:	55                   	push   %ebp
c01087a4:	89 e5                	mov    %esp,%ebp
c01087a6:	83 ec 04             	sub    $0x4,%esp
c01087a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ac:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c01087af:	eb 11                	jmp    c01087c2 <strfind+0x1f>
        if (*s == c) {
c01087b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01087b4:	0f b6 00             	movzbl (%eax),%eax
c01087b7:	3a 45 fc             	cmp    -0x4(%ebp),%al
c01087ba:	75 02                	jne    c01087be <strfind+0x1b>
            break;
c01087bc:	eb 0e                	jmp    c01087cc <strfind+0x29>
        }
        s ++;
c01087be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01087c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01087c5:	0f b6 00             	movzbl (%eax),%eax
c01087c8:	84 c0                	test   %al,%al
c01087ca:	75 e5                	jne    c01087b1 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01087cc:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01087cf:	c9                   	leave  
c01087d0:	c3                   	ret    

c01087d1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01087d1:	55                   	push   %ebp
c01087d2:	89 e5                	mov    %esp,%ebp
c01087d4:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01087d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01087de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01087e5:	eb 04                	jmp    c01087eb <strtol+0x1a>
        s ++;
c01087e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01087eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01087ee:	0f b6 00             	movzbl (%eax),%eax
c01087f1:	3c 20                	cmp    $0x20,%al
c01087f3:	74 f2                	je     c01087e7 <strtol+0x16>
c01087f5:	8b 45 08             	mov    0x8(%ebp),%eax
c01087f8:	0f b6 00             	movzbl (%eax),%eax
c01087fb:	3c 09                	cmp    $0x9,%al
c01087fd:	74 e8                	je     c01087e7 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01087ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0108802:	0f b6 00             	movzbl (%eax),%eax
c0108805:	3c 2b                	cmp    $0x2b,%al
c0108807:	75 06                	jne    c010880f <strtol+0x3e>
        s ++;
c0108809:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010880d:	eb 15                	jmp    c0108824 <strtol+0x53>
    }
    else if (*s == '-') {
c010880f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108812:	0f b6 00             	movzbl (%eax),%eax
c0108815:	3c 2d                	cmp    $0x2d,%al
c0108817:	75 0b                	jne    c0108824 <strtol+0x53>
        s ++, neg = 1;
c0108819:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010881d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108824:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108828:	74 06                	je     c0108830 <strtol+0x5f>
c010882a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010882e:	75 24                	jne    c0108854 <strtol+0x83>
c0108830:	8b 45 08             	mov    0x8(%ebp),%eax
c0108833:	0f b6 00             	movzbl (%eax),%eax
c0108836:	3c 30                	cmp    $0x30,%al
c0108838:	75 1a                	jne    c0108854 <strtol+0x83>
c010883a:	8b 45 08             	mov    0x8(%ebp),%eax
c010883d:	83 c0 01             	add    $0x1,%eax
c0108840:	0f b6 00             	movzbl (%eax),%eax
c0108843:	3c 78                	cmp    $0x78,%al
c0108845:	75 0d                	jne    c0108854 <strtol+0x83>
        s += 2, base = 16;
c0108847:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010884b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108852:	eb 2a                	jmp    c010887e <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108854:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108858:	75 17                	jne    c0108871 <strtol+0xa0>
c010885a:	8b 45 08             	mov    0x8(%ebp),%eax
c010885d:	0f b6 00             	movzbl (%eax),%eax
c0108860:	3c 30                	cmp    $0x30,%al
c0108862:	75 0d                	jne    c0108871 <strtol+0xa0>
        s ++, base = 8;
c0108864:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108868:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010886f:	eb 0d                	jmp    c010887e <strtol+0xad>
    }
    else if (base == 0) {
c0108871:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108875:	75 07                	jne    c010887e <strtol+0xad>
        base = 10;
c0108877:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010887e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108881:	0f b6 00             	movzbl (%eax),%eax
c0108884:	3c 2f                	cmp    $0x2f,%al
c0108886:	7e 1b                	jle    c01088a3 <strtol+0xd2>
c0108888:	8b 45 08             	mov    0x8(%ebp),%eax
c010888b:	0f b6 00             	movzbl (%eax),%eax
c010888e:	3c 39                	cmp    $0x39,%al
c0108890:	7f 11                	jg     c01088a3 <strtol+0xd2>
            dig = *s - '0';
c0108892:	8b 45 08             	mov    0x8(%ebp),%eax
c0108895:	0f b6 00             	movzbl (%eax),%eax
c0108898:	0f be c0             	movsbl %al,%eax
c010889b:	83 e8 30             	sub    $0x30,%eax
c010889e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088a1:	eb 48                	jmp    c01088eb <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c01088a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01088a6:	0f b6 00             	movzbl (%eax),%eax
c01088a9:	3c 60                	cmp    $0x60,%al
c01088ab:	7e 1b                	jle    c01088c8 <strtol+0xf7>
c01088ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01088b0:	0f b6 00             	movzbl (%eax),%eax
c01088b3:	3c 7a                	cmp    $0x7a,%al
c01088b5:	7f 11                	jg     c01088c8 <strtol+0xf7>
            dig = *s - 'a' + 10;
c01088b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01088ba:	0f b6 00             	movzbl (%eax),%eax
c01088bd:	0f be c0             	movsbl %al,%eax
c01088c0:	83 e8 57             	sub    $0x57,%eax
c01088c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01088c6:	eb 23                	jmp    c01088eb <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01088c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01088cb:	0f b6 00             	movzbl (%eax),%eax
c01088ce:	3c 40                	cmp    $0x40,%al
c01088d0:	7e 3d                	jle    c010890f <strtol+0x13e>
c01088d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01088d5:	0f b6 00             	movzbl (%eax),%eax
c01088d8:	3c 5a                	cmp    $0x5a,%al
c01088da:	7f 33                	jg     c010890f <strtol+0x13e>
            dig = *s - 'A' + 10;
c01088dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01088df:	0f b6 00             	movzbl (%eax),%eax
c01088e2:	0f be c0             	movsbl %al,%eax
c01088e5:	83 e8 37             	sub    $0x37,%eax
c01088e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01088eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ee:	3b 45 10             	cmp    0x10(%ebp),%eax
c01088f1:	7c 02                	jl     c01088f5 <strtol+0x124>
            break;
c01088f3:	eb 1a                	jmp    c010890f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01088f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01088f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01088fc:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108900:	89 c2                	mov    %eax,%edx
c0108902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108905:	01 d0                	add    %edx,%eax
c0108907:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010890a:	e9 6f ff ff ff       	jmp    c010887e <strtol+0xad>

    if (endptr) {
c010890f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108913:	74 08                	je     c010891d <strtol+0x14c>
        *endptr = (char *) s;
c0108915:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108918:	8b 55 08             	mov    0x8(%ebp),%edx
c010891b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010891d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108921:	74 07                	je     c010892a <strtol+0x159>
c0108923:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108926:	f7 d8                	neg    %eax
c0108928:	eb 03                	jmp    c010892d <strtol+0x15c>
c010892a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010892d:	c9                   	leave  
c010892e:	c3                   	ret    

c010892f <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010892f:	55                   	push   %ebp
c0108930:	89 e5                	mov    %esp,%ebp
c0108932:	57                   	push   %edi
c0108933:	83 ec 24             	sub    $0x24,%esp
c0108936:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108939:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010893c:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0108940:	8b 55 08             	mov    0x8(%ebp),%edx
c0108943:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0108946:	88 45 f7             	mov    %al,-0x9(%ebp)
c0108949:	8b 45 10             	mov    0x10(%ebp),%eax
c010894c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010894f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108952:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0108956:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0108959:	89 d7                	mov    %edx,%edi
c010895b:	f3 aa                	rep stos %al,%es:(%edi)
c010895d:	89 fa                	mov    %edi,%edx
c010895f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0108962:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108965:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108968:	83 c4 24             	add    $0x24,%esp
c010896b:	5f                   	pop    %edi
c010896c:	5d                   	pop    %ebp
c010896d:	c3                   	ret    

c010896e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010896e:	55                   	push   %ebp
c010896f:	89 e5                	mov    %esp,%ebp
c0108971:	57                   	push   %edi
c0108972:	56                   	push   %esi
c0108973:	53                   	push   %ebx
c0108974:	83 ec 30             	sub    $0x30,%esp
c0108977:	8b 45 08             	mov    0x8(%ebp),%eax
c010897a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010897d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108980:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108983:	8b 45 10             	mov    0x10(%ebp),%eax
c0108986:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108989:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010898c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010898f:	73 42                	jae    c01089d3 <memmove+0x65>
c0108991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108994:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108997:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010899a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010899d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01089a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01089a6:	c1 e8 02             	shr    $0x2,%eax
c01089a9:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01089ab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01089ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01089b1:	89 d7                	mov    %edx,%edi
c01089b3:	89 c6                	mov    %eax,%esi
c01089b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01089b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01089ba:	83 e1 03             	and    $0x3,%ecx
c01089bd:	74 02                	je     c01089c1 <memmove+0x53>
c01089bf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01089c1:	89 f0                	mov    %esi,%eax
c01089c3:	89 fa                	mov    %edi,%edx
c01089c5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c01089c8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01089cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c01089ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01089d1:	eb 36                	jmp    c0108a09 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01089d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089d6:	8d 50 ff             	lea    -0x1(%eax),%edx
c01089d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01089dc:	01 c2                	add    %eax,%edx
c01089de:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089e1:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01089e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01089e7:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c01089ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089ed:	89 c1                	mov    %eax,%ecx
c01089ef:	89 d8                	mov    %ebx,%eax
c01089f1:	89 d6                	mov    %edx,%esi
c01089f3:	89 c7                	mov    %eax,%edi
c01089f5:	fd                   	std    
c01089f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01089f8:	fc                   	cld    
c01089f9:	89 f8                	mov    %edi,%eax
c01089fb:	89 f2                	mov    %esi,%edx
c01089fd:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108a00:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0108a03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108a06:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108a09:	83 c4 30             	add    $0x30,%esp
c0108a0c:	5b                   	pop    %ebx
c0108a0d:	5e                   	pop    %esi
c0108a0e:	5f                   	pop    %edi
c0108a0f:	5d                   	pop    %ebp
c0108a10:	c3                   	ret    

c0108a11 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108a11:	55                   	push   %ebp
c0108a12:	89 e5                	mov    %esp,%ebp
c0108a14:	57                   	push   %edi
c0108a15:	56                   	push   %esi
c0108a16:	83 ec 20             	sub    $0x20,%esp
c0108a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108a1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a25:	8b 45 10             	mov    0x10(%ebp),%eax
c0108a28:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a2e:	c1 e8 02             	shr    $0x2,%eax
c0108a31:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108a33:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a39:	89 d7                	mov    %edx,%edi
c0108a3b:	89 c6                	mov    %eax,%esi
c0108a3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108a3f:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0108a42:	83 e1 03             	and    $0x3,%ecx
c0108a45:	74 02                	je     c0108a49 <memcpy+0x38>
c0108a47:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108a49:	89 f0                	mov    %esi,%eax
c0108a4b:	89 fa                	mov    %edi,%edx
c0108a4d:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0108a50:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108a56:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108a59:	83 c4 20             	add    $0x20,%esp
c0108a5c:	5e                   	pop    %esi
c0108a5d:	5f                   	pop    %edi
c0108a5e:	5d                   	pop    %ebp
c0108a5f:	c3                   	ret    

c0108a60 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108a60:	55                   	push   %ebp
c0108a61:	89 e5                	mov    %esp,%ebp
c0108a63:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a69:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108a6c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108a72:	eb 30                	jmp    c0108aa4 <memcmp+0x44>
        if (*s1 != *s2) {
c0108a74:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a77:	0f b6 10             	movzbl (%eax),%edx
c0108a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a7d:	0f b6 00             	movzbl (%eax),%eax
c0108a80:	38 c2                	cmp    %al,%dl
c0108a82:	74 18                	je     c0108a9c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a87:	0f b6 00             	movzbl (%eax),%eax
c0108a8a:	0f b6 d0             	movzbl %al,%edx
c0108a8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a90:	0f b6 00             	movzbl (%eax),%eax
c0108a93:	0f b6 c0             	movzbl %al,%eax
c0108a96:	29 c2                	sub    %eax,%edx
c0108a98:	89 d0                	mov    %edx,%eax
c0108a9a:	eb 1a                	jmp    c0108ab6 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0108a9c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108aa0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108aa4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108aa7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0108aaa:	89 55 10             	mov    %edx,0x10(%ebp)
c0108aad:	85 c0                	test   %eax,%eax
c0108aaf:	75 c3                	jne    c0108a74 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108ab1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108ab6:	c9                   	leave  
c0108ab7:	c3                   	ret    
