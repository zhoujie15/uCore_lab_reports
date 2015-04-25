
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
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
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
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
//void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 c7 5c 00 00       	call   c0105d1d <memset>

    cons_init();                // init the console
c0100056:	e8 71 15 00 00       	call   c01015cc <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 c0 5e 10 c0 	movl   $0xc0105ec0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 dc 5e 10 c0 	movl   $0xc0105edc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 ab 41 00 00       	call   c010422f <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 ac 16 00 00       	call   c0101735 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 24 18 00 00       	call   c01018b2 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 ef 0c 00 00       	call   c0100d82 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 0b 16 00 00       	call   c01016a3 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 f8 0b 00 00       	call   c0100cb4 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 e1 5e 10 c0 	movl   $0xc0105ee1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 ef 5e 10 c0 	movl   $0xc0105eef,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 fd 5e 10 c0 	movl   $0xc0105efd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 0b 5f 10 c0 	movl   $0xc0105f0b,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 19 5f 10 c0 	movl   $0xc0105f19,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 28 5f 10 c0 	movl   $0xc0105f28,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 48 5f 10 c0 	movl   $0xc0105f48,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 67 5f 10 c0 	movl   $0xc0105f67,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 fe 12 00 00       	call   c01015f8 <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ff 51 00 00       	call   c0105536 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 85 12 00 00       	call   c01015f8 <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 65 12 00 00       	call   c0101634 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 6c 5f 10 c0    	movl   $0xc0105f6c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 6c 5f 10 c0 	movl   $0xc0105f6c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 b8 71 10 c0 	movl   $0xc01071b8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 3c 1d 11 c0 	movl   $0xc0111d3c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 3d 1d 11 c0 	movl   $0xc0111d3d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 81 47 11 c0 	movl   $0xc0114781,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 a5 54 00 00       	call   c0105b91 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 76 5f 10 c0 	movl   $0xc0105f76,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 8f 5f 10 c0 	movl   $0xc0105f8f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 a6 5e 10 	movl   $0xc0105ea6,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 a7 5f 10 c0 	movl   $0xc0105fa7,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 bf 5f 10 c0 	movl   $0xc0105fbf,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 d7 5f 10 c0 	movl   $0xc0105fd7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 f0 5f 10 c0 	movl   $0xc0105ff0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 1a 60 10 c0 	movl   $0xc010601a,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009da:	e9 88 00 00 00       	jmp    c0100a67 <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ed:	c7 04 24 48 60 10 c0 	movl   $0xc0106048,(%esp)
c01009f4:	e8 43 f9 ff ff       	call   c010033c <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fc:	83 c0 08             	add    $0x8,%eax
c01009ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a02:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a09:	eb 25                	jmp    c0100a30 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a0e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a18:	01 d0                	add    %edx,%eax
c0100a1a:	8b 00                	mov    (%eax),%eax
c0100a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a20:	c7 04 24 64 60 10 c0 	movl   $0xc0106064,(%esp)
c0100a27:	e8 10 f9 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a2c:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a30:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a34:	7e d5                	jle    c0100a0b <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a36:	c7 04 24 6c 60 10 c0 	movl   $0xc010606c,(%esp)
c0100a3d:	e8 fa f8 ff ff       	call   c010033c <cprintf>
        print_debuginfo(eip - 1);
c0100a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a45:	83 e8 01             	sub    $0x1,%eax
c0100a48:	89 04 24             	mov    %eax,(%esp)
c0100a4b:	e8 b6 fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a53:	83 c0 04             	add    $0x4,%eax
c0100a56:	8b 00                	mov    (%eax),%eax
c0100a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5e:	8b 00                	mov    (%eax),%eax
c0100a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a63:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a6b:	74 0a                	je     c0100a77 <print_stackframe+0xbd>
c0100a6d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a71:	0f 8e 68 ff ff ff    	jle    c01009df <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a86:	eb 0c                	jmp    c0100a94 <parse+0x1b>
            *buf ++ = '\0';
c0100a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8b:	8d 50 01             	lea    0x1(%eax),%edx
c0100a8e:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a94:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a97:	0f b6 00             	movzbl (%eax),%eax
c0100a9a:	84 c0                	test   %al,%al
c0100a9c:	74 1d                	je     c0100abb <parse+0x42>
c0100a9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa1:	0f b6 00             	movzbl (%eax),%eax
c0100aa4:	0f be c0             	movsbl %al,%eax
c0100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aab:	c7 04 24 f0 60 10 c0 	movl   $0xc01060f0,(%esp)
c0100ab2:	e8 a7 50 00 00       	call   c0105b5e <strchr>
c0100ab7:	85 c0                	test   %eax,%eax
c0100ab9:	75 cd                	jne    c0100a88 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100abe:	0f b6 00             	movzbl (%eax),%eax
c0100ac1:	84 c0                	test   %al,%al
c0100ac3:	75 02                	jne    c0100ac7 <parse+0x4e>
            break;
c0100ac5:	eb 67                	jmp    c0100b2e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acb:	75 14                	jne    c0100ae1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acd:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad4:	00 
c0100ad5:	c7 04 24 f5 60 10 c0 	movl   $0xc01060f5,(%esp)
c0100adc:	e8 5b f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae4:	8d 50 01             	lea    0x1(%eax),%edx
c0100ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100aea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100af4:	01 c2                	add    %eax,%edx
c0100af6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	eb 04                	jmp    c0100b01 <parse+0x88>
            buf ++;
c0100afd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b04:	0f b6 00             	movzbl (%eax),%eax
c0100b07:	84 c0                	test   %al,%al
c0100b09:	74 1d                	je     c0100b28 <parse+0xaf>
c0100b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0e:	0f b6 00             	movzbl (%eax),%eax
c0100b11:	0f be c0             	movsbl %al,%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 f0 60 10 c0 	movl   $0xc01060f0,(%esp)
c0100b1f:	e8 3a 50 00 00       	call   c0105b5e <strchr>
c0100b24:	85 c0                	test   %eax,%eax
c0100b26:	74 d5                	je     c0100afd <parse+0x84>
            buf ++;
        }
    }
c0100b28:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b29:	e9 66 ff ff ff       	jmp    c0100a94 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b31:	c9                   	leave  
c0100b32:	c3                   	ret    

c0100b33 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b33:	55                   	push   %ebp
c0100b34:	89 e5                	mov    %esp,%ebp
c0100b36:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b39:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	89 04 24             	mov    %eax,(%esp)
c0100b46:	e8 2e ff ff ff       	call   c0100a79 <parse>
c0100b4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b4e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b52:	75 0a                	jne    c0100b5e <runcmd+0x2b>
        return 0;
c0100b54:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b59:	e9 85 00 00 00       	jmp    c0100be3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b65:	eb 5c                	jmp    c0100bc3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b67:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b6d:	89 d0                	mov    %edx,%eax
c0100b6f:	01 c0                	add    %eax,%eax
c0100b71:	01 d0                	add    %edx,%eax
c0100b73:	c1 e0 02             	shl    $0x2,%eax
c0100b76:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b7b:	8b 00                	mov    (%eax),%eax
c0100b7d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b81:	89 04 24             	mov    %eax,(%esp)
c0100b84:	e8 36 4f 00 00       	call   c0105abf <strcmp>
c0100b89:	85 c0                	test   %eax,%eax
c0100b8b:	75 32                	jne    c0100bbf <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b90:	89 d0                	mov    %edx,%eax
c0100b92:	01 c0                	add    %eax,%eax
c0100b94:	01 d0                	add    %edx,%eax
c0100b96:	c1 e0 02             	shl    $0x2,%eax
c0100b99:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b9e:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100ba4:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100baa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bae:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb1:	83 c2 04             	add    $0x4,%edx
c0100bb4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bb8:	89 0c 24             	mov    %ecx,(%esp)
c0100bbb:	ff d0                	call   *%eax
c0100bbd:	eb 24                	jmp    c0100be3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bbf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc6:	83 f8 02             	cmp    $0x2,%eax
c0100bc9:	76 9c                	jbe    c0100b67 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bcb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bce:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd2:	c7 04 24 13 61 10 c0 	movl   $0xc0106113,(%esp)
c0100bd9:	e8 5e f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bde:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be3:	c9                   	leave  
c0100be4:	c3                   	ret    

c0100be5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100be5:	55                   	push   %ebp
c0100be6:	89 e5                	mov    %esp,%ebp
c0100be8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100beb:	c7 04 24 2c 61 10 c0 	movl   $0xc010612c,(%esp)
c0100bf2:	e8 45 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf7:	c7 04 24 54 61 10 c0 	movl   $0xc0106154,(%esp)
c0100bfe:	e8 39 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c07:	74 0b                	je     c0100c14 <kmonitor+0x2f>
        print_trapframe(tf);
c0100c09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c0c:	89 04 24             	mov    %eax,(%esp)
c0100c0f:	e8 d7 0d 00 00       	call   c01019eb <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c14:	c7 04 24 79 61 10 c0 	movl   $0xc0106179,(%esp)
c0100c1b:	e8 13 f6 ff ff       	call   c0100233 <readline>
c0100c20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c23:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c27:	74 18                	je     c0100c41 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c29:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c33:	89 04 24             	mov    %eax,(%esp)
c0100c36:	e8 f8 fe ff ff       	call   c0100b33 <runcmd>
c0100c3b:	85 c0                	test   %eax,%eax
c0100c3d:	79 02                	jns    c0100c41 <kmonitor+0x5c>
                break;
c0100c3f:	eb 02                	jmp    c0100c43 <kmonitor+0x5e>
            }
        }
    }
c0100c41:	eb d1                	jmp    c0100c14 <kmonitor+0x2f>
}
c0100c43:	c9                   	leave  
c0100c44:	c3                   	ret    

c0100c45 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c45:	55                   	push   %ebp
c0100c46:	89 e5                	mov    %esp,%ebp
c0100c48:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c52:	eb 3f                	jmp    c0100c93 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c54:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c57:	89 d0                	mov    %edx,%eax
c0100c59:	01 c0                	add    %eax,%eax
c0100c5b:	01 d0                	add    %edx,%eax
c0100c5d:	c1 e0 02             	shl    $0x2,%eax
c0100c60:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c65:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6b:	89 d0                	mov    %edx,%eax
c0100c6d:	01 c0                	add    %eax,%eax
c0100c6f:	01 d0                	add    %edx,%eax
c0100c71:	c1 e0 02             	shl    $0x2,%eax
c0100c74:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c79:	8b 00                	mov    (%eax),%eax
c0100c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c83:	c7 04 24 7d 61 10 c0 	movl   $0xc010617d,(%esp)
c0100c8a:	e8 ad f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c8f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c96:	83 f8 02             	cmp    $0x2,%eax
c0100c99:	76 b9                	jbe    c0100c54 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c9b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca0:	c9                   	leave  
c0100ca1:	c3                   	ret    

c0100ca2 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca2:	55                   	push   %ebp
c0100ca3:	89 e5                	mov    %esp,%ebp
c0100ca5:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca8:	e8 c3 fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb2:	c9                   	leave  
c0100cb3:	c3                   	ret    

c0100cb4 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cb4:	55                   	push   %ebp
c0100cb5:	89 e5                	mov    %esp,%ebp
c0100cb7:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cba:	e8 fb fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc4:	c9                   	leave  
c0100cc5:	c3                   	ret    

c0100cc6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc6:	55                   	push   %ebp
c0100cc7:	89 e5                	mov    %esp,%ebp
c0100cc9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ccc:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd1:	85 c0                	test   %eax,%eax
c0100cd3:	74 02                	je     c0100cd7 <__panic+0x11>
        goto panic_dead;
c0100cd5:	eb 48                	jmp    c0100d1f <__panic+0x59>
    }
    is_panic = 1;
c0100cd7:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cde:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce1:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cea:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cf5:	c7 04 24 86 61 10 c0 	movl   $0xc0106186,(%esp)
c0100cfc:	e8 3b f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d08:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d0b:	89 04 24             	mov    %eax,(%esp)
c0100d0e:	e8 f6 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d13:	c7 04 24 a2 61 10 c0 	movl   $0xc01061a2,(%esp)
c0100d1a:	e8 1d f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1f:	e8 85 09 00 00       	call   c01016a9 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d24:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d2b:	e8 b5 fe ff ff       	call   c0100be5 <kmonitor>
    }
c0100d30:	eb f2                	jmp    c0100d24 <__panic+0x5e>

c0100d32 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d32:	55                   	push   %ebp
c0100d33:	89 e5                	mov    %esp,%ebp
c0100d35:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d38:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d41:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d45:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4c:	c7 04 24 a4 61 10 c0 	movl   $0xc01061a4,(%esp)
c0100d53:	e8 e4 f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d62:	89 04 24             	mov    %eax,(%esp)
c0100d65:	e8 9f f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d6a:	c7 04 24 a2 61 10 c0 	movl   $0xc01061a2,(%esp)
c0100d71:	e8 c6 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d76:	c9                   	leave  
c0100d77:	c3                   	ret    

c0100d78 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d78:	55                   	push   %ebp
c0100d79:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7b:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d80:	5d                   	pop    %ebp
c0100d81:	c3                   	ret    

c0100d82 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d82:	55                   	push   %ebp
c0100d83:	89 e5                	mov    %esp,%ebp
c0100d85:	83 ec 28             	sub    $0x28,%esp
c0100d88:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d8e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d92:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d96:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9a:	ee                   	out    %al,(%dx)
c0100d9b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da1:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dad:	ee                   	out    %al,(%dx)
c0100dae:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db4:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc1:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dc8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcb:	c7 04 24 c2 61 10 c0 	movl   $0xc01061c2,(%esp)
c0100dd2:	e8 65 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dde:	e8 24 09 00 00       	call   c0101707 <pic_enable>
}
c0100de3:	c9                   	leave  
c0100de4:	c3                   	ret    

c0100de5 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de5:	55                   	push   %ebp
c0100de6:	89 e5                	mov    %esp,%ebp
c0100de8:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100deb:	9c                   	pushf  
c0100dec:	58                   	pop    %eax
c0100ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df3:	25 00 02 00 00       	and    $0x200,%eax
c0100df8:	85 c0                	test   %eax,%eax
c0100dfa:	74 0c                	je     c0100e08 <__intr_save+0x23>
        intr_disable();
c0100dfc:	e8 a8 08 00 00       	call   c01016a9 <intr_disable>
        return 1;
c0100e01:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e06:	eb 05                	jmp    c0100e0d <__intr_save+0x28>
    }
    return 0;
c0100e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e0d:	c9                   	leave  
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 83 08 00 00       	call   c01016a3 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	83 ec 10             	sub    $0x10,%esp
c0100e28:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e4e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e58:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e5e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e62:	89 c2                	mov    %eax,%edx
c0100e64:	ec                   	in     (%dx),%al
c0100e65:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e68:	c9                   	leave  
c0100e69:	c3                   	ret    

c0100e6a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e6a:	55                   	push   %ebp
c0100e6b:	89 e5                	mov    %esp,%ebp
c0100e6d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e70:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e77:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7a:	0f b7 00             	movzwl (%eax),%eax
c0100e7d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e84:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8c:	0f b7 00             	movzwl (%eax),%eax
c0100e8f:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e93:	74 12                	je     c0100ea7 <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e95:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e9c:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100ea3:	b4 03 
c0100ea5:	eb 13                	jmp    c0100eba <cga_init+0x50>
    } else {
        *cp = was;
c0100ea7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eaa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eae:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb1:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100eb8:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	0f b7 c0             	movzwl %ax,%eax
c0100ec4:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ec8:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ecc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ed5:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100edc:	83 c0 01             	add    $0x1,%eax
c0100edf:	0f b7 c0             	movzwl %ax,%eax
c0100ee2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ee6:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100eea:	89 c2                	mov    %eax,%edx
c0100eec:	ec                   	in     (%dx),%al
c0100eed:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef4:	0f b6 c0             	movzbl %al,%eax
c0100ef7:	c1 e0 08             	shl    $0x8,%eax
c0100efa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	0f b7 c0             	movzwl %ax,%eax
c0100f07:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f0b:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f0f:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f13:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f17:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f18:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f1f:	83 c0 01             	add    $0x1,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f29:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f2d:	89 c2                	mov    %eax,%edx
c0100f2f:	ec                   	in     (%dx),%al
c0100f30:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f33:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f37:	0f b6 c0             	movzbl %al,%eax
c0100f3a:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f40:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f48:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f4e:	c9                   	leave  
c0100f4f:	c3                   	ret    

c0100f50 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f50:	55                   	push   %ebp
c0100f51:	89 e5                	mov    %esp,%ebp
c0100f53:	83 ec 48             	sub    $0x48,%esp
c0100f56:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f5c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f60:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f64:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f68:	ee                   	out    %al,(%dx)
c0100f69:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f6f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f73:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f77:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f7b:	ee                   	out    %al,(%dx)
c0100f7c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f82:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f86:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f8a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f8e:	ee                   	out    %al,(%dx)
c0100f8f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f95:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f99:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f9d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa1:	ee                   	out    %al,(%dx)
c0100fa2:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fa8:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fac:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb0:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb4:	ee                   	out    %al,(%dx)
c0100fb5:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fbb:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fbf:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fc3:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fc7:	ee                   	out    %al,(%dx)
c0100fc8:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fce:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd2:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fd6:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fda:	ee                   	out    %al,(%dx)
c0100fdb:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fe5:	89 c2                	mov    %eax,%edx
c0100fe7:	ec                   	in     (%dx),%al
c0100fe8:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100feb:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fef:	3c ff                	cmp    $0xff,%al
c0100ff1:	0f 95 c0             	setne  %al
c0100ff4:	0f b6 c0             	movzbl %al,%eax
c0100ff7:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100ffc:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101002:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0101006:	89 c2                	mov    %eax,%edx
c0101008:	ec                   	in     (%dx),%al
c0101009:	88 45 d5             	mov    %al,-0x2b(%ebp)
c010100c:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101012:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0101016:	89 c2                	mov    %eax,%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010101c:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101021:	85 c0                	test   %eax,%eax
c0101023:	74 0c                	je     c0101031 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101025:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010102c:	e8 d6 06 00 00       	call   c0101707 <pic_enable>
    }
}
c0101031:	c9                   	leave  
c0101032:	c3                   	ret    

c0101033 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101033:	55                   	push   %ebp
c0101034:	89 e5                	mov    %esp,%ebp
c0101036:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101040:	eb 09                	jmp    c010104b <lpt_putc_sub+0x18>
        delay();
c0101042:	e8 db fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101047:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010104b:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101051:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101055:	89 c2                	mov    %eax,%edx
c0101057:	ec                   	in     (%dx),%al
c0101058:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010105b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010105f:	84 c0                	test   %al,%al
c0101061:	78 09                	js     c010106c <lpt_putc_sub+0x39>
c0101063:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010106a:	7e d6                	jle    c0101042 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c010106c:	8b 45 08             	mov    0x8(%ebp),%eax
c010106f:	0f b6 c0             	movzbl %al,%eax
c0101072:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0101078:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010107b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010107f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101083:	ee                   	out    %al,(%dx)
c0101084:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010108a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010108e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101092:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101096:	ee                   	out    %al,(%dx)
c0101097:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c010109d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010a5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010a9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010aa:	c9                   	leave  
c01010ab:	c3                   	ret    

c01010ac <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010ac:	55                   	push   %ebp
c01010ad:	89 e5                	mov    %esp,%ebp
c01010af:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010b6:	74 0d                	je     c01010c5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bb:	89 04 24             	mov    %eax,(%esp)
c01010be:	e8 70 ff ff ff       	call   c0101033 <lpt_putc_sub>
c01010c3:	eb 24                	jmp    c01010e9 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010c5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010cc:	e8 62 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010d8:	e8 56 ff ff ff       	call   c0101033 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010dd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e4:	e8 4a ff ff ff       	call   c0101033 <lpt_putc_sub>
    }
}
c01010e9:	c9                   	leave  
c01010ea:	c3                   	ret    

c01010eb <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010eb:	55                   	push   %ebp
c01010ec:	89 e5                	mov    %esp,%ebp
c01010ee:	53                   	push   %ebx
c01010ef:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f5:	b0 00                	mov    $0x0,%al
c01010f7:	85 c0                	test   %eax,%eax
c01010f9:	75 07                	jne    c0101102 <cga_putc+0x17>
        c |= 0x0700;
c01010fb:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101102:	8b 45 08             	mov    0x8(%ebp),%eax
c0101105:	0f b6 c0             	movzbl %al,%eax
c0101108:	83 f8 0a             	cmp    $0xa,%eax
c010110b:	74 4c                	je     c0101159 <cga_putc+0x6e>
c010110d:	83 f8 0d             	cmp    $0xd,%eax
c0101110:	74 57                	je     c0101169 <cga_putc+0x7e>
c0101112:	83 f8 08             	cmp    $0x8,%eax
c0101115:	0f 85 88 00 00 00    	jne    c01011a3 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c010111b:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101122:	66 85 c0             	test   %ax,%ax
c0101125:	74 30                	je     c0101157 <cga_putc+0x6c>
            crt_pos --;
c0101127:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010112e:	83 e8 01             	sub    $0x1,%eax
c0101131:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101137:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010113c:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101143:	0f b7 d2             	movzwl %dx,%edx
c0101146:	01 d2                	add    %edx,%edx
c0101148:	01 c2                	add    %eax,%edx
c010114a:	8b 45 08             	mov    0x8(%ebp),%eax
c010114d:	b0 00                	mov    $0x0,%al
c010114f:	83 c8 20             	or     $0x20,%eax
c0101152:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101155:	eb 72                	jmp    c01011c9 <cga_putc+0xde>
c0101157:	eb 70                	jmp    c01011c9 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101159:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101160:	83 c0 50             	add    $0x50,%eax
c0101163:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101170:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c0101177:	0f b7 c1             	movzwl %cx,%eax
c010117a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101180:	c1 e8 10             	shr    $0x10,%eax
c0101183:	89 c2                	mov    %eax,%edx
c0101185:	66 c1 ea 06          	shr    $0x6,%dx
c0101189:	89 d0                	mov    %edx,%eax
c010118b:	c1 e0 02             	shl    $0x2,%eax
c010118e:	01 d0                	add    %edx,%eax
c0101190:	c1 e0 04             	shl    $0x4,%eax
c0101193:	29 c1                	sub    %eax,%ecx
c0101195:	89 ca                	mov    %ecx,%edx
c0101197:	89 d8                	mov    %ebx,%eax
c0101199:	29 d0                	sub    %edx,%eax
c010119b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a1:	eb 26                	jmp    c01011c9 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011a9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011ba:	0f b7 c0             	movzwl %ax,%eax
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	66 89 02             	mov    %ax,(%edx)
        break;
c01011c8:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011c9:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d0:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011d4:	76 5b                	jbe    c0101231 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011d6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011db:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e1:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e6:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011ed:	00 
c01011ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f2:	89 04 24             	mov    %eax,(%esp)
c01011f5:	e8 62 4b 00 00       	call   c0105d5c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011fa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101201:	eb 15                	jmp    c0101218 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101203:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101208:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010120b:	01 d2                	add    %edx,%edx
c010120d:	01 d0                	add    %edx,%eax
c010120f:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101214:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101218:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c010121f:	7e e2                	jle    c0101203 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101221:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101228:	83 e8 50             	sub    $0x50,%eax
c010122b:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101231:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101238:	0f b7 c0             	movzwl %ax,%eax
c010123b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c010123f:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101243:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101247:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c010124c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101253:	66 c1 e8 08          	shr    $0x8,%ax
c0101257:	0f b6 c0             	movzbl %al,%eax
c010125a:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101261:	83 c2 01             	add    $0x1,%edx
c0101264:	0f b7 d2             	movzwl %dx,%edx
c0101267:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c010126b:	88 45 ed             	mov    %al,-0x13(%ebp)
c010126e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101272:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c0101277:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010127e:	0f b7 c0             	movzwl %ax,%eax
c0101281:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0101285:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101289:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010128d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101291:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101292:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101299:	0f b6 c0             	movzbl %al,%eax
c010129c:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012a3:	83 c2 01             	add    $0x1,%edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012ad:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012b4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	83 c4 34             	add    $0x34,%esp
c01012bc:	5b                   	pop    %ebx
c01012bd:	5d                   	pop    %ebp
c01012be:	c3                   	ret    

c01012bf <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012bf:	55                   	push   %ebp
c01012c0:	89 e5                	mov    %esp,%ebp
c01012c2:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cc:	eb 09                	jmp    c01012d7 <serial_putc_sub+0x18>
        delay();
c01012ce:	e8 4f fb ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3f>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d0                	jle    c01012ce <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	c9                   	leave  
c0101317:	c3                   	ret    

c0101318 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101318:	55                   	push   %ebp
c0101319:	89 e5                	mov    %esp,%ebp
c010131b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101322:	74 0d                	je     c0101331 <serial_putc+0x19>
        serial_putc_sub(c);
c0101324:	8b 45 08             	mov    0x8(%ebp),%eax
c0101327:	89 04 24             	mov    %eax,(%esp)
c010132a:	e8 90 ff ff ff       	call   c01012bf <serial_putc_sub>
c010132f:	eb 24                	jmp    c0101355 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101331:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101338:	e8 82 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub(' ');
c010133d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101344:	e8 76 ff ff ff       	call   c01012bf <serial_putc_sub>
        serial_putc_sub('\b');
c0101349:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101350:	e8 6a ff ff ff       	call   c01012bf <serial_putc_sub>
    }
}
c0101355:	c9                   	leave  
c0101356:	c3                   	ret    

c0101357 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101357:	55                   	push   %ebp
c0101358:	89 e5                	mov    %esp,%ebp
c010135a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135d:	eb 33                	jmp    c0101392 <cons_intr+0x3b>
        if (c != 0) {
c010135f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101363:	74 2d                	je     c0101392 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101365:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010136a:	8d 50 01             	lea    0x1(%eax),%edx
c010136d:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101373:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101376:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101381:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101386:	75 0a                	jne    c0101392 <cons_intr+0x3b>
                cons.wpos = 0;
c0101388:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c010138f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101392:	8b 45 08             	mov    0x8(%ebp),%eax
c0101395:	ff d0                	call   *%eax
c0101397:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010139e:	75 bf                	jne    c010135f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a0:	c9                   	leave  
c01013a1:	c3                   	ret    

c01013a2 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a2:	55                   	push   %ebp
c01013a3:	89 e5                	mov    %esp,%ebp
c01013a5:	83 ec 10             	sub    $0x10,%esp
c01013a8:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ae:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b2:	89 c2                	mov    %eax,%edx
c01013b4:	ec                   	in     (%dx),%al
c01013b5:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013b8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bc:	0f b6 c0             	movzbl %al,%eax
c01013bf:	83 e0 01             	and    $0x1,%eax
c01013c2:	85 c0                	test   %eax,%eax
c01013c4:	75 07                	jne    c01013cd <serial_proc_data+0x2b>
        return -1;
c01013c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013cb:	eb 2a                	jmp    c01013f7 <serial_proc_data+0x55>
c01013cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013d7:	89 c2                	mov    %eax,%edx
c01013d9:	ec                   	in     (%dx),%al
c01013da:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013dd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e1:	0f b6 c0             	movzbl %al,%eax
c01013e4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013e7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013eb:	75 07                	jne    c01013f4 <serial_proc_data+0x52>
        c = '\b';
c01013ed:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013f7:	c9                   	leave  
c01013f8:	c3                   	ret    

c01013f9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013f9:	55                   	push   %ebp
c01013fa:	89 e5                	mov    %esp,%ebp
c01013fc:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013ff:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101404:	85 c0                	test   %eax,%eax
c0101406:	74 0c                	je     c0101414 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101408:	c7 04 24 a2 13 10 c0 	movl   $0xc01013a2,(%esp)
c010140f:	e8 43 ff ff ff       	call   c0101357 <cons_intr>
    }
}
c0101414:	c9                   	leave  
c0101415:	c3                   	ret    

c0101416 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101416:	55                   	push   %ebp
c0101417:	89 e5                	mov    %esp,%ebp
c0101419:	83 ec 38             	sub    $0x38,%esp
c010141c:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101422:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101426:	89 c2                	mov    %eax,%edx
c0101428:	ec                   	in     (%dx),%al
c0101429:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101430:	0f b6 c0             	movzbl %al,%eax
c0101433:	83 e0 01             	and    $0x1,%eax
c0101436:	85 c0                	test   %eax,%eax
c0101438:	75 0a                	jne    c0101444 <kbd_proc_data+0x2e>
        return -1;
c010143a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143f:	e9 59 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
c0101444:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101454:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101458:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c010145f:	75 17                	jne    c0101478 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101461:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101466:	83 c8 40             	or     $0x40,%eax
c0101469:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c010146e:	b8 00 00 00 00       	mov    $0x0,%eax
c0101473:	e9 25 01 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c0101478:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147c:	84 c0                	test   %al,%al
c010147e:	79 47                	jns    c01014c7 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101480:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101485:	83 e0 40             	and    $0x40,%eax
c0101488:	85 c0                	test   %eax,%eax
c010148a:	75 09                	jne    c0101495 <kbd_proc_data+0x7f>
c010148c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101490:	83 e0 7f             	and    $0x7f,%eax
c0101493:	eb 04                	jmp    c0101499 <kbd_proc_data+0x83>
c0101495:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101499:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014a7:	83 c8 40             	or     $0x40,%eax
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d6 00 00 00       	jmp    c010159d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014c7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13e>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14e>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 28                	jne    c010159a <kbd_proc_data+0x184>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1f                	jne    c010159a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 dd 61 10 c0 	movl   $0xc01061dd,(%esp)
c0101582:	e8 b5 ed ff ff       	call   c010033c <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101599:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010159a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159d:	c9                   	leave  
c010159e:	c3                   	ret    

c010159f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159f:	55                   	push   %ebp
c01015a0:	89 e5                	mov    %esp,%ebp
c01015a2:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a5:	c7 04 24 16 14 10 c0 	movl   $0xc0101416,(%esp)
c01015ac:	e8 a6 fd ff ff       	call   c0101357 <cons_intr>
}
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e1 ff ff ff       	call   c010159f <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 3d 01 00 00       	call   c0101707 <pic_enable>
}
c01015ca:	c9                   	leave  
c01015cb:	c3                   	ret    

c01015cc <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cc:	55                   	push   %ebp
c01015cd:	89 e5                	mov    %esp,%ebp
c01015cf:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d2:	e8 93 f8 ff ff       	call   c0100e6a <cga_init>
    serial_init();
c01015d7:	e8 74 f9 ff ff       	call   c0100f50 <serial_init>
    kbd_init();
c01015dc:	e8 d2 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e1:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015e6:	85 c0                	test   %eax,%eax
c01015e8:	75 0c                	jne    c01015f6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015ea:	c7 04 24 e9 61 10 c0 	movl   $0xc01061e9,(%esp)
c01015f1:	e8 46 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015f6:	c9                   	leave  
c01015f7:	c3                   	ret    

c01015f8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015f8:	55                   	push   %ebp
c01015f9:	89 e5                	mov    %esp,%ebp
c01015fb:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015fe:	e8 e2 f7 ff ff       	call   c0100de5 <__intr_save>
c0101603:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101606:	8b 45 08             	mov    0x8(%ebp),%eax
c0101609:	89 04 24             	mov    %eax,(%esp)
c010160c:	e8 9b fa ff ff       	call   c01010ac <lpt_putc>
        cga_putc(c);
c0101611:	8b 45 08             	mov    0x8(%ebp),%eax
c0101614:	89 04 24             	mov    %eax,(%esp)
c0101617:	e8 cf fa ff ff       	call   c01010eb <cga_putc>
        serial_putc(c);
c010161c:	8b 45 08             	mov    0x8(%ebp),%eax
c010161f:	89 04 24             	mov    %eax,(%esp)
c0101622:	e8 f1 fc ff ff       	call   c0101318 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162a:	89 04 24             	mov    %eax,(%esp)
c010162d:	e8 dd f7 ff ff       	call   c0100e0f <__intr_restore>
}
c0101632:	c9                   	leave  
c0101633:	c3                   	ret    

c0101634 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101634:	55                   	push   %ebp
c0101635:	89 e5                	mov    %esp,%ebp
c0101637:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101641:	e8 9f f7 ff ff       	call   c0100de5 <__intr_save>
c0101646:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101649:	e8 ab fd ff ff       	call   c01013f9 <serial_intr>
        kbd_intr();
c010164e:	e8 4c ff ff ff       	call   c010159f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101653:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101659:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010165e:	39 c2                	cmp    %eax,%edx
c0101660:	74 31                	je     c0101693 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	8d 50 01             	lea    0x1(%eax),%edx
c010166a:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101670:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c0101677:	0f b6 c0             	movzbl %al,%eax
c010167a:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c010167d:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101682:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101687:	75 0a                	jne    c0101693 <cons_getc+0x5f>
                cons.rpos = 0;
c0101689:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101690:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101693:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101696:	89 04 24             	mov    %eax,(%esp)
c0101699:	e8 71 f7 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010169e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a1:	c9                   	leave  
c01016a2:	c3                   	ret    

c01016a3 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016a3:	55                   	push   %ebp
c01016a4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016a6:	fb                   	sti    
    sti();
}
c01016a7:	5d                   	pop    %ebp
c01016a8:	c3                   	ret    

c01016a9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016a9:	55                   	push   %ebp
c01016aa:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016ac:	fa                   	cli    
    cli();
}
c01016ad:	5d                   	pop    %ebp
c01016ae:	c3                   	ret    

c01016af <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016af:	55                   	push   %ebp
c01016b0:	89 e5                	mov    %esp,%ebp
c01016b2:	83 ec 14             	sub    $0x14,%esp
c01016b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b8:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016bc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c0:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016c6:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016cb:	85 c0                	test   %eax,%eax
c01016cd:	74 36                	je     c0101705 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016cf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d3:	0f b6 c0             	movzbl %al,%eax
c01016d6:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016dc:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016df:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016e3:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016e7:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ec:	66 c1 e8 08          	shr    $0x8,%ax
c01016f0:	0f b6 c0             	movzbl %al,%eax
c01016f3:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016f9:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016fc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101700:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101704:	ee                   	out    %al,(%dx)
    }
}
c0101705:	c9                   	leave  
c0101706:	c3                   	ret    

c0101707 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101707:	55                   	push   %ebp
c0101708:	89 e5                	mov    %esp,%ebp
c010170a:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010170d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101710:	ba 01 00 00 00       	mov    $0x1,%edx
c0101715:	89 c1                	mov    %eax,%ecx
c0101717:	d3 e2                	shl    %cl,%edx
c0101719:	89 d0                	mov    %edx,%eax
c010171b:	f7 d0                	not    %eax
c010171d:	89 c2                	mov    %eax,%edx
c010171f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101726:	21 d0                	and    %edx,%eax
c0101728:	0f b7 c0             	movzwl %ax,%eax
c010172b:	89 04 24             	mov    %eax,(%esp)
c010172e:	e8 7c ff ff ff       	call   c01016af <pic_setmask>
}
c0101733:	c9                   	leave  
c0101734:	c3                   	ret    

c0101735 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101735:	55                   	push   %ebp
c0101736:	89 e5                	mov    %esp,%ebp
c0101738:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010173b:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101742:	00 00 00 
c0101745:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010174b:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010174f:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101753:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101757:	ee                   	out    %al,(%dx)
c0101758:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010175e:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101762:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101766:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010176a:	ee                   	out    %al,(%dx)
c010176b:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101771:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101775:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101779:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010177d:	ee                   	out    %al,(%dx)
c010177e:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101784:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101788:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010178c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101790:	ee                   	out    %al,(%dx)
c0101791:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0101797:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c010179b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010179f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017a3:	ee                   	out    %al,(%dx)
c01017a4:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017aa:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ae:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b2:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017b6:	ee                   	out    %al,(%dx)
c01017b7:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017bd:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017c5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017c9:	ee                   	out    %al,(%dx)
c01017ca:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d0:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017d4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017d8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017dc:	ee                   	out    %al,(%dx)
c01017dd:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017e3:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017e7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017eb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017f6:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017fa:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017fe:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101809:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c010180d:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101811:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010181c:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101820:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101824:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010182f:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101833:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101837:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101842:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101846:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010184a:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184f:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101856:	66 83 f8 ff          	cmp    $0xffff,%ax
c010185a:	74 12                	je     c010186e <pic_init+0x139>
        pic_setmask(irq_mask);
c010185c:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 04 24             	mov    %eax,(%esp)
c0101869:	e8 41 fe ff ff       	call   c01016af <pic_setmask>
    }
}
c010186e:	c9                   	leave  
c010186f:	c3                   	ret    

c0101870 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101870:	55                   	push   %ebp
c0101871:	89 e5                	mov    %esp,%ebp
c0101873:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101876:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c010187d:	00 
c010187e:	c7 04 24 20 62 10 c0 	movl   $0xc0106220,(%esp)
c0101885:	e8 b2 ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010188a:	c7 04 24 2a 62 10 c0 	movl   $0xc010622a,(%esp)
c0101891:	e8 a6 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c0101896:	c7 44 24 08 38 62 10 	movl   $0xc0106238,0x8(%esp)
c010189d:	c0 
c010189e:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018a5:	00 
c01018a6:	c7 04 24 4e 62 10 c0 	movl   $0xc010624e,(%esp)
c01018ad:	e8 14 f4 ff ff       	call   c0100cc6 <__panic>

c01018b2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018b2:	55                   	push   %ebp
c01018b3:	89 e5                	mov    %esp,%ebp
c01018b5:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01018b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018bf:	e9 c3 00 00 00       	jmp    c0101987 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c7:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018ce:	89 c2                	mov    %eax,%edx
c01018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d3:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018da:	c0 
c01018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018de:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018e5:	c0 08 00 
c01018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018eb:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f2:	c0 
c01018f3:	83 e2 e0             	and    $0xffffffe0,%edx
c01018f6:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101900:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c0101907:	c0 
c0101908:	83 e2 1f             	and    $0x1f,%edx
c010190b:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101915:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010191c:	c0 
c010191d:	83 e2 f0             	and    $0xfffffff0,%edx
c0101920:	83 ca 0e             	or     $0xe,%edx
c0101923:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192d:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101934:	c0 
c0101935:	83 e2 ef             	and    $0xffffffef,%edx
c0101938:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101942:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101949:	c0 
c010194a:	83 e2 9f             	and    $0xffffff9f,%edx
c010194d:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101954:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101957:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010195e:	c0 
c010195f:	83 ca 80             	or     $0xffffff80,%edx
c0101962:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101969:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196c:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101973:	c1 e8 10             	shr    $0x10,%eax
c0101976:	89 c2                	mov    %eax,%edx
c0101978:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197b:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101982:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0101983:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101987:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010198a:	3d ff 00 00 00       	cmp    $0xff,%eax
c010198f:	0f 86 2f ff ff ff    	jbe    c01018c4 <idt_init+0x12>
c0101995:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010199c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010199f:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c01019a2:	c9                   	leave  
c01019a3:	c3                   	ret    

c01019a4 <trapname>:

static const char *
trapname(int trapno) {
c01019a4:	55                   	push   %ebp
c01019a5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019aa:	83 f8 13             	cmp    $0x13,%eax
c01019ad:	77 0c                	ja     c01019bb <trapname+0x17>
        return excnames[trapno];
c01019af:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b2:	8b 04 85 a0 65 10 c0 	mov    -0x3fef9a60(,%eax,4),%eax
c01019b9:	eb 18                	jmp    c01019d3 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019bb:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019bf:	7e 0d                	jle    c01019ce <trapname+0x2a>
c01019c1:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019c5:	7f 07                	jg     c01019ce <trapname+0x2a>
        return "Hardware Interrupt";
c01019c7:	b8 5f 62 10 c0       	mov    $0xc010625f,%eax
c01019cc:	eb 05                	jmp    c01019d3 <trapname+0x2f>
    }
    return "(unknown trap)";
c01019ce:	b8 72 62 10 c0       	mov    $0xc0106272,%eax
}
c01019d3:	5d                   	pop    %ebp
c01019d4:	c3                   	ret    

c01019d5 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019d5:	55                   	push   %ebp
c01019d6:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01019db:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019df:	66 83 f8 08          	cmp    $0x8,%ax
c01019e3:	0f 94 c0             	sete   %al
c01019e6:	0f b6 c0             	movzbl %al,%eax
}
c01019e9:	5d                   	pop    %ebp
c01019ea:	c3                   	ret    

c01019eb <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019eb:	55                   	push   %ebp
c01019ec:	89 e5                	mov    %esp,%ebp
c01019ee:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019f8:	c7 04 24 b3 62 10 c0 	movl   $0xc01062b3,(%esp)
c01019ff:	e8 38 e9 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a04:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a07:	89 04 24             	mov    %eax,(%esp)
c0101a0a:	e8 a1 01 00 00       	call   c0101bb0 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a12:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a16:	0f b7 c0             	movzwl %ax,%eax
c0101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1d:	c7 04 24 c4 62 10 c0 	movl   $0xc01062c4,(%esp)
c0101a24:	e8 13 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a30:	0f b7 c0             	movzwl %ax,%eax
c0101a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a37:	c7 04 24 d7 62 10 c0 	movl   $0xc01062d7,(%esp)
c0101a3e:	e8 f9 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a46:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a4a:	0f b7 c0             	movzwl %ax,%eax
c0101a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a51:	c7 04 24 ea 62 10 c0 	movl   $0xc01062ea,(%esp)
c0101a58:	e8 df e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a60:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a64:	0f b7 c0             	movzwl %ax,%eax
c0101a67:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a6b:	c7 04 24 fd 62 10 c0 	movl   $0xc01062fd,(%esp)
c0101a72:	e8 c5 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a77:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a7a:	8b 40 30             	mov    0x30(%eax),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 1f ff ff ff       	call   c01019a4 <trapname>
c0101a85:	8b 55 08             	mov    0x8(%ebp),%edx
c0101a88:	8b 52 30             	mov    0x30(%edx),%edx
c0101a8b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101a8f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101a93:	c7 04 24 10 63 10 c0 	movl   $0xc0106310,(%esp)
c0101a9a:	e8 9d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	8b 40 34             	mov    0x34(%eax),%eax
c0101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa9:	c7 04 24 22 63 10 c0 	movl   $0xc0106322,(%esp)
c0101ab0:	e8 87 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	8b 40 38             	mov    0x38(%eax),%eax
c0101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abf:	c7 04 24 31 63 10 c0 	movl   $0xc0106331,(%esp)
c0101ac6:	e8 71 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ad2:	0f b7 c0             	movzwl %ax,%eax
c0101ad5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad9:	c7 04 24 40 63 10 c0 	movl   $0xc0106340,(%esp)
c0101ae0:	e8 57 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae8:	8b 40 40             	mov    0x40(%eax),%eax
c0101aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aef:	c7 04 24 53 63 10 c0 	movl   $0xc0106353,(%esp)
c0101af6:	e8 41 e8 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101afb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b02:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b09:	eb 3e                	jmp    c0101b49 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b0b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0e:	8b 50 40             	mov    0x40(%eax),%edx
c0101b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b14:	21 d0                	and    %edx,%eax
c0101b16:	85 c0                	test   %eax,%eax
c0101b18:	74 28                	je     c0101b42 <print_trapframe+0x157>
c0101b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b1d:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b24:	85 c0                	test   %eax,%eax
c0101b26:	74 1a                	je     c0101b42 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b2b:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b36:	c7 04 24 62 63 10 c0 	movl   $0xc0106362,(%esp)
c0101b3d:	e8 fa e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101b46:	d1 65 f0             	shll   -0x10(%ebp)
c0101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b4c:	83 f8 17             	cmp    $0x17,%eax
c0101b4f:	76 ba                	jbe    c0101b0b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	8b 40 40             	mov    0x40(%eax),%eax
c0101b57:	25 00 30 00 00       	and    $0x3000,%eax
c0101b5c:	c1 e8 0c             	shr    $0xc,%eax
c0101b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b63:	c7 04 24 66 63 10 c0 	movl   $0xc0106366,(%esp)
c0101b6a:	e8 cd e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b72:	89 04 24             	mov    %eax,(%esp)
c0101b75:	e8 5b fe ff ff       	call   c01019d5 <trap_in_kernel>
c0101b7a:	85 c0                	test   %eax,%eax
c0101b7c:	75 30                	jne    c0101bae <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b81:	8b 40 44             	mov    0x44(%eax),%eax
c0101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b88:	c7 04 24 6f 63 10 c0 	movl   $0xc010636f,(%esp)
c0101b8f:	e8 a8 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b94:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b97:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b9b:	0f b7 c0             	movzwl %ax,%eax
c0101b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba2:	c7 04 24 7e 63 10 c0 	movl   $0xc010637e,(%esp)
c0101ba9:	e8 8e e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101bae:	c9                   	leave  
c0101baf:	c3                   	ret    

c0101bb0 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101bb0:	55                   	push   %ebp
c0101bb1:	89 e5                	mov    %esp,%ebp
c0101bb3:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb9:	8b 00                	mov    (%eax),%eax
c0101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bbf:	c7 04 24 91 63 10 c0 	movl   $0xc0106391,(%esp)
c0101bc6:	e8 71 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bce:	8b 40 04             	mov    0x4(%eax),%eax
c0101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bd5:	c7 04 24 a0 63 10 c0 	movl   $0xc01063a0,(%esp)
c0101bdc:	e8 5b e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be4:	8b 40 08             	mov    0x8(%eax),%eax
c0101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101beb:	c7 04 24 af 63 10 c0 	movl   $0xc01063af,(%esp)
c0101bf2:	e8 45 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c01:	c7 04 24 be 63 10 c0 	movl   $0xc01063be,(%esp)
c0101c08:	e8 2f e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c10:	8b 40 10             	mov    0x10(%eax),%eax
c0101c13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c17:	c7 04 24 cd 63 10 c0 	movl   $0xc01063cd,(%esp)
c0101c1e:	e8 19 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c23:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c26:	8b 40 14             	mov    0x14(%eax),%eax
c0101c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2d:	c7 04 24 dc 63 10 c0 	movl   $0xc01063dc,(%esp)
c0101c34:	e8 03 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c39:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3c:	8b 40 18             	mov    0x18(%eax),%eax
c0101c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c43:	c7 04 24 eb 63 10 c0 	movl   $0xc01063eb,(%esp)
c0101c4a:	e8 ed e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c52:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c55:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c59:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101c60:	e8 d7 e6 ff ff       	call   c010033c <cprintf>
}
c0101c65:	c9                   	leave  
c0101c66:	c3                   	ret    

c0101c67 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c67:	55                   	push   %ebp
c0101c68:	89 e5                	mov    %esp,%ebp
c0101c6a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c70:	8b 40 30             	mov    0x30(%eax),%eax
c0101c73:	83 f8 2f             	cmp    $0x2f,%eax
c0101c76:	77 21                	ja     c0101c99 <trap_dispatch+0x32>
c0101c78:	83 f8 2e             	cmp    $0x2e,%eax
c0101c7b:	0f 83 04 01 00 00    	jae    c0101d85 <trap_dispatch+0x11e>
c0101c81:	83 f8 21             	cmp    $0x21,%eax
c0101c84:	0f 84 81 00 00 00    	je     c0101d0b <trap_dispatch+0xa4>
c0101c8a:	83 f8 24             	cmp    $0x24,%eax
c0101c8d:	74 56                	je     c0101ce5 <trap_dispatch+0x7e>
c0101c8f:	83 f8 20             	cmp    $0x20,%eax
c0101c92:	74 16                	je     c0101caa <trap_dispatch+0x43>
c0101c94:	e9 b4 00 00 00       	jmp    c0101d4d <trap_dispatch+0xe6>
c0101c99:	83 e8 78             	sub    $0x78,%eax
c0101c9c:	83 f8 01             	cmp    $0x1,%eax
c0101c9f:	0f 87 a8 00 00 00    	ja     c0101d4d <trap_dispatch+0xe6>
c0101ca5:	e9 87 00 00 00       	jmp    c0101d31 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101caa:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101caf:	83 c0 01             	add    $0x1,%eax
c0101cb2:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101cb7:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101cbd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101cc2:	89 c8                	mov    %ecx,%eax
c0101cc4:	f7 e2                	mul    %edx
c0101cc6:	89 d0                	mov    %edx,%eax
c0101cc8:	c1 e8 05             	shr    $0x5,%eax
c0101ccb:	6b c0 64             	imul   $0x64,%eax,%eax
c0101cce:	29 c1                	sub    %eax,%ecx
c0101cd0:	89 c8                	mov    %ecx,%eax
c0101cd2:	85 c0                	test   %eax,%eax
c0101cd4:	75 0a                	jne    c0101ce0 <trap_dispatch+0x79>
            print_ticks();
c0101cd6:	e8 95 fb ff ff       	call   c0101870 <print_ticks>
        }
        break;
c0101cdb:	e9 a6 00 00 00       	jmp    c0101d86 <trap_dispatch+0x11f>
c0101ce0:	e9 a1 00 00 00       	jmp    c0101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ce5:	e8 4a f9 ff ff       	call   c0101634 <cons_getc>
c0101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cfd:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101d04:	e8 33 e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d09:	eb 7b                	jmp    c0101d86 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d0b:	e8 24 f9 ff ff       	call   c0101634 <cons_getc>
c0101d10:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d13:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d17:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d1b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d23:	c7 04 24 1b 64 10 c0 	movl   $0xc010641b,(%esp)
c0101d2a:	e8 0d e6 ff ff       	call   c010033c <cprintf>
        break;
c0101d2f:	eb 55                	jmp    c0101d86 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d31:	c7 44 24 08 2a 64 10 	movl   $0xc010642a,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 4e 62 10 c0 	movl   $0xc010624e,(%esp)
c0101d48:	e8 79 ef ff ff       	call   c0100cc6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d50:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d54:	0f b7 c0             	movzwl %ax,%eax
c0101d57:	83 e0 03             	and    $0x3,%eax
c0101d5a:	85 c0                	test   %eax,%eax
c0101d5c:	75 28                	jne    c0101d86 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	89 04 24             	mov    %eax,(%esp)
c0101d64:	e8 82 fc ff ff       	call   c01019eb <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d69:	c7 44 24 08 3a 64 10 	movl   $0xc010643a,0x8(%esp)
c0101d70:	c0 
c0101d71:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0101d78:	00 
c0101d79:	c7 04 24 4e 62 10 c0 	movl   $0xc010624e,(%esp)
c0101d80:	e8 41 ef ff ff       	call   c0100cc6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101d85:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101d86:	c9                   	leave  
c0101d87:	c3                   	ret    

c0101d88 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d88:	55                   	push   %ebp
c0101d89:	89 e5                	mov    %esp,%ebp
c0101d8b:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d91:	89 04 24             	mov    %eax,(%esp)
c0101d94:	e8 ce fe ff ff       	call   c0101c67 <trap_dispatch>
}
c0101d99:	c9                   	leave  
c0101d9a:	c3                   	ret    

c0101d9b <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101d9b:	1e                   	push   %ds
    pushl %es
c0101d9c:	06                   	push   %es
    pushl %fs
c0101d9d:	0f a0                	push   %fs
    pushl %gs
c0101d9f:	0f a8                	push   %gs
    pushal
c0101da1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101da2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101da7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101da9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101dab:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101dac:	e8 d7 ff ff ff       	call   c0101d88 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101db1:	5c                   	pop    %esp

c0101db2 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101db2:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101db3:	0f a9                	pop    %gs
    popl %fs
c0101db5:	0f a1                	pop    %fs
    popl %es
c0101db7:	07                   	pop    %es
    popl %ds
c0101db8:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101db9:	83 c4 08             	add    $0x8,%esp
    iret
c0101dbc:	cf                   	iret   

c0101dbd <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101dbd:	6a 00                	push   $0x0
  pushl $0
c0101dbf:	6a 00                	push   $0x0
  jmp __alltraps
c0101dc1:	e9 d5 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dc6 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101dc6:	6a 00                	push   $0x0
  pushl $1
c0101dc8:	6a 01                	push   $0x1
  jmp __alltraps
c0101dca:	e9 cc ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dcf <vector2>:
.globl vector2
vector2:
  pushl $0
c0101dcf:	6a 00                	push   $0x0
  pushl $2
c0101dd1:	6a 02                	push   $0x2
  jmp __alltraps
c0101dd3:	e9 c3 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dd8 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101dd8:	6a 00                	push   $0x0
  pushl $3
c0101dda:	6a 03                	push   $0x3
  jmp __alltraps
c0101ddc:	e9 ba ff ff ff       	jmp    c0101d9b <__alltraps>

c0101de1 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101de1:	6a 00                	push   $0x0
  pushl $4
c0101de3:	6a 04                	push   $0x4
  jmp __alltraps
c0101de5:	e9 b1 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dea <vector5>:
.globl vector5
vector5:
  pushl $0
c0101dea:	6a 00                	push   $0x0
  pushl $5
c0101dec:	6a 05                	push   $0x5
  jmp __alltraps
c0101dee:	e9 a8 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101df3 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101df3:	6a 00                	push   $0x0
  pushl $6
c0101df5:	6a 06                	push   $0x6
  jmp __alltraps
c0101df7:	e9 9f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101dfc <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dfc:	6a 00                	push   $0x0
  pushl $7
c0101dfe:	6a 07                	push   $0x7
  jmp __alltraps
c0101e00:	e9 96 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e05 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e05:	6a 08                	push   $0x8
  jmp __alltraps
c0101e07:	e9 8f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e0c <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e0c:	6a 09                	push   $0x9
  jmp __alltraps
c0101e0e:	e9 88 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e13 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e13:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e15:	e9 81 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e1a <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e1a:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e1c:	e9 7a ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e21 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e21:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e23:	e9 73 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e28 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e28:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e2a:	e9 6c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e2f <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e2f:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e31:	e9 65 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e36 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $15
c0101e38:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e3a:	e9 5c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e3f <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e3f:	6a 00                	push   $0x0
  pushl $16
c0101e41:	6a 10                	push   $0x10
  jmp __alltraps
c0101e43:	e9 53 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e48 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e48:	6a 11                	push   $0x11
  jmp __alltraps
c0101e4a:	e9 4c ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e4f <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e4f:	6a 00                	push   $0x0
  pushl $18
c0101e51:	6a 12                	push   $0x12
  jmp __alltraps
c0101e53:	e9 43 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e58 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e58:	6a 00                	push   $0x0
  pushl $19
c0101e5a:	6a 13                	push   $0x13
  jmp __alltraps
c0101e5c:	e9 3a ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e61 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e61:	6a 00                	push   $0x0
  pushl $20
c0101e63:	6a 14                	push   $0x14
  jmp __alltraps
c0101e65:	e9 31 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e6a <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e6a:	6a 00                	push   $0x0
  pushl $21
c0101e6c:	6a 15                	push   $0x15
  jmp __alltraps
c0101e6e:	e9 28 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e73 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e73:	6a 00                	push   $0x0
  pushl $22
c0101e75:	6a 16                	push   $0x16
  jmp __alltraps
c0101e77:	e9 1f ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e7c <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e7c:	6a 00                	push   $0x0
  pushl $23
c0101e7e:	6a 17                	push   $0x17
  jmp __alltraps
c0101e80:	e9 16 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e85 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e85:	6a 00                	push   $0x0
  pushl $24
c0101e87:	6a 18                	push   $0x18
  jmp __alltraps
c0101e89:	e9 0d ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e8e <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e8e:	6a 00                	push   $0x0
  pushl $25
c0101e90:	6a 19                	push   $0x19
  jmp __alltraps
c0101e92:	e9 04 ff ff ff       	jmp    c0101d9b <__alltraps>

c0101e97 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e97:	6a 00                	push   $0x0
  pushl $26
c0101e99:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e9b:	e9 fb fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ea0 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101ea0:	6a 00                	push   $0x0
  pushl $27
c0101ea2:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101ea4:	e9 f2 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ea9 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101ea9:	6a 00                	push   $0x0
  pushl $28
c0101eab:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101ead:	e9 e9 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101eb2 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101eb2:	6a 00                	push   $0x0
  pushl $29
c0101eb4:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101eb6:	e9 e0 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ebb <vector30>:
.globl vector30
vector30:
  pushl $0
c0101ebb:	6a 00                	push   $0x0
  pushl $30
c0101ebd:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101ebf:	e9 d7 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ec4 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101ec4:	6a 00                	push   $0x0
  pushl $31
c0101ec6:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101ec8:	e9 ce fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ecd <vector32>:
.globl vector32
vector32:
  pushl $0
c0101ecd:	6a 00                	push   $0x0
  pushl $32
c0101ecf:	6a 20                	push   $0x20
  jmp __alltraps
c0101ed1:	e9 c5 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ed6 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101ed6:	6a 00                	push   $0x0
  pushl $33
c0101ed8:	6a 21                	push   $0x21
  jmp __alltraps
c0101eda:	e9 bc fe ff ff       	jmp    c0101d9b <__alltraps>

c0101edf <vector34>:
.globl vector34
vector34:
  pushl $0
c0101edf:	6a 00                	push   $0x0
  pushl $34
c0101ee1:	6a 22                	push   $0x22
  jmp __alltraps
c0101ee3:	e9 b3 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ee8 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $35
c0101eea:	6a 23                	push   $0x23
  jmp __alltraps
c0101eec:	e9 aa fe ff ff       	jmp    c0101d9b <__alltraps>

c0101ef1 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $36
c0101ef3:	6a 24                	push   $0x24
  jmp __alltraps
c0101ef5:	e9 a1 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101efa <vector37>:
.globl vector37
vector37:
  pushl $0
c0101efa:	6a 00                	push   $0x0
  pushl $37
c0101efc:	6a 25                	push   $0x25
  jmp __alltraps
c0101efe:	e9 98 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f03 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f03:	6a 00                	push   $0x0
  pushl $38
c0101f05:	6a 26                	push   $0x26
  jmp __alltraps
c0101f07:	e9 8f fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f0c <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f0c:	6a 00                	push   $0x0
  pushl $39
c0101f0e:	6a 27                	push   $0x27
  jmp __alltraps
c0101f10:	e9 86 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f15 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f15:	6a 00                	push   $0x0
  pushl $40
c0101f17:	6a 28                	push   $0x28
  jmp __alltraps
c0101f19:	e9 7d fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f1e <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f1e:	6a 00                	push   $0x0
  pushl $41
c0101f20:	6a 29                	push   $0x29
  jmp __alltraps
c0101f22:	e9 74 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f27 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f27:	6a 00                	push   $0x0
  pushl $42
c0101f29:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f2b:	e9 6b fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f30 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f30:	6a 00                	push   $0x0
  pushl $43
c0101f32:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f34:	e9 62 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f39 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f39:	6a 00                	push   $0x0
  pushl $44
c0101f3b:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f3d:	e9 59 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f42 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f42:	6a 00                	push   $0x0
  pushl $45
c0101f44:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f46:	e9 50 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f4b <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f4b:	6a 00                	push   $0x0
  pushl $46
c0101f4d:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f4f:	e9 47 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f54 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f54:	6a 00                	push   $0x0
  pushl $47
c0101f56:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f58:	e9 3e fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f5d <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f5d:	6a 00                	push   $0x0
  pushl $48
c0101f5f:	6a 30                	push   $0x30
  jmp __alltraps
c0101f61:	e9 35 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f66 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f66:	6a 00                	push   $0x0
  pushl $49
c0101f68:	6a 31                	push   $0x31
  jmp __alltraps
c0101f6a:	e9 2c fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f6f <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f6f:	6a 00                	push   $0x0
  pushl $50
c0101f71:	6a 32                	push   $0x32
  jmp __alltraps
c0101f73:	e9 23 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f78 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f78:	6a 00                	push   $0x0
  pushl $51
c0101f7a:	6a 33                	push   $0x33
  jmp __alltraps
c0101f7c:	e9 1a fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f81 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $52
c0101f83:	6a 34                	push   $0x34
  jmp __alltraps
c0101f85:	e9 11 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f8a <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f8a:	6a 00                	push   $0x0
  pushl $53
c0101f8c:	6a 35                	push   $0x35
  jmp __alltraps
c0101f8e:	e9 08 fe ff ff       	jmp    c0101d9b <__alltraps>

c0101f93 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f93:	6a 00                	push   $0x0
  pushl $54
c0101f95:	6a 36                	push   $0x36
  jmp __alltraps
c0101f97:	e9 ff fd ff ff       	jmp    c0101d9b <__alltraps>

c0101f9c <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f9c:	6a 00                	push   $0x0
  pushl $55
c0101f9e:	6a 37                	push   $0x37
  jmp __alltraps
c0101fa0:	e9 f6 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fa5 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101fa5:	6a 00                	push   $0x0
  pushl $56
c0101fa7:	6a 38                	push   $0x38
  jmp __alltraps
c0101fa9:	e9 ed fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fae <vector57>:
.globl vector57
vector57:
  pushl $0
c0101fae:	6a 00                	push   $0x0
  pushl $57
c0101fb0:	6a 39                	push   $0x39
  jmp __alltraps
c0101fb2:	e9 e4 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fb7 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101fb7:	6a 00                	push   $0x0
  pushl $58
c0101fb9:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101fbb:	e9 db fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fc0 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101fc0:	6a 00                	push   $0x0
  pushl $59
c0101fc2:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101fc4:	e9 d2 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fc9 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101fc9:	6a 00                	push   $0x0
  pushl $60
c0101fcb:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101fcd:	e9 c9 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fd2 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101fd2:	6a 00                	push   $0x0
  pushl $61
c0101fd4:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101fd6:	e9 c0 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fdb <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fdb:	6a 00                	push   $0x0
  pushl $62
c0101fdd:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fdf:	e9 b7 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fe4 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fe4:	6a 00                	push   $0x0
  pushl $63
c0101fe6:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fe8:	e9 ae fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fed <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fed:	6a 00                	push   $0x0
  pushl $64
c0101fef:	6a 40                	push   $0x40
  jmp __alltraps
c0101ff1:	e9 a5 fd ff ff       	jmp    c0101d9b <__alltraps>

c0101ff6 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101ff6:	6a 00                	push   $0x0
  pushl $65
c0101ff8:	6a 41                	push   $0x41
  jmp __alltraps
c0101ffa:	e9 9c fd ff ff       	jmp    c0101d9b <__alltraps>

c0101fff <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fff:	6a 00                	push   $0x0
  pushl $66
c0102001:	6a 42                	push   $0x42
  jmp __alltraps
c0102003:	e9 93 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102008 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102008:	6a 00                	push   $0x0
  pushl $67
c010200a:	6a 43                	push   $0x43
  jmp __alltraps
c010200c:	e9 8a fd ff ff       	jmp    c0101d9b <__alltraps>

c0102011 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102011:	6a 00                	push   $0x0
  pushl $68
c0102013:	6a 44                	push   $0x44
  jmp __alltraps
c0102015:	e9 81 fd ff ff       	jmp    c0101d9b <__alltraps>

c010201a <vector69>:
.globl vector69
vector69:
  pushl $0
c010201a:	6a 00                	push   $0x0
  pushl $69
c010201c:	6a 45                	push   $0x45
  jmp __alltraps
c010201e:	e9 78 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102023 <vector70>:
.globl vector70
vector70:
  pushl $0
c0102023:	6a 00                	push   $0x0
  pushl $70
c0102025:	6a 46                	push   $0x46
  jmp __alltraps
c0102027:	e9 6f fd ff ff       	jmp    c0101d9b <__alltraps>

c010202c <vector71>:
.globl vector71
vector71:
  pushl $0
c010202c:	6a 00                	push   $0x0
  pushl $71
c010202e:	6a 47                	push   $0x47
  jmp __alltraps
c0102030:	e9 66 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102035 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102035:	6a 00                	push   $0x0
  pushl $72
c0102037:	6a 48                	push   $0x48
  jmp __alltraps
c0102039:	e9 5d fd ff ff       	jmp    c0101d9b <__alltraps>

c010203e <vector73>:
.globl vector73
vector73:
  pushl $0
c010203e:	6a 00                	push   $0x0
  pushl $73
c0102040:	6a 49                	push   $0x49
  jmp __alltraps
c0102042:	e9 54 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102047 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102047:	6a 00                	push   $0x0
  pushl $74
c0102049:	6a 4a                	push   $0x4a
  jmp __alltraps
c010204b:	e9 4b fd ff ff       	jmp    c0101d9b <__alltraps>

c0102050 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102050:	6a 00                	push   $0x0
  pushl $75
c0102052:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102054:	e9 42 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102059 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102059:	6a 00                	push   $0x0
  pushl $76
c010205b:	6a 4c                	push   $0x4c
  jmp __alltraps
c010205d:	e9 39 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102062 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102062:	6a 00                	push   $0x0
  pushl $77
c0102064:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102066:	e9 30 fd ff ff       	jmp    c0101d9b <__alltraps>

c010206b <vector78>:
.globl vector78
vector78:
  pushl $0
c010206b:	6a 00                	push   $0x0
  pushl $78
c010206d:	6a 4e                	push   $0x4e
  jmp __alltraps
c010206f:	e9 27 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102074 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102074:	6a 00                	push   $0x0
  pushl $79
c0102076:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102078:	e9 1e fd ff ff       	jmp    c0101d9b <__alltraps>

c010207d <vector80>:
.globl vector80
vector80:
  pushl $0
c010207d:	6a 00                	push   $0x0
  pushl $80
c010207f:	6a 50                	push   $0x50
  jmp __alltraps
c0102081:	e9 15 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102086 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102086:	6a 00                	push   $0x0
  pushl $81
c0102088:	6a 51                	push   $0x51
  jmp __alltraps
c010208a:	e9 0c fd ff ff       	jmp    c0101d9b <__alltraps>

c010208f <vector82>:
.globl vector82
vector82:
  pushl $0
c010208f:	6a 00                	push   $0x0
  pushl $82
c0102091:	6a 52                	push   $0x52
  jmp __alltraps
c0102093:	e9 03 fd ff ff       	jmp    c0101d9b <__alltraps>

c0102098 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102098:	6a 00                	push   $0x0
  pushl $83
c010209a:	6a 53                	push   $0x53
  jmp __alltraps
c010209c:	e9 fa fc ff ff       	jmp    c0101d9b <__alltraps>

c01020a1 <vector84>:
.globl vector84
vector84:
  pushl $0
c01020a1:	6a 00                	push   $0x0
  pushl $84
c01020a3:	6a 54                	push   $0x54
  jmp __alltraps
c01020a5:	e9 f1 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020aa <vector85>:
.globl vector85
vector85:
  pushl $0
c01020aa:	6a 00                	push   $0x0
  pushl $85
c01020ac:	6a 55                	push   $0x55
  jmp __alltraps
c01020ae:	e9 e8 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020b3 <vector86>:
.globl vector86
vector86:
  pushl $0
c01020b3:	6a 00                	push   $0x0
  pushl $86
c01020b5:	6a 56                	push   $0x56
  jmp __alltraps
c01020b7:	e9 df fc ff ff       	jmp    c0101d9b <__alltraps>

c01020bc <vector87>:
.globl vector87
vector87:
  pushl $0
c01020bc:	6a 00                	push   $0x0
  pushl $87
c01020be:	6a 57                	push   $0x57
  jmp __alltraps
c01020c0:	e9 d6 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020c5 <vector88>:
.globl vector88
vector88:
  pushl $0
c01020c5:	6a 00                	push   $0x0
  pushl $88
c01020c7:	6a 58                	push   $0x58
  jmp __alltraps
c01020c9:	e9 cd fc ff ff       	jmp    c0101d9b <__alltraps>

c01020ce <vector89>:
.globl vector89
vector89:
  pushl $0
c01020ce:	6a 00                	push   $0x0
  pushl $89
c01020d0:	6a 59                	push   $0x59
  jmp __alltraps
c01020d2:	e9 c4 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020d7 <vector90>:
.globl vector90
vector90:
  pushl $0
c01020d7:	6a 00                	push   $0x0
  pushl $90
c01020d9:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020db:	e9 bb fc ff ff       	jmp    c0101d9b <__alltraps>

c01020e0 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020e0:	6a 00                	push   $0x0
  pushl $91
c01020e2:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020e4:	e9 b2 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020e9 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020e9:	6a 00                	push   $0x0
  pushl $92
c01020eb:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020ed:	e9 a9 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020f2 <vector93>:
.globl vector93
vector93:
  pushl $0
c01020f2:	6a 00                	push   $0x0
  pushl $93
c01020f4:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020f6:	e9 a0 fc ff ff       	jmp    c0101d9b <__alltraps>

c01020fb <vector94>:
.globl vector94
vector94:
  pushl $0
c01020fb:	6a 00                	push   $0x0
  pushl $94
c01020fd:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020ff:	e9 97 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102104 <vector95>:
.globl vector95
vector95:
  pushl $0
c0102104:	6a 00                	push   $0x0
  pushl $95
c0102106:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102108:	e9 8e fc ff ff       	jmp    c0101d9b <__alltraps>

c010210d <vector96>:
.globl vector96
vector96:
  pushl $0
c010210d:	6a 00                	push   $0x0
  pushl $96
c010210f:	6a 60                	push   $0x60
  jmp __alltraps
c0102111:	e9 85 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102116 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102116:	6a 00                	push   $0x0
  pushl $97
c0102118:	6a 61                	push   $0x61
  jmp __alltraps
c010211a:	e9 7c fc ff ff       	jmp    c0101d9b <__alltraps>

c010211f <vector98>:
.globl vector98
vector98:
  pushl $0
c010211f:	6a 00                	push   $0x0
  pushl $98
c0102121:	6a 62                	push   $0x62
  jmp __alltraps
c0102123:	e9 73 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102128 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102128:	6a 00                	push   $0x0
  pushl $99
c010212a:	6a 63                	push   $0x63
  jmp __alltraps
c010212c:	e9 6a fc ff ff       	jmp    c0101d9b <__alltraps>

c0102131 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102131:	6a 00                	push   $0x0
  pushl $100
c0102133:	6a 64                	push   $0x64
  jmp __alltraps
c0102135:	e9 61 fc ff ff       	jmp    c0101d9b <__alltraps>

c010213a <vector101>:
.globl vector101
vector101:
  pushl $0
c010213a:	6a 00                	push   $0x0
  pushl $101
c010213c:	6a 65                	push   $0x65
  jmp __alltraps
c010213e:	e9 58 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102143 <vector102>:
.globl vector102
vector102:
  pushl $0
c0102143:	6a 00                	push   $0x0
  pushl $102
c0102145:	6a 66                	push   $0x66
  jmp __alltraps
c0102147:	e9 4f fc ff ff       	jmp    c0101d9b <__alltraps>

c010214c <vector103>:
.globl vector103
vector103:
  pushl $0
c010214c:	6a 00                	push   $0x0
  pushl $103
c010214e:	6a 67                	push   $0x67
  jmp __alltraps
c0102150:	e9 46 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102155 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102155:	6a 00                	push   $0x0
  pushl $104
c0102157:	6a 68                	push   $0x68
  jmp __alltraps
c0102159:	e9 3d fc ff ff       	jmp    c0101d9b <__alltraps>

c010215e <vector105>:
.globl vector105
vector105:
  pushl $0
c010215e:	6a 00                	push   $0x0
  pushl $105
c0102160:	6a 69                	push   $0x69
  jmp __alltraps
c0102162:	e9 34 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102167 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102167:	6a 00                	push   $0x0
  pushl $106
c0102169:	6a 6a                	push   $0x6a
  jmp __alltraps
c010216b:	e9 2b fc ff ff       	jmp    c0101d9b <__alltraps>

c0102170 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102170:	6a 00                	push   $0x0
  pushl $107
c0102172:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102174:	e9 22 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102179 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102179:	6a 00                	push   $0x0
  pushl $108
c010217b:	6a 6c                	push   $0x6c
  jmp __alltraps
c010217d:	e9 19 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102182 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102182:	6a 00                	push   $0x0
  pushl $109
c0102184:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102186:	e9 10 fc ff ff       	jmp    c0101d9b <__alltraps>

c010218b <vector110>:
.globl vector110
vector110:
  pushl $0
c010218b:	6a 00                	push   $0x0
  pushl $110
c010218d:	6a 6e                	push   $0x6e
  jmp __alltraps
c010218f:	e9 07 fc ff ff       	jmp    c0101d9b <__alltraps>

c0102194 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102194:	6a 00                	push   $0x0
  pushl $111
c0102196:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102198:	e9 fe fb ff ff       	jmp    c0101d9b <__alltraps>

c010219d <vector112>:
.globl vector112
vector112:
  pushl $0
c010219d:	6a 00                	push   $0x0
  pushl $112
c010219f:	6a 70                	push   $0x70
  jmp __alltraps
c01021a1:	e9 f5 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021a6 <vector113>:
.globl vector113
vector113:
  pushl $0
c01021a6:	6a 00                	push   $0x0
  pushl $113
c01021a8:	6a 71                	push   $0x71
  jmp __alltraps
c01021aa:	e9 ec fb ff ff       	jmp    c0101d9b <__alltraps>

c01021af <vector114>:
.globl vector114
vector114:
  pushl $0
c01021af:	6a 00                	push   $0x0
  pushl $114
c01021b1:	6a 72                	push   $0x72
  jmp __alltraps
c01021b3:	e9 e3 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021b8 <vector115>:
.globl vector115
vector115:
  pushl $0
c01021b8:	6a 00                	push   $0x0
  pushl $115
c01021ba:	6a 73                	push   $0x73
  jmp __alltraps
c01021bc:	e9 da fb ff ff       	jmp    c0101d9b <__alltraps>

c01021c1 <vector116>:
.globl vector116
vector116:
  pushl $0
c01021c1:	6a 00                	push   $0x0
  pushl $116
c01021c3:	6a 74                	push   $0x74
  jmp __alltraps
c01021c5:	e9 d1 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021ca <vector117>:
.globl vector117
vector117:
  pushl $0
c01021ca:	6a 00                	push   $0x0
  pushl $117
c01021cc:	6a 75                	push   $0x75
  jmp __alltraps
c01021ce:	e9 c8 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021d3 <vector118>:
.globl vector118
vector118:
  pushl $0
c01021d3:	6a 00                	push   $0x0
  pushl $118
c01021d5:	6a 76                	push   $0x76
  jmp __alltraps
c01021d7:	e9 bf fb ff ff       	jmp    c0101d9b <__alltraps>

c01021dc <vector119>:
.globl vector119
vector119:
  pushl $0
c01021dc:	6a 00                	push   $0x0
  pushl $119
c01021de:	6a 77                	push   $0x77
  jmp __alltraps
c01021e0:	e9 b6 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021e5 <vector120>:
.globl vector120
vector120:
  pushl $0
c01021e5:	6a 00                	push   $0x0
  pushl $120
c01021e7:	6a 78                	push   $0x78
  jmp __alltraps
c01021e9:	e9 ad fb ff ff       	jmp    c0101d9b <__alltraps>

c01021ee <vector121>:
.globl vector121
vector121:
  pushl $0
c01021ee:	6a 00                	push   $0x0
  pushl $121
c01021f0:	6a 79                	push   $0x79
  jmp __alltraps
c01021f2:	e9 a4 fb ff ff       	jmp    c0101d9b <__alltraps>

c01021f7 <vector122>:
.globl vector122
vector122:
  pushl $0
c01021f7:	6a 00                	push   $0x0
  pushl $122
c01021f9:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021fb:	e9 9b fb ff ff       	jmp    c0101d9b <__alltraps>

c0102200 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102200:	6a 00                	push   $0x0
  pushl $123
c0102202:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102204:	e9 92 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102209 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102209:	6a 00                	push   $0x0
  pushl $124
c010220b:	6a 7c                	push   $0x7c
  jmp __alltraps
c010220d:	e9 89 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102212 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102212:	6a 00                	push   $0x0
  pushl $125
c0102214:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102216:	e9 80 fb ff ff       	jmp    c0101d9b <__alltraps>

c010221b <vector126>:
.globl vector126
vector126:
  pushl $0
c010221b:	6a 00                	push   $0x0
  pushl $126
c010221d:	6a 7e                	push   $0x7e
  jmp __alltraps
c010221f:	e9 77 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102224 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102224:	6a 00                	push   $0x0
  pushl $127
c0102226:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102228:	e9 6e fb ff ff       	jmp    c0101d9b <__alltraps>

c010222d <vector128>:
.globl vector128
vector128:
  pushl $0
c010222d:	6a 00                	push   $0x0
  pushl $128
c010222f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102234:	e9 62 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102239 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102239:	6a 00                	push   $0x0
  pushl $129
c010223b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102240:	e9 56 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102245 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $130
c0102247:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010224c:	e9 4a fb ff ff       	jmp    c0101d9b <__alltraps>

c0102251 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102251:	6a 00                	push   $0x0
  pushl $131
c0102253:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102258:	e9 3e fb ff ff       	jmp    c0101d9b <__alltraps>

c010225d <vector132>:
.globl vector132
vector132:
  pushl $0
c010225d:	6a 00                	push   $0x0
  pushl $132
c010225f:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102264:	e9 32 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102269 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $133
c010226b:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102270:	e9 26 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102275 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102275:	6a 00                	push   $0x0
  pushl $134
c0102277:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010227c:	e9 1a fb ff ff       	jmp    c0101d9b <__alltraps>

c0102281 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102281:	6a 00                	push   $0x0
  pushl $135
c0102283:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102288:	e9 0e fb ff ff       	jmp    c0101d9b <__alltraps>

c010228d <vector136>:
.globl vector136
vector136:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $136
c010228f:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102294:	e9 02 fb ff ff       	jmp    c0101d9b <__alltraps>

c0102299 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102299:	6a 00                	push   $0x0
  pushl $137
c010229b:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c01022a0:	e9 f6 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022a5 <vector138>:
.globl vector138
vector138:
  pushl $0
c01022a5:	6a 00                	push   $0x0
  pushl $138
c01022a7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01022ac:	e9 ea fa ff ff       	jmp    c0101d9b <__alltraps>

c01022b1 <vector139>:
.globl vector139
vector139:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $139
c01022b3:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01022b8:	e9 de fa ff ff       	jmp    c0101d9b <__alltraps>

c01022bd <vector140>:
.globl vector140
vector140:
  pushl $0
c01022bd:	6a 00                	push   $0x0
  pushl $140
c01022bf:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01022c4:	e9 d2 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022c9 <vector141>:
.globl vector141
vector141:
  pushl $0
c01022c9:	6a 00                	push   $0x0
  pushl $141
c01022cb:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01022d0:	e9 c6 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022d5 <vector142>:
.globl vector142
vector142:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $142
c01022d7:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022dc:	e9 ba fa ff ff       	jmp    c0101d9b <__alltraps>

c01022e1 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022e1:	6a 00                	push   $0x0
  pushl $143
c01022e3:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022e8:	e9 ae fa ff ff       	jmp    c0101d9b <__alltraps>

c01022ed <vector144>:
.globl vector144
vector144:
  pushl $0
c01022ed:	6a 00                	push   $0x0
  pushl $144
c01022ef:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022f4:	e9 a2 fa ff ff       	jmp    c0101d9b <__alltraps>

c01022f9 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $145
c01022fb:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102300:	e9 96 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102305 <vector146>:
.globl vector146
vector146:
  pushl $0
c0102305:	6a 00                	push   $0x0
  pushl $146
c0102307:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c010230c:	e9 8a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102311 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102311:	6a 00                	push   $0x0
  pushl $147
c0102313:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102318:	e9 7e fa ff ff       	jmp    c0101d9b <__alltraps>

c010231d <vector148>:
.globl vector148
vector148:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $148
c010231f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102324:	e9 72 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102329 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102329:	6a 00                	push   $0x0
  pushl $149
c010232b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102330:	e9 66 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102335 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102335:	6a 00                	push   $0x0
  pushl $150
c0102337:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010233c:	e9 5a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102341 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $151
c0102343:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102348:	e9 4e fa ff ff       	jmp    c0101d9b <__alltraps>

c010234d <vector152>:
.globl vector152
vector152:
  pushl $0
c010234d:	6a 00                	push   $0x0
  pushl $152
c010234f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102354:	e9 42 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102359 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102359:	6a 00                	push   $0x0
  pushl $153
c010235b:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102360:	e9 36 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102365 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $154
c0102367:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010236c:	e9 2a fa ff ff       	jmp    c0101d9b <__alltraps>

c0102371 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102371:	6a 00                	push   $0x0
  pushl $155
c0102373:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102378:	e9 1e fa ff ff       	jmp    c0101d9b <__alltraps>

c010237d <vector156>:
.globl vector156
vector156:
  pushl $0
c010237d:	6a 00                	push   $0x0
  pushl $156
c010237f:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102384:	e9 12 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102389 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $157
c010238b:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102390:	e9 06 fa ff ff       	jmp    c0101d9b <__alltraps>

c0102395 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102395:	6a 00                	push   $0x0
  pushl $158
c0102397:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010239c:	e9 fa f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023a1 <vector159>:
.globl vector159
vector159:
  pushl $0
c01023a1:	6a 00                	push   $0x0
  pushl $159
c01023a3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c01023a8:	e9 ee f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023ad <vector160>:
.globl vector160
vector160:
  pushl $0
c01023ad:	6a 00                	push   $0x0
  pushl $160
c01023af:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01023b4:	e9 e2 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023b9 <vector161>:
.globl vector161
vector161:
  pushl $0
c01023b9:	6a 00                	push   $0x0
  pushl $161
c01023bb:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01023c0:	e9 d6 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023c5 <vector162>:
.globl vector162
vector162:
  pushl $0
c01023c5:	6a 00                	push   $0x0
  pushl $162
c01023c7:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01023cc:	e9 ca f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023d1 <vector163>:
.globl vector163
vector163:
  pushl $0
c01023d1:	6a 00                	push   $0x0
  pushl $163
c01023d3:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023d8:	e9 be f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023dd <vector164>:
.globl vector164
vector164:
  pushl $0
c01023dd:	6a 00                	push   $0x0
  pushl $164
c01023df:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023e4:	e9 b2 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023e9 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023e9:	6a 00                	push   $0x0
  pushl $165
c01023eb:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023f0:	e9 a6 f9 ff ff       	jmp    c0101d9b <__alltraps>

c01023f5 <vector166>:
.globl vector166
vector166:
  pushl $0
c01023f5:	6a 00                	push   $0x0
  pushl $166
c01023f7:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023fc:	e9 9a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102401 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102401:	6a 00                	push   $0x0
  pushl $167
c0102403:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102408:	e9 8e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010240d <vector168>:
.globl vector168
vector168:
  pushl $0
c010240d:	6a 00                	push   $0x0
  pushl $168
c010240f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102414:	e9 82 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102419 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102419:	6a 00                	push   $0x0
  pushl $169
c010241b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102420:	e9 76 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102425 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102425:	6a 00                	push   $0x0
  pushl $170
c0102427:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010242c:	e9 6a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102431 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102431:	6a 00                	push   $0x0
  pushl $171
c0102433:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102438:	e9 5e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010243d <vector172>:
.globl vector172
vector172:
  pushl $0
c010243d:	6a 00                	push   $0x0
  pushl $172
c010243f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102444:	e9 52 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102449 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102449:	6a 00                	push   $0x0
  pushl $173
c010244b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102450:	e9 46 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102455 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102455:	6a 00                	push   $0x0
  pushl $174
c0102457:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010245c:	e9 3a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102461 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102461:	6a 00                	push   $0x0
  pushl $175
c0102463:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102468:	e9 2e f9 ff ff       	jmp    c0101d9b <__alltraps>

c010246d <vector176>:
.globl vector176
vector176:
  pushl $0
c010246d:	6a 00                	push   $0x0
  pushl $176
c010246f:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102474:	e9 22 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102479 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102479:	6a 00                	push   $0x0
  pushl $177
c010247b:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102480:	e9 16 f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102485 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102485:	6a 00                	push   $0x0
  pushl $178
c0102487:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010248c:	e9 0a f9 ff ff       	jmp    c0101d9b <__alltraps>

c0102491 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102491:	6a 00                	push   $0x0
  pushl $179
c0102493:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102498:	e9 fe f8 ff ff       	jmp    c0101d9b <__alltraps>

c010249d <vector180>:
.globl vector180
vector180:
  pushl $0
c010249d:	6a 00                	push   $0x0
  pushl $180
c010249f:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c01024a4:	e9 f2 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024a9 <vector181>:
.globl vector181
vector181:
  pushl $0
c01024a9:	6a 00                	push   $0x0
  pushl $181
c01024ab:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01024b0:	e9 e6 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024b5 <vector182>:
.globl vector182
vector182:
  pushl $0
c01024b5:	6a 00                	push   $0x0
  pushl $182
c01024b7:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01024bc:	e9 da f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024c1 <vector183>:
.globl vector183
vector183:
  pushl $0
c01024c1:	6a 00                	push   $0x0
  pushl $183
c01024c3:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01024c8:	e9 ce f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024cd <vector184>:
.globl vector184
vector184:
  pushl $0
c01024cd:	6a 00                	push   $0x0
  pushl $184
c01024cf:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01024d4:	e9 c2 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024d9 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024d9:	6a 00                	push   $0x0
  pushl $185
c01024db:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024e0:	e9 b6 f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024e5 <vector186>:
.globl vector186
vector186:
  pushl $0
c01024e5:	6a 00                	push   $0x0
  pushl $186
c01024e7:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024ec:	e9 aa f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024f1 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024f1:	6a 00                	push   $0x0
  pushl $187
c01024f3:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024f8:	e9 9e f8 ff ff       	jmp    c0101d9b <__alltraps>

c01024fd <vector188>:
.globl vector188
vector188:
  pushl $0
c01024fd:	6a 00                	push   $0x0
  pushl $188
c01024ff:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102504:	e9 92 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102509 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102509:	6a 00                	push   $0x0
  pushl $189
c010250b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102510:	e9 86 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102515 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102515:	6a 00                	push   $0x0
  pushl $190
c0102517:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010251c:	e9 7a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102521 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102521:	6a 00                	push   $0x0
  pushl $191
c0102523:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102528:	e9 6e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010252d <vector192>:
.globl vector192
vector192:
  pushl $0
c010252d:	6a 00                	push   $0x0
  pushl $192
c010252f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102534:	e9 62 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102539 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102539:	6a 00                	push   $0x0
  pushl $193
c010253b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102540:	e9 56 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102545 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102545:	6a 00                	push   $0x0
  pushl $194
c0102547:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010254c:	e9 4a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102551 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102551:	6a 00                	push   $0x0
  pushl $195
c0102553:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102558:	e9 3e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010255d <vector196>:
.globl vector196
vector196:
  pushl $0
c010255d:	6a 00                	push   $0x0
  pushl $196
c010255f:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102564:	e9 32 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102569 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102569:	6a 00                	push   $0x0
  pushl $197
c010256b:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102570:	e9 26 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102575 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102575:	6a 00                	push   $0x0
  pushl $198
c0102577:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010257c:	e9 1a f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102581 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102581:	6a 00                	push   $0x0
  pushl $199
c0102583:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102588:	e9 0e f8 ff ff       	jmp    c0101d9b <__alltraps>

c010258d <vector200>:
.globl vector200
vector200:
  pushl $0
c010258d:	6a 00                	push   $0x0
  pushl $200
c010258f:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102594:	e9 02 f8 ff ff       	jmp    c0101d9b <__alltraps>

c0102599 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102599:	6a 00                	push   $0x0
  pushl $201
c010259b:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01025a0:	e9 f6 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025a5 <vector202>:
.globl vector202
vector202:
  pushl $0
c01025a5:	6a 00                	push   $0x0
  pushl $202
c01025a7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01025ac:	e9 ea f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025b1 <vector203>:
.globl vector203
vector203:
  pushl $0
c01025b1:	6a 00                	push   $0x0
  pushl $203
c01025b3:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01025b8:	e9 de f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025bd <vector204>:
.globl vector204
vector204:
  pushl $0
c01025bd:	6a 00                	push   $0x0
  pushl $204
c01025bf:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01025c4:	e9 d2 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025c9 <vector205>:
.globl vector205
vector205:
  pushl $0
c01025c9:	6a 00                	push   $0x0
  pushl $205
c01025cb:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01025d0:	e9 c6 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025d5 <vector206>:
.globl vector206
vector206:
  pushl $0
c01025d5:	6a 00                	push   $0x0
  pushl $206
c01025d7:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025dc:	e9 ba f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025e1 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025e1:	6a 00                	push   $0x0
  pushl $207
c01025e3:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025e8:	e9 ae f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025ed <vector208>:
.globl vector208
vector208:
  pushl $0
c01025ed:	6a 00                	push   $0x0
  pushl $208
c01025ef:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025f4:	e9 a2 f7 ff ff       	jmp    c0101d9b <__alltraps>

c01025f9 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025f9:	6a 00                	push   $0x0
  pushl $209
c01025fb:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102600:	e9 96 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102605 <vector210>:
.globl vector210
vector210:
  pushl $0
c0102605:	6a 00                	push   $0x0
  pushl $210
c0102607:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c010260c:	e9 8a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102611 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102611:	6a 00                	push   $0x0
  pushl $211
c0102613:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102618:	e9 7e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010261d <vector212>:
.globl vector212
vector212:
  pushl $0
c010261d:	6a 00                	push   $0x0
  pushl $212
c010261f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102624:	e9 72 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102629 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102629:	6a 00                	push   $0x0
  pushl $213
c010262b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102630:	e9 66 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102635 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102635:	6a 00                	push   $0x0
  pushl $214
c0102637:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010263c:	e9 5a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102641 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102641:	6a 00                	push   $0x0
  pushl $215
c0102643:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102648:	e9 4e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010264d <vector216>:
.globl vector216
vector216:
  pushl $0
c010264d:	6a 00                	push   $0x0
  pushl $216
c010264f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102654:	e9 42 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102659 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102659:	6a 00                	push   $0x0
  pushl $217
c010265b:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102660:	e9 36 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102665 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102665:	6a 00                	push   $0x0
  pushl $218
c0102667:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010266c:	e9 2a f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102671 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102671:	6a 00                	push   $0x0
  pushl $219
c0102673:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102678:	e9 1e f7 ff ff       	jmp    c0101d9b <__alltraps>

c010267d <vector220>:
.globl vector220
vector220:
  pushl $0
c010267d:	6a 00                	push   $0x0
  pushl $220
c010267f:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102684:	e9 12 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102689 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102689:	6a 00                	push   $0x0
  pushl $221
c010268b:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102690:	e9 06 f7 ff ff       	jmp    c0101d9b <__alltraps>

c0102695 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102695:	6a 00                	push   $0x0
  pushl $222
c0102697:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010269c:	e9 fa f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026a1 <vector223>:
.globl vector223
vector223:
  pushl $0
c01026a1:	6a 00                	push   $0x0
  pushl $223
c01026a3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01026a8:	e9 ee f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026ad <vector224>:
.globl vector224
vector224:
  pushl $0
c01026ad:	6a 00                	push   $0x0
  pushl $224
c01026af:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01026b4:	e9 e2 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026b9 <vector225>:
.globl vector225
vector225:
  pushl $0
c01026b9:	6a 00                	push   $0x0
  pushl $225
c01026bb:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01026c0:	e9 d6 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026c5 <vector226>:
.globl vector226
vector226:
  pushl $0
c01026c5:	6a 00                	push   $0x0
  pushl $226
c01026c7:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01026cc:	e9 ca f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026d1 <vector227>:
.globl vector227
vector227:
  pushl $0
c01026d1:	6a 00                	push   $0x0
  pushl $227
c01026d3:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026d8:	e9 be f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026dd <vector228>:
.globl vector228
vector228:
  pushl $0
c01026dd:	6a 00                	push   $0x0
  pushl $228
c01026df:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026e4:	e9 b2 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026e9 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026e9:	6a 00                	push   $0x0
  pushl $229
c01026eb:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026f0:	e9 a6 f6 ff ff       	jmp    c0101d9b <__alltraps>

c01026f5 <vector230>:
.globl vector230
vector230:
  pushl $0
c01026f5:	6a 00                	push   $0x0
  pushl $230
c01026f7:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026fc:	e9 9a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102701 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102701:	6a 00                	push   $0x0
  pushl $231
c0102703:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0102708:	e9 8e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010270d <vector232>:
.globl vector232
vector232:
  pushl $0
c010270d:	6a 00                	push   $0x0
  pushl $232
c010270f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102714:	e9 82 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102719 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102719:	6a 00                	push   $0x0
  pushl $233
c010271b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102720:	e9 76 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102725 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102725:	6a 00                	push   $0x0
  pushl $234
c0102727:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010272c:	e9 6a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102731 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102731:	6a 00                	push   $0x0
  pushl $235
c0102733:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102738:	e9 5e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010273d <vector236>:
.globl vector236
vector236:
  pushl $0
c010273d:	6a 00                	push   $0x0
  pushl $236
c010273f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102744:	e9 52 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102749 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102749:	6a 00                	push   $0x0
  pushl $237
c010274b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102750:	e9 46 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102755 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102755:	6a 00                	push   $0x0
  pushl $238
c0102757:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010275c:	e9 3a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102761 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102761:	6a 00                	push   $0x0
  pushl $239
c0102763:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102768:	e9 2e f6 ff ff       	jmp    c0101d9b <__alltraps>

c010276d <vector240>:
.globl vector240
vector240:
  pushl $0
c010276d:	6a 00                	push   $0x0
  pushl $240
c010276f:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102774:	e9 22 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102779 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102779:	6a 00                	push   $0x0
  pushl $241
c010277b:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102780:	e9 16 f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102785 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102785:	6a 00                	push   $0x0
  pushl $242
c0102787:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010278c:	e9 0a f6 ff ff       	jmp    c0101d9b <__alltraps>

c0102791 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102791:	6a 00                	push   $0x0
  pushl $243
c0102793:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102798:	e9 fe f5 ff ff       	jmp    c0101d9b <__alltraps>

c010279d <vector244>:
.globl vector244
vector244:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $244
c010279f:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01027a4:	e9 f2 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027a9 <vector245>:
.globl vector245
vector245:
  pushl $0
c01027a9:	6a 00                	push   $0x0
  pushl $245
c01027ab:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01027b0:	e9 e6 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027b5 <vector246>:
.globl vector246
vector246:
  pushl $0
c01027b5:	6a 00                	push   $0x0
  pushl $246
c01027b7:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01027bc:	e9 da f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027c1 <vector247>:
.globl vector247
vector247:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $247
c01027c3:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01027c8:	e9 ce f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027cd <vector248>:
.globl vector248
vector248:
  pushl $0
c01027cd:	6a 00                	push   $0x0
  pushl $248
c01027cf:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01027d4:	e9 c2 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027d9 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027d9:	6a 00                	push   $0x0
  pushl $249
c01027db:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027e0:	e9 b6 f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027e5 <vector250>:
.globl vector250
vector250:
  pushl $0
c01027e5:	6a 00                	push   $0x0
  pushl $250
c01027e7:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027ec:	e9 aa f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027f1 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027f1:	6a 00                	push   $0x0
  pushl $251
c01027f3:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027f8:	e9 9e f5 ff ff       	jmp    c0101d9b <__alltraps>

c01027fd <vector252>:
.globl vector252
vector252:
  pushl $0
c01027fd:	6a 00                	push   $0x0
  pushl $252
c01027ff:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c0102804:	e9 92 f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102809 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102809:	6a 00                	push   $0x0
  pushl $253
c010280b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102810:	e9 86 f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102815 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102815:	6a 00                	push   $0x0
  pushl $254
c0102817:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010281c:	e9 7a f5 ff ff       	jmp    c0101d9b <__alltraps>

c0102821 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102821:	6a 00                	push   $0x0
  pushl $255
c0102823:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102828:	e9 6e f5 ff ff       	jmp    c0101d9b <__alltraps>

c010282d <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010282d:	55                   	push   %ebp
c010282e:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102830:	8b 55 08             	mov    0x8(%ebp),%edx
c0102833:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0102838:	29 c2                	sub    %eax,%edx
c010283a:	89 d0                	mov    %edx,%eax
c010283c:	c1 f8 02             	sar    $0x2,%eax
c010283f:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102845:	5d                   	pop    %ebp
c0102846:	c3                   	ret    

c0102847 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102847:	55                   	push   %ebp
c0102848:	89 e5                	mov    %esp,%ebp
c010284a:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010284d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102850:	89 04 24             	mov    %eax,(%esp)
c0102853:	e8 d5 ff ff ff       	call   c010282d <page2ppn>
c0102858:	c1 e0 0c             	shl    $0xc,%eax
}
c010285b:	c9                   	leave  
c010285c:	c3                   	ret    

c010285d <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010285d:	55                   	push   %ebp
c010285e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102860:	8b 45 08             	mov    0x8(%ebp),%eax
c0102863:	8b 00                	mov    (%eax),%eax
}
c0102865:	5d                   	pop    %ebp
c0102866:	c3                   	ret    

c0102867 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102867:	55                   	push   %ebp
c0102868:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010286a:	8b 45 08             	mov    0x8(%ebp),%eax
c010286d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102870:	89 10                	mov    %edx,(%eax)
}
c0102872:	5d                   	pop    %ebp
c0102873:	c3                   	ret    

c0102874 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102874:	55                   	push   %ebp
c0102875:	89 e5                	mov    %esp,%ebp
c0102877:	83 ec 10             	sub    $0x10,%esp
c010287a:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102881:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102884:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102887:	89 50 04             	mov    %edx,0x4(%eax)
c010288a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010288d:	8b 50 04             	mov    0x4(%eax),%edx
c0102890:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102893:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102895:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010289c:	00 00 00 
}
c010289f:	c9                   	leave  
c01028a0:	c3                   	ret    

c01028a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01028a1:	55                   	push   %ebp
c01028a2:	89 e5                	mov    %esp,%ebp
c01028a4:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c01028a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01028ab:	75 24                	jne    c01028d1 <default_init_memmap+0x30>
c01028ad:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c01028b4:	c0 
c01028b5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01028bc:	c0 
c01028bd:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01028c4:	00 
c01028c5:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01028cc:	e8 f5 e3 ff ff       	call   c0100cc6 <__panic>
    struct Page *p = base;
c01028d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01028d7:	e9 de 00 00 00       	jmp    c01029ba <default_init_memmap+0x119>
        assert(PageReserved(p));
c01028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028df:	83 c0 04             	add    $0x4,%eax
c01028e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01028e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01028ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01028ef:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01028f2:	0f a3 10             	bt     %edx,(%eax)
c01028f5:	19 c0                	sbb    %eax,%eax
c01028f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01028fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01028fe:	0f 95 c0             	setne  %al
c0102901:	0f b6 c0             	movzbl %al,%eax
c0102904:	85 c0                	test   %eax,%eax
c0102906:	75 24                	jne    c010292c <default_init_memmap+0x8b>
c0102908:	c7 44 24 0c 21 66 10 	movl   $0xc0106621,0xc(%esp)
c010290f:	c0 
c0102910:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102917:	c0 
c0102918:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010291f:	00 
c0102920:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102927:	e8 9a e3 ff ff       	call   c0100cc6 <__panic>
        p->flags = p->property = 0;
c010292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010292f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102936:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102939:	8b 50 08             	mov    0x8(%eax),%edx
c010293c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010293f:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102942:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102949:	00 
c010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010294d:	89 04 24             	mov    %eax,(%esp)
c0102950:	e8 12 ff ff ff       	call   c0102867 <set_page_ref>
        SetPageProperty(p);
c0102955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102958:	83 c0 04             	add    $0x4,%eax
c010295b:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102962:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102965:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102968:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010296b:	0f ab 10             	bts    %edx,(%eax)

        list_add_before(&free_list, &(p->page_link));
c010296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102971:	83 c0 0c             	add    $0xc,%eax
c0102974:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c010297b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010297e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102981:	8b 00                	mov    (%eax),%eax
c0102983:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102986:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102989:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010298c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010298f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102995:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102998:	89 10                	mov    %edx,(%eax)
c010299a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010299d:	8b 10                	mov    (%eax),%edx
c010299f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01029a2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01029a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029a8:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01029ab:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01029ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029b1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029b4:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c01029b6:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01029ba:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029bd:	89 d0                	mov    %edx,%eax
c01029bf:	c1 e0 02             	shl    $0x2,%eax
c01029c2:	01 d0                	add    %edx,%eax
c01029c4:	c1 e0 02             	shl    $0x2,%eax
c01029c7:	89 c2                	mov    %eax,%edx
c01029c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01029cc:	01 d0                	add    %edx,%eax
c01029ce:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01029d1:	0f 85 05 ff ff ff    	jne    c01028dc <default_init_memmap+0x3b>
        set_page_ref(p, 0);
        SetPageProperty(p);

        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c01029d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01029da:	8b 55 0c             	mov    0xc(%ebp),%edx
c01029dd:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c01029e0:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c01029e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01029e9:	01 d0                	add    %edx,%eax
c01029eb:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c01029f0:	c9                   	leave  
c01029f1:	c3                   	ret    

c01029f2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01029f2:	55                   	push   %ebp
c01029f3:	89 e5                	mov    %esp,%ebp
c01029f5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01029f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029fc:	75 24                	jne    c0102a22 <default_alloc_pages+0x30>
c01029fe:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c0102a05:	c0 
c0102a06:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102a0d:	c0 
c0102a0e:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102a15:	00 
c0102a16:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102a1d:	e8 a4 e2 ff ff       	call   c0100cc6 <__panic>
    if (n > nr_free) {
c0102a22:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a27:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a2a:	73 0a                	jae    c0102a36 <default_alloc_pages+0x44>
        return NULL;
c0102a2c:	b8 00 00 00 00       	mov    $0x0,%eax
c0102a31:	e9 3e 01 00 00       	jmp    c0102b74 <default_alloc_pages+0x182>
    }

    list_entry_t *le, *nextle;
    le = &free_list;
c0102a36:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)

    struct Page *p, *pp;
    while ((le = list_next(le)) != &free_list){
c0102a3d:	e9 11 01 00 00       	jmp    c0102b53 <default_alloc_pages+0x161>
    	p =  le2page(le, page_link);
c0102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a45:	83 e8 0c             	sub    $0xc,%eax
c0102a48:	89 45 ec             	mov    %eax,-0x14(%ebp)

    	if (p -> property>= n) {
c0102a4b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102a4e:	8b 40 08             	mov    0x8(%eax),%eax
c0102a51:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a54:	0f 82 f9 00 00 00    	jb     c0102b53 <default_alloc_pages+0x161>
    			int i= 0;
c0102a5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    			for (i=0; i < n; i++){
c0102a61:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102a68:	eb 7c                	jmp    c0102ae6 <default_alloc_pages+0xf4>
c0102a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a70:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a73:	8b 40 04             	mov    0x4(%eax),%eax
    				nextle = list_next(le);
c0102a76:	89 45 e8             	mov    %eax,-0x18(%ebp)
    				pp = le2page(le, page_link);
c0102a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7c:	83 e8 0c             	sub    $0xc,%eax
c0102a7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    				SetPageReserved(pp);
c0102a82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a85:	83 c0 04             	add    $0x4,%eax
c0102a88:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102a8f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a92:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a98:	0f ab 10             	bts    %edx,(%eax)
    				ClearPageProperty(pp);
c0102a9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102a9e:	83 c0 04             	add    $0x4,%eax
c0102aa1:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102aa8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102aab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102aae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102ab1:	0f b3 10             	btr    %edx,(%eax)
c0102ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ab7:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102aba:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102abd:	8b 40 04             	mov    0x4(%eax),%eax
c0102ac0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102ac3:	8b 12                	mov    (%edx),%edx
c0102ac5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102ac8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102acb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102ace:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102ad1:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102ad4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102ad7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102ada:	89 10                	mov    %edx,(%eax)
    				list_del(le);
    				le = nextle;
c0102adc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != &free_list){
    	p =  le2page(le, page_link);

    	if (p -> property>= n) {
    			int i= 0;
    			for (i=0; i < n; i++){
c0102ae2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ae9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102aec:	0f 82 78 ff ff ff    	jb     c0102a6a <default_alloc_pages+0x78>
    				SetPageReserved(pp);
    				ClearPageProperty(pp);
    				list_del(le);
    				le = nextle;
    			}
    			if (p->property > n){
c0102af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102af5:	8b 40 08             	mov    0x8(%eax),%eax
c0102af8:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102afb:	76 12                	jbe    c0102b0f <default_alloc_pages+0x11d>
    				(le2page(le, page_link))->property = p->property - n;
c0102afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b00:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b06:	8b 40 08             	mov    0x8(%eax),%eax
c0102b09:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b0c:	89 42 08             	mov    %eax,0x8(%edx)
    			}
    			ClearPageProperty(p);
c0102b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b12:	83 c0 04             	add    $0x4,%eax
c0102b15:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102b1c:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102b1f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b22:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102b25:	0f b3 10             	btr    %edx,(%eax)
    			SetPageReserved(p);
c0102b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b2b:	83 c0 04             	add    $0x4,%eax
c0102b2e:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102b35:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b38:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b3b:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b3e:	0f ab 10             	bts    %edx,(%eax)
    			nr_free -= n;
c0102b41:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102b46:	2b 45 08             	sub    0x8(%ebp),%eax
c0102b49:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    			return p;
c0102b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b51:	eb 21                	jmp    c0102b74 <default_alloc_pages+0x182>
c0102b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b56:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b59:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102b5c:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le, *nextle;
    le = &free_list;

    struct Page *p, *pp;
    while ((le = list_next(le)) != &free_list){
c0102b5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102b62:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102b69:	0f 85 d3 fe ff ff    	jne    c0102a42 <default_alloc_pages+0x50>
    			SetPageReserved(p);
    			nr_free -= n;
    			return p;
    			}
    	}
    return NULL;
c0102b6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b74:	c9                   	leave  
c0102b75:	c3                   	ret    

c0102b76 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102b76:	55                   	push   %ebp
c0102b77:	89 e5                	mov    %esp,%ebp
c0102b79:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102b7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102b80:	75 24                	jne    c0102ba6 <default_free_pages+0x30>
c0102b82:	c7 44 24 0c f0 65 10 	movl   $0xc01065f0,0xc(%esp)
c0102b89:	c0 
c0102b8a:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102b91:	c0 
c0102b92:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
c0102b99:	00 
c0102b9a:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102ba1:	e8 20 e1 ff ff       	call   c0100cc6 <__panic>

    list_entry_t *le = &free_list;
c0102ba6:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    list_entry_t *bef;

    struct Page* p;
    while ((le = list_next(le)) != &free_list){
c0102bad:	eb 13                	jmp    c0102bc2 <default_free_pages+0x4c>
    	p = le2page(le, page_link);
c0102baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb2:	83 e8 0c             	sub    $0xc,%eax
c0102bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	if (p > base) break;
c0102bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bbb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bbe:	76 02                	jbe    c0102bc2 <default_free_pages+0x4c>
c0102bc0:	eb 18                	jmp    c0102bda <default_free_pages+0x64>
c0102bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bc5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102bc8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bcb:	8b 40 04             	mov    0x4(%eax),%eax

    list_entry_t *le = &free_list;
    list_entry_t *bef;

    struct Page* p;
    while ((le = list_next(le)) != &free_list){
c0102bce:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102bd1:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102bd8:	75 d5                	jne    c0102baf <default_free_pages+0x39>
    	p = le2page(le, page_link);
    	if (p > base) break;
    }

    for (p = base; p< base+n; p++){
c0102bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102be0:	eb 4b                	jmp    c0102c2d <default_free_pages+0xb7>
    	list_add_before(le, &(p->page_link));
c0102be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102be5:	8d 50 0c             	lea    0xc(%eax),%edx
c0102be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102beb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0102bee:	89 55 e0             	mov    %edx,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102bf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102bf4:	8b 00                	mov    (%eax),%eax
c0102bf6:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102bf9:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102bfc:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102c02:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102c05:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c08:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c0b:	89 10                	mov    %edx,(%eax)
c0102c0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102c10:	8b 10                	mov    (%eax),%edx
c0102c12:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102c15:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102c18:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c1b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c1e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102c21:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c24:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102c27:	89 10                	mov    %edx,(%eax)
    while ((le = list_next(le)) != &free_list){
    	p = le2page(le, page_link);
    	if (p > base) break;
    }

    for (p = base; p< base+n; p++){
c0102c29:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c30:	89 d0                	mov    %edx,%eax
c0102c32:	c1 e0 02             	shl    $0x2,%eax
c0102c35:	01 d0                	add    %edx,%eax
c0102c37:	c1 e0 02             	shl    $0x2,%eax
c0102c3a:	89 c2                	mov    %eax,%edx
c0102c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c3f:	01 d0                	add    %edx,%eax
c0102c41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102c44:	77 9c                	ja     c0102be2 <default_free_pages+0x6c>
    	list_add_before(le, &(p->page_link));
    }

    base ->flags = 0;
c0102c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102c50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c57:	00 
c0102c58:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c5b:	89 04 24             	mov    %eax,(%esp)
c0102c5e:	e8 04 fc ff ff       	call   c0102867 <set_page_ref>
    ClearPageReserved(base);		//
c0102c63:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c66:	83 c0 04             	add    $0x4,%eax
c0102c69:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c0102c70:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c73:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102c76:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102c79:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c7f:	83 c0 04             	add    $0x4,%eax
c0102c82:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102c89:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c8c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102c8f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102c92:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c98:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c9b:	89 50 08             	mov    %edx,0x8(%eax)

    p = le2page(le, page_link);
c0102c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca1:	83 e8 0c             	sub    $0xc,%eax
c0102ca4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (base + n == p){
c0102ca7:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102caa:	89 d0                	mov    %edx,%eax
c0102cac:	c1 e0 02             	shl    $0x2,%eax
c0102caf:	01 d0                	add    %edx,%eax
c0102cb1:	c1 e0 02             	shl    $0x2,%eax
c0102cb4:	89 c2                	mov    %eax,%edx
c0102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cb9:	01 d0                	add    %edx,%eax
c0102cbb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102cbe:	75 1e                	jne    c0102cde <default_free_pages+0x168>
    	base->property += p->property;
c0102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cc3:	8b 50 08             	mov    0x8(%eax),%edx
c0102cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102cc9:	8b 40 08             	mov    0x8(%eax),%eax
c0102ccc:	01 c2                	add    %eax,%edx
c0102cce:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd1:	89 50 08             	mov    %edx,0x8(%eax)
    	p->property = 0;
c0102cd4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102cd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }

    bef = list_prev(&(base->page_link));
c0102cde:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce1:	83 c0 0c             	add    $0xc,%eax
c0102ce4:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102ce7:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cea:	8b 00                	mov    (%eax),%eax
c0102cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    p = le2page(bef, page_link);
c0102cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cf2:	83 e8 0c             	sub    $0xc,%eax
c0102cf5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (bef != &free_list && p == base-1){
c0102cf8:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102cff:	74 57                	je     c0102d58 <default_free_pages+0x1e2>
c0102d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d04:	83 e8 14             	sub    $0x14,%eax
c0102d07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102d0a:	75 4c                	jne    c0102d58 <default_free_pages+0x1e2>
    		while (bef != &free_list){
c0102d0c:	eb 41                	jmp    c0102d4f <default_free_pages+0x1d9>
    			if (p -> property != 0){
c0102d0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d11:	8b 40 08             	mov    0x8(%eax),%eax
c0102d14:	85 c0                	test   %eax,%eax
c0102d16:	74 20                	je     c0102d38 <default_free_pages+0x1c2>
    				p->property += base->property;
c0102d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d1b:	8b 50 08             	mov    0x8(%eax),%edx
c0102d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d21:	8b 40 08             	mov    0x8(%eax),%eax
c0102d24:	01 c2                	add    %eax,%edx
c0102d26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d29:	89 50 08             	mov    %edx,0x8(%eax)
    				base->property = 0;
c0102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d2f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    				break;
c0102d36:	eb 20                	jmp    c0102d58 <default_free_pages+0x1e2>
c0102d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d3b:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102d3e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d41:	8b 00                	mov    (%eax),%eax
    			}
    			bef = list_prev(bef);
c0102d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    			p = le2page(bef, page_link);
c0102d46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d49:	83 e8 0c             	sub    $0xc,%eax
c0102d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    }

    bef = list_prev(&(base->page_link));
    p = le2page(bef, page_link);
    if (bef != &free_list && p == base-1){
    		while (bef != &free_list){
c0102d4f:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d56:	75 b6                	jne    c0102d0e <default_free_pages+0x198>
    			}
    			bef = list_prev(bef);
    			p = le2page(bef, page_link);
    		}
    }
    nr_free += n;
c0102d58:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102d61:	01 d0                	add    %edx,%eax
c0102d63:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return;
c0102d68:	90                   	nop
}
c0102d69:	c9                   	leave  
c0102d6a:	c3                   	ret    

c0102d6b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102d6b:	55                   	push   %ebp
c0102d6c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102d6e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102d73:	5d                   	pop    %ebp
c0102d74:	c3                   	ret    

c0102d75 <basic_check>:

static void
basic_check(void) {
c0102d75:	55                   	push   %ebp
c0102d76:	89 e5                	mov    %esp,%ebp
c0102d78:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102d7b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102d88:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102d8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102d95:	e8 85 0e 00 00       	call   c0103c1f <alloc_pages>
c0102d9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102d9d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102da1:	75 24                	jne    c0102dc7 <basic_check+0x52>
c0102da3:	c7 44 24 0c 31 66 10 	movl   $0xc0106631,0xc(%esp)
c0102daa:	c0 
c0102dab:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102db2:	c0 
c0102db3:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102dba:	00 
c0102dbb:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102dc2:	e8 ff de ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102dc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102dce:	e8 4c 0e 00 00       	call   c0103c1f <alloc_pages>
c0102dd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102dd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102dda:	75 24                	jne    c0102e00 <basic_check+0x8b>
c0102ddc:	c7 44 24 0c 4d 66 10 	movl   $0xc010664d,0xc(%esp)
c0102de3:	c0 
c0102de4:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102deb:	c0 
c0102dec:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102df3:	00 
c0102df4:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102dfb:	e8 c6 de ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102e00:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e07:	e8 13 0e 00 00       	call   c0103c1f <alloc_pages>
c0102e0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e0f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102e13:	75 24                	jne    c0102e39 <basic_check+0xc4>
c0102e15:	c7 44 24 0c 69 66 10 	movl   $0xc0106669,0xc(%esp)
c0102e1c:	c0 
c0102e1d:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102e24:	c0 
c0102e25:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102e2c:	00 
c0102e2d:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102e34:	e8 8d de ff ff       	call   c0100cc6 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102e39:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e3f:	74 10                	je     c0102e51 <basic_check+0xdc>
c0102e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e44:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e47:	74 08                	je     c0102e51 <basic_check+0xdc>
c0102e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102e4f:	75 24                	jne    c0102e75 <basic_check+0x100>
c0102e51:	c7 44 24 0c 88 66 10 	movl   $0xc0106688,0xc(%esp)
c0102e58:	c0 
c0102e59:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102e60:	c0 
c0102e61:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0102e68:	00 
c0102e69:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102e70:	e8 51 de ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102e75:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102e78:	89 04 24             	mov    %eax,(%esp)
c0102e7b:	e8 dd f9 ff ff       	call   c010285d <page_ref>
c0102e80:	85 c0                	test   %eax,%eax
c0102e82:	75 1e                	jne    c0102ea2 <basic_check+0x12d>
c0102e84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e87:	89 04 24             	mov    %eax,(%esp)
c0102e8a:	e8 ce f9 ff ff       	call   c010285d <page_ref>
c0102e8f:	85 c0                	test   %eax,%eax
c0102e91:	75 0f                	jne    c0102ea2 <basic_check+0x12d>
c0102e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e96:	89 04 24             	mov    %eax,(%esp)
c0102e99:	e8 bf f9 ff ff       	call   c010285d <page_ref>
c0102e9e:	85 c0                	test   %eax,%eax
c0102ea0:	74 24                	je     c0102ec6 <basic_check+0x151>
c0102ea2:	c7 44 24 0c ac 66 10 	movl   $0xc01066ac,0xc(%esp)
c0102ea9:	c0 
c0102eaa:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102eb1:	c0 
c0102eb2:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102eb9:	00 
c0102eba:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102ec1:	e8 00 de ff ff       	call   c0100cc6 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102ec6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ec9:	89 04 24             	mov    %eax,(%esp)
c0102ecc:	e8 76 f9 ff ff       	call   c0102847 <page2pa>
c0102ed1:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102ed7:	c1 e2 0c             	shl    $0xc,%edx
c0102eda:	39 d0                	cmp    %edx,%eax
c0102edc:	72 24                	jb     c0102f02 <basic_check+0x18d>
c0102ede:	c7 44 24 0c e8 66 10 	movl   $0xc01066e8,0xc(%esp)
c0102ee5:	c0 
c0102ee6:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102eed:	c0 
c0102eee:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102ef5:	00 
c0102ef6:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102efd:	e8 c4 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102f02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f05:	89 04 24             	mov    %eax,(%esp)
c0102f08:	e8 3a f9 ff ff       	call   c0102847 <page2pa>
c0102f0d:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f13:	c1 e2 0c             	shl    $0xc,%edx
c0102f16:	39 d0                	cmp    %edx,%eax
c0102f18:	72 24                	jb     c0102f3e <basic_check+0x1c9>
c0102f1a:	c7 44 24 0c 05 67 10 	movl   $0xc0106705,0xc(%esp)
c0102f21:	c0 
c0102f22:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102f29:	c0 
c0102f2a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0102f31:	00 
c0102f32:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102f39:	e8 88 dd ff ff       	call   c0100cc6 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f41:	89 04 24             	mov    %eax,(%esp)
c0102f44:	e8 fe f8 ff ff       	call   c0102847 <page2pa>
c0102f49:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f4f:	c1 e2 0c             	shl    $0xc,%edx
c0102f52:	39 d0                	cmp    %edx,%eax
c0102f54:	72 24                	jb     c0102f7a <basic_check+0x205>
c0102f56:	c7 44 24 0c 22 67 10 	movl   $0xc0106722,0xc(%esp)
c0102f5d:	c0 
c0102f5e:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102f65:	c0 
c0102f66:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0102f6d:	00 
c0102f6e:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102f75:	e8 4c dd ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0102f7a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0102f7f:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0102f85:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f88:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102f8b:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102f92:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f95:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102f98:	89 50 04             	mov    %edx,0x4(%eax)
c0102f9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f9e:	8b 50 04             	mov    0x4(%eax),%edx
c0102fa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102fa4:	89 10                	mov    %edx,(%eax)
c0102fa6:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102fad:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102fb0:	8b 40 04             	mov    0x4(%eax),%eax
c0102fb3:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fb6:	0f 94 c0             	sete   %al
c0102fb9:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102fbc:	85 c0                	test   %eax,%eax
c0102fbe:	75 24                	jne    c0102fe4 <basic_check+0x26f>
c0102fc0:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c0102fc7:	c0 
c0102fc8:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0102fcf:	c0 
c0102fd0:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0102fd7:	00 
c0102fd8:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0102fdf:	e8 e2 dc ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c0102fe4:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102fe9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102fec:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102ff3:	00 00 00 

    assert(alloc_page() == NULL);
c0102ff6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ffd:	e8 1d 0c 00 00       	call   c0103c1f <alloc_pages>
c0103002:	85 c0                	test   %eax,%eax
c0103004:	74 24                	je     c010302a <basic_check+0x2b5>
c0103006:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c010300d:	c0 
c010300e:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103015:	c0 
c0103016:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010301d:	00 
c010301e:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103025:	e8 9c dc ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c010302a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103031:	00 
c0103032:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103035:	89 04 24             	mov    %eax,(%esp)
c0103038:	e8 1a 0c 00 00       	call   c0103c57 <free_pages>
    free_page(p1);
c010303d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103044:	00 
c0103045:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103048:	89 04 24             	mov    %eax,(%esp)
c010304b:	e8 07 0c 00 00       	call   c0103c57 <free_pages>
    free_page(p2);
c0103050:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103057:	00 
c0103058:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010305b:	89 04 24             	mov    %eax,(%esp)
c010305e:	e8 f4 0b 00 00       	call   c0103c57 <free_pages>
    assert(nr_free == 3);
c0103063:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103068:	83 f8 03             	cmp    $0x3,%eax
c010306b:	74 24                	je     c0103091 <basic_check+0x31c>
c010306d:	c7 44 24 0c 6b 67 10 	movl   $0xc010676b,0xc(%esp)
c0103074:	c0 
c0103075:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010307c:	c0 
c010307d:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103084:	00 
c0103085:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010308c:	e8 35 dc ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103091:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103098:	e8 82 0b 00 00       	call   c0103c1f <alloc_pages>
c010309d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01030a4:	75 24                	jne    c01030ca <basic_check+0x355>
c01030a6:	c7 44 24 0c 31 66 10 	movl   $0xc0106631,0xc(%esp)
c01030ad:	c0 
c01030ae:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01030b5:	c0 
c01030b6:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c01030bd:	00 
c01030be:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01030c5:	e8 fc db ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030d1:	e8 49 0b 00 00       	call   c0103c1f <alloc_pages>
c01030d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01030dd:	75 24                	jne    c0103103 <basic_check+0x38e>
c01030df:	c7 44 24 0c 4d 66 10 	movl   $0xc010664d,0xc(%esp)
c01030e6:	c0 
c01030e7:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01030ee:	c0 
c01030ef:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01030f6:	00 
c01030f7:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01030fe:	e8 c3 db ff ff       	call   c0100cc6 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103103:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010310a:	e8 10 0b 00 00       	call   c0103c1f <alloc_pages>
c010310f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103116:	75 24                	jne    c010313c <basic_check+0x3c7>
c0103118:	c7 44 24 0c 69 66 10 	movl   $0xc0106669,0xc(%esp)
c010311f:	c0 
c0103120:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103127:	c0 
c0103128:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c010312f:	00 
c0103130:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103137:	e8 8a db ff ff       	call   c0100cc6 <__panic>

    assert(alloc_page() == NULL);
c010313c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103143:	e8 d7 0a 00 00       	call   c0103c1f <alloc_pages>
c0103148:	85 c0                	test   %eax,%eax
c010314a:	74 24                	je     c0103170 <basic_check+0x3fb>
c010314c:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103153:	c0 
c0103154:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010315b:	c0 
c010315c:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0103163:	00 
c0103164:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010316b:	e8 56 db ff ff       	call   c0100cc6 <__panic>

    free_page(p0);
c0103170:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103177:	00 
c0103178:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010317b:	89 04 24             	mov    %eax,(%esp)
c010317e:	e8 d4 0a 00 00       	call   c0103c57 <free_pages>
c0103183:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010318a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010318d:	8b 40 04             	mov    0x4(%eax),%eax
c0103190:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103193:	0f 94 c0             	sete   %al
c0103196:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103199:	85 c0                	test   %eax,%eax
c010319b:	74 24                	je     c01031c1 <basic_check+0x44c>
c010319d:	c7 44 24 0c 78 67 10 	movl   $0xc0106778,0xc(%esp)
c01031a4:	c0 
c01031a5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01031ac:	c0 
c01031ad:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01031b4:	00 
c01031b5:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01031bc:	e8 05 db ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01031c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031c8:	e8 52 0a 00 00       	call   c0103c1f <alloc_pages>
c01031cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01031d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01031d3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01031d6:	74 24                	je     c01031fc <basic_check+0x487>
c01031d8:	c7 44 24 0c 90 67 10 	movl   $0xc0106790,0xc(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01031e7:	c0 
c01031e8:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01031ef:	00 
c01031f0:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01031f7:	e8 ca da ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01031fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103203:	e8 17 0a 00 00       	call   c0103c1f <alloc_pages>
c0103208:	85 c0                	test   %eax,%eax
c010320a:	74 24                	je     c0103230 <basic_check+0x4bb>
c010320c:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103213:	c0 
c0103214:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010321b:	c0 
c010321c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103223:	00 
c0103224:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010322b:	e8 96 da ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0103230:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103235:	85 c0                	test   %eax,%eax
c0103237:	74 24                	je     c010325d <basic_check+0x4e8>
c0103239:	c7 44 24 0c a9 67 10 	movl   $0xc01067a9,0xc(%esp)
c0103240:	c0 
c0103241:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103248:	c0 
c0103249:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103250:	00 
c0103251:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103258:	e8 69 da ff ff       	call   c0100cc6 <__panic>
    free_list = free_list_store;
c010325d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103260:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103263:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103268:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010326e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103271:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103276:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010327d:	00 
c010327e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103281:	89 04 24             	mov    %eax,(%esp)
c0103284:	e8 ce 09 00 00       	call   c0103c57 <free_pages>
    free_page(p1);
c0103289:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103290:	00 
c0103291:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103294:	89 04 24             	mov    %eax,(%esp)
c0103297:	e8 bb 09 00 00       	call   c0103c57 <free_pages>
    free_page(p2);
c010329c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01032a3:	00 
c01032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032a7:	89 04 24             	mov    %eax,(%esp)
c01032aa:	e8 a8 09 00 00       	call   c0103c57 <free_pages>
}
c01032af:	c9                   	leave  
c01032b0:	c3                   	ret    

c01032b1 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01032b1:	55                   	push   %ebp
c01032b2:	89 e5                	mov    %esp,%ebp
c01032b4:	53                   	push   %ebx
c01032b5:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01032bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01032c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01032c9:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01032d0:	eb 6b                	jmp    c010333d <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01032d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032d5:	83 e8 0c             	sub    $0xc,%eax
c01032d8:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01032db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032de:	83 c0 04             	add    $0x4,%eax
c01032e1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01032e8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032eb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01032ee:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01032f1:	0f a3 10             	bt     %edx,(%eax)
c01032f4:	19 c0                	sbb    %eax,%eax
c01032f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01032f9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01032fd:	0f 95 c0             	setne  %al
c0103300:	0f b6 c0             	movzbl %al,%eax
c0103303:	85 c0                	test   %eax,%eax
c0103305:	75 24                	jne    c010332b <default_check+0x7a>
c0103307:	c7 44 24 0c b6 67 10 	movl   $0xc01067b6,0xc(%esp)
c010330e:	c0 
c010330f:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103316:	c0 
c0103317:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010331e:	00 
c010331f:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103326:	e8 9b d9 ff ff       	call   c0100cc6 <__panic>
        count ++, total += p->property;
c010332b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010332f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103332:	8b 50 08             	mov    0x8(%eax),%edx
c0103335:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103338:	01 d0                	add    %edx,%eax
c010333a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010333d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103340:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103343:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103346:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103349:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010334c:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c0103353:	0f 85 79 ff ff ff    	jne    c01032d2 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103359:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010335c:	e8 28 09 00 00       	call   c0103c89 <nr_free_pages>
c0103361:	39 c3                	cmp    %eax,%ebx
c0103363:	74 24                	je     c0103389 <default_check+0xd8>
c0103365:	c7 44 24 0c c6 67 10 	movl   $0xc01067c6,0xc(%esp)
c010336c:	c0 
c010336d:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103374:	c0 
c0103375:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010337c:	00 
c010337d:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103384:	e8 3d d9 ff ff       	call   c0100cc6 <__panic>

    basic_check();
c0103389:	e8 e7 f9 ff ff       	call   c0102d75 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010338e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103395:	e8 85 08 00 00       	call   c0103c1f <alloc_pages>
c010339a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010339d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01033a1:	75 24                	jne    c01033c7 <default_check+0x116>
c01033a3:	c7 44 24 0c df 67 10 	movl   $0xc01067df,0xc(%esp)
c01033aa:	c0 
c01033ab:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01033b2:	c0 
c01033b3:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01033ba:	00 
c01033bb:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01033c2:	e8 ff d8 ff ff       	call   c0100cc6 <__panic>
    assert(!PageProperty(p0));
c01033c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033ca:	83 c0 04             	add    $0x4,%eax
c01033cd:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01033d4:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033d7:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01033da:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01033dd:	0f a3 10             	bt     %edx,(%eax)
c01033e0:	19 c0                	sbb    %eax,%eax
c01033e2:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01033e5:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01033e9:	0f 95 c0             	setne  %al
c01033ec:	0f b6 c0             	movzbl %al,%eax
c01033ef:	85 c0                	test   %eax,%eax
c01033f1:	74 24                	je     c0103417 <default_check+0x166>
c01033f3:	c7 44 24 0c ea 67 10 	movl   $0xc01067ea,0xc(%esp)
c01033fa:	c0 
c01033fb:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103402:	c0 
c0103403:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c010340a:	00 
c010340b:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103412:	e8 af d8 ff ff       	call   c0100cc6 <__panic>

    list_entry_t free_list_store = free_list;
c0103417:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010341c:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103422:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103425:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103428:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010342f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103432:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103435:	89 50 04             	mov    %edx,0x4(%eax)
c0103438:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010343b:	8b 50 04             	mov    0x4(%eax),%edx
c010343e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103441:	89 10                	mov    %edx,(%eax)
c0103443:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010344a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010344d:	8b 40 04             	mov    0x4(%eax),%eax
c0103450:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103453:	0f 94 c0             	sete   %al
c0103456:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103459:	85 c0                	test   %eax,%eax
c010345b:	75 24                	jne    c0103481 <default_check+0x1d0>
c010345d:	c7 44 24 0c 3f 67 10 	movl   $0xc010673f,0xc(%esp)
c0103464:	c0 
c0103465:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010346c:	c0 
c010346d:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c0103474:	00 
c0103475:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010347c:	e8 45 d8 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c0103481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103488:	e8 92 07 00 00       	call   c0103c1f <alloc_pages>
c010348d:	85 c0                	test   %eax,%eax
c010348f:	74 24                	je     c01034b5 <default_check+0x204>
c0103491:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0103498:	c0 
c0103499:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01034a0:	c0 
c01034a1:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01034a8:	00 
c01034a9:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01034b0:	e8 11 d8 ff ff       	call   c0100cc6 <__panic>

    unsigned int nr_free_store = nr_free;
c01034b5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01034ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01034bd:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01034c4:	00 00 00 

    free_pages(p0 + 2, 3);
c01034c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034ca:	83 c0 28             	add    $0x28,%eax
c01034cd:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01034d4:	00 
c01034d5:	89 04 24             	mov    %eax,(%esp)
c01034d8:	e8 7a 07 00 00       	call   c0103c57 <free_pages>
    assert(alloc_pages(4) == NULL);
c01034dd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01034e4:	e8 36 07 00 00       	call   c0103c1f <alloc_pages>
c01034e9:	85 c0                	test   %eax,%eax
c01034eb:	74 24                	je     c0103511 <default_check+0x260>
c01034ed:	c7 44 24 0c fc 67 10 	movl   $0xc01067fc,0xc(%esp)
c01034f4:	c0 
c01034f5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01034fc:	c0 
c01034fd:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103504:	00 
c0103505:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010350c:	e8 b5 d7 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103514:	83 c0 28             	add    $0x28,%eax
c0103517:	83 c0 04             	add    $0x4,%eax
c010351a:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103521:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103524:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103527:	8b 55 ac             	mov    -0x54(%ebp),%edx
c010352a:	0f a3 10             	bt     %edx,(%eax)
c010352d:	19 c0                	sbb    %eax,%eax
c010352f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103532:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103536:	0f 95 c0             	setne  %al
c0103539:	0f b6 c0             	movzbl %al,%eax
c010353c:	85 c0                	test   %eax,%eax
c010353e:	74 0e                	je     c010354e <default_check+0x29d>
c0103540:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103543:	83 c0 28             	add    $0x28,%eax
c0103546:	8b 40 08             	mov    0x8(%eax),%eax
c0103549:	83 f8 03             	cmp    $0x3,%eax
c010354c:	74 24                	je     c0103572 <default_check+0x2c1>
c010354e:	c7 44 24 0c 14 68 10 	movl   $0xc0106814,0xc(%esp)
c0103555:	c0 
c0103556:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010355d:	c0 
c010355e:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103565:	00 
c0103566:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010356d:	e8 54 d7 ff ff       	call   c0100cc6 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103572:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103579:	e8 a1 06 00 00       	call   c0103c1f <alloc_pages>
c010357e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103581:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103585:	75 24                	jne    c01035ab <default_check+0x2fa>
c0103587:	c7 44 24 0c 40 68 10 	movl   $0xc0106840,0xc(%esp)
c010358e:	c0 
c010358f:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103596:	c0 
c0103597:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c010359e:	00 
c010359f:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01035a6:	e8 1b d7 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01035ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01035b2:	e8 68 06 00 00       	call   c0103c1f <alloc_pages>
c01035b7:	85 c0                	test   %eax,%eax
c01035b9:	74 24                	je     c01035df <default_check+0x32e>
c01035bb:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01035c2:	c0 
c01035c3:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01035ca:	c0 
c01035cb:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01035d2:	00 
c01035d3:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01035da:	e8 e7 d6 ff ff       	call   c0100cc6 <__panic>
    assert(p0 + 2 == p1);
c01035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e2:	83 c0 28             	add    $0x28,%eax
c01035e5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01035e8:	74 24                	je     c010360e <default_check+0x35d>
c01035ea:	c7 44 24 0c 5e 68 10 	movl   $0xc010685e,0xc(%esp)
c01035f1:	c0 
c01035f2:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01035f9:	c0 
c01035fa:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0103601:	00 
c0103602:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103609:	e8 b8 d6 ff ff       	call   c0100cc6 <__panic>

    p2 = p0 + 1;
c010360e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103611:	83 c0 14             	add    $0x14,%eax
c0103614:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103617:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010361e:	00 
c010361f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103622:	89 04 24             	mov    %eax,(%esp)
c0103625:	e8 2d 06 00 00       	call   c0103c57 <free_pages>
    free_pages(p1, 3);
c010362a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103631:	00 
c0103632:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103635:	89 04 24             	mov    %eax,(%esp)
c0103638:	e8 1a 06 00 00       	call   c0103c57 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010363d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103640:	83 c0 04             	add    $0x4,%eax
c0103643:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010364a:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010364d:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103650:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103653:	0f a3 10             	bt     %edx,(%eax)
c0103656:	19 c0                	sbb    %eax,%eax
c0103658:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010365b:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010365f:	0f 95 c0             	setne  %al
c0103662:	0f b6 c0             	movzbl %al,%eax
c0103665:	85 c0                	test   %eax,%eax
c0103667:	74 0b                	je     c0103674 <default_check+0x3c3>
c0103669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010366c:	8b 40 08             	mov    0x8(%eax),%eax
c010366f:	83 f8 01             	cmp    $0x1,%eax
c0103672:	74 24                	je     c0103698 <default_check+0x3e7>
c0103674:	c7 44 24 0c 6c 68 10 	movl   $0xc010686c,0xc(%esp)
c010367b:	c0 
c010367c:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103683:	c0 
c0103684:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c010368b:	00 
c010368c:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103693:	e8 2e d6 ff ff       	call   c0100cc6 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103698:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010369b:	83 c0 04             	add    $0x4,%eax
c010369e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01036a5:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036a8:	8b 45 90             	mov    -0x70(%ebp),%eax
c01036ab:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01036ae:	0f a3 10             	bt     %edx,(%eax)
c01036b1:	19 c0                	sbb    %eax,%eax
c01036b3:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01036b6:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01036ba:	0f 95 c0             	setne  %al
c01036bd:	0f b6 c0             	movzbl %al,%eax
c01036c0:	85 c0                	test   %eax,%eax
c01036c2:	74 0b                	je     c01036cf <default_check+0x41e>
c01036c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036c7:	8b 40 08             	mov    0x8(%eax),%eax
c01036ca:	83 f8 03             	cmp    $0x3,%eax
c01036cd:	74 24                	je     c01036f3 <default_check+0x442>
c01036cf:	c7 44 24 0c 94 68 10 	movl   $0xc0106894,0xc(%esp)
c01036d6:	c0 
c01036d7:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01036de:	c0 
c01036df:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01036e6:	00 
c01036e7:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01036ee:	e8 d3 d5 ff ff       	call   c0100cc6 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01036f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036fa:	e8 20 05 00 00       	call   c0103c1f <alloc_pages>
c01036ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103702:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103705:	83 e8 14             	sub    $0x14,%eax
c0103708:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010370b:	74 24                	je     c0103731 <default_check+0x480>
c010370d:	c7 44 24 0c ba 68 10 	movl   $0xc01068ba,0xc(%esp)
c0103714:	c0 
c0103715:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010371c:	c0 
c010371d:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0103724:	00 
c0103725:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010372c:	e8 95 d5 ff ff       	call   c0100cc6 <__panic>
    free_page(p0);
c0103731:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103738:	00 
c0103739:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010373c:	89 04 24             	mov    %eax,(%esp)
c010373f:	e8 13 05 00 00       	call   c0103c57 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103744:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010374b:	e8 cf 04 00 00       	call   c0103c1f <alloc_pages>
c0103750:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103753:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103756:	83 c0 14             	add    $0x14,%eax
c0103759:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010375c:	74 24                	je     c0103782 <default_check+0x4d1>
c010375e:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c0103765:	c0 
c0103766:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010376d:	c0 
c010376e:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0103775:	00 
c0103776:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010377d:	e8 44 d5 ff ff       	call   c0100cc6 <__panic>

    free_pages(p0, 2);
c0103782:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103789:	00 
c010378a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010378d:	89 04 24             	mov    %eax,(%esp)
c0103790:	e8 c2 04 00 00       	call   c0103c57 <free_pages>
    free_page(p2);
c0103795:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010379c:	00 
c010379d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037a0:	89 04 24             	mov    %eax,(%esp)
c01037a3:	e8 af 04 00 00       	call   c0103c57 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01037a8:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01037af:	e8 6b 04 00 00       	call   c0103c1f <alloc_pages>
c01037b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01037bb:	75 24                	jne    c01037e1 <default_check+0x530>
c01037bd:	c7 44 24 0c f8 68 10 	movl   $0xc01068f8,0xc(%esp)
c01037c4:	c0 
c01037c5:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01037cc:	c0 
c01037cd:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01037d4:	00 
c01037d5:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01037dc:	e8 e5 d4 ff ff       	call   c0100cc6 <__panic>
    assert(alloc_page() == NULL);
c01037e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037e8:	e8 32 04 00 00       	call   c0103c1f <alloc_pages>
c01037ed:	85 c0                	test   %eax,%eax
c01037ef:	74 24                	je     c0103815 <default_check+0x564>
c01037f1:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c01037f8:	c0 
c01037f9:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c0103800:	c0 
c0103801:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103808:	00 
c0103809:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0103810:	e8 b1 d4 ff ff       	call   c0100cc6 <__panic>

    assert(nr_free == 0);
c0103815:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010381a:	85 c0                	test   %eax,%eax
c010381c:	74 24                	je     c0103842 <default_check+0x591>
c010381e:	c7 44 24 0c a9 67 10 	movl   $0xc01067a9,0xc(%esp)
c0103825:	c0 
c0103826:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c010382d:	c0 
c010382e:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103835:	00 
c0103836:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c010383d:	e8 84 d4 ff ff       	call   c0100cc6 <__panic>
    nr_free = nr_free_store;
c0103842:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103845:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c010384a:	8b 45 80             	mov    -0x80(%ebp),%eax
c010384d:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103850:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103855:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c010385b:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103862:	00 
c0103863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103866:	89 04 24             	mov    %eax,(%esp)
c0103869:	e8 e9 03 00 00       	call   c0103c57 <free_pages>

    le = &free_list;
c010386e:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103875:	eb 1d                	jmp    c0103894 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103877:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010387a:	83 e8 0c             	sub    $0xc,%eax
c010387d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103880:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103884:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103887:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010388a:	8b 40 08             	mov    0x8(%eax),%eax
c010388d:	29 c2                	sub    %eax,%edx
c010388f:	89 d0                	mov    %edx,%eax
c0103891:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103894:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103897:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010389a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010389d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01038a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038a3:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01038aa:	75 cb                	jne    c0103877 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01038ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01038b0:	74 24                	je     c01038d6 <default_check+0x625>
c01038b2:	c7 44 24 0c 16 69 10 	movl   $0xc0106916,0xc(%esp)
c01038b9:	c0 
c01038ba:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01038c1:	c0 
c01038c2:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01038c9:	00 
c01038ca:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01038d1:	e8 f0 d3 ff ff       	call   c0100cc6 <__panic>
    assert(total == 0);
c01038d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01038da:	74 24                	je     c0103900 <default_check+0x64f>
c01038dc:	c7 44 24 0c 21 69 10 	movl   $0xc0106921,0xc(%esp)
c01038e3:	c0 
c01038e4:	c7 44 24 08 f6 65 10 	movl   $0xc01065f6,0x8(%esp)
c01038eb:	c0 
c01038ec:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01038f3:	00 
c01038f4:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c01038fb:	e8 c6 d3 ff ff       	call   c0100cc6 <__panic>
}
c0103900:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103906:	5b                   	pop    %ebx
c0103907:	5d                   	pop    %ebp
c0103908:	c3                   	ret    

c0103909 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103909:	55                   	push   %ebp
c010390a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010390c:	8b 55 08             	mov    0x8(%ebp),%edx
c010390f:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103914:	29 c2                	sub    %eax,%edx
c0103916:	89 d0                	mov    %edx,%eax
c0103918:	c1 f8 02             	sar    $0x2,%eax
c010391b:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103921:	5d                   	pop    %ebp
c0103922:	c3                   	ret    

c0103923 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103923:	55                   	push   %ebp
c0103924:	89 e5                	mov    %esp,%ebp
c0103926:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103929:	8b 45 08             	mov    0x8(%ebp),%eax
c010392c:	89 04 24             	mov    %eax,(%esp)
c010392f:	e8 d5 ff ff ff       	call   c0103909 <page2ppn>
c0103934:	c1 e0 0c             	shl    $0xc,%eax
}
c0103937:	c9                   	leave  
c0103938:	c3                   	ret    

c0103939 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103939:	55                   	push   %ebp
c010393a:	89 e5                	mov    %esp,%ebp
c010393c:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010393f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103942:	c1 e8 0c             	shr    $0xc,%eax
c0103945:	89 c2                	mov    %eax,%edx
c0103947:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010394c:	39 c2                	cmp    %eax,%edx
c010394e:	72 1c                	jb     c010396c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103950:	c7 44 24 08 5c 69 10 	movl   $0xc010695c,0x8(%esp)
c0103957:	c0 
c0103958:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010395f:	00 
c0103960:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c0103967:	e8 5a d3 ff ff       	call   c0100cc6 <__panic>
    }
    return &pages[PPN(pa)];
c010396c:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103972:	8b 45 08             	mov    0x8(%ebp),%eax
c0103975:	c1 e8 0c             	shr    $0xc,%eax
c0103978:	89 c2                	mov    %eax,%edx
c010397a:	89 d0                	mov    %edx,%eax
c010397c:	c1 e0 02             	shl    $0x2,%eax
c010397f:	01 d0                	add    %edx,%eax
c0103981:	c1 e0 02             	shl    $0x2,%eax
c0103984:	01 c8                	add    %ecx,%eax
}
c0103986:	c9                   	leave  
c0103987:	c3                   	ret    

c0103988 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103988:	55                   	push   %ebp
c0103989:	89 e5                	mov    %esp,%ebp
c010398b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010398e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103991:	89 04 24             	mov    %eax,(%esp)
c0103994:	e8 8a ff ff ff       	call   c0103923 <page2pa>
c0103999:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010399c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010399f:	c1 e8 0c             	shr    $0xc,%eax
c01039a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039a5:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039aa:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01039ad:	72 23                	jb     c01039d2 <page2kva+0x4a>
c01039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01039b6:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c01039bd:	c0 
c01039be:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01039c5:	00 
c01039c6:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c01039cd:	e8 f4 d2 ff ff       	call   c0100cc6 <__panic>
c01039d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d5:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01039da:	c9                   	leave  
c01039db:	c3                   	ret    

c01039dc <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01039dc:	55                   	push   %ebp
c01039dd:	89 e5                	mov    %esp,%ebp
c01039df:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01039e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e5:	83 e0 01             	and    $0x1,%eax
c01039e8:	85 c0                	test   %eax,%eax
c01039ea:	75 1c                	jne    c0103a08 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01039ec:	c7 44 24 08 b0 69 10 	movl   $0xc01069b0,0x8(%esp)
c01039f3:	c0 
c01039f4:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01039fb:	00 
c01039fc:	c7 04 24 7b 69 10 c0 	movl   $0xc010697b,(%esp)
c0103a03:	e8 be d2 ff ff       	call   c0100cc6 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103a08:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a0b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103a10:	89 04 24             	mov    %eax,(%esp)
c0103a13:	e8 21 ff ff ff       	call   c0103939 <pa2page>
}
c0103a18:	c9                   	leave  
c0103a19:	c3                   	ret    

c0103a1a <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103a1a:	55                   	push   %ebp
c0103a1b:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103a1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a20:	8b 00                	mov    (%eax),%eax
}
c0103a22:	5d                   	pop    %ebp
c0103a23:	c3                   	ret    

c0103a24 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103a24:	55                   	push   %ebp
c0103a25:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103a27:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a2a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a2d:	89 10                	mov    %edx,(%eax)
}
c0103a2f:	5d                   	pop    %ebp
c0103a30:	c3                   	ret    

c0103a31 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103a31:	55                   	push   %ebp
c0103a32:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103a34:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a37:	8b 00                	mov    (%eax),%eax
c0103a39:	8d 50 01             	lea    0x1(%eax),%edx
c0103a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a44:	8b 00                	mov    (%eax),%eax
}
c0103a46:	5d                   	pop    %ebp
c0103a47:	c3                   	ret    

c0103a48 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103a48:	55                   	push   %ebp
c0103a49:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a4e:	8b 00                	mov    (%eax),%eax
c0103a50:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103a53:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a56:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a5b:	8b 00                	mov    (%eax),%eax
}
c0103a5d:	5d                   	pop    %ebp
c0103a5e:	c3                   	ret    

c0103a5f <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103a5f:	55                   	push   %ebp
c0103a60:	89 e5                	mov    %esp,%ebp
c0103a62:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103a65:	9c                   	pushf  
c0103a66:	58                   	pop    %eax
c0103a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103a6d:	25 00 02 00 00       	and    $0x200,%eax
c0103a72:	85 c0                	test   %eax,%eax
c0103a74:	74 0c                	je     c0103a82 <__intr_save+0x23>
        intr_disable();
c0103a76:	e8 2e dc ff ff       	call   c01016a9 <intr_disable>
        return 1;
c0103a7b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103a80:	eb 05                	jmp    c0103a87 <__intr_save+0x28>
    }
    return 0;
c0103a82:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103a87:	c9                   	leave  
c0103a88:	c3                   	ret    

c0103a89 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103a89:	55                   	push   %ebp
c0103a8a:	89 e5                	mov    %esp,%ebp
c0103a8c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103a8f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103a93:	74 05                	je     c0103a9a <__intr_restore+0x11>
        intr_enable();
c0103a95:	e8 09 dc ff ff       	call   c01016a3 <intr_enable>
    }
}
c0103a9a:	c9                   	leave  
c0103a9b:	c3                   	ret    

c0103a9c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103a9c:	55                   	push   %ebp
c0103a9d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aa2:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103aa5:	b8 23 00 00 00       	mov    $0x23,%eax
c0103aaa:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103aac:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ab1:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103ab3:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ab8:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103aba:	b8 10 00 00 00       	mov    $0x10,%eax
c0103abf:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103ac1:	b8 10 00 00 00       	mov    $0x10,%eax
c0103ac6:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103ac8:	ea cf 3a 10 c0 08 00 	ljmp   $0x8,$0xc0103acf
}
c0103acf:	5d                   	pop    %ebp
c0103ad0:	c3                   	ret    

c0103ad1 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103ad1:	55                   	push   %ebp
c0103ad2:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad7:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103adc:	5d                   	pop    %ebp
c0103add:	c3                   	ret    

c0103ade <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103ade:	55                   	push   %ebp
c0103adf:	89 e5                	mov    %esp,%ebp
c0103ae1:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103ae4:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103ae9:	89 04 24             	mov    %eax,(%esp)
c0103aec:	e8 e0 ff ff ff       	call   c0103ad1 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103af1:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103af8:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103afa:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103b01:	68 00 
c0103b03:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b08:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103b0e:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103b13:	c1 e8 10             	shr    $0x10,%eax
c0103b16:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103b1b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b22:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b25:	83 c8 09             	or     $0x9,%eax
c0103b28:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b2d:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b34:	83 e0 ef             	and    $0xffffffef,%eax
c0103b37:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b3c:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b43:	83 e0 9f             	and    $0xffffff9f,%eax
c0103b46:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b4b:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103b52:	83 c8 80             	or     $0xffffff80,%eax
c0103b55:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103b5a:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b61:	83 e0 f0             	and    $0xfffffff0,%eax
c0103b64:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b69:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b70:	83 e0 ef             	and    $0xffffffef,%eax
c0103b73:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b78:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b7f:	83 e0 df             	and    $0xffffffdf,%eax
c0103b82:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b87:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b8e:	83 c8 40             	or     $0x40,%eax
c0103b91:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103b96:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103b9d:	83 e0 7f             	and    $0x7f,%eax
c0103ba0:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103ba5:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103baa:	c1 e8 18             	shr    $0x18,%eax
c0103bad:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103bb2:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103bb9:	e8 de fe ff ff       	call   c0103a9c <lgdt>
c0103bbe:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103bc4:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103bc8:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103bcb:	c9                   	leave  
c0103bcc:	c3                   	ret    

c0103bcd <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103bcd:	55                   	push   %ebp
c0103bce:	89 e5                	mov    %esp,%ebp
c0103bd0:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103bd3:	c7 05 5c 89 11 c0 40 	movl   $0xc0106940,0xc011895c
c0103bda:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103bdd:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103be2:	8b 00                	mov    (%eax),%eax
c0103be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103be8:	c7 04 24 dc 69 10 c0 	movl   $0xc01069dc,(%esp)
c0103bef:	e8 48 c7 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103bf4:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103bf9:	8b 40 04             	mov    0x4(%eax),%eax
c0103bfc:	ff d0                	call   *%eax
}
c0103bfe:	c9                   	leave  
c0103bff:	c3                   	ret    

c0103c00 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103c00:	55                   	push   %ebp
c0103c01:	89 e5                	mov    %esp,%ebp
c0103c03:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103c06:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c0b:	8b 40 08             	mov    0x8(%eax),%eax
c0103c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c11:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c15:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c18:	89 14 24             	mov    %edx,(%esp)
c0103c1b:	ff d0                	call   *%eax
}
c0103c1d:	c9                   	leave  
c0103c1e:	c3                   	ret    

c0103c1f <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103c1f:	55                   	push   %ebp
c0103c20:	89 e5                	mov    %esp,%ebp
c0103c22:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103c25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c2c:	e8 2e fe ff ff       	call   c0103a5f <__intr_save>
c0103c31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103c34:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c39:	8b 40 0c             	mov    0xc(%eax),%eax
c0103c3c:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c3f:	89 14 24             	mov    %edx,(%esp)
c0103c42:	ff d0                	call   *%eax
c0103c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c4a:	89 04 24             	mov    %eax,(%esp)
c0103c4d:	e8 37 fe ff ff       	call   c0103a89 <__intr_restore>
    return page;
c0103c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103c55:	c9                   	leave  
c0103c56:	c3                   	ret    

c0103c57 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103c57:	55                   	push   %ebp
c0103c58:	89 e5                	mov    %esp,%ebp
c0103c5a:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c5d:	e8 fd fd ff ff       	call   c0103a5f <__intr_save>
c0103c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103c65:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c6a:	8b 40 10             	mov    0x10(%eax),%eax
c0103c6d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103c70:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103c74:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c77:	89 14 24             	mov    %edx,(%esp)
c0103c7a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c7f:	89 04 24             	mov    %eax,(%esp)
c0103c82:	e8 02 fe ff ff       	call   c0103a89 <__intr_restore>
}
c0103c87:	c9                   	leave  
c0103c88:	c3                   	ret    

c0103c89 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103c89:	55                   	push   %ebp
c0103c8a:	89 e5                	mov    %esp,%ebp
c0103c8c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103c8f:	e8 cb fd ff ff       	call   c0103a5f <__intr_save>
c0103c94:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103c97:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c9c:	8b 40 14             	mov    0x14(%eax),%eax
c0103c9f:	ff d0                	call   *%eax
c0103ca1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ca7:	89 04 24             	mov    %eax,(%esp)
c0103caa:	e8 da fd ff ff       	call   c0103a89 <__intr_restore>
    return ret;
c0103caf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103cb2:	c9                   	leave  
c0103cb3:	c3                   	ret    

c0103cb4 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103cb4:	55                   	push   %ebp
c0103cb5:	89 e5                	mov    %esp,%ebp
c0103cb7:	57                   	push   %edi
c0103cb8:	56                   	push   %esi
c0103cb9:	53                   	push   %ebx
c0103cba:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103cc0:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103cc7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103cce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103cd5:	c7 04 24 f3 69 10 c0 	movl   $0xc01069f3,(%esp)
c0103cdc:	e8 5b c6 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ce1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103ce8:	e9 15 01 00 00       	jmp    c0103e02 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103ced:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103cf0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103cf3:	89 d0                	mov    %edx,%eax
c0103cf5:	c1 e0 02             	shl    $0x2,%eax
c0103cf8:	01 d0                	add    %edx,%eax
c0103cfa:	c1 e0 02             	shl    $0x2,%eax
c0103cfd:	01 c8                	add    %ecx,%eax
c0103cff:	8b 50 08             	mov    0x8(%eax),%edx
c0103d02:	8b 40 04             	mov    0x4(%eax),%eax
c0103d05:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103d08:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103d0b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d0e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d11:	89 d0                	mov    %edx,%eax
c0103d13:	c1 e0 02             	shl    $0x2,%eax
c0103d16:	01 d0                	add    %edx,%eax
c0103d18:	c1 e0 02             	shl    $0x2,%eax
c0103d1b:	01 c8                	add    %ecx,%eax
c0103d1d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d20:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d23:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d26:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d29:	01 c8                	add    %ecx,%eax
c0103d2b:	11 da                	adc    %ebx,%edx
c0103d2d:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103d30:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103d33:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d36:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d39:	89 d0                	mov    %edx,%eax
c0103d3b:	c1 e0 02             	shl    $0x2,%eax
c0103d3e:	01 d0                	add    %edx,%eax
c0103d40:	c1 e0 02             	shl    $0x2,%eax
c0103d43:	01 c8                	add    %ecx,%eax
c0103d45:	83 c0 14             	add    $0x14,%eax
c0103d48:	8b 00                	mov    (%eax),%eax
c0103d4a:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103d50:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103d53:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103d56:	83 c0 ff             	add    $0xffffffff,%eax
c0103d59:	83 d2 ff             	adc    $0xffffffff,%edx
c0103d5c:	89 c6                	mov    %eax,%esi
c0103d5e:	89 d7                	mov    %edx,%edi
c0103d60:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d63:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d66:	89 d0                	mov    %edx,%eax
c0103d68:	c1 e0 02             	shl    $0x2,%eax
c0103d6b:	01 d0                	add    %edx,%eax
c0103d6d:	c1 e0 02             	shl    $0x2,%eax
c0103d70:	01 c8                	add    %ecx,%eax
c0103d72:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103d75:	8b 58 10             	mov    0x10(%eax),%ebx
c0103d78:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103d7e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103d82:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103d86:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103d8a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103d8d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103d90:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d94:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103d98:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103d9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103da0:	c7 04 24 00 6a 10 c0 	movl   $0xc0106a00,(%esp)
c0103da7:	e8 90 c5 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103dac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103daf:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103db2:	89 d0                	mov    %edx,%eax
c0103db4:	c1 e0 02             	shl    $0x2,%eax
c0103db7:	01 d0                	add    %edx,%eax
c0103db9:	c1 e0 02             	shl    $0x2,%eax
c0103dbc:	01 c8                	add    %ecx,%eax
c0103dbe:	83 c0 14             	add    $0x14,%eax
c0103dc1:	8b 00                	mov    (%eax),%eax
c0103dc3:	83 f8 01             	cmp    $0x1,%eax
c0103dc6:	75 36                	jne    c0103dfe <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103dcb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103dce:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103dd1:	77 2b                	ja     c0103dfe <page_init+0x14a>
c0103dd3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103dd6:	72 05                	jb     c0103ddd <page_init+0x129>
c0103dd8:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ddb:	73 21                	jae    c0103dfe <page_init+0x14a>
c0103ddd:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103de1:	77 1b                	ja     c0103dfe <page_init+0x14a>
c0103de3:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103de7:	72 09                	jb     c0103df2 <page_init+0x13e>
c0103de9:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103df0:	77 0c                	ja     c0103dfe <page_init+0x14a>
                maxpa = end;
c0103df2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103df5:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df8:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103dfb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dfe:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103e02:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e05:	8b 00                	mov    (%eax),%eax
c0103e07:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103e0a:	0f 8f dd fe ff ff    	jg     c0103ced <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103e10:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e14:	72 1d                	jb     c0103e33 <page_init+0x17f>
c0103e16:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103e1a:	77 09                	ja     c0103e25 <page_init+0x171>
c0103e1c:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103e23:	76 0e                	jbe    c0103e33 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103e25:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103e2c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103e33:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e36:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e39:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103e3d:	c1 ea 0c             	shr    $0xc,%edx
c0103e40:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103e45:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103e4c:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103e51:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103e54:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103e57:	01 d0                	add    %edx,%eax
c0103e59:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103e5c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103e5f:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e64:	f7 75 ac             	divl   -0x54(%ebp)
c0103e67:	89 d0                	mov    %edx,%eax
c0103e69:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103e6c:	29 c2                	sub    %eax,%edx
c0103e6e:	89 d0                	mov    %edx,%eax
c0103e70:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103e75:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103e7c:	eb 2f                	jmp    c0103ead <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103e7e:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103e84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e87:	89 d0                	mov    %edx,%eax
c0103e89:	c1 e0 02             	shl    $0x2,%eax
c0103e8c:	01 d0                	add    %edx,%eax
c0103e8e:	c1 e0 02             	shl    $0x2,%eax
c0103e91:	01 c8                	add    %ecx,%eax
c0103e93:	83 c0 04             	add    $0x4,%eax
c0103e96:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103e9d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103ea0:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103ea3:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103ea6:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103ea9:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ead:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eb0:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103eb5:	39 c2                	cmp    %eax,%edx
c0103eb7:	72 c5                	jb     c0103e7e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103eb9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103ebf:	89 d0                	mov    %edx,%eax
c0103ec1:	c1 e0 02             	shl    $0x2,%eax
c0103ec4:	01 d0                	add    %edx,%eax
c0103ec6:	c1 e0 02             	shl    $0x2,%eax
c0103ec9:	89 c2                	mov    %eax,%edx
c0103ecb:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103ed0:	01 d0                	add    %edx,%eax
c0103ed2:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103ed5:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103edc:	77 23                	ja     c0103f01 <page_init+0x24d>
c0103ede:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103ee1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ee5:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c0103eec:	c0 
c0103eed:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103ef4:	00 
c0103ef5:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0103efc:	e8 c5 cd ff ff       	call   c0100cc6 <__panic>
c0103f01:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f04:	05 00 00 00 40       	add    $0x40000000,%eax
c0103f09:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f0c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f13:	e9 74 01 00 00       	jmp    c010408c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103f18:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f1b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f1e:	89 d0                	mov    %edx,%eax
c0103f20:	c1 e0 02             	shl    $0x2,%eax
c0103f23:	01 d0                	add    %edx,%eax
c0103f25:	c1 e0 02             	shl    $0x2,%eax
c0103f28:	01 c8                	add    %ecx,%eax
c0103f2a:	8b 50 08             	mov    0x8(%eax),%edx
c0103f2d:	8b 40 04             	mov    0x4(%eax),%eax
c0103f30:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f33:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103f36:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f39:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f3c:	89 d0                	mov    %edx,%eax
c0103f3e:	c1 e0 02             	shl    $0x2,%eax
c0103f41:	01 d0                	add    %edx,%eax
c0103f43:	c1 e0 02             	shl    $0x2,%eax
c0103f46:	01 c8                	add    %ecx,%eax
c0103f48:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103f4b:	8b 58 10             	mov    0x10(%eax),%ebx
c0103f4e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f51:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103f54:	01 c8                	add    %ecx,%eax
c0103f56:	11 da                	adc    %ebx,%edx
c0103f58:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103f5b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103f5e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103f61:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f64:	89 d0                	mov    %edx,%eax
c0103f66:	c1 e0 02             	shl    $0x2,%eax
c0103f69:	01 d0                	add    %edx,%eax
c0103f6b:	c1 e0 02             	shl    $0x2,%eax
c0103f6e:	01 c8                	add    %ecx,%eax
c0103f70:	83 c0 14             	add    $0x14,%eax
c0103f73:	8b 00                	mov    (%eax),%eax
c0103f75:	83 f8 01             	cmp    $0x1,%eax
c0103f78:	0f 85 0a 01 00 00    	jne    c0104088 <page_init+0x3d4>
            if (begin < freemem) {
c0103f7e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f81:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f86:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f89:	72 17                	jb     c0103fa2 <page_init+0x2ee>
c0103f8b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103f8e:	77 05                	ja     c0103f95 <page_init+0x2e1>
c0103f90:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103f93:	76 0d                	jbe    c0103fa2 <page_init+0x2ee>
                begin = freemem;
c0103f95:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103f98:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103f9b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103fa2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fa6:	72 1d                	jb     c0103fc5 <page_init+0x311>
c0103fa8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103fac:	77 09                	ja     c0103fb7 <page_init+0x303>
c0103fae:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103fb5:	76 0e                	jbe    c0103fc5 <page_init+0x311>
                end = KMEMSIZE;
c0103fb7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103fbe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103fc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103fcb:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103fce:	0f 87 b4 00 00 00    	ja     c0104088 <page_init+0x3d4>
c0103fd4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103fd7:	72 09                	jb     c0103fe2 <page_init+0x32e>
c0103fd9:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103fdc:	0f 83 a6 00 00 00    	jae    c0104088 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103fe2:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103fe9:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103fec:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103fef:	01 d0                	add    %edx,%eax
c0103ff1:	83 e8 01             	sub    $0x1,%eax
c0103ff4:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103ff7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103ffa:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fff:	f7 75 9c             	divl   -0x64(%ebp)
c0104002:	89 d0                	mov    %edx,%eax
c0104004:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104007:	29 c2                	sub    %eax,%edx
c0104009:	89 d0                	mov    %edx,%eax
c010400b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104010:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104013:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104016:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104019:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010401c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010401f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104024:	89 c7                	mov    %eax,%edi
c0104026:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c010402c:	89 7d 80             	mov    %edi,-0x80(%ebp)
c010402f:	89 d0                	mov    %edx,%eax
c0104031:	83 e0 00             	and    $0x0,%eax
c0104034:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104037:	8b 45 80             	mov    -0x80(%ebp),%eax
c010403a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010403d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104040:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104043:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104046:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104049:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010404c:	77 3a                	ja     c0104088 <page_init+0x3d4>
c010404e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104051:	72 05                	jb     c0104058 <page_init+0x3a4>
c0104053:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104056:	73 30                	jae    c0104088 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104058:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010405b:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010405e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104061:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104064:	29 c8                	sub    %ecx,%eax
c0104066:	19 da                	sbb    %ebx,%edx
c0104068:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010406c:	c1 ea 0c             	shr    $0xc,%edx
c010406f:	89 c3                	mov    %eax,%ebx
c0104071:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104074:	89 04 24             	mov    %eax,(%esp)
c0104077:	e8 bd f8 ff ff       	call   c0103939 <pa2page>
c010407c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104080:	89 04 24             	mov    %eax,(%esp)
c0104083:	e8 78 fb ff ff       	call   c0103c00 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104088:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010408c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010408f:	8b 00                	mov    (%eax),%eax
c0104091:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104094:	0f 8f 7e fe ff ff    	jg     c0103f18 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010409a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01040a0:	5b                   	pop    %ebx
c01040a1:	5e                   	pop    %esi
c01040a2:	5f                   	pop    %edi
c01040a3:	5d                   	pop    %ebp
c01040a4:	c3                   	ret    

c01040a5 <enable_paging>:

static void
enable_paging(void) {
c01040a5:	55                   	push   %ebp
c01040a6:	89 e5                	mov    %esp,%ebp
c01040a8:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01040ab:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01040b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01040b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01040b6:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01040b9:	0f 20 c0             	mov    %cr0,%eax
c01040bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01040c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01040c5:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01040cc:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01040d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01040d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040d9:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01040dc:	c9                   	leave  
c01040dd:	c3                   	ret    

c01040de <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01040de:	55                   	push   %ebp
c01040df:	89 e5                	mov    %esp,%ebp
c01040e1:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01040e4:	8b 45 14             	mov    0x14(%ebp),%eax
c01040e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01040ea:	31 d0                	xor    %edx,%eax
c01040ec:	25 ff 0f 00 00       	and    $0xfff,%eax
c01040f1:	85 c0                	test   %eax,%eax
c01040f3:	74 24                	je     c0104119 <boot_map_segment+0x3b>
c01040f5:	c7 44 24 0c 62 6a 10 	movl   $0xc0106a62,0xc(%esp)
c01040fc:	c0 
c01040fd:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104104:	c0 
c0104105:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010410c:	00 
c010410d:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104114:	e8 ad cb ff ff       	call   c0100cc6 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104119:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104120:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104123:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104128:	89 c2                	mov    %eax,%edx
c010412a:	8b 45 10             	mov    0x10(%ebp),%eax
c010412d:	01 c2                	add    %eax,%edx
c010412f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104132:	01 d0                	add    %edx,%eax
c0104134:	83 e8 01             	sub    $0x1,%eax
c0104137:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010413a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010413d:	ba 00 00 00 00       	mov    $0x0,%edx
c0104142:	f7 75 f0             	divl   -0x10(%ebp)
c0104145:	89 d0                	mov    %edx,%eax
c0104147:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010414a:	29 c2                	sub    %eax,%edx
c010414c:	89 d0                	mov    %edx,%eax
c010414e:	c1 e8 0c             	shr    $0xc,%eax
c0104151:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104154:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104157:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010415a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010415d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104162:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104165:	8b 45 14             	mov    0x14(%ebp),%eax
c0104168:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010416b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010416e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104173:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104176:	eb 6b                	jmp    c01041e3 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104178:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010417f:	00 
c0104180:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104183:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104187:	8b 45 08             	mov    0x8(%ebp),%eax
c010418a:	89 04 24             	mov    %eax,(%esp)
c010418d:	e8 cc 01 00 00       	call   c010435e <get_pte>
c0104192:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104195:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104199:	75 24                	jne    c01041bf <boot_map_segment+0xe1>
c010419b:	c7 44 24 0c 8e 6a 10 	movl   $0xc0106a8e,0xc(%esp)
c01041a2:	c0 
c01041a3:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01041aa:	c0 
c01041ab:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01041b2:	00 
c01041b3:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01041ba:	e8 07 cb ff ff       	call   c0100cc6 <__panic>
        *ptep = pa | PTE_P | perm;
c01041bf:	8b 45 18             	mov    0x18(%ebp),%eax
c01041c2:	8b 55 14             	mov    0x14(%ebp),%edx
c01041c5:	09 d0                	or     %edx,%eax
c01041c7:	83 c8 01             	or     $0x1,%eax
c01041ca:	89 c2                	mov    %eax,%edx
c01041cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01041cf:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01041d1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01041d5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01041dc:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01041e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01041e7:	75 8f                	jne    c0104178 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01041e9:	c9                   	leave  
c01041ea:	c3                   	ret    

c01041eb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01041eb:	55                   	push   %ebp
c01041ec:	89 e5                	mov    %esp,%ebp
c01041ee:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01041f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041f8:	e8 22 fa ff ff       	call   c0103c1f <alloc_pages>
c01041fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104204:	75 1c                	jne    c0104222 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104206:	c7 44 24 08 9b 6a 10 	movl   $0xc0106a9b,0x8(%esp)
c010420d:	c0 
c010420e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104215:	00 
c0104216:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010421d:	e8 a4 ca ff ff       	call   c0100cc6 <__panic>
    }
    return page2kva(p);
c0104222:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104225:	89 04 24             	mov    %eax,(%esp)
c0104228:	e8 5b f7 ff ff       	call   c0103988 <page2kva>
}
c010422d:	c9                   	leave  
c010422e:	c3                   	ret    

c010422f <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010422f:	55                   	push   %ebp
c0104230:	89 e5                	mov    %esp,%ebp
c0104232:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104235:	e8 93 f9 ff ff       	call   c0103bcd <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010423a:	e8 75 fa ff ff       	call   c0103cb4 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010423f:	e8 70 04 00 00       	call   c01046b4 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104244:	e8 a2 ff ff ff       	call   c01041eb <boot_alloc_page>
c0104249:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c010424e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104253:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010425a:	00 
c010425b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104262:	00 
c0104263:	89 04 24             	mov    %eax,(%esp)
c0104266:	e8 b2 1a 00 00       	call   c0105d1d <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010426b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104270:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104273:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010427a:	77 23                	ja     c010429f <pmm_init+0x70>
c010427c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010427f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104283:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c010428a:	c0 
c010428b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104292:	00 
c0104293:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010429a:	e8 27 ca ff ff       	call   c0100cc6 <__panic>
c010429f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042a2:	05 00 00 00 40       	add    $0x40000000,%eax
c01042a7:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01042ac:	e8 21 04 00 00       	call   c01046d2 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01042b1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042b6:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01042bc:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01042c4:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01042cb:	77 23                	ja     c01042f0 <pmm_init+0xc1>
c01042cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01042d4:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c01042db:	c0 
c01042dc:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01042e3:	00 
c01042e4:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01042eb:	e8 d6 c9 ff ff       	call   c0100cc6 <__panic>
c01042f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f3:	05 00 00 00 40       	add    $0x40000000,%eax
c01042f8:	83 c8 03             	or     $0x3,%eax
c01042fb:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01042fd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104302:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104309:	00 
c010430a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104311:	00 
c0104312:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104319:	38 
c010431a:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104321:	c0 
c0104322:	89 04 24             	mov    %eax,(%esp)
c0104325:	e8 b4 fd ff ff       	call   c01040de <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010432a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010432f:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c0104335:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010433b:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010433d:	e8 63 fd ff ff       	call   c01040a5 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104342:	e8 97 f7 ff ff       	call   c0103ade <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104347:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010434c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104352:	e8 16 0a 00 00       	call   c0104d6d <check_boot_pgdir>

    print_pgdir();
c0104357:	e8 a3 0e 00 00       	call   c01051ff <print_pgdir>

}
c010435c:	c9                   	leave  
c010435d:	c3                   	ret    

c010435e <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c010435e:	55                   	push   %ebp
c010435f:	89 e5                	mov    %esp,%ebp
c0104361:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif

	pde_t *pdep = &pgdir[PDX(la)];
c0104364:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104367:	c1 e8 16             	shr    $0x16,%eax
c010436a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104371:	8b 45 08             	mov    0x8(%ebp),%eax
c0104374:	01 d0                	add    %edx,%eax
c0104376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (!(*pdep & PTE_P)){
c0104379:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010437c:	8b 00                	mov    (%eax),%eax
c010437e:	83 e0 01             	and    $0x1,%eax
c0104381:	85 c0                	test   %eax,%eax
c0104383:	0f 85 b9 00 00 00    	jne    c0104442 <get_pte+0xe4>
		struct Page* page;
		if (!create) return NULL;
c0104389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010438d:	75 0a                	jne    c0104399 <get_pte+0x3b>
c010438f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104394:	e9 05 01 00 00       	jmp    c010449e <get_pte+0x140>
		page = alloc_page();
c0104399:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01043a0:	e8 7a f8 ff ff       	call   c0103c1f <alloc_pages>
c01043a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (page == NULL) return NULL;
c01043a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01043ac:	75 0a                	jne    c01043b8 <get_pte+0x5a>
c01043ae:	b8 00 00 00 00       	mov    $0x0,%eax
c01043b3:	e9 e6 00 00 00       	jmp    c010449e <get_pte+0x140>
		set_page_ref(page, 1);
c01043b8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043bf:	00 
c01043c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043c3:	89 04 24             	mov    %eax,(%esp)
c01043c6:	e8 59 f6 ff ff       	call   c0103a24 <set_page_ref>
		uintptr_t pa = page2pa(page);
c01043cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ce:	89 04 24             	mov    %eax,(%esp)
c01043d1:	e8 4d f5 ff ff       	call   c0103923 <page2pa>
c01043d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
		memset(KADDR(pa), 0, PGSIZE);
c01043d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01043df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043e2:	c1 e8 0c             	shr    $0xc,%eax
c01043e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01043e8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01043ed:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01043f0:	72 23                	jb     c0104415 <get_pte+0xb7>
c01043f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01043f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043f9:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104400:	c0 
c0104401:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c0104408:	00 
c0104409:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104410:	e8 b1 c8 ff ff       	call   c0100cc6 <__panic>
c0104415:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104418:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010441d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104424:	00 
c0104425:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010442c:	00 
c010442d:	89 04 24             	mov    %eax,(%esp)
c0104430:	e8 e8 18 00 00       	call   c0105d1d <memset>
		*pdep = pa | PTE_U | PTE_W | PTE_P;
c0104435:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104438:	83 c8 07             	or     $0x7,%eax
c010443b:	89 c2                	mov    %eax,%edx
c010443d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104440:	89 10                	mov    %edx,(%eax)
	}
	return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104442:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104445:	8b 00                	mov    (%eax),%eax
c0104447:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010444c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010444f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104452:	c1 e8 0c             	shr    $0xc,%eax
c0104455:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104458:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010445d:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104460:	72 23                	jb     c0104485 <get_pte+0x127>
c0104462:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104465:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104469:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104470:	c0 
c0104471:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c0104478:	00 
c0104479:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104480:	e8 41 c8 ff ff       	call   c0100cc6 <__panic>
c0104485:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104488:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010448d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104490:	c1 ea 0c             	shr    $0xc,%edx
c0104493:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104499:	c1 e2 02             	shl    $0x2,%edx
c010449c:	01 d0                	add    %edx,%eax
}
c010449e:	c9                   	leave  
c010449f:	c3                   	ret    

c01044a0 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01044a0:	55                   	push   %ebp
c01044a1:	89 e5                	mov    %esp,%ebp
c01044a3:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01044a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044ad:	00 
c01044ae:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b8:	89 04 24             	mov    %eax,(%esp)
c01044bb:	e8 9e fe ff ff       	call   c010435e <get_pte>
c01044c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01044c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01044c7:	74 08                	je     c01044d1 <get_page+0x31>
        *ptep_store = ptep;
c01044c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01044cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044cf:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01044d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01044d5:	74 1b                	je     c01044f2 <get_page+0x52>
c01044d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044da:	8b 00                	mov    (%eax),%eax
c01044dc:	83 e0 01             	and    $0x1,%eax
c01044df:	85 c0                	test   %eax,%eax
c01044e1:	74 0f                	je     c01044f2 <get_page+0x52>
        return pa2page(*ptep);
c01044e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044e6:	8b 00                	mov    (%eax),%eax
c01044e8:	89 04 24             	mov    %eax,(%esp)
c01044eb:	e8 49 f4 ff ff       	call   c0103939 <pa2page>
c01044f0:	eb 05                	jmp    c01044f7 <get_page+0x57>
    }
    return NULL;
c01044f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01044f7:	c9                   	leave  
c01044f8:	c3                   	ret    

c01044f9 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01044f9:	55                   	push   %ebp
c01044fa:	89 e5                	mov    %esp,%ebp
c01044fc:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01044ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0104502:	8b 00                	mov    (%eax),%eax
c0104504:	83 e0 01             	and    $0x1,%eax
c0104507:	85 c0                	test   %eax,%eax
c0104509:	74 4d                	je     c0104558 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c010450b:	8b 45 10             	mov    0x10(%ebp),%eax
c010450e:	8b 00                	mov    (%eax),%eax
c0104510:	89 04 24             	mov    %eax,(%esp)
c0104513:	e8 c4 f4 ff ff       	call   c01039dc <pte2page>
c0104518:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010451b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010451e:	89 04 24             	mov    %eax,(%esp)
c0104521:	e8 22 f5 ff ff       	call   c0103a48 <page_ref_dec>
c0104526:	85 c0                	test   %eax,%eax
c0104528:	75 13                	jne    c010453d <page_remove_pte+0x44>
            free_page(page);
c010452a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104531:	00 
c0104532:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104535:	89 04 24             	mov    %eax,(%esp)
c0104538:	e8 1a f7 ff ff       	call   c0103c57 <free_pages>
        }
        *ptep = 0;
c010453d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104549:	89 44 24 04          	mov    %eax,0x4(%esp)
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	89 04 24             	mov    %eax,(%esp)
c0104553:	e8 ff 00 00 00       	call   c0104657 <tlb_invalidate>
    }
}
c0104558:	c9                   	leave  
c0104559:	c3                   	ret    

c010455a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010455a:	55                   	push   %ebp
c010455b:	89 e5                	mov    %esp,%ebp
c010455d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104560:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104567:	00 
c0104568:	8b 45 0c             	mov    0xc(%ebp),%eax
c010456b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010456f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104572:	89 04 24             	mov    %eax,(%esp)
c0104575:	e8 e4 fd ff ff       	call   c010435e <get_pte>
c010457a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010457d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104581:	74 19                	je     c010459c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104583:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104586:	89 44 24 08          	mov    %eax,0x8(%esp)
c010458a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010458d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104591:	8b 45 08             	mov    0x8(%ebp),%eax
c0104594:	89 04 24             	mov    %eax,(%esp)
c0104597:	e8 5d ff ff ff       	call   c01044f9 <page_remove_pte>
    }
}
c010459c:	c9                   	leave  
c010459d:	c3                   	ret    

c010459e <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010459e:	55                   	push   %ebp
c010459f:	89 e5                	mov    %esp,%ebp
c01045a1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01045a4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01045ab:	00 
c01045ac:	8b 45 10             	mov    0x10(%ebp),%eax
c01045af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01045b6:	89 04 24             	mov    %eax,(%esp)
c01045b9:	e8 a0 fd ff ff       	call   c010435e <get_pte>
c01045be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01045c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045c5:	75 0a                	jne    c01045d1 <page_insert+0x33>
        return -E_NO_MEM;
c01045c7:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01045cc:	e9 84 00 00 00       	jmp    c0104655 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01045d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045d4:	89 04 24             	mov    %eax,(%esp)
c01045d7:	e8 55 f4 ff ff       	call   c0103a31 <page_ref_inc>
    if (*ptep & PTE_P) {
c01045dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045df:	8b 00                	mov    (%eax),%eax
c01045e1:	83 e0 01             	and    $0x1,%eax
c01045e4:	85 c0                	test   %eax,%eax
c01045e6:	74 3e                	je     c0104626 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01045e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045eb:	8b 00                	mov    (%eax),%eax
c01045ed:	89 04 24             	mov    %eax,(%esp)
c01045f0:	e8 e7 f3 ff ff       	call   c01039dc <pte2page>
c01045f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01045f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045fb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01045fe:	75 0d                	jne    c010460d <page_insert+0x6f>
            page_ref_dec(page);
c0104600:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104603:	89 04 24             	mov    %eax,(%esp)
c0104606:	e8 3d f4 ff ff       	call   c0103a48 <page_ref_dec>
c010460b:	eb 19                	jmp    c0104626 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010460d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104610:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104614:	8b 45 10             	mov    0x10(%ebp),%eax
c0104617:	89 44 24 04          	mov    %eax,0x4(%esp)
c010461b:	8b 45 08             	mov    0x8(%ebp),%eax
c010461e:	89 04 24             	mov    %eax,(%esp)
c0104621:	e8 d3 fe ff ff       	call   c01044f9 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104629:	89 04 24             	mov    %eax,(%esp)
c010462c:	e8 f2 f2 ff ff       	call   c0103923 <page2pa>
c0104631:	0b 45 14             	or     0x14(%ebp),%eax
c0104634:	83 c8 01             	or     $0x1,%eax
c0104637:	89 c2                	mov    %eax,%edx
c0104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010463e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104641:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104645:	8b 45 08             	mov    0x8(%ebp),%eax
c0104648:	89 04 24             	mov    %eax,(%esp)
c010464b:	e8 07 00 00 00       	call   c0104657 <tlb_invalidate>
    return 0;
c0104650:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104655:	c9                   	leave  
c0104656:	c3                   	ret    

c0104657 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104657:	55                   	push   %ebp
c0104658:	89 e5                	mov    %esp,%ebp
c010465a:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010465d:	0f 20 d8             	mov    %cr3,%eax
c0104660:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104663:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104666:	89 c2                	mov    %eax,%edx
c0104668:	8b 45 08             	mov    0x8(%ebp),%eax
c010466b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010466e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104675:	77 23                	ja     c010469a <tlb_invalidate+0x43>
c0104677:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010467a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010467e:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c0104685:	c0 
c0104686:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c010468d:	00 
c010468e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104695:	e8 2c c6 ff ff       	call   c0100cc6 <__panic>
c010469a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469d:	05 00 00 00 40       	add    $0x40000000,%eax
c01046a2:	39 c2                	cmp    %eax,%edx
c01046a4:	75 0c                	jne    c01046b2 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01046a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01046ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046af:	0f 01 38             	invlpg (%eax)
    }
}
c01046b2:	c9                   	leave  
c01046b3:	c3                   	ret    

c01046b4 <check_alloc_page>:

static void
check_alloc_page(void) {
c01046b4:	55                   	push   %ebp
c01046b5:	89 e5                	mov    %esp,%ebp
c01046b7:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01046ba:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01046bf:	8b 40 18             	mov    0x18(%eax),%eax
c01046c2:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01046c4:	c7 04 24 b4 6a 10 c0 	movl   $0xc0106ab4,(%esp)
c01046cb:	e8 6c bc ff ff       	call   c010033c <cprintf>
}
c01046d0:	c9                   	leave  
c01046d1:	c3                   	ret    

c01046d2 <check_pgdir>:

static void
check_pgdir(void) {
c01046d2:	55                   	push   %ebp
c01046d3:	89 e5                	mov    %esp,%ebp
c01046d5:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01046d8:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01046dd:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01046e2:	76 24                	jbe    c0104708 <check_pgdir+0x36>
c01046e4:	c7 44 24 0c d3 6a 10 	movl   $0xc0106ad3,0xc(%esp)
c01046eb:	c0 
c01046ec:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01046f3:	c0 
c01046f4:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01046fb:	00 
c01046fc:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104703:	e8 be c5 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104708:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010470d:	85 c0                	test   %eax,%eax
c010470f:	74 0e                	je     c010471f <check_pgdir+0x4d>
c0104711:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104716:	25 ff 0f 00 00       	and    $0xfff,%eax
c010471b:	85 c0                	test   %eax,%eax
c010471d:	74 24                	je     c0104743 <check_pgdir+0x71>
c010471f:	c7 44 24 0c f0 6a 10 	movl   $0xc0106af0,0xc(%esp)
c0104726:	c0 
c0104727:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010472e:	c0 
c010472f:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104736:	00 
c0104737:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010473e:	e8 83 c5 ff ff       	call   c0100cc6 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104743:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104748:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010474f:	00 
c0104750:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104757:	00 
c0104758:	89 04 24             	mov    %eax,(%esp)
c010475b:	e8 40 fd ff ff       	call   c01044a0 <get_page>
c0104760:	85 c0                	test   %eax,%eax
c0104762:	74 24                	je     c0104788 <check_pgdir+0xb6>
c0104764:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c010476b:	c0 
c010476c:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104773:	c0 
c0104774:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c010477b:	00 
c010477c:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104783:	e8 3e c5 ff ff       	call   c0100cc6 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104788:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010478f:	e8 8b f4 ff ff       	call   c0103c1f <alloc_pages>
c0104794:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104797:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010479c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01047a3:	00 
c01047a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ab:	00 
c01047ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047b3:	89 04 24             	mov    %eax,(%esp)
c01047b6:	e8 e3 fd ff ff       	call   c010459e <page_insert>
c01047bb:	85 c0                	test   %eax,%eax
c01047bd:	74 24                	je     c01047e3 <check_pgdir+0x111>
c01047bf:	c7 44 24 0c 50 6b 10 	movl   $0xc0106b50,0xc(%esp)
c01047c6:	c0 
c01047c7:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01047ce:	c0 
c01047cf:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c01047d6:	00 
c01047d7:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01047de:	e8 e3 c4 ff ff       	call   c0100cc6 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01047e3:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ef:	00 
c01047f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047f7:	00 
c01047f8:	89 04 24             	mov    %eax,(%esp)
c01047fb:	e8 5e fb ff ff       	call   c010435e <get_pte>
c0104800:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104803:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104807:	75 24                	jne    c010482d <check_pgdir+0x15b>
c0104809:	c7 44 24 0c 7c 6b 10 	movl   $0xc0106b7c,0xc(%esp)
c0104810:	c0 
c0104811:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104818:	c0 
c0104819:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104820:	00 
c0104821:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104828:	e8 99 c4 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c010482d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104830:	8b 00                	mov    (%eax),%eax
c0104832:	89 04 24             	mov    %eax,(%esp)
c0104835:	e8 ff f0 ff ff       	call   c0103939 <pa2page>
c010483a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010483d:	74 24                	je     c0104863 <check_pgdir+0x191>
c010483f:	c7 44 24 0c a9 6b 10 	movl   $0xc0106ba9,0xc(%esp)
c0104846:	c0 
c0104847:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010484e:	c0 
c010484f:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104856:	00 
c0104857:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010485e:	e8 63 c4 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 1);
c0104863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104866:	89 04 24             	mov    %eax,(%esp)
c0104869:	e8 ac f1 ff ff       	call   c0103a1a <page_ref>
c010486e:	83 f8 01             	cmp    $0x1,%eax
c0104871:	74 24                	je     c0104897 <check_pgdir+0x1c5>
c0104873:	c7 44 24 0c be 6b 10 	movl   $0xc0106bbe,0xc(%esp)
c010487a:	c0 
c010487b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104882:	c0 
c0104883:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c010488a:	00 
c010488b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104892:	e8 2f c4 ff ff       	call   c0100cc6 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104897:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010489c:	8b 00                	mov    (%eax),%eax
c010489e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01048a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01048a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048a9:	c1 e8 0c             	shr    $0xc,%eax
c01048ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01048af:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01048b4:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01048b7:	72 23                	jb     c01048dc <check_pgdir+0x20a>
c01048b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01048c0:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c01048c7:	c0 
c01048c8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01048cf:	00 
c01048d0:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01048d7:	e8 ea c3 ff ff       	call   c0100cc6 <__panic>
c01048dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048df:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01048e4:	83 c0 04             	add    $0x4,%eax
c01048e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01048ea:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048ef:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048f6:	00 
c01048f7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01048fe:	00 
c01048ff:	89 04 24             	mov    %eax,(%esp)
c0104902:	e8 57 fa ff ff       	call   c010435e <get_pte>
c0104907:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010490a:	74 24                	je     c0104930 <check_pgdir+0x25e>
c010490c:	c7 44 24 0c d0 6b 10 	movl   $0xc0106bd0,0xc(%esp)
c0104913:	c0 
c0104914:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010491b:	c0 
c010491c:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0104923:	00 
c0104924:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010492b:	e8 96 c3 ff ff       	call   c0100cc6 <__panic>

    p2 = alloc_page();
c0104930:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104937:	e8 e3 f2 ff ff       	call   c0103c1f <alloc_pages>
c010493c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010493f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104944:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010494b:	00 
c010494c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104953:	00 
c0104954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104957:	89 54 24 04          	mov    %edx,0x4(%esp)
c010495b:	89 04 24             	mov    %eax,(%esp)
c010495e:	e8 3b fc ff ff       	call   c010459e <page_insert>
c0104963:	85 c0                	test   %eax,%eax
c0104965:	74 24                	je     c010498b <check_pgdir+0x2b9>
c0104967:	c7 44 24 0c f8 6b 10 	movl   $0xc0106bf8,0xc(%esp)
c010496e:	c0 
c010496f:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104976:	c0 
c0104977:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c010497e:	00 
c010497f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104986:	e8 3b c3 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010498b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104990:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104997:	00 
c0104998:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010499f:	00 
c01049a0:	89 04 24             	mov    %eax,(%esp)
c01049a3:	e8 b6 f9 ff ff       	call   c010435e <get_pte>
c01049a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049af:	75 24                	jne    c01049d5 <check_pgdir+0x303>
c01049b1:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c01049b8:	c0 
c01049b9:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01049c0:	c0 
c01049c1:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01049c8:	00 
c01049c9:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01049d0:	e8 f1 c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_U);
c01049d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d8:	8b 00                	mov    (%eax),%eax
c01049da:	83 e0 04             	and    $0x4,%eax
c01049dd:	85 c0                	test   %eax,%eax
c01049df:	75 24                	jne    c0104a05 <check_pgdir+0x333>
c01049e1:	c7 44 24 0c 60 6c 10 	movl   $0xc0106c60,0xc(%esp)
c01049e8:	c0 
c01049e9:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c01049f0:	c0 
c01049f1:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c01049f8:	00 
c01049f9:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a00:	e8 c1 c2 ff ff       	call   c0100cc6 <__panic>
    assert(*ptep & PTE_W);
c0104a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a08:	8b 00                	mov    (%eax),%eax
c0104a0a:	83 e0 02             	and    $0x2,%eax
c0104a0d:	85 c0                	test   %eax,%eax
c0104a0f:	75 24                	jne    c0104a35 <check_pgdir+0x363>
c0104a11:	c7 44 24 0c 6e 6c 10 	movl   $0xc0106c6e,0xc(%esp)
c0104a18:	c0 
c0104a19:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a20:	c0 
c0104a21:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104a28:	00 
c0104a29:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a30:	e8 91 c2 ff ff       	call   c0100cc6 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104a35:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a3a:	8b 00                	mov    (%eax),%eax
c0104a3c:	83 e0 04             	and    $0x4,%eax
c0104a3f:	85 c0                	test   %eax,%eax
c0104a41:	75 24                	jne    c0104a67 <check_pgdir+0x395>
c0104a43:	c7 44 24 0c 7c 6c 10 	movl   $0xc0106c7c,0xc(%esp)
c0104a4a:	c0 
c0104a4b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a52:	c0 
c0104a53:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104a5a:	00 
c0104a5b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a62:	e8 5f c2 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 1);
c0104a67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104a6a:	89 04 24             	mov    %eax,(%esp)
c0104a6d:	e8 a8 ef ff ff       	call   c0103a1a <page_ref>
c0104a72:	83 f8 01             	cmp    $0x1,%eax
c0104a75:	74 24                	je     c0104a9b <check_pgdir+0x3c9>
c0104a77:	c7 44 24 0c 92 6c 10 	movl   $0xc0106c92,0xc(%esp)
c0104a7e:	c0 
c0104a7f:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104a86:	c0 
c0104a87:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104a8e:	00 
c0104a8f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104a96:	e8 2b c2 ff ff       	call   c0100cc6 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104a9b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104aa0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104aa7:	00 
c0104aa8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104aaf:	00 
c0104ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ab3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ab7:	89 04 24             	mov    %eax,(%esp)
c0104aba:	e8 df fa ff ff       	call   c010459e <page_insert>
c0104abf:	85 c0                	test   %eax,%eax
c0104ac1:	74 24                	je     c0104ae7 <check_pgdir+0x415>
c0104ac3:	c7 44 24 0c a4 6c 10 	movl   $0xc0106ca4,0xc(%esp)
c0104aca:	c0 
c0104acb:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104ad2:	c0 
c0104ad3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104ada:	00 
c0104adb:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104ae2:	e8 df c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p1) == 2);
c0104ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aea:	89 04 24             	mov    %eax,(%esp)
c0104aed:	e8 28 ef ff ff       	call   c0103a1a <page_ref>
c0104af2:	83 f8 02             	cmp    $0x2,%eax
c0104af5:	74 24                	je     c0104b1b <check_pgdir+0x449>
c0104af7:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c0104afe:	c0 
c0104aff:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b06:	c0 
c0104b07:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b0e:	00 
c0104b0f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104b16:	e8 ab c1 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104b1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b1e:	89 04 24             	mov    %eax,(%esp)
c0104b21:	e8 f4 ee ff ff       	call   c0103a1a <page_ref>
c0104b26:	85 c0                	test   %eax,%eax
c0104b28:	74 24                	je     c0104b4e <check_pgdir+0x47c>
c0104b2a:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104b31:	c0 
c0104b32:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b39:	c0 
c0104b3a:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104b41:	00 
c0104b42:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104b49:	e8 78 c1 ff ff       	call   c0100cc6 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104b4e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b5a:	00 
c0104b5b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104b62:	00 
c0104b63:	89 04 24             	mov    %eax,(%esp)
c0104b66:	e8 f3 f7 ff ff       	call   c010435e <get_pte>
c0104b6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b72:	75 24                	jne    c0104b98 <check_pgdir+0x4c6>
c0104b74:	c7 44 24 0c 30 6c 10 	movl   $0xc0106c30,0xc(%esp)
c0104b7b:	c0 
c0104b7c:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104b83:	c0 
c0104b84:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b8b:	00 
c0104b8c:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104b93:	e8 2e c1 ff ff       	call   c0100cc6 <__panic>
    assert(pa2page(*ptep) == p1);
c0104b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b9b:	8b 00                	mov    (%eax),%eax
c0104b9d:	89 04 24             	mov    %eax,(%esp)
c0104ba0:	e8 94 ed ff ff       	call   c0103939 <pa2page>
c0104ba5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ba8:	74 24                	je     c0104bce <check_pgdir+0x4fc>
c0104baa:	c7 44 24 0c a9 6b 10 	movl   $0xc0106ba9,0xc(%esp)
c0104bb1:	c0 
c0104bb2:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104bb9:	c0 
c0104bba:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104bc1:	00 
c0104bc2:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104bc9:	e8 f8 c0 ff ff       	call   c0100cc6 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104bce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104bd1:	8b 00                	mov    (%eax),%eax
c0104bd3:	83 e0 04             	and    $0x4,%eax
c0104bd6:	85 c0                	test   %eax,%eax
c0104bd8:	74 24                	je     c0104bfe <check_pgdir+0x52c>
c0104bda:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c0104be1:	c0 
c0104be2:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104be9:	c0 
c0104bea:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104bf1:	00 
c0104bf2:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104bf9:	e8 c8 c0 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104bfe:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c03:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104c0a:	00 
c0104c0b:	89 04 24             	mov    %eax,(%esp)
c0104c0e:	e8 47 f9 ff ff       	call   c010455a <page_remove>
    assert(page_ref(p1) == 1);
c0104c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c16:	89 04 24             	mov    %eax,(%esp)
c0104c19:	e8 fc ed ff ff       	call   c0103a1a <page_ref>
c0104c1e:	83 f8 01             	cmp    $0x1,%eax
c0104c21:	74 24                	je     c0104c47 <check_pgdir+0x575>
c0104c23:	c7 44 24 0c be 6b 10 	movl   $0xc0106bbe,0xc(%esp)
c0104c2a:	c0 
c0104c2b:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104c32:	c0 
c0104c33:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104c3a:	00 
c0104c3b:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104c42:	e8 7f c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c4a:	89 04 24             	mov    %eax,(%esp)
c0104c4d:	e8 c8 ed ff ff       	call   c0103a1a <page_ref>
c0104c52:	85 c0                	test   %eax,%eax
c0104c54:	74 24                	je     c0104c7a <check_pgdir+0x5a8>
c0104c56:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104c5d:	c0 
c0104c5e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104c65:	c0 
c0104c66:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104c6d:	00 
c0104c6e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104c75:	e8 4c c0 ff ff       	call   c0100cc6 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104c7a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c7f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c86:	00 
c0104c87:	89 04 24             	mov    %eax,(%esp)
c0104c8a:	e8 cb f8 ff ff       	call   c010455a <page_remove>
    assert(page_ref(p1) == 0);
c0104c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c92:	89 04 24             	mov    %eax,(%esp)
c0104c95:	e8 80 ed ff ff       	call   c0103a1a <page_ref>
c0104c9a:	85 c0                	test   %eax,%eax
c0104c9c:	74 24                	je     c0104cc2 <check_pgdir+0x5f0>
c0104c9e:	c7 44 24 0c 09 6d 10 	movl   $0xc0106d09,0xc(%esp)
c0104ca5:	c0 
c0104ca6:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104cad:	c0 
c0104cae:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104cb5:	00 
c0104cb6:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104cbd:	e8 04 c0 ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p2) == 0);
c0104cc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104cc5:	89 04 24             	mov    %eax,(%esp)
c0104cc8:	e8 4d ed ff ff       	call   c0103a1a <page_ref>
c0104ccd:	85 c0                	test   %eax,%eax
c0104ccf:	74 24                	je     c0104cf5 <check_pgdir+0x623>
c0104cd1:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0104cd8:	c0 
c0104cd9:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104ce0:	c0 
c0104ce1:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104ce8:	00 
c0104ce9:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104cf0:	e8 d1 bf ff ff       	call   c0100cc6 <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104cf5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cfa:	8b 00                	mov    (%eax),%eax
c0104cfc:	89 04 24             	mov    %eax,(%esp)
c0104cff:	e8 35 ec ff ff       	call   c0103939 <pa2page>
c0104d04:	89 04 24             	mov    %eax,(%esp)
c0104d07:	e8 0e ed ff ff       	call   c0103a1a <page_ref>
c0104d0c:	83 f8 01             	cmp    $0x1,%eax
c0104d0f:	74 24                	je     c0104d35 <check_pgdir+0x663>
c0104d11:	c7 44 24 0c 1c 6d 10 	movl   $0xc0106d1c,0xc(%esp)
c0104d18:	c0 
c0104d19:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104d20:	c0 
c0104d21:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0104d28:	00 
c0104d29:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104d30:	e8 91 bf ff ff       	call   c0100cc6 <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104d35:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d3a:	8b 00                	mov    (%eax),%eax
c0104d3c:	89 04 24             	mov    %eax,(%esp)
c0104d3f:	e8 f5 eb ff ff       	call   c0103939 <pa2page>
c0104d44:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d4b:	00 
c0104d4c:	89 04 24             	mov    %eax,(%esp)
c0104d4f:	e8 03 ef ff ff       	call   c0103c57 <free_pages>
    boot_pgdir[0] = 0;
c0104d54:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d59:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104d5f:	c7 04 24 42 6d 10 c0 	movl   $0xc0106d42,(%esp)
c0104d66:	e8 d1 b5 ff ff       	call   c010033c <cprintf>
}
c0104d6b:	c9                   	leave  
c0104d6c:	c3                   	ret    

c0104d6d <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104d6d:	55                   	push   %ebp
c0104d6e:	89 e5                	mov    %esp,%ebp
c0104d70:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104d73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d7a:	e9 ca 00 00 00       	jmp    c0104e49 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d82:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d88:	c1 e8 0c             	shr    $0xc,%eax
c0104d8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d8e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104d93:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104d96:	72 23                	jb     c0104dbb <check_boot_pgdir+0x4e>
c0104d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d9b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104d9f:	c7 44 24 08 8c 69 10 	movl   $0xc010698c,0x8(%esp)
c0104da6:	c0 
c0104da7:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104dae:	00 
c0104daf:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104db6:	e8 0b bf ff ff       	call   c0100cc6 <__panic>
c0104dbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dbe:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104dc3:	89 c2                	mov    %eax,%edx
c0104dc5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104dca:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104dd1:	00 
c0104dd2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dd6:	89 04 24             	mov    %eax,(%esp)
c0104dd9:	e8 80 f5 ff ff       	call   c010435e <get_pte>
c0104dde:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104de1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104de5:	75 24                	jne    c0104e0b <check_boot_pgdir+0x9e>
c0104de7:	c7 44 24 0c 5c 6d 10 	movl   $0xc0106d5c,0xc(%esp)
c0104dee:	c0 
c0104def:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104df6:	c0 
c0104df7:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104dfe:	00 
c0104dff:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104e06:	e8 bb be ff ff       	call   c0100cc6 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104e0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e0e:	8b 00                	mov    (%eax),%eax
c0104e10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e15:	89 c2                	mov    %eax,%edx
c0104e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1a:	39 c2                	cmp    %eax,%edx
c0104e1c:	74 24                	je     c0104e42 <check_boot_pgdir+0xd5>
c0104e1e:	c7 44 24 0c 99 6d 10 	movl   $0xc0106d99,0xc(%esp)
c0104e25:	c0 
c0104e26:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104e2d:	c0 
c0104e2e:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0104e35:	00 
c0104e36:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104e3d:	e8 84 be ff ff       	call   c0100cc6 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e42:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e4c:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e51:	39 c2                	cmp    %eax,%edx
c0104e53:	0f 82 26 ff ff ff    	jb     c0104d7f <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104e59:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e5e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104e63:	8b 00                	mov    (%eax),%eax
c0104e65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104e6a:	89 c2                	mov    %eax,%edx
c0104e6c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e74:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104e7b:	77 23                	ja     c0104ea0 <check_boot_pgdir+0x133>
c0104e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e80:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e84:	c7 44 24 08 30 6a 10 	movl   $0xc0106a30,0x8(%esp)
c0104e8b:	c0 
c0104e8c:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104e93:	00 
c0104e94:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104e9b:	e8 26 be ff ff       	call   c0100cc6 <__panic>
c0104ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104ea3:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ea8:	39 c2                	cmp    %eax,%edx
c0104eaa:	74 24                	je     c0104ed0 <check_boot_pgdir+0x163>
c0104eac:	c7 44 24 0c b0 6d 10 	movl   $0xc0106db0,0xc(%esp)
c0104eb3:	c0 
c0104eb4:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104ebb:	c0 
c0104ebc:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0104ec3:	00 
c0104ec4:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104ecb:	e8 f6 bd ff ff       	call   c0100cc6 <__panic>

    assert(boot_pgdir[0] == 0);
c0104ed0:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104ed5:	8b 00                	mov    (%eax),%eax
c0104ed7:	85 c0                	test   %eax,%eax
c0104ed9:	74 24                	je     c0104eff <check_boot_pgdir+0x192>
c0104edb:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104ee2:	c0 
c0104ee3:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104eea:	c0 
c0104eeb:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104ef2:	00 
c0104ef3:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104efa:	e8 c7 bd ff ff       	call   c0100cc6 <__panic>

    struct Page *p;
    p = alloc_page();
c0104eff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f06:	e8 14 ed ff ff       	call   c0103c1f <alloc_pages>
c0104f0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104f0e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f13:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f1a:	00 
c0104f1b:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104f22:	00 
c0104f23:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f26:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f2a:	89 04 24             	mov    %eax,(%esp)
c0104f2d:	e8 6c f6 ff ff       	call   c010459e <page_insert>
c0104f32:	85 c0                	test   %eax,%eax
c0104f34:	74 24                	je     c0104f5a <check_boot_pgdir+0x1ed>
c0104f36:	c7 44 24 0c f8 6d 10 	movl   $0xc0106df8,0xc(%esp)
c0104f3d:	c0 
c0104f3e:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104f45:	c0 
c0104f46:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0104f4d:	00 
c0104f4e:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104f55:	e8 6c bd ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 1);
c0104f5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f5d:	89 04 24             	mov    %eax,(%esp)
c0104f60:	e8 b5 ea ff ff       	call   c0103a1a <page_ref>
c0104f65:	83 f8 01             	cmp    $0x1,%eax
c0104f68:	74 24                	je     c0104f8e <check_boot_pgdir+0x221>
c0104f6a:	c7 44 24 0c 26 6e 10 	movl   $0xc0106e26,0xc(%esp)
c0104f71:	c0 
c0104f72:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104f79:	c0 
c0104f7a:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0104f81:	00 
c0104f82:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104f89:	e8 38 bd ff ff       	call   c0100cc6 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104f8e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f93:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104f9a:	00 
c0104f9b:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104fa2:	00 
c0104fa3:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fa6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104faa:	89 04 24             	mov    %eax,(%esp)
c0104fad:	e8 ec f5 ff ff       	call   c010459e <page_insert>
c0104fb2:	85 c0                	test   %eax,%eax
c0104fb4:	74 24                	je     c0104fda <check_boot_pgdir+0x26d>
c0104fb6:	c7 44 24 0c 38 6e 10 	movl   $0xc0106e38,0xc(%esp)
c0104fbd:	c0 
c0104fbe:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104fc5:	c0 
c0104fc6:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0104fcd:	00 
c0104fce:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0104fd5:	e8 ec bc ff ff       	call   c0100cc6 <__panic>
    assert(page_ref(p) == 2);
c0104fda:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fdd:	89 04 24             	mov    %eax,(%esp)
c0104fe0:	e8 35 ea ff ff       	call   c0103a1a <page_ref>
c0104fe5:	83 f8 02             	cmp    $0x2,%eax
c0104fe8:	74 24                	je     c010500e <check_boot_pgdir+0x2a1>
c0104fea:	c7 44 24 0c 6f 6e 10 	movl   $0xc0106e6f,0xc(%esp)
c0104ff1:	c0 
c0104ff2:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0104ff9:	c0 
c0104ffa:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105001:	00 
c0105002:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c0105009:	e8 b8 bc ff ff       	call   c0100cc6 <__panic>

    const char *str = "ucore: Hello world!!";
c010500e:	c7 45 dc 80 6e 10 c0 	movl   $0xc0106e80,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105015:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105018:	89 44 24 04          	mov    %eax,0x4(%esp)
c010501c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105023:	e8 1e 0a 00 00       	call   c0105a46 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105028:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010502f:	00 
c0105030:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105037:	e8 83 0a 00 00       	call   c0105abf <strcmp>
c010503c:	85 c0                	test   %eax,%eax
c010503e:	74 24                	je     c0105064 <check_boot_pgdir+0x2f7>
c0105040:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0105047:	c0 
c0105048:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c010504f:	c0 
c0105050:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c0105057:	00 
c0105058:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c010505f:	e8 62 bc ff ff       	call   c0100cc6 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105064:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105067:	89 04 24             	mov    %eax,(%esp)
c010506a:	e8 19 e9 ff ff       	call   c0103988 <page2kva>
c010506f:	05 00 01 00 00       	add    $0x100,%eax
c0105074:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105077:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010507e:	e8 6b 09 00 00       	call   c01059ee <strlen>
c0105083:	85 c0                	test   %eax,%eax
c0105085:	74 24                	je     c01050ab <check_boot_pgdir+0x33e>
c0105087:	c7 44 24 0c d0 6e 10 	movl   $0xc0106ed0,0xc(%esp)
c010508e:	c0 
c010508f:	c7 44 24 08 79 6a 10 	movl   $0xc0106a79,0x8(%esp)
c0105096:	c0 
c0105097:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c010509e:	00 
c010509f:	c7 04 24 54 6a 10 c0 	movl   $0xc0106a54,(%esp)
c01050a6:	e8 1b bc ff ff       	call   c0100cc6 <__panic>

    free_page(p);
c01050ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050b2:	00 
c01050b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050b6:	89 04 24             	mov    %eax,(%esp)
c01050b9:	e8 99 eb ff ff       	call   c0103c57 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01050be:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050c3:	8b 00                	mov    (%eax),%eax
c01050c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01050ca:	89 04 24             	mov    %eax,(%esp)
c01050cd:	e8 67 e8 ff ff       	call   c0103939 <pa2page>
c01050d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050d9:	00 
c01050da:	89 04 24             	mov    %eax,(%esp)
c01050dd:	e8 75 eb ff ff       	call   c0103c57 <free_pages>
    boot_pgdir[0] = 0;
c01050e2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01050e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01050ed:	c7 04 24 f4 6e 10 c0 	movl   $0xc0106ef4,(%esp)
c01050f4:	e8 43 b2 ff ff       	call   c010033c <cprintf>
}
c01050f9:	c9                   	leave  
c01050fa:	c3                   	ret    

c01050fb <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01050fb:	55                   	push   %ebp
c01050fc:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01050fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105101:	83 e0 04             	and    $0x4,%eax
c0105104:	85 c0                	test   %eax,%eax
c0105106:	74 07                	je     c010510f <perm2str+0x14>
c0105108:	b8 75 00 00 00       	mov    $0x75,%eax
c010510d:	eb 05                	jmp    c0105114 <perm2str+0x19>
c010510f:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105114:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105119:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105120:	8b 45 08             	mov    0x8(%ebp),%eax
c0105123:	83 e0 02             	and    $0x2,%eax
c0105126:	85 c0                	test   %eax,%eax
c0105128:	74 07                	je     c0105131 <perm2str+0x36>
c010512a:	b8 77 00 00 00       	mov    $0x77,%eax
c010512f:	eb 05                	jmp    c0105136 <perm2str+0x3b>
c0105131:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105136:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010513b:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105142:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105147:	5d                   	pop    %ebp
c0105148:	c3                   	ret    

c0105149 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105149:	55                   	push   %ebp
c010514a:	89 e5                	mov    %esp,%ebp
c010514c:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010514f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105152:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105155:	72 0a                	jb     c0105161 <get_pgtable_items+0x18>
        return 0;
c0105157:	b8 00 00 00 00       	mov    $0x0,%eax
c010515c:	e9 9c 00 00 00       	jmp    c01051fd <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105161:	eb 04                	jmp    c0105167 <get_pgtable_items+0x1e>
        start ++;
c0105163:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105167:	8b 45 10             	mov    0x10(%ebp),%eax
c010516a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010516d:	73 18                	jae    c0105187 <get_pgtable_items+0x3e>
c010516f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105172:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105179:	8b 45 14             	mov    0x14(%ebp),%eax
c010517c:	01 d0                	add    %edx,%eax
c010517e:	8b 00                	mov    (%eax),%eax
c0105180:	83 e0 01             	and    $0x1,%eax
c0105183:	85 c0                	test   %eax,%eax
c0105185:	74 dc                	je     c0105163 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105187:	8b 45 10             	mov    0x10(%ebp),%eax
c010518a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010518d:	73 69                	jae    c01051f8 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010518f:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105193:	74 08                	je     c010519d <get_pgtable_items+0x54>
            *left_store = start;
c0105195:	8b 45 18             	mov    0x18(%ebp),%eax
c0105198:	8b 55 10             	mov    0x10(%ebp),%edx
c010519b:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010519d:	8b 45 10             	mov    0x10(%ebp),%eax
c01051a0:	8d 50 01             	lea    0x1(%eax),%edx
c01051a3:	89 55 10             	mov    %edx,0x10(%ebp)
c01051a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051ad:	8b 45 14             	mov    0x14(%ebp),%eax
c01051b0:	01 d0                	add    %edx,%eax
c01051b2:	8b 00                	mov    (%eax),%eax
c01051b4:	83 e0 07             	and    $0x7,%eax
c01051b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051ba:	eb 04                	jmp    c01051c0 <get_pgtable_items+0x77>
            start ++;
c01051bc:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01051c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01051c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051c6:	73 1d                	jae    c01051e5 <get_pgtable_items+0x9c>
c01051c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01051cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01051d2:	8b 45 14             	mov    0x14(%ebp),%eax
c01051d5:	01 d0                	add    %edx,%eax
c01051d7:	8b 00                	mov    (%eax),%eax
c01051d9:	83 e0 07             	and    $0x7,%eax
c01051dc:	89 c2                	mov    %eax,%edx
c01051de:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051e1:	39 c2                	cmp    %eax,%edx
c01051e3:	74 d7                	je     c01051bc <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01051e5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01051e9:	74 08                	je     c01051f3 <get_pgtable_items+0xaa>
            *right_store = start;
c01051eb:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01051ee:	8b 55 10             	mov    0x10(%ebp),%edx
c01051f1:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01051f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01051f6:	eb 05                	jmp    c01051fd <get_pgtable_items+0xb4>
    }
    return 0;
c01051f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01051fd:	c9                   	leave  
c01051fe:	c3                   	ret    

c01051ff <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01051ff:	55                   	push   %ebp
c0105200:	89 e5                	mov    %esp,%ebp
c0105202:	57                   	push   %edi
c0105203:	56                   	push   %esi
c0105204:	53                   	push   %ebx
c0105205:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105208:	c7 04 24 14 6f 10 c0 	movl   $0xc0106f14,(%esp)
c010520f:	e8 28 b1 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105214:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010521b:	e9 fa 00 00 00       	jmp    c010531a <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105223:	89 04 24             	mov    %eax,(%esp)
c0105226:	e8 d0 fe ff ff       	call   c01050fb <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010522b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010522e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105231:	29 d1                	sub    %edx,%ecx
c0105233:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105235:	89 d6                	mov    %edx,%esi
c0105237:	c1 e6 16             	shl    $0x16,%esi
c010523a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010523d:	89 d3                	mov    %edx,%ebx
c010523f:	c1 e3 16             	shl    $0x16,%ebx
c0105242:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105245:	89 d1                	mov    %edx,%ecx
c0105247:	c1 e1 16             	shl    $0x16,%ecx
c010524a:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010524d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105250:	29 d7                	sub    %edx,%edi
c0105252:	89 fa                	mov    %edi,%edx
c0105254:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105258:	89 74 24 10          	mov    %esi,0x10(%esp)
c010525c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105260:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105264:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105268:	c7 04 24 45 6f 10 c0 	movl   $0xc0106f45,(%esp)
c010526f:	e8 c8 b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105274:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105277:	c1 e0 0a             	shl    $0xa,%eax
c010527a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010527d:	eb 54                	jmp    c01052d3 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010527f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105282:	89 04 24             	mov    %eax,(%esp)
c0105285:	e8 71 fe ff ff       	call   c01050fb <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c010528a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010528d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105290:	29 d1                	sub    %edx,%ecx
c0105292:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105294:	89 d6                	mov    %edx,%esi
c0105296:	c1 e6 0c             	shl    $0xc,%esi
c0105299:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010529c:	89 d3                	mov    %edx,%ebx
c010529e:	c1 e3 0c             	shl    $0xc,%ebx
c01052a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052a4:	c1 e2 0c             	shl    $0xc,%edx
c01052a7:	89 d1                	mov    %edx,%ecx
c01052a9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01052ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01052af:	29 d7                	sub    %edx,%edi
c01052b1:	89 fa                	mov    %edi,%edx
c01052b3:	89 44 24 14          	mov    %eax,0x14(%esp)
c01052b7:	89 74 24 10          	mov    %esi,0x10(%esp)
c01052bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01052bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01052c3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052c7:	c7 04 24 64 6f 10 c0 	movl   $0xc0106f64,(%esp)
c01052ce:	e8 69 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01052d3:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01052d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01052db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052de:	89 ce                	mov    %ecx,%esi
c01052e0:	c1 e6 0a             	shl    $0xa,%esi
c01052e3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01052e6:	89 cb                	mov    %ecx,%ebx
c01052e8:	c1 e3 0a             	shl    $0xa,%ebx
c01052eb:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01052ee:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01052f2:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01052f5:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01052f9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01052fd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105301:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105305:	89 1c 24             	mov    %ebx,(%esp)
c0105308:	e8 3c fe ff ff       	call   c0105149 <get_pgtable_items>
c010530d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105310:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105314:	0f 85 65 ff ff ff    	jne    c010527f <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010531a:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010531f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105322:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105325:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105329:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010532c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105330:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105334:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105338:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010533f:	00 
c0105340:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105347:	e8 fd fd ff ff       	call   c0105149 <get_pgtable_items>
c010534c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010534f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105353:	0f 85 c7 fe ff ff    	jne    c0105220 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105359:	c7 04 24 88 6f 10 c0 	movl   $0xc0106f88,(%esp)
c0105360:	e8 d7 af ff ff       	call   c010033c <cprintf>
}
c0105365:	83 c4 4c             	add    $0x4c,%esp
c0105368:	5b                   	pop    %ebx
c0105369:	5e                   	pop    %esi
c010536a:	5f                   	pop    %edi
c010536b:	5d                   	pop    %ebp
c010536c:	c3                   	ret    

c010536d <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010536d:	55                   	push   %ebp
c010536e:	89 e5                	mov    %esp,%ebp
c0105370:	83 ec 58             	sub    $0x58,%esp
c0105373:	8b 45 10             	mov    0x10(%ebp),%eax
c0105376:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105379:	8b 45 14             	mov    0x14(%ebp),%eax
c010537c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010537f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105382:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105385:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105388:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010538b:	8b 45 18             	mov    0x18(%ebp),%eax
c010538e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105391:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105394:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105397:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010539a:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010539d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053a7:	74 1c                	je     c01053c5 <printnum+0x58>
c01053a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053ac:	ba 00 00 00 00       	mov    $0x0,%edx
c01053b1:	f7 75 e4             	divl   -0x1c(%ebp)
c01053b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01053b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01053ba:	ba 00 00 00 00       	mov    $0x0,%edx
c01053bf:	f7 75 e4             	divl   -0x1c(%ebp)
c01053c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01053c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01053cb:	f7 75 e4             	divl   -0x1c(%ebp)
c01053ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01053d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01053d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01053da:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053dd:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01053e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053e3:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01053e6:	8b 45 18             	mov    0x18(%ebp),%eax
c01053e9:	ba 00 00 00 00       	mov    $0x0,%edx
c01053ee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053f1:	77 56                	ja     c0105449 <printnum+0xdc>
c01053f3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01053f6:	72 05                	jb     c01053fd <printnum+0x90>
c01053f8:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01053fb:	77 4c                	ja     c0105449 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01053fd:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105400:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105403:	8b 45 20             	mov    0x20(%ebp),%eax
c0105406:	89 44 24 18          	mov    %eax,0x18(%esp)
c010540a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010540e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105411:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105415:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105418:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010541b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010541f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105423:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105426:	89 44 24 04          	mov    %eax,0x4(%esp)
c010542a:	8b 45 08             	mov    0x8(%ebp),%eax
c010542d:	89 04 24             	mov    %eax,(%esp)
c0105430:	e8 38 ff ff ff       	call   c010536d <printnum>
c0105435:	eb 1c                	jmp    c0105453 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105437:	8b 45 0c             	mov    0xc(%ebp),%eax
c010543a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010543e:	8b 45 20             	mov    0x20(%ebp),%eax
c0105441:	89 04 24             	mov    %eax,(%esp)
c0105444:	8b 45 08             	mov    0x8(%ebp),%eax
c0105447:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105449:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010544d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105451:	7f e4                	jg     c0105437 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105453:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105456:	05 3c 70 10 c0       	add    $0xc010703c,%eax
c010545b:	0f b6 00             	movzbl (%eax),%eax
c010545e:	0f be c0             	movsbl %al,%eax
c0105461:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105464:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105468:	89 04 24             	mov    %eax,(%esp)
c010546b:	8b 45 08             	mov    0x8(%ebp),%eax
c010546e:	ff d0                	call   *%eax
}
c0105470:	c9                   	leave  
c0105471:	c3                   	ret    

c0105472 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105472:	55                   	push   %ebp
c0105473:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105475:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105479:	7e 14                	jle    c010548f <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010547b:	8b 45 08             	mov    0x8(%ebp),%eax
c010547e:	8b 00                	mov    (%eax),%eax
c0105480:	8d 48 08             	lea    0x8(%eax),%ecx
c0105483:	8b 55 08             	mov    0x8(%ebp),%edx
c0105486:	89 0a                	mov    %ecx,(%edx)
c0105488:	8b 50 04             	mov    0x4(%eax),%edx
c010548b:	8b 00                	mov    (%eax),%eax
c010548d:	eb 30                	jmp    c01054bf <getuint+0x4d>
    }
    else if (lflag) {
c010548f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105493:	74 16                	je     c01054ab <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105495:	8b 45 08             	mov    0x8(%ebp),%eax
c0105498:	8b 00                	mov    (%eax),%eax
c010549a:	8d 48 04             	lea    0x4(%eax),%ecx
c010549d:	8b 55 08             	mov    0x8(%ebp),%edx
c01054a0:	89 0a                	mov    %ecx,(%edx)
c01054a2:	8b 00                	mov    (%eax),%eax
c01054a4:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a9:	eb 14                	jmp    c01054bf <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01054ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ae:	8b 00                	mov    (%eax),%eax
c01054b0:	8d 48 04             	lea    0x4(%eax),%ecx
c01054b3:	8b 55 08             	mov    0x8(%ebp),%edx
c01054b6:	89 0a                	mov    %ecx,(%edx)
c01054b8:	8b 00                	mov    (%eax),%eax
c01054ba:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01054bf:	5d                   	pop    %ebp
c01054c0:	c3                   	ret    

c01054c1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01054c1:	55                   	push   %ebp
c01054c2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01054c4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01054c8:	7e 14                	jle    c01054de <getint+0x1d>
        return va_arg(*ap, long long);
c01054ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01054cd:	8b 00                	mov    (%eax),%eax
c01054cf:	8d 48 08             	lea    0x8(%eax),%ecx
c01054d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01054d5:	89 0a                	mov    %ecx,(%edx)
c01054d7:	8b 50 04             	mov    0x4(%eax),%edx
c01054da:	8b 00                	mov    (%eax),%eax
c01054dc:	eb 28                	jmp    c0105506 <getint+0x45>
    }
    else if (lflag) {
c01054de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01054e2:	74 12                	je     c01054f6 <getint+0x35>
        return va_arg(*ap, long);
c01054e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e7:	8b 00                	mov    (%eax),%eax
c01054e9:	8d 48 04             	lea    0x4(%eax),%ecx
c01054ec:	8b 55 08             	mov    0x8(%ebp),%edx
c01054ef:	89 0a                	mov    %ecx,(%edx)
c01054f1:	8b 00                	mov    (%eax),%eax
c01054f3:	99                   	cltd   
c01054f4:	eb 10                	jmp    c0105506 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01054f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054f9:	8b 00                	mov    (%eax),%eax
c01054fb:	8d 48 04             	lea    0x4(%eax),%ecx
c01054fe:	8b 55 08             	mov    0x8(%ebp),%edx
c0105501:	89 0a                	mov    %ecx,(%edx)
c0105503:	8b 00                	mov    (%eax),%eax
c0105505:	99                   	cltd   
    }
}
c0105506:	5d                   	pop    %ebp
c0105507:	c3                   	ret    

c0105508 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105508:	55                   	push   %ebp
c0105509:	89 e5                	mov    %esp,%ebp
c010550b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010550e:	8d 45 14             	lea    0x14(%ebp),%eax
c0105511:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105514:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105517:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010551b:	8b 45 10             	mov    0x10(%ebp),%eax
c010551e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105525:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105529:	8b 45 08             	mov    0x8(%ebp),%eax
c010552c:	89 04 24             	mov    %eax,(%esp)
c010552f:	e8 02 00 00 00       	call   c0105536 <vprintfmt>
    va_end(ap);
}
c0105534:	c9                   	leave  
c0105535:	c3                   	ret    

c0105536 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105536:	55                   	push   %ebp
c0105537:	89 e5                	mov    %esp,%ebp
c0105539:	56                   	push   %esi
c010553a:	53                   	push   %ebx
c010553b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010553e:	eb 18                	jmp    c0105558 <vprintfmt+0x22>
            if (ch == '\0') {
c0105540:	85 db                	test   %ebx,%ebx
c0105542:	75 05                	jne    c0105549 <vprintfmt+0x13>
                return;
c0105544:	e9 d1 03 00 00       	jmp    c010591a <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010554c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105550:	89 1c 24             	mov    %ebx,(%esp)
c0105553:	8b 45 08             	mov    0x8(%ebp),%eax
c0105556:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105558:	8b 45 10             	mov    0x10(%ebp),%eax
c010555b:	8d 50 01             	lea    0x1(%eax),%edx
c010555e:	89 55 10             	mov    %edx,0x10(%ebp)
c0105561:	0f b6 00             	movzbl (%eax),%eax
c0105564:	0f b6 d8             	movzbl %al,%ebx
c0105567:	83 fb 25             	cmp    $0x25,%ebx
c010556a:	75 d4                	jne    c0105540 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010556c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105570:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105577:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010557a:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010557d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105584:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105587:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010558a:	8b 45 10             	mov    0x10(%ebp),%eax
c010558d:	8d 50 01             	lea    0x1(%eax),%edx
c0105590:	89 55 10             	mov    %edx,0x10(%ebp)
c0105593:	0f b6 00             	movzbl (%eax),%eax
c0105596:	0f b6 d8             	movzbl %al,%ebx
c0105599:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010559c:	83 f8 55             	cmp    $0x55,%eax
c010559f:	0f 87 44 03 00 00    	ja     c01058e9 <vprintfmt+0x3b3>
c01055a5:	8b 04 85 60 70 10 c0 	mov    -0x3fef8fa0(,%eax,4),%eax
c01055ac:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01055ae:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01055b2:	eb d6                	jmp    c010558a <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01055b4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01055b8:	eb d0                	jmp    c010558a <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01055c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055c4:	89 d0                	mov    %edx,%eax
c01055c6:	c1 e0 02             	shl    $0x2,%eax
c01055c9:	01 d0                	add    %edx,%eax
c01055cb:	01 c0                	add    %eax,%eax
c01055cd:	01 d8                	add    %ebx,%eax
c01055cf:	83 e8 30             	sub    $0x30,%eax
c01055d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01055d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01055d8:	0f b6 00             	movzbl (%eax),%eax
c01055db:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01055de:	83 fb 2f             	cmp    $0x2f,%ebx
c01055e1:	7e 0b                	jle    c01055ee <vprintfmt+0xb8>
c01055e3:	83 fb 39             	cmp    $0x39,%ebx
c01055e6:	7f 06                	jg     c01055ee <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01055e8:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01055ec:	eb d3                	jmp    c01055c1 <vprintfmt+0x8b>
            goto process_precision;
c01055ee:	eb 33                	jmp    c0105623 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01055f0:	8b 45 14             	mov    0x14(%ebp),%eax
c01055f3:	8d 50 04             	lea    0x4(%eax),%edx
c01055f6:	89 55 14             	mov    %edx,0x14(%ebp)
c01055f9:	8b 00                	mov    (%eax),%eax
c01055fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01055fe:	eb 23                	jmp    c0105623 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105600:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105604:	79 0c                	jns    c0105612 <vprintfmt+0xdc>
                width = 0;
c0105606:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010560d:	e9 78 ff ff ff       	jmp    c010558a <vprintfmt+0x54>
c0105612:	e9 73 ff ff ff       	jmp    c010558a <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105617:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010561e:	e9 67 ff ff ff       	jmp    c010558a <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105623:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105627:	79 12                	jns    c010563b <vprintfmt+0x105>
                width = precision, precision = -1;
c0105629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010562c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010562f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105636:	e9 4f ff ff ff       	jmp    c010558a <vprintfmt+0x54>
c010563b:	e9 4a ff ff ff       	jmp    c010558a <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105640:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105644:	e9 41 ff ff ff       	jmp    c010558a <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105649:	8b 45 14             	mov    0x14(%ebp),%eax
c010564c:	8d 50 04             	lea    0x4(%eax),%edx
c010564f:	89 55 14             	mov    %edx,0x14(%ebp)
c0105652:	8b 00                	mov    (%eax),%eax
c0105654:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105657:	89 54 24 04          	mov    %edx,0x4(%esp)
c010565b:	89 04 24             	mov    %eax,(%esp)
c010565e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105661:	ff d0                	call   *%eax
            break;
c0105663:	e9 ac 02 00 00       	jmp    c0105914 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105668:	8b 45 14             	mov    0x14(%ebp),%eax
c010566b:	8d 50 04             	lea    0x4(%eax),%edx
c010566e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105671:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105673:	85 db                	test   %ebx,%ebx
c0105675:	79 02                	jns    c0105679 <vprintfmt+0x143>
                err = -err;
c0105677:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105679:	83 fb 06             	cmp    $0x6,%ebx
c010567c:	7f 0b                	jg     c0105689 <vprintfmt+0x153>
c010567e:	8b 34 9d 20 70 10 c0 	mov    -0x3fef8fe0(,%ebx,4),%esi
c0105685:	85 f6                	test   %esi,%esi
c0105687:	75 23                	jne    c01056ac <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105689:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010568d:	c7 44 24 08 4d 70 10 	movl   $0xc010704d,0x8(%esp)
c0105694:	c0 
c0105695:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105698:	89 44 24 04          	mov    %eax,0x4(%esp)
c010569c:	8b 45 08             	mov    0x8(%ebp),%eax
c010569f:	89 04 24             	mov    %eax,(%esp)
c01056a2:	e8 61 fe ff ff       	call   c0105508 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01056a7:	e9 68 02 00 00       	jmp    c0105914 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01056ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01056b0:	c7 44 24 08 56 70 10 	movl   $0xc0107056,0x8(%esp)
c01056b7:	c0 
c01056b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c2:	89 04 24             	mov    %eax,(%esp)
c01056c5:	e8 3e fe ff ff       	call   c0105508 <printfmt>
            }
            break;
c01056ca:	e9 45 02 00 00       	jmp    c0105914 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01056cf:	8b 45 14             	mov    0x14(%ebp),%eax
c01056d2:	8d 50 04             	lea    0x4(%eax),%edx
c01056d5:	89 55 14             	mov    %edx,0x14(%ebp)
c01056d8:	8b 30                	mov    (%eax),%esi
c01056da:	85 f6                	test   %esi,%esi
c01056dc:	75 05                	jne    c01056e3 <vprintfmt+0x1ad>
                p = "(null)";
c01056de:	be 59 70 10 c0       	mov    $0xc0107059,%esi
            }
            if (width > 0 && padc != '-') {
c01056e3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056e7:	7e 3e                	jle    c0105727 <vprintfmt+0x1f1>
c01056e9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01056ed:	74 38                	je     c0105727 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01056ef:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01056f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056f9:	89 34 24             	mov    %esi,(%esp)
c01056fc:	e8 15 03 00 00       	call   c0105a16 <strnlen>
c0105701:	29 c3                	sub    %eax,%ebx
c0105703:	89 d8                	mov    %ebx,%eax
c0105705:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105708:	eb 17                	jmp    c0105721 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c010570a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010570e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105711:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105715:	89 04 24             	mov    %eax,(%esp)
c0105718:	8b 45 08             	mov    0x8(%ebp),%eax
c010571b:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010571d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105721:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105725:	7f e3                	jg     c010570a <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105727:	eb 38                	jmp    c0105761 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105729:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010572d:	74 1f                	je     c010574e <vprintfmt+0x218>
c010572f:	83 fb 1f             	cmp    $0x1f,%ebx
c0105732:	7e 05                	jle    c0105739 <vprintfmt+0x203>
c0105734:	83 fb 7e             	cmp    $0x7e,%ebx
c0105737:	7e 15                	jle    c010574e <vprintfmt+0x218>
                    putch('?', putdat);
c0105739:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105740:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105747:	8b 45 08             	mov    0x8(%ebp),%eax
c010574a:	ff d0                	call   *%eax
c010574c:	eb 0f                	jmp    c010575d <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010574e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105751:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105755:	89 1c 24             	mov    %ebx,(%esp)
c0105758:	8b 45 08             	mov    0x8(%ebp),%eax
c010575b:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010575d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105761:	89 f0                	mov    %esi,%eax
c0105763:	8d 70 01             	lea    0x1(%eax),%esi
c0105766:	0f b6 00             	movzbl (%eax),%eax
c0105769:	0f be d8             	movsbl %al,%ebx
c010576c:	85 db                	test   %ebx,%ebx
c010576e:	74 10                	je     c0105780 <vprintfmt+0x24a>
c0105770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105774:	78 b3                	js     c0105729 <vprintfmt+0x1f3>
c0105776:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010577a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010577e:	79 a9                	jns    c0105729 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105780:	eb 17                	jmp    c0105799 <vprintfmt+0x263>
                putch(' ', putdat);
c0105782:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105785:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105789:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105795:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105799:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010579d:	7f e3                	jg     c0105782 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010579f:	e9 70 01 00 00       	jmp    c0105914 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01057a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057a7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ab:	8d 45 14             	lea    0x14(%ebp),%eax
c01057ae:	89 04 24             	mov    %eax,(%esp)
c01057b1:	e8 0b fd ff ff       	call   c01054c1 <getint>
c01057b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01057bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057c2:	85 d2                	test   %edx,%edx
c01057c4:	79 26                	jns    c01057ec <vprintfmt+0x2b6>
                putch('-', putdat);
c01057c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057cd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01057d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d7:	ff d0                	call   *%eax
                num = -(long long)num;
c01057d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057df:	f7 d8                	neg    %eax
c01057e1:	83 d2 00             	adc    $0x0,%edx
c01057e4:	f7 da                	neg    %edx
c01057e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01057ec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01057f3:	e9 a8 00 00 00       	jmp    c01058a0 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01057f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01057fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ff:	8d 45 14             	lea    0x14(%ebp),%eax
c0105802:	89 04 24             	mov    %eax,(%esp)
c0105805:	e8 68 fc ff ff       	call   c0105472 <getuint>
c010580a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010580d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105810:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105817:	e9 84 00 00 00       	jmp    c01058a0 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010581c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010581f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105823:	8d 45 14             	lea    0x14(%ebp),%eax
c0105826:	89 04 24             	mov    %eax,(%esp)
c0105829:	e8 44 fc ff ff       	call   c0105472 <getuint>
c010582e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105831:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105834:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010583b:	eb 63                	jmp    c01058a0 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010583d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105840:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105844:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010584b:	8b 45 08             	mov    0x8(%ebp),%eax
c010584e:	ff d0                	call   *%eax
            putch('x', putdat);
c0105850:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105853:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105857:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010585e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105861:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105863:	8b 45 14             	mov    0x14(%ebp),%eax
c0105866:	8d 50 04             	lea    0x4(%eax),%edx
c0105869:	89 55 14             	mov    %edx,0x14(%ebp)
c010586c:	8b 00                	mov    (%eax),%eax
c010586e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105871:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105878:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010587f:	eb 1f                	jmp    c01058a0 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105881:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105884:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105888:	8d 45 14             	lea    0x14(%ebp),%eax
c010588b:	89 04 24             	mov    %eax,(%esp)
c010588e:	e8 df fb ff ff       	call   c0105472 <getuint>
c0105893:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105896:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105899:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01058a0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01058a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01058a7:	89 54 24 18          	mov    %edx,0x18(%esp)
c01058ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01058ae:	89 54 24 14          	mov    %edx,0x14(%esp)
c01058b2:	89 44 24 10          	mov    %eax,0x10(%esp)
c01058b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058bc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058c0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01058c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01058ce:	89 04 24             	mov    %eax,(%esp)
c01058d1:	e8 97 fa ff ff       	call   c010536d <printnum>
            break;
c01058d6:	eb 3c                	jmp    c0105914 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01058d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058df:	89 1c 24             	mov    %ebx,(%esp)
c01058e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e5:	ff d0                	call   *%eax
            break;
c01058e7:	eb 2b                	jmp    c0105914 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01058e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058f0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01058f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fa:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01058fc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105900:	eb 04                	jmp    c0105906 <vprintfmt+0x3d0>
c0105902:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105906:	8b 45 10             	mov    0x10(%ebp),%eax
c0105909:	83 e8 01             	sub    $0x1,%eax
c010590c:	0f b6 00             	movzbl (%eax),%eax
c010590f:	3c 25                	cmp    $0x25,%al
c0105911:	75 ef                	jne    c0105902 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105913:	90                   	nop
        }
    }
c0105914:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105915:	e9 3e fc ff ff       	jmp    c0105558 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010591a:	83 c4 40             	add    $0x40,%esp
c010591d:	5b                   	pop    %ebx
c010591e:	5e                   	pop    %esi
c010591f:	5d                   	pop    %ebp
c0105920:	c3                   	ret    

c0105921 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105921:	55                   	push   %ebp
c0105922:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105924:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105927:	8b 40 08             	mov    0x8(%eax),%eax
c010592a:	8d 50 01             	lea    0x1(%eax),%edx
c010592d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105930:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105933:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105936:	8b 10                	mov    (%eax),%edx
c0105938:	8b 45 0c             	mov    0xc(%ebp),%eax
c010593b:	8b 40 04             	mov    0x4(%eax),%eax
c010593e:	39 c2                	cmp    %eax,%edx
c0105940:	73 12                	jae    c0105954 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105942:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105945:	8b 00                	mov    (%eax),%eax
c0105947:	8d 48 01             	lea    0x1(%eax),%ecx
c010594a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010594d:	89 0a                	mov    %ecx,(%edx)
c010594f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105952:	88 10                	mov    %dl,(%eax)
    }
}
c0105954:	5d                   	pop    %ebp
c0105955:	c3                   	ret    

c0105956 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105956:	55                   	push   %ebp
c0105957:	89 e5                	mov    %esp,%ebp
c0105959:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010595c:	8d 45 14             	lea    0x14(%ebp),%eax
c010595f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105962:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105965:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105969:	8b 45 10             	mov    0x10(%ebp),%eax
c010596c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105970:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105973:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105977:	8b 45 08             	mov    0x8(%ebp),%eax
c010597a:	89 04 24             	mov    %eax,(%esp)
c010597d:	e8 08 00 00 00       	call   c010598a <vsnprintf>
c0105982:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105985:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105988:	c9                   	leave  
c0105989:	c3                   	ret    

c010598a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010598a:	55                   	push   %ebp
c010598b:	89 e5                	mov    %esp,%ebp
c010598d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105990:	8b 45 08             	mov    0x8(%ebp),%eax
c0105993:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105996:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105999:	8d 50 ff             	lea    -0x1(%eax),%edx
c010599c:	8b 45 08             	mov    0x8(%ebp),%eax
c010599f:	01 d0                	add    %edx,%eax
c01059a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01059ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01059af:	74 0a                	je     c01059bb <vsnprintf+0x31>
c01059b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01059b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059b7:	39 c2                	cmp    %eax,%edx
c01059b9:	76 07                	jbe    c01059c2 <vsnprintf+0x38>
        return -E_INVAL;
c01059bb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01059c0:	eb 2a                	jmp    c01059ec <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01059c2:	8b 45 14             	mov    0x14(%ebp),%eax
c01059c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01059cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059d0:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01059d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059d7:	c7 04 24 21 59 10 c0 	movl   $0xc0105921,(%esp)
c01059de:	e8 53 fb ff ff       	call   c0105536 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01059e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059e6:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01059e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01059ec:	c9                   	leave  
c01059ed:	c3                   	ret    

c01059ee <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01059ee:	55                   	push   %ebp
c01059ef:	89 e5                	mov    %esp,%ebp
c01059f1:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01059f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01059fb:	eb 04                	jmp    c0105a01 <strlen+0x13>
        cnt ++;
c01059fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a04:	8d 50 01             	lea    0x1(%eax),%edx
c0105a07:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a0a:	0f b6 00             	movzbl (%eax),%eax
c0105a0d:	84 c0                	test   %al,%al
c0105a0f:	75 ec                	jne    c01059fd <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a14:	c9                   	leave  
c0105a15:	c3                   	ret    

c0105a16 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105a16:	55                   	push   %ebp
c0105a17:	89 e5                	mov    %esp,%ebp
c0105a19:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105a1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105a23:	eb 04                	jmp    c0105a29 <strnlen+0x13>
        cnt ++;
c0105a25:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105a29:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a2c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105a2f:	73 10                	jae    c0105a41 <strnlen+0x2b>
c0105a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a34:	8d 50 01             	lea    0x1(%eax),%edx
c0105a37:	89 55 08             	mov    %edx,0x8(%ebp)
c0105a3a:	0f b6 00             	movzbl (%eax),%eax
c0105a3d:	84 c0                	test   %al,%al
c0105a3f:	75 e4                	jne    c0105a25 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105a44:	c9                   	leave  
c0105a45:	c3                   	ret    

c0105a46 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105a46:	55                   	push   %ebp
c0105a47:	89 e5                	mov    %esp,%ebp
c0105a49:	57                   	push   %edi
c0105a4a:	56                   	push   %esi
c0105a4b:	83 ec 20             	sub    $0x20,%esp
c0105a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a51:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a54:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105a5a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a60:	89 d1                	mov    %edx,%ecx
c0105a62:	89 c2                	mov    %eax,%edx
c0105a64:	89 ce                	mov    %ecx,%esi
c0105a66:	89 d7                	mov    %edx,%edi
c0105a68:	ac                   	lods   %ds:(%esi),%al
c0105a69:	aa                   	stos   %al,%es:(%edi)
c0105a6a:	84 c0                	test   %al,%al
c0105a6c:	75 fa                	jne    c0105a68 <strcpy+0x22>
c0105a6e:	89 fa                	mov    %edi,%edx
c0105a70:	89 f1                	mov    %esi,%ecx
c0105a72:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a75:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105a78:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105a7e:	83 c4 20             	add    $0x20,%esp
c0105a81:	5e                   	pop    %esi
c0105a82:	5f                   	pop    %edi
c0105a83:	5d                   	pop    %ebp
c0105a84:	c3                   	ret    

c0105a85 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105a85:	55                   	push   %ebp
c0105a86:	89 e5                	mov    %esp,%ebp
c0105a88:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105a91:	eb 21                	jmp    c0105ab4 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105a93:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a96:	0f b6 10             	movzbl (%eax),%edx
c0105a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a9c:	88 10                	mov    %dl,(%eax)
c0105a9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105aa1:	0f b6 00             	movzbl (%eax),%eax
c0105aa4:	84 c0                	test   %al,%al
c0105aa6:	74 04                	je     c0105aac <strncpy+0x27>
            src ++;
c0105aa8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105aac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105ab0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105ab4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ab8:	75 d9                	jne    c0105a93 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105aba:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105abd:	c9                   	leave  
c0105abe:	c3                   	ret    

c0105abf <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105abf:	55                   	push   %ebp
c0105ac0:	89 e5                	mov    %esp,%ebp
c0105ac2:	57                   	push   %edi
c0105ac3:	56                   	push   %esi
c0105ac4:	83 ec 20             	sub    $0x20,%esp
c0105ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105acd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad0:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ad9:	89 d1                	mov    %edx,%ecx
c0105adb:	89 c2                	mov    %eax,%edx
c0105add:	89 ce                	mov    %ecx,%esi
c0105adf:	89 d7                	mov    %edx,%edi
c0105ae1:	ac                   	lods   %ds:(%esi),%al
c0105ae2:	ae                   	scas   %es:(%edi),%al
c0105ae3:	75 08                	jne    c0105aed <strcmp+0x2e>
c0105ae5:	84 c0                	test   %al,%al
c0105ae7:	75 f8                	jne    c0105ae1 <strcmp+0x22>
c0105ae9:	31 c0                	xor    %eax,%eax
c0105aeb:	eb 04                	jmp    c0105af1 <strcmp+0x32>
c0105aed:	19 c0                	sbb    %eax,%eax
c0105aef:	0c 01                	or     $0x1,%al
c0105af1:	89 fa                	mov    %edi,%edx
c0105af3:	89 f1                	mov    %esi,%ecx
c0105af5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105af8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105afb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105b01:	83 c4 20             	add    $0x20,%esp
c0105b04:	5e                   	pop    %esi
c0105b05:	5f                   	pop    %edi
c0105b06:	5d                   	pop    %ebp
c0105b07:	c3                   	ret    

c0105b08 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105b08:	55                   	push   %ebp
c0105b09:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b0b:	eb 0c                	jmp    c0105b19 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105b0d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105b11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105b15:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105b19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b1d:	74 1a                	je     c0105b39 <strncmp+0x31>
c0105b1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b22:	0f b6 00             	movzbl (%eax),%eax
c0105b25:	84 c0                	test   %al,%al
c0105b27:	74 10                	je     c0105b39 <strncmp+0x31>
c0105b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b2c:	0f b6 10             	movzbl (%eax),%edx
c0105b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b32:	0f b6 00             	movzbl (%eax),%eax
c0105b35:	38 c2                	cmp    %al,%dl
c0105b37:	74 d4                	je     c0105b0d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b39:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b3d:	74 18                	je     c0105b57 <strncmp+0x4f>
c0105b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b42:	0f b6 00             	movzbl (%eax),%eax
c0105b45:	0f b6 d0             	movzbl %al,%edx
c0105b48:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b4b:	0f b6 00             	movzbl (%eax),%eax
c0105b4e:	0f b6 c0             	movzbl %al,%eax
c0105b51:	29 c2                	sub    %eax,%edx
c0105b53:	89 d0                	mov    %edx,%eax
c0105b55:	eb 05                	jmp    c0105b5c <strncmp+0x54>
c0105b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b5c:	5d                   	pop    %ebp
c0105b5d:	c3                   	ret    

c0105b5e <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105b5e:	55                   	push   %ebp
c0105b5f:	89 e5                	mov    %esp,%ebp
c0105b61:	83 ec 04             	sub    $0x4,%esp
c0105b64:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b67:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b6a:	eb 14                	jmp    c0105b80 <strchr+0x22>
        if (*s == c) {
c0105b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b6f:	0f b6 00             	movzbl (%eax),%eax
c0105b72:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105b75:	75 05                	jne    c0105b7c <strchr+0x1e>
            return (char *)s;
c0105b77:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7a:	eb 13                	jmp    c0105b8f <strchr+0x31>
        }
        s ++;
c0105b7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105b80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b83:	0f b6 00             	movzbl (%eax),%eax
c0105b86:	84 c0                	test   %al,%al
c0105b88:	75 e2                	jne    c0105b6c <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105b8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b8f:	c9                   	leave  
c0105b90:	c3                   	ret    

c0105b91 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105b91:	55                   	push   %ebp
c0105b92:	89 e5                	mov    %esp,%ebp
c0105b94:	83 ec 04             	sub    $0x4,%esp
c0105b97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105b9d:	eb 11                	jmp    c0105bb0 <strfind+0x1f>
        if (*s == c) {
c0105b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba2:	0f b6 00             	movzbl (%eax),%eax
c0105ba5:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105ba8:	75 02                	jne    c0105bac <strfind+0x1b>
            break;
c0105baa:	eb 0e                	jmp    c0105bba <strfind+0x29>
        }
        s ++;
c0105bac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105bb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb3:	0f b6 00             	movzbl (%eax),%eax
c0105bb6:	84 c0                	test   %al,%al
c0105bb8:	75 e5                	jne    c0105b9f <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105bba:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bbd:	c9                   	leave  
c0105bbe:	c3                   	ret    

c0105bbf <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105bbf:	55                   	push   %ebp
c0105bc0:	89 e5                	mov    %esp,%ebp
c0105bc2:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105bc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105bcc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bd3:	eb 04                	jmp    c0105bd9 <strtol+0x1a>
        s ++;
c0105bd5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bdc:	0f b6 00             	movzbl (%eax),%eax
c0105bdf:	3c 20                	cmp    $0x20,%al
c0105be1:	74 f2                	je     c0105bd5 <strtol+0x16>
c0105be3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be6:	0f b6 00             	movzbl (%eax),%eax
c0105be9:	3c 09                	cmp    $0x9,%al
c0105beb:	74 e8                	je     c0105bd5 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105bed:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bf0:	0f b6 00             	movzbl (%eax),%eax
c0105bf3:	3c 2b                	cmp    $0x2b,%al
c0105bf5:	75 06                	jne    c0105bfd <strtol+0x3e>
        s ++;
c0105bf7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bfb:	eb 15                	jmp    c0105c12 <strtol+0x53>
    }
    else if (*s == '-') {
c0105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c00:	0f b6 00             	movzbl (%eax),%eax
c0105c03:	3c 2d                	cmp    $0x2d,%al
c0105c05:	75 0b                	jne    c0105c12 <strtol+0x53>
        s ++, neg = 1;
c0105c07:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c0b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105c12:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c16:	74 06                	je     c0105c1e <strtol+0x5f>
c0105c18:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105c1c:	75 24                	jne    c0105c42 <strtol+0x83>
c0105c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c21:	0f b6 00             	movzbl (%eax),%eax
c0105c24:	3c 30                	cmp    $0x30,%al
c0105c26:	75 1a                	jne    c0105c42 <strtol+0x83>
c0105c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2b:	83 c0 01             	add    $0x1,%eax
c0105c2e:	0f b6 00             	movzbl (%eax),%eax
c0105c31:	3c 78                	cmp    $0x78,%al
c0105c33:	75 0d                	jne    c0105c42 <strtol+0x83>
        s += 2, base = 16;
c0105c35:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105c39:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105c40:	eb 2a                	jmp    c0105c6c <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105c42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c46:	75 17                	jne    c0105c5f <strtol+0xa0>
c0105c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c4b:	0f b6 00             	movzbl (%eax),%eax
c0105c4e:	3c 30                	cmp    $0x30,%al
c0105c50:	75 0d                	jne    c0105c5f <strtol+0xa0>
        s ++, base = 8;
c0105c52:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c56:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105c5d:	eb 0d                	jmp    c0105c6c <strtol+0xad>
    }
    else if (base == 0) {
c0105c5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c63:	75 07                	jne    c0105c6c <strtol+0xad>
        base = 10;
c0105c65:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6f:	0f b6 00             	movzbl (%eax),%eax
c0105c72:	3c 2f                	cmp    $0x2f,%al
c0105c74:	7e 1b                	jle    c0105c91 <strtol+0xd2>
c0105c76:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c79:	0f b6 00             	movzbl (%eax),%eax
c0105c7c:	3c 39                	cmp    $0x39,%al
c0105c7e:	7f 11                	jg     c0105c91 <strtol+0xd2>
            dig = *s - '0';
c0105c80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c83:	0f b6 00             	movzbl (%eax),%eax
c0105c86:	0f be c0             	movsbl %al,%eax
c0105c89:	83 e8 30             	sub    $0x30,%eax
c0105c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c8f:	eb 48                	jmp    c0105cd9 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105c91:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c94:	0f b6 00             	movzbl (%eax),%eax
c0105c97:	3c 60                	cmp    $0x60,%al
c0105c99:	7e 1b                	jle    c0105cb6 <strtol+0xf7>
c0105c9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c9e:	0f b6 00             	movzbl (%eax),%eax
c0105ca1:	3c 7a                	cmp    $0x7a,%al
c0105ca3:	7f 11                	jg     c0105cb6 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105ca5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca8:	0f b6 00             	movzbl (%eax),%eax
c0105cab:	0f be c0             	movsbl %al,%eax
c0105cae:	83 e8 57             	sub    $0x57,%eax
c0105cb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105cb4:	eb 23                	jmp    c0105cd9 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cb9:	0f b6 00             	movzbl (%eax),%eax
c0105cbc:	3c 40                	cmp    $0x40,%al
c0105cbe:	7e 3d                	jle    c0105cfd <strtol+0x13e>
c0105cc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cc3:	0f b6 00             	movzbl (%eax),%eax
c0105cc6:	3c 5a                	cmp    $0x5a,%al
c0105cc8:	7f 33                	jg     c0105cfd <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105cca:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccd:	0f b6 00             	movzbl (%eax),%eax
c0105cd0:	0f be c0             	movsbl %al,%eax
c0105cd3:	83 e8 37             	sub    $0x37,%eax
c0105cd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cdc:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105cdf:	7c 02                	jl     c0105ce3 <strtol+0x124>
            break;
c0105ce1:	eb 1a                	jmp    c0105cfd <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105ce3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105cea:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105cee:	89 c2                	mov    %eax,%edx
c0105cf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105cf3:	01 d0                	add    %edx,%eax
c0105cf5:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105cf8:	e9 6f ff ff ff       	jmp    c0105c6c <strtol+0xad>

    if (endptr) {
c0105cfd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105d01:	74 08                	je     c0105d0b <strtol+0x14c>
        *endptr = (char *) s;
c0105d03:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d06:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d09:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105d0b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105d0f:	74 07                	je     c0105d18 <strtol+0x159>
c0105d11:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105d14:	f7 d8                	neg    %eax
c0105d16:	eb 03                	jmp    c0105d1b <strtol+0x15c>
c0105d18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105d1b:	c9                   	leave  
c0105d1c:	c3                   	ret    

c0105d1d <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105d1d:	55                   	push   %ebp
c0105d1e:	89 e5                	mov    %esp,%ebp
c0105d20:	57                   	push   %edi
c0105d21:	83 ec 24             	sub    $0x24,%esp
c0105d24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d27:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105d2a:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105d2e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105d31:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105d34:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105d37:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105d3d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105d40:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105d44:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105d47:	89 d7                	mov    %edx,%edi
c0105d49:	f3 aa                	rep stos %al,%es:(%edi)
c0105d4b:	89 fa                	mov    %edi,%edx
c0105d4d:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105d50:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105d56:	83 c4 24             	add    $0x24,%esp
c0105d59:	5f                   	pop    %edi
c0105d5a:	5d                   	pop    %ebp
c0105d5b:	c3                   	ret    

c0105d5c <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105d5c:	55                   	push   %ebp
c0105d5d:	89 e5                	mov    %esp,%ebp
c0105d5f:	57                   	push   %edi
c0105d60:	56                   	push   %esi
c0105d61:	53                   	push   %ebx
c0105d62:	83 ec 30             	sub    $0x30,%esp
c0105d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d68:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d6b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d71:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d74:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d7a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105d7d:	73 42                	jae    c0105dc1 <memmove+0x65>
c0105d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105d85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d88:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105d8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105d8e:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105d91:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105d94:	c1 e8 02             	shr    $0x2,%eax
c0105d97:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105d99:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d9c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d9f:	89 d7                	mov    %edx,%edi
c0105da1:	89 c6                	mov    %eax,%esi
c0105da3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105da5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105da8:	83 e1 03             	and    $0x3,%ecx
c0105dab:	74 02                	je     c0105daf <memmove+0x53>
c0105dad:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105daf:	89 f0                	mov    %esi,%eax
c0105db1:	89 fa                	mov    %edi,%edx
c0105db3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105db6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105db9:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105dbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dbf:	eb 36                	jmp    c0105df7 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105dc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dc4:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105dc7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105dca:	01 c2                	add    %eax,%edx
c0105dcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105dcf:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dd5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105dd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ddb:	89 c1                	mov    %eax,%ecx
c0105ddd:	89 d8                	mov    %ebx,%eax
c0105ddf:	89 d6                	mov    %edx,%esi
c0105de1:	89 c7                	mov    %eax,%edi
c0105de3:	fd                   	std    
c0105de4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105de6:	fc                   	cld    
c0105de7:	89 f8                	mov    %edi,%eax
c0105de9:	89 f2                	mov    %esi,%edx
c0105deb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105dee:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105df1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105df7:	83 c4 30             	add    $0x30,%esp
c0105dfa:	5b                   	pop    %ebx
c0105dfb:	5e                   	pop    %esi
c0105dfc:	5f                   	pop    %edi
c0105dfd:	5d                   	pop    %ebp
c0105dfe:	c3                   	ret    

c0105dff <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105dff:	55                   	push   %ebp
c0105e00:	89 e5                	mov    %esp,%ebp
c0105e02:	57                   	push   %edi
c0105e03:	56                   	push   %esi
c0105e04:	83 ec 20             	sub    $0x20,%esp
c0105e07:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e10:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e13:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e16:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e1c:	c1 e8 02             	shr    $0x2,%eax
c0105e1f:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e21:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e27:	89 d7                	mov    %edx,%edi
c0105e29:	89 c6                	mov    %eax,%esi
c0105e2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e2d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105e30:	83 e1 03             	and    $0x3,%ecx
c0105e33:	74 02                	je     c0105e37 <memcpy+0x38>
c0105e35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e37:	89 f0                	mov    %esi,%eax
c0105e39:	89 fa                	mov    %edi,%edx
c0105e3b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105e3e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105e41:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105e47:	83 c4 20             	add    $0x20,%esp
c0105e4a:	5e                   	pop    %esi
c0105e4b:	5f                   	pop    %edi
c0105e4c:	5d                   	pop    %ebp
c0105e4d:	c3                   	ret    

c0105e4e <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105e4e:	55                   	push   %ebp
c0105e4f:	89 e5                	mov    %esp,%ebp
c0105e51:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e57:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105e60:	eb 30                	jmp    c0105e92 <memcmp+0x44>
        if (*s1 != *s2) {
c0105e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e65:	0f b6 10             	movzbl (%eax),%edx
c0105e68:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e6b:	0f b6 00             	movzbl (%eax),%eax
c0105e6e:	38 c2                	cmp    %al,%dl
c0105e70:	74 18                	je     c0105e8a <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e75:	0f b6 00             	movzbl (%eax),%eax
c0105e78:	0f b6 d0             	movzbl %al,%edx
c0105e7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e7e:	0f b6 00             	movzbl (%eax),%eax
c0105e81:	0f b6 c0             	movzbl %al,%eax
c0105e84:	29 c2                	sub    %eax,%edx
c0105e86:	89 d0                	mov    %edx,%eax
c0105e88:	eb 1a                	jmp    c0105ea4 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105e8a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e8e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105e92:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e95:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e98:	89 55 10             	mov    %edx,0x10(%ebp)
c0105e9b:	85 c0                	test   %eax,%eax
c0105e9d:	75 c3                	jne    c0105e62 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105ea4:	c9                   	leave  
c0105ea5:	c3                   	ret    
