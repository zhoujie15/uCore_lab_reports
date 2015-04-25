
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
//void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 c7 5c 00 00       	call   105d1d <memset>

    cons_init();                // init the console
  100056:	e8 71 15 00 00       	call   1015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 c0 5e 10 00 	movl   $0x105ec0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 dc 5e 10 00 	movl   $0x105edc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 ab 41 00 00       	call   10422f <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 ac 16 00 00       	call   101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 24 18 00 00       	call   1018b2 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 ef 0c 00 00       	call   100d82 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 0b 16 00 00       	call   1016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 f8 0b 00 00       	call   100cb4 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 e1 5e 10 00 	movl   $0x105ee1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 ef 5e 10 00 	movl   $0x105eef,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 fd 5e 10 00 	movl   $0x105efd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 0b 5f 10 00 	movl   $0x105f0b,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 19 5f 10 00 	movl   $0x105f19,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 28 5f 10 00 	movl   $0x105f28,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 48 5f 10 00 	movl   $0x105f48,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 67 5f 10 00 	movl   $0x105f67,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 fe 12 00 00       	call   1015f8 <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 ff 51 00 00       	call   105536 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 85 12 00 00       	call   1015f8 <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 65 12 00 00       	call   101634 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 6c 5f 10 00    	movl   $0x105f6c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 6c 5f 10 00 	movl   $0x105f6c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 b8 71 10 00 	movl   $0x1071b8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 3c 1d 11 00 	movl   $0x111d3c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 3d 1d 11 00 	movl   $0x111d3d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 81 47 11 00 	movl   $0x114781,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 a5 54 00 00       	call   105b91 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 76 5f 10 00 	movl   $0x105f76,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 8f 5f 10 00 	movl   $0x105f8f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 a6 5e 10 	movl   $0x105ea6,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 a7 5f 10 00 	movl   $0x105fa7,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 bf 5f 10 00 	movl   $0x105fbf,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 d7 5f 10 00 	movl   $0x105fd7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 f0 5f 10 00 	movl   $0x105ff0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 1a 60 10 00 	movl   $0x10601a,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009da:	e9 88 00 00 00       	jmp    100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ed:	c7 04 24 48 60 10 00 	movl   $0x106048,(%esp)
  1009f4:	e8 43 f9 ff ff       	call   10033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	83 c0 08             	add    $0x8,%eax
  1009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a09:	eb 25                	jmp    100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
  100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a18:	01 d0                	add    %edx,%eax
  100a1a:	8b 00                	mov    (%eax),%eax
  100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a20:	c7 04 24 64 60 10 00 	movl   $0x106064,(%esp)
  100a27:	e8 10 f9 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a34:	7e d5                	jle    100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a36:	c7 04 24 6c 60 10 00 	movl   $0x10606c,(%esp)
  100a3d:	e8 fa f8 ff ff       	call   10033c <cprintf>
        print_debuginfo(eip - 1);
  100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a45:	83 e8 01             	sub    $0x1,%eax
  100a48:	89 04 24             	mov    %eax,(%esp)
  100a4b:	e8 b6 fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a53:	83 c0 04             	add    $0x4,%eax
  100a56:	8b 00                	mov    (%eax),%eax
  100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5e:	8b 00                	mov    (%eax),%eax
  100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a6b:	74 0a                	je     100a77 <print_stackframe+0xbd>
  100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a71:	0f 8e 68 ff ff ff    	jle    1009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a86:	eb 0c                	jmp    100a94 <parse+0x1b>
            *buf ++ = '\0';
  100a88:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8b:	8d 50 01             	lea    0x1(%eax),%edx
  100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a94:	8b 45 08             	mov    0x8(%ebp),%eax
  100a97:	0f b6 00             	movzbl (%eax),%eax
  100a9a:	84 c0                	test   %al,%al
  100a9c:	74 1d                	je     100abb <parse+0x42>
  100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa1:	0f b6 00             	movzbl (%eax),%eax
  100aa4:	0f be c0             	movsbl %al,%eax
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 f0 60 10 00 	movl   $0x1060f0,(%esp)
  100ab2:	e8 a7 50 00 00       	call   105b5e <strchr>
  100ab7:	85 c0                	test   %eax,%eax
  100ab9:	75 cd                	jne    100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100abb:	8b 45 08             	mov    0x8(%ebp),%eax
  100abe:	0f b6 00             	movzbl (%eax),%eax
  100ac1:	84 c0                	test   %al,%al
  100ac3:	75 02                	jne    100ac7 <parse+0x4e>
            break;
  100ac5:	eb 67                	jmp    100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100acb:	75 14                	jne    100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ad4:	00 
  100ad5:	c7 04 24 f5 60 10 00 	movl   $0x1060f5,(%esp)
  100adc:	e8 5b f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae4:	8d 50 01             	lea    0x1(%eax),%edx
  100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100af4:	01 c2                	add    %eax,%edx
  100af6:	8b 45 08             	mov    0x8(%ebp),%eax
  100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100afb:	eb 04                	jmp    100b01 <parse+0x88>
            buf ++;
  100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b01:	8b 45 08             	mov    0x8(%ebp),%eax
  100b04:	0f b6 00             	movzbl (%eax),%eax
  100b07:	84 c0                	test   %al,%al
  100b09:	74 1d                	je     100b28 <parse+0xaf>
  100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0e:	0f b6 00             	movzbl (%eax),%eax
  100b11:	0f be c0             	movsbl %al,%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 f0 60 10 00 	movl   $0x1060f0,(%esp)
  100b1f:	e8 3a 50 00 00       	call   105b5e <strchr>
  100b24:	85 c0                	test   %eax,%eax
  100b26:	74 d5                	je     100afd <parse+0x84>
            buf ++;
        }
    }
  100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	e9 66 ff ff ff       	jmp    100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b31:	c9                   	leave  
  100b32:	c3                   	ret    

00100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b33:	55                   	push   %ebp
  100b34:	89 e5                	mov    %esp,%ebp
  100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 2e ff ff ff       	call   100a79 <parse>
  100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b52:	75 0a                	jne    100b5e <runcmd+0x2b>
        return 0;
  100b54:	b8 00 00 00 00       	mov    $0x0,%eax
  100b59:	e9 85 00 00 00       	jmp    100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b65:	eb 5c                	jmp    100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 20 70 11 00       	add    $0x117020,%eax
  100b7b:	8b 00                	mov    (%eax),%eax
  100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b81:	89 04 24             	mov    %eax,(%esp)
  100b84:	e8 36 4f 00 00       	call   105abf <strcmp>
  100b89:	85 c0                	test   %eax,%eax
  100b8b:	75 32                	jne    100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b90:	89 d0                	mov    %edx,%eax
  100b92:	01 c0                	add    %eax,%eax
  100b94:	01 d0                	add    %edx,%eax
  100b96:	c1 e0 02             	shl    $0x2,%eax
  100b99:	05 20 70 11 00       	add    $0x117020,%eax
  100b9e:	8b 40 08             	mov    0x8(%eax),%eax
  100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb1:	83 c2 04             	add    $0x4,%edx
  100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bb8:	89 0c 24             	mov    %ecx,(%esp)
  100bbb:	ff d0                	call   *%eax
  100bbd:	eb 24                	jmp    100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc6:	83 f8 02             	cmp    $0x2,%eax
  100bc9:	76 9c                	jbe    100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd2:	c7 04 24 13 61 10 00 	movl   $0x106113,(%esp)
  100bd9:	e8 5e f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be3:	c9                   	leave  
  100be4:	c3                   	ret    

00100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100be5:	55                   	push   %ebp
  100be6:	89 e5                	mov    %esp,%ebp
  100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100beb:	c7 04 24 2c 61 10 00 	movl   $0x10612c,(%esp)
  100bf2:	e8 45 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bf7:	c7 04 24 54 61 10 00 	movl   $0x106154,(%esp)
  100bfe:	e8 39 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c07:	74 0b                	je     100c14 <kmonitor+0x2f>
        print_trapframe(tf);
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 04 24             	mov    %eax,(%esp)
  100c0f:	e8 d7 0d 00 00       	call   1019eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c14:	c7 04 24 79 61 10 00 	movl   $0x106179,(%esp)
  100c1b:	e8 13 f6 ff ff       	call   100233 <readline>
  100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c27:	74 18                	je     100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c29:	8b 45 08             	mov    0x8(%ebp),%eax
  100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c33:	89 04 24             	mov    %eax,(%esp)
  100c36:	e8 f8 fe ff ff       	call   100b33 <runcmd>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	79 02                	jns    100c41 <kmonitor+0x5c>
                break;
  100c3f:	eb 02                	jmp    100c43 <kmonitor+0x5e>
            }
        }
    }
  100c41:	eb d1                	jmp    100c14 <kmonitor+0x2f>
}
  100c43:	c9                   	leave  
  100c44:	c3                   	ret    

00100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c45:	55                   	push   %ebp
  100c46:	89 e5                	mov    %esp,%ebp
  100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c52:	eb 3f                	jmp    100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c57:	89 d0                	mov    %edx,%eax
  100c59:	01 c0                	add    %eax,%eax
  100c5b:	01 d0                	add    %edx,%eax
  100c5d:	c1 e0 02             	shl    $0x2,%eax
  100c60:	05 20 70 11 00       	add    $0x117020,%eax
  100c65:	8b 48 04             	mov    0x4(%eax),%ecx
  100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6b:	89 d0                	mov    %edx,%eax
  100c6d:	01 c0                	add    %eax,%eax
  100c6f:	01 d0                	add    %edx,%eax
  100c71:	c1 e0 02             	shl    $0x2,%eax
  100c74:	05 20 70 11 00       	add    $0x117020,%eax
  100c79:	8b 00                	mov    (%eax),%eax
  100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c83:	c7 04 24 7d 61 10 00 	movl   $0x10617d,(%esp)
  100c8a:	e8 ad f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c96:	83 f8 02             	cmp    $0x2,%eax
  100c99:	76 b9                	jbe    100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca0:	c9                   	leave  
  100ca1:	c3                   	ret    

00100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca2:	55                   	push   %ebp
  100ca3:	89 e5                	mov    %esp,%ebp
  100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100ca8:	e8 c3 fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb2:	c9                   	leave  
  100cb3:	c3                   	ret    

00100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cb4:	55                   	push   %ebp
  100cb5:	89 e5                	mov    %esp,%ebp
  100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cba:	e8 fb fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc4:	c9                   	leave  
  100cc5:	c3                   	ret    

00100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cc6:	55                   	push   %ebp
  100cc7:	89 e5                	mov    %esp,%ebp
  100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ccc:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd1:	85 c0                	test   %eax,%eax
  100cd3:	74 02                	je     100cd7 <__panic+0x11>
        goto panic_dead;
  100cd5:	eb 48                	jmp    100d1f <__panic+0x59>
    }
    is_panic = 1;
  100cd7:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
  100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cee:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	c7 04 24 86 61 10 00 	movl   $0x106186,(%esp)
  100cfc:	e8 3b f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d08:	8b 45 10             	mov    0x10(%ebp),%eax
  100d0b:	89 04 24             	mov    %eax,(%esp)
  100d0e:	e8 f6 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d13:	c7 04 24 a2 61 10 00 	movl   $0x1061a2,(%esp)
  100d1a:	e8 1d f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d1f:	e8 85 09 00 00       	call   1016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d2b:	e8 b5 fe ff ff       	call   100be5 <kmonitor>
    }
  100d30:	eb f2                	jmp    100d24 <__panic+0x5e>

00100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d32:	55                   	push   %ebp
  100d33:	89 e5                	mov    %esp,%ebp
  100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d38:	8d 45 14             	lea    0x14(%ebp),%eax
  100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d45:	8b 45 08             	mov    0x8(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	c7 04 24 a4 61 10 00 	movl   $0x1061a4,(%esp)
  100d53:	e8 e4 f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d62:	89 04 24             	mov    %eax,(%esp)
  100d65:	e8 9f f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d6a:	c7 04 24 a2 61 10 00 	movl   $0x1061a2,(%esp)
  100d71:	e8 c6 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d76:	c9                   	leave  
  100d77:	c3                   	ret    

00100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d78:	55                   	push   %ebp
  100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d7b:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d80:	5d                   	pop    %ebp
  100d81:	c3                   	ret    

00100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d82:	55                   	push   %ebp
  100d83:	89 e5                	mov    %esp,%ebp
  100d85:	83 ec 28             	sub    $0x28,%esp
  100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
  100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc1:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dcb:	c7 04 24 c2 61 10 00 	movl   $0x1061c2,(%esp)
  100dd2:	e8 65 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dde:	e8 24 09 00 00       	call   101707 <pic_enable>
}
  100de3:	c9                   	leave  
  100de4:	c3                   	ret    

00100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100de5:	55                   	push   %ebp
  100de6:	89 e5                	mov    %esp,%ebp
  100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100deb:	9c                   	pushf  
  100dec:	58                   	pop    %eax
  100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100df3:	25 00 02 00 00       	and    $0x200,%eax
  100df8:	85 c0                	test   %eax,%eax
  100dfa:	74 0c                	je     100e08 <__intr_save+0x23>
        intr_disable();
  100dfc:	e8 a8 08 00 00       	call   1016a9 <intr_disable>
        return 1;
  100e01:	b8 01 00 00 00       	mov    $0x1,%eax
  100e06:	eb 05                	jmp    100e0d <__intr_save+0x28>
    }
    return 0;
  100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e0d:	c9                   	leave  
  100e0e:	c3                   	ret    

00100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e0f:	55                   	push   %ebp
  100e10:	89 e5                	mov    %esp,%ebp
  100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e19:	74 05                	je     100e20 <__intr_restore+0x11>
        intr_enable();
  100e1b:	e8 83 08 00 00       	call   1016a3 <intr_enable>
    }
}
  100e20:	c9                   	leave  
  100e21:	c3                   	ret    

00100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e22:	55                   	push   %ebp
  100e23:	89 e5                	mov    %esp,%ebp
  100e25:	83 ec 10             	sub    $0x10,%esp
  100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e62:	89 c2                	mov    %eax,%edx
  100e64:	ec                   	in     (%dx),%al
  100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e68:	c9                   	leave  
  100e69:	c3                   	ret    

00100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e6a:	55                   	push   %ebp
  100e6b:	89 e5                	mov    %esp,%ebp
  100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7a:	0f b7 00             	movzwl (%eax),%eax
  100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8c:	0f b7 00             	movzwl (%eax),%eax
  100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e93:	74 12                	je     100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e9c:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100ea3:	b4 03 
  100ea5:	eb 13                	jmp    100eba <cga_init+0x50>
    } else {
        *cp = was;
  100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb1:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	0f b7 c0             	movzwl %ax,%eax
  100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ed5:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100edc:	83 c0 01             	add    $0x1,%eax
  100edf:	0f b7 c0             	movzwl %ax,%eax
  100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eea:	89 c2                	mov    %eax,%edx
  100eec:	ec                   	in     (%dx),%al
  100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ef4:	0f b6 c0             	movzbl %al,%eax
  100ef7:	c1 e0 08             	shl    $0x8,%eax
  100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	0f b7 c0             	movzwl %ax,%eax
  100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f18:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f1f:	83 c0 01             	add    $0x1,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f2d:	89 c2                	mov    %eax,%edx
  100f2f:	ec                   	in     (%dx),%al
  100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f37:	0f b6 c0             	movzbl %al,%eax
  100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f40:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f48:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f4e:	c9                   	leave  
  100f4f:	c3                   	ret    

00100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f50:	55                   	push   %ebp
  100f51:	89 e5                	mov    %esp,%ebp
  100f53:	83 ec 48             	sub    $0x48,%esp
  100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f68:	ee                   	out    %al,(%dx)
  100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f7b:	ee                   	out    %al,(%dx)
  100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f8e:	ee                   	out    %al,(%dx)
  100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa1:	ee                   	out    %al,(%dx)
  100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb4:	ee                   	out    %al,(%dx)
  100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fc7:	ee                   	out    %al,(%dx)
  100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fda:	ee                   	out    %al,(%dx)
  100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fe5:	89 c2                	mov    %eax,%edx
  100fe7:	ec                   	in     (%dx),%al
  100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fef:	3c ff                	cmp    $0xff,%al
  100ff1:	0f 95 c0             	setne  %al
  100ff4:	0f b6 c0             	movzbl %al,%eax
  100ff7:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  101006:	89 c2                	mov    %eax,%edx
  101008:	ec                   	in     (%dx),%al
  101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
  10100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  101016:	89 c2                	mov    %eax,%edx
  101018:	ec                   	in     (%dx),%al
  101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10101c:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101021:	85 c0                	test   %eax,%eax
  101023:	74 0c                	je     101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10102c:	e8 d6 06 00 00       	call   101707 <pic_enable>
    }
}
  101031:	c9                   	leave  
  101032:	c3                   	ret    

00101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101033:	55                   	push   %ebp
  101034:	89 e5                	mov    %esp,%ebp
  101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101040:	eb 09                	jmp    10104b <lpt_putc_sub+0x18>
        delay();
  101042:	e8 db fd ff ff       	call   100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101055:	89 c2                	mov    %eax,%edx
  101057:	ec                   	in     (%dx),%al
  101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10105f:	84 c0                	test   %al,%al
  101061:	78 09                	js     10106c <lpt_putc_sub+0x39>
  101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10106a:	7e d6                	jle    101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10106c:	8b 45 08             	mov    0x8(%ebp),%eax
  10106f:	0f b6 c0             	movzbl %al,%eax
  101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101083:	ee                   	out    %al,(%dx)
  101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101096:	ee                   	out    %al,(%dx)
  101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010aa:	c9                   	leave  
  1010ab:	c3                   	ret    

001010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010ac:	55                   	push   %ebp
  1010ad:	89 e5                	mov    %esp,%ebp
  1010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010b6:	74 0d                	je     1010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bb:	89 04 24             	mov    %eax,(%esp)
  1010be:	e8 70 ff ff ff       	call   101033 <lpt_putc_sub>
  1010c3:	eb 24                	jmp    1010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010cc:	e8 62 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010d8:	e8 56 ff ff ff       	call   101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010e4:	e8 4a ff ff ff       	call   101033 <lpt_putc_sub>
    }
}
  1010e9:	c9                   	leave  
  1010ea:	c3                   	ret    

001010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010eb:	55                   	push   %ebp
  1010ec:	89 e5                	mov    %esp,%ebp
  1010ee:	53                   	push   %ebx
  1010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f5:	b0 00                	mov    $0x0,%al
  1010f7:	85 c0                	test   %eax,%eax
  1010f9:	75 07                	jne    101102 <cga_putc+0x17>
        c |= 0x0700;
  1010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101102:	8b 45 08             	mov    0x8(%ebp),%eax
  101105:	0f b6 c0             	movzbl %al,%eax
  101108:	83 f8 0a             	cmp    $0xa,%eax
  10110b:	74 4c                	je     101159 <cga_putc+0x6e>
  10110d:	83 f8 0d             	cmp    $0xd,%eax
  101110:	74 57                	je     101169 <cga_putc+0x7e>
  101112:	83 f8 08             	cmp    $0x8,%eax
  101115:	0f 85 88 00 00 00    	jne    1011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  10111b:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101122:	66 85 c0             	test   %ax,%ax
  101125:	74 30                	je     101157 <cga_putc+0x6c>
            crt_pos --;
  101127:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10112e:	83 e8 01             	sub    $0x1,%eax
  101131:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101137:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10113c:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101143:	0f b7 d2             	movzwl %dx,%edx
  101146:	01 d2                	add    %edx,%edx
  101148:	01 c2                	add    %eax,%edx
  10114a:	8b 45 08             	mov    0x8(%ebp),%eax
  10114d:	b0 00                	mov    $0x0,%al
  10114f:	83 c8 20             	or     $0x20,%eax
  101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101155:	eb 72                	jmp    1011c9 <cga_putc+0xde>
  101157:	eb 70                	jmp    1011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101159:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101160:	83 c0 50             	add    $0x50,%eax
  101163:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101170:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  101177:	0f b7 c1             	movzwl %cx,%eax
  10117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101180:	c1 e8 10             	shr    $0x10,%eax
  101183:	89 c2                	mov    %eax,%edx
  101185:	66 c1 ea 06          	shr    $0x6,%dx
  101189:	89 d0                	mov    %edx,%eax
  10118b:	c1 e0 02             	shl    $0x2,%eax
  10118e:	01 d0                	add    %edx,%eax
  101190:	c1 e0 04             	shl    $0x4,%eax
  101193:	29 c1                	sub    %eax,%ecx
  101195:	89 ca                	mov    %ecx,%edx
  101197:	89 d8                	mov    %ebx,%eax
  101199:	29 d0                	sub    %edx,%eax
  10119b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a1:	eb 26                	jmp    1011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011a9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011ba:	0f b7 c0             	movzwl %ax,%eax
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	66 89 02             	mov    %ax,(%edx)
        break;
  1011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011c9:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011d4:	76 5b                	jbe    101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011d6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e1:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011ed:	00 
  1011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f2:	89 04 24             	mov    %eax,(%esp)
  1011f5:	e8 62 4b 00 00       	call   105d5c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101201:	eb 15                	jmp    101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101203:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10120b:	01 d2                	add    %edx,%edx
  10120d:	01 d0                	add    %edx,%eax
  10120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10121f:	7e e2                	jle    101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101221:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101228:	83 e8 50             	sub    $0x50,%eax
  10122b:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101231:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  10123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  10124c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101253:	66 c1 e8 08          	shr    $0x8,%ax
  101257:	0f b6 c0             	movzbl %al,%eax
  10125a:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101261:	83 c2 01             	add    $0x1,%edx
  101264:	0f b7 d2             	movzwl %dx,%edx
  101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10126b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101277:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10127e:	0f b7 c0             	movzwl %ax,%eax
  101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101292:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101299:	0f b6 c0             	movzbl %al,%eax
  10129c:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012a3:	83 c2 01             	add    $0x1,%edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	83 c4 34             	add    $0x34,%esp
  1012bc:	5b                   	pop    %ebx
  1012bd:	5d                   	pop    %ebp
  1012be:	c3                   	ret    

001012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012bf:	55                   	push   %ebp
  1012c0:	89 e5                	mov    %esp,%ebp
  1012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cc:	eb 09                	jmp    1012d7 <serial_putc_sub+0x18>
        delay();
  1012ce:	e8 4f fb ff ff       	call   100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3f>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d0                	jle    1012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	c9                   	leave  
  101317:	c3                   	ret    

00101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101318:	55                   	push   %ebp
  101319:	89 e5                	mov    %esp,%ebp
  10131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101322:	74 0d                	je     101331 <serial_putc+0x19>
        serial_putc_sub(c);
  101324:	8b 45 08             	mov    0x8(%ebp),%eax
  101327:	89 04 24             	mov    %eax,(%esp)
  10132a:	e8 90 ff ff ff       	call   1012bf <serial_putc_sub>
  10132f:	eb 24                	jmp    101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101338:	e8 82 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub(' ');
  10133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101344:	e8 76 ff ff ff       	call   1012bf <serial_putc_sub>
        serial_putc_sub('\b');
  101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101350:	e8 6a ff ff ff       	call   1012bf <serial_putc_sub>
    }
}
  101355:	c9                   	leave  
  101356:	c3                   	ret    

00101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101357:	55                   	push   %ebp
  101358:	89 e5                	mov    %esp,%ebp
  10135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135d:	eb 33                	jmp    101392 <cons_intr+0x3b>
        if (c != 0) {
  10135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101363:	74 2d                	je     101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101365:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10136a:	8d 50 01             	lea    0x1(%eax),%edx
  10136d:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101376:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101381:	3d 00 02 00 00       	cmp    $0x200,%eax
  101386:	75 0a                	jne    101392 <cons_intr+0x3b>
                cons.wpos = 0;
  101388:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  10138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101392:	8b 45 08             	mov    0x8(%ebp),%eax
  101395:	ff d0                	call   *%eax
  101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10139e:	75 bf                	jne    10135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a0:	c9                   	leave  
  1013a1:	c3                   	ret    

001013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a2:	55                   	push   %ebp
  1013a3:	89 e5                	mov    %esp,%ebp
  1013a5:	83 ec 10             	sub    $0x10,%esp
  1013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b2:	89 c2                	mov    %eax,%edx
  1013b4:	ec                   	in     (%dx),%al
  1013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bc:	0f b6 c0             	movzbl %al,%eax
  1013bf:	83 e0 01             	and    $0x1,%eax
  1013c2:	85 c0                	test   %eax,%eax
  1013c4:	75 07                	jne    1013cd <serial_proc_data+0x2b>
        return -1;
  1013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013cb:	eb 2a                	jmp    1013f7 <serial_proc_data+0x55>
  1013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013d7:	89 c2                	mov    %eax,%edx
  1013d9:	ec                   	in     (%dx),%al
  1013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e1:	0f b6 c0             	movzbl %al,%eax
  1013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013eb:	75 07                	jne    1013f4 <serial_proc_data+0x52>
        c = '\b';
  1013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013f7:	c9                   	leave  
  1013f8:	c3                   	ret    

001013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013f9:	55                   	push   %ebp
  1013fa:	89 e5                	mov    %esp,%ebp
  1013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013ff:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101404:	85 c0                	test   %eax,%eax
  101406:	74 0c                	je     101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101408:	c7 04 24 a2 13 10 00 	movl   $0x1013a2,(%esp)
  10140f:	e8 43 ff ff ff       	call   101357 <cons_intr>
    }
}
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101416:	55                   	push   %ebp
  101417:	89 e5                	mov    %esp,%ebp
  101419:	83 ec 38             	sub    $0x38,%esp
  10141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  101426:	89 c2                	mov    %eax,%edx
  101428:	ec                   	in     (%dx),%al
  101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101430:	0f b6 c0             	movzbl %al,%eax
  101433:	83 e0 01             	and    $0x1,%eax
  101436:	85 c0                	test   %eax,%eax
  101438:	75 0a                	jne    101444 <kbd_proc_data+0x2e>
        return -1;
  10143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143f:	e9 59 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
  101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10145f:	75 17                	jne    101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101461:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101466:	83 c8 40             	or     $0x40,%eax
  101469:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  10146e:	b8 00 00 00 00       	mov    $0x0,%eax
  101473:	e9 25 01 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147c:	84 c0                	test   %al,%al
  10147e:	79 47                	jns    1014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101480:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101485:	83 e0 40             	and    $0x40,%eax
  101488:	85 c0                	test   %eax,%eax
  10148a:	75 09                	jne    101495 <kbd_proc_data+0x7f>
  10148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101490:	83 e0 7f             	and    $0x7f,%eax
  101493:	eb 04                	jmp    101499 <kbd_proc_data+0x83>
  101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014a7:	83 c8 40             	or     $0x40,%eax
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d6 00 00 00       	jmp    10159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014c7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13e>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14e>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 28                	jne    10159a <kbd_proc_data+0x184>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1f                	jne    10159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 dd 61 10 00 	movl   $0x1061dd,(%esp)
  101582:	e8 b5 ed ff ff       	call   10033c <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a5:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  1015ac:	e8 a6 fd ff ff       	call   101357 <cons_intr>
}
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e1 ff ff ff       	call   10159f <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 3d 01 00 00       	call   101707 <pic_enable>
}
  1015ca:	c9                   	leave  
  1015cb:	c3                   	ret    

001015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cc:	55                   	push   %ebp
  1015cd:	89 e5                	mov    %esp,%ebp
  1015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d2:	e8 93 f8 ff ff       	call   100e6a <cga_init>
    serial_init();
  1015d7:	e8 74 f9 ff ff       	call   100f50 <serial_init>
    kbd_init();
  1015dc:	e8 d2 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e1:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015e6:	85 c0                	test   %eax,%eax
  1015e8:	75 0c                	jne    1015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015ea:	c7 04 24 e9 61 10 00 	movl   $0x1061e9,(%esp)
  1015f1:	e8 46 ed ff ff       	call   10033c <cprintf>
    }
}
  1015f6:	c9                   	leave  
  1015f7:	c3                   	ret    

001015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015f8:	55                   	push   %ebp
  1015f9:	89 e5                	mov    %esp,%ebp
  1015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015fe:	e8 e2 f7 ff ff       	call   100de5 <__intr_save>
  101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101606:	8b 45 08             	mov    0x8(%ebp),%eax
  101609:	89 04 24             	mov    %eax,(%esp)
  10160c:	e8 9b fa ff ff       	call   1010ac <lpt_putc>
        cga_putc(c);
  101611:	8b 45 08             	mov    0x8(%ebp),%eax
  101614:	89 04 24             	mov    %eax,(%esp)
  101617:	e8 cf fa ff ff       	call   1010eb <cga_putc>
        serial_putc(c);
  10161c:	8b 45 08             	mov    0x8(%ebp),%eax
  10161f:	89 04 24             	mov    %eax,(%esp)
  101622:	e8 f1 fc ff ff       	call   101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162a:	89 04 24             	mov    %eax,(%esp)
  10162d:	e8 dd f7 ff ff       	call   100e0f <__intr_restore>
}
  101632:	c9                   	leave  
  101633:	c3                   	ret    

00101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101634:	55                   	push   %ebp
  101635:	89 e5                	mov    %esp,%ebp
  101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101641:	e8 9f f7 ff ff       	call   100de5 <__intr_save>
  101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101649:	e8 ab fd ff ff       	call   1013f9 <serial_intr>
        kbd_intr();
  10164e:	e8 4c ff ff ff       	call   10159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101653:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101659:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10165e:	39 c2                	cmp    %eax,%edx
  101660:	74 31                	je     101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	8d 50 01             	lea    0x1(%eax),%edx
  10166a:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101670:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  101677:	0f b6 c0             	movzbl %al,%eax
  10167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10167d:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101682:	3d 00 02 00 00       	cmp    $0x200,%eax
  101687:	75 0a                	jne    101693 <cons_getc+0x5f>
                cons.rpos = 0;
  101689:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101696:	89 04 24             	mov    %eax,(%esp)
  101699:	e8 71 f7 ff ff       	call   100e0f <__intr_restore>
    return c;
  10169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a1:	c9                   	leave  
  1016a2:	c3                   	ret    

001016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016a3:	55                   	push   %ebp
  1016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016a6:	fb                   	sti    
    sti();
}
  1016a7:	5d                   	pop    %ebp
  1016a8:	c3                   	ret    

001016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016a9:	55                   	push   %ebp
  1016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016ac:	fa                   	cli    
    cli();
}
  1016ad:	5d                   	pop    %ebp
  1016ae:	c3                   	ret    

001016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 14             	sub    $0x14,%esp
  1016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c0:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016c6:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016cb:	85 c0                	test   %eax,%eax
  1016cd:	74 36                	je     101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d3:	0f b6 c0             	movzbl %al,%eax
  1016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ec:	66 c1 e8 08          	shr    $0x8,%ax
  1016f0:	0f b6 c0             	movzbl %al,%eax
  1016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101704:	ee                   	out    %al,(%dx)
    }
}
  101705:	c9                   	leave  
  101706:	c3                   	ret    

00101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101707:	55                   	push   %ebp
  101708:	89 e5                	mov    %esp,%ebp
  10170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10170d:	8b 45 08             	mov    0x8(%ebp),%eax
  101710:	ba 01 00 00 00       	mov    $0x1,%edx
  101715:	89 c1                	mov    %eax,%ecx
  101717:	d3 e2                	shl    %cl,%edx
  101719:	89 d0                	mov    %edx,%eax
  10171b:	f7 d0                	not    %eax
  10171d:	89 c2                	mov    %eax,%edx
  10171f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101726:	21 d0                	and    %edx,%eax
  101728:	0f b7 c0             	movzwl %ax,%eax
  10172b:	89 04 24             	mov    %eax,(%esp)
  10172e:	e8 7c ff ff ff       	call   1016af <pic_setmask>
}
  101733:	c9                   	leave  
  101734:	c3                   	ret    

00101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101735:	55                   	push   %ebp
  101736:	89 e5                	mov    %esp,%ebp
  101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10173b:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101742:	00 00 00 
  101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101757:	ee                   	out    %al,(%dx)
  101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10176a:	ee                   	out    %al,(%dx)
  10176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10177d:	ee                   	out    %al,(%dx)
  10177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101790:	ee                   	out    %al,(%dx)
  101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  10179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017a3:	ee                   	out    %al,(%dx)
  1017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017b6:	ee                   	out    %al,(%dx)
  1017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017c9:	ee                   	out    %al,(%dx)
  1017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017dc:	ee                   	out    %al,(%dx)
  1017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184f:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101856:	66 83 f8 ff          	cmp    $0xffff,%ax
  10185a:	74 12                	je     10186e <pic_init+0x139>
        pic_setmask(irq_mask);
  10185c:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 04 24             	mov    %eax,(%esp)
  101869:	e8 41 fe ff ff       	call   1016af <pic_setmask>
    }
}
  10186e:	c9                   	leave  
  10186f:	c3                   	ret    

00101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101870:	55                   	push   %ebp
  101871:	89 e5                	mov    %esp,%ebp
  101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10187d:	00 
  10187e:	c7 04 24 20 62 10 00 	movl   $0x106220,(%esp)
  101885:	e8 b2 ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10188a:	c7 04 24 2a 62 10 00 	movl   $0x10622a,(%esp)
  101891:	e8 a6 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  101896:	c7 44 24 08 38 62 10 	movl   $0x106238,0x8(%esp)
  10189d:	00 
  10189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018a5:	00 
  1018a6:	c7 04 24 4e 62 10 00 	movl   $0x10624e,(%esp)
  1018ad:	e8 14 f4 ff ff       	call   100cc6 <__panic>

001018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018b2:	55                   	push   %ebp
  1018b3:	89 e5                	mov    %esp,%ebp
  1018b5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018bf:	e9 c3 00 00 00       	jmp    101987 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c7:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018ce:	89 c2                	mov    %eax,%edx
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018da:	00 
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018e5:	00 08 00 
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f2:	00 
  1018f3:	83 e2 e0             	and    $0xffffffe0,%edx
  1018f6:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  101907:	00 
  101908:	83 e2 1f             	and    $0x1f,%edx
  10190b:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10191c:	00 
  10191d:	83 e2 f0             	and    $0xfffffff0,%edx
  101920:	83 ca 0e             	or     $0xe,%edx
  101923:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192d:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101934:	00 
  101935:	83 e2 ef             	and    $0xffffffef,%edx
  101938:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101942:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101949:	00 
  10194a:	83 e2 9f             	and    $0xffffff9f,%edx
  10194d:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101957:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10195e:	00 
  10195f:	83 ca 80             	or     $0xffffff80,%edx
  101962:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196c:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101973:	c1 e8 10             	shr    $0x10,%eax
  101976:	89 c2                	mov    %eax,%edx
  101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197b:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101982:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10198a:	3d ff 00 00 00       	cmp    $0xff,%eax
  10198f:	0f 86 2f ff ff ff    	jbe    1018c4 <idt_init+0x12>
  101995:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  10199c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10199f:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
  1019a2:	c9                   	leave  
  1019a3:	c3                   	ret    

001019a4 <trapname>:

static const char *
trapname(int trapno) {
  1019a4:	55                   	push   %ebp
  1019a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019aa:	83 f8 13             	cmp    $0x13,%eax
  1019ad:	77 0c                	ja     1019bb <trapname+0x17>
        return excnames[trapno];
  1019af:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b2:	8b 04 85 a0 65 10 00 	mov    0x1065a0(,%eax,4),%eax
  1019b9:	eb 18                	jmp    1019d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019bf:	7e 0d                	jle    1019ce <trapname+0x2a>
  1019c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019c5:	7f 07                	jg     1019ce <trapname+0x2a>
        return "Hardware Interrupt";
  1019c7:	b8 5f 62 10 00       	mov    $0x10625f,%eax
  1019cc:	eb 05                	jmp    1019d3 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019ce:	b8 72 62 10 00       	mov    $0x106272,%eax
}
  1019d3:	5d                   	pop    %ebp
  1019d4:	c3                   	ret    

001019d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019d5:	55                   	push   %ebp
  1019d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019df:	66 83 f8 08          	cmp    $0x8,%ax
  1019e3:	0f 94 c0             	sete   %al
  1019e6:	0f b6 c0             	movzbl %al,%eax
}
  1019e9:	5d                   	pop    %ebp
  1019ea:	c3                   	ret    

001019eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019eb:	55                   	push   %ebp
  1019ec:	89 e5                	mov    %esp,%ebp
  1019ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f8:	c7 04 24 b3 62 10 00 	movl   $0x1062b3,(%esp)
  1019ff:	e8 38 e9 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a04:	8b 45 08             	mov    0x8(%ebp),%eax
  101a07:	89 04 24             	mov    %eax,(%esp)
  101a0a:	e8 a1 01 00 00       	call   101bb0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a12:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a16:	0f b7 c0             	movzwl %ax,%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 c4 62 10 00 	movl   $0x1062c4,(%esp)
  101a24:	e8 13 e9 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a30:	0f b7 c0             	movzwl %ax,%eax
  101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a37:	c7 04 24 d7 62 10 00 	movl   $0x1062d7,(%esp)
  101a3e:	e8 f9 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a43:	8b 45 08             	mov    0x8(%ebp),%eax
  101a46:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4a:	0f b7 c0             	movzwl %ax,%eax
  101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a51:	c7 04 24 ea 62 10 00 	movl   $0x1062ea,(%esp)
  101a58:	e8 df e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a64:	0f b7 c0             	movzwl %ax,%eax
  101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a6b:	c7 04 24 fd 62 10 00 	movl   $0x1062fd,(%esp)
  101a72:	e8 c5 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a77:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7a:	8b 40 30             	mov    0x30(%eax),%eax
  101a7d:	89 04 24             	mov    %eax,(%esp)
  101a80:	e8 1f ff ff ff       	call   1019a4 <trapname>
  101a85:	8b 55 08             	mov    0x8(%ebp),%edx
  101a88:	8b 52 30             	mov    0x30(%edx),%edx
  101a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a93:	c7 04 24 10 63 10 00 	movl   $0x106310,(%esp)
  101a9a:	e8 9d e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 34             	mov    0x34(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 22 63 10 00 	movl   $0x106322,(%esp)
  101ab0:	e8 87 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	8b 40 38             	mov    0x38(%eax),%eax
  101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abf:	c7 04 24 31 63 10 00 	movl   $0x106331,(%esp)
  101ac6:	e8 71 e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad2:	0f b7 c0             	movzwl %ax,%eax
  101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad9:	c7 04 24 40 63 10 00 	movl   $0x106340,(%esp)
  101ae0:	e8 57 e8 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	8b 40 40             	mov    0x40(%eax),%eax
  101aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aef:	c7 04 24 53 63 10 00 	movl   $0x106353,(%esp)
  101af6:	e8 41 e8 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b09:	eb 3e                	jmp    101b49 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0e:	8b 50 40             	mov    0x40(%eax),%edx
  101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b14:	21 d0                	and    %edx,%eax
  101b16:	85 c0                	test   %eax,%eax
  101b18:	74 28                	je     101b42 <print_trapframe+0x157>
  101b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1d:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b24:	85 c0                	test   %eax,%eax
  101b26:	74 1a                	je     101b42 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2b:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b32:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b36:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  101b3d:	e8 fa e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b46:	d1 65 f0             	shll   -0x10(%ebp)
  101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b4c:	83 f8 17             	cmp    $0x17,%eax
  101b4f:	76 ba                	jbe    101b0b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	8b 40 40             	mov    0x40(%eax),%eax
  101b57:	25 00 30 00 00       	and    $0x3000,%eax
  101b5c:	c1 e8 0c             	shr    $0xc,%eax
  101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b63:	c7 04 24 66 63 10 00 	movl   $0x106366,(%esp)
  101b6a:	e8 cd e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b72:	89 04 24             	mov    %eax,(%esp)
  101b75:	e8 5b fe ff ff       	call   1019d5 <trap_in_kernel>
  101b7a:	85 c0                	test   %eax,%eax
  101b7c:	75 30                	jne    101bae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b81:	8b 40 44             	mov    0x44(%eax),%eax
  101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b88:	c7 04 24 6f 63 10 00 	movl   $0x10636f,(%esp)
  101b8f:	e8 a8 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b9b:	0f b7 c0             	movzwl %ax,%eax
  101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba2:	c7 04 24 7e 63 10 00 	movl   $0x10637e,(%esp)
  101ba9:	e8 8e e7 ff ff       	call   10033c <cprintf>
    }
}
  101bae:	c9                   	leave  
  101baf:	c3                   	ret    

00101bb0 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bb0:	55                   	push   %ebp
  101bb1:	89 e5                	mov    %esp,%ebp
  101bb3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb9:	8b 00                	mov    (%eax),%eax
  101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbf:	c7 04 24 91 63 10 00 	movl   $0x106391,(%esp)
  101bc6:	e8 71 e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	8b 40 04             	mov    0x4(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 a0 63 10 00 	movl   $0x1063a0,(%esp)
  101bdc:	e8 5b e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 08             	mov    0x8(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 af 63 10 00 	movl   $0x1063af,(%esp)
  101bf2:	e8 45 e7 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	8b 40 0c             	mov    0xc(%eax),%eax
  101bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c01:	c7 04 24 be 63 10 00 	movl   $0x1063be,(%esp)
  101c08:	e8 2f e7 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c10:	8b 40 10             	mov    0x10(%eax),%eax
  101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c17:	c7 04 24 cd 63 10 00 	movl   $0x1063cd,(%esp)
  101c1e:	e8 19 e7 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c23:	8b 45 08             	mov    0x8(%ebp),%eax
  101c26:	8b 40 14             	mov    0x14(%eax),%eax
  101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2d:	c7 04 24 dc 63 10 00 	movl   $0x1063dc,(%esp)
  101c34:	e8 03 e7 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c39:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3c:	8b 40 18             	mov    0x18(%eax),%eax
  101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c43:	c7 04 24 eb 63 10 00 	movl   $0x1063eb,(%esp)
  101c4a:	e8 ed e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c52:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c59:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101c60:	e8 d7 e6 ff ff       	call   10033c <cprintf>
}
  101c65:	c9                   	leave  
  101c66:	c3                   	ret    

00101c67 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c67:	55                   	push   %ebp
  101c68:	89 e5                	mov    %esp,%ebp
  101c6a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c70:	8b 40 30             	mov    0x30(%eax),%eax
  101c73:	83 f8 2f             	cmp    $0x2f,%eax
  101c76:	77 21                	ja     101c99 <trap_dispatch+0x32>
  101c78:	83 f8 2e             	cmp    $0x2e,%eax
  101c7b:	0f 83 04 01 00 00    	jae    101d85 <trap_dispatch+0x11e>
  101c81:	83 f8 21             	cmp    $0x21,%eax
  101c84:	0f 84 81 00 00 00    	je     101d0b <trap_dispatch+0xa4>
  101c8a:	83 f8 24             	cmp    $0x24,%eax
  101c8d:	74 56                	je     101ce5 <trap_dispatch+0x7e>
  101c8f:	83 f8 20             	cmp    $0x20,%eax
  101c92:	74 16                	je     101caa <trap_dispatch+0x43>
  101c94:	e9 b4 00 00 00       	jmp    101d4d <trap_dispatch+0xe6>
  101c99:	83 e8 78             	sub    $0x78,%eax
  101c9c:	83 f8 01             	cmp    $0x1,%eax
  101c9f:	0f 87 a8 00 00 00    	ja     101d4d <trap_dispatch+0xe6>
  101ca5:	e9 87 00 00 00       	jmp    101d31 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101caa:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101caf:	83 c0 01             	add    $0x1,%eax
  101cb2:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101cb7:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101cbd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cc2:	89 c8                	mov    %ecx,%eax
  101cc4:	f7 e2                	mul    %edx
  101cc6:	89 d0                	mov    %edx,%eax
  101cc8:	c1 e8 05             	shr    $0x5,%eax
  101ccb:	6b c0 64             	imul   $0x64,%eax,%eax
  101cce:	29 c1                	sub    %eax,%ecx
  101cd0:	89 c8                	mov    %ecx,%eax
  101cd2:	85 c0                	test   %eax,%eax
  101cd4:	75 0a                	jne    101ce0 <trap_dispatch+0x79>
            print_ticks();
  101cd6:	e8 95 fb ff ff       	call   101870 <print_ticks>
        }
        break;
  101cdb:	e9 a6 00 00 00       	jmp    101d86 <trap_dispatch+0x11f>
  101ce0:	e9 a1 00 00 00       	jmp    101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ce5:	e8 4a f9 ff ff       	call   101634 <cons_getc>
  101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101d04:	e8 33 e6 ff ff       	call   10033c <cprintf>
        break;
  101d09:	eb 7b                	jmp    101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d0b:	e8 24 f9 ff ff       	call   101634 <cons_getc>
  101d10:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d13:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d17:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d23:	c7 04 24 1b 64 10 00 	movl   $0x10641b,(%esp)
  101d2a:	e8 0d e6 ff ff       	call   10033c <cprintf>
        break;
  101d2f:	eb 55                	jmp    101d86 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d31:	c7 44 24 08 2a 64 10 	movl   $0x10642a,0x8(%esp)
  101d38:	00 
  101d39:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101d40:	00 
  101d41:	c7 04 24 4e 62 10 00 	movl   $0x10624e,(%esp)
  101d48:	e8 79 ef ff ff       	call   100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d50:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d54:	0f b7 c0             	movzwl %ax,%eax
  101d57:	83 e0 03             	and    $0x3,%eax
  101d5a:	85 c0                	test   %eax,%eax
  101d5c:	75 28                	jne    101d86 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	89 04 24             	mov    %eax,(%esp)
  101d64:	e8 82 fc ff ff       	call   1019eb <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d69:	c7 44 24 08 3a 64 10 	movl   $0x10643a,0x8(%esp)
  101d70:	00 
  101d71:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101d78:	00 
  101d79:	c7 04 24 4e 62 10 00 	movl   $0x10624e,(%esp)
  101d80:	e8 41 ef ff ff       	call   100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d85:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d86:	c9                   	leave  
  101d87:	c3                   	ret    

00101d88 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d88:	55                   	push   %ebp
  101d89:	89 e5                	mov    %esp,%ebp
  101d8b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d91:	89 04 24             	mov    %eax,(%esp)
  101d94:	e8 ce fe ff ff       	call   101c67 <trap_dispatch>
}
  101d99:	c9                   	leave  
  101d9a:	c3                   	ret    

00101d9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d9b:	1e                   	push   %ds
    pushl %es
  101d9c:	06                   	push   %es
    pushl %fs
  101d9d:	0f a0                	push   %fs
    pushl %gs
  101d9f:	0f a8                	push   %gs
    pushal
  101da1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101da2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101da7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101da9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dac:	e8 d7 ff ff ff       	call   101d88 <trap>

    # pop the pushed stack pointer
    popl %esp
  101db1:	5c                   	pop    %esp

00101db2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101db2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101db3:	0f a9                	pop    %gs
    popl %fs
  101db5:	0f a1                	pop    %fs
    popl %es
  101db7:	07                   	pop    %es
    popl %ds
  101db8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101db9:	83 c4 08             	add    $0x8,%esp
    iret
  101dbc:	cf                   	iret   

00101dbd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $0
  101dbf:	6a 00                	push   $0x0
  jmp __alltraps
  101dc1:	e9 d5 ff ff ff       	jmp    101d9b <__alltraps>

00101dc6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $1
  101dc8:	6a 01                	push   $0x1
  jmp __alltraps
  101dca:	e9 cc ff ff ff       	jmp    101d9b <__alltraps>

00101dcf <vector2>:
.globl vector2
vector2:
  pushl $0
  101dcf:	6a 00                	push   $0x0
  pushl $2
  101dd1:	6a 02                	push   $0x2
  jmp __alltraps
  101dd3:	e9 c3 ff ff ff       	jmp    101d9b <__alltraps>

00101dd8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101dd8:	6a 00                	push   $0x0
  pushl $3
  101dda:	6a 03                	push   $0x3
  jmp __alltraps
  101ddc:	e9 ba ff ff ff       	jmp    101d9b <__alltraps>

00101de1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101de1:	6a 00                	push   $0x0
  pushl $4
  101de3:	6a 04                	push   $0x4
  jmp __alltraps
  101de5:	e9 b1 ff ff ff       	jmp    101d9b <__alltraps>

00101dea <vector5>:
.globl vector5
vector5:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $5
  101dec:	6a 05                	push   $0x5
  jmp __alltraps
  101dee:	e9 a8 ff ff ff       	jmp    101d9b <__alltraps>

00101df3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $6
  101df5:	6a 06                	push   $0x6
  jmp __alltraps
  101df7:	e9 9f ff ff ff       	jmp    101d9b <__alltraps>

00101dfc <vector7>:
.globl vector7
vector7:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $7
  101dfe:	6a 07                	push   $0x7
  jmp __alltraps
  101e00:	e9 96 ff ff ff       	jmp    101d9b <__alltraps>

00101e05 <vector8>:
.globl vector8
vector8:
  pushl $8
  101e05:	6a 08                	push   $0x8
  jmp __alltraps
  101e07:	e9 8f ff ff ff       	jmp    101d9b <__alltraps>

00101e0c <vector9>:
.globl vector9
vector9:
  pushl $9
  101e0c:	6a 09                	push   $0x9
  jmp __alltraps
  101e0e:	e9 88 ff ff ff       	jmp    101d9b <__alltraps>

00101e13 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e13:	6a 0a                	push   $0xa
  jmp __alltraps
  101e15:	e9 81 ff ff ff       	jmp    101d9b <__alltraps>

00101e1a <vector11>:
.globl vector11
vector11:
  pushl $11
  101e1a:	6a 0b                	push   $0xb
  jmp __alltraps
  101e1c:	e9 7a ff ff ff       	jmp    101d9b <__alltraps>

00101e21 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e21:	6a 0c                	push   $0xc
  jmp __alltraps
  101e23:	e9 73 ff ff ff       	jmp    101d9b <__alltraps>

00101e28 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e28:	6a 0d                	push   $0xd
  jmp __alltraps
  101e2a:	e9 6c ff ff ff       	jmp    101d9b <__alltraps>

00101e2f <vector14>:
.globl vector14
vector14:
  pushl $14
  101e2f:	6a 0e                	push   $0xe
  jmp __alltraps
  101e31:	e9 65 ff ff ff       	jmp    101d9b <__alltraps>

00101e36 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $15
  101e38:	6a 0f                	push   $0xf
  jmp __alltraps
  101e3a:	e9 5c ff ff ff       	jmp    101d9b <__alltraps>

00101e3f <vector16>:
.globl vector16
vector16:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $16
  101e41:	6a 10                	push   $0x10
  jmp __alltraps
  101e43:	e9 53 ff ff ff       	jmp    101d9b <__alltraps>

00101e48 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e48:	6a 11                	push   $0x11
  jmp __alltraps
  101e4a:	e9 4c ff ff ff       	jmp    101d9b <__alltraps>

00101e4f <vector18>:
.globl vector18
vector18:
  pushl $0
  101e4f:	6a 00                	push   $0x0
  pushl $18
  101e51:	6a 12                	push   $0x12
  jmp __alltraps
  101e53:	e9 43 ff ff ff       	jmp    101d9b <__alltraps>

00101e58 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e58:	6a 00                	push   $0x0
  pushl $19
  101e5a:	6a 13                	push   $0x13
  jmp __alltraps
  101e5c:	e9 3a ff ff ff       	jmp    101d9b <__alltraps>

00101e61 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e61:	6a 00                	push   $0x0
  pushl $20
  101e63:	6a 14                	push   $0x14
  jmp __alltraps
  101e65:	e9 31 ff ff ff       	jmp    101d9b <__alltraps>

00101e6a <vector21>:
.globl vector21
vector21:
  pushl $0
  101e6a:	6a 00                	push   $0x0
  pushl $21
  101e6c:	6a 15                	push   $0x15
  jmp __alltraps
  101e6e:	e9 28 ff ff ff       	jmp    101d9b <__alltraps>

00101e73 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e73:	6a 00                	push   $0x0
  pushl $22
  101e75:	6a 16                	push   $0x16
  jmp __alltraps
  101e77:	e9 1f ff ff ff       	jmp    101d9b <__alltraps>

00101e7c <vector23>:
.globl vector23
vector23:
  pushl $0
  101e7c:	6a 00                	push   $0x0
  pushl $23
  101e7e:	6a 17                	push   $0x17
  jmp __alltraps
  101e80:	e9 16 ff ff ff       	jmp    101d9b <__alltraps>

00101e85 <vector24>:
.globl vector24
vector24:
  pushl $0
  101e85:	6a 00                	push   $0x0
  pushl $24
  101e87:	6a 18                	push   $0x18
  jmp __alltraps
  101e89:	e9 0d ff ff ff       	jmp    101d9b <__alltraps>

00101e8e <vector25>:
.globl vector25
vector25:
  pushl $0
  101e8e:	6a 00                	push   $0x0
  pushl $25
  101e90:	6a 19                	push   $0x19
  jmp __alltraps
  101e92:	e9 04 ff ff ff       	jmp    101d9b <__alltraps>

00101e97 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e97:	6a 00                	push   $0x0
  pushl $26
  101e99:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e9b:	e9 fb fe ff ff       	jmp    101d9b <__alltraps>

00101ea0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ea0:	6a 00                	push   $0x0
  pushl $27
  101ea2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ea4:	e9 f2 fe ff ff       	jmp    101d9b <__alltraps>

00101ea9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ea9:	6a 00                	push   $0x0
  pushl $28
  101eab:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ead:	e9 e9 fe ff ff       	jmp    101d9b <__alltraps>

00101eb2 <vector29>:
.globl vector29
vector29:
  pushl $0
  101eb2:	6a 00                	push   $0x0
  pushl $29
  101eb4:	6a 1d                	push   $0x1d
  jmp __alltraps
  101eb6:	e9 e0 fe ff ff       	jmp    101d9b <__alltraps>

00101ebb <vector30>:
.globl vector30
vector30:
  pushl $0
  101ebb:	6a 00                	push   $0x0
  pushl $30
  101ebd:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ebf:	e9 d7 fe ff ff       	jmp    101d9b <__alltraps>

00101ec4 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ec4:	6a 00                	push   $0x0
  pushl $31
  101ec6:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ec8:	e9 ce fe ff ff       	jmp    101d9b <__alltraps>

00101ecd <vector32>:
.globl vector32
vector32:
  pushl $0
  101ecd:	6a 00                	push   $0x0
  pushl $32
  101ecf:	6a 20                	push   $0x20
  jmp __alltraps
  101ed1:	e9 c5 fe ff ff       	jmp    101d9b <__alltraps>

00101ed6 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ed6:	6a 00                	push   $0x0
  pushl $33
  101ed8:	6a 21                	push   $0x21
  jmp __alltraps
  101eda:	e9 bc fe ff ff       	jmp    101d9b <__alltraps>

00101edf <vector34>:
.globl vector34
vector34:
  pushl $0
  101edf:	6a 00                	push   $0x0
  pushl $34
  101ee1:	6a 22                	push   $0x22
  jmp __alltraps
  101ee3:	e9 b3 fe ff ff       	jmp    101d9b <__alltraps>

00101ee8 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $35
  101eea:	6a 23                	push   $0x23
  jmp __alltraps
  101eec:	e9 aa fe ff ff       	jmp    101d9b <__alltraps>

00101ef1 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $36
  101ef3:	6a 24                	push   $0x24
  jmp __alltraps
  101ef5:	e9 a1 fe ff ff       	jmp    101d9b <__alltraps>

00101efa <vector37>:
.globl vector37
vector37:
  pushl $0
  101efa:	6a 00                	push   $0x0
  pushl $37
  101efc:	6a 25                	push   $0x25
  jmp __alltraps
  101efe:	e9 98 fe ff ff       	jmp    101d9b <__alltraps>

00101f03 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f03:	6a 00                	push   $0x0
  pushl $38
  101f05:	6a 26                	push   $0x26
  jmp __alltraps
  101f07:	e9 8f fe ff ff       	jmp    101d9b <__alltraps>

00101f0c <vector39>:
.globl vector39
vector39:
  pushl $0
  101f0c:	6a 00                	push   $0x0
  pushl $39
  101f0e:	6a 27                	push   $0x27
  jmp __alltraps
  101f10:	e9 86 fe ff ff       	jmp    101d9b <__alltraps>

00101f15 <vector40>:
.globl vector40
vector40:
  pushl $0
  101f15:	6a 00                	push   $0x0
  pushl $40
  101f17:	6a 28                	push   $0x28
  jmp __alltraps
  101f19:	e9 7d fe ff ff       	jmp    101d9b <__alltraps>

00101f1e <vector41>:
.globl vector41
vector41:
  pushl $0
  101f1e:	6a 00                	push   $0x0
  pushl $41
  101f20:	6a 29                	push   $0x29
  jmp __alltraps
  101f22:	e9 74 fe ff ff       	jmp    101d9b <__alltraps>

00101f27 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f27:	6a 00                	push   $0x0
  pushl $42
  101f29:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f2b:	e9 6b fe ff ff       	jmp    101d9b <__alltraps>

00101f30 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f30:	6a 00                	push   $0x0
  pushl $43
  101f32:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f34:	e9 62 fe ff ff       	jmp    101d9b <__alltraps>

00101f39 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f39:	6a 00                	push   $0x0
  pushl $44
  101f3b:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f3d:	e9 59 fe ff ff       	jmp    101d9b <__alltraps>

00101f42 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f42:	6a 00                	push   $0x0
  pushl $45
  101f44:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f46:	e9 50 fe ff ff       	jmp    101d9b <__alltraps>

00101f4b <vector46>:
.globl vector46
vector46:
  pushl $0
  101f4b:	6a 00                	push   $0x0
  pushl $46
  101f4d:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f4f:	e9 47 fe ff ff       	jmp    101d9b <__alltraps>

00101f54 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f54:	6a 00                	push   $0x0
  pushl $47
  101f56:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f58:	e9 3e fe ff ff       	jmp    101d9b <__alltraps>

00101f5d <vector48>:
.globl vector48
vector48:
  pushl $0
  101f5d:	6a 00                	push   $0x0
  pushl $48
  101f5f:	6a 30                	push   $0x30
  jmp __alltraps
  101f61:	e9 35 fe ff ff       	jmp    101d9b <__alltraps>

00101f66 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f66:	6a 00                	push   $0x0
  pushl $49
  101f68:	6a 31                	push   $0x31
  jmp __alltraps
  101f6a:	e9 2c fe ff ff       	jmp    101d9b <__alltraps>

00101f6f <vector50>:
.globl vector50
vector50:
  pushl $0
  101f6f:	6a 00                	push   $0x0
  pushl $50
  101f71:	6a 32                	push   $0x32
  jmp __alltraps
  101f73:	e9 23 fe ff ff       	jmp    101d9b <__alltraps>

00101f78 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f78:	6a 00                	push   $0x0
  pushl $51
  101f7a:	6a 33                	push   $0x33
  jmp __alltraps
  101f7c:	e9 1a fe ff ff       	jmp    101d9b <__alltraps>

00101f81 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $52
  101f83:	6a 34                	push   $0x34
  jmp __alltraps
  101f85:	e9 11 fe ff ff       	jmp    101d9b <__alltraps>

00101f8a <vector53>:
.globl vector53
vector53:
  pushl $0
  101f8a:	6a 00                	push   $0x0
  pushl $53
  101f8c:	6a 35                	push   $0x35
  jmp __alltraps
  101f8e:	e9 08 fe ff ff       	jmp    101d9b <__alltraps>

00101f93 <vector54>:
.globl vector54
vector54:
  pushl $0
  101f93:	6a 00                	push   $0x0
  pushl $54
  101f95:	6a 36                	push   $0x36
  jmp __alltraps
  101f97:	e9 ff fd ff ff       	jmp    101d9b <__alltraps>

00101f9c <vector55>:
.globl vector55
vector55:
  pushl $0
  101f9c:	6a 00                	push   $0x0
  pushl $55
  101f9e:	6a 37                	push   $0x37
  jmp __alltraps
  101fa0:	e9 f6 fd ff ff       	jmp    101d9b <__alltraps>

00101fa5 <vector56>:
.globl vector56
vector56:
  pushl $0
  101fa5:	6a 00                	push   $0x0
  pushl $56
  101fa7:	6a 38                	push   $0x38
  jmp __alltraps
  101fa9:	e9 ed fd ff ff       	jmp    101d9b <__alltraps>

00101fae <vector57>:
.globl vector57
vector57:
  pushl $0
  101fae:	6a 00                	push   $0x0
  pushl $57
  101fb0:	6a 39                	push   $0x39
  jmp __alltraps
  101fb2:	e9 e4 fd ff ff       	jmp    101d9b <__alltraps>

00101fb7 <vector58>:
.globl vector58
vector58:
  pushl $0
  101fb7:	6a 00                	push   $0x0
  pushl $58
  101fb9:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fbb:	e9 db fd ff ff       	jmp    101d9b <__alltraps>

00101fc0 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fc0:	6a 00                	push   $0x0
  pushl $59
  101fc2:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fc4:	e9 d2 fd ff ff       	jmp    101d9b <__alltraps>

00101fc9 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fc9:	6a 00                	push   $0x0
  pushl $60
  101fcb:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fcd:	e9 c9 fd ff ff       	jmp    101d9b <__alltraps>

00101fd2 <vector61>:
.globl vector61
vector61:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $61
  101fd4:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fd6:	e9 c0 fd ff ff       	jmp    101d9b <__alltraps>

00101fdb <vector62>:
.globl vector62
vector62:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $62
  101fdd:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fdf:	e9 b7 fd ff ff       	jmp    101d9b <__alltraps>

00101fe4 <vector63>:
.globl vector63
vector63:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $63
  101fe6:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fe8:	e9 ae fd ff ff       	jmp    101d9b <__alltraps>

00101fed <vector64>:
.globl vector64
vector64:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $64
  101fef:	6a 40                	push   $0x40
  jmp __alltraps
  101ff1:	e9 a5 fd ff ff       	jmp    101d9b <__alltraps>

00101ff6 <vector65>:
.globl vector65
vector65:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $65
  101ff8:	6a 41                	push   $0x41
  jmp __alltraps
  101ffa:	e9 9c fd ff ff       	jmp    101d9b <__alltraps>

00101fff <vector66>:
.globl vector66
vector66:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $66
  102001:	6a 42                	push   $0x42
  jmp __alltraps
  102003:	e9 93 fd ff ff       	jmp    101d9b <__alltraps>

00102008 <vector67>:
.globl vector67
vector67:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $67
  10200a:	6a 43                	push   $0x43
  jmp __alltraps
  10200c:	e9 8a fd ff ff       	jmp    101d9b <__alltraps>

00102011 <vector68>:
.globl vector68
vector68:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $68
  102013:	6a 44                	push   $0x44
  jmp __alltraps
  102015:	e9 81 fd ff ff       	jmp    101d9b <__alltraps>

0010201a <vector69>:
.globl vector69
vector69:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $69
  10201c:	6a 45                	push   $0x45
  jmp __alltraps
  10201e:	e9 78 fd ff ff       	jmp    101d9b <__alltraps>

00102023 <vector70>:
.globl vector70
vector70:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $70
  102025:	6a 46                	push   $0x46
  jmp __alltraps
  102027:	e9 6f fd ff ff       	jmp    101d9b <__alltraps>

0010202c <vector71>:
.globl vector71
vector71:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $71
  10202e:	6a 47                	push   $0x47
  jmp __alltraps
  102030:	e9 66 fd ff ff       	jmp    101d9b <__alltraps>

00102035 <vector72>:
.globl vector72
vector72:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $72
  102037:	6a 48                	push   $0x48
  jmp __alltraps
  102039:	e9 5d fd ff ff       	jmp    101d9b <__alltraps>

0010203e <vector73>:
.globl vector73
vector73:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $73
  102040:	6a 49                	push   $0x49
  jmp __alltraps
  102042:	e9 54 fd ff ff       	jmp    101d9b <__alltraps>

00102047 <vector74>:
.globl vector74
vector74:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $74
  102049:	6a 4a                	push   $0x4a
  jmp __alltraps
  10204b:	e9 4b fd ff ff       	jmp    101d9b <__alltraps>

00102050 <vector75>:
.globl vector75
vector75:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $75
  102052:	6a 4b                	push   $0x4b
  jmp __alltraps
  102054:	e9 42 fd ff ff       	jmp    101d9b <__alltraps>

00102059 <vector76>:
.globl vector76
vector76:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $76
  10205b:	6a 4c                	push   $0x4c
  jmp __alltraps
  10205d:	e9 39 fd ff ff       	jmp    101d9b <__alltraps>

00102062 <vector77>:
.globl vector77
vector77:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $77
  102064:	6a 4d                	push   $0x4d
  jmp __alltraps
  102066:	e9 30 fd ff ff       	jmp    101d9b <__alltraps>

0010206b <vector78>:
.globl vector78
vector78:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $78
  10206d:	6a 4e                	push   $0x4e
  jmp __alltraps
  10206f:	e9 27 fd ff ff       	jmp    101d9b <__alltraps>

00102074 <vector79>:
.globl vector79
vector79:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $79
  102076:	6a 4f                	push   $0x4f
  jmp __alltraps
  102078:	e9 1e fd ff ff       	jmp    101d9b <__alltraps>

0010207d <vector80>:
.globl vector80
vector80:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $80
  10207f:	6a 50                	push   $0x50
  jmp __alltraps
  102081:	e9 15 fd ff ff       	jmp    101d9b <__alltraps>

00102086 <vector81>:
.globl vector81
vector81:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $81
  102088:	6a 51                	push   $0x51
  jmp __alltraps
  10208a:	e9 0c fd ff ff       	jmp    101d9b <__alltraps>

0010208f <vector82>:
.globl vector82
vector82:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $82
  102091:	6a 52                	push   $0x52
  jmp __alltraps
  102093:	e9 03 fd ff ff       	jmp    101d9b <__alltraps>

00102098 <vector83>:
.globl vector83
vector83:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $83
  10209a:	6a 53                	push   $0x53
  jmp __alltraps
  10209c:	e9 fa fc ff ff       	jmp    101d9b <__alltraps>

001020a1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $84
  1020a3:	6a 54                	push   $0x54
  jmp __alltraps
  1020a5:	e9 f1 fc ff ff       	jmp    101d9b <__alltraps>

001020aa <vector85>:
.globl vector85
vector85:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $85
  1020ac:	6a 55                	push   $0x55
  jmp __alltraps
  1020ae:	e9 e8 fc ff ff       	jmp    101d9b <__alltraps>

001020b3 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $86
  1020b5:	6a 56                	push   $0x56
  jmp __alltraps
  1020b7:	e9 df fc ff ff       	jmp    101d9b <__alltraps>

001020bc <vector87>:
.globl vector87
vector87:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $87
  1020be:	6a 57                	push   $0x57
  jmp __alltraps
  1020c0:	e9 d6 fc ff ff       	jmp    101d9b <__alltraps>

001020c5 <vector88>:
.globl vector88
vector88:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $88
  1020c7:	6a 58                	push   $0x58
  jmp __alltraps
  1020c9:	e9 cd fc ff ff       	jmp    101d9b <__alltraps>

001020ce <vector89>:
.globl vector89
vector89:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $89
  1020d0:	6a 59                	push   $0x59
  jmp __alltraps
  1020d2:	e9 c4 fc ff ff       	jmp    101d9b <__alltraps>

001020d7 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $90
  1020d9:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020db:	e9 bb fc ff ff       	jmp    101d9b <__alltraps>

001020e0 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $91
  1020e2:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020e4:	e9 b2 fc ff ff       	jmp    101d9b <__alltraps>

001020e9 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $92
  1020eb:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020ed:	e9 a9 fc ff ff       	jmp    101d9b <__alltraps>

001020f2 <vector93>:
.globl vector93
vector93:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $93
  1020f4:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020f6:	e9 a0 fc ff ff       	jmp    101d9b <__alltraps>

001020fb <vector94>:
.globl vector94
vector94:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $94
  1020fd:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020ff:	e9 97 fc ff ff       	jmp    101d9b <__alltraps>

00102104 <vector95>:
.globl vector95
vector95:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $95
  102106:	6a 5f                	push   $0x5f
  jmp __alltraps
  102108:	e9 8e fc ff ff       	jmp    101d9b <__alltraps>

0010210d <vector96>:
.globl vector96
vector96:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $96
  10210f:	6a 60                	push   $0x60
  jmp __alltraps
  102111:	e9 85 fc ff ff       	jmp    101d9b <__alltraps>

00102116 <vector97>:
.globl vector97
vector97:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $97
  102118:	6a 61                	push   $0x61
  jmp __alltraps
  10211a:	e9 7c fc ff ff       	jmp    101d9b <__alltraps>

0010211f <vector98>:
.globl vector98
vector98:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $98
  102121:	6a 62                	push   $0x62
  jmp __alltraps
  102123:	e9 73 fc ff ff       	jmp    101d9b <__alltraps>

00102128 <vector99>:
.globl vector99
vector99:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $99
  10212a:	6a 63                	push   $0x63
  jmp __alltraps
  10212c:	e9 6a fc ff ff       	jmp    101d9b <__alltraps>

00102131 <vector100>:
.globl vector100
vector100:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $100
  102133:	6a 64                	push   $0x64
  jmp __alltraps
  102135:	e9 61 fc ff ff       	jmp    101d9b <__alltraps>

0010213a <vector101>:
.globl vector101
vector101:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $101
  10213c:	6a 65                	push   $0x65
  jmp __alltraps
  10213e:	e9 58 fc ff ff       	jmp    101d9b <__alltraps>

00102143 <vector102>:
.globl vector102
vector102:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $102
  102145:	6a 66                	push   $0x66
  jmp __alltraps
  102147:	e9 4f fc ff ff       	jmp    101d9b <__alltraps>

0010214c <vector103>:
.globl vector103
vector103:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $103
  10214e:	6a 67                	push   $0x67
  jmp __alltraps
  102150:	e9 46 fc ff ff       	jmp    101d9b <__alltraps>

00102155 <vector104>:
.globl vector104
vector104:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $104
  102157:	6a 68                	push   $0x68
  jmp __alltraps
  102159:	e9 3d fc ff ff       	jmp    101d9b <__alltraps>

0010215e <vector105>:
.globl vector105
vector105:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $105
  102160:	6a 69                	push   $0x69
  jmp __alltraps
  102162:	e9 34 fc ff ff       	jmp    101d9b <__alltraps>

00102167 <vector106>:
.globl vector106
vector106:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $106
  102169:	6a 6a                	push   $0x6a
  jmp __alltraps
  10216b:	e9 2b fc ff ff       	jmp    101d9b <__alltraps>

00102170 <vector107>:
.globl vector107
vector107:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $107
  102172:	6a 6b                	push   $0x6b
  jmp __alltraps
  102174:	e9 22 fc ff ff       	jmp    101d9b <__alltraps>

00102179 <vector108>:
.globl vector108
vector108:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $108
  10217b:	6a 6c                	push   $0x6c
  jmp __alltraps
  10217d:	e9 19 fc ff ff       	jmp    101d9b <__alltraps>

00102182 <vector109>:
.globl vector109
vector109:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $109
  102184:	6a 6d                	push   $0x6d
  jmp __alltraps
  102186:	e9 10 fc ff ff       	jmp    101d9b <__alltraps>

0010218b <vector110>:
.globl vector110
vector110:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $110
  10218d:	6a 6e                	push   $0x6e
  jmp __alltraps
  10218f:	e9 07 fc ff ff       	jmp    101d9b <__alltraps>

00102194 <vector111>:
.globl vector111
vector111:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $111
  102196:	6a 6f                	push   $0x6f
  jmp __alltraps
  102198:	e9 fe fb ff ff       	jmp    101d9b <__alltraps>

0010219d <vector112>:
.globl vector112
vector112:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $112
  10219f:	6a 70                	push   $0x70
  jmp __alltraps
  1021a1:	e9 f5 fb ff ff       	jmp    101d9b <__alltraps>

001021a6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $113
  1021a8:	6a 71                	push   $0x71
  jmp __alltraps
  1021aa:	e9 ec fb ff ff       	jmp    101d9b <__alltraps>

001021af <vector114>:
.globl vector114
vector114:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $114
  1021b1:	6a 72                	push   $0x72
  jmp __alltraps
  1021b3:	e9 e3 fb ff ff       	jmp    101d9b <__alltraps>

001021b8 <vector115>:
.globl vector115
vector115:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $115
  1021ba:	6a 73                	push   $0x73
  jmp __alltraps
  1021bc:	e9 da fb ff ff       	jmp    101d9b <__alltraps>

001021c1 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $116
  1021c3:	6a 74                	push   $0x74
  jmp __alltraps
  1021c5:	e9 d1 fb ff ff       	jmp    101d9b <__alltraps>

001021ca <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $117
  1021cc:	6a 75                	push   $0x75
  jmp __alltraps
  1021ce:	e9 c8 fb ff ff       	jmp    101d9b <__alltraps>

001021d3 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $118
  1021d5:	6a 76                	push   $0x76
  jmp __alltraps
  1021d7:	e9 bf fb ff ff       	jmp    101d9b <__alltraps>

001021dc <vector119>:
.globl vector119
vector119:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $119
  1021de:	6a 77                	push   $0x77
  jmp __alltraps
  1021e0:	e9 b6 fb ff ff       	jmp    101d9b <__alltraps>

001021e5 <vector120>:
.globl vector120
vector120:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $120
  1021e7:	6a 78                	push   $0x78
  jmp __alltraps
  1021e9:	e9 ad fb ff ff       	jmp    101d9b <__alltraps>

001021ee <vector121>:
.globl vector121
vector121:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $121
  1021f0:	6a 79                	push   $0x79
  jmp __alltraps
  1021f2:	e9 a4 fb ff ff       	jmp    101d9b <__alltraps>

001021f7 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $122
  1021f9:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021fb:	e9 9b fb ff ff       	jmp    101d9b <__alltraps>

00102200 <vector123>:
.globl vector123
vector123:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $123
  102202:	6a 7b                	push   $0x7b
  jmp __alltraps
  102204:	e9 92 fb ff ff       	jmp    101d9b <__alltraps>

00102209 <vector124>:
.globl vector124
vector124:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $124
  10220b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10220d:	e9 89 fb ff ff       	jmp    101d9b <__alltraps>

00102212 <vector125>:
.globl vector125
vector125:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $125
  102214:	6a 7d                	push   $0x7d
  jmp __alltraps
  102216:	e9 80 fb ff ff       	jmp    101d9b <__alltraps>

0010221b <vector126>:
.globl vector126
vector126:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $126
  10221d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10221f:	e9 77 fb ff ff       	jmp    101d9b <__alltraps>

00102224 <vector127>:
.globl vector127
vector127:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $127
  102226:	6a 7f                	push   $0x7f
  jmp __alltraps
  102228:	e9 6e fb ff ff       	jmp    101d9b <__alltraps>

0010222d <vector128>:
.globl vector128
vector128:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $128
  10222f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102234:	e9 62 fb ff ff       	jmp    101d9b <__alltraps>

00102239 <vector129>:
.globl vector129
vector129:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $129
  10223b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102240:	e9 56 fb ff ff       	jmp    101d9b <__alltraps>

00102245 <vector130>:
.globl vector130
vector130:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $130
  102247:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10224c:	e9 4a fb ff ff       	jmp    101d9b <__alltraps>

00102251 <vector131>:
.globl vector131
vector131:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $131
  102253:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102258:	e9 3e fb ff ff       	jmp    101d9b <__alltraps>

0010225d <vector132>:
.globl vector132
vector132:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $132
  10225f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102264:	e9 32 fb ff ff       	jmp    101d9b <__alltraps>

00102269 <vector133>:
.globl vector133
vector133:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $133
  10226b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102270:	e9 26 fb ff ff       	jmp    101d9b <__alltraps>

00102275 <vector134>:
.globl vector134
vector134:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $134
  102277:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10227c:	e9 1a fb ff ff       	jmp    101d9b <__alltraps>

00102281 <vector135>:
.globl vector135
vector135:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $135
  102283:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102288:	e9 0e fb ff ff       	jmp    101d9b <__alltraps>

0010228d <vector136>:
.globl vector136
vector136:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $136
  10228f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102294:	e9 02 fb ff ff       	jmp    101d9b <__alltraps>

00102299 <vector137>:
.globl vector137
vector137:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $137
  10229b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022a0:	e9 f6 fa ff ff       	jmp    101d9b <__alltraps>

001022a5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $138
  1022a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022ac:	e9 ea fa ff ff       	jmp    101d9b <__alltraps>

001022b1 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $139
  1022b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022b8:	e9 de fa ff ff       	jmp    101d9b <__alltraps>

001022bd <vector140>:
.globl vector140
vector140:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $140
  1022bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022c4:	e9 d2 fa ff ff       	jmp    101d9b <__alltraps>

001022c9 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $141
  1022cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022d0:	e9 c6 fa ff ff       	jmp    101d9b <__alltraps>

001022d5 <vector142>:
.globl vector142
vector142:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $142
  1022d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022dc:	e9 ba fa ff ff       	jmp    101d9b <__alltraps>

001022e1 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $143
  1022e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022e8:	e9 ae fa ff ff       	jmp    101d9b <__alltraps>

001022ed <vector144>:
.globl vector144
vector144:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $144
  1022ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022f4:	e9 a2 fa ff ff       	jmp    101d9b <__alltraps>

001022f9 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $145
  1022fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102300:	e9 96 fa ff ff       	jmp    101d9b <__alltraps>

00102305 <vector146>:
.globl vector146
vector146:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $146
  102307:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10230c:	e9 8a fa ff ff       	jmp    101d9b <__alltraps>

00102311 <vector147>:
.globl vector147
vector147:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $147
  102313:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102318:	e9 7e fa ff ff       	jmp    101d9b <__alltraps>

0010231d <vector148>:
.globl vector148
vector148:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $148
  10231f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102324:	e9 72 fa ff ff       	jmp    101d9b <__alltraps>

00102329 <vector149>:
.globl vector149
vector149:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $149
  10232b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102330:	e9 66 fa ff ff       	jmp    101d9b <__alltraps>

00102335 <vector150>:
.globl vector150
vector150:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $150
  102337:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10233c:	e9 5a fa ff ff       	jmp    101d9b <__alltraps>

00102341 <vector151>:
.globl vector151
vector151:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $151
  102343:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102348:	e9 4e fa ff ff       	jmp    101d9b <__alltraps>

0010234d <vector152>:
.globl vector152
vector152:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $152
  10234f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102354:	e9 42 fa ff ff       	jmp    101d9b <__alltraps>

00102359 <vector153>:
.globl vector153
vector153:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $153
  10235b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102360:	e9 36 fa ff ff       	jmp    101d9b <__alltraps>

00102365 <vector154>:
.globl vector154
vector154:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $154
  102367:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10236c:	e9 2a fa ff ff       	jmp    101d9b <__alltraps>

00102371 <vector155>:
.globl vector155
vector155:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $155
  102373:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102378:	e9 1e fa ff ff       	jmp    101d9b <__alltraps>

0010237d <vector156>:
.globl vector156
vector156:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $156
  10237f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102384:	e9 12 fa ff ff       	jmp    101d9b <__alltraps>

00102389 <vector157>:
.globl vector157
vector157:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $157
  10238b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102390:	e9 06 fa ff ff       	jmp    101d9b <__alltraps>

00102395 <vector158>:
.globl vector158
vector158:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $158
  102397:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10239c:	e9 fa f9 ff ff       	jmp    101d9b <__alltraps>

001023a1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $159
  1023a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023a8:	e9 ee f9 ff ff       	jmp    101d9b <__alltraps>

001023ad <vector160>:
.globl vector160
vector160:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $160
  1023af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023b4:	e9 e2 f9 ff ff       	jmp    101d9b <__alltraps>

001023b9 <vector161>:
.globl vector161
vector161:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $161
  1023bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023c0:	e9 d6 f9 ff ff       	jmp    101d9b <__alltraps>

001023c5 <vector162>:
.globl vector162
vector162:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $162
  1023c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023cc:	e9 ca f9 ff ff       	jmp    101d9b <__alltraps>

001023d1 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $163
  1023d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023d8:	e9 be f9 ff ff       	jmp    101d9b <__alltraps>

001023dd <vector164>:
.globl vector164
vector164:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $164
  1023df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023e4:	e9 b2 f9 ff ff       	jmp    101d9b <__alltraps>

001023e9 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $165
  1023eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023f0:	e9 a6 f9 ff ff       	jmp    101d9b <__alltraps>

001023f5 <vector166>:
.globl vector166
vector166:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $166
  1023f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023fc:	e9 9a f9 ff ff       	jmp    101d9b <__alltraps>

00102401 <vector167>:
.globl vector167
vector167:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $167
  102403:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102408:	e9 8e f9 ff ff       	jmp    101d9b <__alltraps>

0010240d <vector168>:
.globl vector168
vector168:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $168
  10240f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102414:	e9 82 f9 ff ff       	jmp    101d9b <__alltraps>

00102419 <vector169>:
.globl vector169
vector169:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $169
  10241b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102420:	e9 76 f9 ff ff       	jmp    101d9b <__alltraps>

00102425 <vector170>:
.globl vector170
vector170:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $170
  102427:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10242c:	e9 6a f9 ff ff       	jmp    101d9b <__alltraps>

00102431 <vector171>:
.globl vector171
vector171:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $171
  102433:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102438:	e9 5e f9 ff ff       	jmp    101d9b <__alltraps>

0010243d <vector172>:
.globl vector172
vector172:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $172
  10243f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102444:	e9 52 f9 ff ff       	jmp    101d9b <__alltraps>

00102449 <vector173>:
.globl vector173
vector173:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $173
  10244b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102450:	e9 46 f9 ff ff       	jmp    101d9b <__alltraps>

00102455 <vector174>:
.globl vector174
vector174:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $174
  102457:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10245c:	e9 3a f9 ff ff       	jmp    101d9b <__alltraps>

00102461 <vector175>:
.globl vector175
vector175:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $175
  102463:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102468:	e9 2e f9 ff ff       	jmp    101d9b <__alltraps>

0010246d <vector176>:
.globl vector176
vector176:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $176
  10246f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102474:	e9 22 f9 ff ff       	jmp    101d9b <__alltraps>

00102479 <vector177>:
.globl vector177
vector177:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $177
  10247b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102480:	e9 16 f9 ff ff       	jmp    101d9b <__alltraps>

00102485 <vector178>:
.globl vector178
vector178:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $178
  102487:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10248c:	e9 0a f9 ff ff       	jmp    101d9b <__alltraps>

00102491 <vector179>:
.globl vector179
vector179:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $179
  102493:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102498:	e9 fe f8 ff ff       	jmp    101d9b <__alltraps>

0010249d <vector180>:
.globl vector180
vector180:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $180
  10249f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024a4:	e9 f2 f8 ff ff       	jmp    101d9b <__alltraps>

001024a9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $181
  1024ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024b0:	e9 e6 f8 ff ff       	jmp    101d9b <__alltraps>

001024b5 <vector182>:
.globl vector182
vector182:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $182
  1024b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024bc:	e9 da f8 ff ff       	jmp    101d9b <__alltraps>

001024c1 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $183
  1024c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024c8:	e9 ce f8 ff ff       	jmp    101d9b <__alltraps>

001024cd <vector184>:
.globl vector184
vector184:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $184
  1024cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024d4:	e9 c2 f8 ff ff       	jmp    101d9b <__alltraps>

001024d9 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $185
  1024db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024e0:	e9 b6 f8 ff ff       	jmp    101d9b <__alltraps>

001024e5 <vector186>:
.globl vector186
vector186:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $186
  1024e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024ec:	e9 aa f8 ff ff       	jmp    101d9b <__alltraps>

001024f1 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $187
  1024f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024f8:	e9 9e f8 ff ff       	jmp    101d9b <__alltraps>

001024fd <vector188>:
.globl vector188
vector188:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $188
  1024ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102504:	e9 92 f8 ff ff       	jmp    101d9b <__alltraps>

00102509 <vector189>:
.globl vector189
vector189:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $189
  10250b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102510:	e9 86 f8 ff ff       	jmp    101d9b <__alltraps>

00102515 <vector190>:
.globl vector190
vector190:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $190
  102517:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10251c:	e9 7a f8 ff ff       	jmp    101d9b <__alltraps>

00102521 <vector191>:
.globl vector191
vector191:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $191
  102523:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102528:	e9 6e f8 ff ff       	jmp    101d9b <__alltraps>

0010252d <vector192>:
.globl vector192
vector192:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $192
  10252f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102534:	e9 62 f8 ff ff       	jmp    101d9b <__alltraps>

00102539 <vector193>:
.globl vector193
vector193:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $193
  10253b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102540:	e9 56 f8 ff ff       	jmp    101d9b <__alltraps>

00102545 <vector194>:
.globl vector194
vector194:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $194
  102547:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10254c:	e9 4a f8 ff ff       	jmp    101d9b <__alltraps>

00102551 <vector195>:
.globl vector195
vector195:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $195
  102553:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102558:	e9 3e f8 ff ff       	jmp    101d9b <__alltraps>

0010255d <vector196>:
.globl vector196
vector196:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $196
  10255f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102564:	e9 32 f8 ff ff       	jmp    101d9b <__alltraps>

00102569 <vector197>:
.globl vector197
vector197:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $197
  10256b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102570:	e9 26 f8 ff ff       	jmp    101d9b <__alltraps>

00102575 <vector198>:
.globl vector198
vector198:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $198
  102577:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10257c:	e9 1a f8 ff ff       	jmp    101d9b <__alltraps>

00102581 <vector199>:
.globl vector199
vector199:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $199
  102583:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102588:	e9 0e f8 ff ff       	jmp    101d9b <__alltraps>

0010258d <vector200>:
.globl vector200
vector200:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $200
  10258f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102594:	e9 02 f8 ff ff       	jmp    101d9b <__alltraps>

00102599 <vector201>:
.globl vector201
vector201:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $201
  10259b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025a0:	e9 f6 f7 ff ff       	jmp    101d9b <__alltraps>

001025a5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $202
  1025a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025ac:	e9 ea f7 ff ff       	jmp    101d9b <__alltraps>

001025b1 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $203
  1025b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025b8:	e9 de f7 ff ff       	jmp    101d9b <__alltraps>

001025bd <vector204>:
.globl vector204
vector204:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $204
  1025bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025c4:	e9 d2 f7 ff ff       	jmp    101d9b <__alltraps>

001025c9 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $205
  1025cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025d0:	e9 c6 f7 ff ff       	jmp    101d9b <__alltraps>

001025d5 <vector206>:
.globl vector206
vector206:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $206
  1025d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025dc:	e9 ba f7 ff ff       	jmp    101d9b <__alltraps>

001025e1 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $207
  1025e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025e8:	e9 ae f7 ff ff       	jmp    101d9b <__alltraps>

001025ed <vector208>:
.globl vector208
vector208:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $208
  1025ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025f4:	e9 a2 f7 ff ff       	jmp    101d9b <__alltraps>

001025f9 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $209
  1025fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102600:	e9 96 f7 ff ff       	jmp    101d9b <__alltraps>

00102605 <vector210>:
.globl vector210
vector210:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $210
  102607:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10260c:	e9 8a f7 ff ff       	jmp    101d9b <__alltraps>

00102611 <vector211>:
.globl vector211
vector211:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $211
  102613:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102618:	e9 7e f7 ff ff       	jmp    101d9b <__alltraps>

0010261d <vector212>:
.globl vector212
vector212:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $212
  10261f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102624:	e9 72 f7 ff ff       	jmp    101d9b <__alltraps>

00102629 <vector213>:
.globl vector213
vector213:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $213
  10262b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102630:	e9 66 f7 ff ff       	jmp    101d9b <__alltraps>

00102635 <vector214>:
.globl vector214
vector214:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $214
  102637:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10263c:	e9 5a f7 ff ff       	jmp    101d9b <__alltraps>

00102641 <vector215>:
.globl vector215
vector215:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $215
  102643:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102648:	e9 4e f7 ff ff       	jmp    101d9b <__alltraps>

0010264d <vector216>:
.globl vector216
vector216:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $216
  10264f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102654:	e9 42 f7 ff ff       	jmp    101d9b <__alltraps>

00102659 <vector217>:
.globl vector217
vector217:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $217
  10265b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102660:	e9 36 f7 ff ff       	jmp    101d9b <__alltraps>

00102665 <vector218>:
.globl vector218
vector218:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $218
  102667:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10266c:	e9 2a f7 ff ff       	jmp    101d9b <__alltraps>

00102671 <vector219>:
.globl vector219
vector219:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $219
  102673:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102678:	e9 1e f7 ff ff       	jmp    101d9b <__alltraps>

0010267d <vector220>:
.globl vector220
vector220:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $220
  10267f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102684:	e9 12 f7 ff ff       	jmp    101d9b <__alltraps>

00102689 <vector221>:
.globl vector221
vector221:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $221
  10268b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102690:	e9 06 f7 ff ff       	jmp    101d9b <__alltraps>

00102695 <vector222>:
.globl vector222
vector222:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $222
  102697:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10269c:	e9 fa f6 ff ff       	jmp    101d9b <__alltraps>

001026a1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $223
  1026a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026a8:	e9 ee f6 ff ff       	jmp    101d9b <__alltraps>

001026ad <vector224>:
.globl vector224
vector224:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $224
  1026af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026b4:	e9 e2 f6 ff ff       	jmp    101d9b <__alltraps>

001026b9 <vector225>:
.globl vector225
vector225:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $225
  1026bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026c0:	e9 d6 f6 ff ff       	jmp    101d9b <__alltraps>

001026c5 <vector226>:
.globl vector226
vector226:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $226
  1026c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026cc:	e9 ca f6 ff ff       	jmp    101d9b <__alltraps>

001026d1 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $227
  1026d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026d8:	e9 be f6 ff ff       	jmp    101d9b <__alltraps>

001026dd <vector228>:
.globl vector228
vector228:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $228
  1026df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026e4:	e9 b2 f6 ff ff       	jmp    101d9b <__alltraps>

001026e9 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $229
  1026eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026f0:	e9 a6 f6 ff ff       	jmp    101d9b <__alltraps>

001026f5 <vector230>:
.globl vector230
vector230:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $230
  1026f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026fc:	e9 9a f6 ff ff       	jmp    101d9b <__alltraps>

00102701 <vector231>:
.globl vector231
vector231:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $231
  102703:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102708:	e9 8e f6 ff ff       	jmp    101d9b <__alltraps>

0010270d <vector232>:
.globl vector232
vector232:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $232
  10270f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102714:	e9 82 f6 ff ff       	jmp    101d9b <__alltraps>

00102719 <vector233>:
.globl vector233
vector233:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $233
  10271b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102720:	e9 76 f6 ff ff       	jmp    101d9b <__alltraps>

00102725 <vector234>:
.globl vector234
vector234:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $234
  102727:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10272c:	e9 6a f6 ff ff       	jmp    101d9b <__alltraps>

00102731 <vector235>:
.globl vector235
vector235:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $235
  102733:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102738:	e9 5e f6 ff ff       	jmp    101d9b <__alltraps>

0010273d <vector236>:
.globl vector236
vector236:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $236
  10273f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102744:	e9 52 f6 ff ff       	jmp    101d9b <__alltraps>

00102749 <vector237>:
.globl vector237
vector237:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $237
  10274b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102750:	e9 46 f6 ff ff       	jmp    101d9b <__alltraps>

00102755 <vector238>:
.globl vector238
vector238:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $238
  102757:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10275c:	e9 3a f6 ff ff       	jmp    101d9b <__alltraps>

00102761 <vector239>:
.globl vector239
vector239:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $239
  102763:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102768:	e9 2e f6 ff ff       	jmp    101d9b <__alltraps>

0010276d <vector240>:
.globl vector240
vector240:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $240
  10276f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102774:	e9 22 f6 ff ff       	jmp    101d9b <__alltraps>

00102779 <vector241>:
.globl vector241
vector241:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $241
  10277b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102780:	e9 16 f6 ff ff       	jmp    101d9b <__alltraps>

00102785 <vector242>:
.globl vector242
vector242:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $242
  102787:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10278c:	e9 0a f6 ff ff       	jmp    101d9b <__alltraps>

00102791 <vector243>:
.globl vector243
vector243:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $243
  102793:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102798:	e9 fe f5 ff ff       	jmp    101d9b <__alltraps>

0010279d <vector244>:
.globl vector244
vector244:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $244
  10279f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027a4:	e9 f2 f5 ff ff       	jmp    101d9b <__alltraps>

001027a9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $245
  1027ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027b0:	e9 e6 f5 ff ff       	jmp    101d9b <__alltraps>

001027b5 <vector246>:
.globl vector246
vector246:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $246
  1027b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027bc:	e9 da f5 ff ff       	jmp    101d9b <__alltraps>

001027c1 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $247
  1027c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027c8:	e9 ce f5 ff ff       	jmp    101d9b <__alltraps>

001027cd <vector248>:
.globl vector248
vector248:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $248
  1027cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027d4:	e9 c2 f5 ff ff       	jmp    101d9b <__alltraps>

001027d9 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $249
  1027db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027e0:	e9 b6 f5 ff ff       	jmp    101d9b <__alltraps>

001027e5 <vector250>:
.globl vector250
vector250:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $250
  1027e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027ec:	e9 aa f5 ff ff       	jmp    101d9b <__alltraps>

001027f1 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $251
  1027f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027f8:	e9 9e f5 ff ff       	jmp    101d9b <__alltraps>

001027fd <vector252>:
.globl vector252
vector252:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $252
  1027ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102804:	e9 92 f5 ff ff       	jmp    101d9b <__alltraps>

00102809 <vector253>:
.globl vector253
vector253:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $253
  10280b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102810:	e9 86 f5 ff ff       	jmp    101d9b <__alltraps>

00102815 <vector254>:
.globl vector254
vector254:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $254
  102817:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10281c:	e9 7a f5 ff ff       	jmp    101d9b <__alltraps>

00102821 <vector255>:
.globl vector255
vector255:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $255
  102823:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102828:	e9 6e f5 ff ff       	jmp    101d9b <__alltraps>

0010282d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10282d:	55                   	push   %ebp
  10282e:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102830:	8b 55 08             	mov    0x8(%ebp),%edx
  102833:	a1 64 89 11 00       	mov    0x118964,%eax
  102838:	29 c2                	sub    %eax,%edx
  10283a:	89 d0                	mov    %edx,%eax
  10283c:	c1 f8 02             	sar    $0x2,%eax
  10283f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102845:	5d                   	pop    %ebp
  102846:	c3                   	ret    

00102847 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102847:	55                   	push   %ebp
  102848:	89 e5                	mov    %esp,%ebp
  10284a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10284d:	8b 45 08             	mov    0x8(%ebp),%eax
  102850:	89 04 24             	mov    %eax,(%esp)
  102853:	e8 d5 ff ff ff       	call   10282d <page2ppn>
  102858:	c1 e0 0c             	shl    $0xc,%eax
}
  10285b:	c9                   	leave  
  10285c:	c3                   	ret    

0010285d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10285d:	55                   	push   %ebp
  10285e:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102860:	8b 45 08             	mov    0x8(%ebp),%eax
  102863:	8b 00                	mov    (%eax),%eax
}
  102865:	5d                   	pop    %ebp
  102866:	c3                   	ret    

00102867 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102867:	55                   	push   %ebp
  102868:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10286a:	8b 45 08             	mov    0x8(%ebp),%eax
  10286d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102870:	89 10                	mov    %edx,(%eax)
}
  102872:	5d                   	pop    %ebp
  102873:	c3                   	ret    

00102874 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102874:	55                   	push   %ebp
  102875:	89 e5                	mov    %esp,%ebp
  102877:	83 ec 10             	sub    $0x10,%esp
  10287a:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102881:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102884:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102887:	89 50 04             	mov    %edx,0x4(%eax)
  10288a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10288d:	8b 50 04             	mov    0x4(%eax),%edx
  102890:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102893:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102895:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10289c:	00 00 00 
}
  10289f:	c9                   	leave  
  1028a0:	c3                   	ret    

001028a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1028a1:	55                   	push   %ebp
  1028a2:	89 e5                	mov    %esp,%ebp
  1028a4:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1028a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1028ab:	75 24                	jne    1028d1 <default_init_memmap+0x30>
  1028ad:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  1028b4:	00 
  1028b5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1028bc:	00 
  1028bd:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1028c4:	00 
  1028c5:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1028cc:	e8 f5 e3 ff ff       	call   100cc6 <__panic>
    struct Page *p = base;
  1028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1028d7:	e9 de 00 00 00       	jmp    1029ba <default_init_memmap+0x119>
        assert(PageReserved(p));
  1028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028df:	83 c0 04             	add    $0x4,%eax
  1028e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1028e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1028f2:	0f a3 10             	bt     %edx,(%eax)
  1028f5:	19 c0                	sbb    %eax,%eax
  1028f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1028fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1028fe:	0f 95 c0             	setne  %al
  102901:	0f b6 c0             	movzbl %al,%eax
  102904:	85 c0                	test   %eax,%eax
  102906:	75 24                	jne    10292c <default_init_memmap+0x8b>
  102908:	c7 44 24 0c 21 66 10 	movl   $0x106621,0xc(%esp)
  10290f:	00 
  102910:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102917:	00 
  102918:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  10291f:	00 
  102920:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102927:	e8 9a e3 ff ff       	call   100cc6 <__panic>
        p->flags = p->property = 0;
  10292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10292f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102939:	8b 50 08             	mov    0x8(%eax),%edx
  10293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10293f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102942:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102949:	00 
  10294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10294d:	89 04 24             	mov    %eax,(%esp)
  102950:	e8 12 ff ff ff       	call   102867 <set_page_ref>
        SetPageProperty(p);
  102955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102958:	83 c0 04             	add    $0x4,%eax
  10295b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102962:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102965:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102968:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10296b:	0f ab 10             	bts    %edx,(%eax)

        list_add_before(&free_list, &(p->page_link));
  10296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102971:	83 c0 0c             	add    $0xc,%eax
  102974:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  10297b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  10297e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102981:	8b 00                	mov    (%eax),%eax
  102983:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102986:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102989:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10298c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10298f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102995:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102998:	89 10                	mov    %edx,(%eax)
  10299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10299d:	8b 10                	mov    (%eax),%edx
  10299f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1029a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1029ab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1029ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029b4:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  1029b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1029ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029bd:	89 d0                	mov    %edx,%eax
  1029bf:	c1 e0 02             	shl    $0x2,%eax
  1029c2:	01 d0                	add    %edx,%eax
  1029c4:	c1 e0 02             	shl    $0x2,%eax
  1029c7:	89 c2                	mov    %eax,%edx
  1029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1029cc:	01 d0                	add    %edx,%eax
  1029ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1029d1:	0f 85 05 ff ff ff    	jne    1028dc <default_init_memmap+0x3b>
        set_page_ref(p, 0);
        SetPageProperty(p);

        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	8b 55 0c             	mov    0xc(%ebp),%edx
  1029dd:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  1029e0:	8b 15 58 89 11 00    	mov    0x118958,%edx
  1029e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029e9:	01 d0                	add    %edx,%eax
  1029eb:	a3 58 89 11 00       	mov    %eax,0x118958
}
  1029f0:	c9                   	leave  
  1029f1:	c3                   	ret    

001029f2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1029f2:	55                   	push   %ebp
  1029f3:	89 e5                	mov    %esp,%ebp
  1029f5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029fc:	75 24                	jne    102a22 <default_alloc_pages+0x30>
  1029fe:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  102a05:	00 
  102a06:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102a0d:	00 
  102a0e:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102a15:	00 
  102a16:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102a1d:	e8 a4 e2 ff ff       	call   100cc6 <__panic>
    if (n > nr_free) {
  102a22:	a1 58 89 11 00       	mov    0x118958,%eax
  102a27:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a2a:	73 0a                	jae    102a36 <default_alloc_pages+0x44>
        return NULL;
  102a2c:	b8 00 00 00 00       	mov    $0x0,%eax
  102a31:	e9 3e 01 00 00       	jmp    102b74 <default_alloc_pages+0x182>
    }

    list_entry_t *le, *nextle;
    le = &free_list;
  102a36:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)

    struct Page *p, *pp;
    while ((le = list_next(le)) != &free_list){
  102a3d:	e9 11 01 00 00       	jmp    102b53 <default_alloc_pages+0x161>
    	p =  le2page(le, page_link);
  102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a45:	83 e8 0c             	sub    $0xc,%eax
  102a48:	89 45 ec             	mov    %eax,-0x14(%ebp)

    	if (p -> property>= n) {
  102a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102a4e:	8b 40 08             	mov    0x8(%eax),%eax
  102a51:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a54:	0f 82 f9 00 00 00    	jb     102b53 <default_alloc_pages+0x161>
    			int i= 0;
  102a5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    			for (i=0; i < n; i++){
  102a61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102a68:	eb 7c                	jmp    102ae6 <default_alloc_pages+0xf4>
  102a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a73:	8b 40 04             	mov    0x4(%eax),%eax
    				nextle = list_next(le);
  102a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
    				pp = le2page(le, page_link);
  102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7c:	83 e8 0c             	sub    $0xc,%eax
  102a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    				SetPageReserved(pp);
  102a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a85:	83 c0 04             	add    $0x4,%eax
  102a88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102a8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a92:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a98:	0f ab 10             	bts    %edx,(%eax)
    				ClearPageProperty(pp);
  102a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102a9e:	83 c0 04             	add    $0x4,%eax
  102aa1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102aab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102aae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ab1:	0f b3 10             	btr    %edx,(%eax)
  102ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ab7:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102abd:	8b 40 04             	mov    0x4(%eax),%eax
  102ac0:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102ac3:	8b 12                	mov    (%edx),%edx
  102ac5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ac8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102acb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102ace:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102ad1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102ad4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102ad7:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102ada:	89 10                	mov    %edx,(%eax)
    				list_del(le);
    				le = nextle;
  102adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list){
    	p =  le2page(le, page_link);

    	if (p -> property>= n) {
    			int i= 0;
    			for (i=0; i < n; i++){
  102ae2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ae9:	3b 45 08             	cmp    0x8(%ebp),%eax
  102aec:	0f 82 78 ff ff ff    	jb     102a6a <default_alloc_pages+0x78>
    				SetPageReserved(pp);
    				ClearPageProperty(pp);
    				list_del(le);
    				le = nextle;
    			}
    			if (p->property > n){
  102af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102af5:	8b 40 08             	mov    0x8(%eax),%eax
  102af8:	3b 45 08             	cmp    0x8(%ebp),%eax
  102afb:	76 12                	jbe    102b0f <default_alloc_pages+0x11d>
    				(le2page(le, page_link))->property = p->property - n;
  102afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b00:	8d 50 f4             	lea    -0xc(%eax),%edx
  102b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b06:	8b 40 08             	mov    0x8(%eax),%eax
  102b09:	2b 45 08             	sub    0x8(%ebp),%eax
  102b0c:	89 42 08             	mov    %eax,0x8(%edx)
    			}
    			ClearPageProperty(p);
  102b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b12:	83 c0 04             	add    $0x4,%eax
  102b15:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102b1c:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102b1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b22:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102b25:	0f b3 10             	btr    %edx,(%eax)
    			SetPageReserved(p);
  102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b2b:	83 c0 04             	add    $0x4,%eax
  102b2e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102b35:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b3b:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b3e:	0f ab 10             	bts    %edx,(%eax)
    			nr_free -= n;
  102b41:	a1 58 89 11 00       	mov    0x118958,%eax
  102b46:	2b 45 08             	sub    0x8(%ebp),%eax
  102b49:	a3 58 89 11 00       	mov    %eax,0x118958
    			return p;
  102b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b51:	eb 21                	jmp    102b74 <default_alloc_pages+0x182>
  102b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b56:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b59:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102b5c:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le, *nextle;
    le = &free_list;

    struct Page *p, *pp;
    while ((le = list_next(le)) != &free_list){
  102b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b62:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102b69:	0f 85 d3 fe ff ff    	jne    102a42 <default_alloc_pages+0x50>
    			SetPageReserved(p);
    			nr_free -= n;
    			return p;
    			}
    	}
    return NULL;
  102b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b74:	c9                   	leave  
  102b75:	c3                   	ret    

00102b76 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102b76:	55                   	push   %ebp
  102b77:	89 e5                	mov    %esp,%ebp
  102b79:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b80:	75 24                	jne    102ba6 <default_free_pages+0x30>
  102b82:	c7 44 24 0c f0 65 10 	movl   $0x1065f0,0xc(%esp)
  102b89:	00 
  102b8a:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102b91:	00 
  102b92:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  102b99:	00 
  102b9a:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102ba1:	e8 20 e1 ff ff       	call   100cc6 <__panic>

    list_entry_t *le = &free_list;
  102ba6:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    list_entry_t *bef;

    struct Page* p;
    while ((le = list_next(le)) != &free_list){
  102bad:	eb 13                	jmp    102bc2 <default_free_pages+0x4c>
    	p = le2page(le, page_link);
  102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb2:	83 e8 0c             	sub    $0xc,%eax
  102bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	if (p > base) break;
  102bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bbb:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bbe:	76 02                	jbe    102bc2 <default_free_pages+0x4c>
  102bc0:	eb 18                	jmp    102bda <default_free_pages+0x64>
  102bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bcb:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = &free_list;
    list_entry_t *bef;

    struct Page* p;
    while ((le = list_next(le)) != &free_list){
  102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bd1:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102bd8:	75 d5                	jne    102baf <default_free_pages+0x39>
    	p = le2page(le, page_link);
    	if (p > base) break;
    }

    for (p = base; p< base+n; p++){
  102bda:	8b 45 08             	mov    0x8(%ebp),%eax
  102bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102be0:	eb 4b                	jmp    102c2d <default_free_pages+0xb7>
    	list_add_before(le, &(p->page_link));
  102be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be5:	8d 50 0c             	lea    0xc(%eax),%edx
  102be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102bee:	89 55 e0             	mov    %edx,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102bf4:	8b 00                	mov    (%eax),%eax
  102bf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102bf9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102bfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c02:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c08:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c0b:	89 10                	mov    %edx,(%eax)
  102c0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102c10:	8b 10                	mov    (%eax),%edx
  102c12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c15:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102c18:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c1e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c24:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102c27:	89 10                	mov    %edx,(%eax)
    while ((le = list_next(le)) != &free_list){
    	p = le2page(le, page_link);
    	if (p > base) break;
    }

    for (p = base; p< base+n; p++){
  102c29:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c30:	89 d0                	mov    %edx,%eax
  102c32:	c1 e0 02             	shl    $0x2,%eax
  102c35:	01 d0                	add    %edx,%eax
  102c37:	c1 e0 02             	shl    $0x2,%eax
  102c3a:	89 c2                	mov    %eax,%edx
  102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3f:	01 d0                	add    %edx,%eax
  102c41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102c44:	77 9c                	ja     102be2 <default_free_pages+0x6c>
    	list_add_before(le, &(p->page_link));
    }

    base ->flags = 0;
  102c46:	8b 45 08             	mov    0x8(%ebp),%eax
  102c49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102c50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c57:	00 
  102c58:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5b:	89 04 24             	mov    %eax,(%esp)
  102c5e:	e8 04 fc ff ff       	call   102867 <set_page_ref>
    ClearPageReserved(base);		//
  102c63:	8b 45 08             	mov    0x8(%ebp),%eax
  102c66:	83 c0 04             	add    $0x4,%eax
  102c69:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  102c70:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102c76:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102c79:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7f:	83 c0 04             	add    $0x4,%eax
  102c82:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102c89:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c8c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102c8f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102c92:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102c95:	8b 45 08             	mov    0x8(%ebp),%eax
  102c98:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c9b:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le, page_link);
  102c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca1:	83 e8 0c             	sub    $0xc,%eax
  102ca4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (base + n == p){
  102ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102caa:	89 d0                	mov    %edx,%eax
  102cac:	c1 e0 02             	shl    $0x2,%eax
  102caf:	01 d0                	add    %edx,%eax
  102cb1:	c1 e0 02             	shl    $0x2,%eax
  102cb4:	89 c2                	mov    %eax,%edx
  102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb9:	01 d0                	add    %edx,%eax
  102cbb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102cbe:	75 1e                	jne    102cde <default_free_pages+0x168>
    	base->property += p->property;
  102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc3:	8b 50 08             	mov    0x8(%eax),%edx
  102cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cc9:	8b 40 08             	mov    0x8(%eax),%eax
  102ccc:	01 c2                	add    %eax,%edx
  102cce:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd1:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
  102cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    bef = list_prev(&(base->page_link));
  102cde:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce1:	83 c0 0c             	add    $0xc,%eax
  102ce4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102ce7:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102cea:	8b 00                	mov    (%eax),%eax
  102cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(bef, page_link);
  102cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cf2:	83 e8 0c             	sub    $0xc,%eax
  102cf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (bef != &free_list && p == base-1){
  102cf8:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102cff:	74 57                	je     102d58 <default_free_pages+0x1e2>
  102d01:	8b 45 08             	mov    0x8(%ebp),%eax
  102d04:	83 e8 14             	sub    $0x14,%eax
  102d07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102d0a:	75 4c                	jne    102d58 <default_free_pages+0x1e2>
    		while (bef != &free_list){
  102d0c:	eb 41                	jmp    102d4f <default_free_pages+0x1d9>
    			if (p -> property != 0){
  102d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d11:	8b 40 08             	mov    0x8(%eax),%eax
  102d14:	85 c0                	test   %eax,%eax
  102d16:	74 20                	je     102d38 <default_free_pages+0x1c2>
    				p->property += base->property;
  102d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d1b:	8b 50 08             	mov    0x8(%eax),%edx
  102d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d21:	8b 40 08             	mov    0x8(%eax),%eax
  102d24:	01 c2                	add    %eax,%edx
  102d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d29:	89 50 08             	mov    %edx,0x8(%eax)
    				base->property = 0;
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    				break;
  102d36:	eb 20                	jmp    102d58 <default_free_pages+0x1e2>
  102d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d3b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102d3e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d41:	8b 00                	mov    (%eax),%eax
    			}
    			bef = list_prev(bef);
  102d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    			p = le2page(bef, page_link);
  102d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d49:	83 e8 0c             	sub    $0xc,%eax
  102d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    }

    bef = list_prev(&(base->page_link));
    p = le2page(bef, page_link);
    if (bef != &free_list && p == base-1){
    		while (bef != &free_list){
  102d4f:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d56:	75 b6                	jne    102d0e <default_free_pages+0x198>
    			}
    			bef = list_prev(bef);
    			p = le2page(bef, page_link);
    		}
    }
    nr_free += n;
  102d58:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d61:	01 d0                	add    %edx,%eax
  102d63:	a3 58 89 11 00       	mov    %eax,0x118958
    return;
  102d68:	90                   	nop
}
  102d69:	c9                   	leave  
  102d6a:	c3                   	ret    

00102d6b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102d6b:	55                   	push   %ebp
  102d6c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102d6e:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102d73:	5d                   	pop    %ebp
  102d74:	c3                   	ret    

00102d75 <basic_check>:

static void
basic_check(void) {
  102d75:	55                   	push   %ebp
  102d76:	89 e5                	mov    %esp,%ebp
  102d78:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102d7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102d8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102d95:	e8 85 0e 00 00       	call   103c1f <alloc_pages>
  102d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102da1:	75 24                	jne    102dc7 <basic_check+0x52>
  102da3:	c7 44 24 0c 31 66 10 	movl   $0x106631,0xc(%esp)
  102daa:	00 
  102dab:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102db2:	00 
  102db3:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102dba:	00 
  102dbb:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102dc2:	e8 ff de ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  102dc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102dce:	e8 4c 0e 00 00       	call   103c1f <alloc_pages>
  102dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102dda:	75 24                	jne    102e00 <basic_check+0x8b>
  102ddc:	c7 44 24 0c 4d 66 10 	movl   $0x10664d,0xc(%esp)
  102de3:	00 
  102de4:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102deb:	00 
  102dec:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102df3:	00 
  102df4:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102dfb:	e8 c6 de ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  102e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e07:	e8 13 0e 00 00       	call   103c1f <alloc_pages>
  102e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102e13:	75 24                	jne    102e39 <basic_check+0xc4>
  102e15:	c7 44 24 0c 69 66 10 	movl   $0x106669,0xc(%esp)
  102e1c:	00 
  102e1d:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102e24:	00 
  102e25:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102e2c:	00 
  102e2d:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102e34:	e8 8d de ff ff       	call   100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e3f:	74 10                	je     102e51 <basic_check+0xdc>
  102e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e47:	74 08                	je     102e51 <basic_check+0xdc>
  102e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102e4f:	75 24                	jne    102e75 <basic_check+0x100>
  102e51:	c7 44 24 0c 88 66 10 	movl   $0x106688,0xc(%esp)
  102e58:	00 
  102e59:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102e60:	00 
  102e61:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102e68:	00 
  102e69:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102e70:	e8 51 de ff ff       	call   100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e78:	89 04 24             	mov    %eax,(%esp)
  102e7b:	e8 dd f9 ff ff       	call   10285d <page_ref>
  102e80:	85 c0                	test   %eax,%eax
  102e82:	75 1e                	jne    102ea2 <basic_check+0x12d>
  102e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e87:	89 04 24             	mov    %eax,(%esp)
  102e8a:	e8 ce f9 ff ff       	call   10285d <page_ref>
  102e8f:	85 c0                	test   %eax,%eax
  102e91:	75 0f                	jne    102ea2 <basic_check+0x12d>
  102e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e96:	89 04 24             	mov    %eax,(%esp)
  102e99:	e8 bf f9 ff ff       	call   10285d <page_ref>
  102e9e:	85 c0                	test   %eax,%eax
  102ea0:	74 24                	je     102ec6 <basic_check+0x151>
  102ea2:	c7 44 24 0c ac 66 10 	movl   $0x1066ac,0xc(%esp)
  102ea9:	00 
  102eaa:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102eb1:	00 
  102eb2:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102eb9:	00 
  102eba:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102ec1:	e8 00 de ff ff       	call   100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ec9:	89 04 24             	mov    %eax,(%esp)
  102ecc:	e8 76 f9 ff ff       	call   102847 <page2pa>
  102ed1:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102ed7:	c1 e2 0c             	shl    $0xc,%edx
  102eda:	39 d0                	cmp    %edx,%eax
  102edc:	72 24                	jb     102f02 <basic_check+0x18d>
  102ede:	c7 44 24 0c e8 66 10 	movl   $0x1066e8,0xc(%esp)
  102ee5:	00 
  102ee6:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102eed:	00 
  102eee:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102ef5:	00 
  102ef6:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102efd:	e8 c4 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f05:	89 04 24             	mov    %eax,(%esp)
  102f08:	e8 3a f9 ff ff       	call   102847 <page2pa>
  102f0d:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f13:	c1 e2 0c             	shl    $0xc,%edx
  102f16:	39 d0                	cmp    %edx,%eax
  102f18:	72 24                	jb     102f3e <basic_check+0x1c9>
  102f1a:	c7 44 24 0c 05 67 10 	movl   $0x106705,0xc(%esp)
  102f21:	00 
  102f22:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102f29:	00 
  102f2a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  102f31:	00 
  102f32:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102f39:	e8 88 dd ff ff       	call   100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f41:	89 04 24             	mov    %eax,(%esp)
  102f44:	e8 fe f8 ff ff       	call   102847 <page2pa>
  102f49:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f4f:	c1 e2 0c             	shl    $0xc,%edx
  102f52:	39 d0                	cmp    %edx,%eax
  102f54:	72 24                	jb     102f7a <basic_check+0x205>
  102f56:	c7 44 24 0c 22 67 10 	movl   $0x106722,0xc(%esp)
  102f5d:	00 
  102f5e:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102f65:	00 
  102f66:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  102f6d:	00 
  102f6e:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102f75:	e8 4c dd ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  102f7a:	a1 50 89 11 00       	mov    0x118950,%eax
  102f7f:	8b 15 54 89 11 00    	mov    0x118954,%edx
  102f85:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102f8b:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f95:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102f98:	89 50 04             	mov    %edx,0x4(%eax)
  102f9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f9e:	8b 50 04             	mov    0x4(%eax),%edx
  102fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa4:	89 10                	mov    %edx,(%eax)
  102fa6:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102fad:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fb0:	8b 40 04             	mov    0x4(%eax),%eax
  102fb3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fb6:	0f 94 c0             	sete   %al
  102fb9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102fbc:	85 c0                	test   %eax,%eax
  102fbe:	75 24                	jne    102fe4 <basic_check+0x26f>
  102fc0:	c7 44 24 0c 3f 67 10 	movl   $0x10673f,0xc(%esp)
  102fc7:	00 
  102fc8:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  102fcf:	00 
  102fd0:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  102fd7:	00 
  102fd8:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  102fdf:	e8 e2 dc ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  102fe4:	a1 58 89 11 00       	mov    0x118958,%eax
  102fe9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102fec:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102ff3:	00 00 00 

    assert(alloc_page() == NULL);
  102ff6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ffd:	e8 1d 0c 00 00       	call   103c1f <alloc_pages>
  103002:	85 c0                	test   %eax,%eax
  103004:	74 24                	je     10302a <basic_check+0x2b5>
  103006:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  10300d:	00 
  10300e:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103015:	00 
  103016:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  10301d:	00 
  10301e:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103025:	e8 9c dc ff ff       	call   100cc6 <__panic>

    free_page(p0);
  10302a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103031:	00 
  103032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103035:	89 04 24             	mov    %eax,(%esp)
  103038:	e8 1a 0c 00 00       	call   103c57 <free_pages>
    free_page(p1);
  10303d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103044:	00 
  103045:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103048:	89 04 24             	mov    %eax,(%esp)
  10304b:	e8 07 0c 00 00       	call   103c57 <free_pages>
    free_page(p2);
  103050:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103057:	00 
  103058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10305b:	89 04 24             	mov    %eax,(%esp)
  10305e:	e8 f4 0b 00 00       	call   103c57 <free_pages>
    assert(nr_free == 3);
  103063:	a1 58 89 11 00       	mov    0x118958,%eax
  103068:	83 f8 03             	cmp    $0x3,%eax
  10306b:	74 24                	je     103091 <basic_check+0x31c>
  10306d:	c7 44 24 0c 6b 67 10 	movl   $0x10676b,0xc(%esp)
  103074:	00 
  103075:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10307c:	00 
  10307d:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  103084:	00 
  103085:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10308c:	e8 35 dc ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
  103091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103098:	e8 82 0b 00 00       	call   103c1f <alloc_pages>
  10309d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1030a4:	75 24                	jne    1030ca <basic_check+0x355>
  1030a6:	c7 44 24 0c 31 66 10 	movl   $0x106631,0xc(%esp)
  1030ad:	00 
  1030ae:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1030b5:	00 
  1030b6:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1030bd:	00 
  1030be:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1030c5:	e8 fc db ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030d1:	e8 49 0b 00 00       	call   103c1f <alloc_pages>
  1030d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1030dd:	75 24                	jne    103103 <basic_check+0x38e>
  1030df:	c7 44 24 0c 4d 66 10 	movl   $0x10664d,0xc(%esp)
  1030e6:	00 
  1030e7:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1030ee:	00 
  1030ef:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1030f6:	00 
  1030f7:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1030fe:	e8 c3 db ff ff       	call   100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10310a:	e8 10 0b 00 00       	call   103c1f <alloc_pages>
  10310f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103116:	75 24                	jne    10313c <basic_check+0x3c7>
  103118:	c7 44 24 0c 69 66 10 	movl   $0x106669,0xc(%esp)
  10311f:	00 
  103120:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103127:	00 
  103128:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  10312f:	00 
  103130:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103137:	e8 8a db ff ff       	call   100cc6 <__panic>

    assert(alloc_page() == NULL);
  10313c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103143:	e8 d7 0a 00 00       	call   103c1f <alloc_pages>
  103148:	85 c0                	test   %eax,%eax
  10314a:	74 24                	je     103170 <basic_check+0x3fb>
  10314c:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103153:	00 
  103154:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10315b:	00 
  10315c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  103163:	00 
  103164:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10316b:	e8 56 db ff ff       	call   100cc6 <__panic>

    free_page(p0);
  103170:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103177:	00 
  103178:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10317b:	89 04 24             	mov    %eax,(%esp)
  10317e:	e8 d4 0a 00 00       	call   103c57 <free_pages>
  103183:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10318a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10318d:	8b 40 04             	mov    0x4(%eax),%eax
  103190:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103193:	0f 94 c0             	sete   %al
  103196:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103199:	85 c0                	test   %eax,%eax
  10319b:	74 24                	je     1031c1 <basic_check+0x44c>
  10319d:	c7 44 24 0c 78 67 10 	movl   $0x106778,0xc(%esp)
  1031a4:	00 
  1031a5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1031ac:	00 
  1031ad:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  1031b4:	00 
  1031b5:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1031bc:	e8 05 db ff ff       	call   100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1031c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031c8:	e8 52 0a 00 00       	call   103c1f <alloc_pages>
  1031cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1031d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1031d6:	74 24                	je     1031fc <basic_check+0x487>
  1031d8:	c7 44 24 0c 90 67 10 	movl   $0x106790,0xc(%esp)
  1031df:	00 
  1031e0:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1031e7:	00 
  1031e8:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1031ef:	00 
  1031f0:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1031f7:	e8 ca da ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1031fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103203:	e8 17 0a 00 00       	call   103c1f <alloc_pages>
  103208:	85 c0                	test   %eax,%eax
  10320a:	74 24                	je     103230 <basic_check+0x4bb>
  10320c:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103213:	00 
  103214:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10321b:	00 
  10321c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  103223:	00 
  103224:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10322b:	e8 96 da ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  103230:	a1 58 89 11 00       	mov    0x118958,%eax
  103235:	85 c0                	test   %eax,%eax
  103237:	74 24                	je     10325d <basic_check+0x4e8>
  103239:	c7 44 24 0c a9 67 10 	movl   $0x1067a9,0xc(%esp)
  103240:	00 
  103241:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103248:	00 
  103249:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  103250:	00 
  103251:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103258:	e8 69 da ff ff       	call   100cc6 <__panic>
    free_list = free_list_store;
  10325d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103260:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103263:	a3 50 89 11 00       	mov    %eax,0x118950
  103268:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103271:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103276:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10327d:	00 
  10327e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103281:	89 04 24             	mov    %eax,(%esp)
  103284:	e8 ce 09 00 00       	call   103c57 <free_pages>
    free_page(p1);
  103289:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103290:	00 
  103291:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103294:	89 04 24             	mov    %eax,(%esp)
  103297:	e8 bb 09 00 00       	call   103c57 <free_pages>
    free_page(p2);
  10329c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1032a3:	00 
  1032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032a7:	89 04 24             	mov    %eax,(%esp)
  1032aa:	e8 a8 09 00 00       	call   103c57 <free_pages>
}
  1032af:	c9                   	leave  
  1032b0:	c3                   	ret    

001032b1 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1032b1:	55                   	push   %ebp
  1032b2:	89 e5                	mov    %esp,%ebp
  1032b4:	53                   	push   %ebx
  1032b5:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1032bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1032c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1032c9:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1032d0:	eb 6b                	jmp    10333d <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032d5:	83 e8 0c             	sub    $0xc,%eax
  1032d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032de:	83 c0 04             	add    $0x4,%eax
  1032e1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1032e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1032eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1032ee:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1032f1:	0f a3 10             	bt     %edx,(%eax)
  1032f4:	19 c0                	sbb    %eax,%eax
  1032f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1032f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1032fd:	0f 95 c0             	setne  %al
  103300:	0f b6 c0             	movzbl %al,%eax
  103303:	85 c0                	test   %eax,%eax
  103305:	75 24                	jne    10332b <default_check+0x7a>
  103307:	c7 44 24 0c b6 67 10 	movl   $0x1067b6,0xc(%esp)
  10330e:	00 
  10330f:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103316:	00 
  103317:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10331e:	00 
  10331f:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103326:	e8 9b d9 ff ff       	call   100cc6 <__panic>
        count ++, total += p->property;
  10332b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103332:	8b 50 08             	mov    0x8(%eax),%edx
  103335:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103338:	01 d0                	add    %edx,%eax
  10333a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10333d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103340:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103343:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103346:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103349:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10334c:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  103353:	0f 85 79 ff ff ff    	jne    1032d2 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103359:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  10335c:	e8 28 09 00 00       	call   103c89 <nr_free_pages>
  103361:	39 c3                	cmp    %eax,%ebx
  103363:	74 24                	je     103389 <default_check+0xd8>
  103365:	c7 44 24 0c c6 67 10 	movl   $0x1067c6,0xc(%esp)
  10336c:	00 
  10336d:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103374:	00 
  103375:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  10337c:	00 
  10337d:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103384:	e8 3d d9 ff ff       	call   100cc6 <__panic>

    basic_check();
  103389:	e8 e7 f9 ff ff       	call   102d75 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10338e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103395:	e8 85 08 00 00       	call   103c1f <alloc_pages>
  10339a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10339d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033a1:	75 24                	jne    1033c7 <default_check+0x116>
  1033a3:	c7 44 24 0c df 67 10 	movl   $0x1067df,0xc(%esp)
  1033aa:	00 
  1033ab:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1033b2:	00 
  1033b3:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1033ba:	00 
  1033bb:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1033c2:	e8 ff d8 ff ff       	call   100cc6 <__panic>
    assert(!PageProperty(p0));
  1033c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033ca:	83 c0 04             	add    $0x4,%eax
  1033cd:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1033d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1033da:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1033dd:	0f a3 10             	bt     %edx,(%eax)
  1033e0:	19 c0                	sbb    %eax,%eax
  1033e2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1033e5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1033e9:	0f 95 c0             	setne  %al
  1033ec:	0f b6 c0             	movzbl %al,%eax
  1033ef:	85 c0                	test   %eax,%eax
  1033f1:	74 24                	je     103417 <default_check+0x166>
  1033f3:	c7 44 24 0c ea 67 10 	movl   $0x1067ea,0xc(%esp)
  1033fa:	00 
  1033fb:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103402:	00 
  103403:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  10340a:	00 
  10340b:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103412:	e8 af d8 ff ff       	call   100cc6 <__panic>

    list_entry_t free_list_store = free_list;
  103417:	a1 50 89 11 00       	mov    0x118950,%eax
  10341c:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103422:	89 45 80             	mov    %eax,-0x80(%ebp)
  103425:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103428:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10342f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103432:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103435:	89 50 04             	mov    %edx,0x4(%eax)
  103438:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10343b:	8b 50 04             	mov    0x4(%eax),%edx
  10343e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103441:	89 10                	mov    %edx,(%eax)
  103443:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10344a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10344d:	8b 40 04             	mov    0x4(%eax),%eax
  103450:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103453:	0f 94 c0             	sete   %al
  103456:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103459:	85 c0                	test   %eax,%eax
  10345b:	75 24                	jne    103481 <default_check+0x1d0>
  10345d:	c7 44 24 0c 3f 67 10 	movl   $0x10673f,0xc(%esp)
  103464:	00 
  103465:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10346c:	00 
  10346d:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  103474:	00 
  103475:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10347c:	e8 45 d8 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  103481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103488:	e8 92 07 00 00       	call   103c1f <alloc_pages>
  10348d:	85 c0                	test   %eax,%eax
  10348f:	74 24                	je     1034b5 <default_check+0x204>
  103491:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  103498:	00 
  103499:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1034a0:	00 
  1034a1:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1034a8:	00 
  1034a9:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1034b0:	e8 11 d8 ff ff       	call   100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
  1034b5:	a1 58 89 11 00       	mov    0x118958,%eax
  1034ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1034bd:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1034c4:	00 00 00 

    free_pages(p0 + 2, 3);
  1034c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034ca:	83 c0 28             	add    $0x28,%eax
  1034cd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1034d4:	00 
  1034d5:	89 04 24             	mov    %eax,(%esp)
  1034d8:	e8 7a 07 00 00       	call   103c57 <free_pages>
    assert(alloc_pages(4) == NULL);
  1034dd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1034e4:	e8 36 07 00 00       	call   103c1f <alloc_pages>
  1034e9:	85 c0                	test   %eax,%eax
  1034eb:	74 24                	je     103511 <default_check+0x260>
  1034ed:	c7 44 24 0c fc 67 10 	movl   $0x1067fc,0xc(%esp)
  1034f4:	00 
  1034f5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1034fc:	00 
  1034fd:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103504:	00 
  103505:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10350c:	e8 b5 d7 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  103511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103514:	83 c0 28             	add    $0x28,%eax
  103517:	83 c0 04             	add    $0x4,%eax
  10351a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  103521:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103524:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103527:	8b 55 ac             	mov    -0x54(%ebp),%edx
  10352a:	0f a3 10             	bt     %edx,(%eax)
  10352d:	19 c0                	sbb    %eax,%eax
  10352f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  103532:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103536:	0f 95 c0             	setne  %al
  103539:	0f b6 c0             	movzbl %al,%eax
  10353c:	85 c0                	test   %eax,%eax
  10353e:	74 0e                	je     10354e <default_check+0x29d>
  103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103543:	83 c0 28             	add    $0x28,%eax
  103546:	8b 40 08             	mov    0x8(%eax),%eax
  103549:	83 f8 03             	cmp    $0x3,%eax
  10354c:	74 24                	je     103572 <default_check+0x2c1>
  10354e:	c7 44 24 0c 14 68 10 	movl   $0x106814,0xc(%esp)
  103555:	00 
  103556:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10355d:	00 
  10355e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  103565:	00 
  103566:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10356d:	e8 54 d7 ff ff       	call   100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103572:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103579:	e8 a1 06 00 00       	call   103c1f <alloc_pages>
  10357e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103581:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103585:	75 24                	jne    1035ab <default_check+0x2fa>
  103587:	c7 44 24 0c 40 68 10 	movl   $0x106840,0xc(%esp)
  10358e:	00 
  10358f:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103596:	00 
  103597:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  10359e:	00 
  10359f:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1035a6:	e8 1b d7 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1035ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1035b2:	e8 68 06 00 00       	call   103c1f <alloc_pages>
  1035b7:	85 c0                	test   %eax,%eax
  1035b9:	74 24                	je     1035df <default_check+0x32e>
  1035bb:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1035c2:	00 
  1035c3:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1035ca:	00 
  1035cb:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1035d2:	00 
  1035d3:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1035da:	e8 e7 d6 ff ff       	call   100cc6 <__panic>
    assert(p0 + 2 == p1);
  1035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e2:	83 c0 28             	add    $0x28,%eax
  1035e5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1035e8:	74 24                	je     10360e <default_check+0x35d>
  1035ea:	c7 44 24 0c 5e 68 10 	movl   $0x10685e,0xc(%esp)
  1035f1:	00 
  1035f2:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1035f9:	00 
  1035fa:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  103601:	00 
  103602:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103609:	e8 b8 d6 ff ff       	call   100cc6 <__panic>

    p2 = p0 + 1;
  10360e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103611:	83 c0 14             	add    $0x14,%eax
  103614:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103617:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10361e:	00 
  10361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103622:	89 04 24             	mov    %eax,(%esp)
  103625:	e8 2d 06 00 00       	call   103c57 <free_pages>
    free_pages(p1, 3);
  10362a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103631:	00 
  103632:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103635:	89 04 24             	mov    %eax,(%esp)
  103638:	e8 1a 06 00 00       	call   103c57 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103640:	83 c0 04             	add    $0x4,%eax
  103643:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  10364a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10364d:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103650:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103653:	0f a3 10             	bt     %edx,(%eax)
  103656:	19 c0                	sbb    %eax,%eax
  103658:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  10365b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10365f:	0f 95 c0             	setne  %al
  103662:	0f b6 c0             	movzbl %al,%eax
  103665:	85 c0                	test   %eax,%eax
  103667:	74 0b                	je     103674 <default_check+0x3c3>
  103669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10366c:	8b 40 08             	mov    0x8(%eax),%eax
  10366f:	83 f8 01             	cmp    $0x1,%eax
  103672:	74 24                	je     103698 <default_check+0x3e7>
  103674:	c7 44 24 0c 6c 68 10 	movl   $0x10686c,0xc(%esp)
  10367b:	00 
  10367c:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103683:	00 
  103684:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  10368b:	00 
  10368c:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103693:	e8 2e d6 ff ff       	call   100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103698:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10369b:	83 c0 04             	add    $0x4,%eax
  10369e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1036a5:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036a8:	8b 45 90             	mov    -0x70(%ebp),%eax
  1036ab:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1036ae:	0f a3 10             	bt     %edx,(%eax)
  1036b1:	19 c0                	sbb    %eax,%eax
  1036b3:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1036b6:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1036ba:	0f 95 c0             	setne  %al
  1036bd:	0f b6 c0             	movzbl %al,%eax
  1036c0:	85 c0                	test   %eax,%eax
  1036c2:	74 0b                	je     1036cf <default_check+0x41e>
  1036c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036c7:	8b 40 08             	mov    0x8(%eax),%eax
  1036ca:	83 f8 03             	cmp    $0x3,%eax
  1036cd:	74 24                	je     1036f3 <default_check+0x442>
  1036cf:	c7 44 24 0c 94 68 10 	movl   $0x106894,0xc(%esp)
  1036d6:	00 
  1036d7:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1036de:	00 
  1036df:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1036e6:	00 
  1036e7:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1036ee:	e8 d3 d5 ff ff       	call   100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1036f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036fa:	e8 20 05 00 00       	call   103c1f <alloc_pages>
  1036ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103702:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103705:	83 e8 14             	sub    $0x14,%eax
  103708:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10370b:	74 24                	je     103731 <default_check+0x480>
  10370d:	c7 44 24 0c ba 68 10 	movl   $0x1068ba,0xc(%esp)
  103714:	00 
  103715:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10371c:	00 
  10371d:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  103724:	00 
  103725:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10372c:	e8 95 d5 ff ff       	call   100cc6 <__panic>
    free_page(p0);
  103731:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103738:	00 
  103739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10373c:	89 04 24             	mov    %eax,(%esp)
  10373f:	e8 13 05 00 00       	call   103c57 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103744:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  10374b:	e8 cf 04 00 00       	call   103c1f <alloc_pages>
  103750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103753:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103756:	83 c0 14             	add    $0x14,%eax
  103759:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10375c:	74 24                	je     103782 <default_check+0x4d1>
  10375e:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  103765:	00 
  103766:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10376d:	00 
  10376e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  103775:	00 
  103776:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10377d:	e8 44 d5 ff ff       	call   100cc6 <__panic>

    free_pages(p0, 2);
  103782:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103789:	00 
  10378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10378d:	89 04 24             	mov    %eax,(%esp)
  103790:	e8 c2 04 00 00       	call   103c57 <free_pages>
    free_page(p2);
  103795:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10379c:	00 
  10379d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037a0:	89 04 24             	mov    %eax,(%esp)
  1037a3:	e8 af 04 00 00       	call   103c57 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1037a8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1037af:	e8 6b 04 00 00       	call   103c1f <alloc_pages>
  1037b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1037bb:	75 24                	jne    1037e1 <default_check+0x530>
  1037bd:	c7 44 24 0c f8 68 10 	movl   $0x1068f8,0xc(%esp)
  1037c4:	00 
  1037c5:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1037cc:	00 
  1037cd:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1037d4:	00 
  1037d5:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1037dc:	e8 e5 d4 ff ff       	call   100cc6 <__panic>
    assert(alloc_page() == NULL);
  1037e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037e8:	e8 32 04 00 00       	call   103c1f <alloc_pages>
  1037ed:	85 c0                	test   %eax,%eax
  1037ef:	74 24                	je     103815 <default_check+0x564>
  1037f1:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  1037f8:	00 
  1037f9:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  103800:	00 
  103801:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103808:	00 
  103809:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  103810:	e8 b1 d4 ff ff       	call   100cc6 <__panic>

    assert(nr_free == 0);
  103815:	a1 58 89 11 00       	mov    0x118958,%eax
  10381a:	85 c0                	test   %eax,%eax
  10381c:	74 24                	je     103842 <default_check+0x591>
  10381e:	c7 44 24 0c a9 67 10 	movl   $0x1067a9,0xc(%esp)
  103825:	00 
  103826:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  10382d:	00 
  10382e:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103835:	00 
  103836:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  10383d:	e8 84 d4 ff ff       	call   100cc6 <__panic>
    nr_free = nr_free_store;
  103842:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103845:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  10384a:	8b 45 80             	mov    -0x80(%ebp),%eax
  10384d:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103850:	a3 50 89 11 00       	mov    %eax,0x118950
  103855:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  10385b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103862:	00 
  103863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103866:	89 04 24             	mov    %eax,(%esp)
  103869:	e8 e9 03 00 00       	call   103c57 <free_pages>

    le = &free_list;
  10386e:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103875:	eb 1d                	jmp    103894 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10387a:	83 e8 0c             	sub    $0xc,%eax
  10387d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103880:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103884:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10388a:	8b 40 08             	mov    0x8(%eax),%eax
  10388d:	29 c2                	sub    %eax,%edx
  10388f:	89 d0                	mov    %edx,%eax
  103891:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103897:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10389a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10389d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1038a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038a3:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1038aa:	75 cb                	jne    103877 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1038ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1038b0:	74 24                	je     1038d6 <default_check+0x625>
  1038b2:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  1038b9:	00 
  1038ba:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1038c1:	00 
  1038c2:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1038c9:	00 
  1038ca:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1038d1:	e8 f0 d3 ff ff       	call   100cc6 <__panic>
    assert(total == 0);
  1038d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1038da:	74 24                	je     103900 <default_check+0x64f>
  1038dc:	c7 44 24 0c 21 69 10 	movl   $0x106921,0xc(%esp)
  1038e3:	00 
  1038e4:	c7 44 24 08 f6 65 10 	movl   $0x1065f6,0x8(%esp)
  1038eb:	00 
  1038ec:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1038f3:	00 
  1038f4:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  1038fb:	e8 c6 d3 ff ff       	call   100cc6 <__panic>
}
  103900:	81 c4 94 00 00 00    	add    $0x94,%esp
  103906:	5b                   	pop    %ebx
  103907:	5d                   	pop    %ebp
  103908:	c3                   	ret    

00103909 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103909:	55                   	push   %ebp
  10390a:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10390c:	8b 55 08             	mov    0x8(%ebp),%edx
  10390f:	a1 64 89 11 00       	mov    0x118964,%eax
  103914:	29 c2                	sub    %eax,%edx
  103916:	89 d0                	mov    %edx,%eax
  103918:	c1 f8 02             	sar    $0x2,%eax
  10391b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103921:	5d                   	pop    %ebp
  103922:	c3                   	ret    

00103923 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103923:	55                   	push   %ebp
  103924:	89 e5                	mov    %esp,%ebp
  103926:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103929:	8b 45 08             	mov    0x8(%ebp),%eax
  10392c:	89 04 24             	mov    %eax,(%esp)
  10392f:	e8 d5 ff ff ff       	call   103909 <page2ppn>
  103934:	c1 e0 0c             	shl    $0xc,%eax
}
  103937:	c9                   	leave  
  103938:	c3                   	ret    

00103939 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103939:	55                   	push   %ebp
  10393a:	89 e5                	mov    %esp,%ebp
  10393c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  10393f:	8b 45 08             	mov    0x8(%ebp),%eax
  103942:	c1 e8 0c             	shr    $0xc,%eax
  103945:	89 c2                	mov    %eax,%edx
  103947:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10394c:	39 c2                	cmp    %eax,%edx
  10394e:	72 1c                	jb     10396c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103950:	c7 44 24 08 5c 69 10 	movl   $0x10695c,0x8(%esp)
  103957:	00 
  103958:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  10395f:	00 
  103960:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  103967:	e8 5a d3 ff ff       	call   100cc6 <__panic>
    }
    return &pages[PPN(pa)];
  10396c:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103972:	8b 45 08             	mov    0x8(%ebp),%eax
  103975:	c1 e8 0c             	shr    $0xc,%eax
  103978:	89 c2                	mov    %eax,%edx
  10397a:	89 d0                	mov    %edx,%eax
  10397c:	c1 e0 02             	shl    $0x2,%eax
  10397f:	01 d0                	add    %edx,%eax
  103981:	c1 e0 02             	shl    $0x2,%eax
  103984:	01 c8                	add    %ecx,%eax
}
  103986:	c9                   	leave  
  103987:	c3                   	ret    

00103988 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103988:	55                   	push   %ebp
  103989:	89 e5                	mov    %esp,%ebp
  10398b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  10398e:	8b 45 08             	mov    0x8(%ebp),%eax
  103991:	89 04 24             	mov    %eax,(%esp)
  103994:	e8 8a ff ff ff       	call   103923 <page2pa>
  103999:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10399c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10399f:	c1 e8 0c             	shr    $0xc,%eax
  1039a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039a5:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039aa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1039ad:	72 23                	jb     1039d2 <page2kva+0x4a>
  1039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1039b6:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  1039bd:	00 
  1039be:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1039c5:	00 
  1039c6:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  1039cd:	e8 f4 d2 ff ff       	call   100cc6 <__panic>
  1039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1039da:	c9                   	leave  
  1039db:	c3                   	ret    

001039dc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1039dc:	55                   	push   %ebp
  1039dd:	89 e5                	mov    %esp,%ebp
  1039df:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1039e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1039e5:	83 e0 01             	and    $0x1,%eax
  1039e8:	85 c0                	test   %eax,%eax
  1039ea:	75 1c                	jne    103a08 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1039ec:	c7 44 24 08 b0 69 10 	movl   $0x1069b0,0x8(%esp)
  1039f3:	00 
  1039f4:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  1039fb:	00 
  1039fc:	c7 04 24 7b 69 10 00 	movl   $0x10697b,(%esp)
  103a03:	e8 be d2 ff ff       	call   100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103a08:	8b 45 08             	mov    0x8(%ebp),%eax
  103a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103a10:	89 04 24             	mov    %eax,(%esp)
  103a13:	e8 21 ff ff ff       	call   103939 <pa2page>
}
  103a18:	c9                   	leave  
  103a19:	c3                   	ret    

00103a1a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103a1a:	55                   	push   %ebp
  103a1b:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  103a20:	8b 00                	mov    (%eax),%eax
}
  103a22:	5d                   	pop    %ebp
  103a23:	c3                   	ret    

00103a24 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103a24:	55                   	push   %ebp
  103a25:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103a27:	8b 45 08             	mov    0x8(%ebp),%eax
  103a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  103a2d:	89 10                	mov    %edx,(%eax)
}
  103a2f:	5d                   	pop    %ebp
  103a30:	c3                   	ret    

00103a31 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103a31:	55                   	push   %ebp
  103a32:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103a34:	8b 45 08             	mov    0x8(%ebp),%eax
  103a37:	8b 00                	mov    (%eax),%eax
  103a39:	8d 50 01             	lea    0x1(%eax),%edx
  103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a41:	8b 45 08             	mov    0x8(%ebp),%eax
  103a44:	8b 00                	mov    (%eax),%eax
}
  103a46:	5d                   	pop    %ebp
  103a47:	c3                   	ret    

00103a48 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103a48:	55                   	push   %ebp
  103a49:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a4e:	8b 00                	mov    (%eax),%eax
  103a50:	8d 50 ff             	lea    -0x1(%eax),%edx
  103a53:	8b 45 08             	mov    0x8(%ebp),%eax
  103a56:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103a58:	8b 45 08             	mov    0x8(%ebp),%eax
  103a5b:	8b 00                	mov    (%eax),%eax
}
  103a5d:	5d                   	pop    %ebp
  103a5e:	c3                   	ret    

00103a5f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103a5f:	55                   	push   %ebp
  103a60:	89 e5                	mov    %esp,%ebp
  103a62:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103a65:	9c                   	pushf  
  103a66:	58                   	pop    %eax
  103a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103a6d:	25 00 02 00 00       	and    $0x200,%eax
  103a72:	85 c0                	test   %eax,%eax
  103a74:	74 0c                	je     103a82 <__intr_save+0x23>
        intr_disable();
  103a76:	e8 2e dc ff ff       	call   1016a9 <intr_disable>
        return 1;
  103a7b:	b8 01 00 00 00       	mov    $0x1,%eax
  103a80:	eb 05                	jmp    103a87 <__intr_save+0x28>
    }
    return 0;
  103a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103a87:	c9                   	leave  
  103a88:	c3                   	ret    

00103a89 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103a89:	55                   	push   %ebp
  103a8a:	89 e5                	mov    %esp,%ebp
  103a8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103a93:	74 05                	je     103a9a <__intr_restore+0x11>
        intr_enable();
  103a95:	e8 09 dc ff ff       	call   1016a3 <intr_enable>
    }
}
  103a9a:	c9                   	leave  
  103a9b:	c3                   	ret    

00103a9c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103a9c:	55                   	push   %ebp
  103a9d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  103aa2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103aa5:	b8 23 00 00 00       	mov    $0x23,%eax
  103aaa:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103aac:	b8 23 00 00 00       	mov    $0x23,%eax
  103ab1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103ab3:	b8 10 00 00 00       	mov    $0x10,%eax
  103ab8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103aba:	b8 10 00 00 00       	mov    $0x10,%eax
  103abf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103ac1:	b8 10 00 00 00       	mov    $0x10,%eax
  103ac6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103ac8:	ea cf 3a 10 00 08 00 	ljmp   $0x8,$0x103acf
}
  103acf:	5d                   	pop    %ebp
  103ad0:	c3                   	ret    

00103ad1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103ad1:	55                   	push   %ebp
  103ad2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad7:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103adc:	5d                   	pop    %ebp
  103add:	c3                   	ret    

00103ade <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103ade:	55                   	push   %ebp
  103adf:	89 e5                	mov    %esp,%ebp
  103ae1:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103ae4:	b8 00 70 11 00       	mov    $0x117000,%eax
  103ae9:	89 04 24             	mov    %eax,(%esp)
  103aec:	e8 e0 ff ff ff       	call   103ad1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103af1:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103af8:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103afa:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103b01:	68 00 
  103b03:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b08:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103b0e:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103b13:	c1 e8 10             	shr    $0x10,%eax
  103b16:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103b1b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b22:	83 e0 f0             	and    $0xfffffff0,%eax
  103b25:	83 c8 09             	or     $0x9,%eax
  103b28:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b2d:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b34:	83 e0 ef             	and    $0xffffffef,%eax
  103b37:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b3c:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b43:	83 e0 9f             	and    $0xffffff9f,%eax
  103b46:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b4b:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103b52:	83 c8 80             	or     $0xffffff80,%eax
  103b55:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103b5a:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b61:	83 e0 f0             	and    $0xfffffff0,%eax
  103b64:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b69:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b70:	83 e0 ef             	and    $0xffffffef,%eax
  103b73:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b78:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b7f:	83 e0 df             	and    $0xffffffdf,%eax
  103b82:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b87:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b8e:	83 c8 40             	or     $0x40,%eax
  103b91:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103b96:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103b9d:	83 e0 7f             	and    $0x7f,%eax
  103ba0:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103ba5:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103baa:	c1 e8 18             	shr    $0x18,%eax
  103bad:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103bb2:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103bb9:	e8 de fe ff ff       	call   103a9c <lgdt>
  103bbe:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103bc4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103bc8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103bcb:	c9                   	leave  
  103bcc:	c3                   	ret    

00103bcd <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103bcd:	55                   	push   %ebp
  103bce:	89 e5                	mov    %esp,%ebp
  103bd0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103bd3:	c7 05 5c 89 11 00 40 	movl   $0x106940,0x11895c
  103bda:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103bdd:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103be2:	8b 00                	mov    (%eax),%eax
  103be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  103be8:	c7 04 24 dc 69 10 00 	movl   $0x1069dc,(%esp)
  103bef:	e8 48 c7 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103bf4:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103bf9:	8b 40 04             	mov    0x4(%eax),%eax
  103bfc:	ff d0                	call   *%eax
}
  103bfe:	c9                   	leave  
  103bff:	c3                   	ret    

00103c00 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103c00:	55                   	push   %ebp
  103c01:	89 e5                	mov    %esp,%ebp
  103c03:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103c06:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c0b:	8b 40 08             	mov    0x8(%eax),%eax
  103c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c11:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c15:	8b 55 08             	mov    0x8(%ebp),%edx
  103c18:	89 14 24             	mov    %edx,(%esp)
  103c1b:	ff d0                	call   *%eax
}
  103c1d:	c9                   	leave  
  103c1e:	c3                   	ret    

00103c1f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103c1f:	55                   	push   %ebp
  103c20:	89 e5                	mov    %esp,%ebp
  103c22:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103c25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103c2c:	e8 2e fe ff ff       	call   103a5f <__intr_save>
  103c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103c34:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c39:	8b 40 0c             	mov    0xc(%eax),%eax
  103c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  103c3f:	89 14 24             	mov    %edx,(%esp)
  103c42:	ff d0                	call   *%eax
  103c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c4a:	89 04 24             	mov    %eax,(%esp)
  103c4d:	e8 37 fe ff ff       	call   103a89 <__intr_restore>
    return page;
  103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103c55:	c9                   	leave  
  103c56:	c3                   	ret    

00103c57 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103c57:	55                   	push   %ebp
  103c58:	89 e5                	mov    %esp,%ebp
  103c5a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103c5d:	e8 fd fd ff ff       	call   103a5f <__intr_save>
  103c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103c65:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c6a:	8b 40 10             	mov    0x10(%eax),%eax
  103c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103c70:	89 54 24 04          	mov    %edx,0x4(%esp)
  103c74:	8b 55 08             	mov    0x8(%ebp),%edx
  103c77:	89 14 24             	mov    %edx,(%esp)
  103c7a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c7f:	89 04 24             	mov    %eax,(%esp)
  103c82:	e8 02 fe ff ff       	call   103a89 <__intr_restore>
}
  103c87:	c9                   	leave  
  103c88:	c3                   	ret    

00103c89 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103c89:	55                   	push   %ebp
  103c8a:	89 e5                	mov    %esp,%ebp
  103c8c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103c8f:	e8 cb fd ff ff       	call   103a5f <__intr_save>
  103c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103c97:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c9c:	8b 40 14             	mov    0x14(%eax),%eax
  103c9f:	ff d0                	call   *%eax
  103ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ca7:	89 04 24             	mov    %eax,(%esp)
  103caa:	e8 da fd ff ff       	call   103a89 <__intr_restore>
    return ret;
  103caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103cb2:	c9                   	leave  
  103cb3:	c3                   	ret    

00103cb4 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103cb4:	55                   	push   %ebp
  103cb5:	89 e5                	mov    %esp,%ebp
  103cb7:	57                   	push   %edi
  103cb8:	56                   	push   %esi
  103cb9:	53                   	push   %ebx
  103cba:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103cc0:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103cc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103cce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103cd5:	c7 04 24 f3 69 10 00 	movl   $0x1069f3,(%esp)
  103cdc:	e8 5b c6 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ce1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103ce8:	e9 15 01 00 00       	jmp    103e02 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103ced:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103cf0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103cf3:	89 d0                	mov    %edx,%eax
  103cf5:	c1 e0 02             	shl    $0x2,%eax
  103cf8:	01 d0                	add    %edx,%eax
  103cfa:	c1 e0 02             	shl    $0x2,%eax
  103cfd:	01 c8                	add    %ecx,%eax
  103cff:	8b 50 08             	mov    0x8(%eax),%edx
  103d02:	8b 40 04             	mov    0x4(%eax),%eax
  103d05:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103d08:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103d0b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d11:	89 d0                	mov    %edx,%eax
  103d13:	c1 e0 02             	shl    $0x2,%eax
  103d16:	01 d0                	add    %edx,%eax
  103d18:	c1 e0 02             	shl    $0x2,%eax
  103d1b:	01 c8                	add    %ecx,%eax
  103d1d:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d20:	8b 58 10             	mov    0x10(%eax),%ebx
  103d23:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d26:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d29:	01 c8                	add    %ecx,%eax
  103d2b:	11 da                	adc    %ebx,%edx
  103d2d:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103d30:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103d33:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d39:	89 d0                	mov    %edx,%eax
  103d3b:	c1 e0 02             	shl    $0x2,%eax
  103d3e:	01 d0                	add    %edx,%eax
  103d40:	c1 e0 02             	shl    $0x2,%eax
  103d43:	01 c8                	add    %ecx,%eax
  103d45:	83 c0 14             	add    $0x14,%eax
  103d48:	8b 00                	mov    (%eax),%eax
  103d4a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103d50:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103d53:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103d56:	83 c0 ff             	add    $0xffffffff,%eax
  103d59:	83 d2 ff             	adc    $0xffffffff,%edx
  103d5c:	89 c6                	mov    %eax,%esi
  103d5e:	89 d7                	mov    %edx,%edi
  103d60:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d63:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d66:	89 d0                	mov    %edx,%eax
  103d68:	c1 e0 02             	shl    $0x2,%eax
  103d6b:	01 d0                	add    %edx,%eax
  103d6d:	c1 e0 02             	shl    $0x2,%eax
  103d70:	01 c8                	add    %ecx,%eax
  103d72:	8b 48 0c             	mov    0xc(%eax),%ecx
  103d75:	8b 58 10             	mov    0x10(%eax),%ebx
  103d78:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103d7e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103d82:	89 74 24 14          	mov    %esi,0x14(%esp)
  103d86:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103d8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103d8d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103d90:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d94:	89 54 24 10          	mov    %edx,0x10(%esp)
  103d98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103d9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103da0:	c7 04 24 00 6a 10 00 	movl   $0x106a00,(%esp)
  103da7:	e8 90 c5 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103dac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103daf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103db2:	89 d0                	mov    %edx,%eax
  103db4:	c1 e0 02             	shl    $0x2,%eax
  103db7:	01 d0                	add    %edx,%eax
  103db9:	c1 e0 02             	shl    $0x2,%eax
  103dbc:	01 c8                	add    %ecx,%eax
  103dbe:	83 c0 14             	add    $0x14,%eax
  103dc1:	8b 00                	mov    (%eax),%eax
  103dc3:	83 f8 01             	cmp    $0x1,%eax
  103dc6:	75 36                	jne    103dfe <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103dce:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103dd1:	77 2b                	ja     103dfe <page_init+0x14a>
  103dd3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103dd6:	72 05                	jb     103ddd <page_init+0x129>
  103dd8:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ddb:	73 21                	jae    103dfe <page_init+0x14a>
  103ddd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103de1:	77 1b                	ja     103dfe <page_init+0x14a>
  103de3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103de7:	72 09                	jb     103df2 <page_init+0x13e>
  103de9:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103df0:	77 0c                	ja     103dfe <page_init+0x14a>
                maxpa = end;
  103df2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103df5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103df8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103dfb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dfe:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103e02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103e05:	8b 00                	mov    (%eax),%eax
  103e07:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103e0a:	0f 8f dd fe ff ff    	jg     103ced <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103e10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e14:	72 1d                	jb     103e33 <page_init+0x17f>
  103e16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103e1a:	77 09                	ja     103e25 <page_init+0x171>
  103e1c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103e23:	76 0e                	jbe    103e33 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103e25:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103e2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e39:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103e3d:	c1 ea 0c             	shr    $0xc,%edx
  103e40:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103e45:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103e4c:	b8 68 89 11 00       	mov    $0x118968,%eax
  103e51:	8d 50 ff             	lea    -0x1(%eax),%edx
  103e54:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103e57:	01 d0                	add    %edx,%eax
  103e59:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103e5c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103e5f:	ba 00 00 00 00       	mov    $0x0,%edx
  103e64:	f7 75 ac             	divl   -0x54(%ebp)
  103e67:	89 d0                	mov    %edx,%eax
  103e69:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103e6c:	29 c2                	sub    %eax,%edx
  103e6e:	89 d0                	mov    %edx,%eax
  103e70:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103e75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103e7c:	eb 2f                	jmp    103ead <page_init+0x1f9>
        SetPageReserved(pages + i);
  103e7e:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103e84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e87:	89 d0                	mov    %edx,%eax
  103e89:	c1 e0 02             	shl    $0x2,%eax
  103e8c:	01 d0                	add    %edx,%eax
  103e8e:	c1 e0 02             	shl    $0x2,%eax
  103e91:	01 c8                	add    %ecx,%eax
  103e93:	83 c0 04             	add    $0x4,%eax
  103e96:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103e9d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103ea0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103ea3:	8b 55 90             	mov    -0x70(%ebp),%edx
  103ea6:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103ea9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eb0:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103eb5:	39 c2                	cmp    %eax,%edx
  103eb7:	72 c5                	jb     103e7e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103eb9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103ebf:	89 d0                	mov    %edx,%eax
  103ec1:	c1 e0 02             	shl    $0x2,%eax
  103ec4:	01 d0                	add    %edx,%eax
  103ec6:	c1 e0 02             	shl    $0x2,%eax
  103ec9:	89 c2                	mov    %eax,%edx
  103ecb:	a1 64 89 11 00       	mov    0x118964,%eax
  103ed0:	01 d0                	add    %edx,%eax
  103ed2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103ed5:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103edc:	77 23                	ja     103f01 <page_init+0x24d>
  103ede:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103ee1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ee5:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  103eec:	00 
  103eed:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103ef4:	00 
  103ef5:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  103efc:	e8 c5 cd ff ff       	call   100cc6 <__panic>
  103f01:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f04:	05 00 00 00 40       	add    $0x40000000,%eax
  103f09:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103f0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f13:	e9 74 01 00 00       	jmp    10408c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103f18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f1e:	89 d0                	mov    %edx,%eax
  103f20:	c1 e0 02             	shl    $0x2,%eax
  103f23:	01 d0                	add    %edx,%eax
  103f25:	c1 e0 02             	shl    $0x2,%eax
  103f28:	01 c8                	add    %ecx,%eax
  103f2a:	8b 50 08             	mov    0x8(%eax),%edx
  103f2d:	8b 40 04             	mov    0x4(%eax),%eax
  103f30:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f33:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103f36:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f39:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f3c:	89 d0                	mov    %edx,%eax
  103f3e:	c1 e0 02             	shl    $0x2,%eax
  103f41:	01 d0                	add    %edx,%eax
  103f43:	c1 e0 02             	shl    $0x2,%eax
  103f46:	01 c8                	add    %ecx,%eax
  103f48:	8b 48 0c             	mov    0xc(%eax),%ecx
  103f4b:	8b 58 10             	mov    0x10(%eax),%ebx
  103f4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103f54:	01 c8                	add    %ecx,%eax
  103f56:	11 da                	adc    %ebx,%edx
  103f58:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103f5b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103f5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f64:	89 d0                	mov    %edx,%eax
  103f66:	c1 e0 02             	shl    $0x2,%eax
  103f69:	01 d0                	add    %edx,%eax
  103f6b:	c1 e0 02             	shl    $0x2,%eax
  103f6e:	01 c8                	add    %ecx,%eax
  103f70:	83 c0 14             	add    $0x14,%eax
  103f73:	8b 00                	mov    (%eax),%eax
  103f75:	83 f8 01             	cmp    $0x1,%eax
  103f78:	0f 85 0a 01 00 00    	jne    104088 <page_init+0x3d4>
            if (begin < freemem) {
  103f7e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f81:	ba 00 00 00 00       	mov    $0x0,%edx
  103f86:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f89:	72 17                	jb     103fa2 <page_init+0x2ee>
  103f8b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103f8e:	77 05                	ja     103f95 <page_init+0x2e1>
  103f90:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103f93:	76 0d                	jbe    103fa2 <page_init+0x2ee>
                begin = freemem;
  103f95:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103f9b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103fa2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103fa6:	72 1d                	jb     103fc5 <page_init+0x311>
  103fa8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103fac:	77 09                	ja     103fb7 <page_init+0x303>
  103fae:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103fb5:	76 0e                	jbe    103fc5 <page_init+0x311>
                end = KMEMSIZE;
  103fb7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103fbe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103fc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103fcb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103fce:	0f 87 b4 00 00 00    	ja     104088 <page_init+0x3d4>
  103fd4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103fd7:	72 09                	jb     103fe2 <page_init+0x32e>
  103fd9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103fdc:	0f 83 a6 00 00 00    	jae    104088 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103fe2:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103fe9:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103fec:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103fef:	01 d0                	add    %edx,%eax
  103ff1:	83 e8 01             	sub    $0x1,%eax
  103ff4:	89 45 98             	mov    %eax,-0x68(%ebp)
  103ff7:	8b 45 98             	mov    -0x68(%ebp),%eax
  103ffa:	ba 00 00 00 00       	mov    $0x0,%edx
  103fff:	f7 75 9c             	divl   -0x64(%ebp)
  104002:	89 d0                	mov    %edx,%eax
  104004:	8b 55 98             	mov    -0x68(%ebp),%edx
  104007:	29 c2                	sub    %eax,%edx
  104009:	89 d0                	mov    %edx,%eax
  10400b:	ba 00 00 00 00       	mov    $0x0,%edx
  104010:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104013:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104016:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104019:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10401c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10401f:	ba 00 00 00 00       	mov    $0x0,%edx
  104024:	89 c7                	mov    %eax,%edi
  104026:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  10402c:	89 7d 80             	mov    %edi,-0x80(%ebp)
  10402f:	89 d0                	mov    %edx,%eax
  104031:	83 e0 00             	and    $0x0,%eax
  104034:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104037:	8b 45 80             	mov    -0x80(%ebp),%eax
  10403a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10403d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104040:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  104043:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104046:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104049:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10404c:	77 3a                	ja     104088 <page_init+0x3d4>
  10404e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104051:	72 05                	jb     104058 <page_init+0x3a4>
  104053:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  104056:	73 30                	jae    104088 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104058:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10405b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  10405e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104061:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104064:	29 c8                	sub    %ecx,%eax
  104066:	19 da                	sbb    %ebx,%edx
  104068:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10406c:	c1 ea 0c             	shr    $0xc,%edx
  10406f:	89 c3                	mov    %eax,%ebx
  104071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104074:	89 04 24             	mov    %eax,(%esp)
  104077:	e8 bd f8 ff ff       	call   103939 <pa2page>
  10407c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104080:	89 04 24             	mov    %eax,(%esp)
  104083:	e8 78 fb ff ff       	call   103c00 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104088:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10408c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10408f:	8b 00                	mov    (%eax),%eax
  104091:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104094:	0f 8f 7e fe ff ff    	jg     103f18 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10409a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1040a0:	5b                   	pop    %ebx
  1040a1:	5e                   	pop    %esi
  1040a2:	5f                   	pop    %edi
  1040a3:	5d                   	pop    %ebp
  1040a4:	c3                   	ret    

001040a5 <enable_paging>:

static void
enable_paging(void) {
  1040a5:	55                   	push   %ebp
  1040a6:	89 e5                	mov    %esp,%ebp
  1040a8:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1040ab:	a1 60 89 11 00       	mov    0x118960,%eax
  1040b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1040b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1040b6:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1040b9:	0f 20 c0             	mov    %cr0,%eax
  1040bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1040c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1040c5:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1040cc:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1040d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1040d9:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1040dc:	c9                   	leave  
  1040dd:	c3                   	ret    

001040de <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1040de:	55                   	push   %ebp
  1040df:	89 e5                	mov    %esp,%ebp
  1040e1:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1040e4:	8b 45 14             	mov    0x14(%ebp),%eax
  1040e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  1040ea:	31 d0                	xor    %edx,%eax
  1040ec:	25 ff 0f 00 00       	and    $0xfff,%eax
  1040f1:	85 c0                	test   %eax,%eax
  1040f3:	74 24                	je     104119 <boot_map_segment+0x3b>
  1040f5:	c7 44 24 0c 62 6a 10 	movl   $0x106a62,0xc(%esp)
  1040fc:	00 
  1040fd:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104104:	00 
  104105:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10410c:	00 
  10410d:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104114:	e8 ad cb ff ff       	call   100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104119:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104120:	8b 45 0c             	mov    0xc(%ebp),%eax
  104123:	25 ff 0f 00 00       	and    $0xfff,%eax
  104128:	89 c2                	mov    %eax,%edx
  10412a:	8b 45 10             	mov    0x10(%ebp),%eax
  10412d:	01 c2                	add    %eax,%edx
  10412f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104132:	01 d0                	add    %edx,%eax
  104134:	83 e8 01             	sub    $0x1,%eax
  104137:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10413a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10413d:	ba 00 00 00 00       	mov    $0x0,%edx
  104142:	f7 75 f0             	divl   -0x10(%ebp)
  104145:	89 d0                	mov    %edx,%eax
  104147:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10414a:	29 c2                	sub    %eax,%edx
  10414c:	89 d0                	mov    %edx,%eax
  10414e:	c1 e8 0c             	shr    $0xc,%eax
  104151:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  104154:	8b 45 0c             	mov    0xc(%ebp),%eax
  104157:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10415a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10415d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104162:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104165:	8b 45 14             	mov    0x14(%ebp),%eax
  104168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10416b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10416e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104173:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104176:	eb 6b                	jmp    1041e3 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104178:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10417f:	00 
  104180:	8b 45 0c             	mov    0xc(%ebp),%eax
  104183:	89 44 24 04          	mov    %eax,0x4(%esp)
  104187:	8b 45 08             	mov    0x8(%ebp),%eax
  10418a:	89 04 24             	mov    %eax,(%esp)
  10418d:	e8 cc 01 00 00       	call   10435e <get_pte>
  104192:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104195:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104199:	75 24                	jne    1041bf <boot_map_segment+0xe1>
  10419b:	c7 44 24 0c 8e 6a 10 	movl   $0x106a8e,0xc(%esp)
  1041a2:	00 
  1041a3:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1041aa:	00 
  1041ab:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1041b2:	00 
  1041b3:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1041ba:	e8 07 cb ff ff       	call   100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
  1041bf:	8b 45 18             	mov    0x18(%ebp),%eax
  1041c2:	8b 55 14             	mov    0x14(%ebp),%edx
  1041c5:	09 d0                	or     %edx,%eax
  1041c7:	83 c8 01             	or     $0x1,%eax
  1041ca:	89 c2                	mov    %eax,%edx
  1041cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1041cf:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1041d1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1041d5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1041dc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1041e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1041e7:	75 8f                	jne    104178 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1041e9:	c9                   	leave  
  1041ea:	c3                   	ret    

001041eb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1041eb:	55                   	push   %ebp
  1041ec:	89 e5                	mov    %esp,%ebp
  1041ee:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1041f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1041f8:	e8 22 fa ff ff       	call   103c1f <alloc_pages>
  1041fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104204:	75 1c                	jne    104222 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104206:	c7 44 24 08 9b 6a 10 	movl   $0x106a9b,0x8(%esp)
  10420d:	00 
  10420e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104215:	00 
  104216:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10421d:	e8 a4 ca ff ff       	call   100cc6 <__panic>
    }
    return page2kva(p);
  104222:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104225:	89 04 24             	mov    %eax,(%esp)
  104228:	e8 5b f7 ff ff       	call   103988 <page2kva>
}
  10422d:	c9                   	leave  
  10422e:	c3                   	ret    

0010422f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10422f:	55                   	push   %ebp
  104230:	89 e5                	mov    %esp,%ebp
  104232:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104235:	e8 93 f9 ff ff       	call   103bcd <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  10423a:	e8 75 fa ff ff       	call   103cb4 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10423f:	e8 70 04 00 00       	call   1046b4 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104244:	e8 a2 ff ff ff       	call   1041eb <boot_alloc_page>
  104249:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  10424e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104253:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10425a:	00 
  10425b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104262:	00 
  104263:	89 04 24             	mov    %eax,(%esp)
  104266:	e8 b2 1a 00 00       	call   105d1d <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10426b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104273:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10427a:	77 23                	ja     10429f <pmm_init+0x70>
  10427c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10427f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104283:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  10428a:	00 
  10428b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104292:	00 
  104293:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10429a:	e8 27 ca ff ff       	call   100cc6 <__panic>
  10429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042a2:	05 00 00 00 40       	add    $0x40000000,%eax
  1042a7:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1042ac:	e8 21 04 00 00       	call   1046d2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1042b1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042b6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1042bc:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1042c4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1042cb:	77 23                	ja     1042f0 <pmm_init+0xc1>
  1042cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1042d4:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  1042db:	00 
  1042dc:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1042e3:	00 
  1042e4:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1042eb:	e8 d6 c9 ff ff       	call   100cc6 <__panic>
  1042f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f3:	05 00 00 00 40       	add    $0x40000000,%eax
  1042f8:	83 c8 03             	or     $0x3,%eax
  1042fb:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1042fd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104302:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104309:	00 
  10430a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104311:	00 
  104312:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104319:	38 
  10431a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  104321:	c0 
  104322:	89 04 24             	mov    %eax,(%esp)
  104325:	e8 b4 fd ff ff       	call   1040de <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  10432a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10432f:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  104335:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  10433b:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10433d:	e8 63 fd ff ff       	call   1040a5 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  104342:	e8 97 f7 ff ff       	call   103ade <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104347:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10434c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  104352:	e8 16 0a 00 00       	call   104d6d <check_boot_pgdir>

    print_pgdir();
  104357:	e8 a3 0e 00 00       	call   1051ff <print_pgdir>

}
  10435c:	c9                   	leave  
  10435d:	c3                   	ret    

0010435e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10435e:	55                   	push   %ebp
  10435f:	89 e5                	mov    %esp,%ebp
  104361:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

	pde_t *pdep = &pgdir[PDX(la)];
  104364:	8b 45 0c             	mov    0xc(%ebp),%eax
  104367:	c1 e8 16             	shr    $0x16,%eax
  10436a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104371:	8b 45 08             	mov    0x8(%ebp),%eax
  104374:	01 d0                	add    %edx,%eax
  104376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P)){
  104379:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10437c:	8b 00                	mov    (%eax),%eax
  10437e:	83 e0 01             	and    $0x1,%eax
  104381:	85 c0                	test   %eax,%eax
  104383:	0f 85 b9 00 00 00    	jne    104442 <get_pte+0xe4>
		struct Page* page;
		if (!create) return NULL;
  104389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10438d:	75 0a                	jne    104399 <get_pte+0x3b>
  10438f:	b8 00 00 00 00       	mov    $0x0,%eax
  104394:	e9 05 01 00 00       	jmp    10449e <get_pte+0x140>
		page = alloc_page();
  104399:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1043a0:	e8 7a f8 ff ff       	call   103c1f <alloc_pages>
  1043a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (page == NULL) return NULL;
  1043a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1043ac:	75 0a                	jne    1043b8 <get_pte+0x5a>
  1043ae:	b8 00 00 00 00       	mov    $0x0,%eax
  1043b3:	e9 e6 00 00 00       	jmp    10449e <get_pte+0x140>
		set_page_ref(page, 1);
  1043b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1043bf:	00 
  1043c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043c3:	89 04 24             	mov    %eax,(%esp)
  1043c6:	e8 59 f6 ff ff       	call   103a24 <set_page_ref>
		uintptr_t pa = page2pa(page);
  1043cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ce:	89 04 24             	mov    %eax,(%esp)
  1043d1:	e8 4d f5 ff ff       	call   103923 <page2pa>
  1043d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
  1043d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1043df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043e2:	c1 e8 0c             	shr    $0xc,%eax
  1043e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1043e8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1043ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1043f0:	72 23                	jb     104415 <get_pte+0xb7>
  1043f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1043f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043f9:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104400:	00 
  104401:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
  104408:	00 
  104409:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104410:	e8 b1 c8 ff ff       	call   100cc6 <__panic>
  104415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104418:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10441d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104424:	00 
  104425:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10442c:	00 
  10442d:	89 04 24             	mov    %eax,(%esp)
  104430:	e8 e8 18 00 00       	call   105d1d <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
  104435:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104438:	83 c8 07             	or     $0x7,%eax
  10443b:	89 c2                	mov    %eax,%edx
  10443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104440:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104445:	8b 00                	mov    (%eax),%eax
  104447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10444c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10444f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104452:	c1 e8 0c             	shr    $0xc,%eax
  104455:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104458:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10445d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104460:	72 23                	jb     104485 <get_pte+0x127>
  104462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104465:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104469:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104470:	00 
  104471:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  104478:	00 
  104479:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104480:	e8 41 c8 ff ff       	call   100cc6 <__panic>
  104485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104488:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10448d:	8b 55 0c             	mov    0xc(%ebp),%edx
  104490:	c1 ea 0c             	shr    $0xc,%edx
  104493:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104499:	c1 e2 02             	shl    $0x2,%edx
  10449c:	01 d0                	add    %edx,%eax
}
  10449e:	c9                   	leave  
  10449f:	c3                   	ret    

001044a0 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1044a0:	55                   	push   %ebp
  1044a1:	89 e5                	mov    %esp,%ebp
  1044a3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1044a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044ad:	00 
  1044ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1044b8:	89 04 24             	mov    %eax,(%esp)
  1044bb:	e8 9e fe ff ff       	call   10435e <get_pte>
  1044c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1044c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1044c7:	74 08                	je     1044d1 <get_page+0x31>
        *ptep_store = ptep;
  1044c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1044cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044cf:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1044d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1044d5:	74 1b                	je     1044f2 <get_page+0x52>
  1044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044da:	8b 00                	mov    (%eax),%eax
  1044dc:	83 e0 01             	and    $0x1,%eax
  1044df:	85 c0                	test   %eax,%eax
  1044e1:	74 0f                	je     1044f2 <get_page+0x52>
        return pa2page(*ptep);
  1044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044e6:	8b 00                	mov    (%eax),%eax
  1044e8:	89 04 24             	mov    %eax,(%esp)
  1044eb:	e8 49 f4 ff ff       	call   103939 <pa2page>
  1044f0:	eb 05                	jmp    1044f7 <get_page+0x57>
    }
    return NULL;
  1044f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1044f7:	c9                   	leave  
  1044f8:	c3                   	ret    

001044f9 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1044f9:	55                   	push   %ebp
  1044fa:	89 e5                	mov    %esp,%ebp
  1044fc:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1044ff:	8b 45 10             	mov    0x10(%ebp),%eax
  104502:	8b 00                	mov    (%eax),%eax
  104504:	83 e0 01             	and    $0x1,%eax
  104507:	85 c0                	test   %eax,%eax
  104509:	74 4d                	je     104558 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  10450b:	8b 45 10             	mov    0x10(%ebp),%eax
  10450e:	8b 00                	mov    (%eax),%eax
  104510:	89 04 24             	mov    %eax,(%esp)
  104513:	e8 c4 f4 ff ff       	call   1039dc <pte2page>
  104518:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  10451b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10451e:	89 04 24             	mov    %eax,(%esp)
  104521:	e8 22 f5 ff ff       	call   103a48 <page_ref_dec>
  104526:	85 c0                	test   %eax,%eax
  104528:	75 13                	jne    10453d <page_remove_pte+0x44>
            free_page(page);
  10452a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104531:	00 
  104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104535:	89 04 24             	mov    %eax,(%esp)
  104538:	e8 1a f7 ff ff       	call   103c57 <free_pages>
        }
        *ptep = 0;
  10453d:	8b 45 10             	mov    0x10(%ebp),%eax
  104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  104546:	8b 45 0c             	mov    0xc(%ebp),%eax
  104549:	89 44 24 04          	mov    %eax,0x4(%esp)
  10454d:	8b 45 08             	mov    0x8(%ebp),%eax
  104550:	89 04 24             	mov    %eax,(%esp)
  104553:	e8 ff 00 00 00       	call   104657 <tlb_invalidate>
    }
}
  104558:	c9                   	leave  
  104559:	c3                   	ret    

0010455a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10455a:	55                   	push   %ebp
  10455b:	89 e5                	mov    %esp,%ebp
  10455d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104560:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104567:	00 
  104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  10456b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10456f:	8b 45 08             	mov    0x8(%ebp),%eax
  104572:	89 04 24             	mov    %eax,(%esp)
  104575:	e8 e4 fd ff ff       	call   10435e <get_pte>
  10457a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10457d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104581:	74 19                	je     10459c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104586:	89 44 24 08          	mov    %eax,0x8(%esp)
  10458a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10458d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104591:	8b 45 08             	mov    0x8(%ebp),%eax
  104594:	89 04 24             	mov    %eax,(%esp)
  104597:	e8 5d ff ff ff       	call   1044f9 <page_remove_pte>
    }
}
  10459c:	c9                   	leave  
  10459d:	c3                   	ret    

0010459e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10459e:	55                   	push   %ebp
  10459f:	89 e5                	mov    %esp,%ebp
  1045a1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1045a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1045ab:	00 
  1045ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1045af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1045b6:	89 04 24             	mov    %eax,(%esp)
  1045b9:	e8 a0 fd ff ff       	call   10435e <get_pte>
  1045be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1045c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045c5:	75 0a                	jne    1045d1 <page_insert+0x33>
        return -E_NO_MEM;
  1045c7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1045cc:	e9 84 00 00 00       	jmp    104655 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1045d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045d4:	89 04 24             	mov    %eax,(%esp)
  1045d7:	e8 55 f4 ff ff       	call   103a31 <page_ref_inc>
    if (*ptep & PTE_P) {
  1045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045df:	8b 00                	mov    (%eax),%eax
  1045e1:	83 e0 01             	and    $0x1,%eax
  1045e4:	85 c0                	test   %eax,%eax
  1045e6:	74 3e                	je     104626 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1045e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045eb:	8b 00                	mov    (%eax),%eax
  1045ed:	89 04 24             	mov    %eax,(%esp)
  1045f0:	e8 e7 f3 ff ff       	call   1039dc <pte2page>
  1045f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1045f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1045fe:	75 0d                	jne    10460d <page_insert+0x6f>
            page_ref_dec(page);
  104600:	8b 45 0c             	mov    0xc(%ebp),%eax
  104603:	89 04 24             	mov    %eax,(%esp)
  104606:	e8 3d f4 ff ff       	call   103a48 <page_ref_dec>
  10460b:	eb 19                	jmp    104626 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10460d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104610:	89 44 24 08          	mov    %eax,0x8(%esp)
  104614:	8b 45 10             	mov    0x10(%ebp),%eax
  104617:	89 44 24 04          	mov    %eax,0x4(%esp)
  10461b:	8b 45 08             	mov    0x8(%ebp),%eax
  10461e:	89 04 24             	mov    %eax,(%esp)
  104621:	e8 d3 fe ff ff       	call   1044f9 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104626:	8b 45 0c             	mov    0xc(%ebp),%eax
  104629:	89 04 24             	mov    %eax,(%esp)
  10462c:	e8 f2 f2 ff ff       	call   103923 <page2pa>
  104631:	0b 45 14             	or     0x14(%ebp),%eax
  104634:	83 c8 01             	or     $0x1,%eax
  104637:	89 c2                	mov    %eax,%edx
  104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10463c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10463e:	8b 45 10             	mov    0x10(%ebp),%eax
  104641:	89 44 24 04          	mov    %eax,0x4(%esp)
  104645:	8b 45 08             	mov    0x8(%ebp),%eax
  104648:	89 04 24             	mov    %eax,(%esp)
  10464b:	e8 07 00 00 00       	call   104657 <tlb_invalidate>
    return 0;
  104650:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104655:	c9                   	leave  
  104656:	c3                   	ret    

00104657 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104657:	55                   	push   %ebp
  104658:	89 e5                	mov    %esp,%ebp
  10465a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10465d:	0f 20 d8             	mov    %cr3,%eax
  104660:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104663:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104666:	89 c2                	mov    %eax,%edx
  104668:	8b 45 08             	mov    0x8(%ebp),%eax
  10466b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10466e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104675:	77 23                	ja     10469a <tlb_invalidate+0x43>
  104677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10467a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10467e:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  104685:	00 
  104686:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  10468d:	00 
  10468e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104695:	e8 2c c6 ff ff       	call   100cc6 <__panic>
  10469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469d:	05 00 00 00 40       	add    $0x40000000,%eax
  1046a2:	39 c2                	cmp    %eax,%edx
  1046a4:	75 0c                	jne    1046b2 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1046a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1046ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1046af:	0f 01 38             	invlpg (%eax)
    }
}
  1046b2:	c9                   	leave  
  1046b3:	c3                   	ret    

001046b4 <check_alloc_page>:

static void
check_alloc_page(void) {
  1046b4:	55                   	push   %ebp
  1046b5:	89 e5                	mov    %esp,%ebp
  1046b7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1046ba:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1046bf:	8b 40 18             	mov    0x18(%eax),%eax
  1046c2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1046c4:	c7 04 24 b4 6a 10 00 	movl   $0x106ab4,(%esp)
  1046cb:	e8 6c bc ff ff       	call   10033c <cprintf>
}
  1046d0:	c9                   	leave  
  1046d1:	c3                   	ret    

001046d2 <check_pgdir>:

static void
check_pgdir(void) {
  1046d2:	55                   	push   %ebp
  1046d3:	89 e5                	mov    %esp,%ebp
  1046d5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1046d8:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1046dd:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1046e2:	76 24                	jbe    104708 <check_pgdir+0x36>
  1046e4:	c7 44 24 0c d3 6a 10 	movl   $0x106ad3,0xc(%esp)
  1046eb:	00 
  1046ec:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1046f3:	00 
  1046f4:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  1046fb:	00 
  1046fc:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104703:	e8 be c5 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104708:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10470d:	85 c0                	test   %eax,%eax
  10470f:	74 0e                	je     10471f <check_pgdir+0x4d>
  104711:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104716:	25 ff 0f 00 00       	and    $0xfff,%eax
  10471b:	85 c0                	test   %eax,%eax
  10471d:	74 24                	je     104743 <check_pgdir+0x71>
  10471f:	c7 44 24 0c f0 6a 10 	movl   $0x106af0,0xc(%esp)
  104726:	00 
  104727:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10472e:	00 
  10472f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104736:	00 
  104737:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10473e:	e8 83 c5 ff ff       	call   100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104743:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104748:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10474f:	00 
  104750:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104757:	00 
  104758:	89 04 24             	mov    %eax,(%esp)
  10475b:	e8 40 fd ff ff       	call   1044a0 <get_page>
  104760:	85 c0                	test   %eax,%eax
  104762:	74 24                	je     104788 <check_pgdir+0xb6>
  104764:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  10476b:	00 
  10476c:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104773:	00 
  104774:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  10477b:	00 
  10477c:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104783:	e8 3e c5 ff ff       	call   100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104788:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10478f:	e8 8b f4 ff ff       	call   103c1f <alloc_pages>
  104794:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104797:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10479c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1047a3:	00 
  1047a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047ab:	00 
  1047ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047b3:	89 04 24             	mov    %eax,(%esp)
  1047b6:	e8 e3 fd ff ff       	call   10459e <page_insert>
  1047bb:	85 c0                	test   %eax,%eax
  1047bd:	74 24                	je     1047e3 <check_pgdir+0x111>
  1047bf:	c7 44 24 0c 50 6b 10 	movl   $0x106b50,0xc(%esp)
  1047c6:	00 
  1047c7:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1047ce:	00 
  1047cf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  1047d6:	00 
  1047d7:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1047de:	e8 e3 c4 ff ff       	call   100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1047e3:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047ef:	00 
  1047f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047f7:	00 
  1047f8:	89 04 24             	mov    %eax,(%esp)
  1047fb:	e8 5e fb ff ff       	call   10435e <get_pte>
  104800:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104807:	75 24                	jne    10482d <check_pgdir+0x15b>
  104809:	c7 44 24 0c 7c 6b 10 	movl   $0x106b7c,0xc(%esp)
  104810:	00 
  104811:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104818:	00 
  104819:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104820:	00 
  104821:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104828:	e8 99 c4 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  10482d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104830:	8b 00                	mov    (%eax),%eax
  104832:	89 04 24             	mov    %eax,(%esp)
  104835:	e8 ff f0 ff ff       	call   103939 <pa2page>
  10483a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10483d:	74 24                	je     104863 <check_pgdir+0x191>
  10483f:	c7 44 24 0c a9 6b 10 	movl   $0x106ba9,0xc(%esp)
  104846:	00 
  104847:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10484e:	00 
  10484f:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104856:	00 
  104857:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10485e:	e8 63 c4 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 1);
  104863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104866:	89 04 24             	mov    %eax,(%esp)
  104869:	e8 ac f1 ff ff       	call   103a1a <page_ref>
  10486e:	83 f8 01             	cmp    $0x1,%eax
  104871:	74 24                	je     104897 <check_pgdir+0x1c5>
  104873:	c7 44 24 0c be 6b 10 	movl   $0x106bbe,0xc(%esp)
  10487a:	00 
  10487b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104882:	00 
  104883:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  10488a:	00 
  10488b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104892:	e8 2f c4 ff ff       	call   100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104897:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10489c:	8b 00                	mov    (%eax),%eax
  10489e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1048a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1048a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048a9:	c1 e8 0c             	shr    $0xc,%eax
  1048ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1048af:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1048b4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1048b7:	72 23                	jb     1048dc <check_pgdir+0x20a>
  1048b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1048c0:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  1048c7:	00 
  1048c8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1048cf:	00 
  1048d0:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1048d7:	e8 ea c3 ff ff       	call   100cc6 <__panic>
  1048dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048df:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1048e4:	83 c0 04             	add    $0x4,%eax
  1048e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1048ea:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048f6:	00 
  1048f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1048fe:	00 
  1048ff:	89 04 24             	mov    %eax,(%esp)
  104902:	e8 57 fa ff ff       	call   10435e <get_pte>
  104907:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10490a:	74 24                	je     104930 <check_pgdir+0x25e>
  10490c:	c7 44 24 0c d0 6b 10 	movl   $0x106bd0,0xc(%esp)
  104913:	00 
  104914:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10491b:	00 
  10491c:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  104923:	00 
  104924:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10492b:	e8 96 c3 ff ff       	call   100cc6 <__panic>

    p2 = alloc_page();
  104930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104937:	e8 e3 f2 ff ff       	call   103c1f <alloc_pages>
  10493c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10493f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104944:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10494b:	00 
  10494c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104953:	00 
  104954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104957:	89 54 24 04          	mov    %edx,0x4(%esp)
  10495b:	89 04 24             	mov    %eax,(%esp)
  10495e:	e8 3b fc ff ff       	call   10459e <page_insert>
  104963:	85 c0                	test   %eax,%eax
  104965:	74 24                	je     10498b <check_pgdir+0x2b9>
  104967:	c7 44 24 0c f8 6b 10 	movl   $0x106bf8,0xc(%esp)
  10496e:	00 
  10496f:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104976:	00 
  104977:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  10497e:	00 
  10497f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104986:	e8 3b c3 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10498b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104990:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104997:	00 
  104998:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10499f:	00 
  1049a0:	89 04 24             	mov    %eax,(%esp)
  1049a3:	e8 b6 f9 ff ff       	call   10435e <get_pte>
  1049a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1049ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1049af:	75 24                	jne    1049d5 <check_pgdir+0x303>
  1049b1:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  1049b8:	00 
  1049b9:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1049c0:	00 
  1049c1:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1049c8:	00 
  1049c9:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1049d0:	e8 f1 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_U);
  1049d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049d8:	8b 00                	mov    (%eax),%eax
  1049da:	83 e0 04             	and    $0x4,%eax
  1049dd:	85 c0                	test   %eax,%eax
  1049df:	75 24                	jne    104a05 <check_pgdir+0x333>
  1049e1:	c7 44 24 0c 60 6c 10 	movl   $0x106c60,0xc(%esp)
  1049e8:	00 
  1049e9:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  1049f0:	00 
  1049f1:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  1049f8:	00 
  1049f9:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a00:	e8 c1 c2 ff ff       	call   100cc6 <__panic>
    assert(*ptep & PTE_W);
  104a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a08:	8b 00                	mov    (%eax),%eax
  104a0a:	83 e0 02             	and    $0x2,%eax
  104a0d:	85 c0                	test   %eax,%eax
  104a0f:	75 24                	jne    104a35 <check_pgdir+0x363>
  104a11:	c7 44 24 0c 6e 6c 10 	movl   $0x106c6e,0xc(%esp)
  104a18:	00 
  104a19:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a20:	00 
  104a21:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104a28:	00 
  104a29:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a30:	e8 91 c2 ff ff       	call   100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104a35:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a3a:	8b 00                	mov    (%eax),%eax
  104a3c:	83 e0 04             	and    $0x4,%eax
  104a3f:	85 c0                	test   %eax,%eax
  104a41:	75 24                	jne    104a67 <check_pgdir+0x395>
  104a43:	c7 44 24 0c 7c 6c 10 	movl   $0x106c7c,0xc(%esp)
  104a4a:	00 
  104a4b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a52:	00 
  104a53:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104a5a:	00 
  104a5b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a62:	e8 5f c2 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 1);
  104a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104a6a:	89 04 24             	mov    %eax,(%esp)
  104a6d:	e8 a8 ef ff ff       	call   103a1a <page_ref>
  104a72:	83 f8 01             	cmp    $0x1,%eax
  104a75:	74 24                	je     104a9b <check_pgdir+0x3c9>
  104a77:	c7 44 24 0c 92 6c 10 	movl   $0x106c92,0xc(%esp)
  104a7e:	00 
  104a7f:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104a86:	00 
  104a87:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104a8e:	00 
  104a8f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104a96:	e8 2b c2 ff ff       	call   100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104a9b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104aa0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104aa7:	00 
  104aa8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104aaf:	00 
  104ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ab3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ab7:	89 04 24             	mov    %eax,(%esp)
  104aba:	e8 df fa ff ff       	call   10459e <page_insert>
  104abf:	85 c0                	test   %eax,%eax
  104ac1:	74 24                	je     104ae7 <check_pgdir+0x415>
  104ac3:	c7 44 24 0c a4 6c 10 	movl   $0x106ca4,0xc(%esp)
  104aca:	00 
  104acb:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104ad2:	00 
  104ad3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104ada:	00 
  104adb:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104ae2:	e8 df c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p1) == 2);
  104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104aea:	89 04 24             	mov    %eax,(%esp)
  104aed:	e8 28 ef ff ff       	call   103a1a <page_ref>
  104af2:	83 f8 02             	cmp    $0x2,%eax
  104af5:	74 24                	je     104b1b <check_pgdir+0x449>
  104af7:	c7 44 24 0c d0 6c 10 	movl   $0x106cd0,0xc(%esp)
  104afe:	00 
  104aff:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b06:	00 
  104b07:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104b0e:	00 
  104b0f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104b16:	e8 ab c1 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b1e:	89 04 24             	mov    %eax,(%esp)
  104b21:	e8 f4 ee ff ff       	call   103a1a <page_ref>
  104b26:	85 c0                	test   %eax,%eax
  104b28:	74 24                	je     104b4e <check_pgdir+0x47c>
  104b2a:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104b31:	00 
  104b32:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b39:	00 
  104b3a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104b41:	00 
  104b42:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104b49:	e8 78 c1 ff ff       	call   100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104b4e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b5a:	00 
  104b5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104b62:	00 
  104b63:	89 04 24             	mov    %eax,(%esp)
  104b66:	e8 f3 f7 ff ff       	call   10435e <get_pte>
  104b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b72:	75 24                	jne    104b98 <check_pgdir+0x4c6>
  104b74:	c7 44 24 0c 30 6c 10 	movl   $0x106c30,0xc(%esp)
  104b7b:	00 
  104b7c:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104b83:	00 
  104b84:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b8b:	00 
  104b8c:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104b93:	e8 2e c1 ff ff       	call   100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
  104b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b9b:	8b 00                	mov    (%eax),%eax
  104b9d:	89 04 24             	mov    %eax,(%esp)
  104ba0:	e8 94 ed ff ff       	call   103939 <pa2page>
  104ba5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ba8:	74 24                	je     104bce <check_pgdir+0x4fc>
  104baa:	c7 44 24 0c a9 6b 10 	movl   $0x106ba9,0xc(%esp)
  104bb1:	00 
  104bb2:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104bb9:	00 
  104bba:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104bc1:	00 
  104bc2:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104bc9:	e8 f8 c0 ff ff       	call   100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
  104bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104bd1:	8b 00                	mov    (%eax),%eax
  104bd3:	83 e0 04             	and    $0x4,%eax
  104bd6:	85 c0                	test   %eax,%eax
  104bd8:	74 24                	je     104bfe <check_pgdir+0x52c>
  104bda:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  104be1:	00 
  104be2:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104be9:	00 
  104bea:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104bf1:	00 
  104bf2:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104bf9:	e8 c8 c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
  104bfe:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104c0a:	00 
  104c0b:	89 04 24             	mov    %eax,(%esp)
  104c0e:	e8 47 f9 ff ff       	call   10455a <page_remove>
    assert(page_ref(p1) == 1);
  104c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c16:	89 04 24             	mov    %eax,(%esp)
  104c19:	e8 fc ed ff ff       	call   103a1a <page_ref>
  104c1e:	83 f8 01             	cmp    $0x1,%eax
  104c21:	74 24                	je     104c47 <check_pgdir+0x575>
  104c23:	c7 44 24 0c be 6b 10 	movl   $0x106bbe,0xc(%esp)
  104c2a:	00 
  104c2b:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104c32:	00 
  104c33:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104c3a:	00 
  104c3b:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104c42:	e8 7f c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c4a:	89 04 24             	mov    %eax,(%esp)
  104c4d:	e8 c8 ed ff ff       	call   103a1a <page_ref>
  104c52:	85 c0                	test   %eax,%eax
  104c54:	74 24                	je     104c7a <check_pgdir+0x5a8>
  104c56:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104c5d:	00 
  104c5e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104c65:	00 
  104c66:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104c6d:	00 
  104c6e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104c75:	e8 4c c0 ff ff       	call   100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104c7a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c7f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c86:	00 
  104c87:	89 04 24             	mov    %eax,(%esp)
  104c8a:	e8 cb f8 ff ff       	call   10455a <page_remove>
    assert(page_ref(p1) == 0);
  104c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104c92:	89 04 24             	mov    %eax,(%esp)
  104c95:	e8 80 ed ff ff       	call   103a1a <page_ref>
  104c9a:	85 c0                	test   %eax,%eax
  104c9c:	74 24                	je     104cc2 <check_pgdir+0x5f0>
  104c9e:	c7 44 24 0c 09 6d 10 	movl   $0x106d09,0xc(%esp)
  104ca5:	00 
  104ca6:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104cad:	00 
  104cae:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104cb5:	00 
  104cb6:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104cbd:	e8 04 c0 ff ff       	call   100cc6 <__panic>
    assert(page_ref(p2) == 0);
  104cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104cc5:	89 04 24             	mov    %eax,(%esp)
  104cc8:	e8 4d ed ff ff       	call   103a1a <page_ref>
  104ccd:	85 c0                	test   %eax,%eax
  104ccf:	74 24                	je     104cf5 <check_pgdir+0x623>
  104cd1:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  104cd8:	00 
  104cd9:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104ce0:	00 
  104ce1:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104ce8:	00 
  104ce9:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104cf0:	e8 d1 bf ff ff       	call   100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104cf5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cfa:	8b 00                	mov    (%eax),%eax
  104cfc:	89 04 24             	mov    %eax,(%esp)
  104cff:	e8 35 ec ff ff       	call   103939 <pa2page>
  104d04:	89 04 24             	mov    %eax,(%esp)
  104d07:	e8 0e ed ff ff       	call   103a1a <page_ref>
  104d0c:	83 f8 01             	cmp    $0x1,%eax
  104d0f:	74 24                	je     104d35 <check_pgdir+0x663>
  104d11:	c7 44 24 0c 1c 6d 10 	movl   $0x106d1c,0xc(%esp)
  104d18:	00 
  104d19:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104d20:	00 
  104d21:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  104d28:	00 
  104d29:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104d30:	e8 91 bf ff ff       	call   100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104d35:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d3a:	8b 00                	mov    (%eax),%eax
  104d3c:	89 04 24             	mov    %eax,(%esp)
  104d3f:	e8 f5 eb ff ff       	call   103939 <pa2page>
  104d44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d4b:	00 
  104d4c:	89 04 24             	mov    %eax,(%esp)
  104d4f:	e8 03 ef ff ff       	call   103c57 <free_pages>
    boot_pgdir[0] = 0;
  104d54:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104d5f:	c7 04 24 42 6d 10 00 	movl   $0x106d42,(%esp)
  104d66:	e8 d1 b5 ff ff       	call   10033c <cprintf>
}
  104d6b:	c9                   	leave  
  104d6c:	c3                   	ret    

00104d6d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104d6d:	55                   	push   %ebp
  104d6e:	89 e5                	mov    %esp,%ebp
  104d70:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104d73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d7a:	e9 ca 00 00 00       	jmp    104e49 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d88:	c1 e8 0c             	shr    $0xc,%eax
  104d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d8e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104d93:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104d96:	72 23                	jb     104dbb <check_boot_pgdir+0x4e>
  104d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104d9f:	c7 44 24 08 8c 69 10 	movl   $0x10698c,0x8(%esp)
  104da6:	00 
  104da7:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104dae:	00 
  104daf:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104db6:	e8 0b bf ff ff       	call   100cc6 <__panic>
  104dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dbe:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104dc3:	89 c2                	mov    %eax,%edx
  104dc5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104dca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104dd1:	00 
  104dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104dd6:	89 04 24             	mov    %eax,(%esp)
  104dd9:	e8 80 f5 ff ff       	call   10435e <get_pte>
  104dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104de1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104de5:	75 24                	jne    104e0b <check_boot_pgdir+0x9e>
  104de7:	c7 44 24 0c 5c 6d 10 	movl   $0x106d5c,0xc(%esp)
  104dee:	00 
  104def:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104df6:	00 
  104df7:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104dfe:	00 
  104dff:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104e06:	e8 bb be ff ff       	call   100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e0e:	8b 00                	mov    (%eax),%eax
  104e10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e15:	89 c2                	mov    %eax,%edx
  104e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e1a:	39 c2                	cmp    %eax,%edx
  104e1c:	74 24                	je     104e42 <check_boot_pgdir+0xd5>
  104e1e:	c7 44 24 0c 99 6d 10 	movl   $0x106d99,0xc(%esp)
  104e25:	00 
  104e26:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104e2d:	00 
  104e2e:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
  104e35:	00 
  104e36:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104e3d:	e8 84 be ff ff       	call   100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e42:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e4c:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e51:	39 c2                	cmp    %eax,%edx
  104e53:	0f 82 26 ff ff ff    	jb     104d7f <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104e59:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e5e:	05 ac 0f 00 00       	add    $0xfac,%eax
  104e63:	8b 00                	mov    (%eax),%eax
  104e65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104e6a:	89 c2                	mov    %eax,%edx
  104e6c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e74:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104e7b:	77 23                	ja     104ea0 <check_boot_pgdir+0x133>
  104e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e80:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e84:	c7 44 24 08 30 6a 10 	movl   $0x106a30,0x8(%esp)
  104e8b:	00 
  104e8c:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104e93:	00 
  104e94:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104e9b:	e8 26 be ff ff       	call   100cc6 <__panic>
  104ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104ea3:	05 00 00 00 40       	add    $0x40000000,%eax
  104ea8:	39 c2                	cmp    %eax,%edx
  104eaa:	74 24                	je     104ed0 <check_boot_pgdir+0x163>
  104eac:	c7 44 24 0c b0 6d 10 	movl   $0x106db0,0xc(%esp)
  104eb3:	00 
  104eb4:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104ebb:	00 
  104ebc:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  104ec3:	00 
  104ec4:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104ecb:	e8 f6 bd ff ff       	call   100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
  104ed0:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104ed5:	8b 00                	mov    (%eax),%eax
  104ed7:	85 c0                	test   %eax,%eax
  104ed9:	74 24                	je     104eff <check_boot_pgdir+0x192>
  104edb:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104ee2:	00 
  104ee3:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104eea:	00 
  104eeb:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104ef2:	00 
  104ef3:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104efa:	e8 c7 bd ff ff       	call   100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
  104eff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f06:	e8 14 ed ff ff       	call   103c1f <alloc_pages>
  104f0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104f0e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f13:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f1a:	00 
  104f1b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104f22:	00 
  104f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f26:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f2a:	89 04 24             	mov    %eax,(%esp)
  104f2d:	e8 6c f6 ff ff       	call   10459e <page_insert>
  104f32:	85 c0                	test   %eax,%eax
  104f34:	74 24                	je     104f5a <check_boot_pgdir+0x1ed>
  104f36:	c7 44 24 0c f8 6d 10 	movl   $0x106df8,0xc(%esp)
  104f3d:	00 
  104f3e:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104f45:	00 
  104f46:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  104f4d:	00 
  104f4e:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104f55:	e8 6c bd ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 1);
  104f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f5d:	89 04 24             	mov    %eax,(%esp)
  104f60:	e8 b5 ea ff ff       	call   103a1a <page_ref>
  104f65:	83 f8 01             	cmp    $0x1,%eax
  104f68:	74 24                	je     104f8e <check_boot_pgdir+0x221>
  104f6a:	c7 44 24 0c 26 6e 10 	movl   $0x106e26,0xc(%esp)
  104f71:	00 
  104f72:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104f79:	00 
  104f7a:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  104f81:	00 
  104f82:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104f89:	e8 38 bd ff ff       	call   100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104f8e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f93:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104f9a:	00 
  104f9b:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104fa2:	00 
  104fa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fa6:	89 54 24 04          	mov    %edx,0x4(%esp)
  104faa:	89 04 24             	mov    %eax,(%esp)
  104fad:	e8 ec f5 ff ff       	call   10459e <page_insert>
  104fb2:	85 c0                	test   %eax,%eax
  104fb4:	74 24                	je     104fda <check_boot_pgdir+0x26d>
  104fb6:	c7 44 24 0c 38 6e 10 	movl   $0x106e38,0xc(%esp)
  104fbd:	00 
  104fbe:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104fc5:	00 
  104fc6:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  104fcd:	00 
  104fce:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  104fd5:	e8 ec bc ff ff       	call   100cc6 <__panic>
    assert(page_ref(p) == 2);
  104fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104fdd:	89 04 24             	mov    %eax,(%esp)
  104fe0:	e8 35 ea ff ff       	call   103a1a <page_ref>
  104fe5:	83 f8 02             	cmp    $0x2,%eax
  104fe8:	74 24                	je     10500e <check_boot_pgdir+0x2a1>
  104fea:	c7 44 24 0c 6f 6e 10 	movl   $0x106e6f,0xc(%esp)
  104ff1:	00 
  104ff2:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  104ff9:	00 
  104ffa:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  105001:	00 
  105002:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  105009:	e8 b8 bc ff ff       	call   100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
  10500e:	c7 45 dc 80 6e 10 00 	movl   $0x106e80,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105015:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105018:	89 44 24 04          	mov    %eax,0x4(%esp)
  10501c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105023:	e8 1e 0a 00 00       	call   105a46 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105028:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10502f:	00 
  105030:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105037:	e8 83 0a 00 00       	call   105abf <strcmp>
  10503c:	85 c0                	test   %eax,%eax
  10503e:	74 24                	je     105064 <check_boot_pgdir+0x2f7>
  105040:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  105047:	00 
  105048:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  10504f:	00 
  105050:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  105057:	00 
  105058:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  10505f:	e8 62 bc ff ff       	call   100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105064:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105067:	89 04 24             	mov    %eax,(%esp)
  10506a:	e8 19 e9 ff ff       	call   103988 <page2kva>
  10506f:	05 00 01 00 00       	add    $0x100,%eax
  105074:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105077:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10507e:	e8 6b 09 00 00       	call   1059ee <strlen>
  105083:	85 c0                	test   %eax,%eax
  105085:	74 24                	je     1050ab <check_boot_pgdir+0x33e>
  105087:	c7 44 24 0c d0 6e 10 	movl   $0x106ed0,0xc(%esp)
  10508e:	00 
  10508f:	c7 44 24 08 79 6a 10 	movl   $0x106a79,0x8(%esp)
  105096:	00 
  105097:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
  10509e:	00 
  10509f:	c7 04 24 54 6a 10 00 	movl   $0x106a54,(%esp)
  1050a6:	e8 1b bc ff ff       	call   100cc6 <__panic>

    free_page(p);
  1050ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050b2:	00 
  1050b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050b6:	89 04 24             	mov    %eax,(%esp)
  1050b9:	e8 99 eb ff ff       	call   103c57 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1050be:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050c3:	8b 00                	mov    (%eax),%eax
  1050c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1050ca:	89 04 24             	mov    %eax,(%esp)
  1050cd:	e8 67 e8 ff ff       	call   103939 <pa2page>
  1050d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050d9:	00 
  1050da:	89 04 24             	mov    %eax,(%esp)
  1050dd:	e8 75 eb ff ff       	call   103c57 <free_pages>
    boot_pgdir[0] = 0;
  1050e2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1050e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1050ed:	c7 04 24 f4 6e 10 00 	movl   $0x106ef4,(%esp)
  1050f4:	e8 43 b2 ff ff       	call   10033c <cprintf>
}
  1050f9:	c9                   	leave  
  1050fa:	c3                   	ret    

001050fb <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1050fb:	55                   	push   %ebp
  1050fc:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1050fe:	8b 45 08             	mov    0x8(%ebp),%eax
  105101:	83 e0 04             	and    $0x4,%eax
  105104:	85 c0                	test   %eax,%eax
  105106:	74 07                	je     10510f <perm2str+0x14>
  105108:	b8 75 00 00 00       	mov    $0x75,%eax
  10510d:	eb 05                	jmp    105114 <perm2str+0x19>
  10510f:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105114:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105119:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105120:	8b 45 08             	mov    0x8(%ebp),%eax
  105123:	83 e0 02             	and    $0x2,%eax
  105126:	85 c0                	test   %eax,%eax
  105128:	74 07                	je     105131 <perm2str+0x36>
  10512a:	b8 77 00 00 00       	mov    $0x77,%eax
  10512f:	eb 05                	jmp    105136 <perm2str+0x3b>
  105131:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105136:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10513b:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105142:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105147:	5d                   	pop    %ebp
  105148:	c3                   	ret    

00105149 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105149:	55                   	push   %ebp
  10514a:	89 e5                	mov    %esp,%ebp
  10514c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10514f:	8b 45 10             	mov    0x10(%ebp),%eax
  105152:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105155:	72 0a                	jb     105161 <get_pgtable_items+0x18>
        return 0;
  105157:	b8 00 00 00 00       	mov    $0x0,%eax
  10515c:	e9 9c 00 00 00       	jmp    1051fd <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105161:	eb 04                	jmp    105167 <get_pgtable_items+0x1e>
        start ++;
  105163:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105167:	8b 45 10             	mov    0x10(%ebp),%eax
  10516a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10516d:	73 18                	jae    105187 <get_pgtable_items+0x3e>
  10516f:	8b 45 10             	mov    0x10(%ebp),%eax
  105172:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105179:	8b 45 14             	mov    0x14(%ebp),%eax
  10517c:	01 d0                	add    %edx,%eax
  10517e:	8b 00                	mov    (%eax),%eax
  105180:	83 e0 01             	and    $0x1,%eax
  105183:	85 c0                	test   %eax,%eax
  105185:	74 dc                	je     105163 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105187:	8b 45 10             	mov    0x10(%ebp),%eax
  10518a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10518d:	73 69                	jae    1051f8 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10518f:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105193:	74 08                	je     10519d <get_pgtable_items+0x54>
            *left_store = start;
  105195:	8b 45 18             	mov    0x18(%ebp),%eax
  105198:	8b 55 10             	mov    0x10(%ebp),%edx
  10519b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10519d:	8b 45 10             	mov    0x10(%ebp),%eax
  1051a0:	8d 50 01             	lea    0x1(%eax),%edx
  1051a3:	89 55 10             	mov    %edx,0x10(%ebp)
  1051a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051ad:	8b 45 14             	mov    0x14(%ebp),%eax
  1051b0:	01 d0                	add    %edx,%eax
  1051b2:	8b 00                	mov    (%eax),%eax
  1051b4:	83 e0 07             	and    $0x7,%eax
  1051b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051ba:	eb 04                	jmp    1051c0 <get_pgtable_items+0x77>
            start ++;
  1051bc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1051c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1051c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1051c6:	73 1d                	jae    1051e5 <get_pgtable_items+0x9c>
  1051c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1051cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1051d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1051d5:	01 d0                	add    %edx,%eax
  1051d7:	8b 00                	mov    (%eax),%eax
  1051d9:	83 e0 07             	and    $0x7,%eax
  1051dc:	89 c2                	mov    %eax,%edx
  1051de:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051e1:	39 c2                	cmp    %eax,%edx
  1051e3:	74 d7                	je     1051bc <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1051e5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1051e9:	74 08                	je     1051f3 <get_pgtable_items+0xaa>
            *right_store = start;
  1051eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1051ee:	8b 55 10             	mov    0x10(%ebp),%edx
  1051f1:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1051f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1051f6:	eb 05                	jmp    1051fd <get_pgtable_items+0xb4>
    }
    return 0;
  1051f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1051fd:	c9                   	leave  
  1051fe:	c3                   	ret    

001051ff <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1051ff:	55                   	push   %ebp
  105200:	89 e5                	mov    %esp,%ebp
  105202:	57                   	push   %edi
  105203:	56                   	push   %esi
  105204:	53                   	push   %ebx
  105205:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  105208:	c7 04 24 14 6f 10 00 	movl   $0x106f14,(%esp)
  10520f:	e8 28 b1 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105214:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10521b:	e9 fa 00 00 00       	jmp    10531a <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105223:	89 04 24             	mov    %eax,(%esp)
  105226:	e8 d0 fe ff ff       	call   1050fb <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10522b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10522e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105231:	29 d1                	sub    %edx,%ecx
  105233:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105235:	89 d6                	mov    %edx,%esi
  105237:	c1 e6 16             	shl    $0x16,%esi
  10523a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10523d:	89 d3                	mov    %edx,%ebx
  10523f:	c1 e3 16             	shl    $0x16,%ebx
  105242:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105245:	89 d1                	mov    %edx,%ecx
  105247:	c1 e1 16             	shl    $0x16,%ecx
  10524a:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10524d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105250:	29 d7                	sub    %edx,%edi
  105252:	89 fa                	mov    %edi,%edx
  105254:	89 44 24 14          	mov    %eax,0x14(%esp)
  105258:	89 74 24 10          	mov    %esi,0x10(%esp)
  10525c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105260:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105264:	89 54 24 04          	mov    %edx,0x4(%esp)
  105268:	c7 04 24 45 6f 10 00 	movl   $0x106f45,(%esp)
  10526f:	e8 c8 b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105274:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105277:	c1 e0 0a             	shl    $0xa,%eax
  10527a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10527d:	eb 54                	jmp    1052d3 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10527f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105282:	89 04 24             	mov    %eax,(%esp)
  105285:	e8 71 fe ff ff       	call   1050fb <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10528a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10528d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105290:	29 d1                	sub    %edx,%ecx
  105292:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105294:	89 d6                	mov    %edx,%esi
  105296:	c1 e6 0c             	shl    $0xc,%esi
  105299:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10529c:	89 d3                	mov    %edx,%ebx
  10529e:	c1 e3 0c             	shl    $0xc,%ebx
  1052a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052a4:	c1 e2 0c             	shl    $0xc,%edx
  1052a7:	89 d1                	mov    %edx,%ecx
  1052a9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1052ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1052af:	29 d7                	sub    %edx,%edi
  1052b1:	89 fa                	mov    %edi,%edx
  1052b3:	89 44 24 14          	mov    %eax,0x14(%esp)
  1052b7:	89 74 24 10          	mov    %esi,0x10(%esp)
  1052bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1052bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1052c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1052c7:	c7 04 24 64 6f 10 00 	movl   $0x106f64,(%esp)
  1052ce:	e8 69 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1052d3:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1052d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1052db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052de:	89 ce                	mov    %ecx,%esi
  1052e0:	c1 e6 0a             	shl    $0xa,%esi
  1052e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1052e6:	89 cb                	mov    %ecx,%ebx
  1052e8:	c1 e3 0a             	shl    $0xa,%ebx
  1052eb:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1052ee:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1052f2:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1052f5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1052f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1052fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  105301:	89 74 24 04          	mov    %esi,0x4(%esp)
  105305:	89 1c 24             	mov    %ebx,(%esp)
  105308:	e8 3c fe ff ff       	call   105149 <get_pgtable_items>
  10530d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105310:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105314:	0f 85 65 ff ff ff    	jne    10527f <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10531a:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10531f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105322:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105325:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105329:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10532c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105330:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105334:	89 44 24 08          	mov    %eax,0x8(%esp)
  105338:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10533f:	00 
  105340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105347:	e8 fd fd ff ff       	call   105149 <get_pgtable_items>
  10534c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10534f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105353:	0f 85 c7 fe ff ff    	jne    105220 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105359:	c7 04 24 88 6f 10 00 	movl   $0x106f88,(%esp)
  105360:	e8 d7 af ff ff       	call   10033c <cprintf>
}
  105365:	83 c4 4c             	add    $0x4c,%esp
  105368:	5b                   	pop    %ebx
  105369:	5e                   	pop    %esi
  10536a:	5f                   	pop    %edi
  10536b:	5d                   	pop    %ebp
  10536c:	c3                   	ret    

0010536d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10536d:	55                   	push   %ebp
  10536e:	89 e5                	mov    %esp,%ebp
  105370:	83 ec 58             	sub    $0x58,%esp
  105373:	8b 45 10             	mov    0x10(%ebp),%eax
  105376:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105379:	8b 45 14             	mov    0x14(%ebp),%eax
  10537c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10537f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105382:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105385:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105388:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10538b:	8b 45 18             	mov    0x18(%ebp),%eax
  10538e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105391:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105394:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105397:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10539a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10539d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1053a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053a7:	74 1c                	je     1053c5 <printnum+0x58>
  1053a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053ac:	ba 00 00 00 00       	mov    $0x0,%edx
  1053b1:	f7 75 e4             	divl   -0x1c(%ebp)
  1053b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1053b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1053ba:	ba 00 00 00 00       	mov    $0x0,%edx
  1053bf:	f7 75 e4             	divl   -0x1c(%ebp)
  1053c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1053c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1053cb:	f7 75 e4             	divl   -0x1c(%ebp)
  1053ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1053d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1053d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1053da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1053e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053e3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1053e6:	8b 45 18             	mov    0x18(%ebp),%eax
  1053e9:	ba 00 00 00 00       	mov    $0x0,%edx
  1053ee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053f1:	77 56                	ja     105449 <printnum+0xdc>
  1053f3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1053f6:	72 05                	jb     1053fd <printnum+0x90>
  1053f8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1053fb:	77 4c                	ja     105449 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1053fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105400:	8d 50 ff             	lea    -0x1(%eax),%edx
  105403:	8b 45 20             	mov    0x20(%ebp),%eax
  105406:	89 44 24 18          	mov    %eax,0x18(%esp)
  10540a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10540e:	8b 45 18             	mov    0x18(%ebp),%eax
  105411:	89 44 24 10          	mov    %eax,0x10(%esp)
  105415:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105418:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10541b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10541f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105423:	8b 45 0c             	mov    0xc(%ebp),%eax
  105426:	89 44 24 04          	mov    %eax,0x4(%esp)
  10542a:	8b 45 08             	mov    0x8(%ebp),%eax
  10542d:	89 04 24             	mov    %eax,(%esp)
  105430:	e8 38 ff ff ff       	call   10536d <printnum>
  105435:	eb 1c                	jmp    105453 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105437:	8b 45 0c             	mov    0xc(%ebp),%eax
  10543a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10543e:	8b 45 20             	mov    0x20(%ebp),%eax
  105441:	89 04 24             	mov    %eax,(%esp)
  105444:	8b 45 08             	mov    0x8(%ebp),%eax
  105447:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105449:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10544d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105451:	7f e4                	jg     105437 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105453:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105456:	05 3c 70 10 00       	add    $0x10703c,%eax
  10545b:	0f b6 00             	movzbl (%eax),%eax
  10545e:	0f be c0             	movsbl %al,%eax
  105461:	8b 55 0c             	mov    0xc(%ebp),%edx
  105464:	89 54 24 04          	mov    %edx,0x4(%esp)
  105468:	89 04 24             	mov    %eax,(%esp)
  10546b:	8b 45 08             	mov    0x8(%ebp),%eax
  10546e:	ff d0                	call   *%eax
}
  105470:	c9                   	leave  
  105471:	c3                   	ret    

00105472 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105472:	55                   	push   %ebp
  105473:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105475:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105479:	7e 14                	jle    10548f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10547b:	8b 45 08             	mov    0x8(%ebp),%eax
  10547e:	8b 00                	mov    (%eax),%eax
  105480:	8d 48 08             	lea    0x8(%eax),%ecx
  105483:	8b 55 08             	mov    0x8(%ebp),%edx
  105486:	89 0a                	mov    %ecx,(%edx)
  105488:	8b 50 04             	mov    0x4(%eax),%edx
  10548b:	8b 00                	mov    (%eax),%eax
  10548d:	eb 30                	jmp    1054bf <getuint+0x4d>
    }
    else if (lflag) {
  10548f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105493:	74 16                	je     1054ab <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105495:	8b 45 08             	mov    0x8(%ebp),%eax
  105498:	8b 00                	mov    (%eax),%eax
  10549a:	8d 48 04             	lea    0x4(%eax),%ecx
  10549d:	8b 55 08             	mov    0x8(%ebp),%edx
  1054a0:	89 0a                	mov    %ecx,(%edx)
  1054a2:	8b 00                	mov    (%eax),%eax
  1054a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1054a9:	eb 14                	jmp    1054bf <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1054ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ae:	8b 00                	mov    (%eax),%eax
  1054b0:	8d 48 04             	lea    0x4(%eax),%ecx
  1054b3:	8b 55 08             	mov    0x8(%ebp),%edx
  1054b6:	89 0a                	mov    %ecx,(%edx)
  1054b8:	8b 00                	mov    (%eax),%eax
  1054ba:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1054bf:	5d                   	pop    %ebp
  1054c0:	c3                   	ret    

001054c1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1054c1:	55                   	push   %ebp
  1054c2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1054c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1054c8:	7e 14                	jle    1054de <getint+0x1d>
        return va_arg(*ap, long long);
  1054ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1054cd:	8b 00                	mov    (%eax),%eax
  1054cf:	8d 48 08             	lea    0x8(%eax),%ecx
  1054d2:	8b 55 08             	mov    0x8(%ebp),%edx
  1054d5:	89 0a                	mov    %ecx,(%edx)
  1054d7:	8b 50 04             	mov    0x4(%eax),%edx
  1054da:	8b 00                	mov    (%eax),%eax
  1054dc:	eb 28                	jmp    105506 <getint+0x45>
    }
    else if (lflag) {
  1054de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1054e2:	74 12                	je     1054f6 <getint+0x35>
        return va_arg(*ap, long);
  1054e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e7:	8b 00                	mov    (%eax),%eax
  1054e9:	8d 48 04             	lea    0x4(%eax),%ecx
  1054ec:	8b 55 08             	mov    0x8(%ebp),%edx
  1054ef:	89 0a                	mov    %ecx,(%edx)
  1054f1:	8b 00                	mov    (%eax),%eax
  1054f3:	99                   	cltd   
  1054f4:	eb 10                	jmp    105506 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1054f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1054f9:	8b 00                	mov    (%eax),%eax
  1054fb:	8d 48 04             	lea    0x4(%eax),%ecx
  1054fe:	8b 55 08             	mov    0x8(%ebp),%edx
  105501:	89 0a                	mov    %ecx,(%edx)
  105503:	8b 00                	mov    (%eax),%eax
  105505:	99                   	cltd   
    }
}
  105506:	5d                   	pop    %ebp
  105507:	c3                   	ret    

00105508 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105508:	55                   	push   %ebp
  105509:	89 e5                	mov    %esp,%ebp
  10550b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10550e:	8d 45 14             	lea    0x14(%ebp),%eax
  105511:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105517:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10551b:	8b 45 10             	mov    0x10(%ebp),%eax
  10551e:	89 44 24 08          	mov    %eax,0x8(%esp)
  105522:	8b 45 0c             	mov    0xc(%ebp),%eax
  105525:	89 44 24 04          	mov    %eax,0x4(%esp)
  105529:	8b 45 08             	mov    0x8(%ebp),%eax
  10552c:	89 04 24             	mov    %eax,(%esp)
  10552f:	e8 02 00 00 00       	call   105536 <vprintfmt>
    va_end(ap);
}
  105534:	c9                   	leave  
  105535:	c3                   	ret    

00105536 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105536:	55                   	push   %ebp
  105537:	89 e5                	mov    %esp,%ebp
  105539:	56                   	push   %esi
  10553a:	53                   	push   %ebx
  10553b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10553e:	eb 18                	jmp    105558 <vprintfmt+0x22>
            if (ch == '\0') {
  105540:	85 db                	test   %ebx,%ebx
  105542:	75 05                	jne    105549 <vprintfmt+0x13>
                return;
  105544:	e9 d1 03 00 00       	jmp    10591a <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105549:	8b 45 0c             	mov    0xc(%ebp),%eax
  10554c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105550:	89 1c 24             	mov    %ebx,(%esp)
  105553:	8b 45 08             	mov    0x8(%ebp),%eax
  105556:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105558:	8b 45 10             	mov    0x10(%ebp),%eax
  10555b:	8d 50 01             	lea    0x1(%eax),%edx
  10555e:	89 55 10             	mov    %edx,0x10(%ebp)
  105561:	0f b6 00             	movzbl (%eax),%eax
  105564:	0f b6 d8             	movzbl %al,%ebx
  105567:	83 fb 25             	cmp    $0x25,%ebx
  10556a:	75 d4                	jne    105540 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10556c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105570:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10557a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10557d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105584:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105587:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  10558a:	8b 45 10             	mov    0x10(%ebp),%eax
  10558d:	8d 50 01             	lea    0x1(%eax),%edx
  105590:	89 55 10             	mov    %edx,0x10(%ebp)
  105593:	0f b6 00             	movzbl (%eax),%eax
  105596:	0f b6 d8             	movzbl %al,%ebx
  105599:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10559c:	83 f8 55             	cmp    $0x55,%eax
  10559f:	0f 87 44 03 00 00    	ja     1058e9 <vprintfmt+0x3b3>
  1055a5:	8b 04 85 60 70 10 00 	mov    0x107060(,%eax,4),%eax
  1055ac:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1055ae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1055b2:	eb d6                	jmp    10558a <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1055b4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1055b8:	eb d0                	jmp    10558a <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1055ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1055c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1055c4:	89 d0                	mov    %edx,%eax
  1055c6:	c1 e0 02             	shl    $0x2,%eax
  1055c9:	01 d0                	add    %edx,%eax
  1055cb:	01 c0                	add    %eax,%eax
  1055cd:	01 d8                	add    %ebx,%eax
  1055cf:	83 e8 30             	sub    $0x30,%eax
  1055d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1055d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1055d8:	0f b6 00             	movzbl (%eax),%eax
  1055db:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1055de:	83 fb 2f             	cmp    $0x2f,%ebx
  1055e1:	7e 0b                	jle    1055ee <vprintfmt+0xb8>
  1055e3:	83 fb 39             	cmp    $0x39,%ebx
  1055e6:	7f 06                	jg     1055ee <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1055e8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1055ec:	eb d3                	jmp    1055c1 <vprintfmt+0x8b>
            goto process_precision;
  1055ee:	eb 33                	jmp    105623 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1055f0:	8b 45 14             	mov    0x14(%ebp),%eax
  1055f3:	8d 50 04             	lea    0x4(%eax),%edx
  1055f6:	89 55 14             	mov    %edx,0x14(%ebp)
  1055f9:	8b 00                	mov    (%eax),%eax
  1055fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1055fe:	eb 23                	jmp    105623 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105600:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105604:	79 0c                	jns    105612 <vprintfmt+0xdc>
                width = 0;
  105606:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10560d:	e9 78 ff ff ff       	jmp    10558a <vprintfmt+0x54>
  105612:	e9 73 ff ff ff       	jmp    10558a <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105617:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10561e:	e9 67 ff ff ff       	jmp    10558a <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105623:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105627:	79 12                	jns    10563b <vprintfmt+0x105>
                width = precision, precision = -1;
  105629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10562c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10562f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105636:	e9 4f ff ff ff       	jmp    10558a <vprintfmt+0x54>
  10563b:	e9 4a ff ff ff       	jmp    10558a <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105640:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105644:	e9 41 ff ff ff       	jmp    10558a <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105649:	8b 45 14             	mov    0x14(%ebp),%eax
  10564c:	8d 50 04             	lea    0x4(%eax),%edx
  10564f:	89 55 14             	mov    %edx,0x14(%ebp)
  105652:	8b 00                	mov    (%eax),%eax
  105654:	8b 55 0c             	mov    0xc(%ebp),%edx
  105657:	89 54 24 04          	mov    %edx,0x4(%esp)
  10565b:	89 04 24             	mov    %eax,(%esp)
  10565e:	8b 45 08             	mov    0x8(%ebp),%eax
  105661:	ff d0                	call   *%eax
            break;
  105663:	e9 ac 02 00 00       	jmp    105914 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105668:	8b 45 14             	mov    0x14(%ebp),%eax
  10566b:	8d 50 04             	lea    0x4(%eax),%edx
  10566e:	89 55 14             	mov    %edx,0x14(%ebp)
  105671:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105673:	85 db                	test   %ebx,%ebx
  105675:	79 02                	jns    105679 <vprintfmt+0x143>
                err = -err;
  105677:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105679:	83 fb 06             	cmp    $0x6,%ebx
  10567c:	7f 0b                	jg     105689 <vprintfmt+0x153>
  10567e:	8b 34 9d 20 70 10 00 	mov    0x107020(,%ebx,4),%esi
  105685:	85 f6                	test   %esi,%esi
  105687:	75 23                	jne    1056ac <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105689:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10568d:	c7 44 24 08 4d 70 10 	movl   $0x10704d,0x8(%esp)
  105694:	00 
  105695:	8b 45 0c             	mov    0xc(%ebp),%eax
  105698:	89 44 24 04          	mov    %eax,0x4(%esp)
  10569c:	8b 45 08             	mov    0x8(%ebp),%eax
  10569f:	89 04 24             	mov    %eax,(%esp)
  1056a2:	e8 61 fe ff ff       	call   105508 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1056a7:	e9 68 02 00 00       	jmp    105914 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1056ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1056b0:	c7 44 24 08 56 70 10 	movl   $0x107056,0x8(%esp)
  1056b7:	00 
  1056b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c2:	89 04 24             	mov    %eax,(%esp)
  1056c5:	e8 3e fe ff ff       	call   105508 <printfmt>
            }
            break;
  1056ca:	e9 45 02 00 00       	jmp    105914 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1056cf:	8b 45 14             	mov    0x14(%ebp),%eax
  1056d2:	8d 50 04             	lea    0x4(%eax),%edx
  1056d5:	89 55 14             	mov    %edx,0x14(%ebp)
  1056d8:	8b 30                	mov    (%eax),%esi
  1056da:	85 f6                	test   %esi,%esi
  1056dc:	75 05                	jne    1056e3 <vprintfmt+0x1ad>
                p = "(null)";
  1056de:	be 59 70 10 00       	mov    $0x107059,%esi
            }
            if (width > 0 && padc != '-') {
  1056e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056e7:	7e 3e                	jle    105727 <vprintfmt+0x1f1>
  1056e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1056ed:	74 38                	je     105727 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1056ef:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1056f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056f9:	89 34 24             	mov    %esi,(%esp)
  1056fc:	e8 15 03 00 00       	call   105a16 <strnlen>
  105701:	29 c3                	sub    %eax,%ebx
  105703:	89 d8                	mov    %ebx,%eax
  105705:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105708:	eb 17                	jmp    105721 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  10570a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10570e:	8b 55 0c             	mov    0xc(%ebp),%edx
  105711:	89 54 24 04          	mov    %edx,0x4(%esp)
  105715:	89 04 24             	mov    %eax,(%esp)
  105718:	8b 45 08             	mov    0x8(%ebp),%eax
  10571b:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10571d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105721:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105725:	7f e3                	jg     10570a <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105727:	eb 38                	jmp    105761 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105729:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10572d:	74 1f                	je     10574e <vprintfmt+0x218>
  10572f:	83 fb 1f             	cmp    $0x1f,%ebx
  105732:	7e 05                	jle    105739 <vprintfmt+0x203>
  105734:	83 fb 7e             	cmp    $0x7e,%ebx
  105737:	7e 15                	jle    10574e <vprintfmt+0x218>
                    putch('?', putdat);
  105739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10573c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105740:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105747:	8b 45 08             	mov    0x8(%ebp),%eax
  10574a:	ff d0                	call   *%eax
  10574c:	eb 0f                	jmp    10575d <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10574e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105751:	89 44 24 04          	mov    %eax,0x4(%esp)
  105755:	89 1c 24             	mov    %ebx,(%esp)
  105758:	8b 45 08             	mov    0x8(%ebp),%eax
  10575b:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10575d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105761:	89 f0                	mov    %esi,%eax
  105763:	8d 70 01             	lea    0x1(%eax),%esi
  105766:	0f b6 00             	movzbl (%eax),%eax
  105769:	0f be d8             	movsbl %al,%ebx
  10576c:	85 db                	test   %ebx,%ebx
  10576e:	74 10                	je     105780 <vprintfmt+0x24a>
  105770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105774:	78 b3                	js     105729 <vprintfmt+0x1f3>
  105776:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  10577a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10577e:	79 a9                	jns    105729 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105780:	eb 17                	jmp    105799 <vprintfmt+0x263>
                putch(' ', putdat);
  105782:	8b 45 0c             	mov    0xc(%ebp),%eax
  105785:	89 44 24 04          	mov    %eax,0x4(%esp)
  105789:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105795:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105799:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10579d:	7f e3                	jg     105782 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10579f:	e9 70 01 00 00       	jmp    105914 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1057a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ab:	8d 45 14             	lea    0x14(%ebp),%eax
  1057ae:	89 04 24             	mov    %eax,(%esp)
  1057b1:	e8 0b fd ff ff       	call   1054c1 <getint>
  1057b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057c2:	85 d2                	test   %edx,%edx
  1057c4:	79 26                	jns    1057ec <vprintfmt+0x2b6>
                putch('-', putdat);
  1057c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057cd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1057d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d7:	ff d0                	call   *%eax
                num = -(long long)num;
  1057d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057df:	f7 d8                	neg    %eax
  1057e1:	83 d2 00             	adc    $0x0,%edx
  1057e4:	f7 da                	neg    %edx
  1057e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1057ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1057f3:	e9 a8 00 00 00       	jmp    1058a0 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1057f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1057fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ff:	8d 45 14             	lea    0x14(%ebp),%eax
  105802:	89 04 24             	mov    %eax,(%esp)
  105805:	e8 68 fc ff ff       	call   105472 <getuint>
  10580a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10580d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105810:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105817:	e9 84 00 00 00       	jmp    1058a0 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10581c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10581f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105823:	8d 45 14             	lea    0x14(%ebp),%eax
  105826:	89 04 24             	mov    %eax,(%esp)
  105829:	e8 44 fc ff ff       	call   105472 <getuint>
  10582e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105831:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105834:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10583b:	eb 63                	jmp    1058a0 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10583d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105840:	89 44 24 04          	mov    %eax,0x4(%esp)
  105844:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10584b:	8b 45 08             	mov    0x8(%ebp),%eax
  10584e:	ff d0                	call   *%eax
            putch('x', putdat);
  105850:	8b 45 0c             	mov    0xc(%ebp),%eax
  105853:	89 44 24 04          	mov    %eax,0x4(%esp)
  105857:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10585e:	8b 45 08             	mov    0x8(%ebp),%eax
  105861:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105863:	8b 45 14             	mov    0x14(%ebp),%eax
  105866:	8d 50 04             	lea    0x4(%eax),%edx
  105869:	89 55 14             	mov    %edx,0x14(%ebp)
  10586c:	8b 00                	mov    (%eax),%eax
  10586e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105878:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10587f:	eb 1f                	jmp    1058a0 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105881:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105884:	89 44 24 04          	mov    %eax,0x4(%esp)
  105888:	8d 45 14             	lea    0x14(%ebp),%eax
  10588b:	89 04 24             	mov    %eax,(%esp)
  10588e:	e8 df fb ff ff       	call   105472 <getuint>
  105893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105896:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105899:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1058a0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1058a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1058a7:	89 54 24 18          	mov    %edx,0x18(%esp)
  1058ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1058ae:	89 54 24 14          	mov    %edx,0x14(%esp)
  1058b2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1058b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1058c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1058ce:	89 04 24             	mov    %eax,(%esp)
  1058d1:	e8 97 fa ff ff       	call   10536d <printnum>
            break;
  1058d6:	eb 3c                	jmp    105914 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1058d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058df:	89 1c 24             	mov    %ebx,(%esp)
  1058e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e5:	ff d0                	call   *%eax
            break;
  1058e7:	eb 2b                	jmp    105914 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058f0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1058f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058fa:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1058fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105900:	eb 04                	jmp    105906 <vprintfmt+0x3d0>
  105902:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105906:	8b 45 10             	mov    0x10(%ebp),%eax
  105909:	83 e8 01             	sub    $0x1,%eax
  10590c:	0f b6 00             	movzbl (%eax),%eax
  10590f:	3c 25                	cmp    $0x25,%al
  105911:	75 ef                	jne    105902 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105913:	90                   	nop
        }
    }
  105914:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105915:	e9 3e fc ff ff       	jmp    105558 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  10591a:	83 c4 40             	add    $0x40,%esp
  10591d:	5b                   	pop    %ebx
  10591e:	5e                   	pop    %esi
  10591f:	5d                   	pop    %ebp
  105920:	c3                   	ret    

00105921 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105921:	55                   	push   %ebp
  105922:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105924:	8b 45 0c             	mov    0xc(%ebp),%eax
  105927:	8b 40 08             	mov    0x8(%eax),%eax
  10592a:	8d 50 01             	lea    0x1(%eax),%edx
  10592d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105930:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105933:	8b 45 0c             	mov    0xc(%ebp),%eax
  105936:	8b 10                	mov    (%eax),%edx
  105938:	8b 45 0c             	mov    0xc(%ebp),%eax
  10593b:	8b 40 04             	mov    0x4(%eax),%eax
  10593e:	39 c2                	cmp    %eax,%edx
  105940:	73 12                	jae    105954 <sprintputch+0x33>
        *b->buf ++ = ch;
  105942:	8b 45 0c             	mov    0xc(%ebp),%eax
  105945:	8b 00                	mov    (%eax),%eax
  105947:	8d 48 01             	lea    0x1(%eax),%ecx
  10594a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10594d:	89 0a                	mov    %ecx,(%edx)
  10594f:	8b 55 08             	mov    0x8(%ebp),%edx
  105952:	88 10                	mov    %dl,(%eax)
    }
}
  105954:	5d                   	pop    %ebp
  105955:	c3                   	ret    

00105956 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105956:	55                   	push   %ebp
  105957:	89 e5                	mov    %esp,%ebp
  105959:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10595c:	8d 45 14             	lea    0x14(%ebp),%eax
  10595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105965:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105969:	8b 45 10             	mov    0x10(%ebp),%eax
  10596c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105970:	8b 45 0c             	mov    0xc(%ebp),%eax
  105973:	89 44 24 04          	mov    %eax,0x4(%esp)
  105977:	8b 45 08             	mov    0x8(%ebp),%eax
  10597a:	89 04 24             	mov    %eax,(%esp)
  10597d:	e8 08 00 00 00       	call   10598a <vsnprintf>
  105982:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105985:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105988:	c9                   	leave  
  105989:	c3                   	ret    

0010598a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10598a:	55                   	push   %ebp
  10598b:	89 e5                	mov    %esp,%ebp
  10598d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105990:	8b 45 08             	mov    0x8(%ebp),%eax
  105993:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105996:	8b 45 0c             	mov    0xc(%ebp),%eax
  105999:	8d 50 ff             	lea    -0x1(%eax),%edx
  10599c:	8b 45 08             	mov    0x8(%ebp),%eax
  10599f:	01 d0                	add    %edx,%eax
  1059a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1059ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1059af:	74 0a                	je     1059bb <vsnprintf+0x31>
  1059b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1059b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059b7:	39 c2                	cmp    %eax,%edx
  1059b9:	76 07                	jbe    1059c2 <vsnprintf+0x38>
        return -E_INVAL;
  1059bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1059c0:	eb 2a                	jmp    1059ec <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1059c2:	8b 45 14             	mov    0x14(%ebp),%eax
  1059c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1059c9:	8b 45 10             	mov    0x10(%ebp),%eax
  1059cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1059d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059d7:	c7 04 24 21 59 10 00 	movl   $0x105921,(%esp)
  1059de:	e8 53 fb ff ff       	call   105536 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1059e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059e6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1059e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1059ec:	c9                   	leave  
  1059ed:	c3                   	ret    

001059ee <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1059ee:	55                   	push   %ebp
  1059ef:	89 e5                	mov    %esp,%ebp
  1059f1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1059f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1059fb:	eb 04                	jmp    105a01 <strlen+0x13>
        cnt ++;
  1059fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105a01:	8b 45 08             	mov    0x8(%ebp),%eax
  105a04:	8d 50 01             	lea    0x1(%eax),%edx
  105a07:	89 55 08             	mov    %edx,0x8(%ebp)
  105a0a:	0f b6 00             	movzbl (%eax),%eax
  105a0d:	84 c0                	test   %al,%al
  105a0f:	75 ec                	jne    1059fd <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a14:	c9                   	leave  
  105a15:	c3                   	ret    

00105a16 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105a16:	55                   	push   %ebp
  105a17:	89 e5                	mov    %esp,%ebp
  105a19:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105a1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105a23:	eb 04                	jmp    105a29 <strnlen+0x13>
        cnt ++;
  105a25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105a2f:	73 10                	jae    105a41 <strnlen+0x2b>
  105a31:	8b 45 08             	mov    0x8(%ebp),%eax
  105a34:	8d 50 01             	lea    0x1(%eax),%edx
  105a37:	89 55 08             	mov    %edx,0x8(%ebp)
  105a3a:	0f b6 00             	movzbl (%eax),%eax
  105a3d:	84 c0                	test   %al,%al
  105a3f:	75 e4                	jne    105a25 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105a44:	c9                   	leave  
  105a45:	c3                   	ret    

00105a46 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105a46:	55                   	push   %ebp
  105a47:	89 e5                	mov    %esp,%ebp
  105a49:	57                   	push   %edi
  105a4a:	56                   	push   %esi
  105a4b:	83 ec 20             	sub    $0x20,%esp
  105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  105a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a54:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a60:	89 d1                	mov    %edx,%ecx
  105a62:	89 c2                	mov    %eax,%edx
  105a64:	89 ce                	mov    %ecx,%esi
  105a66:	89 d7                	mov    %edx,%edi
  105a68:	ac                   	lods   %ds:(%esi),%al
  105a69:	aa                   	stos   %al,%es:(%edi)
  105a6a:	84 c0                	test   %al,%al
  105a6c:	75 fa                	jne    105a68 <strcpy+0x22>
  105a6e:	89 fa                	mov    %edi,%edx
  105a70:	89 f1                	mov    %esi,%ecx
  105a72:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a75:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105a7e:	83 c4 20             	add    $0x20,%esp
  105a81:	5e                   	pop    %esi
  105a82:	5f                   	pop    %edi
  105a83:	5d                   	pop    %ebp
  105a84:	c3                   	ret    

00105a85 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105a85:	55                   	push   %ebp
  105a86:	89 e5                	mov    %esp,%ebp
  105a88:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105a91:	eb 21                	jmp    105ab4 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105a93:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a96:	0f b6 10             	movzbl (%eax),%edx
  105a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a9c:	88 10                	mov    %dl,(%eax)
  105a9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105aa1:	0f b6 00             	movzbl (%eax),%eax
  105aa4:	84 c0                	test   %al,%al
  105aa6:	74 04                	je     105aac <strncpy+0x27>
            src ++;
  105aa8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105aac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105ab0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105ab4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ab8:	75 d9                	jne    105a93 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105aba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105abd:	c9                   	leave  
  105abe:	c3                   	ret    

00105abf <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105abf:	55                   	push   %ebp
  105ac0:	89 e5                	mov    %esp,%ebp
  105ac2:	57                   	push   %edi
  105ac3:	56                   	push   %esi
  105ac4:	83 ec 20             	sub    $0x20,%esp
  105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  105aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ad9:	89 d1                	mov    %edx,%ecx
  105adb:	89 c2                	mov    %eax,%edx
  105add:	89 ce                	mov    %ecx,%esi
  105adf:	89 d7                	mov    %edx,%edi
  105ae1:	ac                   	lods   %ds:(%esi),%al
  105ae2:	ae                   	scas   %es:(%edi),%al
  105ae3:	75 08                	jne    105aed <strcmp+0x2e>
  105ae5:	84 c0                	test   %al,%al
  105ae7:	75 f8                	jne    105ae1 <strcmp+0x22>
  105ae9:	31 c0                	xor    %eax,%eax
  105aeb:	eb 04                	jmp    105af1 <strcmp+0x32>
  105aed:	19 c0                	sbb    %eax,%eax
  105aef:	0c 01                	or     $0x1,%al
  105af1:	89 fa                	mov    %edi,%edx
  105af3:	89 f1                	mov    %esi,%ecx
  105af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105af8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105afb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105b01:	83 c4 20             	add    $0x20,%esp
  105b04:	5e                   	pop    %esi
  105b05:	5f                   	pop    %edi
  105b06:	5d                   	pop    %ebp
  105b07:	c3                   	ret    

00105b08 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105b08:	55                   	push   %ebp
  105b09:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b0b:	eb 0c                	jmp    105b19 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105b0d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105b11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105b15:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105b19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b1d:	74 1a                	je     105b39 <strncmp+0x31>
  105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b22:	0f b6 00             	movzbl (%eax),%eax
  105b25:	84 c0                	test   %al,%al
  105b27:	74 10                	je     105b39 <strncmp+0x31>
  105b29:	8b 45 08             	mov    0x8(%ebp),%eax
  105b2c:	0f b6 10             	movzbl (%eax),%edx
  105b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b32:	0f b6 00             	movzbl (%eax),%eax
  105b35:	38 c2                	cmp    %al,%dl
  105b37:	74 d4                	je     105b0d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b3d:	74 18                	je     105b57 <strncmp+0x4f>
  105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  105b42:	0f b6 00             	movzbl (%eax),%eax
  105b45:	0f b6 d0             	movzbl %al,%edx
  105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b4b:	0f b6 00             	movzbl (%eax),%eax
  105b4e:	0f b6 c0             	movzbl %al,%eax
  105b51:	29 c2                	sub    %eax,%edx
  105b53:	89 d0                	mov    %edx,%eax
  105b55:	eb 05                	jmp    105b5c <strncmp+0x54>
  105b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b5c:	5d                   	pop    %ebp
  105b5d:	c3                   	ret    

00105b5e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105b5e:	55                   	push   %ebp
  105b5f:	89 e5                	mov    %esp,%ebp
  105b61:	83 ec 04             	sub    $0x4,%esp
  105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b67:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b6a:	eb 14                	jmp    105b80 <strchr+0x22>
        if (*s == c) {
  105b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105b6f:	0f b6 00             	movzbl (%eax),%eax
  105b72:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105b75:	75 05                	jne    105b7c <strchr+0x1e>
            return (char *)s;
  105b77:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7a:	eb 13                	jmp    105b8f <strchr+0x31>
        }
        s ++;
  105b7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105b80:	8b 45 08             	mov    0x8(%ebp),%eax
  105b83:	0f b6 00             	movzbl (%eax),%eax
  105b86:	84 c0                	test   %al,%al
  105b88:	75 e2                	jne    105b6c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b8f:	c9                   	leave  
  105b90:	c3                   	ret    

00105b91 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105b91:	55                   	push   %ebp
  105b92:	89 e5                	mov    %esp,%ebp
  105b94:	83 ec 04             	sub    $0x4,%esp
  105b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105b9d:	eb 11                	jmp    105bb0 <strfind+0x1f>
        if (*s == c) {
  105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba2:	0f b6 00             	movzbl (%eax),%eax
  105ba5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105ba8:	75 02                	jne    105bac <strfind+0x1b>
            break;
  105baa:	eb 0e                	jmp    105bba <strfind+0x29>
        }
        s ++;
  105bac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb3:	0f b6 00             	movzbl (%eax),%eax
  105bb6:	84 c0                	test   %al,%al
  105bb8:	75 e5                	jne    105b9f <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105bba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bbd:	c9                   	leave  
  105bbe:	c3                   	ret    

00105bbf <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105bbf:	55                   	push   %ebp
  105bc0:	89 e5                	mov    %esp,%ebp
  105bc2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105bcc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105bd3:	eb 04                	jmp    105bd9 <strtol+0x1a>
        s ++;
  105bd5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  105bdc:	0f b6 00             	movzbl (%eax),%eax
  105bdf:	3c 20                	cmp    $0x20,%al
  105be1:	74 f2                	je     105bd5 <strtol+0x16>
  105be3:	8b 45 08             	mov    0x8(%ebp),%eax
  105be6:	0f b6 00             	movzbl (%eax),%eax
  105be9:	3c 09                	cmp    $0x9,%al
  105beb:	74 e8                	je     105bd5 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105bed:	8b 45 08             	mov    0x8(%ebp),%eax
  105bf0:	0f b6 00             	movzbl (%eax),%eax
  105bf3:	3c 2b                	cmp    $0x2b,%al
  105bf5:	75 06                	jne    105bfd <strtol+0x3e>
        s ++;
  105bf7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bfb:	eb 15                	jmp    105c12 <strtol+0x53>
    }
    else if (*s == '-') {
  105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  105c00:	0f b6 00             	movzbl (%eax),%eax
  105c03:	3c 2d                	cmp    $0x2d,%al
  105c05:	75 0b                	jne    105c12 <strtol+0x53>
        s ++, neg = 1;
  105c07:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c0b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105c12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c16:	74 06                	je     105c1e <strtol+0x5f>
  105c18:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105c1c:	75 24                	jne    105c42 <strtol+0x83>
  105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c21:	0f b6 00             	movzbl (%eax),%eax
  105c24:	3c 30                	cmp    $0x30,%al
  105c26:	75 1a                	jne    105c42 <strtol+0x83>
  105c28:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2b:	83 c0 01             	add    $0x1,%eax
  105c2e:	0f b6 00             	movzbl (%eax),%eax
  105c31:	3c 78                	cmp    $0x78,%al
  105c33:	75 0d                	jne    105c42 <strtol+0x83>
        s += 2, base = 16;
  105c35:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105c39:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105c40:	eb 2a                	jmp    105c6c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c46:	75 17                	jne    105c5f <strtol+0xa0>
  105c48:	8b 45 08             	mov    0x8(%ebp),%eax
  105c4b:	0f b6 00             	movzbl (%eax),%eax
  105c4e:	3c 30                	cmp    $0x30,%al
  105c50:	75 0d                	jne    105c5f <strtol+0xa0>
        s ++, base = 8;
  105c52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c56:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105c5d:	eb 0d                	jmp    105c6c <strtol+0xad>
    }
    else if (base == 0) {
  105c5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c63:	75 07                	jne    105c6c <strtol+0xad>
        base = 10;
  105c65:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6f:	0f b6 00             	movzbl (%eax),%eax
  105c72:	3c 2f                	cmp    $0x2f,%al
  105c74:	7e 1b                	jle    105c91 <strtol+0xd2>
  105c76:	8b 45 08             	mov    0x8(%ebp),%eax
  105c79:	0f b6 00             	movzbl (%eax),%eax
  105c7c:	3c 39                	cmp    $0x39,%al
  105c7e:	7f 11                	jg     105c91 <strtol+0xd2>
            dig = *s - '0';
  105c80:	8b 45 08             	mov    0x8(%ebp),%eax
  105c83:	0f b6 00             	movzbl (%eax),%eax
  105c86:	0f be c0             	movsbl %al,%eax
  105c89:	83 e8 30             	sub    $0x30,%eax
  105c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105c8f:	eb 48                	jmp    105cd9 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105c91:	8b 45 08             	mov    0x8(%ebp),%eax
  105c94:	0f b6 00             	movzbl (%eax),%eax
  105c97:	3c 60                	cmp    $0x60,%al
  105c99:	7e 1b                	jle    105cb6 <strtol+0xf7>
  105c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c9e:	0f b6 00             	movzbl (%eax),%eax
  105ca1:	3c 7a                	cmp    $0x7a,%al
  105ca3:	7f 11                	jg     105cb6 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca8:	0f b6 00             	movzbl (%eax),%eax
  105cab:	0f be c0             	movsbl %al,%eax
  105cae:	83 e8 57             	sub    $0x57,%eax
  105cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105cb4:	eb 23                	jmp    105cd9 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105cb9:	0f b6 00             	movzbl (%eax),%eax
  105cbc:	3c 40                	cmp    $0x40,%al
  105cbe:	7e 3d                	jle    105cfd <strtol+0x13e>
  105cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105cc3:	0f b6 00             	movzbl (%eax),%eax
  105cc6:	3c 5a                	cmp    $0x5a,%al
  105cc8:	7f 33                	jg     105cfd <strtol+0x13e>
            dig = *s - 'A' + 10;
  105cca:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccd:	0f b6 00             	movzbl (%eax),%eax
  105cd0:	0f be c0             	movsbl %al,%eax
  105cd3:	83 e8 37             	sub    $0x37,%eax
  105cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cdc:	3b 45 10             	cmp    0x10(%ebp),%eax
  105cdf:	7c 02                	jl     105ce3 <strtol+0x124>
            break;
  105ce1:	eb 1a                	jmp    105cfd <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105ce3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105cea:	0f af 45 10          	imul   0x10(%ebp),%eax
  105cee:	89 c2                	mov    %eax,%edx
  105cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105cf3:	01 d0                	add    %edx,%eax
  105cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105cf8:	e9 6f ff ff ff       	jmp    105c6c <strtol+0xad>

    if (endptr) {
  105cfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105d01:	74 08                	je     105d0b <strtol+0x14c>
        *endptr = (char *) s;
  105d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d06:	8b 55 08             	mov    0x8(%ebp),%edx
  105d09:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105d0f:	74 07                	je     105d18 <strtol+0x159>
  105d11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105d14:	f7 d8                	neg    %eax
  105d16:	eb 03                	jmp    105d1b <strtol+0x15c>
  105d18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105d1b:	c9                   	leave  
  105d1c:	c3                   	ret    

00105d1d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105d1d:	55                   	push   %ebp
  105d1e:	89 e5                	mov    %esp,%ebp
  105d20:	57                   	push   %edi
  105d21:	83 ec 24             	sub    $0x24,%esp
  105d24:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d27:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105d2a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105d2e:	8b 55 08             	mov    0x8(%ebp),%edx
  105d31:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105d34:	88 45 f7             	mov    %al,-0x9(%ebp)
  105d37:	8b 45 10             	mov    0x10(%ebp),%eax
  105d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105d3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105d40:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105d44:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105d47:	89 d7                	mov    %edx,%edi
  105d49:	f3 aa                	rep stos %al,%es:(%edi)
  105d4b:	89 fa                	mov    %edi,%edx
  105d4d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105d50:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105d56:	83 c4 24             	add    $0x24,%esp
  105d59:	5f                   	pop    %edi
  105d5a:	5d                   	pop    %ebp
  105d5b:	c3                   	ret    

00105d5c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105d5c:	55                   	push   %ebp
  105d5d:	89 e5                	mov    %esp,%ebp
  105d5f:	57                   	push   %edi
  105d60:	56                   	push   %esi
  105d61:	53                   	push   %ebx
  105d62:	83 ec 30             	sub    $0x30,%esp
  105d65:	8b 45 08             	mov    0x8(%ebp),%eax
  105d68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d71:	8b 45 10             	mov    0x10(%ebp),%eax
  105d74:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105d7d:	73 42                	jae    105dc1 <memmove+0x65>
  105d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d88:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105d8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105d91:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105d94:	c1 e8 02             	shr    $0x2,%eax
  105d97:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d9f:	89 d7                	mov    %edx,%edi
  105da1:	89 c6                	mov    %eax,%esi
  105da3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105da5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105da8:	83 e1 03             	and    $0x3,%ecx
  105dab:	74 02                	je     105daf <memmove+0x53>
  105dad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105daf:	89 f0                	mov    %esi,%eax
  105db1:	89 fa                	mov    %edi,%edx
  105db3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105db6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105db9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105dbf:	eb 36                	jmp    105df7 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  105dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105dca:	01 c2                	add    %eax,%edx
  105dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105dcf:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dd5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ddb:	89 c1                	mov    %eax,%ecx
  105ddd:	89 d8                	mov    %ebx,%eax
  105ddf:	89 d6                	mov    %edx,%esi
  105de1:	89 c7                	mov    %eax,%edi
  105de3:	fd                   	std    
  105de4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105de6:	fc                   	cld    
  105de7:	89 f8                	mov    %edi,%eax
  105de9:	89 f2                	mov    %esi,%edx
  105deb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105dee:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105df1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105df7:	83 c4 30             	add    $0x30,%esp
  105dfa:	5b                   	pop    %ebx
  105dfb:	5e                   	pop    %esi
  105dfc:	5f                   	pop    %edi
  105dfd:	5d                   	pop    %ebp
  105dfe:	c3                   	ret    

00105dff <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105dff:	55                   	push   %ebp
  105e00:	89 e5                	mov    %esp,%ebp
  105e02:	57                   	push   %edi
  105e03:	56                   	push   %esi
  105e04:	83 ec 20             	sub    $0x20,%esp
  105e07:	8b 45 08             	mov    0x8(%ebp),%eax
  105e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e13:	8b 45 10             	mov    0x10(%ebp),%eax
  105e16:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e1c:	c1 e8 02             	shr    $0x2,%eax
  105e1f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e27:	89 d7                	mov    %edx,%edi
  105e29:	89 c6                	mov    %eax,%esi
  105e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e2d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105e30:	83 e1 03             	and    $0x3,%ecx
  105e33:	74 02                	je     105e37 <memcpy+0x38>
  105e35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e37:	89 f0                	mov    %esi,%eax
  105e39:	89 fa                	mov    %edi,%edx
  105e3b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105e41:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105e47:	83 c4 20             	add    $0x20,%esp
  105e4a:	5e                   	pop    %esi
  105e4b:	5f                   	pop    %edi
  105e4c:	5d                   	pop    %ebp
  105e4d:	c3                   	ret    

00105e4e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105e4e:	55                   	push   %ebp
  105e4f:	89 e5                	mov    %esp,%ebp
  105e51:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105e54:	8b 45 08             	mov    0x8(%ebp),%eax
  105e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105e60:	eb 30                	jmp    105e92 <memcmp+0x44>
        if (*s1 != *s2) {
  105e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e65:	0f b6 10             	movzbl (%eax),%edx
  105e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e6b:	0f b6 00             	movzbl (%eax),%eax
  105e6e:	38 c2                	cmp    %al,%dl
  105e70:	74 18                	je     105e8a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e75:	0f b6 00             	movzbl (%eax),%eax
  105e78:	0f b6 d0             	movzbl %al,%edx
  105e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e7e:	0f b6 00             	movzbl (%eax),%eax
  105e81:	0f b6 c0             	movzbl %al,%eax
  105e84:	29 c2                	sub    %eax,%edx
  105e86:	89 d0                	mov    %edx,%eax
  105e88:	eb 1a                	jmp    105ea4 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105e8a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e8e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105e92:	8b 45 10             	mov    0x10(%ebp),%eax
  105e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e98:	89 55 10             	mov    %edx,0x10(%ebp)
  105e9b:	85 c0                	test   %eax,%eax
  105e9d:	75 c3                	jne    105e62 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105ea4:	c9                   	leave  
  105ea5:	c3                   	ret    
