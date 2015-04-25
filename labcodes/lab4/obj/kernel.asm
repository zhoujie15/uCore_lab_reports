
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 40 12 00 	lgdtl  0x124018
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
c010001e:	bc 00 40 12 c0       	mov    $0xc0124000,%esp
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
c0100030:	ba 18 7c 12 c0       	mov    $0xc0127c18,%edx
c0100035:	b8 90 4a 12 c0       	mov    $0xc0124a90,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 90 4a 12 c0 	movl   $0xc0124a90,(%esp)
c0100051:	e8 ab 9a 00 00       	call   c0109b01 <memset>

    cons_init();                // init the console
c0100056:	e8 88 15 00 00       	call   c01015e3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 9c 10 c0 	movl   $0xc0109ca0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 9c 10 c0 	movl   $0xc0109cbc,(%esp)
c0100070:	e8 de 02 00 00       	call   c0100353 <cprintf>

    print_kerninfo();
c0100075:	e8 0d 08 00 00       	call   c0100887 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 9d 00 00 00       	call   c010011c <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 10 53 00 00       	call   c0105394 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 38 1f 00 00       	call   c0101fc1 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 b0 20 00 00       	call   c010213e <idt_init>

    vmm_init();                 // init virtual memory management
c010008e:	e8 37 79 00 00       	call   c01079ca <vmm_init>
    proc_init();                // init process table
c0100093:	e8 5f 8c 00 00       	call   c0108cf7 <proc_init>
    
    ide_init();                 // init ide devices
c0100098:	e8 77 16 00 00       	call   c0101714 <ide_init>
    swap_init();                // init swap
c010009d:	e8 79 65 00 00       	call   c010661b <swap_init>

    clock_init();               // init clock interrupt
c01000a2:	e8 f2 0c 00 00       	call   c0100d99 <clock_init>
    intr_enable();              // enable irq interrupt
c01000a7:	e8 83 1e 00 00       	call   c0101f2f <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000ac:	e8 05 8e 00 00       	call   c0108eb6 <cpu_idle>

c01000b1 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b1:	55                   	push   %ebp
c01000b2:	89 e5                	mov    %esp,%ebp
c01000b4:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000be:	00 
c01000bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c6:	00 
c01000c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ce:	e8 f8 0b 00 00       	call   c0100ccb <mon_backtrace>
}
c01000d3:	c9                   	leave  
c01000d4:	c3                   	ret    

c01000d5 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d5:	55                   	push   %ebp
c01000d6:	89 e5                	mov    %esp,%ebp
c01000d8:	53                   	push   %ebx
c01000d9:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000dc:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000df:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e2:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000ec:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f4:	89 04 24             	mov    %eax,(%esp)
c01000f7:	e8 b5 ff ff ff       	call   c01000b1 <grade_backtrace2>
}
c01000fc:	83 c4 14             	add    $0x14,%esp
c01000ff:	5b                   	pop    %ebx
c0100100:	5d                   	pop    %ebp
c0100101:	c3                   	ret    

c0100102 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100102:	55                   	push   %ebp
c0100103:	89 e5                	mov    %esp,%ebp
c0100105:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100108:	8b 45 10             	mov    0x10(%ebp),%eax
c010010b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100112:	89 04 24             	mov    %eax,(%esp)
c0100115:	e8 bb ff ff ff       	call   c01000d5 <grade_backtrace1>
}
c010011a:	c9                   	leave  
c010011b:	c3                   	ret    

c010011c <grade_backtrace>:

void
grade_backtrace(void) {
c010011c:	55                   	push   %ebp
c010011d:	89 e5                	mov    %esp,%ebp
c010011f:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100122:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100127:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012e:	ff 
c010012f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013a:	e8 c3 ff ff ff       	call   c0100102 <grade_backtrace0>
}
c010013f:	c9                   	leave  
c0100140:	c3                   	ret    

c0100141 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100141:	55                   	push   %ebp
c0100142:	89 e5                	mov    %esp,%ebp
c0100144:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100147:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014a:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010014d:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100150:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100153:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100157:	0f b7 c0             	movzwl %ax,%eax
c010015a:	83 e0 03             	and    $0x3,%eax
c010015d:	89 c2                	mov    %eax,%edx
c010015f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100164:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100168:	89 44 24 04          	mov    %eax,0x4(%esp)
c010016c:	c7 04 24 c1 9c 10 c0 	movl   $0xc0109cc1,(%esp)
c0100173:	e8 db 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100178:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010017c:	0f b7 d0             	movzwl %ax,%edx
c010017f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c0100184:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100188:	89 44 24 04          	mov    %eax,0x4(%esp)
c010018c:	c7 04 24 cf 9c 10 c0 	movl   $0xc0109ccf,(%esp)
c0100193:	e8 bb 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100198:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010019c:	0f b7 d0             	movzwl %ax,%edx
c010019f:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001a4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ac:	c7 04 24 dd 9c 10 c0 	movl   $0xc0109cdd,(%esp)
c01001b3:	e8 9b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b8:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001bc:	0f b7 d0             	movzwl %ax,%edx
c01001bf:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001c4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001cc:	c7 04 24 eb 9c 10 c0 	movl   $0xc0109ceb,(%esp)
c01001d3:	e8 7b 01 00 00       	call   c0100353 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d8:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001dc:	0f b7 d0             	movzwl %ax,%edx
c01001df:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001e4:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001ec:	c7 04 24 f9 9c 10 c0 	movl   $0xc0109cf9,(%esp)
c01001f3:	e8 5b 01 00 00       	call   c0100353 <cprintf>
    round ++;
c01001f8:	a1 a0 4a 12 c0       	mov    0xc0124aa0,%eax
c01001fd:	83 c0 01             	add    $0x1,%eax
c0100200:	a3 a0 4a 12 c0       	mov    %eax,0xc0124aa0
}
c0100205:	c9                   	leave  
c0100206:	c3                   	ret    

c0100207 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100207:	55                   	push   %ebp
c0100208:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020a:	5d                   	pop    %ebp
c010020b:	c3                   	ret    

c010020c <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c010020c:	55                   	push   %ebp
c010020d:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 25 ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 08 9d 10 c0 	movl   $0xc0109d08,(%esp)
c0100223:	e8 2b 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_user();
c0100228:	e8 da ff ff ff       	call   c0100207 <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 0f ff ff ff       	call   c0100141 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 28 9d 10 c0 	movl   $0xc0109d28,(%esp)
c0100239:	e8 15 01 00 00       	call   c0100353 <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c9 ff ff ff       	call   c010020c <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 f9 fe ff ff       	call   c0100141 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100250:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100254:	74 13                	je     c0100269 <readline+0x1f>
        cprintf("%s", prompt);
c0100256:	8b 45 08             	mov    0x8(%ebp),%eax
c0100259:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025d:	c7 04 24 47 9d 10 c0 	movl   $0xc0109d47,(%esp)
c0100264:	e8 ea 00 00 00       	call   c0100353 <cprintf>
    }
    int i = 0, c;
c0100269:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100270:	e8 66 01 00 00       	call   c01003db <getchar>
c0100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027c:	79 07                	jns    c0100285 <readline+0x3b>
            return NULL;
c010027e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100283:	eb 79                	jmp    c01002fe <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100285:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100289:	7e 28                	jle    c01002b3 <readline+0x69>
c010028b:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100292:	7f 1f                	jg     c01002b3 <readline+0x69>
            cputchar(c);
c0100294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100297:	89 04 24             	mov    %eax,(%esp)
c010029a:	e8 da 00 00 00       	call   c0100379 <cputchar>
            buf[i ++] = c;
c010029f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002a2:	8d 50 01             	lea    0x1(%eax),%edx
c01002a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01002a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01002ab:	88 90 c0 4a 12 c0    	mov    %dl,-0x3fedb540(%eax)
c01002b1:	eb 46                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01002b3:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b7:	75 17                	jne    c01002d0 <readline+0x86>
c01002b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002bd:	7e 11                	jle    c01002d0 <readline+0x86>
            cputchar(c);
c01002bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c2:	89 04 24             	mov    %eax,(%esp)
c01002c5:	e8 af 00 00 00       	call   c0100379 <cputchar>
            i --;
c01002ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002ce:	eb 29                	jmp    c01002f9 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d4:	74 06                	je     c01002dc <readline+0x92>
c01002d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002da:	75 1d                	jne    c01002f9 <readline+0xaf>
            cputchar(c);
c01002dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002df:	89 04 24             	mov    %eax,(%esp)
c01002e2:	e8 92 00 00 00       	call   c0100379 <cputchar>
            buf[i] = '\0';
c01002e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002ea:	05 c0 4a 12 c0       	add    $0xc0124ac0,%eax
c01002ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f2:	b8 c0 4a 12 c0       	mov    $0xc0124ac0,%eax
c01002f7:	eb 05                	jmp    c01002fe <readline+0xb4>
        }
    }
c01002f9:	e9 72 ff ff ff       	jmp    c0100270 <readline+0x26>
}
c01002fe:	c9                   	leave  
c01002ff:	c3                   	ret    

c0100300 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100300:	55                   	push   %ebp
c0100301:	89 e5                	mov    %esp,%ebp
c0100303:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100306:	8b 45 08             	mov    0x8(%ebp),%eax
c0100309:	89 04 24             	mov    %eax,(%esp)
c010030c:	e8 fe 12 00 00       	call   c010160f <cons_putc>
    (*cnt) ++;
c0100311:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100314:	8b 00                	mov    (%eax),%eax
c0100316:	8d 50 01             	lea    0x1(%eax),%edx
c0100319:	8b 45 0c             	mov    0xc(%ebp),%eax
c010031c:	89 10                	mov    %edx,(%eax)
}
c010031e:	c9                   	leave  
c010031f:	c3                   	ret    

c0100320 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100320:	55                   	push   %ebp
c0100321:	89 e5                	mov    %esp,%ebp
c0100323:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010032d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100330:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100334:	8b 45 08             	mov    0x8(%ebp),%eax
c0100337:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033b:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010033e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100342:	c7 04 24 00 03 10 c0 	movl   $0xc0100300,(%esp)
c0100349:	e8 f4 8e 00 00       	call   c0109242 <vprintfmt>
    return cnt;
c010034e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100351:	c9                   	leave  
c0100352:	c3                   	ret    

c0100353 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100353:	55                   	push   %ebp
c0100354:	89 e5                	mov    %esp,%ebp
c0100356:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100359:	8d 45 0c             	lea    0xc(%ebp),%eax
c010035c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010035f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100362:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100366:	8b 45 08             	mov    0x8(%ebp),%eax
c0100369:	89 04 24             	mov    %eax,(%esp)
c010036c:	e8 af ff ff ff       	call   c0100320 <vcprintf>
c0100371:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100374:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100377:	c9                   	leave  
c0100378:	c3                   	ret    

c0100379 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100379:	55                   	push   %ebp
c010037a:	89 e5                	mov    %esp,%ebp
c010037c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010037f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100382:	89 04 24             	mov    %eax,(%esp)
c0100385:	e8 85 12 00 00       	call   c010160f <cons_putc>
}
c010038a:	c9                   	leave  
c010038b:	c3                   	ret    

c010038c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010038c:	55                   	push   %ebp
c010038d:	89 e5                	mov    %esp,%ebp
c010038f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100399:	eb 13                	jmp    c01003ae <cputs+0x22>
        cputch(c, &cnt);
c010039b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c010039f:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003a6:	89 04 24             	mov    %eax,(%esp)
c01003a9:	e8 52 ff ff ff       	call   c0100300 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b1:	8d 50 01             	lea    0x1(%eax),%edx
c01003b4:	89 55 08             	mov    %edx,0x8(%ebp)
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	75 d8                	jne    c010039b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003c3:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003c6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003ca:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003d1:	e8 2a ff ff ff       	call   c0100300 <cputch>
    return cnt;
c01003d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d9:	c9                   	leave  
c01003da:	c3                   	ret    

c01003db <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003db:	55                   	push   %ebp
c01003dc:	89 e5                	mov    %esp,%ebp
c01003de:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003e1:	e8 65 12 00 00       	call   c010164b <cons_getc>
c01003e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003ed:	74 f2                	je     c01003e1 <getchar+0x6>
        /* do nothing */;
    return c;
c01003ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003fd:	8b 00                	mov    (%eax),%eax
c01003ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100402:	8b 45 10             	mov    0x10(%ebp),%eax
c0100405:	8b 00                	mov    (%eax),%eax
c0100407:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010040a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100411:	e9 d2 00 00 00       	jmp    c01004e8 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c0100416:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100419:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010041c:	01 d0                	add    %edx,%eax
c010041e:	89 c2                	mov    %eax,%edx
c0100420:	c1 ea 1f             	shr    $0x1f,%edx
c0100423:	01 d0                	add    %edx,%eax
c0100425:	d1 f8                	sar    %eax
c0100427:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010042a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010042d:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100430:	eb 04                	jmp    c0100436 <stab_binsearch+0x42>
            m --;
c0100432:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100436:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100439:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010043c:	7c 1f                	jl     c010045d <stab_binsearch+0x69>
c010043e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100441:	89 d0                	mov    %edx,%eax
c0100443:	01 c0                	add    %eax,%eax
c0100445:	01 d0                	add    %edx,%eax
c0100447:	c1 e0 02             	shl    $0x2,%eax
c010044a:	89 c2                	mov    %eax,%edx
c010044c:	8b 45 08             	mov    0x8(%ebp),%eax
c010044f:	01 d0                	add    %edx,%eax
c0100451:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100455:	0f b6 c0             	movzbl %al,%eax
c0100458:	3b 45 14             	cmp    0x14(%ebp),%eax
c010045b:	75 d5                	jne    c0100432 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010045d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100460:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100463:	7d 0b                	jge    c0100470 <stab_binsearch+0x7c>
            l = true_m + 1;
c0100465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100468:	83 c0 01             	add    $0x1,%eax
c010046b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010046e:	eb 78                	jmp    c01004e8 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100470:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100477:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010047a:	89 d0                	mov    %edx,%eax
c010047c:	01 c0                	add    %eax,%eax
c010047e:	01 d0                	add    %edx,%eax
c0100480:	c1 e0 02             	shl    $0x2,%eax
c0100483:	89 c2                	mov    %eax,%edx
c0100485:	8b 45 08             	mov    0x8(%ebp),%eax
c0100488:	01 d0                	add    %edx,%eax
c010048a:	8b 40 08             	mov    0x8(%eax),%eax
c010048d:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100490:	73 13                	jae    c01004a5 <stab_binsearch+0xb1>
            *region_left = m;
c0100492:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100495:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100498:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010049d:	83 c0 01             	add    $0x1,%eax
c01004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a3:	eb 43                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c01004a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a8:	89 d0                	mov    %edx,%eax
c01004aa:	01 c0                	add    %eax,%eax
c01004ac:	01 d0                	add    %edx,%eax
c01004ae:	c1 e0 02             	shl    $0x2,%eax
c01004b1:	89 c2                	mov    %eax,%edx
c01004b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01004b6:	01 d0                	add    %edx,%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 22 ff ff ff    	jle    c0100416 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3f                	jmp    c0100548 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x123>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1f                	jge    c0100540 <stab_binsearch+0x14c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	89 c2                	mov    %eax,%edx
c010052f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100532:	01 d0                	add    %edx,%eax
c0100534:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100538:	0f b6 c0             	movzbl %al,%eax
c010053b:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053e:	75 d3                	jne    c0100513 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100540:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100543:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100546:	89 10                	mov    %edx,(%eax)
    }
}
c0100548:	c9                   	leave  
c0100549:	c3                   	ret    

c010054a <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054a:	55                   	push   %ebp
c010054b:	89 e5                	mov    %esp,%ebp
c010054d:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 00 4c 9d 10 c0    	movl   $0xc0109d4c,(%eax)
    info->eip_line = 0;
c0100559:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100563:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100566:	c7 40 08 4c 9d 10 c0 	movl   $0xc0109d4c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100577:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057a:	8b 55 08             	mov    0x8(%ebp),%edx
c010057d:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100580:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100583:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c010058a:	c7 45 f4 80 be 10 c0 	movl   $0xc010be80,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100591:	c7 45 f0 e8 d0 11 c0 	movl   $0xc011d0e8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100598:	c7 45 ec e9 d0 11 c0 	movl   $0xc011d0e9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059f:	c7 45 e8 b9 18 12 c0 	movl   $0xc01218b9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005ac:	76 0d                	jbe    c01005bb <debuginfo_eip+0x71>
c01005ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b1:	83 e8 01             	sub    $0x1,%eax
c01005b4:	0f b6 00             	movzbl (%eax),%eax
c01005b7:	84 c0                	test   %al,%al
c01005b9:	74 0a                	je     c01005c5 <debuginfo_eip+0x7b>
        return -1;
c01005bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c0:	e9 c0 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d2:	29 c2                	sub    %eax,%edx
c01005d4:	89 d0                	mov    %edx,%eax
c01005d6:	c1 f8 02             	sar    $0x2,%eax
c01005d9:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005df:	83 e8 01             	sub    $0x1,%eax
c01005e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e8:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005ec:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f3:	00 
c01005f4:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100602:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100605:	89 04 24             	mov    %eax,(%esp)
c0100608:	e8 e7 fd ff ff       	call   c01003f4 <stab_binsearch>
    if (lfile == 0)
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	85 c0                	test   %eax,%eax
c0100612:	75 0a                	jne    c010061e <debuginfo_eip+0xd4>
        return -1;
c0100614:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100619:	e9 67 02 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100621:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100624:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100627:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010062a:	8b 45 08             	mov    0x8(%ebp),%eax
c010062d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100631:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100638:	00 
c0100639:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100640:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100647:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010064a:	89 04 24             	mov    %eax,(%esp)
c010064d:	e8 a2 fd ff ff       	call   c01003f4 <stab_binsearch>

    if (lfun <= rfun) {
c0100652:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100655:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100658:	39 c2                	cmp    %eax,%edx
c010065a:	7f 7c                	jg     c01006d8 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065f:	89 c2                	mov    %eax,%edx
c0100661:	89 d0                	mov    %edx,%eax
c0100663:	01 c0                	add    %eax,%eax
c0100665:	01 d0                	add    %edx,%eax
c0100667:	c1 e0 02             	shl    $0x2,%eax
c010066a:	89 c2                	mov    %eax,%edx
c010066c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010066f:	01 d0                	add    %edx,%eax
c0100671:	8b 10                	mov    (%eax),%edx
c0100673:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100676:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100679:	29 c1                	sub    %eax,%ecx
c010067b:	89 c8                	mov    %ecx,%eax
c010067d:	39 c2                	cmp    %eax,%edx
c010067f:	73 22                	jae    c01006a3 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100681:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100684:	89 c2                	mov    %eax,%edx
c0100686:	89 d0                	mov    %edx,%eax
c0100688:	01 c0                	add    %eax,%eax
c010068a:	01 d0                	add    %edx,%eax
c010068c:	c1 e0 02             	shl    $0x2,%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100694:	01 d0                	add    %edx,%eax
c0100696:	8b 10                	mov    (%eax),%edx
c0100698:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010069b:	01 c2                	add    %eax,%edx
c010069d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a0:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a6:	89 c2                	mov    %eax,%edx
c01006a8:	89 d0                	mov    %edx,%eax
c01006aa:	01 c0                	add    %eax,%eax
c01006ac:	01 d0                	add    %edx,%eax
c01006ae:	c1 e0 02             	shl    $0x2,%eax
c01006b1:	89 c2                	mov    %eax,%edx
c01006b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006b6:	01 d0                	add    %edx,%eax
c01006b8:	8b 50 08             	mov    0x8(%eax),%edx
c01006bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006be:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 40 10             	mov    0x10(%eax),%eax
c01006c7:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d6:	eb 15                	jmp    c01006ed <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006db:	8b 55 08             	mov    0x8(%ebp),%edx
c01006de:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f0:	8b 40 08             	mov    0x8(%eax),%eax
c01006f3:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006fa:	00 
c01006fb:	89 04 24             	mov    %eax,(%esp)
c01006fe:	e8 72 92 00 00       	call   c0109975 <strfind>
c0100703:	89 c2                	mov    %eax,%edx
c0100705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100708:	8b 40 08             	mov    0x8(%eax),%eax
c010070b:	29 c2                	sub    %eax,%edx
c010070d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100710:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100713:	8b 45 08             	mov    0x8(%ebp),%eax
c0100716:	89 44 24 10          	mov    %eax,0x10(%esp)
c010071a:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100721:	00 
c0100722:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100725:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100729:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c010072c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100730:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100733:	89 04 24             	mov    %eax,(%esp)
c0100736:	e8 b9 fc ff ff       	call   c01003f4 <stab_binsearch>
    if (lline <= rline) {
c010073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100741:	39 c2                	cmp    %eax,%edx
c0100743:	7f 24                	jg     c0100769 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100745:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100748:	89 c2                	mov    %eax,%edx
c010074a:	89 d0                	mov    %edx,%eax
c010074c:	01 c0                	add    %eax,%eax
c010074e:	01 d0                	add    %edx,%eax
c0100750:	c1 e0 02             	shl    $0x2,%eax
c0100753:	89 c2                	mov    %eax,%edx
c0100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100758:	01 d0                	add    %edx,%eax
c010075a:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010075e:	0f b7 d0             	movzwl %ax,%edx
c0100761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100764:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100767:	eb 13                	jmp    c010077c <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100769:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010076e:	e9 12 01 00 00       	jmp    c0100885 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100773:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100776:	83 e8 01             	sub    $0x1,%eax
c0100779:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010077c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010077f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100782:	39 c2                	cmp    %eax,%edx
c0100784:	7c 56                	jl     c01007dc <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100786:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100789:	89 c2                	mov    %eax,%edx
c010078b:	89 d0                	mov    %edx,%eax
c010078d:	01 c0                	add    %eax,%eax
c010078f:	01 d0                	add    %edx,%eax
c0100791:	c1 e0 02             	shl    $0x2,%eax
c0100794:	89 c2                	mov    %eax,%edx
c0100796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010079f:	3c 84                	cmp    $0x84,%al
c01007a1:	74 39                	je     c01007dc <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c01007a3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a6:	89 c2                	mov    %eax,%edx
c01007a8:	89 d0                	mov    %edx,%eax
c01007aa:	01 c0                	add    %eax,%eax
c01007ac:	01 d0                	add    %edx,%eax
c01007ae:	c1 e0 02             	shl    $0x2,%eax
c01007b1:	89 c2                	mov    %eax,%edx
c01007b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007b6:	01 d0                	add    %edx,%eax
c01007b8:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007bc:	3c 64                	cmp    $0x64,%al
c01007be:	75 b3                	jne    c0100773 <debuginfo_eip+0x229>
c01007c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c3:	89 c2                	mov    %eax,%edx
c01007c5:	89 d0                	mov    %edx,%eax
c01007c7:	01 c0                	add    %eax,%eax
c01007c9:	01 d0                	add    %edx,%eax
c01007cb:	c1 e0 02             	shl    $0x2,%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007d3:	01 d0                	add    %edx,%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	85 c0                	test   %eax,%eax
c01007da:	74 97                	je     c0100773 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007dc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007e2:	39 c2                	cmp    %eax,%edx
c01007e4:	7c 46                	jl     c010082c <debuginfo_eip+0x2e2>
c01007e6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e9:	89 c2                	mov    %eax,%edx
c01007eb:	89 d0                	mov    %edx,%eax
c01007ed:	01 c0                	add    %eax,%eax
c01007ef:	01 d0                	add    %edx,%eax
c01007f1:	c1 e0 02             	shl    $0x2,%eax
c01007f4:	89 c2                	mov    %eax,%edx
c01007f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007f9:	01 d0                	add    %edx,%eax
c01007fb:	8b 10                	mov    (%eax),%edx
c01007fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100800:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100803:	29 c1                	sub    %eax,%ecx
c0100805:	89 c8                	mov    %ecx,%eax
c0100807:	39 c2                	cmp    %eax,%edx
c0100809:	73 21                	jae    c010082c <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c010080b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010080e:	89 c2                	mov    %eax,%edx
c0100810:	89 d0                	mov    %edx,%eax
c0100812:	01 c0                	add    %eax,%eax
c0100814:	01 d0                	add    %edx,%eax
c0100816:	c1 e0 02             	shl    $0x2,%eax
c0100819:	89 c2                	mov    %eax,%edx
c010081b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010081e:	01 d0                	add    %edx,%eax
c0100820:	8b 10                	mov    (%eax),%edx
c0100822:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100825:	01 c2                	add    %eax,%edx
c0100827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082a:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010082c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010082f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100832:	39 c2                	cmp    %eax,%edx
c0100834:	7d 4a                	jge    c0100880 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100836:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100839:	83 c0 01             	add    $0x1,%eax
c010083c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010083f:	eb 18                	jmp    c0100859 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100844:	8b 40 14             	mov    0x14(%eax),%eax
c0100847:	8d 50 01             	lea    0x1(%eax),%edx
c010084a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010084d:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100850:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100853:	83 c0 01             	add    $0x1,%eax
c0100856:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100859:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010085c:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010085f:	39 c2                	cmp    %eax,%edx
c0100861:	7d 1d                	jge    c0100880 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100863:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	89 d0                	mov    %edx,%eax
c010086a:	01 c0                	add    %eax,%eax
c010086c:	01 d0                	add    %edx,%eax
c010086e:	c1 e0 02             	shl    $0x2,%eax
c0100871:	89 c2                	mov    %eax,%edx
c0100873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100876:	01 d0                	add    %edx,%eax
c0100878:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010087c:	3c a0                	cmp    $0xa0,%al
c010087e:	74 c1                	je     c0100841 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100880:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100885:	c9                   	leave  
c0100886:	c3                   	ret    

c0100887 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100887:	55                   	push   %ebp
c0100888:	89 e5                	mov    %esp,%ebp
c010088a:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010088d:	c7 04 24 56 9d 10 c0 	movl   $0xc0109d56,(%esp)
c0100894:	e8 ba fa ff ff       	call   c0100353 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100899:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c01008a0:	c0 
c01008a1:	c7 04 24 6f 9d 10 c0 	movl   $0xc0109d6f,(%esp)
c01008a8:	e8 a6 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c01008ad:	c7 44 24 04 8a 9c 10 	movl   $0xc0109c8a,0x4(%esp)
c01008b4:	c0 
c01008b5:	c7 04 24 87 9d 10 c0 	movl   $0xc0109d87,(%esp)
c01008bc:	e8 92 fa ff ff       	call   c0100353 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008c1:	c7 44 24 04 90 4a 12 	movl   $0xc0124a90,0x4(%esp)
c01008c8:	c0 
c01008c9:	c7 04 24 9f 9d 10 c0 	movl   $0xc0109d9f,(%esp)
c01008d0:	e8 7e fa ff ff       	call   c0100353 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008d5:	c7 44 24 04 18 7c 12 	movl   $0xc0127c18,0x4(%esp)
c01008dc:	c0 
c01008dd:	c7 04 24 b7 9d 10 c0 	movl   $0xc0109db7,(%esp)
c01008e4:	e8 6a fa ff ff       	call   c0100353 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008e9:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c01008ee:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008f4:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008f9:	29 c2                	sub    %eax,%edx
c01008fb:	89 d0                	mov    %edx,%eax
c01008fd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c0100903:	85 c0                	test   %eax,%eax
c0100905:	0f 48 c2             	cmovs  %edx,%eax
c0100908:	c1 f8 0a             	sar    $0xa,%eax
c010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090f:	c7 04 24 d0 9d 10 c0 	movl   $0xc0109dd0,(%esp)
c0100916:	e8 38 fa ff ff       	call   c0100353 <cprintf>
}
c010091b:	c9                   	leave  
c010091c:	c3                   	ret    

c010091d <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c010091d:	55                   	push   %ebp
c010091e:	89 e5                	mov    %esp,%ebp
c0100920:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100926:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100930:	89 04 24             	mov    %eax,(%esp)
c0100933:	e8 12 fc ff ff       	call   c010054a <debuginfo_eip>
c0100938:	85 c0                	test   %eax,%eax
c010093a:	74 15                	je     c0100951 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010093c:	8b 45 08             	mov    0x8(%ebp),%eax
c010093f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100943:	c7 04 24 fa 9d 10 c0 	movl   $0xc0109dfa,(%esp)
c010094a:	e8 04 fa ff ff       	call   c0100353 <cprintf>
c010094f:	eb 6d                	jmp    c01009be <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100958:	eb 1c                	jmp    c0100976 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c010095a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010095d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100960:	01 d0                	add    %edx,%eax
c0100962:	0f b6 00             	movzbl (%eax),%eax
c0100965:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010096b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010096e:	01 ca                	add    %ecx,%edx
c0100970:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100972:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100976:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010097c:	7f dc                	jg     c010095a <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010097e:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100984:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100987:	01 d0                	add    %edx,%eax
c0100989:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c010098c:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100992:	89 d1                	mov    %edx,%ecx
c0100994:	29 c1                	sub    %eax,%ecx
c0100996:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100999:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010099c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01009a0:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c01009a6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01009aa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01009ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009b2:	c7 04 24 16 9e 10 c0 	movl   $0xc0109e16,(%esp)
c01009b9:	e8 95 f9 ff ff       	call   c0100353 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009be:	c9                   	leave  
c01009bf:	c3                   	ret    

c01009c0 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009c0:	55                   	push   %ebp
c01009c1:	89 e5                	mov    %esp,%ebp
c01009c3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009c6:	8b 45 04             	mov    0x4(%ebp),%eax
c01009c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009cf:	c9                   	leave  
c01009d0:	c3                   	ret    

c01009d1 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009d1:	55                   	push   %ebp
c01009d2:	89 e5                	mov    %esp,%ebp
c01009d4:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009d7:	89 e8                	mov    %ebp,%eax
c01009d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009e2:	e8 d9 ff ff ff       	call   c01009c0 <read_eip>
c01009e7:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009ea:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009f1:	e9 88 00 00 00       	jmp    c0100a7e <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 28 9e 10 c0 	movl   $0xc0109e28,(%esp)
c0100a0b:	e8 43 f9 ff ff       	call   c0100353 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c0100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a13:	83 c0 08             	add    $0x8,%eax
c0100a16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a19:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a20:	eb 25                	jmp    c0100a47 <print_stackframe+0x76>
            cprintf("0x%08x ", args[j]);
c0100a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a25:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a2f:	01 d0                	add    %edx,%eax
c0100a31:	8b 00                	mov    (%eax),%eax
c0100a33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a37:	c7 04 24 44 9e 10 c0 	movl   $0xc0109e44,(%esp)
c0100a3e:	e8 10 f9 ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a43:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a47:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a4b:	7e d5                	jle    c0100a22 <print_stackframe+0x51>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a4d:	c7 04 24 4c 9e 10 c0 	movl   $0xc0109e4c,(%esp)
c0100a54:	e8 fa f8 ff ff       	call   c0100353 <cprintf>
        print_debuginfo(eip - 1);
c0100a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a5c:	83 e8 01             	sub    $0x1,%eax
c0100a5f:	89 04 24             	mov    %eax,(%esp)
c0100a62:	e8 b6 fe ff ff       	call   c010091d <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a6a:	83 c0 04             	add    $0x4,%eax
c0100a6d:	8b 00                	mov    (%eax),%eax
c0100a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a75:	8b 00                	mov    (%eax),%eax
c0100a77:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a7a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a82:	74 0a                	je     c0100a8e <print_stackframe+0xbd>
c0100a84:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a88:	0f 8e 68 ff ff ff    	jle    c01009f6 <print_stackframe+0x25>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a8e:	c9                   	leave  
c0100a8f:	c3                   	ret    

c0100a90 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a90:	55                   	push   %ebp
c0100a91:	89 e5                	mov    %esp,%ebp
c0100a93:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9d:	eb 0c                	jmp    c0100aab <parse+0x1b>
            *buf ++ = '\0';
c0100a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa2:	8d 50 01             	lea    0x1(%eax),%edx
c0100aa5:	89 55 08             	mov    %edx,0x8(%ebp)
c0100aa8:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100aab:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aae:	0f b6 00             	movzbl (%eax),%eax
c0100ab1:	84 c0                	test   %al,%al
c0100ab3:	74 1d                	je     c0100ad2 <parse+0x42>
c0100ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ab8:	0f b6 00             	movzbl (%eax),%eax
c0100abb:	0f be c0             	movsbl %al,%eax
c0100abe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ac2:	c7 04 24 d0 9e 10 c0 	movl   $0xc0109ed0,(%esp)
c0100ac9:	e8 74 8e 00 00       	call   c0109942 <strchr>
c0100ace:	85 c0                	test   %eax,%eax
c0100ad0:	75 cd                	jne    c0100a9f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ad5:	0f b6 00             	movzbl (%eax),%eax
c0100ad8:	84 c0                	test   %al,%al
c0100ada:	75 02                	jne    c0100ade <parse+0x4e>
            break;
c0100adc:	eb 67                	jmp    c0100b45 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ade:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ae2:	75 14                	jne    c0100af8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ae4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100aeb:	00 
c0100aec:	c7 04 24 d5 9e 10 c0 	movl   $0xc0109ed5,(%esp)
c0100af3:	e8 5b f8 ff ff       	call   c0100353 <cprintf>
        }
        argv[argc ++] = buf;
c0100af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100afb:	8d 50 01             	lea    0x1(%eax),%edx
c0100afe:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b01:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b0b:	01 c2                	add    %eax,%edx
c0100b0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b10:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b12:	eb 04                	jmp    c0100b18 <parse+0x88>
            buf ++;
c0100b14:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b1b:	0f b6 00             	movzbl (%eax),%eax
c0100b1e:	84 c0                	test   %al,%al
c0100b20:	74 1d                	je     c0100b3f <parse+0xaf>
c0100b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b25:	0f b6 00             	movzbl (%eax),%eax
c0100b28:	0f be c0             	movsbl %al,%eax
c0100b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b2f:	c7 04 24 d0 9e 10 c0 	movl   $0xc0109ed0,(%esp)
c0100b36:	e8 07 8e 00 00       	call   c0109942 <strchr>
c0100b3b:	85 c0                	test   %eax,%eax
c0100b3d:	74 d5                	je     c0100b14 <parse+0x84>
            buf ++;
        }
    }
c0100b3f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b40:	e9 66 ff ff ff       	jmp    c0100aab <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b48:	c9                   	leave  
c0100b49:	c3                   	ret    

c0100b4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b4a:	55                   	push   %ebp
c0100b4b:	89 e5                	mov    %esp,%ebp
c0100b4d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b50:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b5a:	89 04 24             	mov    %eax,(%esp)
c0100b5d:	e8 2e ff ff ff       	call   c0100a90 <parse>
c0100b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b69:	75 0a                	jne    c0100b75 <runcmd+0x2b>
        return 0;
c0100b6b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b70:	e9 85 00 00 00       	jmp    c0100bfa <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b7c:	eb 5c                	jmp    c0100bda <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b7e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b81:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b84:	89 d0                	mov    %edx,%eax
c0100b86:	01 c0                	add    %eax,%eax
c0100b88:	01 d0                	add    %edx,%eax
c0100b8a:	c1 e0 02             	shl    $0x2,%eax
c0100b8d:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100b92:	8b 00                	mov    (%eax),%eax
c0100b94:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b98:	89 04 24             	mov    %eax,(%esp)
c0100b9b:	e8 03 8d 00 00       	call   c01098a3 <strcmp>
c0100ba0:	85 c0                	test   %eax,%eax
c0100ba2:	75 32                	jne    c0100bd6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ba4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ba7:	89 d0                	mov    %edx,%eax
c0100ba9:	01 c0                	add    %eax,%eax
c0100bab:	01 d0                	add    %edx,%eax
c0100bad:	c1 e0 02             	shl    $0x2,%eax
c0100bb0:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100bb5:	8b 40 08             	mov    0x8(%eax),%eax
c0100bb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bbb:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bc1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bc5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bc8:	83 c2 04             	add    $0x4,%edx
c0100bcb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bcf:	89 0c 24             	mov    %ecx,(%esp)
c0100bd2:	ff d0                	call   *%eax
c0100bd4:	eb 24                	jmp    c0100bfa <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdd:	83 f8 02             	cmp    $0x2,%eax
c0100be0:	76 9c                	jbe    c0100b7e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100be2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100be5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100be9:	c7 04 24 f3 9e 10 c0 	movl   $0xc0109ef3,(%esp)
c0100bf0:	e8 5e f7 ff ff       	call   c0100353 <cprintf>
    return 0;
c0100bf5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bfa:	c9                   	leave  
c0100bfb:	c3                   	ret    

c0100bfc <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bfc:	55                   	push   %ebp
c0100bfd:	89 e5                	mov    %esp,%ebp
c0100bff:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c02:	c7 04 24 0c 9f 10 c0 	movl   $0xc0109f0c,(%esp)
c0100c09:	e8 45 f7 ff ff       	call   c0100353 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100c0e:	c7 04 24 34 9f 10 c0 	movl   $0xc0109f34,(%esp)
c0100c15:	e8 39 f7 ff ff       	call   c0100353 <cprintf>

    if (tf != NULL) {
c0100c1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c1e:	74 0b                	je     c0100c2b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c20:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c23:	89 04 24             	mov    %eax,(%esp)
c0100c26:	e8 4c 16 00 00       	call   c0102277 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c2b:	c7 04 24 59 9f 10 c0 	movl   $0xc0109f59,(%esp)
c0100c32:	e8 13 f6 ff ff       	call   c010024a <readline>
c0100c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c3a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c3e:	74 18                	je     c0100c58 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 04 24             	mov    %eax,(%esp)
c0100c4d:	e8 f8 fe ff ff       	call   c0100b4a <runcmd>
c0100c52:	85 c0                	test   %eax,%eax
c0100c54:	79 02                	jns    c0100c58 <kmonitor+0x5c>
                break;
c0100c56:	eb 02                	jmp    c0100c5a <kmonitor+0x5e>
            }
        }
    }
c0100c58:	eb d1                	jmp    c0100c2b <kmonitor+0x2f>
}
c0100c5a:	c9                   	leave  
c0100c5b:	c3                   	ret    

c0100c5c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c5c:	55                   	push   %ebp
c0100c5d:	89 e5                	mov    %esp,%ebp
c0100c5f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c69:	eb 3f                	jmp    c0100caa <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c6b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c6e:	89 d0                	mov    %edx,%eax
c0100c70:	01 c0                	add    %eax,%eax
c0100c72:	01 d0                	add    %edx,%eax
c0100c74:	c1 e0 02             	shl    $0x2,%eax
c0100c77:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c7c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c82:	89 d0                	mov    %edx,%eax
c0100c84:	01 c0                	add    %eax,%eax
c0100c86:	01 d0                	add    %edx,%eax
c0100c88:	c1 e0 02             	shl    $0x2,%eax
c0100c8b:	05 20 40 12 c0       	add    $0xc0124020,%eax
c0100c90:	8b 00                	mov    (%eax),%eax
c0100c92:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c9a:	c7 04 24 5d 9f 10 c0 	movl   $0xc0109f5d,(%esp)
c0100ca1:	e8 ad f6 ff ff       	call   c0100353 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cad:	83 f8 02             	cmp    $0x2,%eax
c0100cb0:	76 b9                	jbe    c0100c6b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb7:	c9                   	leave  
c0100cb8:	c3                   	ret    

c0100cb9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100cb9:	55                   	push   %ebp
c0100cba:	89 e5                	mov    %esp,%ebp
c0100cbc:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100cbf:	e8 c3 fb ff ff       	call   c0100887 <print_kerninfo>
    return 0;
c0100cc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc9:	c9                   	leave  
c0100cca:	c3                   	ret    

c0100ccb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ccb:	55                   	push   %ebp
c0100ccc:	89 e5                	mov    %esp,%ebp
c0100cce:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cd1:	e8 fb fc ff ff       	call   c01009d1 <print_stackframe>
    return 0;
c0100cd6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cdb:	c9                   	leave  
c0100cdc:	c3                   	ret    

c0100cdd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cdd:	55                   	push   %ebp
c0100cde:	89 e5                	mov    %esp,%ebp
c0100ce0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100ce3:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
c0100ce8:	85 c0                	test   %eax,%eax
c0100cea:	74 02                	je     c0100cee <__panic+0x11>
        goto panic_dead;
c0100cec:	eb 48                	jmp    c0100d36 <__panic+0x59>
    }
    is_panic = 1;
c0100cee:	c7 05 c0 4e 12 c0 01 	movl   $0x1,0xc0124ec0
c0100cf5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cf8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d01:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d08:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0c:	c7 04 24 66 9f 10 c0 	movl   $0xc0109f66,(%esp)
c0100d13:	e8 3b f6 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d1f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d22:	89 04 24             	mov    %eax,(%esp)
c0100d25:	e8 f6 f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d2a:	c7 04 24 82 9f 10 c0 	movl   $0xc0109f82,(%esp)
c0100d31:	e8 1d f6 ff ff       	call   c0100353 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d36:	e8 fa 11 00 00       	call   c0101f35 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d42:	e8 b5 fe ff ff       	call   c0100bfc <kmonitor>
    }
c0100d47:	eb f2                	jmp    c0100d3b <__panic+0x5e>

c0100d49 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d49:	55                   	push   %ebp
c0100d4a:	89 e5                	mov    %esp,%ebp
c0100d4c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d4f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d55:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d58:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d63:	c7 04 24 84 9f 10 c0 	movl   $0xc0109f84,(%esp)
c0100d6a:	e8 e4 f5 ff ff       	call   c0100353 <cprintf>
    vcprintf(fmt, ap);
c0100d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d76:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d79:	89 04 24             	mov    %eax,(%esp)
c0100d7c:	e8 9f f5 ff ff       	call   c0100320 <vcprintf>
    cprintf("\n");
c0100d81:	c7 04 24 82 9f 10 c0 	movl   $0xc0109f82,(%esp)
c0100d88:	e8 c6 f5 ff ff       	call   c0100353 <cprintf>
    va_end(ap);
}
c0100d8d:	c9                   	leave  
c0100d8e:	c3                   	ret    

c0100d8f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d8f:	55                   	push   %ebp
c0100d90:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d92:	a1 c0 4e 12 c0       	mov    0xc0124ec0,%eax
}
c0100d97:	5d                   	pop    %ebp
c0100d98:	c3                   	ret    

c0100d99 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d99:	55                   	push   %ebp
c0100d9a:	89 e5                	mov    %esp,%ebp
c0100d9c:	83 ec 28             	sub    $0x28,%esp
c0100d9f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100da5:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100da9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dad:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100db1:	ee                   	out    %al,(%dx)
c0100db2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100db8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dbc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dc0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dc4:	ee                   	out    %al,(%dx)
c0100dc5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dcb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dcf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dd3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dd7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dd8:	c7 05 14 7b 12 c0 00 	movl   $0x0,0xc0127b14
c0100ddf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100de2:	c7 04 24 a2 9f 10 c0 	movl   $0xc0109fa2,(%esp)
c0100de9:	e8 65 f5 ff ff       	call   c0100353 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100df5:	e8 99 11 00 00       	call   c0101f93 <pic_enable>
}
c0100dfa:	c9                   	leave  
c0100dfb:	c3                   	ret    

c0100dfc <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dfc:	55                   	push   %ebp
c0100dfd:	89 e5                	mov    %esp,%ebp
c0100dff:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e02:	9c                   	pushf  
c0100e03:	58                   	pop    %eax
c0100e04:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e0a:	25 00 02 00 00       	and    $0x200,%eax
c0100e0f:	85 c0                	test   %eax,%eax
c0100e11:	74 0c                	je     c0100e1f <__intr_save+0x23>
        intr_disable();
c0100e13:	e8 1d 11 00 00       	call   c0101f35 <intr_disable>
        return 1;
c0100e18:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e1d:	eb 05                	jmp    c0100e24 <__intr_save+0x28>
    }
    return 0;
c0100e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e24:	c9                   	leave  
c0100e25:	c3                   	ret    

c0100e26 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e26:	55                   	push   %ebp
c0100e27:	89 e5                	mov    %esp,%ebp
c0100e29:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e30:	74 05                	je     c0100e37 <__intr_restore+0x11>
        intr_enable();
c0100e32:	e8 f8 10 00 00       	call   c0101f2f <intr_enable>
    }
}
c0100e37:	c9                   	leave  
c0100e38:	c3                   	ret    

c0100e39 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e39:	55                   	push   %ebp
c0100e3a:	89 e5                	mov    %esp,%ebp
c0100e3c:	83 ec 10             	sub    $0x10,%esp
c0100e3f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e45:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e4f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e55:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e5f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e65:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e6f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e75:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e79:	89 c2                	mov    %eax,%edx
c0100e7b:	ec                   	in     (%dx),%al
c0100e7c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e7f:	c9                   	leave  
c0100e80:	c3                   	ret    

c0100e81 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e81:	55                   	push   %ebp
c0100e82:	89 e5                	mov    %esp,%ebp
c0100e84:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e87:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e91:	0f b7 00             	movzwl (%eax),%eax
c0100e94:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e98:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea3:	0f b7 00             	movzwl (%eax),%eax
c0100ea6:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eaa:	74 12                	je     c0100ebe <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eac:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100eb3:	66 c7 05 e6 4e 12 c0 	movw   $0x3b4,0xc0124ee6
c0100eba:	b4 03 
c0100ebc:	eb 13                	jmp    c0100ed1 <cga_init+0x50>
    } else {
        *cp = was;
c0100ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ec1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ec5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec8:	66 c7 05 e6 4e 12 c0 	movw   $0x3d4,0xc0124ee6
c0100ecf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed1:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ed8:	0f b7 c0             	movzwl %ax,%eax
c0100edb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100edf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ee7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eeb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eec:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100ef3:	83 c0 01             	add    $0x1,%eax
c0100ef6:	0f b7 c0             	movzwl %ax,%eax
c0100ef9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efd:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f01:	89 c2                	mov    %eax,%edx
c0100f03:	ec                   	in     (%dx),%al
c0100f04:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f07:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f0b:	0f b6 c0             	movzbl %al,%eax
c0100f0e:	c1 e0 08             	shl    $0x8,%eax
c0100f11:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f14:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f1b:	0f b7 c0             	movzwl %ax,%eax
c0100f1e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f22:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f2e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f2f:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0100f36:	83 c0 01             	add    $0x1,%eax
c0100f39:	0f b7 c0             	movzwl %ax,%eax
c0100f3c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f40:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f44:	89 c2                	mov    %eax,%edx
c0100f46:	ec                   	in     (%dx),%al
c0100f47:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f4e:	0f b6 c0             	movzbl %al,%eax
c0100f51:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f57:	a3 e0 4e 12 c0       	mov    %eax,0xc0124ee0
    crt_pos = pos;
c0100f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f5f:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
}
c0100f65:	c9                   	leave  
c0100f66:	c3                   	ret    

c0100f67 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f67:	55                   	push   %ebp
c0100f68:	89 e5                	mov    %esp,%ebp
c0100f6a:	83 ec 48             	sub    $0x48,%esp
c0100f6d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f73:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f7f:	ee                   	out    %al,(%dx)
c0100f80:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f86:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f92:	ee                   	out    %al,(%dx)
c0100f93:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f99:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fa1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fa5:	ee                   	out    %al,(%dx)
c0100fa6:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fac:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fb8:	ee                   	out    %al,(%dx)
c0100fb9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fbf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fc3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fc7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fcb:	ee                   	out    %al,(%dx)
c0100fcc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fd2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fd6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fda:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fde:	ee                   	out    %al,(%dx)
c0100fdf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fe5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fe9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fed:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100ff1:	ee                   	out    %al,(%dx)
c0100ff2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100ffc:	89 c2                	mov    %eax,%edx
c0100ffe:	ec                   	in     (%dx),%al
c0100fff:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101002:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101006:	3c ff                	cmp    $0xff,%al
c0101008:	0f 95 c0             	setne  %al
c010100b:	0f b6 c0             	movzbl %al,%eax
c010100e:	a3 e8 4e 12 c0       	mov    %eax,0xc0124ee8
c0101013:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101019:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101023:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101029:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010102d:	89 c2                	mov    %eax,%edx
c010102f:	ec                   	in     (%dx),%al
c0101030:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101033:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c0101038:	85 c0                	test   %eax,%eax
c010103a:	74 0c                	je     c0101048 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010103c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101043:	e8 4b 0f 00 00       	call   c0101f93 <pic_enable>
    }
}
c0101048:	c9                   	leave  
c0101049:	c3                   	ret    

c010104a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010104a:	55                   	push   %ebp
c010104b:	89 e5                	mov    %esp,%ebp
c010104d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101050:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101057:	eb 09                	jmp    c0101062 <lpt_putc_sub+0x18>
        delay();
c0101059:	e8 db fd ff ff       	call   c0100e39 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010105e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101062:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101068:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010106c:	89 c2                	mov    %eax,%edx
c010106e:	ec                   	in     (%dx),%al
c010106f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101072:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101076:	84 c0                	test   %al,%al
c0101078:	78 09                	js     c0101083 <lpt_putc_sub+0x39>
c010107a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101081:	7e d6                	jle    c0101059 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101083:	8b 45 08             	mov    0x8(%ebp),%eax
c0101086:	0f b6 c0             	movzbl %al,%eax
c0101089:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010108f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101092:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101096:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109a:	ee                   	out    %al,(%dx)
c010109b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010a1:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010a5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010a9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010ad:	ee                   	out    %al,(%dx)
c01010ae:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010b4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010b8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010bc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010c1:	c9                   	leave  
c01010c2:	c3                   	ret    

c01010c3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010c3:	55                   	push   %ebp
c01010c4:	89 e5                	mov    %esp,%ebp
c01010c6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010c9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010cd:	74 0d                	je     c01010dc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d2:	89 04 24             	mov    %eax,(%esp)
c01010d5:	e8 70 ff ff ff       	call   c010104a <lpt_putc_sub>
c01010da:	eb 24                	jmp    c0101100 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010dc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010e3:	e8 62 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010e8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010ef:	e8 56 ff ff ff       	call   c010104a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010f4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010fb:	e8 4a ff ff ff       	call   c010104a <lpt_putc_sub>
    }
}
c0101100:	c9                   	leave  
c0101101:	c3                   	ret    

c0101102 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101102:	55                   	push   %ebp
c0101103:	89 e5                	mov    %esp,%ebp
c0101105:	53                   	push   %ebx
c0101106:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	b0 00                	mov    $0x0,%al
c010110e:	85 c0                	test   %eax,%eax
c0101110:	75 07                	jne    c0101119 <cga_putc+0x17>
        c |= 0x0700;
c0101112:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101119:	8b 45 08             	mov    0x8(%ebp),%eax
c010111c:	0f b6 c0             	movzbl %al,%eax
c010111f:	83 f8 0a             	cmp    $0xa,%eax
c0101122:	74 4c                	je     c0101170 <cga_putc+0x6e>
c0101124:	83 f8 0d             	cmp    $0xd,%eax
c0101127:	74 57                	je     c0101180 <cga_putc+0x7e>
c0101129:	83 f8 08             	cmp    $0x8,%eax
c010112c:	0f 85 88 00 00 00    	jne    c01011ba <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101132:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101139:	66 85 c0             	test   %ax,%ax
c010113c:	74 30                	je     c010116e <cga_putc+0x6c>
            crt_pos --;
c010113e:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101145:	83 e8 01             	sub    $0x1,%eax
c0101148:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010114e:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c0101153:	0f b7 15 e4 4e 12 c0 	movzwl 0xc0124ee4,%edx
c010115a:	0f b7 d2             	movzwl %dx,%edx
c010115d:	01 d2                	add    %edx,%edx
c010115f:	01 c2                	add    %eax,%edx
c0101161:	8b 45 08             	mov    0x8(%ebp),%eax
c0101164:	b0 00                	mov    $0x0,%al
c0101166:	83 c8 20             	or     $0x20,%eax
c0101169:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010116c:	eb 72                	jmp    c01011e0 <cga_putc+0xde>
c010116e:	eb 70                	jmp    c01011e0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101170:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c0101177:	83 c0 50             	add    $0x50,%eax
c010117a:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101180:	0f b7 1d e4 4e 12 c0 	movzwl 0xc0124ee4,%ebx
c0101187:	0f b7 0d e4 4e 12 c0 	movzwl 0xc0124ee4,%ecx
c010118e:	0f b7 c1             	movzwl %cx,%eax
c0101191:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101197:	c1 e8 10             	shr    $0x10,%eax
c010119a:	89 c2                	mov    %eax,%edx
c010119c:	66 c1 ea 06          	shr    $0x6,%dx
c01011a0:	89 d0                	mov    %edx,%eax
c01011a2:	c1 e0 02             	shl    $0x2,%eax
c01011a5:	01 d0                	add    %edx,%eax
c01011a7:	c1 e0 04             	shl    $0x4,%eax
c01011aa:	29 c1                	sub    %eax,%ecx
c01011ac:	89 ca                	mov    %ecx,%edx
c01011ae:	89 d8                	mov    %ebx,%eax
c01011b0:	29 d0                	sub    %edx,%eax
c01011b2:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
        break;
c01011b8:	eb 26                	jmp    c01011e0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011ba:	8b 0d e0 4e 12 c0    	mov    0xc0124ee0,%ecx
c01011c0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011c7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ca:	66 89 15 e4 4e 12 c0 	mov    %dx,0xc0124ee4
c01011d1:	0f b7 c0             	movzwl %ax,%eax
c01011d4:	01 c0                	add    %eax,%eax
c01011d6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011dc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011df:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011e0:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01011e7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011eb:	76 5b                	jbe    c0101248 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011ed:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011f2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011f8:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c01011fd:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101204:	00 
c0101205:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101209:	89 04 24             	mov    %eax,(%esp)
c010120c:	e8 2f 89 00 00       	call   c0109b40 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101211:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101218:	eb 15                	jmp    c010122f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010121a:	a1 e0 4e 12 c0       	mov    0xc0124ee0,%eax
c010121f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101222:	01 d2                	add    %edx,%edx
c0101224:	01 d0                	add    %edx,%eax
c0101226:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010122b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010122f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101236:	7e e2                	jle    c010121a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101238:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010123f:	83 e8 50             	sub    $0x50,%eax
c0101242:	66 a3 e4 4e 12 c0    	mov    %ax,0xc0124ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101248:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c010124f:	0f b7 c0             	movzwl %ax,%eax
c0101252:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101256:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010125a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010125e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101262:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101263:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c010126a:	66 c1 e8 08          	shr    $0x8,%ax
c010126e:	0f b6 c0             	movzbl %al,%eax
c0101271:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c0101278:	83 c2 01             	add    $0x1,%edx
c010127b:	0f b7 d2             	movzwl %dx,%edx
c010127e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101282:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101285:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101289:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010128d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010128e:	0f b7 05 e6 4e 12 c0 	movzwl 0xc0124ee6,%eax
c0101295:	0f b7 c0             	movzwl %ax,%eax
c0101298:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010129c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012a0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012a4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012a8:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012a9:	0f b7 05 e4 4e 12 c0 	movzwl 0xc0124ee4,%eax
c01012b0:	0f b6 c0             	movzbl %al,%eax
c01012b3:	0f b7 15 e6 4e 12 c0 	movzwl 0xc0124ee6,%edx
c01012ba:	83 c2 01             	add    $0x1,%edx
c01012bd:	0f b7 d2             	movzwl %dx,%edx
c01012c0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012c4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012c7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012cb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012cf:	ee                   	out    %al,(%dx)
}
c01012d0:	83 c4 34             	add    $0x34,%esp
c01012d3:	5b                   	pop    %ebx
c01012d4:	5d                   	pop    %ebp
c01012d5:	c3                   	ret    

c01012d6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012d6:	55                   	push   %ebp
c01012d7:	89 e5                	mov    %esp,%ebp
c01012d9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012e3:	eb 09                	jmp    c01012ee <serial_putc_sub+0x18>
        delay();
c01012e5:	e8 4f fb ff ff       	call   c0100e39 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 20             	and    $0x20,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 09                	jne    c0101315 <serial_putc_sub+0x3f>
c010130c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101313:	7e d0                	jle    c01012e5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101315:	8b 45 08             	mov    0x8(%ebp),%eax
c0101318:	0f b6 c0             	movzbl %al,%eax
c010131b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101321:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101324:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101328:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010132c:	ee                   	out    %al,(%dx)
}
c010132d:	c9                   	leave  
c010132e:	c3                   	ret    

c010132f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010132f:	55                   	push   %ebp
c0101330:	89 e5                	mov    %esp,%ebp
c0101332:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101335:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101339:	74 0d                	je     c0101348 <serial_putc+0x19>
        serial_putc_sub(c);
c010133b:	8b 45 08             	mov    0x8(%ebp),%eax
c010133e:	89 04 24             	mov    %eax,(%esp)
c0101341:	e8 90 ff ff ff       	call   c01012d6 <serial_putc_sub>
c0101346:	eb 24                	jmp    c010136c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101348:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010134f:	e8 82 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010135b:	e8 76 ff ff ff       	call   c01012d6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101360:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101367:	e8 6a ff ff ff       	call   c01012d6 <serial_putc_sub>
    }
}
c010136c:	c9                   	leave  
c010136d:	c3                   	ret    

c010136e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010136e:	55                   	push   %ebp
c010136f:	89 e5                	mov    %esp,%ebp
c0101371:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101374:	eb 33                	jmp    c01013a9 <cons_intr+0x3b>
        if (c != 0) {
c0101376:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010137a:	74 2d                	je     c01013a9 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010137c:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101381:	8d 50 01             	lea    0x1(%eax),%edx
c0101384:	89 15 04 51 12 c0    	mov    %edx,0xc0125104
c010138a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010138d:	88 90 00 4f 12 c0    	mov    %dl,-0x3fedb100(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101393:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101398:	3d 00 02 00 00       	cmp    $0x200,%eax
c010139d:	75 0a                	jne    c01013a9 <cons_intr+0x3b>
                cons.wpos = 0;
c010139f:	c7 05 04 51 12 c0 00 	movl   $0x0,0xc0125104
c01013a6:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01013ac:	ff d0                	call   *%eax
c01013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013b5:	75 bf                	jne    c0101376 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013b7:	c9                   	leave  
c01013b8:	c3                   	ret    

c01013b9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013b9:	55                   	push   %ebp
c01013ba:	89 e5                	mov    %esp,%ebp
c01013bc:	83 ec 10             	sub    $0x10,%esp
c01013bf:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013c5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013c9:	89 c2                	mov    %eax,%edx
c01013cb:	ec                   	in     (%dx),%al
c01013cc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013cf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013d3:	0f b6 c0             	movzbl %al,%eax
c01013d6:	83 e0 01             	and    $0x1,%eax
c01013d9:	85 c0                	test   %eax,%eax
c01013db:	75 07                	jne    c01013e4 <serial_proc_data+0x2b>
        return -1;
c01013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013e2:	eb 2a                	jmp    c010140e <serial_proc_data+0x55>
c01013e4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013ea:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ee:	89 c2                	mov    %eax,%edx
c01013f0:	ec                   	in     (%dx),%al
c01013f1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013f4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013f8:	0f b6 c0             	movzbl %al,%eax
c01013fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013fe:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101402:	75 07                	jne    c010140b <serial_proc_data+0x52>
        c = '\b';
c0101404:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010140e:	c9                   	leave  
c010140f:	c3                   	ret    

c0101410 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101410:	55                   	push   %ebp
c0101411:	89 e5                	mov    %esp,%ebp
c0101413:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101416:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	74 0c                	je     c010142b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010141f:	c7 04 24 b9 13 10 c0 	movl   $0xc01013b9,(%esp)
c0101426:	e8 43 ff ff ff       	call   c010136e <cons_intr>
    }
}
c010142b:	c9                   	leave  
c010142c:	c3                   	ret    

c010142d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010142d:	55                   	push   %ebp
c010142e:	89 e5                	mov    %esp,%ebp
c0101430:	83 ec 38             	sub    $0x38,%esp
c0101433:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101439:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010143d:	89 c2                	mov    %eax,%edx
c010143f:	ec                   	in     (%dx),%al
c0101440:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101443:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101447:	0f b6 c0             	movzbl %al,%eax
c010144a:	83 e0 01             	and    $0x1,%eax
c010144d:	85 c0                	test   %eax,%eax
c010144f:	75 0a                	jne    c010145b <kbd_proc_data+0x2e>
        return -1;
c0101451:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101456:	e9 59 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
c010145b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101461:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101465:	89 c2                	mov    %eax,%edx
c0101467:	ec                   	in     (%dx),%al
c0101468:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010146b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010146f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101472:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101476:	75 17                	jne    c010148f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101478:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010147d:	83 c8 40             	or     $0x40,%eax
c0101480:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c0101485:	b8 00 00 00 00       	mov    $0x0,%eax
c010148a:	e9 25 01 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010148f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101493:	84 c0                	test   %al,%al
c0101495:	79 47                	jns    c01014de <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101497:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010149c:	83 e0 40             	and    $0x40,%eax
c010149f:	85 c0                	test   %eax,%eax
c01014a1:	75 09                	jne    c01014ac <kbd_proc_data+0x7f>
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	83 e0 7f             	and    $0x7f,%eax
c01014aa:	eb 04                	jmp    c01014b0 <kbd_proc_data+0x83>
c01014ac:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b7:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c01014be:	83 c8 40             	or     $0x40,%eax
c01014c1:	0f b6 c0             	movzbl %al,%eax
c01014c4:	f7 d0                	not    %eax
c01014c6:	89 c2                	mov    %eax,%edx
c01014c8:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014cd:	21 d0                	and    %edx,%eax
c01014cf:	a3 08 51 12 c0       	mov    %eax,0xc0125108
        return 0;
c01014d4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014d9:	e9 d6 00 00 00       	jmp    c01015b4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014de:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014e3:	83 e0 40             	and    $0x40,%eax
c01014e6:	85 c0                	test   %eax,%eax
c01014e8:	74 11                	je     c01014fb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014ea:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ee:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c01014f3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014f6:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    }

    shift |= shiftcode[data];
c01014fb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ff:	0f b6 80 60 40 12 c0 	movzbl -0x3fedbfa0(%eax),%eax
c0101506:	0f b6 d0             	movzbl %al,%edx
c0101509:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c010150e:	09 d0                	or     %edx,%eax
c0101510:	a3 08 51 12 c0       	mov    %eax,0xc0125108
    shift ^= togglecode[data];
c0101515:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101519:	0f b6 80 60 41 12 c0 	movzbl -0x3fedbea0(%eax),%eax
c0101520:	0f b6 d0             	movzbl %al,%edx
c0101523:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101528:	31 d0                	xor    %edx,%eax
c010152a:	a3 08 51 12 c0       	mov    %eax,0xc0125108

    c = charcode[shift & (CTL | SHIFT)][data];
c010152f:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101534:	83 e0 03             	and    $0x3,%eax
c0101537:	8b 14 85 60 45 12 c0 	mov    -0x3fedbaa0(,%eax,4),%edx
c010153e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101542:	01 d0                	add    %edx,%eax
c0101544:	0f b6 00             	movzbl (%eax),%eax
c0101547:	0f b6 c0             	movzbl %al,%eax
c010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010154d:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101552:	83 e0 08             	and    $0x8,%eax
c0101555:	85 c0                	test   %eax,%eax
c0101557:	74 22                	je     c010157b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101559:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010155d:	7e 0c                	jle    c010156b <kbd_proc_data+0x13e>
c010155f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101563:	7f 06                	jg     c010156b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101565:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101569:	eb 10                	jmp    c010157b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010156b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010156f:	7e 0a                	jle    c010157b <kbd_proc_data+0x14e>
c0101571:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101575:	7f 04                	jg     c010157b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101577:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010157b:	a1 08 51 12 c0       	mov    0xc0125108,%eax
c0101580:	f7 d0                	not    %eax
c0101582:	83 e0 06             	and    $0x6,%eax
c0101585:	85 c0                	test   %eax,%eax
c0101587:	75 28                	jne    c01015b1 <kbd_proc_data+0x184>
c0101589:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101590:	75 1f                	jne    c01015b1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101592:	c7 04 24 bd 9f 10 c0 	movl   $0xc0109fbd,(%esp)
c0101599:	e8 b5 ed ff ff       	call   c0100353 <cprintf>
c010159e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015a4:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015a8:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015ac:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015b0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015b4:	c9                   	leave  
c01015b5:	c3                   	ret    

c01015b6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015b6:	55                   	push   %ebp
c01015b7:	89 e5                	mov    %esp,%ebp
c01015b9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015bc:	c7 04 24 2d 14 10 c0 	movl   $0xc010142d,(%esp)
c01015c3:	e8 a6 fd ff ff       	call   c010136e <cons_intr>
}
c01015c8:	c9                   	leave  
c01015c9:	c3                   	ret    

c01015ca <kbd_init>:

static void
kbd_init(void) {
c01015ca:	55                   	push   %ebp
c01015cb:	89 e5                	mov    %esp,%ebp
c01015cd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015d0:	e8 e1 ff ff ff       	call   c01015b6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015dc:	e8 b2 09 00 00       	call   c0101f93 <pic_enable>
}
c01015e1:	c9                   	leave  
c01015e2:	c3                   	ret    

c01015e3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015e3:	55                   	push   %ebp
c01015e4:	89 e5                	mov    %esp,%ebp
c01015e6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015e9:	e8 93 f8 ff ff       	call   c0100e81 <cga_init>
    serial_init();
c01015ee:	e8 74 f9 ff ff       	call   c0100f67 <serial_init>
    kbd_init();
c01015f3:	e8 d2 ff ff ff       	call   c01015ca <kbd_init>
    if (!serial_exists) {
c01015f8:	a1 e8 4e 12 c0       	mov    0xc0124ee8,%eax
c01015fd:	85 c0                	test   %eax,%eax
c01015ff:	75 0c                	jne    c010160d <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101601:	c7 04 24 c9 9f 10 c0 	movl   $0xc0109fc9,(%esp)
c0101608:	e8 46 ed ff ff       	call   c0100353 <cprintf>
    }
}
c010160d:	c9                   	leave  
c010160e:	c3                   	ret    

c010160f <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010160f:	55                   	push   %ebp
c0101610:	89 e5                	mov    %esp,%ebp
c0101612:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101615:	e8 e2 f7 ff ff       	call   c0100dfc <__intr_save>
c010161a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010161d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101620:	89 04 24             	mov    %eax,(%esp)
c0101623:	e8 9b fa ff ff       	call   c01010c3 <lpt_putc>
        cga_putc(c);
c0101628:	8b 45 08             	mov    0x8(%ebp),%eax
c010162b:	89 04 24             	mov    %eax,(%esp)
c010162e:	e8 cf fa ff ff       	call   c0101102 <cga_putc>
        serial_putc(c);
c0101633:	8b 45 08             	mov    0x8(%ebp),%eax
c0101636:	89 04 24             	mov    %eax,(%esp)
c0101639:	e8 f1 fc ff ff       	call   c010132f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101641:	89 04 24             	mov    %eax,(%esp)
c0101644:	e8 dd f7 ff ff       	call   c0100e26 <__intr_restore>
}
c0101649:	c9                   	leave  
c010164a:	c3                   	ret    

c010164b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010164b:	55                   	push   %ebp
c010164c:	89 e5                	mov    %esp,%ebp
c010164e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101651:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101658:	e8 9f f7 ff ff       	call   c0100dfc <__intr_save>
c010165d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101660:	e8 ab fd ff ff       	call   c0101410 <serial_intr>
        kbd_intr();
c0101665:	e8 4c ff ff ff       	call   c01015b6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010166a:	8b 15 00 51 12 c0    	mov    0xc0125100,%edx
c0101670:	a1 04 51 12 c0       	mov    0xc0125104,%eax
c0101675:	39 c2                	cmp    %eax,%edx
c0101677:	74 31                	je     c01016aa <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101679:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c010167e:	8d 50 01             	lea    0x1(%eax),%edx
c0101681:	89 15 00 51 12 c0    	mov    %edx,0xc0125100
c0101687:	0f b6 80 00 4f 12 c0 	movzbl -0x3fedb100(%eax),%eax
c010168e:	0f b6 c0             	movzbl %al,%eax
c0101691:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101694:	a1 00 51 12 c0       	mov    0xc0125100,%eax
c0101699:	3d 00 02 00 00       	cmp    $0x200,%eax
c010169e:	75 0a                	jne    c01016aa <cons_getc+0x5f>
                cons.rpos = 0;
c01016a0:	c7 05 00 51 12 c0 00 	movl   $0x0,0xc0125100
c01016a7:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016ad:	89 04 24             	mov    %eax,(%esp)
c01016b0:	e8 71 f7 ff ff       	call   c0100e26 <__intr_restore>
    return c;
c01016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016b8:	c9                   	leave  
c01016b9:	c3                   	ret    

c01016ba <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c01016ba:	55                   	push   %ebp
c01016bb:	89 e5                	mov    %esp,%ebp
c01016bd:	83 ec 14             	sub    $0x14,%esp
c01016c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c3:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c01016c7:	90                   	nop
c01016c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016cc:	83 c0 07             	add    $0x7,%eax
c01016cf:	0f b7 c0             	movzwl %ax,%eax
c01016d2:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01016d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01016da:	89 c2                	mov    %eax,%edx
c01016dc:	ec                   	in     (%dx),%al
c01016dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01016e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e4:	0f b6 c0             	movzbl %al,%eax
c01016e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01016ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ed:	25 80 00 00 00       	and    $0x80,%eax
c01016f2:	85 c0                	test   %eax,%eax
c01016f4:	75 d2                	jne    c01016c8 <ide_wait_ready+0xe>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c01016f6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01016fa:	74 11                	je     c010170d <ide_wait_ready+0x53>
c01016fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01016ff:	83 e0 21             	and    $0x21,%eax
c0101702:	85 c0                	test   %eax,%eax
c0101704:	74 07                	je     c010170d <ide_wait_ready+0x53>
        return -1;
c0101706:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010170b:	eb 05                	jmp    c0101712 <ide_wait_ready+0x58>
    }
    return 0;
c010170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101712:	c9                   	leave  
c0101713:	c3                   	ret    

c0101714 <ide_init>:

void
ide_init(void) {
c0101714:	55                   	push   %ebp
c0101715:	89 e5                	mov    %esp,%ebp
c0101717:	57                   	push   %edi
c0101718:	53                   	push   %ebx
c0101719:	81 ec 50 02 00 00    	sub    $0x250,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c010171f:	66 c7 45 f6 00 00    	movw   $0x0,-0xa(%ebp)
c0101725:	e9 d6 02 00 00       	jmp    c0101a00 <ide_init+0x2ec>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c010172a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010172e:	c1 e0 03             	shl    $0x3,%eax
c0101731:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101738:	29 c2                	sub    %eax,%edx
c010173a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101740:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c0101743:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101747:	66 d1 e8             	shr    %ax
c010174a:	0f b7 c0             	movzwl %ax,%eax
c010174d:	0f b7 04 85 e8 9f 10 	movzwl -0x3fef6018(,%eax,4),%eax
c0101754:	c0 
c0101755:	66 89 45 ea          	mov    %ax,-0x16(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c0101759:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010175d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101764:	00 
c0101765:	89 04 24             	mov    %eax,(%esp)
c0101768:	e8 4d ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010176d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101771:	83 e0 01             	and    $0x1,%eax
c0101774:	c1 e0 04             	shl    $0x4,%eax
c0101777:	83 c8 e0             	or     $0xffffffe0,%eax
c010177a:	0f b6 c0             	movzbl %al,%eax
c010177d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101781:	83 c2 06             	add    $0x6,%edx
c0101784:	0f b7 d2             	movzwl %dx,%edx
c0101787:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c010178b:	88 45 d1             	mov    %al,-0x2f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010178e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101792:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101796:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101797:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c010179b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017a2:	00 
c01017a3:	89 04 24             	mov    %eax,(%esp)
c01017a6:	e8 0f ff ff ff       	call   c01016ba <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c01017ab:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017af:	83 c0 07             	add    $0x7,%eax
c01017b2:	0f b7 c0             	movzwl %ax,%eax
c01017b5:	66 89 45 ce          	mov    %ax,-0x32(%ebp)
c01017b9:	c6 45 cd ec          	movb   $0xec,-0x33(%ebp)
c01017bd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01017c1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01017c5:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c01017c6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017ca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017d1:	00 
c01017d2:	89 04 24             	mov    %eax,(%esp)
c01017d5:	e8 e0 fe ff ff       	call   c01016ba <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c01017da:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c01017de:	83 c0 07             	add    $0x7,%eax
c01017e1:	0f b7 c0             	movzwl %ax,%eax
c01017e4:	66 89 45 ca          	mov    %ax,-0x36(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01017e8:	0f b7 45 ca          	movzwl -0x36(%ebp),%eax
c01017ec:	89 c2                	mov    %eax,%edx
c01017ee:	ec                   	in     (%dx),%al
c01017ef:	88 45 c9             	mov    %al,-0x37(%ebp)
    return data;
c01017f2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01017f6:	84 c0                	test   %al,%al
c01017f8:	0f 84 f7 01 00 00    	je     c01019f5 <ide_init+0x2e1>
c01017fe:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101802:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101809:	00 
c010180a:	89 04 24             	mov    %eax,(%esp)
c010180d:	e8 a8 fe ff ff       	call   c01016ba <ide_wait_ready>
c0101812:	85 c0                	test   %eax,%eax
c0101814:	0f 85 db 01 00 00    	jne    c01019f5 <ide_init+0x2e1>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c010181a:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010181e:	c1 e0 03             	shl    $0x3,%eax
c0101821:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101828:	29 c2                	sub    %eax,%edx
c010182a:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101830:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c0101833:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0101837:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010183a:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c0101840:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101843:	c7 45 bc 80 00 00 00 	movl   $0x80,-0x44(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c010184a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010184d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0101850:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0101853:	89 cb                	mov    %ecx,%ebx
c0101855:	89 df                	mov    %ebx,%edi
c0101857:	89 c1                	mov    %eax,%ecx
c0101859:	fc                   	cld    
c010185a:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010185c:	89 c8                	mov    %ecx,%eax
c010185e:	89 fb                	mov    %edi,%ebx
c0101860:	89 5d c0             	mov    %ebx,-0x40(%ebp)
c0101863:	89 45 bc             	mov    %eax,-0x44(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101866:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
c010186c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c010186f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101872:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101878:	89 45 e0             	mov    %eax,-0x20(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010187b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010187e:	25 00 00 00 04       	and    $0x4000000,%eax
c0101883:	85 c0                	test   %eax,%eax
c0101885:	74 0e                	je     c0101895 <ide_init+0x181>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101887:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010188a:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101890:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0101893:	eb 09                	jmp    c010189e <ide_init+0x18a>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101895:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0101898:	8b 40 78             	mov    0x78(%eax),%eax
c010189b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c010189e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018a2:	c1 e0 03             	shl    $0x3,%eax
c01018a5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ac:	29 c2                	sub    %eax,%edx
c01018ae:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01018b7:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c01018ba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01018be:	c1 e0 03             	shl    $0x3,%eax
c01018c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018c8:	29 c2                	sub    %eax,%edx
c01018ca:	81 c2 20 51 12 c0    	add    $0xc0125120,%edx
c01018d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01018d3:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c01018d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01018d9:	83 c0 62             	add    $0x62,%eax
c01018dc:	0f b7 00             	movzwl (%eax),%eax
c01018df:	0f b7 c0             	movzwl %ax,%eax
c01018e2:	25 00 02 00 00       	and    $0x200,%eax
c01018e7:	85 c0                	test   %eax,%eax
c01018e9:	75 24                	jne    c010190f <ide_init+0x1fb>
c01018eb:	c7 44 24 0c f0 9f 10 	movl   $0xc0109ff0,0xc(%esp)
c01018f2:	c0 
c01018f3:	c7 44 24 08 33 a0 10 	movl   $0xc010a033,0x8(%esp)
c01018fa:	c0 
c01018fb:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101902:	00 
c0101903:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c010190a:	e8 ce f3 ff ff       	call   c0100cdd <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c010190f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101913:	c1 e0 03             	shl    $0x3,%eax
c0101916:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010191d:	29 c2                	sub    %eax,%edx
c010191f:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101925:	83 c0 0c             	add    $0xc,%eax
c0101928:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010192b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010192e:	83 c0 36             	add    $0x36,%eax
c0101931:	89 45 d8             	mov    %eax,-0x28(%ebp)
        unsigned int i, length = 40;
c0101934:	c7 45 d4 28 00 00 00 	movl   $0x28,-0x2c(%ebp)
        for (i = 0; i < length; i += 2) {
c010193b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0101942:	eb 34                	jmp    c0101978 <ide_init+0x264>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101944:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101947:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010194a:	01 c2                	add    %eax,%edx
c010194c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010194f:	8d 48 01             	lea    0x1(%eax),%ecx
c0101952:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0101955:	01 c8                	add    %ecx,%eax
c0101957:	0f b6 00             	movzbl (%eax),%eax
c010195a:	88 02                	mov    %al,(%edx)
c010195c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010195f:	8d 50 01             	lea    0x1(%eax),%edx
c0101962:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101965:	01 c2                	add    %eax,%edx
c0101967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010196a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
c010196d:	01 c8                	add    %ecx,%eax
c010196f:	0f b6 00             	movzbl (%eax),%eax
c0101972:	88 02                	mov    %al,(%edx)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101974:	83 45 ec 02          	addl   $0x2,-0x14(%ebp)
c0101978:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010197b:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010197e:	72 c4                	jb     c0101944 <ide_init+0x230>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101980:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101983:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101986:	01 d0                	add    %edx,%eax
c0101988:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c010198b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010198e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0101991:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0101994:	85 c0                	test   %eax,%eax
c0101996:	74 0f                	je     c01019a7 <ide_init+0x293>
c0101998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010199b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010199e:	01 d0                	add    %edx,%eax
c01019a0:	0f b6 00             	movzbl (%eax),%eax
c01019a3:	3c 20                	cmp    $0x20,%al
c01019a5:	74 d9                	je     c0101980 <ide_init+0x26c>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c01019a7:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019ab:	c1 e0 03             	shl    $0x3,%eax
c01019ae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019b5:	29 c2                	sub    %eax,%edx
c01019b7:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019bd:	8d 48 0c             	lea    0xc(%eax),%ecx
c01019c0:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019c4:	c1 e0 03             	shl    $0x3,%eax
c01019c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ce:	29 c2                	sub    %eax,%edx
c01019d0:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c01019d6:	8b 50 08             	mov    0x8(%eax),%edx
c01019d9:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019dd:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01019e1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01019e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019e9:	c7 04 24 5a a0 10 c0 	movl   $0xc010a05a,(%esp)
c01019f0:	e8 5e e9 ff ff       	call   c0100353 <cprintf>

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01019f5:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01019f9:	83 c0 01             	add    $0x1,%eax
c01019fc:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
c0101a00:	66 83 7d f6 03       	cmpw   $0x3,-0xa(%ebp)
c0101a05:	0f 86 1f fd ff ff    	jbe    c010172a <ide_init+0x16>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101a0b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101a12:	e8 7c 05 00 00       	call   c0101f93 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101a17:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101a1e:	e8 70 05 00 00       	call   c0101f93 <pic_enable>
}
c0101a23:	81 c4 50 02 00 00    	add    $0x250,%esp
c0101a29:	5b                   	pop    %ebx
c0101a2a:	5f                   	pop    %edi
c0101a2b:	5d                   	pop    %ebp
c0101a2c:	c3                   	ret    

c0101a2d <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101a2d:	55                   	push   %ebp
c0101a2e:	89 e5                	mov    %esp,%ebp
c0101a30:	83 ec 04             	sub    $0x4,%esp
c0101a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101a3a:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101a3f:	77 24                	ja     c0101a65 <ide_device_valid+0x38>
c0101a41:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a45:	c1 e0 03             	shl    $0x3,%eax
c0101a48:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a4f:	29 c2                	sub    %eax,%edx
c0101a51:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a57:	0f b6 00             	movzbl (%eax),%eax
c0101a5a:	84 c0                	test   %al,%al
c0101a5c:	74 07                	je     c0101a65 <ide_device_valid+0x38>
c0101a5e:	b8 01 00 00 00       	mov    $0x1,%eax
c0101a63:	eb 05                	jmp    c0101a6a <ide_device_valid+0x3d>
c0101a65:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101a6a:	c9                   	leave  
c0101a6b:	c3                   	ret    

c0101a6c <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101a6c:	55                   	push   %ebp
c0101a6d:	89 e5                	mov    %esp,%ebp
c0101a6f:	83 ec 08             	sub    $0x8,%esp
c0101a72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a75:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101a79:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a7d:	89 04 24             	mov    %eax,(%esp)
c0101a80:	e8 a8 ff ff ff       	call   c0101a2d <ide_device_valid>
c0101a85:	85 c0                	test   %eax,%eax
c0101a87:	74 1b                	je     c0101aa4 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101a89:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101a8d:	c1 e0 03             	shl    $0x3,%eax
c0101a90:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a97:	29 c2                	sub    %eax,%edx
c0101a99:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101a9f:	8b 40 08             	mov    0x8(%eax),%eax
c0101aa2:	eb 05                	jmp    c0101aa9 <ide_device_size+0x3d>
    }
    return 0;
c0101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101aa9:	c9                   	leave  
c0101aaa:	c3                   	ret    

c0101aab <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101aab:	55                   	push   %ebp
c0101aac:	89 e5                	mov    %esp,%ebp
c0101aae:	57                   	push   %edi
c0101aaf:	53                   	push   %ebx
c0101ab0:	83 ec 50             	sub    $0x50,%esp
c0101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab6:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101aba:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101ac1:	77 24                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101ac3:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101ac8:	77 1d                	ja     c0101ae7 <ide_read_secs+0x3c>
c0101aca:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ace:	c1 e0 03             	shl    $0x3,%eax
c0101ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ad8:	29 c2                	sub    %eax,%edx
c0101ada:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101ae0:	0f b6 00             	movzbl (%eax),%eax
c0101ae3:	84 c0                	test   %al,%al
c0101ae5:	75 24                	jne    c0101b0b <ide_read_secs+0x60>
c0101ae7:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c0101aee:	c0 
c0101aef:	c7 44 24 08 33 a0 10 	movl   $0xc010a033,0x8(%esp)
c0101af6:	c0 
c0101af7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101afe:	00 
c0101aff:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c0101b06:	e8 d2 f1 ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101b0b:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101b12:	77 0f                	ja     c0101b23 <ide_read_secs+0x78>
c0101b14:	8b 45 14             	mov    0x14(%ebp),%eax
c0101b17:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101b1a:	01 d0                	add    %edx,%eax
c0101b1c:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101b21:	76 24                	jbe    c0101b47 <ide_read_secs+0x9c>
c0101b23:	c7 44 24 0c a0 a0 10 	movl   $0xc010a0a0,0xc(%esp)
c0101b2a:	c0 
c0101b2b:	c7 44 24 08 33 a0 10 	movl   $0xc010a033,0x8(%esp)
c0101b32:	c0 
c0101b33:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101b3a:	00 
c0101b3b:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c0101b42:	e8 96 f1 ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101b47:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b4b:	66 d1 e8             	shr    %ax
c0101b4e:	0f b7 c0             	movzwl %ax,%eax
c0101b51:	0f b7 04 85 e8 9f 10 	movzwl -0x3fef6018(,%eax,4),%eax
c0101b58:	c0 
c0101b59:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101b5d:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101b61:	66 d1 e8             	shr    %ax
c0101b64:	0f b7 c0             	movzwl %ax,%eax
c0101b67:	0f b7 04 85 ea 9f 10 	movzwl -0x3fef6016(,%eax,4),%eax
c0101b6e:	c0 
c0101b6f:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101b73:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101b77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101b7e:	00 
c0101b7f:	89 04 24             	mov    %eax,(%esp)
c0101b82:	e8 33 fb ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101b87:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101b8b:	83 c0 02             	add    $0x2,%eax
c0101b8e:	0f b7 c0             	movzwl %ax,%eax
c0101b91:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101b95:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101b99:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101b9d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101ba1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101ba2:	8b 45 14             	mov    0x14(%ebp),%eax
c0101ba5:	0f b6 c0             	movzbl %al,%eax
c0101ba8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bac:	83 c2 02             	add    $0x2,%edx
c0101baf:	0f b7 d2             	movzwl %dx,%edx
c0101bb2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101bb6:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101bb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101bbd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101bc1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101bc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101bc5:	0f b6 c0             	movzbl %al,%eax
c0101bc8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bcc:	83 c2 03             	add    $0x3,%edx
c0101bcf:	0f b7 d2             	movzwl %dx,%edx
c0101bd2:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101bd6:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101bd9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101bdd:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101be1:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101be2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101be5:	c1 e8 08             	shr    $0x8,%eax
c0101be8:	0f b6 c0             	movzbl %al,%eax
c0101beb:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101bef:	83 c2 04             	add    $0x4,%edx
c0101bf2:	0f b7 d2             	movzwl %dx,%edx
c0101bf5:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101bf9:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101bfc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101c00:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c04:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c08:	c1 e8 10             	shr    $0x10,%eax
c0101c0b:	0f b6 c0             	movzbl %al,%eax
c0101c0e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c12:	83 c2 05             	add    $0x5,%edx
c0101c15:	0f b7 d2             	movzwl %dx,%edx
c0101c18:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101c1c:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101c1f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c23:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c27:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101c28:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101c2c:	83 e0 01             	and    $0x1,%eax
c0101c2f:	c1 e0 04             	shl    $0x4,%eax
c0101c32:	89 c2                	mov    %eax,%edx
c0101c34:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c37:	c1 e8 18             	shr    $0x18,%eax
c0101c3a:	83 e0 0f             	and    $0xf,%eax
c0101c3d:	09 d0                	or     %edx,%eax
c0101c3f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101c42:	0f b6 c0             	movzbl %al,%eax
c0101c45:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101c49:	83 c2 06             	add    $0x6,%edx
c0101c4c:	0f b7 d2             	movzwl %dx,%edx
c0101c4f:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c53:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c56:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c5a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c5e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101c5f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c63:	83 c0 07             	add    $0x7,%eax
c0101c66:	0f b7 c0             	movzwl %ax,%eax
c0101c69:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101c6d:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101c71:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c75:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c79:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101c81:	eb 5a                	jmp    c0101cdd <ide_read_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101c83:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101c87:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101c8e:	00 
c0101c8f:	89 04 24             	mov    %eax,(%esp)
c0101c92:	e8 23 fa ff ff       	call   c01016ba <ide_wait_ready>
c0101c97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101c9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101c9e:	74 02                	je     c0101ca2 <ide_read_secs+0x1f7>
            goto out;
c0101ca0:	eb 41                	jmp    c0101ce3 <ide_read_secs+0x238>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101ca2:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101ca9:	8b 45 10             	mov    0x10(%ebp),%eax
c0101cac:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101caf:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101cb6:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101cb9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101cbc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101cbf:	89 cb                	mov    %ecx,%ebx
c0101cc1:	89 df                	mov    %ebx,%edi
c0101cc3:	89 c1                	mov    %eax,%ecx
c0101cc5:	fc                   	cld    
c0101cc6:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101cc8:	89 c8                	mov    %ecx,%eax
c0101cca:	89 fb                	mov    %edi,%ebx
c0101ccc:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101ccf:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101cd2:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101cd6:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101cdd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101ce1:	75 a0                	jne    c0101c83 <ide_read_secs+0x1d8>
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101ce6:	83 c4 50             	add    $0x50,%esp
c0101ce9:	5b                   	pop    %ebx
c0101cea:	5f                   	pop    %edi
c0101ceb:	5d                   	pop    %ebp
c0101cec:	c3                   	ret    

c0101ced <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101ced:	55                   	push   %ebp
c0101cee:	89 e5                	mov    %esp,%ebp
c0101cf0:	56                   	push   %esi
c0101cf1:	53                   	push   %ebx
c0101cf2:	83 ec 50             	sub    $0x50,%esp
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101cfc:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101d03:	77 24                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d05:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101d0a:	77 1d                	ja     c0101d29 <ide_write_secs+0x3c>
c0101d0c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d10:	c1 e0 03             	shl    $0x3,%eax
c0101d13:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101d1a:	29 c2                	sub    %eax,%edx
c0101d1c:	8d 82 20 51 12 c0    	lea    -0x3fedaee0(%edx),%eax
c0101d22:	0f b6 00             	movzbl (%eax),%eax
c0101d25:	84 c0                	test   %al,%al
c0101d27:	75 24                	jne    c0101d4d <ide_write_secs+0x60>
c0101d29:	c7 44 24 0c 78 a0 10 	movl   $0xc010a078,0xc(%esp)
c0101d30:	c0 
c0101d31:	c7 44 24 08 33 a0 10 	movl   $0xc010a033,0x8(%esp)
c0101d38:	c0 
c0101d39:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d40:	00 
c0101d41:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c0101d48:	e8 90 ef ff ff       	call   c0100cdd <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101d4d:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101d54:	77 0f                	ja     c0101d65 <ide_write_secs+0x78>
c0101d56:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d59:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101d5c:	01 d0                	add    %edx,%eax
c0101d5e:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101d63:	76 24                	jbe    c0101d89 <ide_write_secs+0x9c>
c0101d65:	c7 44 24 0c a0 a0 10 	movl   $0xc010a0a0,0xc(%esp)
c0101d6c:	c0 
c0101d6d:	c7 44 24 08 33 a0 10 	movl   $0xc010a033,0x8(%esp)
c0101d74:	c0 
c0101d75:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101d7c:	00 
c0101d7d:	c7 04 24 48 a0 10 c0 	movl   $0xc010a048,(%esp)
c0101d84:	e8 54 ef ff ff       	call   c0100cdd <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101d89:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101d8d:	66 d1 e8             	shr    %ax
c0101d90:	0f b7 c0             	movzwl %ax,%eax
c0101d93:	0f b7 04 85 e8 9f 10 	movzwl -0x3fef6018(,%eax,4),%eax
c0101d9a:	c0 
c0101d9b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101d9f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101da3:	66 d1 e8             	shr    %ax
c0101da6:	0f b7 c0             	movzwl %ax,%eax
c0101da9:	0f b7 04 85 ea 9f 10 	movzwl -0x3fef6016(,%eax,4),%eax
c0101db0:	c0 
c0101db1:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101db5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101db9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101dc0:	00 
c0101dc1:	89 04 24             	mov    %eax,(%esp)
c0101dc4:	e8 f1 f8 ff ff       	call   c01016ba <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101dc9:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101dcd:	83 c0 02             	add    $0x2,%eax
c0101dd0:	0f b7 c0             	movzwl %ax,%eax
c0101dd3:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101dd7:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101ddb:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101ddf:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101de3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101de4:	8b 45 14             	mov    0x14(%ebp),%eax
c0101de7:	0f b6 c0             	movzbl %al,%eax
c0101dea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101dee:	83 c2 02             	add    $0x2,%edx
c0101df1:	0f b7 d2             	movzwl %dx,%edx
c0101df4:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101df8:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101dfb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101dff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101e03:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101e04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e07:	0f b6 c0             	movzbl %al,%eax
c0101e0a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e0e:	83 c2 03             	add    $0x3,%edx
c0101e11:	0f b7 d2             	movzwl %dx,%edx
c0101e14:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101e18:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101e1b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101e1f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101e23:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101e24:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e27:	c1 e8 08             	shr    $0x8,%eax
c0101e2a:	0f b6 c0             	movzbl %al,%eax
c0101e2d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e31:	83 c2 04             	add    $0x4,%edx
c0101e34:	0f b7 d2             	movzwl %dx,%edx
c0101e37:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101e3b:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101e3e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101e42:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101e46:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101e47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e4a:	c1 e8 10             	shr    $0x10,%eax
c0101e4d:	0f b6 c0             	movzbl %al,%eax
c0101e50:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e54:	83 c2 05             	add    $0x5,%edx
c0101e57:	0f b7 d2             	movzwl %dx,%edx
c0101e5a:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101e5e:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101e61:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101e65:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101e69:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101e6a:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e6e:	83 e0 01             	and    $0x1,%eax
c0101e71:	c1 e0 04             	shl    $0x4,%eax
c0101e74:	89 c2                	mov    %eax,%edx
c0101e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101e79:	c1 e8 18             	shr    $0x18,%eax
c0101e7c:	83 e0 0f             	and    $0xf,%eax
c0101e7f:	09 d0                	or     %edx,%eax
c0101e81:	83 c8 e0             	or     $0xffffffe0,%eax
c0101e84:	0f b6 c0             	movzbl %al,%eax
c0101e87:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e8b:	83 c2 06             	add    $0x6,%edx
c0101e8e:	0f b7 d2             	movzwl %dx,%edx
c0101e91:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101e95:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101e98:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101e9c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101ea0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101ea1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ea5:	83 c0 07             	add    $0x7,%eax
c0101ea8:	0f b7 c0             	movzwl %ax,%eax
c0101eab:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101eaf:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101eb3:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101eb7:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101ebb:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101ebc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101ec3:	eb 5a                	jmp    c0101f1f <ide_write_secs+0x232>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101ec5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ec9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101ed0:	00 
c0101ed1:	89 04 24             	mov    %eax,(%esp)
c0101ed4:	e8 e1 f7 ff ff       	call   c01016ba <ide_wait_ready>
c0101ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101ee0:	74 02                	je     c0101ee4 <ide_write_secs+0x1f7>
            goto out;
c0101ee2:	eb 41                	jmp    c0101f25 <ide_write_secs+0x238>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101ee4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101ee8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101eeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0101eee:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ef1:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101ef8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0101efb:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101efe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0101f01:	89 cb                	mov    %ecx,%ebx
c0101f03:	89 de                	mov    %ebx,%esi
c0101f05:	89 c1                	mov    %eax,%ecx
c0101f07:	fc                   	cld    
c0101f08:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101f0a:	89 c8                	mov    %ecx,%eax
c0101f0c:	89 f3                	mov    %esi,%ebx
c0101f0e:	89 5d cc             	mov    %ebx,-0x34(%ebp)
c0101f11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f14:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101f18:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101f1f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101f23:	75 a0                	jne    c0101ec5 <ide_write_secs+0x1d8>
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101f28:	83 c4 50             	add    $0x50,%esp
c0101f2b:	5b                   	pop    %ebx
c0101f2c:	5e                   	pop    %esi
c0101f2d:	5d                   	pop    %ebp
c0101f2e:	c3                   	ret    

c0101f2f <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101f2f:	55                   	push   %ebp
c0101f30:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101f32:	fb                   	sti    
    sti();
}
c0101f33:	5d                   	pop    %ebp
c0101f34:	c3                   	ret    

c0101f35 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101f35:	55                   	push   %ebp
c0101f36:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101f38:	fa                   	cli    
    cli();
}
c0101f39:	5d                   	pop    %ebp
c0101f3a:	c3                   	ret    

c0101f3b <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101f3b:	55                   	push   %ebp
c0101f3c:	89 e5                	mov    %esp,%ebp
c0101f3e:	83 ec 14             	sub    $0x14,%esp
c0101f41:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f44:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101f48:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f4c:	66 a3 70 45 12 c0    	mov    %ax,0xc0124570
    if (did_init) {
c0101f52:	a1 00 52 12 c0       	mov    0xc0125200,%eax
c0101f57:	85 c0                	test   %eax,%eax
c0101f59:	74 36                	je     c0101f91 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101f5b:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f5f:	0f b6 c0             	movzbl %al,%eax
c0101f62:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101f68:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f6b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101f6f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101f73:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101f74:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101f78:	66 c1 e8 08          	shr    $0x8,%ax
c0101f7c:	0f b6 c0             	movzbl %al,%eax
c0101f7f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101f85:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101f88:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101f8c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101f90:	ee                   	out    %al,(%dx)
    }
}
c0101f91:	c9                   	leave  
c0101f92:	c3                   	ret    

c0101f93 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101f93:	55                   	push   %ebp
c0101f94:	89 e5                	mov    %esp,%ebp
c0101f96:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101f99:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f9c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101fa1:	89 c1                	mov    %eax,%ecx
c0101fa3:	d3 e2                	shl    %cl,%edx
c0101fa5:	89 d0                	mov    %edx,%eax
c0101fa7:	f7 d0                	not    %eax
c0101fa9:	89 c2                	mov    %eax,%edx
c0101fab:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c0101fb2:	21 d0                	and    %edx,%eax
c0101fb4:	0f b7 c0             	movzwl %ax,%eax
c0101fb7:	89 04 24             	mov    %eax,(%esp)
c0101fba:	e8 7c ff ff ff       	call   c0101f3b <pic_setmask>
}
c0101fbf:	c9                   	leave  
c0101fc0:	c3                   	ret    

c0101fc1 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101fc1:	55                   	push   %ebp
c0101fc2:	89 e5                	mov    %esp,%ebp
c0101fc4:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101fc7:	c7 05 00 52 12 c0 01 	movl   $0x1,0xc0125200
c0101fce:	00 00 00 
c0101fd1:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101fd7:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101fdb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101fdf:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101fe3:	ee                   	out    %al,(%dx)
c0101fe4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101fea:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101fee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101ff2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101ff6:	ee                   	out    %al,(%dx)
c0101ff7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101ffd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0102001:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0102005:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0102009:	ee                   	out    %al,(%dx)
c010200a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0102010:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0102014:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0102018:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010201c:	ee                   	out    %al,(%dx)
c010201d:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c0102023:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0102027:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010202b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010202f:	ee                   	out    %al,(%dx)
c0102030:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0102036:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c010203a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010203e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102042:	ee                   	out    %al,(%dx)
c0102043:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102049:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010204d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102051:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102055:	ee                   	out    %al,(%dx)
c0102056:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010205c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102060:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102064:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)
c0102069:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010206f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102073:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102077:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010207b:	ee                   	out    %al,(%dx)
c010207c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102082:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102086:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010208a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010208e:	ee                   	out    %al,(%dx)
c010208f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102095:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102099:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010209d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01020a1:	ee                   	out    %al,(%dx)
c01020a2:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01020a8:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01020ac:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01020b0:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01020b4:	ee                   	out    %al,(%dx)
c01020b5:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01020bb:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01020bf:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01020c3:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01020c7:	ee                   	out    %al,(%dx)
c01020c8:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01020ce:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01020d2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01020d6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01020da:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01020db:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020e2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01020e6:	74 12                	je     c01020fa <pic_init+0x139>
        pic_setmask(irq_mask);
c01020e8:	0f b7 05 70 45 12 c0 	movzwl 0xc0124570,%eax
c01020ef:	0f b7 c0             	movzwl %ax,%eax
c01020f2:	89 04 24             	mov    %eax,(%esp)
c01020f5:	e8 41 fe ff ff       	call   c0101f3b <pic_setmask>
    }
}
c01020fa:	c9                   	leave  
c01020fb:	c3                   	ret    

c01020fc <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01020fc:	55                   	push   %ebp
c01020fd:	89 e5                	mov    %esp,%ebp
c01020ff:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0102102:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0102109:	00 
c010210a:	c7 04 24 e0 a0 10 c0 	movl   $0xc010a0e0,(%esp)
c0102111:	e8 3d e2 ff ff       	call   c0100353 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0102116:	c7 04 24 ea a0 10 c0 	movl   $0xc010a0ea,(%esp)
c010211d:	e8 31 e2 ff ff       	call   c0100353 <cprintf>
    panic("EOT: kernel seems ok.");
c0102122:	c7 44 24 08 f8 a0 10 	movl   $0xc010a0f8,0x8(%esp)
c0102129:	c0 
c010212a:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0102131:	00 
c0102132:	c7 04 24 0e a1 10 c0 	movl   $0xc010a10e,(%esp)
c0102139:	e8 9f eb ff ff       	call   c0100cdd <__panic>

c010213e <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c010213e:	55                   	push   %ebp
c010213f:	89 e5                	mov    %esp,%ebp
c0102141:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102144:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010214b:	e9 c3 00 00 00       	jmp    c0102213 <idt_init+0xd5>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102150:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102153:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c010215a:	89 c2                	mov    %eax,%edx
c010215c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010215f:	66 89 14 c5 20 52 12 	mov    %dx,-0x3fedade0(,%eax,8)
c0102166:	c0 
c0102167:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010216a:	66 c7 04 c5 22 52 12 	movw   $0x8,-0x3fedadde(,%eax,8)
c0102171:	c0 08 00 
c0102174:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102177:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c010217e:	c0 
c010217f:	83 e2 e0             	and    $0xffffffe0,%edx
c0102182:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c0102189:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010218c:	0f b6 14 c5 24 52 12 	movzbl -0x3fedaddc(,%eax,8),%edx
c0102193:	c0 
c0102194:	83 e2 1f             	and    $0x1f,%edx
c0102197:	88 14 c5 24 52 12 c0 	mov    %dl,-0x3fedaddc(,%eax,8)
c010219e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021a1:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021a8:	c0 
c01021a9:	83 e2 f0             	and    $0xfffffff0,%edx
c01021ac:	83 ca 0e             	or     $0xe,%edx
c01021af:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021b9:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021c0:	c0 
c01021c1:	83 e2 ef             	and    $0xffffffef,%edx
c01021c4:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021ce:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021d5:	c0 
c01021d6:	83 e2 9f             	and    $0xffffff9f,%edx
c01021d9:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021e3:	0f b6 14 c5 25 52 12 	movzbl -0x3fedaddb(,%eax,8),%edx
c01021ea:	c0 
c01021eb:	83 ca 80             	or     $0xffffff80,%edx
c01021ee:	88 14 c5 25 52 12 c0 	mov    %dl,-0x3fedaddb(,%eax,8)
c01021f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01021f8:	8b 04 85 00 46 12 c0 	mov    -0x3fedba00(,%eax,4),%eax
c01021ff:	c1 e8 10             	shr    $0x10,%eax
c0102202:	89 c2                	mov    %eax,%edx
c0102204:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102207:	66 89 14 c5 26 52 12 	mov    %dx,-0x3fedadda(,%eax,8)
c010220e:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010220f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0102213:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102216:	3d ff 00 00 00       	cmp    $0xff,%eax
c010221b:	0f 86 2f ff ff ff    	jbe    c0102150 <idt_init+0x12>
c0102221:	c7 45 f8 80 45 12 c0 	movl   $0xc0124580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102228:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010222b:	0f 01 18             	lidtl  (%eax)
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    lidt(&idt_pd);
}
c010222e:	c9                   	leave  
c010222f:	c3                   	ret    

c0102230 <trapname>:

static const char *
trapname(int trapno) {
c0102230:	55                   	push   %ebp
c0102231:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102233:	8b 45 08             	mov    0x8(%ebp),%eax
c0102236:	83 f8 13             	cmp    $0x13,%eax
c0102239:	77 0c                	ja     c0102247 <trapname+0x17>
        return excnames[trapno];
c010223b:	8b 45 08             	mov    0x8(%ebp),%eax
c010223e:	8b 04 85 e0 a4 10 c0 	mov    -0x3fef5b20(,%eax,4),%eax
c0102245:	eb 18                	jmp    c010225f <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102247:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010224b:	7e 0d                	jle    c010225a <trapname+0x2a>
c010224d:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102251:	7f 07                	jg     c010225a <trapname+0x2a>
        return "Hardware Interrupt";
c0102253:	b8 1f a1 10 c0       	mov    $0xc010a11f,%eax
c0102258:	eb 05                	jmp    c010225f <trapname+0x2f>
    }
    return "(unknown trap)";
c010225a:	b8 32 a1 10 c0       	mov    $0xc010a132,%eax
}
c010225f:	5d                   	pop    %ebp
c0102260:	c3                   	ret    

c0102261 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102261:	55                   	push   %ebp
c0102262:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102264:	8b 45 08             	mov    0x8(%ebp),%eax
c0102267:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010226b:	66 83 f8 08          	cmp    $0x8,%ax
c010226f:	0f 94 c0             	sete   %al
c0102272:	0f b6 c0             	movzbl %al,%eax
}
c0102275:	5d                   	pop    %ebp
c0102276:	c3                   	ret    

c0102277 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0102277:	55                   	push   %ebp
c0102278:	89 e5                	mov    %esp,%ebp
c010227a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c010227d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102280:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102284:	c7 04 24 73 a1 10 c0 	movl   $0xc010a173,(%esp)
c010228b:	e8 c3 e0 ff ff       	call   c0100353 <cprintf>
    print_regs(&tf->tf_regs);
c0102290:	8b 45 08             	mov    0x8(%ebp),%eax
c0102293:	89 04 24             	mov    %eax,(%esp)
c0102296:	e8 a1 01 00 00       	call   c010243c <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c010229b:	8b 45 08             	mov    0x8(%ebp),%eax
c010229e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01022a2:	0f b7 c0             	movzwl %ax,%eax
c01022a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022a9:	c7 04 24 84 a1 10 c0 	movl   $0xc010a184,(%esp)
c01022b0:	e8 9e e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01022b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01022b8:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01022bc:	0f b7 c0             	movzwl %ax,%eax
c01022bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022c3:	c7 04 24 97 a1 10 c0 	movl   $0xc010a197,(%esp)
c01022ca:	e8 84 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c01022cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01022d2:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c01022d6:	0f b7 c0             	movzwl %ax,%eax
c01022d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022dd:	c7 04 24 aa a1 10 c0 	movl   $0xc010a1aa,(%esp)
c01022e4:	e8 6a e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c01022e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01022ec:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c01022f0:	0f b7 c0             	movzwl %ax,%eax
c01022f3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01022f7:	c7 04 24 bd a1 10 c0 	movl   $0xc010a1bd,(%esp)
c01022fe:	e8 50 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102303:	8b 45 08             	mov    0x8(%ebp),%eax
c0102306:	8b 40 30             	mov    0x30(%eax),%eax
c0102309:	89 04 24             	mov    %eax,(%esp)
c010230c:	e8 1f ff ff ff       	call   c0102230 <trapname>
c0102311:	8b 55 08             	mov    0x8(%ebp),%edx
c0102314:	8b 52 30             	mov    0x30(%edx),%edx
c0102317:	89 44 24 08          	mov    %eax,0x8(%esp)
c010231b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010231f:	c7 04 24 d0 a1 10 c0 	movl   $0xc010a1d0,(%esp)
c0102326:	e8 28 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010232b:	8b 45 08             	mov    0x8(%ebp),%eax
c010232e:	8b 40 34             	mov    0x34(%eax),%eax
c0102331:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102335:	c7 04 24 e2 a1 10 c0 	movl   $0xc010a1e2,(%esp)
c010233c:	e8 12 e0 ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102341:	8b 45 08             	mov    0x8(%ebp),%eax
c0102344:	8b 40 38             	mov    0x38(%eax),%eax
c0102347:	89 44 24 04          	mov    %eax,0x4(%esp)
c010234b:	c7 04 24 f1 a1 10 c0 	movl   $0xc010a1f1,(%esp)
c0102352:	e8 fc df ff ff       	call   c0100353 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102357:	8b 45 08             	mov    0x8(%ebp),%eax
c010235a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010235e:	0f b7 c0             	movzwl %ax,%eax
c0102361:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102365:	c7 04 24 00 a2 10 c0 	movl   $0xc010a200,(%esp)
c010236c:	e8 e2 df ff ff       	call   c0100353 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0102371:	8b 45 08             	mov    0x8(%ebp),%eax
c0102374:	8b 40 40             	mov    0x40(%eax),%eax
c0102377:	89 44 24 04          	mov    %eax,0x4(%esp)
c010237b:	c7 04 24 13 a2 10 c0 	movl   $0xc010a213,(%esp)
c0102382:	e8 cc df ff ff       	call   c0100353 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010238e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0102395:	eb 3e                	jmp    c01023d5 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0102397:	8b 45 08             	mov    0x8(%ebp),%eax
c010239a:	8b 50 40             	mov    0x40(%eax),%edx
c010239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01023a0:	21 d0                	and    %edx,%eax
c01023a2:	85 c0                	test   %eax,%eax
c01023a4:	74 28                	je     c01023ce <print_trapframe+0x157>
c01023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023a9:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01023b0:	85 c0                	test   %eax,%eax
c01023b2:	74 1a                	je     c01023ce <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023b7:	8b 04 85 a0 45 12 c0 	mov    -0x3fedba60(,%eax,4),%eax
c01023be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c2:	c7 04 24 22 a2 10 c0 	movl   $0xc010a222,(%esp)
c01023c9:	e8 85 df ff ff       	call   c0100353 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01023ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01023d2:	d1 65 f0             	shll   -0x10(%ebp)
c01023d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01023d8:	83 f8 17             	cmp    $0x17,%eax
c01023db:	76 ba                	jbe    c0102397 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c01023dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01023e0:	8b 40 40             	mov    0x40(%eax),%eax
c01023e3:	25 00 30 00 00       	and    $0x3000,%eax
c01023e8:	c1 e8 0c             	shr    $0xc,%eax
c01023eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023ef:	c7 04 24 26 a2 10 c0 	movl   $0xc010a226,(%esp)
c01023f6:	e8 58 df ff ff       	call   c0100353 <cprintf>

    if (!trap_in_kernel(tf)) {
c01023fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01023fe:	89 04 24             	mov    %eax,(%esp)
c0102401:	e8 5b fe ff ff       	call   c0102261 <trap_in_kernel>
c0102406:	85 c0                	test   %eax,%eax
c0102408:	75 30                	jne    c010243a <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010240a:	8b 45 08             	mov    0x8(%ebp),%eax
c010240d:	8b 40 44             	mov    0x44(%eax),%eax
c0102410:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102414:	c7 04 24 2f a2 10 c0 	movl   $0xc010a22f,(%esp)
c010241b:	e8 33 df ff ff       	call   c0100353 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102420:	8b 45 08             	mov    0x8(%ebp),%eax
c0102423:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102427:	0f b7 c0             	movzwl %ax,%eax
c010242a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010242e:	c7 04 24 3e a2 10 c0 	movl   $0xc010a23e,(%esp)
c0102435:	e8 19 df ff ff       	call   c0100353 <cprintf>
    }
}
c010243a:	c9                   	leave  
c010243b:	c3                   	ret    

c010243c <print_regs>:

void
print_regs(struct pushregs *regs) {
c010243c:	55                   	push   %ebp
c010243d:	89 e5                	mov    %esp,%ebp
c010243f:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102442:	8b 45 08             	mov    0x8(%ebp),%eax
c0102445:	8b 00                	mov    (%eax),%eax
c0102447:	89 44 24 04          	mov    %eax,0x4(%esp)
c010244b:	c7 04 24 51 a2 10 c0 	movl   $0xc010a251,(%esp)
c0102452:	e8 fc de ff ff       	call   c0100353 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102457:	8b 45 08             	mov    0x8(%ebp),%eax
c010245a:	8b 40 04             	mov    0x4(%eax),%eax
c010245d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102461:	c7 04 24 60 a2 10 c0 	movl   $0xc010a260,(%esp)
c0102468:	e8 e6 de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c010246d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102470:	8b 40 08             	mov    0x8(%eax),%eax
c0102473:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102477:	c7 04 24 6f a2 10 c0 	movl   $0xc010a26f,(%esp)
c010247e:	e8 d0 de ff ff       	call   c0100353 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0102483:	8b 45 08             	mov    0x8(%ebp),%eax
c0102486:	8b 40 0c             	mov    0xc(%eax),%eax
c0102489:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248d:	c7 04 24 7e a2 10 c0 	movl   $0xc010a27e,(%esp)
c0102494:	e8 ba de ff ff       	call   c0100353 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0102499:	8b 45 08             	mov    0x8(%ebp),%eax
c010249c:	8b 40 10             	mov    0x10(%eax),%eax
c010249f:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a3:	c7 04 24 8d a2 10 c0 	movl   $0xc010a28d,(%esp)
c01024aa:	e8 a4 de ff ff       	call   c0100353 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01024af:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b2:	8b 40 14             	mov    0x14(%eax),%eax
c01024b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b9:	c7 04 24 9c a2 10 c0 	movl   $0xc010a29c,(%esp)
c01024c0:	e8 8e de ff ff       	call   c0100353 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01024c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c8:	8b 40 18             	mov    0x18(%eax),%eax
c01024cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024cf:	c7 04 24 ab a2 10 c0 	movl   $0xc010a2ab,(%esp)
c01024d6:	e8 78 de ff ff       	call   c0100353 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c01024db:	8b 45 08             	mov    0x8(%ebp),%eax
c01024de:	8b 40 1c             	mov    0x1c(%eax),%eax
c01024e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024e5:	c7 04 24 ba a2 10 c0 	movl   $0xc010a2ba,(%esp)
c01024ec:	e8 62 de ff ff       	call   c0100353 <cprintf>
}
c01024f1:	c9                   	leave  
c01024f2:	c3                   	ret    

c01024f3 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c01024f3:	55                   	push   %ebp
c01024f4:	89 e5                	mov    %esp,%ebp
c01024f6:	53                   	push   %ebx
c01024f7:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c01024fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01024fd:	8b 40 34             	mov    0x34(%eax),%eax
c0102500:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102503:	85 c0                	test   %eax,%eax
c0102505:	74 07                	je     c010250e <print_pgfault+0x1b>
c0102507:	b9 c9 a2 10 c0       	mov    $0xc010a2c9,%ecx
c010250c:	eb 05                	jmp    c0102513 <print_pgfault+0x20>
c010250e:	b9 da a2 10 c0       	mov    $0xc010a2da,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102513:	8b 45 08             	mov    0x8(%ebp),%eax
c0102516:	8b 40 34             	mov    0x34(%eax),%eax
c0102519:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010251c:	85 c0                	test   %eax,%eax
c010251e:	74 07                	je     c0102527 <print_pgfault+0x34>
c0102520:	ba 57 00 00 00       	mov    $0x57,%edx
c0102525:	eb 05                	jmp    c010252c <print_pgfault+0x39>
c0102527:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010252c:	8b 45 08             	mov    0x8(%ebp),%eax
c010252f:	8b 40 34             	mov    0x34(%eax),%eax
c0102532:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102535:	85 c0                	test   %eax,%eax
c0102537:	74 07                	je     c0102540 <print_pgfault+0x4d>
c0102539:	b8 55 00 00 00       	mov    $0x55,%eax
c010253e:	eb 05                	jmp    c0102545 <print_pgfault+0x52>
c0102540:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102545:	0f 20 d3             	mov    %cr2,%ebx
c0102548:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010254b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010254e:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102552:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102556:	89 44 24 08          	mov    %eax,0x8(%esp)
c010255a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010255e:	c7 04 24 e8 a2 10 c0 	movl   $0xc010a2e8,(%esp)
c0102565:	e8 e9 dd ff ff       	call   c0100353 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010256a:	83 c4 34             	add    $0x34,%esp
c010256d:	5b                   	pop    %ebx
c010256e:	5d                   	pop    %ebp
c010256f:	c3                   	ret    

c0102570 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c0102570:	55                   	push   %ebp
c0102571:	89 e5                	mov    %esp,%ebp
c0102573:	83 ec 28             	sub    $0x28,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c0102576:	8b 45 08             	mov    0x8(%ebp),%eax
c0102579:	89 04 24             	mov    %eax,(%esp)
c010257c:	e8 72 ff ff ff       	call   c01024f3 <print_pgfault>
    if (check_mm_struct != NULL) {
c0102581:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0102586:	85 c0                	test   %eax,%eax
c0102588:	74 34                	je     c01025be <pgfault_handler+0x4e>
    	cprintf("Do pgfault");
c010258a:	c7 04 24 0b a3 10 c0 	movl   $0xc010a30b,(%esp)
c0102591:	e8 bd dd ff ff       	call   c0100353 <cprintf>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102596:	0f 20 d0             	mov    %cr2,%eax
c0102599:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr2;
c010259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c010259f:	89 c1                	mov    %eax,%ecx
c01025a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a4:	8b 50 34             	mov    0x34(%eax),%edx
c01025a7:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c01025ac:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01025b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01025b4:	89 04 24             	mov    %eax,(%esp)
c01025b7:	e8 1f 5b 00 00       	call   c01080db <do_pgfault>
c01025bc:	eb 1c                	jmp    c01025da <pgfault_handler+0x6a>
    }
    panic("unhandled page fault.\n");
c01025be:	c7 44 24 08 16 a3 10 	movl   $0xc010a316,0x8(%esp)
c01025c5:	c0 
c01025c6:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c01025cd:	00 
c01025ce:	c7 04 24 0e a1 10 c0 	movl   $0xc010a10e,(%esp)
c01025d5:	e8 03 e7 ff ff       	call   c0100cdd <__panic>
}
c01025da:	c9                   	leave  
c01025db:	c3                   	ret    

c01025dc <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c01025dc:	55                   	push   %ebp
c01025dd:	89 e5                	mov    %esp,%ebp
c01025df:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c01025e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e5:	8b 40 30             	mov    0x30(%eax),%eax
c01025e8:	83 f8 24             	cmp    $0x24,%eax
c01025eb:	0f 84 c2 00 00 00    	je     c01026b3 <trap_dispatch+0xd7>
c01025f1:	83 f8 24             	cmp    $0x24,%eax
c01025f4:	77 18                	ja     c010260e <trap_dispatch+0x32>
c01025f6:	83 f8 20             	cmp    $0x20,%eax
c01025f9:	74 7d                	je     c0102678 <trap_dispatch+0x9c>
c01025fb:	83 f8 21             	cmp    $0x21,%eax
c01025fe:	0f 84 d5 00 00 00    	je     c01026d9 <trap_dispatch+0xfd>
c0102604:	83 f8 0e             	cmp    $0xe,%eax
c0102607:	74 28                	je     c0102631 <trap_dispatch+0x55>
c0102609:	e9 0d 01 00 00       	jmp    c010271b <trap_dispatch+0x13f>
c010260e:	83 f8 2e             	cmp    $0x2e,%eax
c0102611:	0f 82 04 01 00 00    	jb     c010271b <trap_dispatch+0x13f>
c0102617:	83 f8 2f             	cmp    $0x2f,%eax
c010261a:	0f 86 33 01 00 00    	jbe    c0102753 <trap_dispatch+0x177>
c0102620:	83 e8 78             	sub    $0x78,%eax
c0102623:	83 f8 01             	cmp    $0x1,%eax
c0102626:	0f 87 ef 00 00 00    	ja     c010271b <trap_dispatch+0x13f>
c010262c:	e9 ce 00 00 00       	jmp    c01026ff <trap_dispatch+0x123>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102631:	8b 45 08             	mov    0x8(%ebp),%eax
c0102634:	89 04 24             	mov    %eax,(%esp)
c0102637:	e8 34 ff ff ff       	call   c0102570 <pgfault_handler>
c010263c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010263f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102643:	74 2e                	je     c0102673 <trap_dispatch+0x97>
            print_trapframe(tf);
c0102645:	8b 45 08             	mov    0x8(%ebp),%eax
c0102648:	89 04 24             	mov    %eax,(%esp)
c010264b:	e8 27 fc ff ff       	call   c0102277 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102650:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102653:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102657:	c7 44 24 08 2d a3 10 	movl   $0xc010a32d,0x8(%esp)
c010265e:	c0 
c010265f:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102666:	00 
c0102667:	c7 04 24 0e a1 10 c0 	movl   $0xc010a10e,(%esp)
c010266e:	e8 6a e6 ff ff       	call   c0100cdd <__panic>
        }
        break;
c0102673:	e9 dc 00 00 00       	jmp    c0102754 <trap_dispatch+0x178>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0102678:	a1 14 7b 12 c0       	mov    0xc0127b14,%eax
c010267d:	83 c0 01             	add    $0x1,%eax
c0102680:	a3 14 7b 12 c0       	mov    %eax,0xc0127b14
        if (ticks % TICK_NUM == 0) {
c0102685:	8b 0d 14 7b 12 c0    	mov    0xc0127b14,%ecx
c010268b:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0102690:	89 c8                	mov    %ecx,%eax
c0102692:	f7 e2                	mul    %edx
c0102694:	89 d0                	mov    %edx,%eax
c0102696:	c1 e8 05             	shr    $0x5,%eax
c0102699:	6b c0 64             	imul   $0x64,%eax,%eax
c010269c:	29 c1                	sub    %eax,%ecx
c010269e:	89 c8                	mov    %ecx,%eax
c01026a0:	85 c0                	test   %eax,%eax
c01026a2:	75 0a                	jne    c01026ae <trap_dispatch+0xd2>
            print_ticks();
c01026a4:	e8 53 fa ff ff       	call   c01020fc <print_ticks>
        }
        break;
c01026a9:	e9 a6 00 00 00       	jmp    c0102754 <trap_dispatch+0x178>
c01026ae:	e9 a1 00 00 00       	jmp    c0102754 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01026b3:	e8 93 ef ff ff       	call   c010164b <cons_getc>
c01026b8:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01026bb:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026bf:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026c3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026cb:	c7 04 24 48 a3 10 c0 	movl   $0xc010a348,(%esp)
c01026d2:	e8 7c dc ff ff       	call   c0100353 <cprintf>
        break;
c01026d7:	eb 7b                	jmp    c0102754 <trap_dispatch+0x178>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01026d9:	e8 6d ef ff ff       	call   c010164b <cons_getc>
c01026de:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c01026e1:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01026e5:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01026e9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01026ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026f1:	c7 04 24 5a a3 10 c0 	movl   $0xc010a35a,(%esp)
c01026f8:	e8 56 dc ff ff       	call   c0100353 <cprintf>
        break;
c01026fd:	eb 55                	jmp    c0102754 <trap_dispatch+0x178>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c01026ff:	c7 44 24 08 69 a3 10 	movl   $0xc010a369,0x8(%esp)
c0102706:	c0 
c0102707:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010270e:	00 
c010270f:	c7 04 24 0e a1 10 c0 	movl   $0xc010a10e,(%esp)
c0102716:	e8 c2 e5 ff ff       	call   c0100cdd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010271b:	8b 45 08             	mov    0x8(%ebp),%eax
c010271e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102722:	0f b7 c0             	movzwl %ax,%eax
c0102725:	83 e0 03             	and    $0x3,%eax
c0102728:	85 c0                	test   %eax,%eax
c010272a:	75 28                	jne    c0102754 <trap_dispatch+0x178>
            print_trapframe(tf);
c010272c:	8b 45 08             	mov    0x8(%ebp),%eax
c010272f:	89 04 24             	mov    %eax,(%esp)
c0102732:	e8 40 fb ff ff       	call   c0102277 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102737:	c7 44 24 08 79 a3 10 	movl   $0xc010a379,0x8(%esp)
c010273e:	c0 
c010273f:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0102746:	00 
c0102747:	c7 04 24 0e a1 10 c0 	movl   $0xc010a10e,(%esp)
c010274e:	e8 8a e5 ff ff       	call   c0100cdd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102753:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102754:	c9                   	leave  
c0102755:	c3                   	ret    

c0102756 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102756:	55                   	push   %ebp
c0102757:	89 e5                	mov    %esp,%ebp
c0102759:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010275c:	8b 45 08             	mov    0x8(%ebp),%eax
c010275f:	89 04 24             	mov    %eax,(%esp)
c0102762:	e8 75 fe ff ff       	call   c01025dc <trap_dispatch>
}
c0102767:	c9                   	leave  
c0102768:	c3                   	ret    

c0102769 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102769:	1e                   	push   %ds
    pushl %es
c010276a:	06                   	push   %es
    pushl %fs
c010276b:	0f a0                	push   %fs
    pushl %gs
c010276d:	0f a8                	push   %gs
    pushal
c010276f:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102770:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102775:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102777:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102779:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c010277a:	e8 d7 ff ff ff       	call   c0102756 <trap>

    # pop the pushed stack pointer
    popl %esp
c010277f:	5c                   	pop    %esp

c0102780 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102780:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102781:	0f a9                	pop    %gs
    popl %fs
c0102783:	0f a1                	pop    %fs
    popl %es
c0102785:	07                   	pop    %es
    popl %ds
c0102786:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102787:	83 c4 08             	add    $0x8,%esp
    iret
c010278a:	cf                   	iret   

c010278b <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c010278b:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c010278f:	e9 ec ff ff ff       	jmp    c0102780 <__trapret>

c0102794 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $0
c0102796:	6a 00                	push   $0x0
  jmp __alltraps
c0102798:	e9 cc ff ff ff       	jmp    c0102769 <__alltraps>

c010279d <vector1>:
.globl vector1
vector1:
  pushl $0
c010279d:	6a 00                	push   $0x0
  pushl $1
c010279f:	6a 01                	push   $0x1
  jmp __alltraps
c01027a1:	e9 c3 ff ff ff       	jmp    c0102769 <__alltraps>

c01027a6 <vector2>:
.globl vector2
vector2:
  pushl $0
c01027a6:	6a 00                	push   $0x0
  pushl $2
c01027a8:	6a 02                	push   $0x2
  jmp __alltraps
c01027aa:	e9 ba ff ff ff       	jmp    c0102769 <__alltraps>

c01027af <vector3>:
.globl vector3
vector3:
  pushl $0
c01027af:	6a 00                	push   $0x0
  pushl $3
c01027b1:	6a 03                	push   $0x3
  jmp __alltraps
c01027b3:	e9 b1 ff ff ff       	jmp    c0102769 <__alltraps>

c01027b8 <vector4>:
.globl vector4
vector4:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $4
c01027ba:	6a 04                	push   $0x4
  jmp __alltraps
c01027bc:	e9 a8 ff ff ff       	jmp    c0102769 <__alltraps>

c01027c1 <vector5>:
.globl vector5
vector5:
  pushl $0
c01027c1:	6a 00                	push   $0x0
  pushl $5
c01027c3:	6a 05                	push   $0x5
  jmp __alltraps
c01027c5:	e9 9f ff ff ff       	jmp    c0102769 <__alltraps>

c01027ca <vector6>:
.globl vector6
vector6:
  pushl $0
c01027ca:	6a 00                	push   $0x0
  pushl $6
c01027cc:	6a 06                	push   $0x6
  jmp __alltraps
c01027ce:	e9 96 ff ff ff       	jmp    c0102769 <__alltraps>

c01027d3 <vector7>:
.globl vector7
vector7:
  pushl $0
c01027d3:	6a 00                	push   $0x0
  pushl $7
c01027d5:	6a 07                	push   $0x7
  jmp __alltraps
c01027d7:	e9 8d ff ff ff       	jmp    c0102769 <__alltraps>

c01027dc <vector8>:
.globl vector8
vector8:
  pushl $8
c01027dc:	6a 08                	push   $0x8
  jmp __alltraps
c01027de:	e9 86 ff ff ff       	jmp    c0102769 <__alltraps>

c01027e3 <vector9>:
.globl vector9
vector9:
  pushl $9
c01027e3:	6a 09                	push   $0x9
  jmp __alltraps
c01027e5:	e9 7f ff ff ff       	jmp    c0102769 <__alltraps>

c01027ea <vector10>:
.globl vector10
vector10:
  pushl $10
c01027ea:	6a 0a                	push   $0xa
  jmp __alltraps
c01027ec:	e9 78 ff ff ff       	jmp    c0102769 <__alltraps>

c01027f1 <vector11>:
.globl vector11
vector11:
  pushl $11
c01027f1:	6a 0b                	push   $0xb
  jmp __alltraps
c01027f3:	e9 71 ff ff ff       	jmp    c0102769 <__alltraps>

c01027f8 <vector12>:
.globl vector12
vector12:
  pushl $12
c01027f8:	6a 0c                	push   $0xc
  jmp __alltraps
c01027fa:	e9 6a ff ff ff       	jmp    c0102769 <__alltraps>

c01027ff <vector13>:
.globl vector13
vector13:
  pushl $13
c01027ff:	6a 0d                	push   $0xd
  jmp __alltraps
c0102801:	e9 63 ff ff ff       	jmp    c0102769 <__alltraps>

c0102806 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102806:	6a 0e                	push   $0xe
  jmp __alltraps
c0102808:	e9 5c ff ff ff       	jmp    c0102769 <__alltraps>

c010280d <vector15>:
.globl vector15
vector15:
  pushl $0
c010280d:	6a 00                	push   $0x0
  pushl $15
c010280f:	6a 0f                	push   $0xf
  jmp __alltraps
c0102811:	e9 53 ff ff ff       	jmp    c0102769 <__alltraps>

c0102816 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102816:	6a 00                	push   $0x0
  pushl $16
c0102818:	6a 10                	push   $0x10
  jmp __alltraps
c010281a:	e9 4a ff ff ff       	jmp    c0102769 <__alltraps>

c010281f <vector17>:
.globl vector17
vector17:
  pushl $17
c010281f:	6a 11                	push   $0x11
  jmp __alltraps
c0102821:	e9 43 ff ff ff       	jmp    c0102769 <__alltraps>

c0102826 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102826:	6a 00                	push   $0x0
  pushl $18
c0102828:	6a 12                	push   $0x12
  jmp __alltraps
c010282a:	e9 3a ff ff ff       	jmp    c0102769 <__alltraps>

c010282f <vector19>:
.globl vector19
vector19:
  pushl $0
c010282f:	6a 00                	push   $0x0
  pushl $19
c0102831:	6a 13                	push   $0x13
  jmp __alltraps
c0102833:	e9 31 ff ff ff       	jmp    c0102769 <__alltraps>

c0102838 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102838:	6a 00                	push   $0x0
  pushl $20
c010283a:	6a 14                	push   $0x14
  jmp __alltraps
c010283c:	e9 28 ff ff ff       	jmp    c0102769 <__alltraps>

c0102841 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102841:	6a 00                	push   $0x0
  pushl $21
c0102843:	6a 15                	push   $0x15
  jmp __alltraps
c0102845:	e9 1f ff ff ff       	jmp    c0102769 <__alltraps>

c010284a <vector22>:
.globl vector22
vector22:
  pushl $0
c010284a:	6a 00                	push   $0x0
  pushl $22
c010284c:	6a 16                	push   $0x16
  jmp __alltraps
c010284e:	e9 16 ff ff ff       	jmp    c0102769 <__alltraps>

c0102853 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102853:	6a 00                	push   $0x0
  pushl $23
c0102855:	6a 17                	push   $0x17
  jmp __alltraps
c0102857:	e9 0d ff ff ff       	jmp    c0102769 <__alltraps>

c010285c <vector24>:
.globl vector24
vector24:
  pushl $0
c010285c:	6a 00                	push   $0x0
  pushl $24
c010285e:	6a 18                	push   $0x18
  jmp __alltraps
c0102860:	e9 04 ff ff ff       	jmp    c0102769 <__alltraps>

c0102865 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102865:	6a 00                	push   $0x0
  pushl $25
c0102867:	6a 19                	push   $0x19
  jmp __alltraps
c0102869:	e9 fb fe ff ff       	jmp    c0102769 <__alltraps>

c010286e <vector26>:
.globl vector26
vector26:
  pushl $0
c010286e:	6a 00                	push   $0x0
  pushl $26
c0102870:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102872:	e9 f2 fe ff ff       	jmp    c0102769 <__alltraps>

c0102877 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102877:	6a 00                	push   $0x0
  pushl $27
c0102879:	6a 1b                	push   $0x1b
  jmp __alltraps
c010287b:	e9 e9 fe ff ff       	jmp    c0102769 <__alltraps>

c0102880 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102880:	6a 00                	push   $0x0
  pushl $28
c0102882:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102884:	e9 e0 fe ff ff       	jmp    c0102769 <__alltraps>

c0102889 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102889:	6a 00                	push   $0x0
  pushl $29
c010288b:	6a 1d                	push   $0x1d
  jmp __alltraps
c010288d:	e9 d7 fe ff ff       	jmp    c0102769 <__alltraps>

c0102892 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102892:	6a 00                	push   $0x0
  pushl $30
c0102894:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102896:	e9 ce fe ff ff       	jmp    c0102769 <__alltraps>

c010289b <vector31>:
.globl vector31
vector31:
  pushl $0
c010289b:	6a 00                	push   $0x0
  pushl $31
c010289d:	6a 1f                	push   $0x1f
  jmp __alltraps
c010289f:	e9 c5 fe ff ff       	jmp    c0102769 <__alltraps>

c01028a4 <vector32>:
.globl vector32
vector32:
  pushl $0
c01028a4:	6a 00                	push   $0x0
  pushl $32
c01028a6:	6a 20                	push   $0x20
  jmp __alltraps
c01028a8:	e9 bc fe ff ff       	jmp    c0102769 <__alltraps>

c01028ad <vector33>:
.globl vector33
vector33:
  pushl $0
c01028ad:	6a 00                	push   $0x0
  pushl $33
c01028af:	6a 21                	push   $0x21
  jmp __alltraps
c01028b1:	e9 b3 fe ff ff       	jmp    c0102769 <__alltraps>

c01028b6 <vector34>:
.globl vector34
vector34:
  pushl $0
c01028b6:	6a 00                	push   $0x0
  pushl $34
c01028b8:	6a 22                	push   $0x22
  jmp __alltraps
c01028ba:	e9 aa fe ff ff       	jmp    c0102769 <__alltraps>

c01028bf <vector35>:
.globl vector35
vector35:
  pushl $0
c01028bf:	6a 00                	push   $0x0
  pushl $35
c01028c1:	6a 23                	push   $0x23
  jmp __alltraps
c01028c3:	e9 a1 fe ff ff       	jmp    c0102769 <__alltraps>

c01028c8 <vector36>:
.globl vector36
vector36:
  pushl $0
c01028c8:	6a 00                	push   $0x0
  pushl $36
c01028ca:	6a 24                	push   $0x24
  jmp __alltraps
c01028cc:	e9 98 fe ff ff       	jmp    c0102769 <__alltraps>

c01028d1 <vector37>:
.globl vector37
vector37:
  pushl $0
c01028d1:	6a 00                	push   $0x0
  pushl $37
c01028d3:	6a 25                	push   $0x25
  jmp __alltraps
c01028d5:	e9 8f fe ff ff       	jmp    c0102769 <__alltraps>

c01028da <vector38>:
.globl vector38
vector38:
  pushl $0
c01028da:	6a 00                	push   $0x0
  pushl $38
c01028dc:	6a 26                	push   $0x26
  jmp __alltraps
c01028de:	e9 86 fe ff ff       	jmp    c0102769 <__alltraps>

c01028e3 <vector39>:
.globl vector39
vector39:
  pushl $0
c01028e3:	6a 00                	push   $0x0
  pushl $39
c01028e5:	6a 27                	push   $0x27
  jmp __alltraps
c01028e7:	e9 7d fe ff ff       	jmp    c0102769 <__alltraps>

c01028ec <vector40>:
.globl vector40
vector40:
  pushl $0
c01028ec:	6a 00                	push   $0x0
  pushl $40
c01028ee:	6a 28                	push   $0x28
  jmp __alltraps
c01028f0:	e9 74 fe ff ff       	jmp    c0102769 <__alltraps>

c01028f5 <vector41>:
.globl vector41
vector41:
  pushl $0
c01028f5:	6a 00                	push   $0x0
  pushl $41
c01028f7:	6a 29                	push   $0x29
  jmp __alltraps
c01028f9:	e9 6b fe ff ff       	jmp    c0102769 <__alltraps>

c01028fe <vector42>:
.globl vector42
vector42:
  pushl $0
c01028fe:	6a 00                	push   $0x0
  pushl $42
c0102900:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102902:	e9 62 fe ff ff       	jmp    c0102769 <__alltraps>

c0102907 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102907:	6a 00                	push   $0x0
  pushl $43
c0102909:	6a 2b                	push   $0x2b
  jmp __alltraps
c010290b:	e9 59 fe ff ff       	jmp    c0102769 <__alltraps>

c0102910 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102910:	6a 00                	push   $0x0
  pushl $44
c0102912:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102914:	e9 50 fe ff ff       	jmp    c0102769 <__alltraps>

c0102919 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102919:	6a 00                	push   $0x0
  pushl $45
c010291b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010291d:	e9 47 fe ff ff       	jmp    c0102769 <__alltraps>

c0102922 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102922:	6a 00                	push   $0x0
  pushl $46
c0102924:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102926:	e9 3e fe ff ff       	jmp    c0102769 <__alltraps>

c010292b <vector47>:
.globl vector47
vector47:
  pushl $0
c010292b:	6a 00                	push   $0x0
  pushl $47
c010292d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010292f:	e9 35 fe ff ff       	jmp    c0102769 <__alltraps>

c0102934 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102934:	6a 00                	push   $0x0
  pushl $48
c0102936:	6a 30                	push   $0x30
  jmp __alltraps
c0102938:	e9 2c fe ff ff       	jmp    c0102769 <__alltraps>

c010293d <vector49>:
.globl vector49
vector49:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $49
c010293f:	6a 31                	push   $0x31
  jmp __alltraps
c0102941:	e9 23 fe ff ff       	jmp    c0102769 <__alltraps>

c0102946 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $50
c0102948:	6a 32                	push   $0x32
  jmp __alltraps
c010294a:	e9 1a fe ff ff       	jmp    c0102769 <__alltraps>

c010294f <vector51>:
.globl vector51
vector51:
  pushl $0
c010294f:	6a 00                	push   $0x0
  pushl $51
c0102951:	6a 33                	push   $0x33
  jmp __alltraps
c0102953:	e9 11 fe ff ff       	jmp    c0102769 <__alltraps>

c0102958 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102958:	6a 00                	push   $0x0
  pushl $52
c010295a:	6a 34                	push   $0x34
  jmp __alltraps
c010295c:	e9 08 fe ff ff       	jmp    c0102769 <__alltraps>

c0102961 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102961:	6a 00                	push   $0x0
  pushl $53
c0102963:	6a 35                	push   $0x35
  jmp __alltraps
c0102965:	e9 ff fd ff ff       	jmp    c0102769 <__alltraps>

c010296a <vector54>:
.globl vector54
vector54:
  pushl $0
c010296a:	6a 00                	push   $0x0
  pushl $54
c010296c:	6a 36                	push   $0x36
  jmp __alltraps
c010296e:	e9 f6 fd ff ff       	jmp    c0102769 <__alltraps>

c0102973 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102973:	6a 00                	push   $0x0
  pushl $55
c0102975:	6a 37                	push   $0x37
  jmp __alltraps
c0102977:	e9 ed fd ff ff       	jmp    c0102769 <__alltraps>

c010297c <vector56>:
.globl vector56
vector56:
  pushl $0
c010297c:	6a 00                	push   $0x0
  pushl $56
c010297e:	6a 38                	push   $0x38
  jmp __alltraps
c0102980:	e9 e4 fd ff ff       	jmp    c0102769 <__alltraps>

c0102985 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102985:	6a 00                	push   $0x0
  pushl $57
c0102987:	6a 39                	push   $0x39
  jmp __alltraps
c0102989:	e9 db fd ff ff       	jmp    c0102769 <__alltraps>

c010298e <vector58>:
.globl vector58
vector58:
  pushl $0
c010298e:	6a 00                	push   $0x0
  pushl $58
c0102990:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102992:	e9 d2 fd ff ff       	jmp    c0102769 <__alltraps>

c0102997 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102997:	6a 00                	push   $0x0
  pushl $59
c0102999:	6a 3b                	push   $0x3b
  jmp __alltraps
c010299b:	e9 c9 fd ff ff       	jmp    c0102769 <__alltraps>

c01029a0 <vector60>:
.globl vector60
vector60:
  pushl $0
c01029a0:	6a 00                	push   $0x0
  pushl $60
c01029a2:	6a 3c                	push   $0x3c
  jmp __alltraps
c01029a4:	e9 c0 fd ff ff       	jmp    c0102769 <__alltraps>

c01029a9 <vector61>:
.globl vector61
vector61:
  pushl $0
c01029a9:	6a 00                	push   $0x0
  pushl $61
c01029ab:	6a 3d                	push   $0x3d
  jmp __alltraps
c01029ad:	e9 b7 fd ff ff       	jmp    c0102769 <__alltraps>

c01029b2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01029b2:	6a 00                	push   $0x0
  pushl $62
c01029b4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01029b6:	e9 ae fd ff ff       	jmp    c0102769 <__alltraps>

c01029bb <vector63>:
.globl vector63
vector63:
  pushl $0
c01029bb:	6a 00                	push   $0x0
  pushl $63
c01029bd:	6a 3f                	push   $0x3f
  jmp __alltraps
c01029bf:	e9 a5 fd ff ff       	jmp    c0102769 <__alltraps>

c01029c4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01029c4:	6a 00                	push   $0x0
  pushl $64
c01029c6:	6a 40                	push   $0x40
  jmp __alltraps
c01029c8:	e9 9c fd ff ff       	jmp    c0102769 <__alltraps>

c01029cd <vector65>:
.globl vector65
vector65:
  pushl $0
c01029cd:	6a 00                	push   $0x0
  pushl $65
c01029cf:	6a 41                	push   $0x41
  jmp __alltraps
c01029d1:	e9 93 fd ff ff       	jmp    c0102769 <__alltraps>

c01029d6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01029d6:	6a 00                	push   $0x0
  pushl $66
c01029d8:	6a 42                	push   $0x42
  jmp __alltraps
c01029da:	e9 8a fd ff ff       	jmp    c0102769 <__alltraps>

c01029df <vector67>:
.globl vector67
vector67:
  pushl $0
c01029df:	6a 00                	push   $0x0
  pushl $67
c01029e1:	6a 43                	push   $0x43
  jmp __alltraps
c01029e3:	e9 81 fd ff ff       	jmp    c0102769 <__alltraps>

c01029e8 <vector68>:
.globl vector68
vector68:
  pushl $0
c01029e8:	6a 00                	push   $0x0
  pushl $68
c01029ea:	6a 44                	push   $0x44
  jmp __alltraps
c01029ec:	e9 78 fd ff ff       	jmp    c0102769 <__alltraps>

c01029f1 <vector69>:
.globl vector69
vector69:
  pushl $0
c01029f1:	6a 00                	push   $0x0
  pushl $69
c01029f3:	6a 45                	push   $0x45
  jmp __alltraps
c01029f5:	e9 6f fd ff ff       	jmp    c0102769 <__alltraps>

c01029fa <vector70>:
.globl vector70
vector70:
  pushl $0
c01029fa:	6a 00                	push   $0x0
  pushl $70
c01029fc:	6a 46                	push   $0x46
  jmp __alltraps
c01029fe:	e9 66 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a03 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102a03:	6a 00                	push   $0x0
  pushl $71
c0102a05:	6a 47                	push   $0x47
  jmp __alltraps
c0102a07:	e9 5d fd ff ff       	jmp    c0102769 <__alltraps>

c0102a0c <vector72>:
.globl vector72
vector72:
  pushl $0
c0102a0c:	6a 00                	push   $0x0
  pushl $72
c0102a0e:	6a 48                	push   $0x48
  jmp __alltraps
c0102a10:	e9 54 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a15 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102a15:	6a 00                	push   $0x0
  pushl $73
c0102a17:	6a 49                	push   $0x49
  jmp __alltraps
c0102a19:	e9 4b fd ff ff       	jmp    c0102769 <__alltraps>

c0102a1e <vector74>:
.globl vector74
vector74:
  pushl $0
c0102a1e:	6a 00                	push   $0x0
  pushl $74
c0102a20:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102a22:	e9 42 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a27 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102a27:	6a 00                	push   $0x0
  pushl $75
c0102a29:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102a2b:	e9 39 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a30 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102a30:	6a 00                	push   $0x0
  pushl $76
c0102a32:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102a34:	e9 30 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a39 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102a39:	6a 00                	push   $0x0
  pushl $77
c0102a3b:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102a3d:	e9 27 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a42 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102a42:	6a 00                	push   $0x0
  pushl $78
c0102a44:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102a46:	e9 1e fd ff ff       	jmp    c0102769 <__alltraps>

c0102a4b <vector79>:
.globl vector79
vector79:
  pushl $0
c0102a4b:	6a 00                	push   $0x0
  pushl $79
c0102a4d:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102a4f:	e9 15 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a54 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102a54:	6a 00                	push   $0x0
  pushl $80
c0102a56:	6a 50                	push   $0x50
  jmp __alltraps
c0102a58:	e9 0c fd ff ff       	jmp    c0102769 <__alltraps>

c0102a5d <vector81>:
.globl vector81
vector81:
  pushl $0
c0102a5d:	6a 00                	push   $0x0
  pushl $81
c0102a5f:	6a 51                	push   $0x51
  jmp __alltraps
c0102a61:	e9 03 fd ff ff       	jmp    c0102769 <__alltraps>

c0102a66 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102a66:	6a 00                	push   $0x0
  pushl $82
c0102a68:	6a 52                	push   $0x52
  jmp __alltraps
c0102a6a:	e9 fa fc ff ff       	jmp    c0102769 <__alltraps>

c0102a6f <vector83>:
.globl vector83
vector83:
  pushl $0
c0102a6f:	6a 00                	push   $0x0
  pushl $83
c0102a71:	6a 53                	push   $0x53
  jmp __alltraps
c0102a73:	e9 f1 fc ff ff       	jmp    c0102769 <__alltraps>

c0102a78 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102a78:	6a 00                	push   $0x0
  pushl $84
c0102a7a:	6a 54                	push   $0x54
  jmp __alltraps
c0102a7c:	e9 e8 fc ff ff       	jmp    c0102769 <__alltraps>

c0102a81 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102a81:	6a 00                	push   $0x0
  pushl $85
c0102a83:	6a 55                	push   $0x55
  jmp __alltraps
c0102a85:	e9 df fc ff ff       	jmp    c0102769 <__alltraps>

c0102a8a <vector86>:
.globl vector86
vector86:
  pushl $0
c0102a8a:	6a 00                	push   $0x0
  pushl $86
c0102a8c:	6a 56                	push   $0x56
  jmp __alltraps
c0102a8e:	e9 d6 fc ff ff       	jmp    c0102769 <__alltraps>

c0102a93 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102a93:	6a 00                	push   $0x0
  pushl $87
c0102a95:	6a 57                	push   $0x57
  jmp __alltraps
c0102a97:	e9 cd fc ff ff       	jmp    c0102769 <__alltraps>

c0102a9c <vector88>:
.globl vector88
vector88:
  pushl $0
c0102a9c:	6a 00                	push   $0x0
  pushl $88
c0102a9e:	6a 58                	push   $0x58
  jmp __alltraps
c0102aa0:	e9 c4 fc ff ff       	jmp    c0102769 <__alltraps>

c0102aa5 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102aa5:	6a 00                	push   $0x0
  pushl $89
c0102aa7:	6a 59                	push   $0x59
  jmp __alltraps
c0102aa9:	e9 bb fc ff ff       	jmp    c0102769 <__alltraps>

c0102aae <vector90>:
.globl vector90
vector90:
  pushl $0
c0102aae:	6a 00                	push   $0x0
  pushl $90
c0102ab0:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102ab2:	e9 b2 fc ff ff       	jmp    c0102769 <__alltraps>

c0102ab7 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102ab7:	6a 00                	push   $0x0
  pushl $91
c0102ab9:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102abb:	e9 a9 fc ff ff       	jmp    c0102769 <__alltraps>

c0102ac0 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102ac0:	6a 00                	push   $0x0
  pushl $92
c0102ac2:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102ac4:	e9 a0 fc ff ff       	jmp    c0102769 <__alltraps>

c0102ac9 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102ac9:	6a 00                	push   $0x0
  pushl $93
c0102acb:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102acd:	e9 97 fc ff ff       	jmp    c0102769 <__alltraps>

c0102ad2 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102ad2:	6a 00                	push   $0x0
  pushl $94
c0102ad4:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102ad6:	e9 8e fc ff ff       	jmp    c0102769 <__alltraps>

c0102adb <vector95>:
.globl vector95
vector95:
  pushl $0
c0102adb:	6a 00                	push   $0x0
  pushl $95
c0102add:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102adf:	e9 85 fc ff ff       	jmp    c0102769 <__alltraps>

c0102ae4 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102ae4:	6a 00                	push   $0x0
  pushl $96
c0102ae6:	6a 60                	push   $0x60
  jmp __alltraps
c0102ae8:	e9 7c fc ff ff       	jmp    c0102769 <__alltraps>

c0102aed <vector97>:
.globl vector97
vector97:
  pushl $0
c0102aed:	6a 00                	push   $0x0
  pushl $97
c0102aef:	6a 61                	push   $0x61
  jmp __alltraps
c0102af1:	e9 73 fc ff ff       	jmp    c0102769 <__alltraps>

c0102af6 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102af6:	6a 00                	push   $0x0
  pushl $98
c0102af8:	6a 62                	push   $0x62
  jmp __alltraps
c0102afa:	e9 6a fc ff ff       	jmp    c0102769 <__alltraps>

c0102aff <vector99>:
.globl vector99
vector99:
  pushl $0
c0102aff:	6a 00                	push   $0x0
  pushl $99
c0102b01:	6a 63                	push   $0x63
  jmp __alltraps
c0102b03:	e9 61 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b08 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102b08:	6a 00                	push   $0x0
  pushl $100
c0102b0a:	6a 64                	push   $0x64
  jmp __alltraps
c0102b0c:	e9 58 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b11 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102b11:	6a 00                	push   $0x0
  pushl $101
c0102b13:	6a 65                	push   $0x65
  jmp __alltraps
c0102b15:	e9 4f fc ff ff       	jmp    c0102769 <__alltraps>

c0102b1a <vector102>:
.globl vector102
vector102:
  pushl $0
c0102b1a:	6a 00                	push   $0x0
  pushl $102
c0102b1c:	6a 66                	push   $0x66
  jmp __alltraps
c0102b1e:	e9 46 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b23 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102b23:	6a 00                	push   $0x0
  pushl $103
c0102b25:	6a 67                	push   $0x67
  jmp __alltraps
c0102b27:	e9 3d fc ff ff       	jmp    c0102769 <__alltraps>

c0102b2c <vector104>:
.globl vector104
vector104:
  pushl $0
c0102b2c:	6a 00                	push   $0x0
  pushl $104
c0102b2e:	6a 68                	push   $0x68
  jmp __alltraps
c0102b30:	e9 34 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b35 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102b35:	6a 00                	push   $0x0
  pushl $105
c0102b37:	6a 69                	push   $0x69
  jmp __alltraps
c0102b39:	e9 2b fc ff ff       	jmp    c0102769 <__alltraps>

c0102b3e <vector106>:
.globl vector106
vector106:
  pushl $0
c0102b3e:	6a 00                	push   $0x0
  pushl $106
c0102b40:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102b42:	e9 22 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b47 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102b47:	6a 00                	push   $0x0
  pushl $107
c0102b49:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102b4b:	e9 19 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b50 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102b50:	6a 00                	push   $0x0
  pushl $108
c0102b52:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102b54:	e9 10 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b59 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102b59:	6a 00                	push   $0x0
  pushl $109
c0102b5b:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102b5d:	e9 07 fc ff ff       	jmp    c0102769 <__alltraps>

c0102b62 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102b62:	6a 00                	push   $0x0
  pushl $110
c0102b64:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102b66:	e9 fe fb ff ff       	jmp    c0102769 <__alltraps>

c0102b6b <vector111>:
.globl vector111
vector111:
  pushl $0
c0102b6b:	6a 00                	push   $0x0
  pushl $111
c0102b6d:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102b6f:	e9 f5 fb ff ff       	jmp    c0102769 <__alltraps>

c0102b74 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102b74:	6a 00                	push   $0x0
  pushl $112
c0102b76:	6a 70                	push   $0x70
  jmp __alltraps
c0102b78:	e9 ec fb ff ff       	jmp    c0102769 <__alltraps>

c0102b7d <vector113>:
.globl vector113
vector113:
  pushl $0
c0102b7d:	6a 00                	push   $0x0
  pushl $113
c0102b7f:	6a 71                	push   $0x71
  jmp __alltraps
c0102b81:	e9 e3 fb ff ff       	jmp    c0102769 <__alltraps>

c0102b86 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102b86:	6a 00                	push   $0x0
  pushl $114
c0102b88:	6a 72                	push   $0x72
  jmp __alltraps
c0102b8a:	e9 da fb ff ff       	jmp    c0102769 <__alltraps>

c0102b8f <vector115>:
.globl vector115
vector115:
  pushl $0
c0102b8f:	6a 00                	push   $0x0
  pushl $115
c0102b91:	6a 73                	push   $0x73
  jmp __alltraps
c0102b93:	e9 d1 fb ff ff       	jmp    c0102769 <__alltraps>

c0102b98 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102b98:	6a 00                	push   $0x0
  pushl $116
c0102b9a:	6a 74                	push   $0x74
  jmp __alltraps
c0102b9c:	e9 c8 fb ff ff       	jmp    c0102769 <__alltraps>

c0102ba1 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102ba1:	6a 00                	push   $0x0
  pushl $117
c0102ba3:	6a 75                	push   $0x75
  jmp __alltraps
c0102ba5:	e9 bf fb ff ff       	jmp    c0102769 <__alltraps>

c0102baa <vector118>:
.globl vector118
vector118:
  pushl $0
c0102baa:	6a 00                	push   $0x0
  pushl $118
c0102bac:	6a 76                	push   $0x76
  jmp __alltraps
c0102bae:	e9 b6 fb ff ff       	jmp    c0102769 <__alltraps>

c0102bb3 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102bb3:	6a 00                	push   $0x0
  pushl $119
c0102bb5:	6a 77                	push   $0x77
  jmp __alltraps
c0102bb7:	e9 ad fb ff ff       	jmp    c0102769 <__alltraps>

c0102bbc <vector120>:
.globl vector120
vector120:
  pushl $0
c0102bbc:	6a 00                	push   $0x0
  pushl $120
c0102bbe:	6a 78                	push   $0x78
  jmp __alltraps
c0102bc0:	e9 a4 fb ff ff       	jmp    c0102769 <__alltraps>

c0102bc5 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102bc5:	6a 00                	push   $0x0
  pushl $121
c0102bc7:	6a 79                	push   $0x79
  jmp __alltraps
c0102bc9:	e9 9b fb ff ff       	jmp    c0102769 <__alltraps>

c0102bce <vector122>:
.globl vector122
vector122:
  pushl $0
c0102bce:	6a 00                	push   $0x0
  pushl $122
c0102bd0:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102bd2:	e9 92 fb ff ff       	jmp    c0102769 <__alltraps>

c0102bd7 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102bd7:	6a 00                	push   $0x0
  pushl $123
c0102bd9:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102bdb:	e9 89 fb ff ff       	jmp    c0102769 <__alltraps>

c0102be0 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102be0:	6a 00                	push   $0x0
  pushl $124
c0102be2:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102be4:	e9 80 fb ff ff       	jmp    c0102769 <__alltraps>

c0102be9 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102be9:	6a 00                	push   $0x0
  pushl $125
c0102beb:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102bed:	e9 77 fb ff ff       	jmp    c0102769 <__alltraps>

c0102bf2 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102bf2:	6a 00                	push   $0x0
  pushl $126
c0102bf4:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102bf6:	e9 6e fb ff ff       	jmp    c0102769 <__alltraps>

c0102bfb <vector127>:
.globl vector127
vector127:
  pushl $0
c0102bfb:	6a 00                	push   $0x0
  pushl $127
c0102bfd:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102bff:	e9 65 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c04 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102c04:	6a 00                	push   $0x0
  pushl $128
c0102c06:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102c0b:	e9 59 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c10 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $129
c0102c12:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102c17:	e9 4d fb ff ff       	jmp    c0102769 <__alltraps>

c0102c1c <vector130>:
.globl vector130
vector130:
  pushl $0
c0102c1c:	6a 00                	push   $0x0
  pushl $130
c0102c1e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102c23:	e9 41 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c28 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102c28:	6a 00                	push   $0x0
  pushl $131
c0102c2a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102c2f:	e9 35 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c34 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $132
c0102c36:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102c3b:	e9 29 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c40 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102c40:	6a 00                	push   $0x0
  pushl $133
c0102c42:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102c47:	e9 1d fb ff ff       	jmp    c0102769 <__alltraps>

c0102c4c <vector134>:
.globl vector134
vector134:
  pushl $0
c0102c4c:	6a 00                	push   $0x0
  pushl $134
c0102c4e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102c53:	e9 11 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c58 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $135
c0102c5a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102c5f:	e9 05 fb ff ff       	jmp    c0102769 <__alltraps>

c0102c64 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102c64:	6a 00                	push   $0x0
  pushl $136
c0102c66:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102c6b:	e9 f9 fa ff ff       	jmp    c0102769 <__alltraps>

c0102c70 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102c70:	6a 00                	push   $0x0
  pushl $137
c0102c72:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102c77:	e9 ed fa ff ff       	jmp    c0102769 <__alltraps>

c0102c7c <vector138>:
.globl vector138
vector138:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $138
c0102c7e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102c83:	e9 e1 fa ff ff       	jmp    c0102769 <__alltraps>

c0102c88 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102c88:	6a 00                	push   $0x0
  pushl $139
c0102c8a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102c8f:	e9 d5 fa ff ff       	jmp    c0102769 <__alltraps>

c0102c94 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102c94:	6a 00                	push   $0x0
  pushl $140
c0102c96:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102c9b:	e9 c9 fa ff ff       	jmp    c0102769 <__alltraps>

c0102ca0 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $141
c0102ca2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102ca7:	e9 bd fa ff ff       	jmp    c0102769 <__alltraps>

c0102cac <vector142>:
.globl vector142
vector142:
  pushl $0
c0102cac:	6a 00                	push   $0x0
  pushl $142
c0102cae:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102cb3:	e9 b1 fa ff ff       	jmp    c0102769 <__alltraps>

c0102cb8 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102cb8:	6a 00                	push   $0x0
  pushl $143
c0102cba:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102cbf:	e9 a5 fa ff ff       	jmp    c0102769 <__alltraps>

c0102cc4 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $144
c0102cc6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102ccb:	e9 99 fa ff ff       	jmp    c0102769 <__alltraps>

c0102cd0 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102cd0:	6a 00                	push   $0x0
  pushl $145
c0102cd2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102cd7:	e9 8d fa ff ff       	jmp    c0102769 <__alltraps>

c0102cdc <vector146>:
.globl vector146
vector146:
  pushl $0
c0102cdc:	6a 00                	push   $0x0
  pushl $146
c0102cde:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102ce3:	e9 81 fa ff ff       	jmp    c0102769 <__alltraps>

c0102ce8 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $147
c0102cea:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102cef:	e9 75 fa ff ff       	jmp    c0102769 <__alltraps>

c0102cf4 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102cf4:	6a 00                	push   $0x0
  pushl $148
c0102cf6:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102cfb:	e9 69 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d00 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102d00:	6a 00                	push   $0x0
  pushl $149
c0102d02:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102d07:	e9 5d fa ff ff       	jmp    c0102769 <__alltraps>

c0102d0c <vector150>:
.globl vector150
vector150:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $150
c0102d0e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102d13:	e9 51 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d18 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102d18:	6a 00                	push   $0x0
  pushl $151
c0102d1a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102d1f:	e9 45 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d24 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102d24:	6a 00                	push   $0x0
  pushl $152
c0102d26:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102d2b:	e9 39 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d30 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $153
c0102d32:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102d37:	e9 2d fa ff ff       	jmp    c0102769 <__alltraps>

c0102d3c <vector154>:
.globl vector154
vector154:
  pushl $0
c0102d3c:	6a 00                	push   $0x0
  pushl $154
c0102d3e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102d43:	e9 21 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d48 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102d48:	6a 00                	push   $0x0
  pushl $155
c0102d4a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102d4f:	e9 15 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d54 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $156
c0102d56:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102d5b:	e9 09 fa ff ff       	jmp    c0102769 <__alltraps>

c0102d60 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102d60:	6a 00                	push   $0x0
  pushl $157
c0102d62:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102d67:	e9 fd f9 ff ff       	jmp    c0102769 <__alltraps>

c0102d6c <vector158>:
.globl vector158
vector158:
  pushl $0
c0102d6c:	6a 00                	push   $0x0
  pushl $158
c0102d6e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102d73:	e9 f1 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102d78 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $159
c0102d7a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102d7f:	e9 e5 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102d84 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102d84:	6a 00                	push   $0x0
  pushl $160
c0102d86:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102d8b:	e9 d9 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102d90 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102d90:	6a 00                	push   $0x0
  pushl $161
c0102d92:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102d97:	e9 cd f9 ff ff       	jmp    c0102769 <__alltraps>

c0102d9c <vector162>:
.globl vector162
vector162:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $162
c0102d9e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102da3:	e9 c1 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102da8 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102da8:	6a 00                	push   $0x0
  pushl $163
c0102daa:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102daf:	e9 b5 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102db4 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102db4:	6a 00                	push   $0x0
  pushl $164
c0102db6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102dbb:	e9 a9 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102dc0 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $165
c0102dc2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102dc7:	e9 9d f9 ff ff       	jmp    c0102769 <__alltraps>

c0102dcc <vector166>:
.globl vector166
vector166:
  pushl $0
c0102dcc:	6a 00                	push   $0x0
  pushl $166
c0102dce:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102dd3:	e9 91 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102dd8 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102dd8:	6a 00                	push   $0x0
  pushl $167
c0102dda:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102ddf:	e9 85 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102de4 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $168
c0102de6:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102deb:	e9 79 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102df0 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102df0:	6a 00                	push   $0x0
  pushl $169
c0102df2:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102df7:	e9 6d f9 ff ff       	jmp    c0102769 <__alltraps>

c0102dfc <vector170>:
.globl vector170
vector170:
  pushl $0
c0102dfc:	6a 00                	push   $0x0
  pushl $170
c0102dfe:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102e03:	e9 61 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e08 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $171
c0102e0a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102e0f:	e9 55 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e14 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102e14:	6a 00                	push   $0x0
  pushl $172
c0102e16:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102e1b:	e9 49 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e20 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102e20:	6a 00                	push   $0x0
  pushl $173
c0102e22:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102e27:	e9 3d f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e2c <vector174>:
.globl vector174
vector174:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $174
c0102e2e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102e33:	e9 31 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e38 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102e38:	6a 00                	push   $0x0
  pushl $175
c0102e3a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102e3f:	e9 25 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e44 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102e44:	6a 00                	push   $0x0
  pushl $176
c0102e46:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102e4b:	e9 19 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e50 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $177
c0102e52:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102e57:	e9 0d f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e5c <vector178>:
.globl vector178
vector178:
  pushl $0
c0102e5c:	6a 00                	push   $0x0
  pushl $178
c0102e5e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102e63:	e9 01 f9 ff ff       	jmp    c0102769 <__alltraps>

c0102e68 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102e68:	6a 00                	push   $0x0
  pushl $179
c0102e6a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102e6f:	e9 f5 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102e74 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $180
c0102e76:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102e7b:	e9 e9 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102e80 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102e80:	6a 00                	push   $0x0
  pushl $181
c0102e82:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102e87:	e9 dd f8 ff ff       	jmp    c0102769 <__alltraps>

c0102e8c <vector182>:
.globl vector182
vector182:
  pushl $0
c0102e8c:	6a 00                	push   $0x0
  pushl $182
c0102e8e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102e93:	e9 d1 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102e98 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $183
c0102e9a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102e9f:	e9 c5 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ea4 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102ea4:	6a 00                	push   $0x0
  pushl $184
c0102ea6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102eab:	e9 b9 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102eb0 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102eb0:	6a 00                	push   $0x0
  pushl $185
c0102eb2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102eb7:	e9 ad f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ebc <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $186
c0102ebe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ec3:	e9 a1 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ec8 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ec8:	6a 00                	push   $0x0
  pushl $187
c0102eca:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102ecf:	e9 95 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ed4 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102ed4:	6a 00                	push   $0x0
  pushl $188
c0102ed6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c0102edb:	e9 89 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ee0 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $189
c0102ee2:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102ee7:	e9 7d f8 ff ff       	jmp    c0102769 <__alltraps>

c0102eec <vector190>:
.globl vector190
vector190:
  pushl $0
c0102eec:	6a 00                	push   $0x0
  pushl $190
c0102eee:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102ef3:	e9 71 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102ef8 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102ef8:	6a 00                	push   $0x0
  pushl $191
c0102efa:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102eff:	e9 65 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f04 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $192
c0102f06:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102f0b:	e9 59 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f10 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102f10:	6a 00                	push   $0x0
  pushl $193
c0102f12:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102f17:	e9 4d f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f1c <vector194>:
.globl vector194
vector194:
  pushl $0
c0102f1c:	6a 00                	push   $0x0
  pushl $194
c0102f1e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102f23:	e9 41 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f28 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $195
c0102f2a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102f2f:	e9 35 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f34 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102f34:	6a 00                	push   $0x0
  pushl $196
c0102f36:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102f3b:	e9 29 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f40 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102f40:	6a 00                	push   $0x0
  pushl $197
c0102f42:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102f47:	e9 1d f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f4c <vector198>:
.globl vector198
vector198:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $198
c0102f4e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102f53:	e9 11 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f58 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102f58:	6a 00                	push   $0x0
  pushl $199
c0102f5a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102f5f:	e9 05 f8 ff ff       	jmp    c0102769 <__alltraps>

c0102f64 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102f64:	6a 00                	push   $0x0
  pushl $200
c0102f66:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102f6b:	e9 f9 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102f70 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $201
c0102f72:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102f77:	e9 ed f7 ff ff       	jmp    c0102769 <__alltraps>

c0102f7c <vector202>:
.globl vector202
vector202:
  pushl $0
c0102f7c:	6a 00                	push   $0x0
  pushl $202
c0102f7e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102f83:	e9 e1 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102f88 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102f88:	6a 00                	push   $0x0
  pushl $203
c0102f8a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102f8f:	e9 d5 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102f94 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $204
c0102f96:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102f9b:	e9 c9 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fa0 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102fa0:	6a 00                	push   $0x0
  pushl $205
c0102fa2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102fa7:	e9 bd f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fac <vector206>:
.globl vector206
vector206:
  pushl $0
c0102fac:	6a 00                	push   $0x0
  pushl $206
c0102fae:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102fb3:	e9 b1 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fb8 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $207
c0102fba:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0102fbf:	e9 a5 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fc4 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $208
c0102fc6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c0102fcb:	e9 99 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fd0 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $209
c0102fd2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102fd7:	e9 8d f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fdc <vector210>:
.globl vector210
vector210:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $210
c0102fde:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102fe3:	e9 81 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102fe8 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $211
c0102fea:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102fef:	e9 75 f7 ff ff       	jmp    c0102769 <__alltraps>

c0102ff4 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $212
c0102ff6:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102ffb:	e9 69 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103000 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $213
c0103002:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103007:	e9 5d f7 ff ff       	jmp    c0102769 <__alltraps>

c010300c <vector214>:
.globl vector214
vector214:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $214
c010300e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103013:	e9 51 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103018 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $215
c010301a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010301f:	e9 45 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103024 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $216
c0103026:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010302b:	e9 39 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103030 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $217
c0103032:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103037:	e9 2d f7 ff ff       	jmp    c0102769 <__alltraps>

c010303c <vector218>:
.globl vector218
vector218:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $218
c010303e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103043:	e9 21 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103048 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $219
c010304a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010304f:	e9 15 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103054 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $220
c0103056:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010305b:	e9 09 f7 ff ff       	jmp    c0102769 <__alltraps>

c0103060 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $221
c0103062:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103067:	e9 fd f6 ff ff       	jmp    c0102769 <__alltraps>

c010306c <vector222>:
.globl vector222
vector222:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $222
c010306e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103073:	e9 f1 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103078 <vector223>:
.globl vector223
vector223:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $223
c010307a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010307f:	e9 e5 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103084 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $224
c0103086:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010308b:	e9 d9 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103090 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $225
c0103092:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0103097:	e9 cd f6 ff ff       	jmp    c0102769 <__alltraps>

c010309c <vector226>:
.globl vector226
vector226:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $226
c010309e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01030a3:	e9 c1 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030a8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $227
c01030aa:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01030af:	e9 b5 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030b4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $228
c01030b6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01030bb:	e9 a9 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030c0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $229
c01030c2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01030c7:	e9 9d f6 ff ff       	jmp    c0102769 <__alltraps>

c01030cc <vector230>:
.globl vector230
vector230:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $230
c01030ce:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01030d3:	e9 91 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030d8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $231
c01030da:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01030df:	e9 85 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030e4 <vector232>:
.globl vector232
vector232:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $232
c01030e6:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01030eb:	e9 79 f6 ff ff       	jmp    c0102769 <__alltraps>

c01030f0 <vector233>:
.globl vector233
vector233:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $233
c01030f2:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01030f7:	e9 6d f6 ff ff       	jmp    c0102769 <__alltraps>

c01030fc <vector234>:
.globl vector234
vector234:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $234
c01030fe:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103103:	e9 61 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103108 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $235
c010310a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010310f:	e9 55 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103114 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $236
c0103116:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010311b:	e9 49 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103120 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $237
c0103122:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103127:	e9 3d f6 ff ff       	jmp    c0102769 <__alltraps>

c010312c <vector238>:
.globl vector238
vector238:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $238
c010312e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103133:	e9 31 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103138 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $239
c010313a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010313f:	e9 25 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103144 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $240
c0103146:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010314b:	e9 19 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103150 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $241
c0103152:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103157:	e9 0d f6 ff ff       	jmp    c0102769 <__alltraps>

c010315c <vector242>:
.globl vector242
vector242:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $242
c010315e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103163:	e9 01 f6 ff ff       	jmp    c0102769 <__alltraps>

c0103168 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $243
c010316a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010316f:	e9 f5 f5 ff ff       	jmp    c0102769 <__alltraps>

c0103174 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $244
c0103176:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010317b:	e9 e9 f5 ff ff       	jmp    c0102769 <__alltraps>

c0103180 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $245
c0103182:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0103187:	e9 dd f5 ff ff       	jmp    c0102769 <__alltraps>

c010318c <vector246>:
.globl vector246
vector246:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $246
c010318e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103193:	e9 d1 f5 ff ff       	jmp    c0102769 <__alltraps>

c0103198 <vector247>:
.globl vector247
vector247:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $247
c010319a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010319f:	e9 c5 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031a4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $248
c01031a6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01031ab:	e9 b9 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031b0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $249
c01031b2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01031b7:	e9 ad f5 ff ff       	jmp    c0102769 <__alltraps>

c01031bc <vector250>:
.globl vector250
vector250:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $250
c01031be:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01031c3:	e9 a1 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031c8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $251
c01031ca:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01031cf:	e9 95 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031d4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $252
c01031d6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01031db:	e9 89 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031e0 <vector253>:
.globl vector253
vector253:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $253
c01031e2:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01031e7:	e9 7d f5 ff ff       	jmp    c0102769 <__alltraps>

c01031ec <vector254>:
.globl vector254
vector254:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $254
c01031ee:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01031f3:	e9 71 f5 ff ff       	jmp    c0102769 <__alltraps>

c01031f8 <vector255>:
.globl vector255
vector255:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $255
c01031fa:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01031ff:	e9 65 f5 ff ff       	jmp    c0102769 <__alltraps>

c0103204 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103204:	55                   	push   %ebp
c0103205:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103207:	8b 55 08             	mov    0x8(%ebp),%edx
c010320a:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010320f:	29 c2                	sub    %eax,%edx
c0103211:	89 d0                	mov    %edx,%eax
c0103213:	c1 f8 05             	sar    $0x5,%eax
}
c0103216:	5d                   	pop    %ebp
c0103217:	c3                   	ret    

c0103218 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103218:	55                   	push   %ebp
c0103219:	89 e5                	mov    %esp,%ebp
c010321b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010321e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103221:	89 04 24             	mov    %eax,(%esp)
c0103224:	e8 db ff ff ff       	call   c0103204 <page2ppn>
c0103229:	c1 e0 0c             	shl    $0xc,%eax
}
c010322c:	c9                   	leave  
c010322d:	c3                   	ret    

c010322e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010322e:	55                   	push   %ebp
c010322f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103231:	8b 45 08             	mov    0x8(%ebp),%eax
c0103234:	8b 00                	mov    (%eax),%eax
}
c0103236:	5d                   	pop    %ebp
c0103237:	c3                   	ret    

c0103238 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103238:	55                   	push   %ebp
c0103239:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010323b:	8b 45 08             	mov    0x8(%ebp),%eax
c010323e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103241:	89 10                	mov    %edx,(%eax)
}
c0103243:	5d                   	pop    %ebp
c0103244:	c3                   	ret    

c0103245 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103245:	55                   	push   %ebp
c0103246:	89 e5                	mov    %esp,%ebp
c0103248:	83 ec 10             	sub    $0x10,%esp
c010324b:	c7 45 fc 18 7b 12 c0 	movl   $0xc0127b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103252:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103255:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0103258:	89 50 04             	mov    %edx,0x4(%eax)
c010325b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010325e:	8b 50 04             	mov    0x4(%eax),%edx
c0103261:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103264:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103266:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c010326d:	00 00 00 
}
c0103270:	c9                   	leave  
c0103271:	c3                   	ret    

c0103272 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103272:	55                   	push   %ebp
c0103273:	89 e5                	mov    %esp,%ebp
c0103275:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0103278:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010327c:	75 24                	jne    c01032a2 <default_init_memmap+0x30>
c010327e:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c0103285:	c0 
c0103286:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c010328d:	c0 
c010328e:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0103295:	00 
c0103296:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010329d:	e8 3b da ff ff       	call   c0100cdd <__panic>
    struct Page *p = base;
c01032a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01032a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01032a8:	e9 dc 00 00 00       	jmp    c0103389 <default_init_memmap+0x117>
        assert(PageReserved(p));
c01032ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032b0:	83 c0 04             	add    $0x4,%eax
c01032b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01032ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01032bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01032c3:	0f a3 10             	bt     %edx,(%eax)
c01032c6:	19 c0                	sbb    %eax,%eax
c01032c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01032cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01032cf:	0f 95 c0             	setne  %al
c01032d2:	0f b6 c0             	movzbl %al,%eax
c01032d5:	85 c0                	test   %eax,%eax
c01032d7:	75 24                	jne    c01032fd <default_init_memmap+0x8b>
c01032d9:	c7 44 24 0c 61 a5 10 	movl   $0xc010a561,0xc(%esp)
c01032e0:	c0 
c01032e1:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01032e8:	c0 
c01032e9:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01032f0:	00 
c01032f1:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01032f8:	e8 e0 d9 ff ff       	call   c0100cdd <__panic>
        p->flags = 0;
c01032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103300:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c0103307:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010330a:	83 c0 04             	add    $0x4,%eax
c010330d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103314:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103317:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010331a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010331d:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0103320:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103323:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c010332a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103331:	00 
c0103332:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103335:	89 04 24             	mov    %eax,(%esp)
c0103338:	e8 fb fe ff ff       	call   c0103238 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c010333d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103340:	83 c0 0c             	add    $0xc,%eax
c0103343:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
c010334a:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c010334d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103350:	8b 00                	mov    (%eax),%eax
c0103352:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103355:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103358:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010335b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010335e:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103361:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103364:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103367:	89 10                	mov    %edx,(%eax)
c0103369:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010336c:	8b 10                	mov    (%eax),%edx
c010336e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103371:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103374:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103377:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010337a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010337d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103380:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103383:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0103385:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103389:	8b 45 0c             	mov    0xc(%ebp),%eax
c010338c:	c1 e0 05             	shl    $0x5,%eax
c010338f:	89 c2                	mov    %eax,%edx
c0103391:	8b 45 08             	mov    0x8(%ebp),%eax
c0103394:	01 d0                	add    %edx,%eax
c0103396:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103399:	0f 85 0e ff ff ff    	jne    c01032ad <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free += n;
c010339f:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c01033a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033a8:	01 d0                	add    %edx,%eax
c01033aa:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    //first block
    base->property = n;
c01033af:	8b 45 08             	mov    0x8(%ebp),%eax
c01033b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01033b5:	89 50 08             	mov    %edx,0x8(%eax)
}
c01033b8:	c9                   	leave  
c01033b9:	c3                   	ret    

c01033ba <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01033ba:	55                   	push   %ebp
c01033bb:	89 e5                	mov    %esp,%ebp
c01033bd:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01033c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01033c4:	75 24                	jne    c01033ea <default_alloc_pages+0x30>
c01033c6:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c01033cd:	c0 
c01033ce:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01033d5:	c0 
c01033d6:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c01033dd:	00 
c01033de:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01033e5:	e8 f3 d8 ff ff       	call   c0100cdd <__panic>
    if (n > nr_free) {
c01033ea:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01033ef:	3b 45 08             	cmp    0x8(%ebp),%eax
c01033f2:	73 0a                	jae    c01033fe <default_alloc_pages+0x44>
        return NULL;
c01033f4:	b8 00 00 00 00       	mov    $0x0,%eax
c01033f9:	e9 37 01 00 00       	jmp    c0103535 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c01033fe:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c0103405:	e9 0a 01 00 00       	jmp    c0103514 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c010340a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340d:	83 e8 0c             	sub    $0xc,%eax
c0103410:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0103413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103416:	8b 40 08             	mov    0x8(%eax),%eax
c0103419:	3b 45 08             	cmp    0x8(%ebp),%eax
c010341c:	0f 82 f2 00 00 00    	jb     c0103514 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c0103422:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103429:	eb 7c                	jmp    c01034a7 <default_alloc_pages+0xed>
c010342b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010342e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103431:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103434:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0103437:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c010343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343d:	83 e8 0c             	sub    $0xc,%eax
c0103440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0103443:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103446:	83 c0 04             	add    $0x4,%eax
c0103449:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103450:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103453:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103456:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103459:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c010345c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010345f:	83 c0 04             	add    $0x4,%eax
c0103462:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103469:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010346c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010346f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103472:	0f b3 10             	btr    %edx,(%eax)
c0103475:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103478:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010347b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010347e:	8b 40 04             	mov    0x4(%eax),%eax
c0103481:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103484:	8b 12                	mov    (%edx),%edx
c0103486:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0103489:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c010348c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010348f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103492:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103495:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103498:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010349b:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c010349d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01034a0:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c01034a3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01034a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034aa:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034ad:	0f 82 78 ff ff ff    	jb     c010342b <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c01034b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034b6:	8b 40 08             	mov    0x8(%eax),%eax
c01034b9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01034bc:	76 12                	jbe    c01034d0 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c01034be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034c1:	8d 50 f4             	lea    -0xc(%eax),%edx
c01034c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034c7:	8b 40 08             	mov    0x8(%eax),%eax
c01034ca:	2b 45 08             	sub    0x8(%ebp),%eax
c01034cd:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c01034d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034d3:	83 c0 04             	add    $0x4,%eax
c01034d6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
c01034e0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034e3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034e6:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c01034e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034ec:	83 c0 04             	add    $0x4,%eax
c01034ef:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01034f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01034f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01034ff:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c0103502:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103507:	2b 45 08             	sub    0x8(%ebp),%eax
c010350a:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
        return p;
c010350f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103512:	eb 21                	jmp    c0103535 <default_alloc_pages+0x17b>
c0103514:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103517:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010351a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010351d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c0103520:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103523:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c010352a:	0f 85 da fe ff ff    	jne    c010340a <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0103530:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103535:	c9                   	leave  
c0103536:	c3                   	ret    

c0103537 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103537:	55                   	push   %ebp
c0103538:	89 e5                	mov    %esp,%ebp
c010353a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010353d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103541:	75 24                	jne    c0103567 <default_free_pages+0x30>
c0103543:	c7 44 24 0c 30 a5 10 	movl   $0xc010a530,0xc(%esp)
c010354a:	c0 
c010354b:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103552:	c0 
c0103553:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c010355a:	00 
c010355b:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103562:	e8 76 d7 ff ff       	call   c0100cdd <__panic>
    assert(PageReserved(base));
c0103567:	8b 45 08             	mov    0x8(%ebp),%eax
c010356a:	83 c0 04             	add    $0x4,%eax
c010356d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103574:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103577:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010357a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010357d:	0f a3 10             	bt     %edx,(%eax)
c0103580:	19 c0                	sbb    %eax,%eax
c0103582:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0103585:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103589:	0f 95 c0             	setne  %al
c010358c:	0f b6 c0             	movzbl %al,%eax
c010358f:	85 c0                	test   %eax,%eax
c0103591:	75 24                	jne    c01035b7 <default_free_pages+0x80>
c0103593:	c7 44 24 0c 71 a5 10 	movl   $0xc010a571,0xc(%esp)
c010359a:	c0 
c010359b:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01035a2:	c0 
c01035a3:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c01035aa:	00 
c01035ab:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01035b2:	e8 26 d7 ff ff       	call   c0100cdd <__panic>

    list_entry_t *le = &free_list;
c01035b7:	c7 45 f4 18 7b 12 c0 	movl   $0xc0127b18,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c01035be:	eb 13                	jmp    c01035d3 <default_free_pages+0x9c>
      p = le2page(le, page_link);
c01035c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035c3:	83 e8 0c             	sub    $0xc,%eax
c01035c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c01035c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035cc:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035cf:	76 02                	jbe    c01035d3 <default_free_pages+0x9c>
        break;
c01035d1:	eb 18                	jmp    c01035eb <default_free_pages+0xb4>
c01035d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01035d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01035dc:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c01035df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01035e2:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c01035e9:	75 d5                	jne    c01035c0 <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c01035eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01035f1:	eb 4b                	jmp    c010363e <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c01035f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035f6:	8d 50 0c             	lea    0xc(%eax),%edx
c01035f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035fc:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01035ff:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103602:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103605:	8b 00                	mov    (%eax),%eax
c0103607:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010360a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010360d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103610:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103613:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103616:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103619:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010361c:	89 10                	mov    %edx,(%eax)
c010361e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103621:	8b 10                	mov    (%eax),%edx
c0103623:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103626:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103629:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010362c:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010362f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103632:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103635:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103638:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p=base;p<base+n;p++){
c010363a:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c010363e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103641:	c1 e0 05             	shl    $0x5,%eax
c0103644:	89 c2                	mov    %eax,%edx
c0103646:	8b 45 08             	mov    0x8(%ebp),%eax
c0103649:	01 d0                	add    %edx,%eax
c010364b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010364e:	77 a3                	ja     c01035f3 <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0103650:	8b 45 08             	mov    0x8(%ebp),%eax
c0103653:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c010365a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103661:	00 
c0103662:	8b 45 08             	mov    0x8(%ebp),%eax
c0103665:	89 04 24             	mov    %eax,(%esp)
c0103668:	e8 cb fb ff ff       	call   c0103238 <set_page_ref>
    ClearPageProperty(base);
c010366d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103670:	83 c0 04             	add    $0x4,%eax
c0103673:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c010367a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010367d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103680:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103683:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0103686:	8b 45 08             	mov    0x8(%ebp),%eax
c0103689:	83 c0 04             	add    $0x4,%eax
c010368c:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103693:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103696:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103699:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010369c:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c010369f:	8b 45 08             	mov    0x8(%ebp),%eax
c01036a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01036a5:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c01036a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ab:	83 e8 0c             	sub    $0xc,%eax
c01036ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c01036b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036b4:	c1 e0 05             	shl    $0x5,%eax
c01036b7:	89 c2                	mov    %eax,%edx
c01036b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01036bc:	01 d0                	add    %edx,%eax
c01036be:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01036c1:	75 1e                	jne    c01036e1 <default_free_pages+0x1aa>
      base->property += p->property;
c01036c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01036c6:	8b 50 08             	mov    0x8(%eax),%edx
c01036c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036cc:	8b 40 08             	mov    0x8(%eax),%eax
c01036cf:	01 c2                	add    %eax,%edx
c01036d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036d4:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c01036d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c01036e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01036e4:	83 c0 0c             	add    $0xc,%eax
c01036e7:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01036ea:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01036ed:	8b 00                	mov    (%eax),%eax
c01036ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c01036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f5:	83 e8 0c             	sub    $0xc,%eax
c01036f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c01036fb:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103702:	74 57                	je     c010375b <default_free_pages+0x224>
c0103704:	8b 45 08             	mov    0x8(%ebp),%eax
c0103707:	83 e8 20             	sub    $0x20,%eax
c010370a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010370d:	75 4c                	jne    c010375b <default_free_pages+0x224>
      while(le!=&free_list){
c010370f:	eb 41                	jmp    c0103752 <default_free_pages+0x21b>
        if(p->property){
c0103711:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103714:	8b 40 08             	mov    0x8(%eax),%eax
c0103717:	85 c0                	test   %eax,%eax
c0103719:	74 20                	je     c010373b <default_free_pages+0x204>
          p->property += base->property;
c010371b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010371e:	8b 50 08             	mov    0x8(%eax),%edx
c0103721:	8b 45 08             	mov    0x8(%ebp),%eax
c0103724:	8b 40 08             	mov    0x8(%eax),%eax
c0103727:	01 c2                	add    %eax,%edx
c0103729:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010372c:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c010372f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103732:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0103739:	eb 20                	jmp    c010375b <default_free_pages+0x224>
c010373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103741:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103744:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103746:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010374c:	83 e8 0c             	sub    $0xc,%eax
c010374f:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0103752:	81 7d f4 18 7b 12 c0 	cmpl   $0xc0127b18,-0xc(%ebp)
c0103759:	75 b6                	jne    c0103711 <default_free_pages+0x1da>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free += n;
c010375b:	8b 15 20 7b 12 c0    	mov    0xc0127b20,%edx
c0103761:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103764:	01 d0                	add    %edx,%eax
c0103766:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
    return ;
c010376b:	90                   	nop
}
c010376c:	c9                   	leave  
c010376d:	c3                   	ret    

c010376e <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010376e:	55                   	push   %ebp
c010376f:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103771:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
}
c0103776:	5d                   	pop    %ebp
c0103777:	c3                   	ret    

c0103778 <basic_check>:

static void
basic_check(void) {
c0103778:	55                   	push   %ebp
c0103779:	89 e5                	mov    %esp,%ebp
c010377b:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010377e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103785:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103788:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010378b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010378e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103791:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103798:	e8 c4 15 00 00       	call   c0104d61 <alloc_pages>
c010379d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01037a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01037a4:	75 24                	jne    c01037ca <basic_check+0x52>
c01037a6:	c7 44 24 0c 84 a5 10 	movl   $0xc010a584,0xc(%esp)
c01037ad:	c0 
c01037ae:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01037b5:	c0 
c01037b6:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c01037bd:	00 
c01037be:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01037c5:	e8 13 d5 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c01037ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037d1:	e8 8b 15 00 00       	call   c0104d61 <alloc_pages>
c01037d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01037d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01037dd:	75 24                	jne    c0103803 <basic_check+0x8b>
c01037df:	c7 44 24 0c a0 a5 10 	movl   $0xc010a5a0,0xc(%esp)
c01037e6:	c0 
c01037e7:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01037ee:	c0 
c01037ef:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c01037f6:	00 
c01037f7:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01037fe:	e8 da d4 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103803:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010380a:	e8 52 15 00 00       	call   c0104d61 <alloc_pages>
c010380f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103812:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103816:	75 24                	jne    c010383c <basic_check+0xc4>
c0103818:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c010381f:	c0 
c0103820:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103827:	c0 
c0103828:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c010382f:	00 
c0103830:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103837:	e8 a1 d4 ff ff       	call   c0100cdd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c010383c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010383f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103842:	74 10                	je     c0103854 <basic_check+0xdc>
c0103844:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103847:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010384a:	74 08                	je     c0103854 <basic_check+0xdc>
c010384c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010384f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103852:	75 24                	jne    c0103878 <basic_check+0x100>
c0103854:	c7 44 24 0c d8 a5 10 	movl   $0xc010a5d8,0xc(%esp)
c010385b:	c0 
c010385c:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103863:	c0 
c0103864:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c010386b:	00 
c010386c:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103873:	e8 65 d4 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103878:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010387b:	89 04 24             	mov    %eax,(%esp)
c010387e:	e8 ab f9 ff ff       	call   c010322e <page_ref>
c0103883:	85 c0                	test   %eax,%eax
c0103885:	75 1e                	jne    c01038a5 <basic_check+0x12d>
c0103887:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010388a:	89 04 24             	mov    %eax,(%esp)
c010388d:	e8 9c f9 ff ff       	call   c010322e <page_ref>
c0103892:	85 c0                	test   %eax,%eax
c0103894:	75 0f                	jne    c01038a5 <basic_check+0x12d>
c0103896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103899:	89 04 24             	mov    %eax,(%esp)
c010389c:	e8 8d f9 ff ff       	call   c010322e <page_ref>
c01038a1:	85 c0                	test   %eax,%eax
c01038a3:	74 24                	je     c01038c9 <basic_check+0x151>
c01038a5:	c7 44 24 0c fc a5 10 	movl   $0xc010a5fc,0xc(%esp)
c01038ac:	c0 
c01038ad:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01038b4:	c0 
c01038b5:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c01038bc:	00 
c01038bd:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01038c4:	e8 14 d4 ff ff       	call   c0100cdd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01038c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038cc:	89 04 24             	mov    %eax,(%esp)
c01038cf:	e8 44 f9 ff ff       	call   c0103218 <page2pa>
c01038d4:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c01038da:	c1 e2 0c             	shl    $0xc,%edx
c01038dd:	39 d0                	cmp    %edx,%eax
c01038df:	72 24                	jb     c0103905 <basic_check+0x18d>
c01038e1:	c7 44 24 0c 38 a6 10 	movl   $0xc010a638,0xc(%esp)
c01038e8:	c0 
c01038e9:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01038f0:	c0 
c01038f1:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01038f8:	00 
c01038f9:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103900:	e8 d8 d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103905:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103908:	89 04 24             	mov    %eax,(%esp)
c010390b:	e8 08 f9 ff ff       	call   c0103218 <page2pa>
c0103910:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103916:	c1 e2 0c             	shl    $0xc,%edx
c0103919:	39 d0                	cmp    %edx,%eax
c010391b:	72 24                	jb     c0103941 <basic_check+0x1c9>
c010391d:	c7 44 24 0c 55 a6 10 	movl   $0xc010a655,0xc(%esp)
c0103924:	c0 
c0103925:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c010392c:	c0 
c010392d:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103934:	00 
c0103935:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010393c:	e8 9c d3 ff ff       	call   c0100cdd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103941:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103944:	89 04 24             	mov    %eax,(%esp)
c0103947:	e8 cc f8 ff ff       	call   c0103218 <page2pa>
c010394c:	8b 15 40 5a 12 c0    	mov    0xc0125a40,%edx
c0103952:	c1 e2 0c             	shl    $0xc,%edx
c0103955:	39 d0                	cmp    %edx,%eax
c0103957:	72 24                	jb     c010397d <basic_check+0x205>
c0103959:	c7 44 24 0c 72 a6 10 	movl   $0xc010a672,0xc(%esp)
c0103960:	c0 
c0103961:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103968:	c0 
c0103969:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0103970:	00 
c0103971:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103978:	e8 60 d3 ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c010397d:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103982:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103988:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010398b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010398e:	c7 45 e0 18 7b 12 c0 	movl   $0xc0127b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103995:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103998:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010399b:	89 50 04             	mov    %edx,0x4(%eax)
c010399e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039a1:	8b 50 04             	mov    0x4(%eax),%edx
c01039a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01039a7:	89 10                	mov    %edx,(%eax)
c01039a9:	c7 45 dc 18 7b 12 c0 	movl   $0xc0127b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01039b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039b3:	8b 40 04             	mov    0x4(%eax),%eax
c01039b6:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01039b9:	0f 94 c0             	sete   %al
c01039bc:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01039bf:	85 c0                	test   %eax,%eax
c01039c1:	75 24                	jne    c01039e7 <basic_check+0x26f>
c01039c3:	c7 44 24 0c 8f a6 10 	movl   $0xc010a68f,0xc(%esp)
c01039ca:	c0 
c01039cb:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01039d2:	c0 
c01039d3:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c01039da:	00 
c01039db:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01039e2:	e8 f6 d2 ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c01039e7:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c01039ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01039ef:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c01039f6:	00 00 00 

    assert(alloc_page() == NULL);
c01039f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a00:	e8 5c 13 00 00       	call   c0104d61 <alloc_pages>
c0103a05:	85 c0                	test   %eax,%eax
c0103a07:	74 24                	je     c0103a2d <basic_check+0x2b5>
c0103a09:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103a10:	c0 
c0103a11:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103a18:	c0 
c0103a19:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0103a20:	00 
c0103a21:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103a28:	e8 b0 d2 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103a2d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a34:	00 
c0103a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a38:	89 04 24             	mov    %eax,(%esp)
c0103a3b:	e8 8c 13 00 00       	call   c0104dcc <free_pages>
    free_page(p1);
c0103a40:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a47:	00 
c0103a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a4b:	89 04 24             	mov    %eax,(%esp)
c0103a4e:	e8 79 13 00 00       	call   c0104dcc <free_pages>
    free_page(p2);
c0103a53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a5a:	00 
c0103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5e:	89 04 24             	mov    %eax,(%esp)
c0103a61:	e8 66 13 00 00       	call   c0104dcc <free_pages>
    assert(nr_free == 3);
c0103a66:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103a6b:	83 f8 03             	cmp    $0x3,%eax
c0103a6e:	74 24                	je     c0103a94 <basic_check+0x31c>
c0103a70:	c7 44 24 0c bb a6 10 	movl   $0xc010a6bb,0xc(%esp)
c0103a77:	c0 
c0103a78:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103a7f:	c0 
c0103a80:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0103a87:	00 
c0103a88:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103a8f:	e8 49 d2 ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103a94:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a9b:	e8 c1 12 00 00       	call   c0104d61 <alloc_pages>
c0103aa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103aa3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103aa7:	75 24                	jne    c0103acd <basic_check+0x355>
c0103aa9:	c7 44 24 0c 84 a5 10 	movl   $0xc010a584,0xc(%esp)
c0103ab0:	c0 
c0103ab1:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ab8:	c0 
c0103ab9:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103ac0:	00 
c0103ac1:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103ac8:	e8 10 d2 ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ad4:	e8 88 12 00 00       	call   c0104d61 <alloc_pages>
c0103ad9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103adc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103ae0:	75 24                	jne    c0103b06 <basic_check+0x38e>
c0103ae2:	c7 44 24 0c a0 a5 10 	movl   $0xc010a5a0,0xc(%esp)
c0103ae9:	c0 
c0103aea:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103af1:	c0 
c0103af2:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103af9:	00 
c0103afa:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b01:	e8 d7 d1 ff ff       	call   c0100cdd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103b06:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b0d:	e8 4f 12 00 00       	call   c0104d61 <alloc_pages>
c0103b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103b15:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103b19:	75 24                	jne    c0103b3f <basic_check+0x3c7>
c0103b1b:	c7 44 24 0c bc a5 10 	movl   $0xc010a5bc,0xc(%esp)
c0103b22:	c0 
c0103b23:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103b2a:	c0 
c0103b2b:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0103b32:	00 
c0103b33:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b3a:	e8 9e d1 ff ff       	call   c0100cdd <__panic>

    assert(alloc_page() == NULL);
c0103b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b46:	e8 16 12 00 00       	call   c0104d61 <alloc_pages>
c0103b4b:	85 c0                	test   %eax,%eax
c0103b4d:	74 24                	je     c0103b73 <basic_check+0x3fb>
c0103b4f:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103b56:	c0 
c0103b57:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103b5e:	c0 
c0103b5f:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103b66:	00 
c0103b67:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103b6e:	e8 6a d1 ff ff       	call   c0100cdd <__panic>

    free_page(p0);
c0103b73:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b7a:	00 
c0103b7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b7e:	89 04 24             	mov    %eax,(%esp)
c0103b81:	e8 46 12 00 00       	call   c0104dcc <free_pages>
c0103b86:	c7 45 d8 18 7b 12 c0 	movl   $0xc0127b18,-0x28(%ebp)
c0103b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103b90:	8b 40 04             	mov    0x4(%eax),%eax
c0103b93:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103b96:	0f 94 c0             	sete   %al
c0103b99:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103b9c:	85 c0                	test   %eax,%eax
c0103b9e:	74 24                	je     c0103bc4 <basic_check+0x44c>
c0103ba0:	c7 44 24 0c c8 a6 10 	movl   $0xc010a6c8,0xc(%esp)
c0103ba7:	c0 
c0103ba8:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103baf:	c0 
c0103bb0:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103bb7:	00 
c0103bb8:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103bbf:	e8 19 d1 ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103bc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bcb:	e8 91 11 00 00       	call   c0104d61 <alloc_pages>
c0103bd0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103bd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103bd6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103bd9:	74 24                	je     c0103bff <basic_check+0x487>
c0103bdb:	c7 44 24 0c e0 a6 10 	movl   $0xc010a6e0,0xc(%esp)
c0103be2:	c0 
c0103be3:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103bea:	c0 
c0103beb:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103bf2:	00 
c0103bf3:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103bfa:	e8 de d0 ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103bff:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c06:	e8 56 11 00 00       	call   c0104d61 <alloc_pages>
c0103c0b:	85 c0                	test   %eax,%eax
c0103c0d:	74 24                	je     c0103c33 <basic_check+0x4bb>
c0103c0f:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103c16:	c0 
c0103c17:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103c1e:	c0 
c0103c1f:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103c26:	00 
c0103c27:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103c2e:	e8 aa d0 ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0103c33:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103c38:	85 c0                	test   %eax,%eax
c0103c3a:	74 24                	je     c0103c60 <basic_check+0x4e8>
c0103c3c:	c7 44 24 0c f9 a6 10 	movl   $0xc010a6f9,0xc(%esp)
c0103c43:	c0 
c0103c44:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103c4b:	c0 
c0103c4c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103c53:	00 
c0103c54:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103c5b:	e8 7d d0 ff ff       	call   c0100cdd <__panic>
    free_list = free_list_store;
c0103c60:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103c63:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103c66:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0103c6b:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    nr_free = nr_free_store;
c0103c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103c74:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_page(p);
c0103c79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c80:	00 
c0103c81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c84:	89 04 24             	mov    %eax,(%esp)
c0103c87:	e8 40 11 00 00       	call   c0104dcc <free_pages>
    free_page(p1);
c0103c8c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c93:	00 
c0103c94:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c97:	89 04 24             	mov    %eax,(%esp)
c0103c9a:	e8 2d 11 00 00       	call   c0104dcc <free_pages>
    free_page(p2);
c0103c9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ca6:	00 
c0103ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103caa:	89 04 24             	mov    %eax,(%esp)
c0103cad:	e8 1a 11 00 00       	call   c0104dcc <free_pages>
}
c0103cb2:	c9                   	leave  
c0103cb3:	c3                   	ret    

c0103cb4 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103cb4:	55                   	push   %ebp
c0103cb5:	89 e5                	mov    %esp,%ebp
c0103cb7:	53                   	push   %ebx
c0103cb8:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103cbe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103cc5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103ccc:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103cd3:	eb 6b                	jmp    c0103d40 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103cd5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cd8:	83 e8 0c             	sub    $0xc,%eax
c0103cdb:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103ce1:	83 c0 04             	add    $0x4,%eax
c0103ce4:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103ceb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103cee:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103cf1:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103cf4:	0f a3 10             	bt     %edx,(%eax)
c0103cf7:	19 c0                	sbb    %eax,%eax
c0103cf9:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103cfc:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103d00:	0f 95 c0             	setne  %al
c0103d03:	0f b6 c0             	movzbl %al,%eax
c0103d06:	85 c0                	test   %eax,%eax
c0103d08:	75 24                	jne    c0103d2e <default_check+0x7a>
c0103d0a:	c7 44 24 0c 06 a7 10 	movl   $0xc010a706,0xc(%esp)
c0103d11:	c0 
c0103d12:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103d19:	c0 
c0103d1a:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0103d21:	00 
c0103d22:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103d29:	e8 af cf ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0103d2e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103d32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d35:	8b 50 08             	mov    0x8(%eax),%edx
c0103d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d3b:	01 d0                	add    %edx,%eax
c0103d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d40:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103d43:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103d46:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103d49:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103d4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103d4f:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c0103d56:	0f 85 79 ff ff ff    	jne    c0103cd5 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103d5c:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103d5f:	e8 9a 10 00 00       	call   c0104dfe <nr_free_pages>
c0103d64:	39 c3                	cmp    %eax,%ebx
c0103d66:	74 24                	je     c0103d8c <default_check+0xd8>
c0103d68:	c7 44 24 0c 16 a7 10 	movl   $0xc010a716,0xc(%esp)
c0103d6f:	c0 
c0103d70:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103d77:	c0 
c0103d78:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103d7f:	00 
c0103d80:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103d87:	e8 51 cf ff ff       	call   c0100cdd <__panic>

    basic_check();
c0103d8c:	e8 e7 f9 ff ff       	call   c0103778 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103d91:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103d98:	e8 c4 0f 00 00       	call   c0104d61 <alloc_pages>
c0103d9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103da0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103da4:	75 24                	jne    c0103dca <default_check+0x116>
c0103da6:	c7 44 24 0c 2f a7 10 	movl   $0xc010a72f,0xc(%esp)
c0103dad:	c0 
c0103dae:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103db5:	c0 
c0103db6:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103dbd:	00 
c0103dbe:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103dc5:	e8 13 cf ff ff       	call   c0100cdd <__panic>
    assert(!PageProperty(p0));
c0103dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dcd:	83 c0 04             	add    $0x4,%eax
c0103dd0:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103dd7:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103dda:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103ddd:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103de0:	0f a3 10             	bt     %edx,(%eax)
c0103de3:	19 c0                	sbb    %eax,%eax
c0103de5:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103de8:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103dec:	0f 95 c0             	setne  %al
c0103def:	0f b6 c0             	movzbl %al,%eax
c0103df2:	85 c0                	test   %eax,%eax
c0103df4:	74 24                	je     c0103e1a <default_check+0x166>
c0103df6:	c7 44 24 0c 3a a7 10 	movl   $0xc010a73a,0xc(%esp)
c0103dfd:	c0 
c0103dfe:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103e05:	c0 
c0103e06:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
c0103e0d:	00 
c0103e0e:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103e15:	e8 c3 ce ff ff       	call   c0100cdd <__panic>

    list_entry_t free_list_store = free_list;
c0103e1a:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0103e1f:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0103e25:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103e28:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103e2b:	c7 45 b4 18 7b 12 c0 	movl   $0xc0127b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103e32:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e35:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e38:	89 50 04             	mov    %edx,0x4(%eax)
c0103e3b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e3e:	8b 50 04             	mov    0x4(%eax),%edx
c0103e41:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103e44:	89 10                	mov    %edx,(%eax)
c0103e46:	c7 45 b0 18 7b 12 c0 	movl   $0xc0127b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103e4d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e50:	8b 40 04             	mov    0x4(%eax),%eax
c0103e53:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103e56:	0f 94 c0             	sete   %al
c0103e59:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103e5c:	85 c0                	test   %eax,%eax
c0103e5e:	75 24                	jne    c0103e84 <default_check+0x1d0>
c0103e60:	c7 44 24 0c 8f a6 10 	movl   $0xc010a68f,0xc(%esp)
c0103e67:	c0 
c0103e68:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103e6f:	c0 
c0103e70:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0103e77:	00 
c0103e78:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103e7f:	e8 59 ce ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103e84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e8b:	e8 d1 0e 00 00       	call   c0104d61 <alloc_pages>
c0103e90:	85 c0                	test   %eax,%eax
c0103e92:	74 24                	je     c0103eb8 <default_check+0x204>
c0103e94:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103e9b:	c0 
c0103e9c:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ea3:	c0 
c0103ea4:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103eab:	00 
c0103eac:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103eb3:	e8 25 ce ff ff       	call   c0100cdd <__panic>

    unsigned int nr_free_store = nr_free;
c0103eb8:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0103ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103ec0:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0103ec7:	00 00 00 

    free_pages(p0 + 2, 3);
c0103eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ecd:	83 c0 40             	add    $0x40,%eax
c0103ed0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103ed7:	00 
c0103ed8:	89 04 24             	mov    %eax,(%esp)
c0103edb:	e8 ec 0e 00 00       	call   c0104dcc <free_pages>
    assert(alloc_pages(4) == NULL);
c0103ee0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103ee7:	e8 75 0e 00 00       	call   c0104d61 <alloc_pages>
c0103eec:	85 c0                	test   %eax,%eax
c0103eee:	74 24                	je     c0103f14 <default_check+0x260>
c0103ef0:	c7 44 24 0c 4c a7 10 	movl   $0xc010a74c,0xc(%esp)
c0103ef7:	c0 
c0103ef8:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103eff:	c0 
c0103f00:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0103f07:	00 
c0103f08:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103f0f:	e8 c9 cd ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0103f14:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f17:	83 c0 40             	add    $0x40,%eax
c0103f1a:	83 c0 04             	add    $0x4,%eax
c0103f1d:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0103f24:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f27:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f2a:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103f2d:	0f a3 10             	bt     %edx,(%eax)
c0103f30:	19 c0                	sbb    %eax,%eax
c0103f32:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0103f35:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103f39:	0f 95 c0             	setne  %al
c0103f3c:	0f b6 c0             	movzbl %al,%eax
c0103f3f:	85 c0                	test   %eax,%eax
c0103f41:	74 0e                	je     c0103f51 <default_check+0x29d>
c0103f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f46:	83 c0 40             	add    $0x40,%eax
c0103f49:	8b 40 08             	mov    0x8(%eax),%eax
c0103f4c:	83 f8 03             	cmp    $0x3,%eax
c0103f4f:	74 24                	je     c0103f75 <default_check+0x2c1>
c0103f51:	c7 44 24 0c 64 a7 10 	movl   $0xc010a764,0xc(%esp)
c0103f58:	c0 
c0103f59:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103f60:	c0 
c0103f61:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103f68:	00 
c0103f69:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103f70:	e8 68 cd ff ff       	call   c0100cdd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103f75:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103f7c:	e8 e0 0d 00 00       	call   c0104d61 <alloc_pages>
c0103f81:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103f84:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103f88:	75 24                	jne    c0103fae <default_check+0x2fa>
c0103f8a:	c7 44 24 0c 90 a7 10 	movl   $0xc010a790,0xc(%esp)
c0103f91:	c0 
c0103f92:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103f99:	c0 
c0103f9a:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0103fa1:	00 
c0103fa2:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103fa9:	e8 2f cd ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c0103fae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fb5:	e8 a7 0d 00 00       	call   c0104d61 <alloc_pages>
c0103fba:	85 c0                	test   %eax,%eax
c0103fbc:	74 24                	je     c0103fe2 <default_check+0x32e>
c0103fbe:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c0103fc5:	c0 
c0103fc6:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103fcd:	c0 
c0103fce:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0103fd5:	00 
c0103fd6:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0103fdd:	e8 fb cc ff ff       	call   c0100cdd <__panic>
    assert(p0 + 2 == p1);
c0103fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103fe5:	83 c0 40             	add    $0x40,%eax
c0103fe8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103feb:	74 24                	je     c0104011 <default_check+0x35d>
c0103fed:	c7 44 24 0c ae a7 10 	movl   $0xc010a7ae,0xc(%esp)
c0103ff4:	c0 
c0103ff5:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0103ffc:	c0 
c0103ffd:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104004:	00 
c0104005:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010400c:	e8 cc cc ff ff       	call   c0100cdd <__panic>

    p2 = p0 + 1;
c0104011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104014:	83 c0 20             	add    $0x20,%eax
c0104017:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010401a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104021:	00 
c0104022:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104025:	89 04 24             	mov    %eax,(%esp)
c0104028:	e8 9f 0d 00 00       	call   c0104dcc <free_pages>
    free_pages(p1, 3);
c010402d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104034:	00 
c0104035:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104038:	89 04 24             	mov    %eax,(%esp)
c010403b:	e8 8c 0d 00 00       	call   c0104dcc <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0104040:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104043:	83 c0 04             	add    $0x4,%eax
c0104046:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c010404d:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104050:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104053:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104056:	0f a3 10             	bt     %edx,(%eax)
c0104059:	19 c0                	sbb    %eax,%eax
c010405b:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c010405e:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104062:	0f 95 c0             	setne  %al
c0104065:	0f b6 c0             	movzbl %al,%eax
c0104068:	85 c0                	test   %eax,%eax
c010406a:	74 0b                	je     c0104077 <default_check+0x3c3>
c010406c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010406f:	8b 40 08             	mov    0x8(%eax),%eax
c0104072:	83 f8 01             	cmp    $0x1,%eax
c0104075:	74 24                	je     c010409b <default_check+0x3e7>
c0104077:	c7 44 24 0c bc a7 10 	movl   $0xc010a7bc,0xc(%esp)
c010407e:	c0 
c010407f:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104086:	c0 
c0104087:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c010408e:	00 
c010408f:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104096:	e8 42 cc ff ff       	call   c0100cdd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010409b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010409e:	83 c0 04             	add    $0x4,%eax
c01040a1:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01040a8:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01040ab:	8b 45 90             	mov    -0x70(%ebp),%eax
c01040ae:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01040b1:	0f a3 10             	bt     %edx,(%eax)
c01040b4:	19 c0                	sbb    %eax,%eax
c01040b6:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01040b9:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01040bd:	0f 95 c0             	setne  %al
c01040c0:	0f b6 c0             	movzbl %al,%eax
c01040c3:	85 c0                	test   %eax,%eax
c01040c5:	74 0b                	je     c01040d2 <default_check+0x41e>
c01040c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01040ca:	8b 40 08             	mov    0x8(%eax),%eax
c01040cd:	83 f8 03             	cmp    $0x3,%eax
c01040d0:	74 24                	je     c01040f6 <default_check+0x442>
c01040d2:	c7 44 24 0c e4 a7 10 	movl   $0xc010a7e4,0xc(%esp)
c01040d9:	c0 
c01040da:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01040e1:	c0 
c01040e2:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c01040e9:	00 
c01040ea:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01040f1:	e8 e7 cb ff ff       	call   c0100cdd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01040f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040fd:	e8 5f 0c 00 00       	call   c0104d61 <alloc_pages>
c0104102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104105:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104108:	83 e8 20             	sub    $0x20,%eax
c010410b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010410e:	74 24                	je     c0104134 <default_check+0x480>
c0104110:	c7 44 24 0c 0a a8 10 	movl   $0xc010a80a,0xc(%esp)
c0104117:	c0 
c0104118:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c010411f:	c0 
c0104120:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104127:	00 
c0104128:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c010412f:	e8 a9 cb ff ff       	call   c0100cdd <__panic>
    free_page(p0);
c0104134:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010413b:	00 
c010413c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010413f:	89 04 24             	mov    %eax,(%esp)
c0104142:	e8 85 0c 00 00       	call   c0104dcc <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104147:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c010414e:	e8 0e 0c 00 00       	call   c0104d61 <alloc_pages>
c0104153:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104156:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104159:	83 c0 20             	add    $0x20,%eax
c010415c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010415f:	74 24                	je     c0104185 <default_check+0x4d1>
c0104161:	c7 44 24 0c 28 a8 10 	movl   $0xc010a828,0xc(%esp)
c0104168:	c0 
c0104169:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104170:	c0 
c0104171:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c0104178:	00 
c0104179:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104180:	e8 58 cb ff ff       	call   c0100cdd <__panic>

    free_pages(p0, 2);
c0104185:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010418c:	00 
c010418d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104190:	89 04 24             	mov    %eax,(%esp)
c0104193:	e8 34 0c 00 00       	call   c0104dcc <free_pages>
    free_page(p2);
c0104198:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010419f:	00 
c01041a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01041a3:	89 04 24             	mov    %eax,(%esp)
c01041a6:	e8 21 0c 00 00       	call   c0104dcc <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01041ab:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01041b2:	e8 aa 0b 00 00       	call   c0104d61 <alloc_pages>
c01041b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041ba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041be:	75 24                	jne    c01041e4 <default_check+0x530>
c01041c0:	c7 44 24 0c 48 a8 10 	movl   $0xc010a848,0xc(%esp)
c01041c7:	c0 
c01041c8:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01041cf:	c0 
c01041d0:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01041d7:	00 
c01041d8:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01041df:	e8 f9 ca ff ff       	call   c0100cdd <__panic>
    assert(alloc_page() == NULL);
c01041e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01041eb:	e8 71 0b 00 00       	call   c0104d61 <alloc_pages>
c01041f0:	85 c0                	test   %eax,%eax
c01041f2:	74 24                	je     c0104218 <default_check+0x564>
c01041f4:	c7 44 24 0c a6 a6 10 	movl   $0xc010a6a6,0xc(%esp)
c01041fb:	c0 
c01041fc:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104203:	c0 
c0104204:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c010420b:	00 
c010420c:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104213:	e8 c5 ca ff ff       	call   c0100cdd <__panic>

    assert(nr_free == 0);
c0104218:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c010421d:	85 c0                	test   %eax,%eax
c010421f:	74 24                	je     c0104245 <default_check+0x591>
c0104221:	c7 44 24 0c f9 a6 10 	movl   $0xc010a6f9,0xc(%esp)
c0104228:	c0 
c0104229:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c0104230:	c0 
c0104231:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104238:	00 
c0104239:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c0104240:	e8 98 ca ff ff       	call   c0100cdd <__panic>
    nr_free = nr_free_store;
c0104245:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104248:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20

    free_list = free_list_store;
c010424d:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104250:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104253:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c0104258:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c
    free_pages(p0, 5);
c010425e:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104265:	00 
c0104266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104269:	89 04 24             	mov    %eax,(%esp)
c010426c:	e8 5b 0b 00 00       	call   c0104dcc <free_pages>

    le = &free_list;
c0104271:	c7 45 ec 18 7b 12 c0 	movl   $0xc0127b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104278:	eb 1d                	jmp    c0104297 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c010427a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010427d:	83 e8 0c             	sub    $0xc,%eax
c0104280:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104283:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104287:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010428a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010428d:	8b 40 08             	mov    0x8(%eax),%eax
c0104290:	29 c2                	sub    %eax,%edx
c0104292:	89 d0                	mov    %edx,%eax
c0104294:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104297:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010429a:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010429d:	8b 45 88             	mov    -0x78(%ebp),%eax
c01042a0:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01042a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01042a6:	81 7d ec 18 7b 12 c0 	cmpl   $0xc0127b18,-0x14(%ebp)
c01042ad:	75 cb                	jne    c010427a <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01042af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042b3:	74 24                	je     c01042d9 <default_check+0x625>
c01042b5:	c7 44 24 0c 66 a8 10 	movl   $0xc010a866,0xc(%esp)
c01042bc:	c0 
c01042bd:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01042c4:	c0 
c01042c5:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01042cc:	00 
c01042cd:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01042d4:	e8 04 ca ff ff       	call   c0100cdd <__panic>
    assert(total == 0);
c01042d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01042dd:	74 24                	je     c0104303 <default_check+0x64f>
c01042df:	c7 44 24 0c 71 a8 10 	movl   $0xc010a871,0xc(%esp)
c01042e6:	c0 
c01042e7:	c7 44 24 08 36 a5 10 	movl   $0xc010a536,0x8(%esp)
c01042ee:	c0 
c01042ef:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c01042f6:	00 
c01042f7:	c7 04 24 4b a5 10 c0 	movl   $0xc010a54b,(%esp)
c01042fe:	e8 da c9 ff ff       	call   c0100cdd <__panic>
}
c0104303:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104309:	5b                   	pop    %ebx
c010430a:	5d                   	pop    %ebp
c010430b:	c3                   	ret    

c010430c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010430c:	55                   	push   %ebp
c010430d:	89 e5                	mov    %esp,%ebp
c010430f:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104312:	9c                   	pushf  
c0104313:	58                   	pop    %eax
c0104314:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104317:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010431a:	25 00 02 00 00       	and    $0x200,%eax
c010431f:	85 c0                	test   %eax,%eax
c0104321:	74 0c                	je     c010432f <__intr_save+0x23>
        intr_disable();
c0104323:	e8 0d dc ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104328:	b8 01 00 00 00       	mov    $0x1,%eax
c010432d:	eb 05                	jmp    c0104334 <__intr_save+0x28>
    }
    return 0;
c010432f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104334:	c9                   	leave  
c0104335:	c3                   	ret    

c0104336 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104336:	55                   	push   %ebp
c0104337:	89 e5                	mov    %esp,%ebp
c0104339:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010433c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104340:	74 05                	je     c0104347 <__intr_restore+0x11>
        intr_enable();
c0104342:	e8 e8 db ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104347:	c9                   	leave  
c0104348:	c3                   	ret    

c0104349 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104349:	55                   	push   %ebp
c010434a:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010434c:	8b 55 08             	mov    0x8(%ebp),%edx
c010434f:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104354:	29 c2                	sub    %eax,%edx
c0104356:	89 d0                	mov    %edx,%eax
c0104358:	c1 f8 05             	sar    $0x5,%eax
}
c010435b:	5d                   	pop    %ebp
c010435c:	c3                   	ret    

c010435d <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010435d:	55                   	push   %ebp
c010435e:	89 e5                	mov    %esp,%ebp
c0104360:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104363:	8b 45 08             	mov    0x8(%ebp),%eax
c0104366:	89 04 24             	mov    %eax,(%esp)
c0104369:	e8 db ff ff ff       	call   c0104349 <page2ppn>
c010436e:	c1 e0 0c             	shl    $0xc,%eax
}
c0104371:	c9                   	leave  
c0104372:	c3                   	ret    

c0104373 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104373:	55                   	push   %ebp
c0104374:	89 e5                	mov    %esp,%ebp
c0104376:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104379:	8b 45 08             	mov    0x8(%ebp),%eax
c010437c:	c1 e8 0c             	shr    $0xc,%eax
c010437f:	89 c2                	mov    %eax,%edx
c0104381:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104386:	39 c2                	cmp    %eax,%edx
c0104388:	72 1c                	jb     c01043a6 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010438a:	c7 44 24 08 ac a8 10 	movl   $0xc010a8ac,0x8(%esp)
c0104391:	c0 
c0104392:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104399:	00 
c010439a:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c01043a1:	e8 37 c9 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01043a6:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01043ab:	8b 55 08             	mov    0x8(%ebp),%edx
c01043ae:	c1 ea 0c             	shr    $0xc,%edx
c01043b1:	c1 e2 05             	shl    $0x5,%edx
c01043b4:	01 d0                	add    %edx,%eax
}
c01043b6:	c9                   	leave  
c01043b7:	c3                   	ret    

c01043b8 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01043b8:	55                   	push   %ebp
c01043b9:	89 e5                	mov    %esp,%ebp
c01043bb:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01043be:	8b 45 08             	mov    0x8(%ebp),%eax
c01043c1:	89 04 24             	mov    %eax,(%esp)
c01043c4:	e8 94 ff ff ff       	call   c010435d <page2pa>
c01043c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01043cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043cf:	c1 e8 0c             	shr    $0xc,%eax
c01043d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043d5:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01043da:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01043dd:	72 23                	jb     c0104402 <page2kva+0x4a>
c01043df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01043e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043e6:	c7 44 24 08 dc a8 10 	movl   $0xc010a8dc,0x8(%esp)
c01043ed:	c0 
c01043ee:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01043f5:	00 
c01043f6:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c01043fd:	e8 db c8 ff ff       	call   c0100cdd <__panic>
c0104402:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104405:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010440a:	c9                   	leave  
c010440b:	c3                   	ret    

c010440c <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010440c:	55                   	push   %ebp
c010440d:	89 e5                	mov    %esp,%ebp
c010440f:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104412:	8b 45 08             	mov    0x8(%ebp),%eax
c0104415:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104418:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010441f:	77 23                	ja     c0104444 <kva2page+0x38>
c0104421:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104424:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104428:	c7 44 24 08 00 a9 10 	movl   $0xc010a900,0x8(%esp)
c010442f:	c0 
c0104430:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0104437:	00 
c0104438:	c7 04 24 cb a8 10 c0 	movl   $0xc010a8cb,(%esp)
c010443f:	e8 99 c8 ff ff       	call   c0100cdd <__panic>
c0104444:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104447:	05 00 00 00 40       	add    $0x40000000,%eax
c010444c:	89 04 24             	mov    %eax,(%esp)
c010444f:	e8 1f ff ff ff       	call   c0104373 <pa2page>
}
c0104454:	c9                   	leave  
c0104455:	c3                   	ret    

c0104456 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104456:	55                   	push   %ebp
c0104457:	89 e5                	mov    %esp,%ebp
c0104459:	83 ec 28             	sub    $0x28,%esp
  struct Page * page = alloc_pages(1 << order);
c010445c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010445f:	ba 01 00 00 00       	mov    $0x1,%edx
c0104464:	89 c1                	mov    %eax,%ecx
c0104466:	d3 e2                	shl    %cl,%edx
c0104468:	89 d0                	mov    %edx,%eax
c010446a:	89 04 24             	mov    %eax,(%esp)
c010446d:	e8 ef 08 00 00       	call   c0104d61 <alloc_pages>
c0104472:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c0104475:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104479:	75 07                	jne    c0104482 <__slob_get_free_pages+0x2c>
    return NULL;
c010447b:	b8 00 00 00 00       	mov    $0x0,%eax
c0104480:	eb 0b                	jmp    c010448d <__slob_get_free_pages+0x37>
  return page2kva(page);
c0104482:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104485:	89 04 24             	mov    %eax,(%esp)
c0104488:	e8 2b ff ff ff       	call   c01043b8 <page2kva>
}
c010448d:	c9                   	leave  
c010448e:	c3                   	ret    

c010448f <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010448f:	55                   	push   %ebp
c0104490:	89 e5                	mov    %esp,%ebp
c0104492:	53                   	push   %ebx
c0104493:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104499:	ba 01 00 00 00       	mov    $0x1,%edx
c010449e:	89 c1                	mov    %eax,%ecx
c01044a0:	d3 e2                	shl    %cl,%edx
c01044a2:	89 d0                	mov    %edx,%eax
c01044a4:	89 c3                	mov    %eax,%ebx
c01044a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a9:	89 04 24             	mov    %eax,(%esp)
c01044ac:	e8 5b ff ff ff       	call   c010440c <kva2page>
c01044b1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01044b5:	89 04 24             	mov    %eax,(%esp)
c01044b8:	e8 0f 09 00 00       	call   c0104dcc <free_pages>
}
c01044bd:	83 c4 14             	add    $0x14,%esp
c01044c0:	5b                   	pop    %ebx
c01044c1:	5d                   	pop    %ebp
c01044c2:	c3                   	ret    

c01044c3 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c01044c3:	55                   	push   %ebp
c01044c4:	89 e5                	mov    %esp,%ebp
c01044c6:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c01044c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01044cc:	83 c0 08             	add    $0x8,%eax
c01044cf:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c01044d4:	76 24                	jbe    c01044fa <slob_alloc+0x37>
c01044d6:	c7 44 24 0c 24 a9 10 	movl   $0xc010a924,0xc(%esp)
c01044dd:	c0 
c01044de:	c7 44 24 08 43 a9 10 	movl   $0xc010a943,0x8(%esp)
c01044e5:	c0 
c01044e6:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01044ed:	00 
c01044ee:	c7 04 24 58 a9 10 c0 	movl   $0xc010a958,(%esp)
c01044f5:	e8 e3 c7 ff ff       	call   c0100cdd <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01044fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c0104501:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104508:	8b 45 08             	mov    0x8(%ebp),%eax
c010450b:	83 c0 07             	add    $0x7,%eax
c010450e:	c1 e8 03             	shr    $0x3,%eax
c0104511:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104514:	e8 f3 fd ff ff       	call   c010430c <__intr_save>
c0104519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c010451c:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c0104521:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104524:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104527:	8b 40 04             	mov    0x4(%eax),%eax
c010452a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c010452d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104531:	74 25                	je     c0104558 <slob_alloc+0x95>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c0104533:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104536:	8b 45 10             	mov    0x10(%ebp),%eax
c0104539:	01 d0                	add    %edx,%eax
c010453b:	8d 50 ff             	lea    -0x1(%eax),%edx
c010453e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104541:	f7 d8                	neg    %eax
c0104543:	21 d0                	and    %edx,%eax
c0104545:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104548:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010454b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010454e:	29 c2                	sub    %eax,%edx
c0104550:	89 d0                	mov    %edx,%eax
c0104552:	c1 f8 03             	sar    $0x3,%eax
c0104555:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c0104558:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010455b:	8b 00                	mov    (%eax),%eax
c010455d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104560:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104563:	01 ca                	add    %ecx,%edx
c0104565:	39 d0                	cmp    %edx,%eax
c0104567:	0f 8c aa 00 00 00    	jl     c0104617 <slob_alloc+0x154>
			if (delta) { /* need to fragment head to align? */
c010456d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104571:	74 38                	je     c01045ab <slob_alloc+0xe8>
				aligned->units = cur->units - delta;
c0104573:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104576:	8b 00                	mov    (%eax),%eax
c0104578:	2b 45 e8             	sub    -0x18(%ebp),%eax
c010457b:	89 c2                	mov    %eax,%edx
c010457d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104580:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104582:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104585:	8b 50 04             	mov    0x4(%eax),%edx
c0104588:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010458b:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c010458e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104591:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104594:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104597:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010459a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010459d:	89 10                	mov    %edx,(%eax)
				prev = cur;
c010459f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01045a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01045ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045ae:	8b 00                	mov    (%eax),%eax
c01045b0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01045b3:	75 0e                	jne    c01045c3 <slob_alloc+0x100>
				prev->next = cur->next; /* unlink */
c01045b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045b8:	8b 50 04             	mov    0x4(%eax),%edx
c01045bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045be:	89 50 04             	mov    %edx,0x4(%eax)
c01045c1:	eb 3c                	jmp    c01045ff <slob_alloc+0x13c>
			else { /* fragment */
				prev->next = cur + units;
c01045c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01045cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045d0:	01 c2                	add    %eax,%edx
c01045d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d5:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c01045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045db:	8b 40 04             	mov    0x4(%eax),%eax
c01045de:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045e1:	8b 12                	mov    (%edx),%edx
c01045e3:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01045e6:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01045e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045eb:	8b 40 04             	mov    0x4(%eax),%eax
c01045ee:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01045f1:	8b 52 04             	mov    0x4(%edx),%edx
c01045f4:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01045f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045fa:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045fd:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c01045ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104602:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010460a:	89 04 24             	mov    %eax,(%esp)
c010460d:	e8 24 fd ff ff       	call   c0104336 <__intr_restore>
			return cur;
c0104612:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104615:	eb 7f                	jmp    c0104696 <slob_alloc+0x1d3>
		}
		if (cur == slobfree) {
c0104617:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010461c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010461f:	75 61                	jne    c0104682 <slob_alloc+0x1bf>
			spin_unlock_irqrestore(&slob_lock, flags);
c0104621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104624:	89 04 24             	mov    %eax,(%esp)
c0104627:	e8 0a fd ff ff       	call   c0104336 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c010462c:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104633:	75 07                	jne    c010463c <slob_alloc+0x179>
				return 0;
c0104635:	b8 00 00 00 00       	mov    $0x0,%eax
c010463a:	eb 5a                	jmp    c0104696 <slob_alloc+0x1d3>

			cur = (slob_t *)__slob_get_free_page(gfp);
c010463c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104643:	00 
c0104644:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104647:	89 04 24             	mov    %eax,(%esp)
c010464a:	e8 07 fe ff ff       	call   c0104456 <__slob_get_free_pages>
c010464f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104656:	75 07                	jne    c010465f <slob_alloc+0x19c>
				return 0;
c0104658:	b8 00 00 00 00       	mov    $0x0,%eax
c010465d:	eb 37                	jmp    c0104696 <slob_alloc+0x1d3>

			slob_free(cur, PAGE_SIZE);
c010465f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104666:	00 
c0104667:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010466a:	89 04 24             	mov    %eax,(%esp)
c010466d:	e8 26 00 00 00       	call   c0104698 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104672:	e8 95 fc ff ff       	call   c010430c <__intr_save>
c0104677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c010467a:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c010467f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104682:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104685:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104688:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010468b:	8b 40 04             	mov    0x4(%eax),%eax
c010468e:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104691:	e9 97 fe ff ff       	jmp    c010452d <slob_alloc+0x6a>
}
c0104696:	c9                   	leave  
c0104697:	c3                   	ret    

c0104698 <slob_free>:

static void slob_free(void *block, int size)
{
c0104698:	55                   	push   %ebp
c0104699:	89 e5                	mov    %esp,%ebp
c010469b:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c010469e:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01046a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01046a8:	75 05                	jne    c01046af <slob_free+0x17>
		return;
c01046aa:	e9 ff 00 00 00       	jmp    c01047ae <slob_free+0x116>

	if (size)
c01046af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01046b3:	74 10                	je     c01046c5 <slob_free+0x2d>
		b->units = SLOB_UNITS(size);
c01046b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b8:	83 c0 07             	add    $0x7,%eax
c01046bb:	c1 e8 03             	shr    $0x3,%eax
c01046be:	89 c2                	mov    %eax,%edx
c01046c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c3:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c01046c5:	e8 42 fc ff ff       	call   c010430c <__intr_save>
c01046ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01046cd:	a1 08 4a 12 c0       	mov    0xc0124a08,%eax
c01046d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046d5:	eb 27                	jmp    c01046fe <slob_free+0x66>
		if (cur >= cur->next && (b > cur || b < cur->next))
c01046d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046da:	8b 40 04             	mov    0x4(%eax),%eax
c01046dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046e0:	77 13                	ja     c01046f5 <slob_free+0x5d>
c01046e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01046e8:	77 27                	ja     c0104711 <slob_free+0x79>
c01046ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ed:	8b 40 04             	mov    0x4(%eax),%eax
c01046f0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01046f3:	77 1c                	ja     c0104711 <slob_free+0x79>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c01046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f8:	8b 40 04             	mov    0x4(%eax),%eax
c01046fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104701:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104704:	76 d1                	jbe    c01046d7 <slob_free+0x3f>
c0104706:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104709:	8b 40 04             	mov    0x4(%eax),%eax
c010470c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010470f:	76 c6                	jbe    c01046d7 <slob_free+0x3f>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104711:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104714:	8b 00                	mov    (%eax),%eax
c0104716:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010471d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104720:	01 c2                	add    %eax,%edx
c0104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104725:	8b 40 04             	mov    0x4(%eax),%eax
c0104728:	39 c2                	cmp    %eax,%edx
c010472a:	75 25                	jne    c0104751 <slob_free+0xb9>
		b->units += cur->next->units;
c010472c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010472f:	8b 10                	mov    (%eax),%edx
c0104731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104734:	8b 40 04             	mov    0x4(%eax),%eax
c0104737:	8b 00                	mov    (%eax),%eax
c0104739:	01 c2                	add    %eax,%edx
c010473b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010473e:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104740:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104743:	8b 40 04             	mov    0x4(%eax),%eax
c0104746:	8b 50 04             	mov    0x4(%eax),%edx
c0104749:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010474c:	89 50 04             	mov    %edx,0x4(%eax)
c010474f:	eb 0c                	jmp    c010475d <slob_free+0xc5>
	} else
		b->next = cur->next;
c0104751:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104754:	8b 50 04             	mov    0x4(%eax),%edx
c0104757:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475a:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c010475d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104760:	8b 00                	mov    (%eax),%eax
c0104762:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0104769:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010476c:	01 d0                	add    %edx,%eax
c010476e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104771:	75 1f                	jne    c0104792 <slob_free+0xfa>
		cur->units += b->units;
c0104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104776:	8b 10                	mov    (%eax),%edx
c0104778:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010477b:	8b 00                	mov    (%eax),%eax
c010477d:	01 c2                	add    %eax,%edx
c010477f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104782:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104784:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104787:	8b 50 04             	mov    0x4(%eax),%edx
c010478a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478d:	89 50 04             	mov    %edx,0x4(%eax)
c0104790:	eb 09                	jmp    c010479b <slob_free+0x103>
	} else
		cur->next = b;
c0104792:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104795:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104798:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c010479b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010479e:	a3 08 4a 12 c0       	mov    %eax,0xc0124a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01047a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01047a6:	89 04 24             	mov    %eax,(%esp)
c01047a9:	e8 88 fb ff ff       	call   c0104336 <__intr_restore>
}
c01047ae:	c9                   	leave  
c01047af:	c3                   	ret    

c01047b0 <slob_init>:



void
slob_init(void) {
c01047b0:	55                   	push   %ebp
c01047b1:	89 e5                	mov    %esp,%ebp
c01047b3:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01047b6:	c7 04 24 6a a9 10 c0 	movl   $0xc010a96a,(%esp)
c01047bd:	e8 91 bb ff ff       	call   c0100353 <cprintf>
}
c01047c2:	c9                   	leave  
c01047c3:	c3                   	ret    

c01047c4 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c01047c4:	55                   	push   %ebp
c01047c5:	89 e5                	mov    %esp,%ebp
c01047c7:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c01047ca:	e8 e1 ff ff ff       	call   c01047b0 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c01047cf:	c7 04 24 7e a9 10 c0 	movl   $0xc010a97e,(%esp)
c01047d6:	e8 78 bb ff ff       	call   c0100353 <cprintf>
}
c01047db:	c9                   	leave  
c01047dc:	c3                   	ret    

c01047dd <slob_allocated>:

size_t
slob_allocated(void) {
c01047dd:	55                   	push   %ebp
c01047de:	89 e5                	mov    %esp,%ebp
  return 0;
c01047e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01047e5:	5d                   	pop    %ebp
c01047e6:	c3                   	ret    

c01047e7 <kallocated>:

size_t
kallocated(void) {
c01047e7:	55                   	push   %ebp
c01047e8:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c01047ea:	e8 ee ff ff ff       	call   c01047dd <slob_allocated>
}
c01047ef:	5d                   	pop    %ebp
c01047f0:	c3                   	ret    

c01047f1 <find_order>:

static int find_order(int size)
{
c01047f1:	55                   	push   %ebp
c01047f2:	89 e5                	mov    %esp,%ebp
c01047f4:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c01047f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c01047fe:	eb 07                	jmp    c0104807 <find_order+0x16>
		order++;
c0104800:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104804:	d1 7d 08             	sarl   0x8(%ebp)
c0104807:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010480e:	7f f0                	jg     c0104800 <find_order+0xf>
		order++;
	return order;
c0104810:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104813:	c9                   	leave  
c0104814:	c3                   	ret    

c0104815 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104815:	55                   	push   %ebp
c0104816:	89 e5                	mov    %esp,%ebp
c0104818:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c010481b:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104822:	77 38                	ja     c010485c <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104824:	8b 45 08             	mov    0x8(%ebp),%eax
c0104827:	8d 50 08             	lea    0x8(%eax),%edx
c010482a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104831:	00 
c0104832:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104835:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104839:	89 14 24             	mov    %edx,(%esp)
c010483c:	e8 82 fc ff ff       	call   c01044c3 <slob_alloc>
c0104841:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104848:	74 08                	je     c0104852 <__kmalloc+0x3d>
c010484a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010484d:	83 c0 08             	add    $0x8,%eax
c0104850:	eb 05                	jmp    c0104857 <__kmalloc+0x42>
c0104852:	b8 00 00 00 00       	mov    $0x0,%eax
c0104857:	e9 a6 00 00 00       	jmp    c0104902 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c010485c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104863:	00 
c0104864:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104867:	89 44 24 04          	mov    %eax,0x4(%esp)
c010486b:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104872:	e8 4c fc ff ff       	call   c01044c3 <slob_alloc>
c0104877:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c010487a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010487e:	75 07                	jne    c0104887 <__kmalloc+0x72>
		return 0;
c0104880:	b8 00 00 00 00       	mov    $0x0,%eax
c0104885:	eb 7b                	jmp    c0104902 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104887:	8b 45 08             	mov    0x8(%ebp),%eax
c010488a:	89 04 24             	mov    %eax,(%esp)
c010488d:	e8 5f ff ff ff       	call   c01047f1 <find_order>
c0104892:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104895:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104897:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010489a:	8b 00                	mov    (%eax),%eax
c010489c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048a3:	89 04 24             	mov    %eax,(%esp)
c01048a6:	e8 ab fb ff ff       	call   c0104456 <__slob_get_free_pages>
c01048ab:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048ae:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c01048b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048b4:	8b 40 04             	mov    0x4(%eax),%eax
c01048b7:	85 c0                	test   %eax,%eax
c01048b9:	74 2f                	je     c01048ea <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c01048bb:	e8 4c fa ff ff       	call   c010430c <__intr_save>
c01048c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c01048c3:	8b 15 24 5a 12 c0    	mov    0xc0125a24,%edx
c01048c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048cc:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c01048cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048d2:	a3 24 5a 12 c0       	mov    %eax,0xc0125a24
		spin_unlock_irqrestore(&block_lock, flags);
c01048d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048da:	89 04 24             	mov    %eax,(%esp)
c01048dd:	e8 54 fa ff ff       	call   c0104336 <__intr_restore>
		return bb->pages;
c01048e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048e5:	8b 40 04             	mov    0x4(%eax),%eax
c01048e8:	eb 18                	jmp    c0104902 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c01048ea:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c01048f1:	00 
c01048f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048f5:	89 04 24             	mov    %eax,(%esp)
c01048f8:	e8 9b fd ff ff       	call   c0104698 <slob_free>
	return 0;
c01048fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104902:	c9                   	leave  
c0104903:	c3                   	ret    

c0104904 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104904:	55                   	push   %ebp
c0104905:	89 e5                	mov    %esp,%ebp
c0104907:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c010490a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104911:	00 
c0104912:	8b 45 08             	mov    0x8(%ebp),%eax
c0104915:	89 04 24             	mov    %eax,(%esp)
c0104918:	e8 f8 fe ff ff       	call   c0104815 <__kmalloc>
}
c010491d:	c9                   	leave  
c010491e:	c3                   	ret    

c010491f <kfree>:


void kfree(void *block)
{
c010491f:	55                   	push   %ebp
c0104920:	89 e5                	mov    %esp,%ebp
c0104922:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104925:	c7 45 f0 24 5a 12 c0 	movl   $0xc0125a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c010492c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104930:	75 05                	jne    c0104937 <kfree+0x18>
		return;
c0104932:	e9 a2 00 00 00       	jmp    c01049d9 <kfree+0xba>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104937:	8b 45 08             	mov    0x8(%ebp),%eax
c010493a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010493f:	85 c0                	test   %eax,%eax
c0104941:	75 7f                	jne    c01049c2 <kfree+0xa3>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104943:	e8 c4 f9 ff ff       	call   c010430c <__intr_save>
c0104948:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010494b:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104950:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104953:	eb 5c                	jmp    c01049b1 <kfree+0x92>
			if (bb->pages == block) {
c0104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104958:	8b 40 04             	mov    0x4(%eax),%eax
c010495b:	3b 45 08             	cmp    0x8(%ebp),%eax
c010495e:	75 3f                	jne    c010499f <kfree+0x80>
				*last = bb->next;
c0104960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104963:	8b 50 08             	mov    0x8(%eax),%edx
c0104966:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104969:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c010496b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496e:	89 04 24             	mov    %eax,(%esp)
c0104971:	e8 c0 f9 ff ff       	call   c0104336 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104976:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104979:	8b 10                	mov    (%eax),%edx
c010497b:	8b 45 08             	mov    0x8(%ebp),%eax
c010497e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104982:	89 04 24             	mov    %eax,(%esp)
c0104985:	e8 05 fb ff ff       	call   c010448f <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c010498a:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104991:	00 
c0104992:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104995:	89 04 24             	mov    %eax,(%esp)
c0104998:	e8 fb fc ff ff       	call   c0104698 <slob_free>
				return;
c010499d:	eb 3a                	jmp    c01049d9 <kfree+0xba>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c010499f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a2:	83 c0 08             	add    $0x8,%eax
c01049a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01049a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049ab:	8b 40 08             	mov    0x8(%eax),%eax
c01049ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01049b5:	75 9e                	jne    c0104955 <kfree+0x36>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c01049b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ba:	89 04 24             	mov    %eax,(%esp)
c01049bd:	e8 74 f9 ff ff       	call   c0104336 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c01049c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c5:	83 e8 08             	sub    $0x8,%eax
c01049c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01049cf:	00 
c01049d0:	89 04 24             	mov    %eax,(%esp)
c01049d3:	e8 c0 fc ff ff       	call   c0104698 <slob_free>
	return;
c01049d8:	90                   	nop
}
c01049d9:	c9                   	leave  
c01049da:	c3                   	ret    

c01049db <ksize>:


unsigned int ksize(const void *block)
{
c01049db:	55                   	push   %ebp
c01049dc:	89 e5                	mov    %esp,%ebp
c01049de:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c01049e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01049e5:	75 07                	jne    c01049ee <ksize+0x13>
		return 0;
c01049e7:	b8 00 00 00 00       	mov    $0x0,%eax
c01049ec:	eb 6b                	jmp    c0104a59 <ksize+0x7e>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c01049ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01049f1:	25 ff 0f 00 00       	and    $0xfff,%eax
c01049f6:	85 c0                	test   %eax,%eax
c01049f8:	75 54                	jne    c0104a4e <ksize+0x73>
		spin_lock_irqsave(&block_lock, flags);
c01049fa:	e8 0d f9 ff ff       	call   c010430c <__intr_save>
c01049ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104a02:	a1 24 5a 12 c0       	mov    0xc0125a24,%eax
c0104a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a0a:	eb 31                	jmp    c0104a3d <ksize+0x62>
			if (bb->pages == block) {
c0104a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a0f:	8b 40 04             	mov    0x4(%eax),%eax
c0104a12:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a15:	75 1d                	jne    c0104a34 <ksize+0x59>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104a17:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a1a:	89 04 24             	mov    %eax,(%esp)
c0104a1d:	e8 14 f9 ff ff       	call   c0104336 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a25:	8b 00                	mov    (%eax),%eax
c0104a27:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104a2c:	89 c1                	mov    %eax,%ecx
c0104a2e:	d3 e2                	shl    %cl,%edx
c0104a30:	89 d0                	mov    %edx,%eax
c0104a32:	eb 25                	jmp    c0104a59 <ksize+0x7e>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a37:	8b 40 08             	mov    0x8(%eax),%eax
c0104a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a41:	75 c9                	jne    c0104a0c <ksize+0x31>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a46:	89 04 24             	mov    %eax,(%esp)
c0104a49:	e8 e8 f8 ff ff       	call   c0104336 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104a4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a51:	83 e8 08             	sub    $0x8,%eax
c0104a54:	8b 00                	mov    (%eax),%eax
c0104a56:	c1 e0 03             	shl    $0x3,%eax
}
c0104a59:	c9                   	leave  
c0104a5a:	c3                   	ret    

c0104a5b <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104a5b:	55                   	push   %ebp
c0104a5c:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104a5e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104a61:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104a66:	29 c2                	sub    %eax,%edx
c0104a68:	89 d0                	mov    %edx,%eax
c0104a6a:	c1 f8 05             	sar    $0x5,%eax
}
c0104a6d:	5d                   	pop    %ebp
c0104a6e:	c3                   	ret    

c0104a6f <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104a6f:	55                   	push   %ebp
c0104a70:	89 e5                	mov    %esp,%ebp
c0104a72:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a78:	89 04 24             	mov    %eax,(%esp)
c0104a7b:	e8 db ff ff ff       	call   c0104a5b <page2ppn>
c0104a80:	c1 e0 0c             	shl    $0xc,%eax
}
c0104a83:	c9                   	leave  
c0104a84:	c3                   	ret    

c0104a85 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104a85:	55                   	push   %ebp
c0104a86:	89 e5                	mov    %esp,%ebp
c0104a88:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a8e:	c1 e8 0c             	shr    $0xc,%eax
c0104a91:	89 c2                	mov    %eax,%edx
c0104a93:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104a98:	39 c2                	cmp    %eax,%edx
c0104a9a:	72 1c                	jb     c0104ab8 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104a9c:	c7 44 24 08 9c a9 10 	movl   $0xc010a99c,0x8(%esp)
c0104aa3:	c0 
c0104aa4:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104aab:	00 
c0104aac:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104ab3:	e8 25 c2 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0104ab8:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104abd:	8b 55 08             	mov    0x8(%ebp),%edx
c0104ac0:	c1 ea 0c             	shr    $0xc,%edx
c0104ac3:	c1 e2 05             	shl    $0x5,%edx
c0104ac6:	01 d0                	add    %edx,%eax
}
c0104ac8:	c9                   	leave  
c0104ac9:	c3                   	ret    

c0104aca <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104aca:	55                   	push   %ebp
c0104acb:	89 e5                	mov    %esp,%ebp
c0104acd:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104ad0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ad3:	89 04 24             	mov    %eax,(%esp)
c0104ad6:	e8 94 ff ff ff       	call   c0104a6f <page2pa>
c0104adb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ade:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae1:	c1 e8 0c             	shr    $0xc,%eax
c0104ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ae7:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0104aec:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104aef:	72 23                	jb     c0104b14 <page2kva+0x4a>
c0104af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104af4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104af8:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0104aff:	c0 
c0104b00:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104b07:	00 
c0104b08:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104b0f:	e8 c9 c1 ff ff       	call   c0100cdd <__panic>
c0104b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b17:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104b1c:	c9                   	leave  
c0104b1d:	c3                   	ret    

c0104b1e <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104b1e:	55                   	push   %ebp
c0104b1f:	89 e5                	mov    %esp,%ebp
c0104b21:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104b24:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b27:	83 e0 01             	and    $0x1,%eax
c0104b2a:	85 c0                	test   %eax,%eax
c0104b2c:	75 1c                	jne    c0104b4a <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104b2e:	c7 44 24 08 f0 a9 10 	movl   $0xc010a9f0,0x8(%esp)
c0104b35:	c0 
c0104b36:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104b3d:	00 
c0104b3e:	c7 04 24 bb a9 10 c0 	movl   $0xc010a9bb,(%esp)
c0104b45:	e8 93 c1 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b52:	89 04 24             	mov    %eax,(%esp)
c0104b55:	e8 2b ff ff ff       	call   c0104a85 <pa2page>
}
c0104b5a:	c9                   	leave  
c0104b5b:	c3                   	ret    

c0104b5c <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0104b5c:	55                   	push   %ebp
c0104b5d:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104b5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b62:	8b 00                	mov    (%eax),%eax
}
c0104b64:	5d                   	pop    %ebp
c0104b65:	c3                   	ret    

c0104b66 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104b66:	55                   	push   %ebp
c0104b67:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b6c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104b6f:	89 10                	mov    %edx,(%eax)
}
c0104b71:	5d                   	pop    %ebp
c0104b72:	c3                   	ret    

c0104b73 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104b73:	55                   	push   %ebp
c0104b74:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104b76:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b79:	8b 00                	mov    (%eax),%eax
c0104b7b:	8d 50 01             	lea    0x1(%eax),%edx
c0104b7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b81:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b86:	8b 00                	mov    (%eax),%eax
}
c0104b88:	5d                   	pop    %ebp
c0104b89:	c3                   	ret    

c0104b8a <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104b8a:	55                   	push   %ebp
c0104b8b:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104b8d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b90:	8b 00                	mov    (%eax),%eax
c0104b92:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b98:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b9d:	8b 00                	mov    (%eax),%eax
}
c0104b9f:	5d                   	pop    %ebp
c0104ba0:	c3                   	ret    

c0104ba1 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104ba1:	55                   	push   %ebp
c0104ba2:	89 e5                	mov    %esp,%ebp
c0104ba4:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104ba7:	9c                   	pushf  
c0104ba8:	58                   	pop    %eax
c0104ba9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0104bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104baf:	25 00 02 00 00       	and    $0x200,%eax
c0104bb4:	85 c0                	test   %eax,%eax
c0104bb6:	74 0c                	je     c0104bc4 <__intr_save+0x23>
        intr_disable();
c0104bb8:	e8 78 d3 ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0104bbd:	b8 01 00 00 00       	mov    $0x1,%eax
c0104bc2:	eb 05                	jmp    c0104bc9 <__intr_save+0x28>
    }
    return 0;
c0104bc4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104bc9:	c9                   	leave  
c0104bca:	c3                   	ret    

c0104bcb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104bcb:	55                   	push   %ebp
c0104bcc:	89 e5                	mov    %esp,%ebp
c0104bce:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104bd1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104bd5:	74 05                	je     c0104bdc <__intr_restore+0x11>
        intr_enable();
c0104bd7:	e8 53 d3 ff ff       	call   c0101f2f <intr_enable>
    }
}
c0104bdc:	c9                   	leave  
c0104bdd:	c3                   	ret    

c0104bde <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104bde:	55                   	push   %ebp
c0104bdf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104be1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104be4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104be7:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bec:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104bee:	b8 23 00 00 00       	mov    $0x23,%eax
c0104bf3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104bf5:	b8 10 00 00 00       	mov    $0x10,%eax
c0104bfa:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104bfc:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c01:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104c03:	b8 10 00 00 00       	mov    $0x10,%eax
c0104c08:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104c0a:	ea 11 4c 10 c0 08 00 	ljmp   $0x8,$0xc0104c11
}
c0104c11:	5d                   	pop    %ebp
c0104c12:	c3                   	ret    

c0104c13 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104c13:	55                   	push   %ebp
c0104c14:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104c16:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c19:	a3 64 5a 12 c0       	mov    %eax,0xc0125a64
}
c0104c1e:	5d                   	pop    %ebp
c0104c1f:	c3                   	ret    

c0104c20 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104c20:	55                   	push   %ebp
c0104c21:	89 e5                	mov    %esp,%ebp
c0104c23:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104c26:	b8 00 40 12 c0       	mov    $0xc0124000,%eax
c0104c2b:	89 04 24             	mov    %eax,(%esp)
c0104c2e:	e8 e0 ff ff ff       	call   c0104c13 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104c33:	66 c7 05 68 5a 12 c0 	movw   $0x10,0xc0125a68
c0104c3a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104c3c:	66 c7 05 48 4a 12 c0 	movw   $0x68,0xc0124a48
c0104c43:	68 00 
c0104c45:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c4a:	66 a3 4a 4a 12 c0    	mov    %ax,0xc0124a4a
c0104c50:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104c55:	c1 e8 10             	shr    $0x10,%eax
c0104c58:	a2 4c 4a 12 c0       	mov    %al,0xc0124a4c
c0104c5d:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c64:	83 e0 f0             	and    $0xfffffff0,%eax
c0104c67:	83 c8 09             	or     $0x9,%eax
c0104c6a:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c6f:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c76:	83 e0 ef             	and    $0xffffffef,%eax
c0104c79:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c7e:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c85:	83 e0 9f             	and    $0xffffff9f,%eax
c0104c88:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c8d:	0f b6 05 4d 4a 12 c0 	movzbl 0xc0124a4d,%eax
c0104c94:	83 c8 80             	or     $0xffffff80,%eax
c0104c97:	a2 4d 4a 12 c0       	mov    %al,0xc0124a4d
c0104c9c:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104ca3:	83 e0 f0             	and    $0xfffffff0,%eax
c0104ca6:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cab:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cb2:	83 e0 ef             	and    $0xffffffef,%eax
c0104cb5:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cba:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cc1:	83 e0 df             	and    $0xffffffdf,%eax
c0104cc4:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cc9:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cd0:	83 c8 40             	or     $0x40,%eax
c0104cd3:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104cd8:	0f b6 05 4e 4a 12 c0 	movzbl 0xc0124a4e,%eax
c0104cdf:	83 e0 7f             	and    $0x7f,%eax
c0104ce2:	a2 4e 4a 12 c0       	mov    %al,0xc0124a4e
c0104ce7:	b8 60 5a 12 c0       	mov    $0xc0125a60,%eax
c0104cec:	c1 e8 18             	shr    $0x18,%eax
c0104cef:	a2 4f 4a 12 c0       	mov    %al,0xc0124a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104cf4:	c7 04 24 50 4a 12 c0 	movl   $0xc0124a50,(%esp)
c0104cfb:	e8 de fe ff ff       	call   c0104bde <lgdt>
c0104d00:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104d06:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104d0a:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104d0d:	c9                   	leave  
c0104d0e:	c3                   	ret    

c0104d0f <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104d0f:	55                   	push   %ebp
c0104d10:	89 e5                	mov    %esp,%ebp
c0104d12:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104d15:	c7 05 24 7b 12 c0 90 	movl   $0xc010a890,0xc0127b24
c0104d1c:	a8 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104d1f:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d24:	8b 00                	mov    (%eax),%eax
c0104d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d2a:	c7 04 24 1c aa 10 c0 	movl   $0xc010aa1c,(%esp)
c0104d31:	e8 1d b6 ff ff       	call   c0100353 <cprintf>
    pmm_manager->init();
c0104d36:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d3b:	8b 40 04             	mov    0x4(%eax),%eax
c0104d3e:	ff d0                	call   *%eax
}
c0104d40:	c9                   	leave  
c0104d41:	c3                   	ret    

c0104d42 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104d42:	55                   	push   %ebp
c0104d43:	89 e5                	mov    %esp,%ebp
c0104d45:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104d48:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d4d:	8b 40 08             	mov    0x8(%eax),%eax
c0104d50:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104d53:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d57:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d5a:	89 14 24             	mov    %edx,(%esp)
c0104d5d:	ff d0                	call   *%eax
}
c0104d5f:	c9                   	leave  
c0104d60:	c3                   	ret    

c0104d61 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104d61:	55                   	push   %ebp
c0104d62:	89 e5                	mov    %esp,%ebp
c0104d64:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104d67:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104d6e:	e8 2e fe ff ff       	call   c0104ba1 <__intr_save>
c0104d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104d76:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104d7b:	8b 40 0c             	mov    0xc(%eax),%eax
c0104d7e:	8b 55 08             	mov    0x8(%ebp),%edx
c0104d81:	89 14 24             	mov    %edx,(%esp)
c0104d84:	ff d0                	call   *%eax
c0104d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104d89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d8c:	89 04 24             	mov    %eax,(%esp)
c0104d8f:	e8 37 fe ff ff       	call   c0104bcb <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104d94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d98:	75 2d                	jne    c0104dc7 <alloc_pages+0x66>
c0104d9a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104d9e:	77 27                	ja     c0104dc7 <alloc_pages+0x66>
c0104da0:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0104da5:	85 c0                	test   %eax,%eax
c0104da7:	74 1e                	je     c0104dc7 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104da9:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dac:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0104db1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104db8:	00 
c0104db9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104dbd:	89 04 24             	mov    %eax,(%esp)
c0104dc0:	e8 62 19 00 00       	call   c0106727 <swap_out>
    }
c0104dc5:	eb a7                	jmp    c0104d6e <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104dca:	c9                   	leave  
c0104dcb:	c3                   	ret    

c0104dcc <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104dcc:	55                   	push   %ebp
c0104dcd:	89 e5                	mov    %esp,%ebp
c0104dcf:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104dd2:	e8 ca fd ff ff       	call   c0104ba1 <__intr_save>
c0104dd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104dda:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104ddf:	8b 40 10             	mov    0x10(%eax),%eax
c0104de2:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104de5:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104de9:	8b 55 08             	mov    0x8(%ebp),%edx
c0104dec:	89 14 24             	mov    %edx,(%esp)
c0104def:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0104df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df4:	89 04 24             	mov    %eax,(%esp)
c0104df7:	e8 cf fd ff ff       	call   c0104bcb <__intr_restore>
}
c0104dfc:	c9                   	leave  
c0104dfd:	c3                   	ret    

c0104dfe <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104dfe:	55                   	push   %ebp
c0104dff:	89 e5                	mov    %esp,%ebp
c0104e01:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104e04:	e8 98 fd ff ff       	call   c0104ba1 <__intr_save>
c0104e09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104e0c:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c0104e11:	8b 40 14             	mov    0x14(%eax),%eax
c0104e14:	ff d0                	call   *%eax
c0104e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e1c:	89 04 24             	mov    %eax,(%esp)
c0104e1f:	e8 a7 fd ff ff       	call   c0104bcb <__intr_restore>
    return ret;
c0104e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104e27:	c9                   	leave  
c0104e28:	c3                   	ret    

c0104e29 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104e29:	55                   	push   %ebp
c0104e2a:	89 e5                	mov    %esp,%ebp
c0104e2c:	57                   	push   %edi
c0104e2d:	56                   	push   %esi
c0104e2e:	53                   	push   %ebx
c0104e2f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104e35:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104e3c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104e43:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104e4a:	c7 04 24 33 aa 10 c0 	movl   $0xc010aa33,(%esp)
c0104e51:	e8 fd b4 ff ff       	call   c0100353 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104e56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104e5d:	e9 15 01 00 00       	jmp    c0104f77 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104e62:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e65:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e68:	89 d0                	mov    %edx,%eax
c0104e6a:	c1 e0 02             	shl    $0x2,%eax
c0104e6d:	01 d0                	add    %edx,%eax
c0104e6f:	c1 e0 02             	shl    $0x2,%eax
c0104e72:	01 c8                	add    %ecx,%eax
c0104e74:	8b 50 08             	mov    0x8(%eax),%edx
c0104e77:	8b 40 04             	mov    0x4(%eax),%eax
c0104e7a:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104e7d:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104e80:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104e83:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104e86:	89 d0                	mov    %edx,%eax
c0104e88:	c1 e0 02             	shl    $0x2,%eax
c0104e8b:	01 d0                	add    %edx,%eax
c0104e8d:	c1 e0 02             	shl    $0x2,%eax
c0104e90:	01 c8                	add    %ecx,%eax
c0104e92:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104e95:	8b 58 10             	mov    0x10(%eax),%ebx
c0104e98:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104e9b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104e9e:	01 c8                	add    %ecx,%eax
c0104ea0:	11 da                	adc    %ebx,%edx
c0104ea2:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0104ea5:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104ea8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104eab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104eae:	89 d0                	mov    %edx,%eax
c0104eb0:	c1 e0 02             	shl    $0x2,%eax
c0104eb3:	01 d0                	add    %edx,%eax
c0104eb5:	c1 e0 02             	shl    $0x2,%eax
c0104eb8:	01 c8                	add    %ecx,%eax
c0104eba:	83 c0 14             	add    $0x14,%eax
c0104ebd:	8b 00                	mov    (%eax),%eax
c0104ebf:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0104ec5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ec8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104ecb:	83 c0 ff             	add    $0xffffffff,%eax
c0104ece:	83 d2 ff             	adc    $0xffffffff,%edx
c0104ed1:	89 c6                	mov    %eax,%esi
c0104ed3:	89 d7                	mov    %edx,%edi
c0104ed5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ed8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104edb:	89 d0                	mov    %edx,%eax
c0104edd:	c1 e0 02             	shl    $0x2,%eax
c0104ee0:	01 d0                	add    %edx,%eax
c0104ee2:	c1 e0 02             	shl    $0x2,%eax
c0104ee5:	01 c8                	add    %ecx,%eax
c0104ee7:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104eea:	8b 58 10             	mov    0x10(%eax),%ebx
c0104eed:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0104ef3:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104ef7:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104efb:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0104eff:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0104f02:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104f05:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f09:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104f0d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0104f11:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104f15:	c7 04 24 40 aa 10 c0 	movl   $0xc010aa40,(%esp)
c0104f1c:	e8 32 b4 ff ff       	call   c0100353 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0104f21:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f27:	89 d0                	mov    %edx,%eax
c0104f29:	c1 e0 02             	shl    $0x2,%eax
c0104f2c:	01 d0                	add    %edx,%eax
c0104f2e:	c1 e0 02             	shl    $0x2,%eax
c0104f31:	01 c8                	add    %ecx,%eax
c0104f33:	83 c0 14             	add    $0x14,%eax
c0104f36:	8b 00                	mov    (%eax),%eax
c0104f38:	83 f8 01             	cmp    $0x1,%eax
c0104f3b:	75 36                	jne    c0104f73 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0104f3d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104f43:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f46:	77 2b                	ja     c0104f73 <page_init+0x14a>
c0104f48:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104f4b:	72 05                	jb     c0104f52 <page_init+0x129>
c0104f4d:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0104f50:	73 21                	jae    c0104f73 <page_init+0x14a>
c0104f52:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f56:	77 1b                	ja     c0104f73 <page_init+0x14a>
c0104f58:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104f5c:	72 09                	jb     c0104f67 <page_init+0x13e>
c0104f5e:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104f65:	77 0c                	ja     c0104f73 <page_init+0x14a>
                maxpa = end;
c0104f67:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104f6a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0104f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104f70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104f73:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104f77:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104f7a:	8b 00                	mov    (%eax),%eax
c0104f7c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104f7f:	0f 8f dd fe ff ff    	jg     c0104e62 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104f85:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f89:	72 1d                	jb     c0104fa8 <page_init+0x17f>
c0104f8b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104f8f:	77 09                	ja     c0104f9a <page_init+0x171>
c0104f91:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104f98:	76 0e                	jbe    c0104fa8 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0104f9a:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104fa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104fa8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104fab:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104fae:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104fb2:	c1 ea 0c             	shr    $0xc,%edx
c0104fb5:	a3 40 5a 12 c0       	mov    %eax,0xc0125a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104fba:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104fc1:	b8 18 7c 12 c0       	mov    $0xc0127c18,%eax
c0104fc6:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104fc9:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104fcc:	01 d0                	add    %edx,%eax
c0104fce:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104fd1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104fd4:	ba 00 00 00 00       	mov    $0x0,%edx
c0104fd9:	f7 75 ac             	divl   -0x54(%ebp)
c0104fdc:	89 d0                	mov    %edx,%eax
c0104fde:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104fe1:	29 c2                	sub    %eax,%edx
c0104fe3:	89 d0                	mov    %edx,%eax
c0104fe5:	a3 2c 7b 12 c0       	mov    %eax,0xc0127b2c

    for (i = 0; i < npage; i ++) {
c0104fea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104ff1:	eb 27                	jmp    c010501a <page_init+0x1f1>
        SetPageReserved(pages + i);
c0104ff3:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0104ff8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ffb:	c1 e2 05             	shl    $0x5,%edx
c0104ffe:	01 d0                	add    %edx,%eax
c0105000:	83 c0 04             	add    $0x4,%eax
c0105003:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010500a:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010500d:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105010:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105013:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105016:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010501a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010501d:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105022:	39 c2                	cmp    %eax,%edx
c0105024:	72 cd                	jb     c0104ff3 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105026:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010502b:	c1 e0 05             	shl    $0x5,%eax
c010502e:	89 c2                	mov    %eax,%edx
c0105030:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0105035:	01 d0                	add    %edx,%eax
c0105037:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010503a:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105041:	77 23                	ja     c0105066 <page_init+0x23d>
c0105043:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105046:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010504a:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c0105051:	c0 
c0105052:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0105059:	00 
c010505a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105061:	e8 77 bc ff ff       	call   c0100cdd <__panic>
c0105066:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0105069:	05 00 00 00 40       	add    $0x40000000,%eax
c010506e:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105071:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105078:	e9 74 01 00 00       	jmp    c01051f1 <page_init+0x3c8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010507d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105080:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105083:	89 d0                	mov    %edx,%eax
c0105085:	c1 e0 02             	shl    $0x2,%eax
c0105088:	01 d0                	add    %edx,%eax
c010508a:	c1 e0 02             	shl    $0x2,%eax
c010508d:	01 c8                	add    %ecx,%eax
c010508f:	8b 50 08             	mov    0x8(%eax),%edx
c0105092:	8b 40 04             	mov    0x4(%eax),%eax
c0105095:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105098:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010509b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010509e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050a1:	89 d0                	mov    %edx,%eax
c01050a3:	c1 e0 02             	shl    $0x2,%eax
c01050a6:	01 d0                	add    %edx,%eax
c01050a8:	c1 e0 02             	shl    $0x2,%eax
c01050ab:	01 c8                	add    %ecx,%eax
c01050ad:	8b 48 0c             	mov    0xc(%eax),%ecx
c01050b0:	8b 58 10             	mov    0x10(%eax),%ebx
c01050b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01050b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01050b9:	01 c8                	add    %ecx,%eax
c01050bb:	11 da                	adc    %ebx,%edx
c01050bd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01050c0:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c01050c3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01050c6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01050c9:	89 d0                	mov    %edx,%eax
c01050cb:	c1 e0 02             	shl    $0x2,%eax
c01050ce:	01 d0                	add    %edx,%eax
c01050d0:	c1 e0 02             	shl    $0x2,%eax
c01050d3:	01 c8                	add    %ecx,%eax
c01050d5:	83 c0 14             	add    $0x14,%eax
c01050d8:	8b 00                	mov    (%eax),%eax
c01050da:	83 f8 01             	cmp    $0x1,%eax
c01050dd:	0f 85 0a 01 00 00    	jne    c01051ed <page_init+0x3c4>
            if (begin < freemem) {
c01050e3:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050e6:	ba 00 00 00 00       	mov    $0x0,%edx
c01050eb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050ee:	72 17                	jb     c0105107 <page_init+0x2de>
c01050f0:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050f3:	77 05                	ja     c01050fa <page_init+0x2d1>
c01050f5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01050f8:	76 0d                	jbe    c0105107 <page_init+0x2de>
                begin = freemem;
c01050fa:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01050fd:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105100:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105107:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010510b:	72 1d                	jb     c010512a <page_init+0x301>
c010510d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105111:	77 09                	ja     c010511c <page_init+0x2f3>
c0105113:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010511a:	76 0e                	jbe    c010512a <page_init+0x301>
                end = KMEMSIZE;
c010511c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105123:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010512a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010512d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105130:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105133:	0f 87 b4 00 00 00    	ja     c01051ed <page_init+0x3c4>
c0105139:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010513c:	72 09                	jb     c0105147 <page_init+0x31e>
c010513e:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105141:	0f 83 a6 00 00 00    	jae    c01051ed <page_init+0x3c4>
                begin = ROUNDUP(begin, PGSIZE);
c0105147:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c010514e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0105151:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0105154:	01 d0                	add    %edx,%eax
c0105156:	83 e8 01             	sub    $0x1,%eax
c0105159:	89 45 98             	mov    %eax,-0x68(%ebp)
c010515c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010515f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105164:	f7 75 9c             	divl   -0x64(%ebp)
c0105167:	89 d0                	mov    %edx,%eax
c0105169:	8b 55 98             	mov    -0x68(%ebp),%edx
c010516c:	29 c2                	sub    %eax,%edx
c010516e:	89 d0                	mov    %edx,%eax
c0105170:	ba 00 00 00 00       	mov    $0x0,%edx
c0105175:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105178:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010517b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010517e:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105181:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105184:	ba 00 00 00 00       	mov    $0x0,%edx
c0105189:	89 c7                	mov    %eax,%edi
c010518b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0105191:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0105194:	89 d0                	mov    %edx,%eax
c0105196:	83 e0 00             	and    $0x0,%eax
c0105199:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010519c:	8b 45 80             	mov    -0x80(%ebp),%eax
c010519f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01051a2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01051a5:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01051a8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01051ae:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051b1:	77 3a                	ja     c01051ed <page_init+0x3c4>
c01051b3:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01051b6:	72 05                	jb     c01051bd <page_init+0x394>
c01051b8:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01051bb:	73 30                	jae    c01051ed <page_init+0x3c4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01051bd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01051c0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01051c3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01051c6:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01051c9:	29 c8                	sub    %ecx,%eax
c01051cb:	19 da                	sbb    %ebx,%edx
c01051cd:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01051d1:	c1 ea 0c             	shr    $0xc,%edx
c01051d4:	89 c3                	mov    %eax,%ebx
c01051d6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01051d9:	89 04 24             	mov    %eax,(%esp)
c01051dc:	e8 a4 f8 ff ff       	call   c0104a85 <pa2page>
c01051e1:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01051e5:	89 04 24             	mov    %eax,(%esp)
c01051e8:	e8 55 fb ff ff       	call   c0104d42 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01051ed:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01051f1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01051f4:	8b 00                	mov    (%eax),%eax
c01051f6:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01051f9:	0f 8f 7e fe ff ff    	jg     c010507d <page_init+0x254>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01051ff:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0105205:	5b                   	pop    %ebx
c0105206:	5e                   	pop    %esi
c0105207:	5f                   	pop    %edi
c0105208:	5d                   	pop    %ebp
c0105209:	c3                   	ret    

c010520a <enable_paging>:

static void
enable_paging(void) {
c010520a:	55                   	push   %ebp
c010520b:	89 e5                	mov    %esp,%ebp
c010520d:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0105210:	a1 28 7b 12 c0       	mov    0xc0127b28,%eax
c0105215:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105218:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010521b:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c010521e:	0f 20 c0             	mov    %cr0,%eax
c0105221:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0105224:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105227:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c010522a:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105231:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0105235:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105238:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010523b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010523e:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105241:	c9                   	leave  
c0105242:	c3                   	ret    

c0105243 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105243:	55                   	push   %ebp
c0105244:	89 e5                	mov    %esp,%ebp
c0105246:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0105249:	8b 45 14             	mov    0x14(%ebp),%eax
c010524c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010524f:	31 d0                	xor    %edx,%eax
c0105251:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105256:	85 c0                	test   %eax,%eax
c0105258:	74 24                	je     c010527e <boot_map_segment+0x3b>
c010525a:	c7 44 24 0c a2 aa 10 	movl   $0xc010aaa2,0xc(%esp)
c0105261:	c0 
c0105262:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105269:	c0 
c010526a:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105271:	00 
c0105272:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105279:	e8 5f ba ff ff       	call   c0100cdd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010527e:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105285:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105288:	25 ff 0f 00 00       	and    $0xfff,%eax
c010528d:	89 c2                	mov    %eax,%edx
c010528f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105292:	01 c2                	add    %eax,%edx
c0105294:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105297:	01 d0                	add    %edx,%eax
c0105299:	83 e8 01             	sub    $0x1,%eax
c010529c:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010529f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01052a2:	ba 00 00 00 00       	mov    $0x0,%edx
c01052a7:	f7 75 f0             	divl   -0x10(%ebp)
c01052aa:	89 d0                	mov    %edx,%eax
c01052ac:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01052af:	29 c2                	sub    %eax,%edx
c01052b1:	89 d0                	mov    %edx,%eax
c01052b3:	c1 e8 0c             	shr    $0xc,%eax
c01052b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01052b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01052bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01052c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052c7:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01052ca:	8b 45 14             	mov    0x14(%ebp),%eax
c01052cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01052d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052d3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01052d8:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01052db:	eb 6b                	jmp    c0105348 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01052dd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01052e4:	00 
c01052e5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01052e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01052ef:	89 04 24             	mov    %eax,(%esp)
c01052f2:	e8 d1 01 00 00       	call   c01054c8 <get_pte>
c01052f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01052fa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01052fe:	75 24                	jne    c0105324 <boot_map_segment+0xe1>
c0105300:	c7 44 24 0c ce aa 10 	movl   $0xc010aace,0xc(%esp)
c0105307:	c0 
c0105308:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010530f:	c0 
c0105310:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105317:	00 
c0105318:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010531f:	e8 b9 b9 ff ff       	call   c0100cdd <__panic>
        *ptep = pa | PTE_P | perm;
c0105324:	8b 45 18             	mov    0x18(%ebp),%eax
c0105327:	8b 55 14             	mov    0x14(%ebp),%edx
c010532a:	09 d0                	or     %edx,%eax
c010532c:	83 c8 01             	or     $0x1,%eax
c010532f:	89 c2                	mov    %eax,%edx
c0105331:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105334:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105336:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010533a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105341:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105348:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010534c:	75 8f                	jne    c01052dd <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010534e:	c9                   	leave  
c010534f:	c3                   	ret    

c0105350 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0105350:	55                   	push   %ebp
c0105351:	89 e5                	mov    %esp,%ebp
c0105353:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105356:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010535d:	e8 ff f9 ff ff       	call   c0104d61 <alloc_pages>
c0105362:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105365:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105369:	75 1c                	jne    c0105387 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010536b:	c7 44 24 08 db aa 10 	movl   $0xc010aadb,0x8(%esp)
c0105372:	c0 
c0105373:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c010537a:	00 
c010537b:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105382:	e8 56 b9 ff ff       	call   c0100cdd <__panic>
    }
    return page2kva(p);
c0105387:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010538a:	89 04 24             	mov    %eax,(%esp)
c010538d:	e8 38 f7 ff ff       	call   c0104aca <page2kva>
}
c0105392:	c9                   	leave  
c0105393:	c3                   	ret    

c0105394 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105394:	55                   	push   %ebp
c0105395:	89 e5                	mov    %esp,%ebp
c0105397:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010539a:	e8 70 f9 ff ff       	call   c0104d0f <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010539f:	e8 85 fa ff ff       	call   c0104e29 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01053a4:	e8 36 05 00 00       	call   c01058df <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01053a9:	e8 a2 ff ff ff       	call   c0105350 <boot_alloc_page>
c01053ae:	a3 44 5a 12 c0       	mov    %eax,0xc0125a44
    memset(boot_pgdir, 0, PGSIZE);
c01053b3:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01053bf:	00 
c01053c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01053c7:	00 
c01053c8:	89 04 24             	mov    %eax,(%esp)
c01053cb:	e8 31 47 00 00       	call   c0109b01 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01053d0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01053d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01053d8:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01053df:	77 23                	ja     c0105404 <pmm_init+0x70>
c01053e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01053e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01053e8:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01053ef:	c0 
c01053f0:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01053f7:	00 
c01053f8:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01053ff:	e8 d9 b8 ff ff       	call   c0100cdd <__panic>
c0105404:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105407:	05 00 00 00 40       	add    $0x40000000,%eax
c010540c:	a3 28 7b 12 c0       	mov    %eax,0xc0127b28

    check_pgdir();
c0105411:	e8 e7 04 00 00       	call   c01058fd <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105416:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010541b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105421:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105426:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105429:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0105430:	77 23                	ja     c0105455 <pmm_init+0xc1>
c0105432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105435:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105439:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c0105440:	c0 
c0105441:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105448:	00 
c0105449:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105450:	e8 88 b8 ff ff       	call   c0100cdd <__panic>
c0105455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105458:	05 00 00 00 40       	add    $0x40000000,%eax
c010545d:	83 c8 03             	or     $0x3,%eax
c0105460:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105462:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105467:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010546e:	00 
c010546f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105476:	00 
c0105477:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010547e:	38 
c010547f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105486:	c0 
c0105487:	89 04 24             	mov    %eax,(%esp)
c010548a:	e8 b4 fd ff ff       	call   c0105243 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010548f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105494:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c010549a:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01054a0:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01054a2:	e8 63 fd ff ff       	call   c010520a <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01054a7:	e8 74 f7 ff ff       	call   c0104c20 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01054ac:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01054b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01054b7:	e8 dc 0a 00 00       	call   c0105f98 <check_boot_pgdir>

    print_pgdir();
c01054bc:	e8 69 0f 00 00       	call   c010642a <print_pgdir>
    
    kmalloc_init();
c01054c1:	e8 fe f2 ff ff       	call   c01047c4 <kmalloc_init>

}
c01054c6:	c9                   	leave  
c01054c7:	c3                   	ret    

c01054c8 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01054c8:	55                   	push   %ebp
c01054c9:	89 e5                	mov    %esp,%ebp
c01054cb:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01054ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054d1:	c1 e8 16             	shr    $0x16,%eax
c01054d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01054db:	8b 45 08             	mov    0x8(%ebp),%eax
c01054de:	01 d0                	add    %edx,%eax
c01054e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c01054e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054e6:	8b 00                	mov    (%eax),%eax
c01054e8:	83 e0 01             	and    $0x1,%eax
c01054eb:	85 c0                	test   %eax,%eax
c01054ed:	0f 85 af 00 00 00    	jne    c01055a2 <get_pte+0xda>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c01054f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054f7:	74 15                	je     c010550e <get_pte+0x46>
c01054f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105500:	e8 5c f8 ff ff       	call   c0104d61 <alloc_pages>
c0105505:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105508:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010550c:	75 0a                	jne    c0105518 <get_pte+0x50>
            return NULL;
c010550e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105513:	e9 e6 00 00 00       	jmp    c01055fe <get_pte+0x136>
        }
        set_page_ref(page, 1);
c0105518:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010551f:	00 
c0105520:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105523:	89 04 24             	mov    %eax,(%esp)
c0105526:	e8 3b f6 ff ff       	call   c0104b66 <set_page_ref>
        uintptr_t pa = page2pa(page);
c010552b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010552e:	89 04 24             	mov    %eax,(%esp)
c0105531:	e8 39 f5 ff ff       	call   c0104a6f <page2pa>
c0105536:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c0105539:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010553c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010553f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105542:	c1 e8 0c             	shr    $0xc,%eax
c0105545:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105548:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010554d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105550:	72 23                	jb     c0105575 <get_pte+0xad>
c0105552:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105555:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105559:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105560:	c0 
c0105561:	c7 44 24 04 97 01 00 	movl   $0x197,0x4(%esp)
c0105568:	00 
c0105569:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105570:	e8 68 b7 ff ff       	call   c0100cdd <__panic>
c0105575:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105578:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010557d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105584:	00 
c0105585:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010558c:	00 
c010558d:	89 04 24             	mov    %eax,(%esp)
c0105590:	e8 6c 45 00 00       	call   c0109b01 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0105595:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105598:	83 c8 07             	or     $0x7,%eax
c010559b:	89 c2                	mov    %eax,%edx
c010559d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055a0:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c01055a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055a5:	8b 00                	mov    (%eax),%eax
c01055a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01055ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01055af:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055b2:	c1 e8 0c             	shr    $0xc,%eax
c01055b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01055b8:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01055bd:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01055c0:	72 23                	jb     c01055e5 <get_pte+0x11d>
c01055c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055c9:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c01055d0:	c0 
c01055d1:	c7 44 24 04 9a 01 00 	movl   $0x19a,0x4(%esp)
c01055d8:	00 
c01055d9:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01055e0:	e8 f8 b6 ff ff       	call   c0100cdd <__panic>
c01055e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055e8:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01055ed:	8b 55 0c             	mov    0xc(%ebp),%edx
c01055f0:	c1 ea 0c             	shr    $0xc,%edx
c01055f3:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01055f9:	c1 e2 02             	shl    $0x2,%edx
c01055fc:	01 d0                	add    %edx,%eax
}
c01055fe:	c9                   	leave  
c01055ff:	c3                   	ret    

c0105600 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c0105600:	55                   	push   %ebp
c0105601:	89 e5                	mov    %esp,%ebp
c0105603:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105606:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010560d:	00 
c010560e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105611:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105615:	8b 45 08             	mov    0x8(%ebp),%eax
c0105618:	89 04 24             	mov    %eax,(%esp)
c010561b:	e8 a8 fe ff ff       	call   c01054c8 <get_pte>
c0105620:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105623:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105627:	74 08                	je     c0105631 <get_page+0x31>
        *ptep_store = ptep;
c0105629:	8b 45 10             	mov    0x10(%ebp),%eax
c010562c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010562f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105631:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105635:	74 1b                	je     c0105652 <get_page+0x52>
c0105637:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010563a:	8b 00                	mov    (%eax),%eax
c010563c:	83 e0 01             	and    $0x1,%eax
c010563f:	85 c0                	test   %eax,%eax
c0105641:	74 0f                	je     c0105652 <get_page+0x52>
        return pa2page(*ptep);
c0105643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105646:	8b 00                	mov    (%eax),%eax
c0105648:	89 04 24             	mov    %eax,(%esp)
c010564b:	e8 35 f4 ff ff       	call   c0104a85 <pa2page>
c0105650:	eb 05                	jmp    c0105657 <get_page+0x57>
    }
    return NULL;
c0105652:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105657:	c9                   	leave  
c0105658:	c3                   	ret    

c0105659 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105659:	55                   	push   %ebp
c010565a:	89 e5                	mov    %esp,%ebp
c010565c:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c010565f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105662:	8b 00                	mov    (%eax),%eax
c0105664:	83 e0 01             	and    $0x1,%eax
c0105667:	85 c0                	test   %eax,%eax
c0105669:	74 4d                	je     c01056b8 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c010566b:	8b 45 10             	mov    0x10(%ebp),%eax
c010566e:	8b 00                	mov    (%eax),%eax
c0105670:	89 04 24             	mov    %eax,(%esp)
c0105673:	e8 a6 f4 ff ff       	call   c0104b1e <pte2page>
c0105678:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
c010567b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010567e:	89 04 24             	mov    %eax,(%esp)
c0105681:	e8 04 f5 ff ff       	call   c0104b8a <page_ref_dec>
c0105686:	85 c0                	test   %eax,%eax
c0105688:	75 13                	jne    c010569d <page_remove_pte+0x44>
            free_page(page);
c010568a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105691:	00 
c0105692:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105695:	89 04 24             	mov    %eax,(%esp)
c0105698:	e8 2f f7 ff ff       	call   c0104dcc <free_pages>
        }
        *ptep = 0;
c010569d:	8b 45 10             	mov    0x10(%ebp),%eax
c01056a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c01056a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b0:	89 04 24             	mov    %eax,(%esp)
c01056b3:	e8 ff 00 00 00       	call   c01057b7 <tlb_invalidate>
    }
}
c01056b8:	c9                   	leave  
c01056b9:	c3                   	ret    

c01056ba <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01056ba:	55                   	push   %ebp
c01056bb:	89 e5                	mov    %esp,%ebp
c01056bd:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01056c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01056c7:	00 
c01056c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01056d2:	89 04 24             	mov    %eax,(%esp)
c01056d5:	e8 ee fd ff ff       	call   c01054c8 <get_pte>
c01056da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01056dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01056e1:	74 19                	je     c01056fc <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01056e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056f4:	89 04 24             	mov    %eax,(%esp)
c01056f7:	e8 5d ff ff ff       	call   c0105659 <page_remove_pte>
    }
}
c01056fc:	c9                   	leave  
c01056fd:	c3                   	ret    

c01056fe <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01056fe:	55                   	push   %ebp
c01056ff:	89 e5                	mov    %esp,%ebp
c0105701:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105704:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010570b:	00 
c010570c:	8b 45 10             	mov    0x10(%ebp),%eax
c010570f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105713:	8b 45 08             	mov    0x8(%ebp),%eax
c0105716:	89 04 24             	mov    %eax,(%esp)
c0105719:	e8 aa fd ff ff       	call   c01054c8 <get_pte>
c010571e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105721:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105725:	75 0a                	jne    c0105731 <page_insert+0x33>
        return -E_NO_MEM;
c0105727:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010572c:	e9 84 00 00 00       	jmp    c01057b5 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105731:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105734:	89 04 24             	mov    %eax,(%esp)
c0105737:	e8 37 f4 ff ff       	call   c0104b73 <page_ref_inc>
    if (*ptep & PTE_P) {
c010573c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010573f:	8b 00                	mov    (%eax),%eax
c0105741:	83 e0 01             	and    $0x1,%eax
c0105744:	85 c0                	test   %eax,%eax
c0105746:	74 3e                	je     c0105786 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105748:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010574b:	8b 00                	mov    (%eax),%eax
c010574d:	89 04 24             	mov    %eax,(%esp)
c0105750:	e8 c9 f3 ff ff       	call   c0104b1e <pte2page>
c0105755:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105758:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010575b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010575e:	75 0d                	jne    c010576d <page_insert+0x6f>
            page_ref_dec(page);
c0105760:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105763:	89 04 24             	mov    %eax,(%esp)
c0105766:	e8 1f f4 ff ff       	call   c0104b8a <page_ref_dec>
c010576b:	eb 19                	jmp    c0105786 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010576d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105770:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105774:	8b 45 10             	mov    0x10(%ebp),%eax
c0105777:	89 44 24 04          	mov    %eax,0x4(%esp)
c010577b:	8b 45 08             	mov    0x8(%ebp),%eax
c010577e:	89 04 24             	mov    %eax,(%esp)
c0105781:	e8 d3 fe ff ff       	call   c0105659 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105786:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105789:	89 04 24             	mov    %eax,(%esp)
c010578c:	e8 de f2 ff ff       	call   c0104a6f <page2pa>
c0105791:	0b 45 14             	or     0x14(%ebp),%eax
c0105794:	83 c8 01             	or     $0x1,%eax
c0105797:	89 c2                	mov    %eax,%edx
c0105799:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010579c:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010579e:	8b 45 10             	mov    0x10(%ebp),%eax
c01057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a8:	89 04 24             	mov    %eax,(%esp)
c01057ab:	e8 07 00 00 00       	call   c01057b7 <tlb_invalidate>
    return 0;
c01057b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057b5:	c9                   	leave  
c01057b6:	c3                   	ret    

c01057b7 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01057b7:	55                   	push   %ebp
c01057b8:	89 e5                	mov    %esp,%ebp
c01057ba:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01057bd:	0f 20 d8             	mov    %cr3,%eax
c01057c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01057c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01057c6:	89 c2                	mov    %eax,%edx
c01057c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057ce:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01057d5:	77 23                	ja     c01057fa <tlb_invalidate+0x43>
c01057d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057da:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057de:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01057e5:	c0 
c01057e6:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c01057ed:	00 
c01057ee:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01057f5:	e8 e3 b4 ff ff       	call   c0100cdd <__panic>
c01057fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057fd:	05 00 00 00 40       	add    $0x40000000,%eax
c0105802:	39 c2                	cmp    %eax,%edx
c0105804:	75 0c                	jne    c0105812 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0105806:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105809:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010580c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010580f:	0f 01 38             	invlpg (%eax)
    }
}
c0105812:	c9                   	leave  
c0105813:	c3                   	ret    

c0105814 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105814:	55                   	push   %ebp
c0105815:	89 e5                	mov    %esp,%ebp
c0105817:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010581a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105821:	e8 3b f5 ff ff       	call   c0104d61 <alloc_pages>
c0105826:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010582d:	0f 84 a7 00 00 00    	je     c01058da <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0105833:	8b 45 10             	mov    0x10(%ebp),%eax
c0105836:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010583a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010583d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105844:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105848:	8b 45 08             	mov    0x8(%ebp),%eax
c010584b:	89 04 24             	mov    %eax,(%esp)
c010584e:	e8 ab fe ff ff       	call   c01056fe <page_insert>
c0105853:	85 c0                	test   %eax,%eax
c0105855:	74 1a                	je     c0105871 <pgdir_alloc_page+0x5d>
            free_page(page);
c0105857:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010585e:	00 
c010585f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105862:	89 04 24             	mov    %eax,(%esp)
c0105865:	e8 62 f5 ff ff       	call   c0104dcc <free_pages>
            return NULL;
c010586a:	b8 00 00 00 00       	mov    $0x0,%eax
c010586f:	eb 6c                	jmp    c01058dd <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c0105871:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0105876:	85 c0                	test   %eax,%eax
c0105878:	74 60                	je     c01058da <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c010587a:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c010587f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105886:	00 
c0105887:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010588a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010588e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105891:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105895:	89 04 24             	mov    %eax,(%esp)
c0105898:	e8 3e 0e 00 00       	call   c01066db <swap_map_swappable>
            page->pra_vaddr=la;
c010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01058a3:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01058a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058a9:	89 04 24             	mov    %eax,(%esp)
c01058ac:	e8 ab f2 ff ff       	call   c0104b5c <page_ref>
c01058b1:	83 f8 01             	cmp    $0x1,%eax
c01058b4:	74 24                	je     c01058da <pgdir_alloc_page+0xc6>
c01058b6:	c7 44 24 0c f4 aa 10 	movl   $0xc010aaf4,0xc(%esp)
c01058bd:	c0 
c01058be:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01058c5:	c0 
c01058c6:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c01058cd:	00 
c01058ce:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01058d5:	e8 03 b4 ff ff       	call   c0100cdd <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c01058da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01058dd:	c9                   	leave  
c01058de:	c3                   	ret    

c01058df <check_alloc_page>:

static void
check_alloc_page(void) {
c01058df:	55                   	push   %ebp
c01058e0:	89 e5                	mov    %esp,%ebp
c01058e2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01058e5:	a1 24 7b 12 c0       	mov    0xc0127b24,%eax
c01058ea:	8b 40 18             	mov    0x18(%eax),%eax
c01058ed:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01058ef:	c7 04 24 08 ab 10 c0 	movl   $0xc010ab08,(%esp)
c01058f6:	e8 58 aa ff ff       	call   c0100353 <cprintf>
}
c01058fb:	c9                   	leave  
c01058fc:	c3                   	ret    

c01058fd <check_pgdir>:

static void
check_pgdir(void) {
c01058fd:	55                   	push   %ebp
c01058fe:	89 e5                	mov    %esp,%ebp
c0105900:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105903:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105908:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010590d:	76 24                	jbe    c0105933 <check_pgdir+0x36>
c010590f:	c7 44 24 0c 27 ab 10 	movl   $0xc010ab27,0xc(%esp)
c0105916:	c0 
c0105917:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010591e:	c0 
c010591f:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105926:	00 
c0105927:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010592e:	e8 aa b3 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105933:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105938:	85 c0                	test   %eax,%eax
c010593a:	74 0e                	je     c010594a <check_pgdir+0x4d>
c010593c:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105941:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105946:	85 c0                	test   %eax,%eax
c0105948:	74 24                	je     c010596e <check_pgdir+0x71>
c010594a:	c7 44 24 0c 44 ab 10 	movl   $0xc010ab44,0xc(%esp)
c0105951:	c0 
c0105952:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105959:	c0 
c010595a:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0105961:	00 
c0105962:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105969:	e8 6f b3 ff ff       	call   c0100cdd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010596e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105973:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010597a:	00 
c010597b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105982:	00 
c0105983:	89 04 24             	mov    %eax,(%esp)
c0105986:	e8 75 fc ff ff       	call   c0105600 <get_page>
c010598b:	85 c0                	test   %eax,%eax
c010598d:	74 24                	je     c01059b3 <check_pgdir+0xb6>
c010598f:	c7 44 24 0c 7c ab 10 	movl   $0xc010ab7c,0xc(%esp)
c0105996:	c0 
c0105997:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010599e:	c0 
c010599f:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c01059a6:	00 
c01059a7:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01059ae:	e8 2a b3 ff ff       	call   c0100cdd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01059b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059ba:	e8 a2 f3 ff ff       	call   c0104d61 <alloc_pages>
c01059bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01059c2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01059c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01059ce:	00 
c01059cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059d6:	00 
c01059d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059da:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059de:	89 04 24             	mov    %eax,(%esp)
c01059e1:	e8 18 fd ff ff       	call   c01056fe <page_insert>
c01059e6:	85 c0                	test   %eax,%eax
c01059e8:	74 24                	je     c0105a0e <check_pgdir+0x111>
c01059ea:	c7 44 24 0c a4 ab 10 	movl   $0xc010aba4,0xc(%esp)
c01059f1:	c0 
c01059f2:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01059f9:	c0 
c01059fa:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0105a01:	00 
c0105a02:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a09:	e8 cf b2 ff ff       	call   c0100cdd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105a0e:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105a13:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a1a:	00 
c0105a1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105a22:	00 
c0105a23:	89 04 24             	mov    %eax,(%esp)
c0105a26:	e8 9d fa ff ff       	call   c01054c8 <get_pte>
c0105a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a32:	75 24                	jne    c0105a58 <check_pgdir+0x15b>
c0105a34:	c7 44 24 0c d0 ab 10 	movl   $0xc010abd0,0xc(%esp)
c0105a3b:	c0 
c0105a3c:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105a43:	c0 
c0105a44:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105a4b:	00 
c0105a4c:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a53:	e8 85 b2 ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a5b:	8b 00                	mov    (%eax),%eax
c0105a5d:	89 04 24             	mov    %eax,(%esp)
c0105a60:	e8 20 f0 ff ff       	call   c0104a85 <pa2page>
c0105a65:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105a68:	74 24                	je     c0105a8e <check_pgdir+0x191>
c0105a6a:	c7 44 24 0c fd ab 10 	movl   $0xc010abfd,0xc(%esp)
c0105a71:	c0 
c0105a72:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105a79:	c0 
c0105a7a:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105a81:	00 
c0105a82:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105a89:	e8 4f b2 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 1);
c0105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a91:	89 04 24             	mov    %eax,(%esp)
c0105a94:	e8 c3 f0 ff ff       	call   c0104b5c <page_ref>
c0105a99:	83 f8 01             	cmp    $0x1,%eax
c0105a9c:	74 24                	je     c0105ac2 <check_pgdir+0x1c5>
c0105a9e:	c7 44 24 0c 12 ac 10 	movl   $0xc010ac12,0xc(%esp)
c0105aa5:	c0 
c0105aa6:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105aad:	c0 
c0105aae:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
c0105ab5:	00 
c0105ab6:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105abd:	e8 1b b2 ff ff       	call   c0100cdd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105ac2:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ac7:	8b 00                	mov    (%eax),%eax
c0105ac9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105ace:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad4:	c1 e8 0c             	shr    $0xc,%eax
c0105ad7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ada:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105adf:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105ae2:	72 23                	jb     c0105b07 <check_pgdir+0x20a>
c0105ae4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ae7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105aeb:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105af2:	c0 
c0105af3:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105afa:	00 
c0105afb:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105b02:	e8 d6 b1 ff ff       	call   c0100cdd <__panic>
c0105b07:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b0a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105b0f:	83 c0 04             	add    $0x4,%eax
c0105b12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105b15:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b1a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b21:	00 
c0105b22:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105b29:	00 
c0105b2a:	89 04 24             	mov    %eax,(%esp)
c0105b2d:	e8 96 f9 ff ff       	call   c01054c8 <get_pte>
c0105b32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105b35:	74 24                	je     c0105b5b <check_pgdir+0x25e>
c0105b37:	c7 44 24 0c 24 ac 10 	movl   $0xc010ac24,0xc(%esp)
c0105b3e:	c0 
c0105b3f:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105b46:	c0 
c0105b47:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c0105b4e:	00 
c0105b4f:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105b56:	e8 82 b1 ff ff       	call   c0100cdd <__panic>

    p2 = alloc_page();
c0105b5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b62:	e8 fa f1 ff ff       	call   c0104d61 <alloc_pages>
c0105b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105b6a:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105b6f:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105b76:	00 
c0105b77:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105b7e:	00 
c0105b7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105b82:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b86:	89 04 24             	mov    %eax,(%esp)
c0105b89:	e8 70 fb ff ff       	call   c01056fe <page_insert>
c0105b8e:	85 c0                	test   %eax,%eax
c0105b90:	74 24                	je     c0105bb6 <check_pgdir+0x2b9>
c0105b92:	c7 44 24 0c 4c ac 10 	movl   $0xc010ac4c,0xc(%esp)
c0105b99:	c0 
c0105b9a:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105ba1:	c0 
c0105ba2:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105ba9:	00 
c0105baa:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105bb1:	e8 27 b1 ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105bb6:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105bbb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105bc2:	00 
c0105bc3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105bca:	00 
c0105bcb:	89 04 24             	mov    %eax,(%esp)
c0105bce:	e8 f5 f8 ff ff       	call   c01054c8 <get_pte>
c0105bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bd6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105bda:	75 24                	jne    c0105c00 <check_pgdir+0x303>
c0105bdc:	c7 44 24 0c 84 ac 10 	movl   $0xc010ac84,0xc(%esp)
c0105be3:	c0 
c0105be4:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105beb:	c0 
c0105bec:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105bf3:	00 
c0105bf4:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105bfb:	e8 dd b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_U);
c0105c00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c03:	8b 00                	mov    (%eax),%eax
c0105c05:	83 e0 04             	and    $0x4,%eax
c0105c08:	85 c0                	test   %eax,%eax
c0105c0a:	75 24                	jne    c0105c30 <check_pgdir+0x333>
c0105c0c:	c7 44 24 0c b4 ac 10 	movl   $0xc010acb4,0xc(%esp)
c0105c13:	c0 
c0105c14:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c1b:	c0 
c0105c1c:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105c23:	00 
c0105c24:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c2b:	e8 ad b0 ff ff       	call   c0100cdd <__panic>
    assert(*ptep & PTE_W);
c0105c30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c33:	8b 00                	mov    (%eax),%eax
c0105c35:	83 e0 02             	and    $0x2,%eax
c0105c38:	85 c0                	test   %eax,%eax
c0105c3a:	75 24                	jne    c0105c60 <check_pgdir+0x363>
c0105c3c:	c7 44 24 0c c2 ac 10 	movl   $0xc010acc2,0xc(%esp)
c0105c43:	c0 
c0105c44:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c4b:	c0 
c0105c4c:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105c53:	00 
c0105c54:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c5b:	e8 7d b0 ff ff       	call   c0100cdd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105c60:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105c65:	8b 00                	mov    (%eax),%eax
c0105c67:	83 e0 04             	and    $0x4,%eax
c0105c6a:	85 c0                	test   %eax,%eax
c0105c6c:	75 24                	jne    c0105c92 <check_pgdir+0x395>
c0105c6e:	c7 44 24 0c d0 ac 10 	movl   $0xc010acd0,0xc(%esp)
c0105c75:	c0 
c0105c76:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105c7d:	c0 
c0105c7e:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105c85:	00 
c0105c86:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105c8d:	e8 4b b0 ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 1);
c0105c92:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c95:	89 04 24             	mov    %eax,(%esp)
c0105c98:	e8 bf ee ff ff       	call   c0104b5c <page_ref>
c0105c9d:	83 f8 01             	cmp    $0x1,%eax
c0105ca0:	74 24                	je     c0105cc6 <check_pgdir+0x3c9>
c0105ca2:	c7 44 24 0c e6 ac 10 	movl   $0xc010ace6,0xc(%esp)
c0105ca9:	c0 
c0105caa:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105cb1:	c0 
c0105cb2:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105cb9:	00 
c0105cba:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105cc1:	e8 17 b0 ff ff       	call   c0100cdd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105cc6:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ccb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105cd2:	00 
c0105cd3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105cda:	00 
c0105cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cde:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105ce2:	89 04 24             	mov    %eax,(%esp)
c0105ce5:	e8 14 fa ff ff       	call   c01056fe <page_insert>
c0105cea:	85 c0                	test   %eax,%eax
c0105cec:	74 24                	je     c0105d12 <check_pgdir+0x415>
c0105cee:	c7 44 24 0c f8 ac 10 	movl   $0xc010acf8,0xc(%esp)
c0105cf5:	c0 
c0105cf6:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105cfd:	c0 
c0105cfe:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105d05:	00 
c0105d06:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d0d:	e8 cb af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p1) == 2);
c0105d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d15:	89 04 24             	mov    %eax,(%esp)
c0105d18:	e8 3f ee ff ff       	call   c0104b5c <page_ref>
c0105d1d:	83 f8 02             	cmp    $0x2,%eax
c0105d20:	74 24                	je     c0105d46 <check_pgdir+0x449>
c0105d22:	c7 44 24 0c 24 ad 10 	movl   $0xc010ad24,0xc(%esp)
c0105d29:	c0 
c0105d2a:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105d31:	c0 
c0105d32:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105d39:	00 
c0105d3a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d41:	e8 97 af ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105d46:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d49:	89 04 24             	mov    %eax,(%esp)
c0105d4c:	e8 0b ee ff ff       	call   c0104b5c <page_ref>
c0105d51:	85 c0                	test   %eax,%eax
c0105d53:	74 24                	je     c0105d79 <check_pgdir+0x47c>
c0105d55:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105d5c:	c0 
c0105d5d:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105d64:	c0 
c0105d65:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105d6c:	00 
c0105d6d:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105d74:	e8 64 af ff ff       	call   c0100cdd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105d79:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105d7e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d85:	00 
c0105d86:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d8d:	00 
c0105d8e:	89 04 24             	mov    %eax,(%esp)
c0105d91:	e8 32 f7 ff ff       	call   c01054c8 <get_pte>
c0105d96:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d9d:	75 24                	jne    c0105dc3 <check_pgdir+0x4c6>
c0105d9f:	c7 44 24 0c 84 ac 10 	movl   $0xc010ac84,0xc(%esp)
c0105da6:	c0 
c0105da7:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105dae:	c0 
c0105daf:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105db6:	00 
c0105db7:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105dbe:	e8 1a af ff ff       	call   c0100cdd <__panic>
    assert(pa2page(*ptep) == p1);
c0105dc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dc6:	8b 00                	mov    (%eax),%eax
c0105dc8:	89 04 24             	mov    %eax,(%esp)
c0105dcb:	e8 b5 ec ff ff       	call   c0104a85 <pa2page>
c0105dd0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105dd3:	74 24                	je     c0105df9 <check_pgdir+0x4fc>
c0105dd5:	c7 44 24 0c fd ab 10 	movl   $0xc010abfd,0xc(%esp)
c0105ddc:	c0 
c0105ddd:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105de4:	c0 
c0105de5:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105dec:	00 
c0105ded:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105df4:	e8 e4 ae ff ff       	call   c0100cdd <__panic>
    assert((*ptep & PTE_U) == 0);
c0105df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dfc:	8b 00                	mov    (%eax),%eax
c0105dfe:	83 e0 04             	and    $0x4,%eax
c0105e01:	85 c0                	test   %eax,%eax
c0105e03:	74 24                	je     c0105e29 <check_pgdir+0x52c>
c0105e05:	c7 44 24 0c 48 ad 10 	movl   $0xc010ad48,0xc(%esp)
c0105e0c:	c0 
c0105e0d:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e14:	c0 
c0105e15:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105e1c:	00 
c0105e1d:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105e24:	e8 b4 ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, 0x0);
c0105e29:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105e2e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105e35:	00 
c0105e36:	89 04 24             	mov    %eax,(%esp)
c0105e39:	e8 7c f8 ff ff       	call   c01056ba <page_remove>
    assert(page_ref(p1) == 1);
c0105e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e41:	89 04 24             	mov    %eax,(%esp)
c0105e44:	e8 13 ed ff ff       	call   c0104b5c <page_ref>
c0105e49:	83 f8 01             	cmp    $0x1,%eax
c0105e4c:	74 24                	je     c0105e72 <check_pgdir+0x575>
c0105e4e:	c7 44 24 0c 12 ac 10 	movl   $0xc010ac12,0xc(%esp)
c0105e55:	c0 
c0105e56:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e5d:	c0 
c0105e5e:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105e65:	00 
c0105e66:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105e6d:	e8 6b ae ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e75:	89 04 24             	mov    %eax,(%esp)
c0105e78:	e8 df ec ff ff       	call   c0104b5c <page_ref>
c0105e7d:	85 c0                	test   %eax,%eax
c0105e7f:	74 24                	je     c0105ea5 <check_pgdir+0x5a8>
c0105e81:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105e88:	c0 
c0105e89:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105e90:	c0 
c0105e91:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c0105e98:	00 
c0105e99:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105ea0:	e8 38 ae ff ff       	call   c0100cdd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0105ea5:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105eaa:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105eb1:	00 
c0105eb2:	89 04 24             	mov    %eax,(%esp)
c0105eb5:	e8 00 f8 ff ff       	call   c01056ba <page_remove>
    assert(page_ref(p1) == 0);
c0105eba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ebd:	89 04 24             	mov    %eax,(%esp)
c0105ec0:	e8 97 ec ff ff       	call   c0104b5c <page_ref>
c0105ec5:	85 c0                	test   %eax,%eax
c0105ec7:	74 24                	je     c0105eed <check_pgdir+0x5f0>
c0105ec9:	c7 44 24 0c 5d ad 10 	movl   $0xc010ad5d,0xc(%esp)
c0105ed0:	c0 
c0105ed1:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105ed8:	c0 
c0105ed9:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0105ee0:	00 
c0105ee1:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105ee8:	e8 f0 ad ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p2) == 0);
c0105eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ef0:	89 04 24             	mov    %eax,(%esp)
c0105ef3:	e8 64 ec ff ff       	call   c0104b5c <page_ref>
c0105ef8:	85 c0                	test   %eax,%eax
c0105efa:	74 24                	je     c0105f20 <check_pgdir+0x623>
c0105efc:	c7 44 24 0c 36 ad 10 	movl   $0xc010ad36,0xc(%esp)
c0105f03:	c0 
c0105f04:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105f0b:	c0 
c0105f0c:	c7 44 24 04 45 02 00 	movl   $0x245,0x4(%esp)
c0105f13:	00 
c0105f14:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105f1b:	e8 bd ad ff ff       	call   c0100cdd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0105f20:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f25:	8b 00                	mov    (%eax),%eax
c0105f27:	89 04 24             	mov    %eax,(%esp)
c0105f2a:	e8 56 eb ff ff       	call   c0104a85 <pa2page>
c0105f2f:	89 04 24             	mov    %eax,(%esp)
c0105f32:	e8 25 ec ff ff       	call   c0104b5c <page_ref>
c0105f37:	83 f8 01             	cmp    $0x1,%eax
c0105f3a:	74 24                	je     c0105f60 <check_pgdir+0x663>
c0105f3c:	c7 44 24 0c 70 ad 10 	movl   $0xc010ad70,0xc(%esp)
c0105f43:	c0 
c0105f44:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0105f4b:	c0 
c0105f4c:	c7 44 24 04 47 02 00 	movl   $0x247,0x4(%esp)
c0105f53:	00 
c0105f54:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105f5b:	e8 7d ad ff ff       	call   c0100cdd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0105f60:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f65:	8b 00                	mov    (%eax),%eax
c0105f67:	89 04 24             	mov    %eax,(%esp)
c0105f6a:	e8 16 eb ff ff       	call   c0104a85 <pa2page>
c0105f6f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105f76:	00 
c0105f77:	89 04 24             	mov    %eax,(%esp)
c0105f7a:	e8 4d ee ff ff       	call   c0104dcc <free_pages>
    boot_pgdir[0] = 0;
c0105f7f:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105f84:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0105f8a:	c7 04 24 96 ad 10 c0 	movl   $0xc010ad96,(%esp)
c0105f91:	e8 bd a3 ff ff       	call   c0100353 <cprintf>
}
c0105f96:	c9                   	leave  
c0105f97:	c3                   	ret    

c0105f98 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0105f98:	55                   	push   %ebp
c0105f99:	89 e5                	mov    %esp,%ebp
c0105f9b:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105f9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0105fa5:	e9 ca 00 00 00       	jmp    c0106074 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fb3:	c1 e8 0c             	shr    $0xc,%eax
c0105fb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105fb9:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0105fbe:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105fc1:	72 23                	jb     c0105fe6 <check_boot_pgdir+0x4e>
c0105fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fc6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fca:	c7 44 24 08 cc a9 10 	movl   $0xc010a9cc,0x8(%esp)
c0105fd1:	c0 
c0105fd2:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105fd9:	00 
c0105fda:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0105fe1:	e8 f7 ac ff ff       	call   c0100cdd <__panic>
c0105fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105fe9:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105fee:	89 c2                	mov    %eax,%edx
c0105ff0:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0105ff5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ffc:	00 
c0105ffd:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106001:	89 04 24             	mov    %eax,(%esp)
c0106004:	e8 bf f4 ff ff       	call   c01054c8 <get_pte>
c0106009:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010600c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106010:	75 24                	jne    c0106036 <check_boot_pgdir+0x9e>
c0106012:	c7 44 24 0c b0 ad 10 	movl   $0xc010adb0,0xc(%esp)
c0106019:	c0 
c010601a:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106021:	c0 
c0106022:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0106029:	00 
c010602a:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106031:	e8 a7 ac ff ff       	call   c0100cdd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106036:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106039:	8b 00                	mov    (%eax),%eax
c010603b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106040:	89 c2                	mov    %eax,%edx
c0106042:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106045:	39 c2                	cmp    %eax,%edx
c0106047:	74 24                	je     c010606d <check_boot_pgdir+0xd5>
c0106049:	c7 44 24 0c ed ad 10 	movl   $0xc010aded,0xc(%esp)
c0106050:	c0 
c0106051:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106058:	c0 
c0106059:	c7 44 24 04 54 02 00 	movl   $0x254,0x4(%esp)
c0106060:	00 
c0106061:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106068:	e8 70 ac ff ff       	call   c0100cdd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010606d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106074:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106077:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c010607c:	39 c2                	cmp    %eax,%edx
c010607e:	0f 82 26 ff ff ff    	jb     c0105faa <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106084:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106089:	05 ac 0f 00 00       	add    $0xfac,%eax
c010608e:	8b 00                	mov    (%eax),%eax
c0106090:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106095:	89 c2                	mov    %eax,%edx
c0106097:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010609c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010609f:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01060a6:	77 23                	ja     c01060cb <check_boot_pgdir+0x133>
c01060a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060af:	c7 44 24 08 70 aa 10 	movl   $0xc010aa70,0x8(%esp)
c01060b6:	c0 
c01060b7:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c01060be:	00 
c01060bf:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01060c6:	e8 12 ac ff ff       	call   c0100cdd <__panic>
c01060cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01060ce:	05 00 00 00 40       	add    $0x40000000,%eax
c01060d3:	39 c2                	cmp    %eax,%edx
c01060d5:	74 24                	je     c01060fb <check_boot_pgdir+0x163>
c01060d7:	c7 44 24 0c 04 ae 10 	movl   $0xc010ae04,0xc(%esp)
c01060de:	c0 
c01060df:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01060e6:	c0 
c01060e7:	c7 44 24 04 57 02 00 	movl   $0x257,0x4(%esp)
c01060ee:	00 
c01060ef:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01060f6:	e8 e2 ab ff ff       	call   c0100cdd <__panic>

    assert(boot_pgdir[0] == 0);
c01060fb:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106100:	8b 00                	mov    (%eax),%eax
c0106102:	85 c0                	test   %eax,%eax
c0106104:	74 24                	je     c010612a <check_boot_pgdir+0x192>
c0106106:	c7 44 24 0c 38 ae 10 	movl   $0xc010ae38,0xc(%esp)
c010610d:	c0 
c010610e:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106115:	c0 
c0106116:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c010611d:	00 
c010611e:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106125:	e8 b3 ab ff ff       	call   c0100cdd <__panic>

    struct Page *p;
    p = alloc_page();
c010612a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106131:	e8 2b ec ff ff       	call   c0104d61 <alloc_pages>
c0106136:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106139:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c010613e:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106145:	00 
c0106146:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010614d:	00 
c010614e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106151:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106155:	89 04 24             	mov    %eax,(%esp)
c0106158:	e8 a1 f5 ff ff       	call   c01056fe <page_insert>
c010615d:	85 c0                	test   %eax,%eax
c010615f:	74 24                	je     c0106185 <check_boot_pgdir+0x1ed>
c0106161:	c7 44 24 0c 4c ae 10 	movl   $0xc010ae4c,0xc(%esp)
c0106168:	c0 
c0106169:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106170:	c0 
c0106171:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0106178:	00 
c0106179:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106180:	e8 58 ab ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 1);
c0106185:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106188:	89 04 24             	mov    %eax,(%esp)
c010618b:	e8 cc e9 ff ff       	call   c0104b5c <page_ref>
c0106190:	83 f8 01             	cmp    $0x1,%eax
c0106193:	74 24                	je     c01061b9 <check_boot_pgdir+0x221>
c0106195:	c7 44 24 0c 7a ae 10 	movl   $0xc010ae7a,0xc(%esp)
c010619c:	c0 
c010619d:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01061a4:	c0 
c01061a5:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c01061ac:	00 
c01061ad:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01061b4:	e8 24 ab ff ff       	call   c0100cdd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01061b9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01061be:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01061c5:	00 
c01061c6:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01061cd:	00 
c01061ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01061d1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061d5:	89 04 24             	mov    %eax,(%esp)
c01061d8:	e8 21 f5 ff ff       	call   c01056fe <page_insert>
c01061dd:	85 c0                	test   %eax,%eax
c01061df:	74 24                	je     c0106205 <check_boot_pgdir+0x26d>
c01061e1:	c7 44 24 0c 8c ae 10 	movl   $0xc010ae8c,0xc(%esp)
c01061e8:	c0 
c01061e9:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01061f0:	c0 
c01061f1:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c01061f8:	00 
c01061f9:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106200:	e8 d8 aa ff ff       	call   c0100cdd <__panic>
    assert(page_ref(p) == 2);
c0106205:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106208:	89 04 24             	mov    %eax,(%esp)
c010620b:	e8 4c e9 ff ff       	call   c0104b5c <page_ref>
c0106210:	83 f8 02             	cmp    $0x2,%eax
c0106213:	74 24                	je     c0106239 <check_boot_pgdir+0x2a1>
c0106215:	c7 44 24 0c c3 ae 10 	movl   $0xc010aec3,0xc(%esp)
c010621c:	c0 
c010621d:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c0106224:	c0 
c0106225:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c010622c:	00 
c010622d:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c0106234:	e8 a4 aa ff ff       	call   c0100cdd <__panic>

    const char *str = "ucore: Hello world!!";
c0106239:	c7 45 dc d4 ae 10 c0 	movl   $0xc010aed4,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106240:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106243:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106247:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010624e:	e8 d7 35 00 00       	call   c010982a <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106253:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010625a:	00 
c010625b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106262:	e8 3c 36 00 00       	call   c01098a3 <strcmp>
c0106267:	85 c0                	test   %eax,%eax
c0106269:	74 24                	je     c010628f <check_boot_pgdir+0x2f7>
c010626b:	c7 44 24 0c ec ae 10 	movl   $0xc010aeec,0xc(%esp)
c0106272:	c0 
c0106273:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c010627a:	c0 
c010627b:	c7 44 24 04 64 02 00 	movl   $0x264,0x4(%esp)
c0106282:	00 
c0106283:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c010628a:	e8 4e aa ff ff       	call   c0100cdd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c010628f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106292:	89 04 24             	mov    %eax,(%esp)
c0106295:	e8 30 e8 ff ff       	call   c0104aca <page2kva>
c010629a:	05 00 01 00 00       	add    $0x100,%eax
c010629f:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01062a2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01062a9:	e8 24 35 00 00       	call   c01097d2 <strlen>
c01062ae:	85 c0                	test   %eax,%eax
c01062b0:	74 24                	je     c01062d6 <check_boot_pgdir+0x33e>
c01062b2:	c7 44 24 0c 24 af 10 	movl   $0xc010af24,0xc(%esp)
c01062b9:	c0 
c01062ba:	c7 44 24 08 b9 aa 10 	movl   $0xc010aab9,0x8(%esp)
c01062c1:	c0 
c01062c2:	c7 44 24 04 67 02 00 	movl   $0x267,0x4(%esp)
c01062c9:	00 
c01062ca:	c7 04 24 94 aa 10 c0 	movl   $0xc010aa94,(%esp)
c01062d1:	e8 07 aa ff ff       	call   c0100cdd <__panic>

    free_page(p);
c01062d6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01062dd:	00 
c01062de:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01062e1:	89 04 24             	mov    %eax,(%esp)
c01062e4:	e8 e3 ea ff ff       	call   c0104dcc <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01062e9:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c01062ee:	8b 00                	mov    (%eax),%eax
c01062f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062f5:	89 04 24             	mov    %eax,(%esp)
c01062f8:	e8 88 e7 ff ff       	call   c0104a85 <pa2page>
c01062fd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106304:	00 
c0106305:	89 04 24             	mov    %eax,(%esp)
c0106308:	e8 bf ea ff ff       	call   c0104dcc <free_pages>
    boot_pgdir[0] = 0;
c010630d:	a1 44 5a 12 c0       	mov    0xc0125a44,%eax
c0106312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106318:	c7 04 24 48 af 10 c0 	movl   $0xc010af48,(%esp)
c010631f:	e8 2f a0 ff ff       	call   c0100353 <cprintf>
}
c0106324:	c9                   	leave  
c0106325:	c3                   	ret    

c0106326 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106326:	55                   	push   %ebp
c0106327:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106329:	8b 45 08             	mov    0x8(%ebp),%eax
c010632c:	83 e0 04             	and    $0x4,%eax
c010632f:	85 c0                	test   %eax,%eax
c0106331:	74 07                	je     c010633a <perm2str+0x14>
c0106333:	b8 75 00 00 00       	mov    $0x75,%eax
c0106338:	eb 05                	jmp    c010633f <perm2str+0x19>
c010633a:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010633f:	a2 c8 5a 12 c0       	mov    %al,0xc0125ac8
    str[1] = 'r';
c0106344:	c6 05 c9 5a 12 c0 72 	movb   $0x72,0xc0125ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010634b:	8b 45 08             	mov    0x8(%ebp),%eax
c010634e:	83 e0 02             	and    $0x2,%eax
c0106351:	85 c0                	test   %eax,%eax
c0106353:	74 07                	je     c010635c <perm2str+0x36>
c0106355:	b8 77 00 00 00       	mov    $0x77,%eax
c010635a:	eb 05                	jmp    c0106361 <perm2str+0x3b>
c010635c:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106361:	a2 ca 5a 12 c0       	mov    %al,0xc0125aca
    str[3] = '\0';
c0106366:	c6 05 cb 5a 12 c0 00 	movb   $0x0,0xc0125acb
    return str;
c010636d:	b8 c8 5a 12 c0       	mov    $0xc0125ac8,%eax
}
c0106372:	5d                   	pop    %ebp
c0106373:	c3                   	ret    

c0106374 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106374:	55                   	push   %ebp
c0106375:	89 e5                	mov    %esp,%ebp
c0106377:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010637a:	8b 45 10             	mov    0x10(%ebp),%eax
c010637d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106380:	72 0a                	jb     c010638c <get_pgtable_items+0x18>
        return 0;
c0106382:	b8 00 00 00 00       	mov    $0x0,%eax
c0106387:	e9 9c 00 00 00       	jmp    c0106428 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010638c:	eb 04                	jmp    c0106392 <get_pgtable_items+0x1e>
        start ++;
c010638e:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106392:	8b 45 10             	mov    0x10(%ebp),%eax
c0106395:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106398:	73 18                	jae    c01063b2 <get_pgtable_items+0x3e>
c010639a:	8b 45 10             	mov    0x10(%ebp),%eax
c010639d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063a4:	8b 45 14             	mov    0x14(%ebp),%eax
c01063a7:	01 d0                	add    %edx,%eax
c01063a9:	8b 00                	mov    (%eax),%eax
c01063ab:	83 e0 01             	and    $0x1,%eax
c01063ae:	85 c0                	test   %eax,%eax
c01063b0:	74 dc                	je     c010638e <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c01063b2:	8b 45 10             	mov    0x10(%ebp),%eax
c01063b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063b8:	73 69                	jae    c0106423 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01063ba:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01063be:	74 08                	je     c01063c8 <get_pgtable_items+0x54>
            *left_store = start;
c01063c0:	8b 45 18             	mov    0x18(%ebp),%eax
c01063c3:	8b 55 10             	mov    0x10(%ebp),%edx
c01063c6:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01063c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01063cb:	8d 50 01             	lea    0x1(%eax),%edx
c01063ce:	89 55 10             	mov    %edx,0x10(%ebp)
c01063d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063d8:	8b 45 14             	mov    0x14(%ebp),%eax
c01063db:	01 d0                	add    %edx,%eax
c01063dd:	8b 00                	mov    (%eax),%eax
c01063df:	83 e0 07             	and    $0x7,%eax
c01063e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063e5:	eb 04                	jmp    c01063eb <get_pgtable_items+0x77>
            start ++;
c01063e7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01063eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01063ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01063f1:	73 1d                	jae    c0106410 <get_pgtable_items+0x9c>
c01063f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01063f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01063fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0106400:	01 d0                	add    %edx,%eax
c0106402:	8b 00                	mov    (%eax),%eax
c0106404:	83 e0 07             	and    $0x7,%eax
c0106407:	89 c2                	mov    %eax,%edx
c0106409:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010640c:	39 c2                	cmp    %eax,%edx
c010640e:	74 d7                	je     c01063e7 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0106410:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106414:	74 08                	je     c010641e <get_pgtable_items+0xaa>
            *right_store = start;
c0106416:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106419:	8b 55 10             	mov    0x10(%ebp),%edx
c010641c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010641e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106421:	eb 05                	jmp    c0106428 <get_pgtable_items+0xb4>
    }
    return 0;
c0106423:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106428:	c9                   	leave  
c0106429:	c3                   	ret    

c010642a <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c010642a:	55                   	push   %ebp
c010642b:	89 e5                	mov    %esp,%ebp
c010642d:	57                   	push   %edi
c010642e:	56                   	push   %esi
c010642f:	53                   	push   %ebx
c0106430:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106433:	c7 04 24 68 af 10 c0 	movl   $0xc010af68,(%esp)
c010643a:	e8 14 9f ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
c010643f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106446:	e9 fa 00 00 00       	jmp    c0106545 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010644b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010644e:	89 04 24             	mov    %eax,(%esp)
c0106451:	e8 d0 fe ff ff       	call   c0106326 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106456:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106459:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010645c:	29 d1                	sub    %edx,%ecx
c010645e:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106460:	89 d6                	mov    %edx,%esi
c0106462:	c1 e6 16             	shl    $0x16,%esi
c0106465:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106468:	89 d3                	mov    %edx,%ebx
c010646a:	c1 e3 16             	shl    $0x16,%ebx
c010646d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106470:	89 d1                	mov    %edx,%ecx
c0106472:	c1 e1 16             	shl    $0x16,%ecx
c0106475:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106478:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010647b:	29 d7                	sub    %edx,%edi
c010647d:	89 fa                	mov    %edi,%edx
c010647f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106483:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106487:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010648b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010648f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106493:	c7 04 24 99 af 10 c0 	movl   $0xc010af99,(%esp)
c010649a:	e8 b4 9e ff ff       	call   c0100353 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c010649f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01064a2:	c1 e0 0a             	shl    $0xa,%eax
c01064a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01064a8:	eb 54                	jmp    c01064fe <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01064aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064ad:	89 04 24             	mov    %eax,(%esp)
c01064b0:	e8 71 fe ff ff       	call   c0106326 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01064b5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01064b8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064bb:	29 d1                	sub    %edx,%ecx
c01064bd:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01064bf:	89 d6                	mov    %edx,%esi
c01064c1:	c1 e6 0c             	shl    $0xc,%esi
c01064c4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01064c7:	89 d3                	mov    %edx,%ebx
c01064c9:	c1 e3 0c             	shl    $0xc,%ebx
c01064cc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064cf:	c1 e2 0c             	shl    $0xc,%edx
c01064d2:	89 d1                	mov    %edx,%ecx
c01064d4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01064d7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01064da:	29 d7                	sub    %edx,%edi
c01064dc:	89 fa                	mov    %edi,%edx
c01064de:	89 44 24 14          	mov    %eax,0x14(%esp)
c01064e2:	89 74 24 10          	mov    %esi,0x10(%esp)
c01064e6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01064ea:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01064ee:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064f2:	c7 04 24 b8 af 10 c0 	movl   $0xc010afb8,(%esp)
c01064f9:	e8 55 9e ff ff       	call   c0100353 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01064fe:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0106503:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106506:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106509:	89 ce                	mov    %ecx,%esi
c010650b:	c1 e6 0a             	shl    $0xa,%esi
c010650e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106511:	89 cb                	mov    %ecx,%ebx
c0106513:	c1 e3 0a             	shl    $0xa,%ebx
c0106516:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106519:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010651d:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106520:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106524:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106528:	89 44 24 08          	mov    %eax,0x8(%esp)
c010652c:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106530:	89 1c 24             	mov    %ebx,(%esp)
c0106533:	e8 3c fe ff ff       	call   c0106374 <get_pgtable_items>
c0106538:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010653b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010653f:	0f 85 65 ff ff ff    	jne    c01064aa <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106545:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010654a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010654d:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106550:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106554:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106557:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010655b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010655f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106563:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010656a:	00 
c010656b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106572:	e8 fd fd ff ff       	call   c0106374 <get_pgtable_items>
c0106577:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010657a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010657e:	0f 85 c7 fe ff ff    	jne    c010644b <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106584:	c7 04 24 dc af 10 c0 	movl   $0xc010afdc,(%esp)
c010658b:	e8 c3 9d ff ff       	call   c0100353 <cprintf>
}
c0106590:	83 c4 4c             	add    $0x4c,%esp
c0106593:	5b                   	pop    %ebx
c0106594:	5e                   	pop    %esi
c0106595:	5f                   	pop    %edi
c0106596:	5d                   	pop    %ebp
c0106597:	c3                   	ret    

c0106598 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106598:	55                   	push   %ebp
c0106599:	89 e5                	mov    %esp,%ebp
c010659b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010659e:	8b 45 08             	mov    0x8(%ebp),%eax
c01065a1:	c1 e8 0c             	shr    $0xc,%eax
c01065a4:	89 c2                	mov    %eax,%edx
c01065a6:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01065ab:	39 c2                	cmp    %eax,%edx
c01065ad:	72 1c                	jb     c01065cb <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01065af:	c7 44 24 08 10 b0 10 	movl   $0xc010b010,0x8(%esp)
c01065b6:	c0 
c01065b7:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01065be:	00 
c01065bf:	c7 04 24 2f b0 10 c0 	movl   $0xc010b02f,(%esp)
c01065c6:	e8 12 a7 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01065cb:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01065d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01065d3:	c1 ea 0c             	shr    $0xc,%edx
c01065d6:	c1 e2 05             	shl    $0x5,%edx
c01065d9:	01 d0                	add    %edx,%eax
}
c01065db:	c9                   	leave  
c01065dc:	c3                   	ret    

c01065dd <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01065dd:	55                   	push   %ebp
c01065de:	89 e5                	mov    %esp,%ebp
c01065e0:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01065e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01065e6:	83 e0 01             	and    $0x1,%eax
c01065e9:	85 c0                	test   %eax,%eax
c01065eb:	75 1c                	jne    c0106609 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01065ed:	c7 44 24 08 40 b0 10 	movl   $0xc010b040,0x8(%esp)
c01065f4:	c0 
c01065f5:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01065fc:	00 
c01065fd:	c7 04 24 2f b0 10 c0 	movl   $0xc010b02f,(%esp)
c0106604:	e8 d4 a6 ff ff       	call   c0100cdd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106609:	8b 45 08             	mov    0x8(%ebp),%eax
c010660c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106611:	89 04 24             	mov    %eax,(%esp)
c0106614:	e8 7f ff ff ff       	call   c0106598 <pa2page>
}
c0106619:	c9                   	leave  
c010661a:	c3                   	ret    

c010661b <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010661b:	55                   	push   %ebp
c010661c:	89 e5                	mov    %esp,%ebp
c010661e:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106621:	e8 fc 1c 00 00       	call   c0108322 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106626:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c010662b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106630:	76 0c                	jbe    c010663e <swap_init+0x23>
c0106632:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106637:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c010663c:	76 25                	jbe    c0106663 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c010663e:	a1 dc 7b 12 c0       	mov    0xc0127bdc,%eax
c0106643:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106647:	c7 44 24 08 61 b0 10 	movl   $0xc010b061,0x8(%esp)
c010664e:	c0 
c010664f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c0106656:	00 
c0106657:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c010665e:	e8 7a a6 ff ff       	call   c0100cdd <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106663:	c7 05 d4 5a 12 c0 60 	movl   $0xc0124a60,0xc0125ad4
c010666a:	4a 12 c0 
     int r = sm->init();
c010666d:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106672:	8b 40 04             	mov    0x4(%eax),%eax
c0106675:	ff d0                	call   *%eax
c0106677:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c010667a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010667e:	75 26                	jne    c01066a6 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106680:	c7 05 cc 5a 12 c0 01 	movl   $0x1,0xc0125acc
c0106687:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c010668a:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010668f:	8b 00                	mov    (%eax),%eax
c0106691:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106695:	c7 04 24 8b b0 10 c0 	movl   $0xc010b08b,(%esp)
c010669c:	e8 b2 9c ff ff       	call   c0100353 <cprintf>
          check_swap();
c01066a1:	e8 a4 04 00 00       	call   c0106b4a <check_swap>
     }

     return r;
c01066a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01066a9:	c9                   	leave  
c01066aa:	c3                   	ret    

c01066ab <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c01066ab:	55                   	push   %ebp
c01066ac:	89 e5                	mov    %esp,%ebp
c01066ae:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c01066b1:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066b6:	8b 40 08             	mov    0x8(%eax),%eax
c01066b9:	8b 55 08             	mov    0x8(%ebp),%edx
c01066bc:	89 14 24             	mov    %edx,(%esp)
c01066bf:	ff d0                	call   *%eax
}
c01066c1:	c9                   	leave  
c01066c2:	c3                   	ret    

c01066c3 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c01066c3:	55                   	push   %ebp
c01066c4:	89 e5                	mov    %esp,%ebp
c01066c6:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c01066c9:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066ce:	8b 40 0c             	mov    0xc(%eax),%eax
c01066d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01066d4:	89 14 24             	mov    %edx,(%esp)
c01066d7:	ff d0                	call   *%eax
}
c01066d9:	c9                   	leave  
c01066da:	c3                   	ret    

c01066db <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01066db:	55                   	push   %ebp
c01066dc:	89 e5                	mov    %esp,%ebp
c01066de:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c01066e1:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c01066e6:	8b 40 10             	mov    0x10(%eax),%eax
c01066e9:	8b 55 14             	mov    0x14(%ebp),%edx
c01066ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01066f0:	8b 55 10             	mov    0x10(%ebp),%edx
c01066f3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01066f7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01066fa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01066fe:	8b 55 08             	mov    0x8(%ebp),%edx
c0106701:	89 14 24             	mov    %edx,(%esp)
c0106704:	ff d0                	call   *%eax
}
c0106706:	c9                   	leave  
c0106707:	c3                   	ret    

c0106708 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106708:	55                   	push   %ebp
c0106709:	89 e5                	mov    %esp,%ebp
c010670b:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010670e:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106713:	8b 40 14             	mov    0x14(%eax),%eax
c0106716:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106719:	89 54 24 04          	mov    %edx,0x4(%esp)
c010671d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106720:	89 14 24             	mov    %edx,(%esp)
c0106723:	ff d0                	call   *%eax
}
c0106725:	c9                   	leave  
c0106726:	c3                   	ret    

c0106727 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106727:	55                   	push   %ebp
c0106728:	89 e5                	mov    %esp,%ebp
c010672a:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c010672d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106734:	e9 5a 01 00 00       	jmp    c0106893 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106739:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c010673e:	8b 40 18             	mov    0x18(%eax),%eax
c0106741:	8b 55 10             	mov    0x10(%ebp),%edx
c0106744:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106748:	8d 55 e4             	lea    -0x1c(%ebp),%edx
c010674b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010674f:	8b 55 08             	mov    0x8(%ebp),%edx
c0106752:	89 14 24             	mov    %edx,(%esp)
c0106755:	ff d0                	call   *%eax
c0106757:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c010675a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010675e:	74 18                	je     c0106778 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106760:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106763:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106767:	c7 04 24 a0 b0 10 c0 	movl   $0xc010b0a0,(%esp)
c010676e:	e8 e0 9b ff ff       	call   c0100353 <cprintf>
c0106773:	e9 27 01 00 00       	jmp    c010689f <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010677b:	8b 40 1c             	mov    0x1c(%eax),%eax
c010677e:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106781:	8b 45 08             	mov    0x8(%ebp),%eax
c0106784:	8b 40 0c             	mov    0xc(%eax),%eax
c0106787:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010678e:	00 
c010678f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106792:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106796:	89 04 24             	mov    %eax,(%esp)
c0106799:	e8 2a ed ff ff       	call   c01054c8 <get_pte>
c010679e:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c01067a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01067a4:	8b 00                	mov    (%eax),%eax
c01067a6:	83 e0 01             	and    $0x1,%eax
c01067a9:	85 c0                	test   %eax,%eax
c01067ab:	75 24                	jne    c01067d1 <swap_out+0xaa>
c01067ad:	c7 44 24 0c cd b0 10 	movl   $0xc010b0cd,0xc(%esp)
c01067b4:	c0 
c01067b5:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01067bc:	c0 
c01067bd:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01067c4:	00 
c01067c5:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01067cc:	e8 0c a5 ff ff       	call   c0100cdd <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c01067d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01067d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01067d7:	8b 52 1c             	mov    0x1c(%edx),%edx
c01067da:	c1 ea 0c             	shr    $0xc,%edx
c01067dd:	83 c2 01             	add    $0x1,%edx
c01067e0:	c1 e2 08             	shl    $0x8,%edx
c01067e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067e7:	89 14 24             	mov    %edx,(%esp)
c01067ea:	e8 ed 1b 00 00       	call   c01083dc <swapfs_write>
c01067ef:	85 c0                	test   %eax,%eax
c01067f1:	74 34                	je     c0106827 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c01067f3:	c7 04 24 f7 b0 10 c0 	movl   $0xc010b0f7,(%esp)
c01067fa:	e8 54 9b ff ff       	call   c0100353 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c01067ff:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106804:	8b 40 10             	mov    0x10(%eax),%eax
c0106807:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010680a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106811:	00 
c0106812:	89 54 24 08          	mov    %edx,0x8(%esp)
c0106816:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106819:	89 54 24 04          	mov    %edx,0x4(%esp)
c010681d:	8b 55 08             	mov    0x8(%ebp),%edx
c0106820:	89 14 24             	mov    %edx,(%esp)
c0106823:	ff d0                	call   *%eax
c0106825:	eb 68                	jmp    c010688f <swap_out+0x168>
                    continue;
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0106827:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010682a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010682d:	c1 e8 0c             	shr    $0xc,%eax
c0106830:	83 c0 01             	add    $0x1,%eax
c0106833:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106837:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010683a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010683e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106841:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106845:	c7 04 24 10 b1 10 c0 	movl   $0xc010b110,(%esp)
c010684c:	e8 02 9b ff ff       	call   c0100353 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0106851:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106854:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106857:	c1 e8 0c             	shr    $0xc,%eax
c010685a:	83 c0 01             	add    $0x1,%eax
c010685d:	c1 e0 08             	shl    $0x8,%eax
c0106860:	89 c2                	mov    %eax,%edx
c0106862:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106865:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0106867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010686a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106871:	00 
c0106872:	89 04 24             	mov    %eax,(%esp)
c0106875:	e8 52 e5 ff ff       	call   c0104dcc <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c010687a:	8b 45 08             	mov    0x8(%ebp),%eax
c010687d:	8b 40 0c             	mov    0xc(%eax),%eax
c0106880:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106883:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106887:	89 04 24             	mov    %eax,(%esp)
c010688a:	e8 28 ef ff ff       	call   c01057b7 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010688f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106896:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106899:	0f 85 9a fe ff ff    	jne    c0106739 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010689f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01068a2:	c9                   	leave  
c01068a3:	c3                   	ret    

c01068a4 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01068a4:	55                   	push   %ebp
c01068a5:	89 e5                	mov    %esp,%ebp
c01068a7:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01068aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01068b1:	e8 ab e4 ff ff       	call   c0104d61 <alloc_pages>
c01068b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01068b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01068bd:	75 24                	jne    c01068e3 <swap_in+0x3f>
c01068bf:	c7 44 24 0c 50 b1 10 	movl   $0xc010b150,0xc(%esp)
c01068c6:	c0 
c01068c7:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01068ce:	c0 
c01068cf:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c01068d6:	00 
c01068d7:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01068de:	e8 fa a3 ff ff       	call   c0100cdd <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c01068e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01068e6:	8b 40 0c             	mov    0xc(%eax),%eax
c01068e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01068f0:	00 
c01068f1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01068f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01068f8:	89 04 24             	mov    %eax,(%esp)
c01068fb:	e8 c8 eb ff ff       	call   c01054c8 <get_pte>
c0106900:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106903:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106906:	8b 00                	mov    (%eax),%eax
c0106908:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010690b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010690f:	89 04 24             	mov    %eax,(%esp)
c0106912:	e8 53 1a 00 00       	call   c010836a <swapfs_read>
c0106917:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010691a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010691e:	74 2a                	je     c010694a <swap_in+0xa6>
     {
        assert(r!=0);
c0106920:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106924:	75 24                	jne    c010694a <swap_in+0xa6>
c0106926:	c7 44 24 0c 5d b1 10 	movl   $0xc010b15d,0xc(%esp)
c010692d:	c0 
c010692e:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106935:	c0 
c0106936:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c010693d:	00 
c010693e:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106945:	e8 93 a3 ff ff       	call   c0100cdd <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c010694a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010694d:	8b 00                	mov    (%eax),%eax
c010694f:	c1 e8 08             	shr    $0x8,%eax
c0106952:	89 c2                	mov    %eax,%edx
c0106954:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106957:	89 44 24 08          	mov    %eax,0x8(%esp)
c010695b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010695f:	c7 04 24 64 b1 10 c0 	movl   $0xc010b164,(%esp)
c0106966:	e8 e8 99 ff ff       	call   c0100353 <cprintf>
     *ptr_result=result;
c010696b:	8b 45 10             	mov    0x10(%ebp),%eax
c010696e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106971:	89 10                	mov    %edx,(%eax)
     return 0;
c0106973:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106978:	c9                   	leave  
c0106979:	c3                   	ret    

c010697a <check_content_set>:



static inline void
check_content_set(void)
{
c010697a:	55                   	push   %ebp
c010697b:	89 e5                	mov    %esp,%ebp
c010697d:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106980:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106985:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106988:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010698d:	83 f8 01             	cmp    $0x1,%eax
c0106990:	74 24                	je     c01069b6 <check_content_set+0x3c>
c0106992:	c7 44 24 0c a2 b1 10 	movl   $0xc010b1a2,0xc(%esp)
c0106999:	c0 
c010699a:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01069a1:	c0 
c01069a2:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c01069a9:	00 
c01069aa:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01069b1:	e8 27 a3 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01069b6:	b8 10 10 00 00       	mov    $0x1010,%eax
c01069bb:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01069be:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069c3:	83 f8 01             	cmp    $0x1,%eax
c01069c6:	74 24                	je     c01069ec <check_content_set+0x72>
c01069c8:	c7 44 24 0c a2 b1 10 	movl   $0xc010b1a2,0xc(%esp)
c01069cf:	c0 
c01069d0:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01069d7:	c0 
c01069d8:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01069df:	00 
c01069e0:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01069e7:	e8 f1 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c01069ec:	b8 00 20 00 00       	mov    $0x2000,%eax
c01069f1:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01069f4:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01069f9:	83 f8 02             	cmp    $0x2,%eax
c01069fc:	74 24                	je     c0106a22 <check_content_set+0xa8>
c01069fe:	c7 44 24 0c b1 b1 10 	movl   $0xc010b1b1,0xc(%esp)
c0106a05:	c0 
c0106a06:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a0d:	c0 
c0106a0e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106a15:	00 
c0106a16:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a1d:	e8 bb a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106a22:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106a27:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106a2a:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a2f:	83 f8 02             	cmp    $0x2,%eax
c0106a32:	74 24                	je     c0106a58 <check_content_set+0xde>
c0106a34:	c7 44 24 0c b1 b1 10 	movl   $0xc010b1b1,0xc(%esp)
c0106a3b:	c0 
c0106a3c:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a43:	c0 
c0106a44:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106a4b:	00 
c0106a4c:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a53:	e8 85 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106a58:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106a5d:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a60:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a65:	83 f8 03             	cmp    $0x3,%eax
c0106a68:	74 24                	je     c0106a8e <check_content_set+0x114>
c0106a6a:	c7 44 24 0c c0 b1 10 	movl   $0xc010b1c0,0xc(%esp)
c0106a71:	c0 
c0106a72:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106a79:	c0 
c0106a7a:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106a81:	00 
c0106a82:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106a89:	e8 4f a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106a8e:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106a93:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106a96:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106a9b:	83 f8 03             	cmp    $0x3,%eax
c0106a9e:	74 24                	je     c0106ac4 <check_content_set+0x14a>
c0106aa0:	c7 44 24 0c c0 b1 10 	movl   $0xc010b1c0,0xc(%esp)
c0106aa7:	c0 
c0106aa8:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106aaf:	c0 
c0106ab0:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106ab7:	00 
c0106ab8:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106abf:	e8 19 a2 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106ac4:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106ac9:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106acc:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106ad1:	83 f8 04             	cmp    $0x4,%eax
c0106ad4:	74 24                	je     c0106afa <check_content_set+0x180>
c0106ad6:	c7 44 24 0c cf b1 10 	movl   $0xc010b1cf,0xc(%esp)
c0106add:	c0 
c0106ade:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106ae5:	c0 
c0106ae6:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106aed:	00 
c0106aee:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106af5:	e8 e3 a1 ff ff       	call   c0100cdd <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106afa:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106aff:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106b02:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0106b07:	83 f8 04             	cmp    $0x4,%eax
c0106b0a:	74 24                	je     c0106b30 <check_content_set+0x1b6>
c0106b0c:	c7 44 24 0c cf b1 10 	movl   $0xc010b1cf,0xc(%esp)
c0106b13:	c0 
c0106b14:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106b1b:	c0 
c0106b1c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106b23:	00 
c0106b24:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106b2b:	e8 ad a1 ff ff       	call   c0100cdd <__panic>
}
c0106b30:	c9                   	leave  
c0106b31:	c3                   	ret    

c0106b32 <check_content_access>:

static inline int
check_content_access(void)
{
c0106b32:	55                   	push   %ebp
c0106b33:	89 e5                	mov    %esp,%ebp
c0106b35:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106b38:	a1 d4 5a 12 c0       	mov    0xc0125ad4,%eax
c0106b3d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106b40:	ff d0                	call   *%eax
c0106b42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106b48:	c9                   	leave  
c0106b49:	c3                   	ret    

c0106b4a <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106b4a:	55                   	push   %ebp
c0106b4b:	89 e5                	mov    %esp,%ebp
c0106b4d:	53                   	push   %ebx
c0106b4e:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106b51:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106b58:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106b5f:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106b66:	eb 6b                	jmp    c0106bd3 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106b68:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106b6b:	83 e8 0c             	sub    $0xc,%eax
c0106b6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106b74:	83 c0 04             	add    $0x4,%eax
c0106b77:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106b7e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106b81:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106b84:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106b87:	0f a3 10             	bt     %edx,(%eax)
c0106b8a:	19 c0                	sbb    %eax,%eax
c0106b8c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    return oldbit != 0;
c0106b8f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106b93:	0f 95 c0             	setne  %al
c0106b96:	0f b6 c0             	movzbl %al,%eax
c0106b99:	85 c0                	test   %eax,%eax
c0106b9b:	75 24                	jne    c0106bc1 <check_swap+0x77>
c0106b9d:	c7 44 24 0c de b1 10 	movl   $0xc010b1de,0xc(%esp)
c0106ba4:	c0 
c0106ba5:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106bac:	c0 
c0106bad:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106bb4:	00 
c0106bb5:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106bbc:	e8 1c a1 ff ff       	call   c0100cdd <__panic>
        count ++, total += p->property;
c0106bc1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106bc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106bc8:	8b 50 08             	mov    0x8(%eax),%edx
c0106bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106bce:	01 d0                	add    %edx,%eax
c0106bd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106bd6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106bd9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106bdc:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106bdf:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106be2:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0106be9:	0f 85 79 ff ff ff    	jne    c0106b68 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106bef:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106bf2:	e8 07 e2 ff ff       	call   c0104dfe <nr_free_pages>
c0106bf7:	39 c3                	cmp    %eax,%ebx
c0106bf9:	74 24                	je     c0106c1f <check_swap+0xd5>
c0106bfb:	c7 44 24 0c ee b1 10 	movl   $0xc010b1ee,0xc(%esp)
c0106c02:	c0 
c0106c03:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c0a:	c0 
c0106c0b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106c12:	00 
c0106c13:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c1a:	e8 be a0 ff ff       	call   c0100cdd <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106c22:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106c2d:	c7 04 24 08 b2 10 c0 	movl   $0xc010b208,(%esp)
c0106c34:	e8 1a 97 ff ff       	call   c0100353 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106c39:	e8 e5 09 00 00       	call   c0107623 <mm_create>
c0106c3e:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106c41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106c45:	75 24                	jne    c0106c6b <check_swap+0x121>
c0106c47:	c7 44 24 0c 2e b2 10 	movl   $0xc010b22e,0xc(%esp)
c0106c4e:	c0 
c0106c4f:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c56:	c0 
c0106c57:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106c5e:	00 
c0106c5f:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c66:	e8 72 a0 ff ff       	call   c0100cdd <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106c6b:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0106c70:	85 c0                	test   %eax,%eax
c0106c72:	74 24                	je     c0106c98 <check_swap+0x14e>
c0106c74:	c7 44 24 0c 39 b2 10 	movl   $0xc010b239,0xc(%esp)
c0106c7b:	c0 
c0106c7c:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106c83:	c0 
c0106c84:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106c8b:	00 
c0106c8c:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106c93:	e8 45 a0 ff ff       	call   c0100cdd <__panic>

     check_mm_struct = mm;
c0106c98:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c9b:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106ca0:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0106ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ca9:	89 50 0c             	mov    %edx,0xc(%eax)
c0106cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106caf:	8b 40 0c             	mov    0xc(%eax),%eax
c0106cb2:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106cb5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106cb8:	8b 00                	mov    (%eax),%eax
c0106cba:	85 c0                	test   %eax,%eax
c0106cbc:	74 24                	je     c0106ce2 <check_swap+0x198>
c0106cbe:	c7 44 24 0c 51 b2 10 	movl   $0xc010b251,0xc(%esp)
c0106cc5:	c0 
c0106cc6:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106ccd:	c0 
c0106cce:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106cd5:	00 
c0106cd6:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106cdd:	e8 fb 9f ff ff       	call   c0100cdd <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106ce2:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106ce9:	00 
c0106cea:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106cf1:	00 
c0106cf2:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106cf9:	e8 9d 09 00 00       	call   c010769b <vma_create>
c0106cfe:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106d01:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106d05:	75 24                	jne    c0106d2b <check_swap+0x1e1>
c0106d07:	c7 44 24 0c 5f b2 10 	movl   $0xc010b25f,0xc(%esp)
c0106d0e:	c0 
c0106d0f:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106d16:	c0 
c0106d17:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106d1e:	00 
c0106d1f:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106d26:	e8 b2 9f ff ff       	call   c0100cdd <__panic>

     insert_vma_struct(mm, vma);
c0106d2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d32:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d35:	89 04 24             	mov    %eax,(%esp)
c0106d38:	e8 ee 0a 00 00       	call   c010782b <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106d3d:	c7 04 24 6c b2 10 c0 	movl   $0xc010b26c,(%esp)
c0106d44:	e8 0a 96 ff ff       	call   c0100353 <cprintf>
     pte_t *temp_ptep=NULL;
c0106d49:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106d50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106d53:	8b 40 0c             	mov    0xc(%eax),%eax
c0106d56:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106d5d:	00 
c0106d5e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106d65:	00 
c0106d66:	89 04 24             	mov    %eax,(%esp)
c0106d69:	e8 5a e7 ff ff       	call   c01054c8 <get_pte>
c0106d6e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106d71:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106d75:	75 24                	jne    c0106d9b <check_swap+0x251>
c0106d77:	c7 44 24 0c a0 b2 10 	movl   $0xc010b2a0,0xc(%esp)
c0106d7e:	c0 
c0106d7f:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106d86:	c0 
c0106d87:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106d8e:	00 
c0106d8f:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106d96:	e8 42 9f ff ff       	call   c0100cdd <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106d9b:	c7 04 24 b4 b2 10 c0 	movl   $0xc010b2b4,(%esp)
c0106da2:	e8 ac 95 ff ff       	call   c0100353 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106da7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106dae:	e9 a3 00 00 00       	jmp    c0106e56 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106db3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106dba:	e8 a2 df ff ff       	call   c0104d61 <alloc_pages>
c0106dbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106dc2:	89 04 95 40 7b 12 c0 	mov    %eax,-0x3fed84c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106dc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dcc:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106dd3:	85 c0                	test   %eax,%eax
c0106dd5:	75 24                	jne    c0106dfb <check_swap+0x2b1>
c0106dd7:	c7 44 24 0c d8 b2 10 	movl   $0xc010b2d8,0xc(%esp)
c0106dde:	c0 
c0106ddf:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106de6:	c0 
c0106de7:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106dee:	00 
c0106def:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106df6:	e8 e2 9e ff ff       	call   c0100cdd <__panic>
          assert(!PageProperty(check_rp[i]));
c0106dfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dfe:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106e05:	83 c0 04             	add    $0x4,%eax
c0106e08:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106e0f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106e12:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106e15:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106e18:	0f a3 10             	bt     %edx,(%eax)
c0106e1b:	19 c0                	sbb    %eax,%eax
c0106e1d:	89 45 ac             	mov    %eax,-0x54(%ebp)
    return oldbit != 0;
c0106e20:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106e24:	0f 95 c0             	setne  %al
c0106e27:	0f b6 c0             	movzbl %al,%eax
c0106e2a:	85 c0                	test   %eax,%eax
c0106e2c:	74 24                	je     c0106e52 <check_swap+0x308>
c0106e2e:	c7 44 24 0c ec b2 10 	movl   $0xc010b2ec,0xc(%esp)
c0106e35:	c0 
c0106e36:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106e3d:	c0 
c0106e3e:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106e45:	00 
c0106e46:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106e4d:	e8 8b 9e ff ff       	call   c0100cdd <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106e52:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106e56:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106e5a:	0f 8e 53 ff ff ff    	jle    c0106db3 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106e60:	a1 18 7b 12 c0       	mov    0xc0127b18,%eax
c0106e65:	8b 15 1c 7b 12 c0    	mov    0xc0127b1c,%edx
c0106e6b:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106e6e:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106e71:	c7 45 a8 18 7b 12 c0 	movl   $0xc0127b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106e78:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e7b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106e7e:	89 50 04             	mov    %edx,0x4(%eax)
c0106e81:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e84:	8b 50 04             	mov    0x4(%eax),%edx
c0106e87:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106e8a:	89 10                	mov    %edx,(%eax)
c0106e8c:	c7 45 a4 18 7b 12 c0 	movl   $0xc0127b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106e93:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106e96:	8b 40 04             	mov    0x4(%eax),%eax
c0106e99:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106e9c:	0f 94 c0             	sete   %al
c0106e9f:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106ea2:	85 c0                	test   %eax,%eax
c0106ea4:	75 24                	jne    c0106eca <check_swap+0x380>
c0106ea6:	c7 44 24 0c 07 b3 10 	movl   $0xc010b307,0xc(%esp)
c0106ead:	c0 
c0106eae:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106eb5:	c0 
c0106eb6:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106ebd:	00 
c0106ebe:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106ec5:	e8 13 9e ff ff       	call   c0100cdd <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106eca:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106ecf:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106ed2:	c7 05 20 7b 12 c0 00 	movl   $0x0,0xc0127b20
c0106ed9:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106edc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106ee3:	eb 1e                	jmp    c0106f03 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106ee5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ee8:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0106eef:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106ef6:	00 
c0106ef7:	89 04 24             	mov    %eax,(%esp)
c0106efa:	e8 cd de ff ff       	call   c0104dcc <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106eff:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106f03:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106f07:	7e dc                	jle    c0106ee5 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106f09:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f0e:	83 f8 04             	cmp    $0x4,%eax
c0106f11:	74 24                	je     c0106f37 <check_swap+0x3ed>
c0106f13:	c7 44 24 0c 20 b3 10 	movl   $0xc010b320,0xc(%esp)
c0106f1a:	c0 
c0106f1b:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106f22:	c0 
c0106f23:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106f2a:	00 
c0106f2b:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106f32:	e8 a6 9d ff ff       	call   c0100cdd <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106f37:	c7 04 24 44 b3 10 c0 	movl   $0xc010b344,(%esp)
c0106f3e:	e8 10 94 ff ff       	call   c0100353 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106f43:	c7 05 d8 5a 12 c0 00 	movl   $0x0,0xc0125ad8
c0106f4a:	00 00 00 
     
     check_content_set();
c0106f4d:	e8 28 fa ff ff       	call   c010697a <check_content_set>
     assert( nr_free == 0);         
c0106f52:	a1 20 7b 12 c0       	mov    0xc0127b20,%eax
c0106f57:	85 c0                	test   %eax,%eax
c0106f59:	74 24                	je     c0106f7f <check_swap+0x435>
c0106f5b:	c7 44 24 0c 6b b3 10 	movl   $0xc010b36b,0xc(%esp)
c0106f62:	c0 
c0106f63:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0106f6a:	c0 
c0106f6b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106f72:	00 
c0106f73:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0106f7a:	e8 5e 9d ff ff       	call   c0100cdd <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106f7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f86:	eb 26                	jmp    c0106fae <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f8b:	c7 04 85 60 7b 12 c0 	movl   $0xffffffff,-0x3fed84a0(,%eax,4)
c0106f92:	ff ff ff ff 
c0106f96:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f99:	8b 14 85 60 7b 12 c0 	mov    -0x3fed84a0(,%eax,4),%edx
c0106fa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fa3:	89 14 85 a0 7b 12 c0 	mov    %edx,-0x3fed8460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106faa:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106fae:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106fb2:	7e d4                	jle    c0106f88 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106fb4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106fbb:	e9 eb 00 00 00       	jmp    c01070ab <check_swap+0x561>
         check_ptep[i]=0;
c0106fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fc3:	c7 04 85 f4 7b 12 c0 	movl   $0x0,-0x3fed840c(,%eax,4)
c0106fca:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106fce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106fd1:	83 c0 01             	add    $0x1,%eax
c0106fd4:	c1 e0 0c             	shl    $0xc,%eax
c0106fd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fde:	00 
c0106fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106fe3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106fe6:	89 04 24             	mov    %eax,(%esp)
c0106fe9:	e8 da e4 ff ff       	call   c01054c8 <get_pte>
c0106fee:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106ff1:	89 04 95 f4 7b 12 c0 	mov    %eax,-0x3fed840c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106ffb:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107002:	85 c0                	test   %eax,%eax
c0107004:	75 24                	jne    c010702a <check_swap+0x4e0>
c0107006:	c7 44 24 0c 78 b3 10 	movl   $0xc010b378,0xc(%esp)
c010700d:	c0 
c010700e:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0107015:	c0 
c0107016:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010701d:	00 
c010701e:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c0107025:	e8 b3 9c ff ff       	call   c0100cdd <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010702a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010702d:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c0107034:	8b 00                	mov    (%eax),%eax
c0107036:	89 04 24             	mov    %eax,(%esp)
c0107039:	e8 9f f5 ff ff       	call   c01065dd <pte2page>
c010703e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107041:	8b 14 95 40 7b 12 c0 	mov    -0x3fed84c0(,%edx,4),%edx
c0107048:	39 d0                	cmp    %edx,%eax
c010704a:	74 24                	je     c0107070 <check_swap+0x526>
c010704c:	c7 44 24 0c 90 b3 10 	movl   $0xc010b390,0xc(%esp)
c0107053:	c0 
c0107054:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c010705b:	c0 
c010705c:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0107063:	00 
c0107064:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c010706b:	e8 6d 9c ff ff       	call   c0100cdd <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107070:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107073:	8b 04 85 f4 7b 12 c0 	mov    -0x3fed840c(,%eax,4),%eax
c010707a:	8b 00                	mov    (%eax),%eax
c010707c:	83 e0 01             	and    $0x1,%eax
c010707f:	85 c0                	test   %eax,%eax
c0107081:	75 24                	jne    c01070a7 <check_swap+0x55d>
c0107083:	c7 44 24 0c b8 b3 10 	movl   $0xc010b3b8,0xc(%esp)
c010708a:	c0 
c010708b:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c0107092:	c0 
c0107093:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010709a:	00 
c010709b:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01070a2:	e8 36 9c ff ff       	call   c0100cdd <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070a7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01070ab:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01070af:	0f 8e 0b ff ff ff    	jle    c0106fc0 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01070b5:	c7 04 24 d4 b3 10 c0 	movl   $0xc010b3d4,(%esp)
c01070bc:	e8 92 92 ff ff       	call   c0100353 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01070c1:	e8 6c fa ff ff       	call   c0106b32 <check_content_access>
c01070c6:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01070c9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01070cd:	74 24                	je     c01070f3 <check_swap+0x5a9>
c01070cf:	c7 44 24 0c fa b3 10 	movl   $0xc010b3fa,0xc(%esp)
c01070d6:	c0 
c01070d7:	c7 44 24 08 e2 b0 10 	movl   $0xc010b0e2,0x8(%esp)
c01070de:	c0 
c01070df:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01070e6:	00 
c01070e7:	c7 04 24 7c b0 10 c0 	movl   $0xc010b07c,(%esp)
c01070ee:	e8 ea 9b ff ff       	call   c0100cdd <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01070f3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01070fa:	eb 1e                	jmp    c010711a <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c01070fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01070ff:	8b 04 85 40 7b 12 c0 	mov    -0x3fed84c0(,%eax,4),%eax
c0107106:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010710d:	00 
c010710e:	89 04 24             	mov    %eax,(%esp)
c0107111:	e8 b6 dc ff ff       	call   c0104dcc <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107116:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010711a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010711e:	7e dc                	jle    c01070fc <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0107120:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107123:	89 04 24             	mov    %eax,(%esp)
c0107126:	e8 30 08 00 00       	call   c010795b <mm_destroy>
         
     nr_free = nr_free_store;
c010712b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010712e:	a3 20 7b 12 c0       	mov    %eax,0xc0127b20
     free_list = free_list_store;
c0107133:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107136:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107139:	a3 18 7b 12 c0       	mov    %eax,0xc0127b18
c010713e:	89 15 1c 7b 12 c0    	mov    %edx,0xc0127b1c

     
     le = &free_list;
c0107144:	c7 45 e8 18 7b 12 c0 	movl   $0xc0127b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c010714b:	eb 1d                	jmp    c010716a <check_swap+0x620>
         struct Page *p = le2page(le, page_link);
c010714d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107150:	83 e8 0c             	sub    $0xc,%eax
c0107153:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0107156:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010715a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010715d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107160:	8b 40 08             	mov    0x8(%eax),%eax
c0107163:	29 c2                	sub    %eax,%edx
c0107165:	89 d0                	mov    %edx,%eax
c0107167:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010716a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010716d:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107170:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0107173:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0107176:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107179:	81 7d e8 18 7b 12 c0 	cmpl   $0xc0127b18,-0x18(%ebp)
c0107180:	75 cb                	jne    c010714d <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107182:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107185:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107189:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010718c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107190:	c7 04 24 01 b4 10 c0 	movl   $0xc010b401,(%esp)
c0107197:	e8 b7 91 ff ff       	call   c0100353 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010719c:	c7 04 24 1b b4 10 c0 	movl   $0xc010b41b,(%esp)
c01071a3:	e8 ab 91 ff ff       	call   c0100353 <cprintf>
}
c01071a8:	83 c4 74             	add    $0x74,%esp
c01071ab:	5b                   	pop    %ebx
c01071ac:	5d                   	pop    %ebp
c01071ad:	c3                   	ret    

c01071ae <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c01071ae:	55                   	push   %ebp
c01071af:	89 e5                	mov    %esp,%ebp
c01071b1:	83 ec 10             	sub    $0x10,%esp
c01071b4:	c7 45 fc 04 7c 12 c0 	movl   $0xc0127c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01071bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071be:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01071c1:	89 50 04             	mov    %edx,0x4(%eax)
c01071c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071c7:	8b 50 04             	mov    0x4(%eax),%edx
c01071ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01071cd:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c01071cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01071d2:	c7 40 14 04 7c 12 c0 	movl   $0xc0127c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c01071d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01071de:	c9                   	leave  
c01071df:	c3                   	ret    

c01071e0 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c01071e0:	55                   	push   %ebp
c01071e1:	89 e5                	mov    %esp,%ebp
c01071e3:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01071e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01071e9:	8b 40 14             	mov    0x14(%eax),%eax
c01071ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c01071ef:	8b 45 10             	mov    0x10(%ebp),%eax
c01071f2:	83 c0 14             	add    $0x14,%eax
c01071f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c01071f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01071fc:	74 06                	je     c0107204 <_fifo_map_swappable+0x24>
c01071fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107202:	75 24                	jne    c0107228 <_fifo_map_swappable+0x48>
c0107204:	c7 44 24 0c 34 b4 10 	movl   $0xc010b434,0xc(%esp)
c010720b:	c0 
c010720c:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107213:	c0 
c0107214:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010721b:	00 
c010721c:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107223:	e8 b5 9a ff ff       	call   c0100cdd <__panic>
c0107228:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010722b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010722e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107231:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0107234:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107237:	8b 00                	mov    (%eax),%eax
c0107239:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010723c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c010723f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107242:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107245:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107248:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010724b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010724e:	89 10                	mov    %edx,(%eax)
c0107250:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107253:	8b 10                	mov    (%eax),%edx
c0107255:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107258:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010725b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010725e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107261:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107267:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010726a:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2012011394*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);
    return 0;
c010726c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107271:	c9                   	leave  
c0107272:	c3                   	ret    

c0107273 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107273:	55                   	push   %ebp
c0107274:	89 e5                	mov    %esp,%ebp
c0107276:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107279:	8b 45 08             	mov    0x8(%ebp),%eax
c010727c:	8b 40 14             	mov    0x14(%eax),%eax
c010727f:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107286:	75 24                	jne    c01072ac <_fifo_swap_out_victim+0x39>
c0107288:	c7 44 24 0c 7b b4 10 	movl   $0xc010b47b,0xc(%esp)
c010728f:	c0 
c0107290:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107297:	c0 
c0107298:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c010729f:	00 
c01072a0:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01072a7:	e8 31 9a ff ff       	call   c0100cdd <__panic>
     assert(in_tick==0);
c01072ac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01072b0:	74 24                	je     c01072d6 <_fifo_swap_out_victim+0x63>
c01072b2:	c7 44 24 0c 88 b4 10 	movl   $0xc010b488,0xc(%esp)
c01072b9:	c0 
c01072ba:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01072c1:	c0 
c01072c2:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c01072c9:	00 
c01072ca:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01072d1:	e8 07 9a ff ff       	call   c0100cdd <__panic>
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2012011394*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t* item = head->next;
c01072d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072d9:	8b 40 04             	mov    0x4(%eax),%eax
c01072dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
     struct Page* page = le2page(item, pra_page_link);
c01072df:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072e2:	83 e8 14             	sub    $0x14,%eax
c01072e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01072e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01072ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072f1:	8b 40 04             	mov    0x4(%eax),%eax
c01072f4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01072f7:	8b 12                	mov    (%edx),%edx
c01072f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01072fc:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01072ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107302:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107305:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107308:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010730b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010730e:	89 10                	mov    %edx,(%eax)
     list_del(item);
     *ptr_page = page;
c0107310:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107313:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107316:	89 10                	mov    %edx,(%eax)
     return 0;
c0107318:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010731d:	c9                   	leave  
c010731e:	c3                   	ret    

c010731f <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c010731f:	55                   	push   %ebp
c0107320:	89 e5                	mov    %esp,%ebp
c0107322:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107325:	c7 04 24 94 b4 10 c0 	movl   $0xc010b494,(%esp)
c010732c:	e8 22 90 ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107331:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107336:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107339:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010733e:	83 f8 04             	cmp    $0x4,%eax
c0107341:	74 24                	je     c0107367 <_fifo_check_swap+0x48>
c0107343:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c010734a:	c0 
c010734b:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107352:	c0 
c0107353:	c7 44 24 04 52 00 00 	movl   $0x52,0x4(%esp)
c010735a:	00 
c010735b:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107362:	e8 76 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107367:	c7 04 24 cc b4 10 c0 	movl   $0xc010b4cc,(%esp)
c010736e:	e8 e0 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107373:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107378:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c010737b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107380:	83 f8 04             	cmp    $0x4,%eax
c0107383:	74 24                	je     c01073a9 <_fifo_check_swap+0x8a>
c0107385:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c010738c:	c0 
c010738d:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107394:	c0 
c0107395:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c010739c:	00 
c010739d:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01073a4:	e8 34 99 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c01073a9:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c01073b0:	e8 9e 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c01073b5:	b8 00 40 00 00       	mov    $0x4000,%eax
c01073ba:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c01073bd:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01073c2:	83 f8 04             	cmp    $0x4,%eax
c01073c5:	74 24                	je     c01073eb <_fifo_check_swap+0xcc>
c01073c7:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c01073ce:	c0 
c01073cf:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01073d6:	c0 
c01073d7:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
c01073de:	00 
c01073df:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01073e6:	e8 f2 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01073eb:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c01073f2:	e8 5c 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01073f7:	b8 00 20 00 00       	mov    $0x2000,%eax
c01073fc:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01073ff:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107404:	83 f8 04             	cmp    $0x4,%eax
c0107407:	74 24                	je     c010742d <_fifo_check_swap+0x10e>
c0107409:	c7 44 24 0c ba b4 10 	movl   $0xc010b4ba,0xc(%esp)
c0107410:	c0 
c0107411:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107418:	c0 
c0107419:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c0107420:	00 
c0107421:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107428:	e8 b0 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010742d:	c7 04 24 44 b5 10 c0 	movl   $0xc010b544,(%esp)
c0107434:	e8 1a 8f ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107439:	b8 00 50 00 00       	mov    $0x5000,%eax
c010743e:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107441:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107446:	83 f8 05             	cmp    $0x5,%eax
c0107449:	74 24                	je     c010746f <_fifo_check_swap+0x150>
c010744b:	c7 44 24 0c 6a b5 10 	movl   $0xc010b56a,0xc(%esp)
c0107452:	c0 
c0107453:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c010745a:	c0 
c010745b:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107462:	00 
c0107463:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c010746a:	e8 6e 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010746f:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c0107476:	e8 d8 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c010747b:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107480:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107483:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107488:	83 f8 05             	cmp    $0x5,%eax
c010748b:	74 24                	je     c01074b1 <_fifo_check_swap+0x192>
c010748d:	c7 44 24 0c 6a b5 10 	movl   $0xc010b56a,0xc(%esp)
c0107494:	c0 
c0107495:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c010749c:	c0 
c010749d:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01074a4:	00 
c01074a5:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01074ac:	e8 2c 98 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01074b1:	c7 04 24 cc b4 10 c0 	movl   $0xc010b4cc,(%esp)
c01074b8:	e8 96 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01074bd:	b8 00 10 00 00       	mov    $0x1000,%eax
c01074c2:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01074c5:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c01074ca:	83 f8 06             	cmp    $0x6,%eax
c01074cd:	74 24                	je     c01074f3 <_fifo_check_swap+0x1d4>
c01074cf:	c7 44 24 0c 79 b5 10 	movl   $0xc010b579,0xc(%esp)
c01074d6:	c0 
c01074d7:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01074de:	c0 
c01074df:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01074e6:	00 
c01074e7:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01074ee:	e8 ea 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01074f3:	c7 04 24 1c b5 10 c0 	movl   $0xc010b51c,(%esp)
c01074fa:	e8 54 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01074ff:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107504:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107507:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010750c:	83 f8 07             	cmp    $0x7,%eax
c010750f:	74 24                	je     c0107535 <_fifo_check_swap+0x216>
c0107511:	c7 44 24 0c 88 b5 10 	movl   $0xc010b588,0xc(%esp)
c0107518:	c0 
c0107519:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107520:	c0 
c0107521:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0107528:	00 
c0107529:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107530:	e8 a8 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107535:	c7 04 24 94 b4 10 c0 	movl   $0xc010b494,(%esp)
c010753c:	e8 12 8e ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107541:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107546:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107549:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c010754e:	83 f8 08             	cmp    $0x8,%eax
c0107551:	74 24                	je     c0107577 <_fifo_check_swap+0x258>
c0107553:	c7 44 24 0c 97 b5 10 	movl   $0xc010b597,0xc(%esp)
c010755a:	c0 
c010755b:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c0107562:	c0 
c0107563:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010756a:	00 
c010756b:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c0107572:	e8 66 97 ff ff       	call   c0100cdd <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107577:	c7 04 24 f4 b4 10 c0 	movl   $0xc010b4f4,(%esp)
c010757e:	e8 d0 8d ff ff       	call   c0100353 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107583:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107588:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c010758b:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0107590:	83 f8 09             	cmp    $0x9,%eax
c0107593:	74 24                	je     c01075b9 <_fifo_check_swap+0x29a>
c0107595:	c7 44 24 0c a6 b5 10 	movl   $0xc010b5a6,0xc(%esp)
c010759c:	c0 
c010759d:	c7 44 24 08 52 b4 10 	movl   $0xc010b452,0x8(%esp)
c01075a4:	c0 
c01075a5:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01075ac:	00 
c01075ad:	c7 04 24 67 b4 10 c0 	movl   $0xc010b467,(%esp)
c01075b4:	e8 24 97 ff ff       	call   c0100cdd <__panic>
    return 0;
c01075b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075be:	c9                   	leave  
c01075bf:	c3                   	ret    

c01075c0 <_fifo_init>:


static int
_fifo_init(void)
{
c01075c0:	55                   	push   %ebp
c01075c1:	89 e5                	mov    %esp,%ebp
    return 0;
c01075c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075c8:	5d                   	pop    %ebp
c01075c9:	c3                   	ret    

c01075ca <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c01075ca:	55                   	push   %ebp
c01075cb:	89 e5                	mov    %esp,%ebp
    return 0;
c01075cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01075d2:	5d                   	pop    %ebp
c01075d3:	c3                   	ret    

c01075d4 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c01075d4:	55                   	push   %ebp
c01075d5:	89 e5                	mov    %esp,%ebp
c01075d7:	b8 00 00 00 00       	mov    $0x0,%eax
c01075dc:	5d                   	pop    %ebp
c01075dd:	c3                   	ret    

c01075de <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c01075de:	55                   	push   %ebp
c01075df:	89 e5                	mov    %esp,%ebp
c01075e1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01075e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01075e7:	c1 e8 0c             	shr    $0xc,%eax
c01075ea:	89 c2                	mov    %eax,%edx
c01075ec:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01075f1:	39 c2                	cmp    %eax,%edx
c01075f3:	72 1c                	jb     c0107611 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01075f5:	c7 44 24 08 c8 b5 10 	movl   $0xc010b5c8,0x8(%esp)
c01075fc:	c0 
c01075fd:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107604:	00 
c0107605:	c7 04 24 e7 b5 10 c0 	movl   $0xc010b5e7,(%esp)
c010760c:	e8 cc 96 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c0107611:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c0107616:	8b 55 08             	mov    0x8(%ebp),%edx
c0107619:	c1 ea 0c             	shr    $0xc,%edx
c010761c:	c1 e2 05             	shl    $0x5,%edx
c010761f:	01 d0                	add    %edx,%eax
}
c0107621:	c9                   	leave  
c0107622:	c3                   	ret    

c0107623 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107623:	55                   	push   %ebp
c0107624:	89 e5                	mov    %esp,%ebp
c0107626:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107629:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107630:	e8 cf d2 ff ff       	call   c0104904 <kmalloc>
c0107635:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010763c:	74 58                	je     c0107696 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c010763e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107641:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107644:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107647:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010764a:	89 50 04             	mov    %edx,0x4(%eax)
c010764d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107650:	8b 50 04             	mov    0x4(%eax),%edx
c0107653:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107656:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107658:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010765b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107662:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107665:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c010766c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010766f:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107676:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c010767b:	85 c0                	test   %eax,%eax
c010767d:	74 0d                	je     c010768c <mm_create+0x69>
c010767f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107682:	89 04 24             	mov    %eax,(%esp)
c0107685:	e8 21 f0 ff ff       	call   c01066ab <swap_init_mm>
c010768a:	eb 0a                	jmp    c0107696 <mm_create+0x73>
        else mm->sm_priv = NULL;
c010768c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010768f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107696:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107699:	c9                   	leave  
c010769a:	c3                   	ret    

c010769b <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c010769b:	55                   	push   %ebp
c010769c:	89 e5                	mov    %esp,%ebp
c010769e:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c01076a1:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01076a8:	e8 57 d2 ff ff       	call   c0104904 <kmalloc>
c01076ad:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c01076b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01076b4:	74 1b                	je     c01076d1 <vma_create+0x36>
        vma->vm_start = vm_start;
c01076b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076b9:	8b 55 08             	mov    0x8(%ebp),%edx
c01076bc:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c01076bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076c2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01076c5:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c01076c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01076cb:	8b 55 10             	mov    0x10(%ebp),%edx
c01076ce:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c01076d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01076d4:	c9                   	leave  
c01076d5:	c3                   	ret    

c01076d6 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01076d6:	55                   	push   %ebp
c01076d7:	89 e5                	mov    %esp,%ebp
c01076d9:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01076dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01076e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01076e7:	0f 84 95 00 00 00    	je     c0107782 <find_vma+0xac>
        vma = mm->mmap_cache;
c01076ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01076f0:	8b 40 08             	mov    0x8(%eax),%eax
c01076f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01076f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01076fa:	74 16                	je     c0107712 <find_vma+0x3c>
c01076fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01076ff:	8b 40 04             	mov    0x4(%eax),%eax
c0107702:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107705:	77 0b                	ja     c0107712 <find_vma+0x3c>
c0107707:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010770a:	8b 40 08             	mov    0x8(%eax),%eax
c010770d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107710:	77 61                	ja     c0107773 <find_vma+0x9d>
                bool found = 0;
c0107712:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c0107719:	8b 45 08             	mov    0x8(%ebp),%eax
c010771c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010771f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107722:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c0107725:	eb 28                	jmp    c010774f <find_vma+0x79>
                    vma = le2vma(le, list_link);
c0107727:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010772a:	83 e8 10             	sub    $0x10,%eax
c010772d:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c0107730:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107733:	8b 40 04             	mov    0x4(%eax),%eax
c0107736:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107739:	77 14                	ja     c010774f <find_vma+0x79>
c010773b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010773e:	8b 40 08             	mov    0x8(%eax),%eax
c0107741:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0107744:	76 09                	jbe    c010774f <find_vma+0x79>
                        found = 1;
c0107746:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010774d:	eb 17                	jmp    c0107766 <find_vma+0x90>
c010774f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107752:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107755:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107758:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c010775b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010775e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107761:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107764:	75 c1                	jne    c0107727 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107766:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010776a:	75 07                	jne    c0107773 <find_vma+0x9d>
                    vma = NULL;
c010776c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107773:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107777:	74 09                	je     c0107782 <find_vma+0xac>
            mm->mmap_cache = vma;
c0107779:	8b 45 08             	mov    0x8(%ebp),%eax
c010777c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010777f:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107782:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107785:	c9                   	leave  
c0107786:	c3                   	ret    

c0107787 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107787:	55                   	push   %ebp
c0107788:	89 e5                	mov    %esp,%ebp
c010778a:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010778d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107790:	8b 50 04             	mov    0x4(%eax),%edx
c0107793:	8b 45 08             	mov    0x8(%ebp),%eax
c0107796:	8b 40 08             	mov    0x8(%eax),%eax
c0107799:	39 c2                	cmp    %eax,%edx
c010779b:	72 24                	jb     c01077c1 <check_vma_overlap+0x3a>
c010779d:	c7 44 24 0c f5 b5 10 	movl   $0xc010b5f5,0xc(%esp)
c01077a4:	c0 
c01077a5:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01077ac:	c0 
c01077ad:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c01077b4:	00 
c01077b5:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c01077bc:	e8 1c 95 ff ff       	call   c0100cdd <__panic>
    assert(prev->vm_end <= next->vm_start);
c01077c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01077c4:	8b 50 08             	mov    0x8(%eax),%edx
c01077c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077ca:	8b 40 04             	mov    0x4(%eax),%eax
c01077cd:	39 c2                	cmp    %eax,%edx
c01077cf:	76 24                	jbe    c01077f5 <check_vma_overlap+0x6e>
c01077d1:	c7 44 24 0c 38 b6 10 	movl   $0xc010b638,0xc(%esp)
c01077d8:	c0 
c01077d9:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01077e0:	c0 
c01077e1:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01077e8:	00 
c01077e9:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c01077f0:	e8 e8 94 ff ff       	call   c0100cdd <__panic>
    assert(next->vm_start < next->vm_end);
c01077f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077f8:	8b 50 04             	mov    0x4(%eax),%edx
c01077fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01077fe:	8b 40 08             	mov    0x8(%eax),%eax
c0107801:	39 c2                	cmp    %eax,%edx
c0107803:	72 24                	jb     c0107829 <check_vma_overlap+0xa2>
c0107805:	c7 44 24 0c 57 b6 10 	movl   $0xc010b657,0xc(%esp)
c010780c:	c0 
c010780d:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107814:	c0 
c0107815:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010781c:	00 
c010781d:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107824:	e8 b4 94 ff ff       	call   c0100cdd <__panic>
}
c0107829:	c9                   	leave  
c010782a:	c3                   	ret    

c010782b <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c010782b:	55                   	push   %ebp
c010782c:	89 e5                	mov    %esp,%ebp
c010782e:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107831:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107834:	8b 50 04             	mov    0x4(%eax),%edx
c0107837:	8b 45 0c             	mov    0xc(%ebp),%eax
c010783a:	8b 40 08             	mov    0x8(%eax),%eax
c010783d:	39 c2                	cmp    %eax,%edx
c010783f:	72 24                	jb     c0107865 <insert_vma_struct+0x3a>
c0107841:	c7 44 24 0c 75 b6 10 	movl   $0xc010b675,0xc(%esp)
c0107848:	c0 
c0107849:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107850:	c0 
c0107851:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0107858:	00 
c0107859:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107860:	e8 78 94 ff ff       	call   c0100cdd <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107865:	8b 45 08             	mov    0x8(%ebp),%eax
c0107868:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c010786b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010786e:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107871:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107874:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107877:	eb 21                	jmp    c010789a <insert_vma_struct+0x6f>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107879:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010787c:	83 e8 10             	sub    $0x10,%eax
c010787f:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107882:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107885:	8b 50 04             	mov    0x4(%eax),%edx
c0107888:	8b 45 0c             	mov    0xc(%ebp),%eax
c010788b:	8b 40 04             	mov    0x4(%eax),%eax
c010788e:	39 c2                	cmp    %eax,%edx
c0107890:	76 02                	jbe    c0107894 <insert_vma_struct+0x69>
                break;
c0107892:	eb 1d                	jmp    c01078b1 <insert_vma_struct+0x86>
            }
            le_prev = le;
c0107894:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107897:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010789a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010789d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01078a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01078a3:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c01078a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01078a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078ac:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078af:	75 c8                	jne    c0107879 <insert_vma_struct+0x4e>
c01078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01078b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01078ba:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c01078bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c01078c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078c3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078c6:	74 15                	je     c01078dd <insert_vma_struct+0xb2>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c01078c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078cb:	8d 50 f0             	lea    -0x10(%eax),%edx
c01078ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078d5:	89 14 24             	mov    %edx,(%esp)
c01078d8:	e8 aa fe ff ff       	call   c0107787 <check_vma_overlap>
    }
    if (le_next != list) {
c01078dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078e0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01078e3:	74 15                	je     c01078fa <insert_vma_struct+0xcf>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01078e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01078e8:	83 e8 10             	sub    $0x10,%eax
c01078eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01078ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078f2:	89 04 24             	mov    %eax,(%esp)
c01078f5:	e8 8d fe ff ff       	call   c0107787 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01078fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01078fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0107900:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107902:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107905:	8d 50 10             	lea    0x10(%eax),%edx
c0107908:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010790b:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010790e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107911:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107914:	8b 40 04             	mov    0x4(%eax),%eax
c0107917:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010791a:	89 55 d0             	mov    %edx,-0x30(%ebp)
c010791d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107920:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107923:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107926:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107929:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010792c:	89 10                	mov    %edx,(%eax)
c010792e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107931:	8b 10                	mov    (%eax),%edx
c0107933:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107936:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107939:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010793c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010793f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107942:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107945:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107948:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c010794a:	8b 45 08             	mov    0x8(%ebp),%eax
c010794d:	8b 40 10             	mov    0x10(%eax),%eax
c0107950:	8d 50 01             	lea    0x1(%eax),%edx
c0107953:	8b 45 08             	mov    0x8(%ebp),%eax
c0107956:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107959:	c9                   	leave  
c010795a:	c3                   	ret    

c010795b <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010795b:	55                   	push   %ebp
c010795c:	89 e5                	mov    %esp,%ebp
c010795e:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107961:	8b 45 08             	mov    0x8(%ebp),%eax
c0107964:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107967:	eb 36                	jmp    c010799f <mm_destroy+0x44>
c0107969:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010796c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010796f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107972:	8b 40 04             	mov    0x4(%eax),%eax
c0107975:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107978:	8b 12                	mov    (%edx),%edx
c010797a:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010797d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107980:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107983:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107986:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107989:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010798c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010798f:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107991:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107994:	83 e8 10             	sub    $0x10,%eax
c0107997:	89 04 24             	mov    %eax,(%esp)
c010799a:	e8 80 cf ff ff       	call   c010491f <kfree>
c010799f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01079a8:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01079ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01079b4:	75 b3                	jne    c0107969 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01079b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01079b9:	89 04 24             	mov    %eax,(%esp)
c01079bc:	e8 5e cf ff ff       	call   c010491f <kfree>
    mm=NULL;
c01079c1:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01079c8:	c9                   	leave  
c01079c9:	c3                   	ret    

c01079ca <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c01079ca:	55                   	push   %ebp
c01079cb:	89 e5                	mov    %esp,%ebp
c01079cd:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c01079d0:	e8 02 00 00 00       	call   c01079d7 <check_vmm>
}
c01079d5:	c9                   	leave  
c01079d6:	c3                   	ret    

c01079d7 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c01079d7:	55                   	push   %ebp
c01079d8:	89 e5                	mov    %esp,%ebp
c01079da:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01079dd:	e8 1c d4 ff ff       	call   c0104dfe <nr_free_pages>
c01079e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01079e5:	e8 13 00 00 00       	call   c01079fd <check_vma_struct>
    check_pgfault();
c01079ea:	e8 a7 04 00 00       	call   c0107e96 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c01079ef:	c7 04 24 91 b6 10 c0 	movl   $0xc010b691,(%esp)
c01079f6:	e8 58 89 ff ff       	call   c0100353 <cprintf>
}
c01079fb:	c9                   	leave  
c01079fc:	c3                   	ret    

c01079fd <check_vma_struct>:

static void
check_vma_struct(void) {
c01079fd:	55                   	push   %ebp
c01079fe:	89 e5                	mov    %esp,%ebp
c0107a00:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107a03:	e8 f6 d3 ff ff       	call   c0104dfe <nr_free_pages>
c0107a08:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107a0b:	e8 13 fc ff ff       	call   c0107623 <mm_create>
c0107a10:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107a13:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107a17:	75 24                	jne    c0107a3d <check_vma_struct+0x40>
c0107a19:	c7 44 24 0c a9 b6 10 	movl   $0xc010b6a9,0xc(%esp)
c0107a20:	c0 
c0107a21:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107a28:	c0 
c0107a29:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107a30:	00 
c0107a31:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107a38:	e8 a0 92 ff ff       	call   c0100cdd <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107a3d:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107a44:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107a47:	89 d0                	mov    %edx,%eax
c0107a49:	c1 e0 02             	shl    $0x2,%eax
c0107a4c:	01 d0                	add    %edx,%eax
c0107a4e:	01 c0                	add    %eax,%eax
c0107a50:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a59:	eb 70                	jmp    c0107acb <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107a5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a5e:	89 d0                	mov    %edx,%eax
c0107a60:	c1 e0 02             	shl    $0x2,%eax
c0107a63:	01 d0                	add    %edx,%eax
c0107a65:	83 c0 02             	add    $0x2,%eax
c0107a68:	89 c1                	mov    %eax,%ecx
c0107a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107a6d:	89 d0                	mov    %edx,%eax
c0107a6f:	c1 e0 02             	shl    $0x2,%eax
c0107a72:	01 d0                	add    %edx,%eax
c0107a74:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107a7b:	00 
c0107a7c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107a80:	89 04 24             	mov    %eax,(%esp)
c0107a83:	e8 13 fc ff ff       	call   c010769b <vma_create>
c0107a88:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107a8b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107a8f:	75 24                	jne    c0107ab5 <check_vma_struct+0xb8>
c0107a91:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107a98:	c0 
c0107a99:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107aa0:	c0 
c0107aa1:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107aa8:	00 
c0107aa9:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107ab0:	e8 28 92 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107ab5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ab8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107abc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107abf:	89 04 24             	mov    %eax,(%esp)
c0107ac2:	e8 64 fd ff ff       	call   c010782b <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107ac7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107acb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107acf:	7f 8a                	jg     c0107a5b <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107ad1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ad4:	83 c0 01             	add    $0x1,%eax
c0107ad7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107ada:	eb 70                	jmp    c0107b4c <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107adc:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107adf:	89 d0                	mov    %edx,%eax
c0107ae1:	c1 e0 02             	shl    $0x2,%eax
c0107ae4:	01 d0                	add    %edx,%eax
c0107ae6:	83 c0 02             	add    $0x2,%eax
c0107ae9:	89 c1                	mov    %eax,%ecx
c0107aeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107aee:	89 d0                	mov    %edx,%eax
c0107af0:	c1 e0 02             	shl    $0x2,%eax
c0107af3:	01 d0                	add    %edx,%eax
c0107af5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107afc:	00 
c0107afd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107b01:	89 04 24             	mov    %eax,(%esp)
c0107b04:	e8 92 fb ff ff       	call   c010769b <vma_create>
c0107b09:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107b0c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107b10:	75 24                	jne    c0107b36 <check_vma_struct+0x139>
c0107b12:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107b19:	c0 
c0107b1a:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107b21:	c0 
c0107b22:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107b29:	00 
c0107b2a:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107b31:	e8 a7 91 ff ff       	call   c0100cdd <__panic>
        insert_vma_struct(mm, vma);
c0107b36:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107b39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b40:	89 04 24             	mov    %eax,(%esp)
c0107b43:	e8 e3 fc ff ff       	call   c010782b <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107b48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b4f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107b52:	7e 88                	jle    c0107adc <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107b54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b57:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107b5a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107b5d:	8b 40 04             	mov    0x4(%eax),%eax
c0107b60:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107b63:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107b6a:	e9 97 00 00 00       	jmp    c0107c06 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107b75:	75 24                	jne    c0107b9b <check_vma_struct+0x19e>
c0107b77:	c7 44 24 0c c0 b6 10 	movl   $0xc010b6c0,0xc(%esp)
c0107b7e:	c0 
c0107b7f:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107b86:	c0 
c0107b87:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107b8e:	00 
c0107b8f:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107b96:	e8 42 91 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b9e:	83 e8 10             	sub    $0x10,%eax
c0107ba1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107ba4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107ba7:	8b 48 04             	mov    0x4(%eax),%ecx
c0107baa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bad:	89 d0                	mov    %edx,%eax
c0107baf:	c1 e0 02             	shl    $0x2,%eax
c0107bb2:	01 d0                	add    %edx,%eax
c0107bb4:	39 c1                	cmp    %eax,%ecx
c0107bb6:	75 17                	jne    c0107bcf <check_vma_struct+0x1d2>
c0107bb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107bbb:	8b 48 08             	mov    0x8(%eax),%ecx
c0107bbe:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107bc1:	89 d0                	mov    %edx,%eax
c0107bc3:	c1 e0 02             	shl    $0x2,%eax
c0107bc6:	01 d0                	add    %edx,%eax
c0107bc8:	83 c0 02             	add    $0x2,%eax
c0107bcb:	39 c1                	cmp    %eax,%ecx
c0107bcd:	74 24                	je     c0107bf3 <check_vma_struct+0x1f6>
c0107bcf:	c7 44 24 0c d8 b6 10 	movl   $0xc010b6d8,0xc(%esp)
c0107bd6:	c0 
c0107bd7:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107bde:	c0 
c0107bdf:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107be6:	00 
c0107be7:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107bee:	e8 ea 90 ff ff       	call   c0100cdd <__panic>
c0107bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107bf6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107bf9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107bfc:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107c02:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107c06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c09:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107c0c:	0f 8e 5d ff ff ff    	jle    c0107b6f <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107c12:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107c19:	e9 cd 01 00 00       	jmp    c0107deb <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c28:	89 04 24             	mov    %eax,(%esp)
c0107c2b:	e8 a6 fa ff ff       	call   c01076d6 <find_vma>
c0107c30:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107c33:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107c37:	75 24                	jne    c0107c5d <check_vma_struct+0x260>
c0107c39:	c7 44 24 0c 0d b7 10 	movl   $0xc010b70d,0xc(%esp)
c0107c40:	c0 
c0107c41:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107c48:	c0 
c0107c49:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107c50:	00 
c0107c51:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107c58:	e8 80 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c60:	83 c0 01             	add    $0x1,%eax
c0107c63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c6a:	89 04 24             	mov    %eax,(%esp)
c0107c6d:	e8 64 fa ff ff       	call   c01076d6 <find_vma>
c0107c72:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107c75:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107c79:	75 24                	jne    c0107c9f <check_vma_struct+0x2a2>
c0107c7b:	c7 44 24 0c 1a b7 10 	movl   $0xc010b71a,0xc(%esp)
c0107c82:	c0 
c0107c83:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107c8a:	c0 
c0107c8b:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107c92:	00 
c0107c93:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107c9a:	e8 3e 90 ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ca2:	83 c0 02             	add    $0x2,%eax
c0107ca5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ca9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cac:	89 04 24             	mov    %eax,(%esp)
c0107caf:	e8 22 fa ff ff       	call   c01076d6 <find_vma>
c0107cb4:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107cb7:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107cbb:	74 24                	je     c0107ce1 <check_vma_struct+0x2e4>
c0107cbd:	c7 44 24 0c 27 b7 10 	movl   $0xc010b727,0xc(%esp)
c0107cc4:	c0 
c0107cc5:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107ccc:	c0 
c0107ccd:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107cd4:	00 
c0107cd5:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107cdc:	e8 fc 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ce4:	83 c0 03             	add    $0x3,%eax
c0107ce7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ceb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cee:	89 04 24             	mov    %eax,(%esp)
c0107cf1:	e8 e0 f9 ff ff       	call   c01076d6 <find_vma>
c0107cf6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107cf9:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107cfd:	74 24                	je     c0107d23 <check_vma_struct+0x326>
c0107cff:	c7 44 24 0c 34 b7 10 	movl   $0xc010b734,0xc(%esp)
c0107d06:	c0 
c0107d07:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107d0e:	c0 
c0107d0f:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107d16:	00 
c0107d17:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107d1e:	e8 ba 8f ff ff       	call   c0100cdd <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107d23:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d26:	83 c0 04             	add    $0x4,%eax
c0107d29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d30:	89 04 24             	mov    %eax,(%esp)
c0107d33:	e8 9e f9 ff ff       	call   c01076d6 <find_vma>
c0107d38:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107d3b:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107d3f:	74 24                	je     c0107d65 <check_vma_struct+0x368>
c0107d41:	c7 44 24 0c 41 b7 10 	movl   $0xc010b741,0xc(%esp)
c0107d48:	c0 
c0107d49:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107d50:	c0 
c0107d51:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0107d58:	00 
c0107d59:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107d60:	e8 78 8f ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107d65:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d68:	8b 50 04             	mov    0x4(%eax),%edx
c0107d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d6e:	39 c2                	cmp    %eax,%edx
c0107d70:	75 10                	jne    c0107d82 <check_vma_struct+0x385>
c0107d72:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107d75:	8b 50 08             	mov    0x8(%eax),%edx
c0107d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d7b:	83 c0 02             	add    $0x2,%eax
c0107d7e:	39 c2                	cmp    %eax,%edx
c0107d80:	74 24                	je     c0107da6 <check_vma_struct+0x3a9>
c0107d82:	c7 44 24 0c 50 b7 10 	movl   $0xc010b750,0xc(%esp)
c0107d89:	c0 
c0107d8a:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107d91:	c0 
c0107d92:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0107d99:	00 
c0107d9a:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107da1:	e8 37 8f ff ff       	call   c0100cdd <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107da6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107da9:	8b 50 04             	mov    0x4(%eax),%edx
c0107dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107daf:	39 c2                	cmp    %eax,%edx
c0107db1:	75 10                	jne    c0107dc3 <check_vma_struct+0x3c6>
c0107db3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107db6:	8b 50 08             	mov    0x8(%eax),%edx
c0107db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dbc:	83 c0 02             	add    $0x2,%eax
c0107dbf:	39 c2                	cmp    %eax,%edx
c0107dc1:	74 24                	je     c0107de7 <check_vma_struct+0x3ea>
c0107dc3:	c7 44 24 0c 80 b7 10 	movl   $0xc010b780,0xc(%esp)
c0107dca:	c0 
c0107dcb:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107dd2:	c0 
c0107dd3:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107dda:	00 
c0107ddb:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107de2:	e8 f6 8e ff ff       	call   c0100cdd <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107de7:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107deb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107dee:	89 d0                	mov    %edx,%eax
c0107df0:	c1 e0 02             	shl    $0x2,%eax
c0107df3:	01 d0                	add    %edx,%eax
c0107df5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107df8:	0f 8d 20 fe ff ff    	jge    c0107c1e <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107dfe:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107e05:	eb 70                	jmp    c0107e77 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107e07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e11:	89 04 24             	mov    %eax,(%esp)
c0107e14:	e8 bd f8 ff ff       	call   c01076d6 <find_vma>
c0107e19:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107e1c:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e20:	74 27                	je     c0107e49 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107e22:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e25:	8b 50 08             	mov    0x8(%eax),%edx
c0107e28:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107e2b:	8b 40 04             	mov    0x4(%eax),%eax
c0107e2e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107e32:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107e39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e3d:	c7 04 24 b0 b7 10 c0 	movl   $0xc010b7b0,(%esp)
c0107e44:	e8 0a 85 ff ff       	call   c0100353 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107e49:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107e4d:	74 24                	je     c0107e73 <check_vma_struct+0x476>
c0107e4f:	c7 44 24 0c d5 b7 10 	movl   $0xc010b7d5,0xc(%esp)
c0107e56:	c0 
c0107e57:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107e5e:	c0 
c0107e5f:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0107e66:	00 
c0107e67:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107e6e:	e8 6a 8e ff ff       	call   c0100cdd <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107e73:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107e77:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107e7b:	79 8a                	jns    c0107e07 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e80:	89 04 24             	mov    %eax,(%esp)
c0107e83:	e8 d3 fa ff ff       	call   c010795b <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0107e88:	c7 04 24 ec b7 10 c0 	movl   $0xc010b7ec,(%esp)
c0107e8f:	e8 bf 84 ff ff       	call   c0100353 <cprintf>
}
c0107e94:	c9                   	leave  
c0107e95:	c3                   	ret    

c0107e96 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107e96:	55                   	push   %ebp
c0107e97:	89 e5                	mov    %esp,%ebp
c0107e99:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107e9c:	e8 5d cf ff ff       	call   c0104dfe <nr_free_pages>
c0107ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107ea4:	e8 7a f7 ff ff       	call   c0107623 <mm_create>
c0107ea9:	a3 0c 7c 12 c0       	mov    %eax,0xc0127c0c
    assert(check_mm_struct != NULL);
c0107eae:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107eb3:	85 c0                	test   %eax,%eax
c0107eb5:	75 24                	jne    c0107edb <check_pgfault+0x45>
c0107eb7:	c7 44 24 0c 0b b8 10 	movl   $0xc010b80b,0xc(%esp)
c0107ebe:	c0 
c0107ebf:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107ec6:	c0 
c0107ec7:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0107ece:	00 
c0107ecf:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107ed6:	e8 02 8e ff ff       	call   c0100cdd <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107edb:	a1 0c 7c 12 c0       	mov    0xc0127c0c,%eax
c0107ee0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107ee3:	8b 15 44 5a 12 c0    	mov    0xc0125a44,%edx
c0107ee9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107eec:	89 50 0c             	mov    %edx,0xc(%eax)
c0107eef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ef2:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ef5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107ef8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107efb:	8b 00                	mov    (%eax),%eax
c0107efd:	85 c0                	test   %eax,%eax
c0107eff:	74 24                	je     c0107f25 <check_pgfault+0x8f>
c0107f01:	c7 44 24 0c 23 b8 10 	movl   $0xc010b823,0xc(%esp)
c0107f08:	c0 
c0107f09:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107f10:	c0 
c0107f11:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0107f18:	00 
c0107f19:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107f20:	e8 b8 8d ff ff       	call   c0100cdd <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107f25:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107f2c:	00 
c0107f2d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107f34:	00 
c0107f35:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107f3c:	e8 5a f7 ff ff       	call   c010769b <vma_create>
c0107f41:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107f44:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f48:	75 24                	jne    c0107f6e <check_pgfault+0xd8>
c0107f4a:	c7 44 24 0c b4 b6 10 	movl   $0xc010b6b4,0xc(%esp)
c0107f51:	c0 
c0107f52:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107f59:	c0 
c0107f5a:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107f61:	00 
c0107f62:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107f69:	e8 6f 8d ff ff       	call   c0100cdd <__panic>

    insert_vma_struct(mm, vma);
c0107f6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107f71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f78:	89 04 24             	mov    %eax,(%esp)
c0107f7b:	e8 ab f8 ff ff       	call   c010782b <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107f80:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107f87:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f91:	89 04 24             	mov    %eax,(%esp)
c0107f94:	e8 3d f7 ff ff       	call   c01076d6 <find_vma>
c0107f99:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107f9c:	74 24                	je     c0107fc2 <check_pgfault+0x12c>
c0107f9e:	c7 44 24 0c 31 b8 10 	movl   $0xc010b831,0xc(%esp)
c0107fa5:	c0 
c0107fa6:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0107fad:	c0 
c0107fae:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0107fb5:	00 
c0107fb6:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0107fbd:	e8 1b 8d ff ff       	call   c0100cdd <__panic>

    int i, sum = 0;
c0107fc2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107fc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107fd0:	eb 17                	jmp    c0107fe9 <check_pgfault+0x153>
        *(char *)(addr + i) = i;
c0107fd2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fd8:	01 d0                	add    %edx,%eax
c0107fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107fdd:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fe2:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107fe5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107fe9:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107fed:	7e e3                	jle    c0107fd2 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107fef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107ff6:	eb 15                	jmp    c010800d <check_pgfault+0x177>
        sum -= *(char *)(addr + i);
c0107ff8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107ffb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ffe:	01 d0                	add    %edx,%eax
c0108000:	0f b6 00             	movzbl (%eax),%eax
c0108003:	0f be c0             	movsbl %al,%eax
c0108006:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108009:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010800d:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108011:	7e e5                	jle    c0107ff8 <check_pgfault+0x162>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108013:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108017:	74 24                	je     c010803d <check_pgfault+0x1a7>
c0108019:	c7 44 24 0c 4b b8 10 	movl   $0xc010b84b,0xc(%esp)
c0108020:	c0 
c0108021:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c0108028:	c0 
c0108029:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0108030:	00 
c0108031:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c0108038:	e8 a0 8c ff ff       	call   c0100cdd <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c010803d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108040:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108043:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010804b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010804f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108052:	89 04 24             	mov    %eax,(%esp)
c0108055:	e8 60 d6 ff ff       	call   c01056ba <page_remove>
    free_page(pa2page(pgdir[0]));
c010805a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010805d:	8b 00                	mov    (%eax),%eax
c010805f:	89 04 24             	mov    %eax,(%esp)
c0108062:	e8 77 f5 ff ff       	call   c01075de <pa2page>
c0108067:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010806e:	00 
c010806f:	89 04 24             	mov    %eax,(%esp)
c0108072:	e8 55 cd ff ff       	call   c0104dcc <free_pages>
    pgdir[0] = 0;
c0108077:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010807a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108080:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108083:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c010808a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010808d:	89 04 24             	mov    %eax,(%esp)
c0108090:	e8 c6 f8 ff ff       	call   c010795b <mm_destroy>
    check_mm_struct = NULL;
c0108095:	c7 05 0c 7c 12 c0 00 	movl   $0x0,0xc0127c0c
c010809c:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c010809f:	e8 5a cd ff ff       	call   c0104dfe <nr_free_pages>
c01080a4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01080a7:	74 24                	je     c01080cd <check_pgfault+0x237>
c01080a9:	c7 44 24 0c 54 b8 10 	movl   $0xc010b854,0xc(%esp)
c01080b0:	c0 
c01080b1:	c7 44 24 08 13 b6 10 	movl   $0xc010b613,0x8(%esp)
c01080b8:	c0 
c01080b9:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01080c0:	00 
c01080c1:	c7 04 24 28 b6 10 c0 	movl   $0xc010b628,(%esp)
c01080c8:	e8 10 8c ff ff       	call   c0100cdd <__panic>

    cprintf("check_pgfault() succeeded!\n");
c01080cd:	c7 04 24 7b b8 10 c0 	movl   $0xc010b87b,(%esp)
c01080d4:	e8 7a 82 ff ff       	call   c0100353 <cprintf>
}
c01080d9:	c9                   	leave  
c01080da:	c3                   	ret    

c01080db <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c01080db:	55                   	push   %ebp
c01080dc:	89 e5                	mov    %esp,%ebp
c01080de:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c01080e1:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c01080e8:	8b 45 10             	mov    0x10(%ebp),%eax
c01080eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01080f2:	89 04 24             	mov    %eax,(%esp)
c01080f5:	e8 dc f5 ff ff       	call   c01076d6 <find_vma>
c01080fa:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01080fd:	a1 d8 5a 12 c0       	mov    0xc0125ad8,%eax
c0108102:	83 c0 01             	add    $0x1,%eax
c0108105:	a3 d8 5a 12 c0       	mov    %eax,0xc0125ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c010810a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010810e:	74 0b                	je     c010811b <do_pgfault+0x40>
c0108110:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108113:	8b 40 04             	mov    0x4(%eax),%eax
c0108116:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108119:	76 18                	jbe    c0108133 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c010811b:	8b 45 10             	mov    0x10(%ebp),%eax
c010811e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108122:	c7 04 24 98 b8 10 c0 	movl   $0xc010b898,(%esp)
c0108129:	e8 25 82 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010812e:	e9 6c 01 00 00       	jmp    c010829f <do_pgfault+0x1c4>
    }
    //check the error_code
    switch (error_code & 3) {
c0108133:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108136:	83 e0 03             	and    $0x3,%eax
c0108139:	85 c0                	test   %eax,%eax
c010813b:	74 36                	je     c0108173 <do_pgfault+0x98>
c010813d:	83 f8 01             	cmp    $0x1,%eax
c0108140:	74 20                	je     c0108162 <do_pgfault+0x87>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108142:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108145:	8b 40 0c             	mov    0xc(%eax),%eax
c0108148:	83 e0 02             	and    $0x2,%eax
c010814b:	85 c0                	test   %eax,%eax
c010814d:	75 11                	jne    c0108160 <do_pgfault+0x85>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c010814f:	c7 04 24 c8 b8 10 c0 	movl   $0xc010b8c8,(%esp)
c0108156:	e8 f8 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010815b:	e9 3f 01 00 00       	jmp    c010829f <do_pgfault+0x1c4>
        }
        break;
c0108160:	eb 2f                	jmp    c0108191 <do_pgfault+0xb6>
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108162:	c7 04 24 28 b9 10 c0 	movl   $0xc010b928,(%esp)
c0108169:	e8 e5 81 ff ff       	call   c0100353 <cprintf>
        goto failed;
c010816e:	e9 2c 01 00 00       	jmp    c010829f <do_pgfault+0x1c4>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108173:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108176:	8b 40 0c             	mov    0xc(%eax),%eax
c0108179:	83 e0 05             	and    $0x5,%eax
c010817c:	85 c0                	test   %eax,%eax
c010817e:	75 11                	jne    c0108191 <do_pgfault+0xb6>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108180:	c7 04 24 60 b9 10 c0 	movl   $0xc010b960,(%esp)
c0108187:	e8 c7 81 ff ff       	call   c0100353 <cprintf>
            goto failed;
c010818c:	e9 0e 01 00 00       	jmp    c010829f <do_pgfault+0x1c4>
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108191:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108198:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010819b:	8b 40 0c             	mov    0xc(%eax),%eax
c010819e:	83 e0 02             	and    $0x2,%eax
c01081a1:	85 c0                	test   %eax,%eax
c01081a3:	74 04                	je     c01081a9 <do_pgfault+0xce>
        perm |= PTE_W;
c01081a5:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c01081a9:	8b 45 10             	mov    0x10(%ebp),%eax
c01081ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01081b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01081b7:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c01081ba:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c01081c1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    *
    */
//#if 0
    /*LAB3 EXERCISE 1: 2012011394*/
    //ptep = ???              //(1) try to find a pte, if pte's PT(Page Table) isn't existed, then create a PT.
    ptep = get_pte(mm->pgdir, addr, 1);
c01081c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01081cb:	8b 40 0c             	mov    0xc(%eax),%eax
c01081ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01081d5:	00 
c01081d6:	8b 55 10             	mov    0x10(%ebp),%edx
c01081d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081dd:	89 04 24             	mov    %eax,(%esp)
c01081e0:	e8 e3 d2 ff ff       	call   c01054c8 <get_pte>
c01081e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (*ptep == 0) {
c01081e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081eb:	8b 00                	mov    (%eax),%eax
c01081ed:	85 c0                	test   %eax,%eax
c01081ef:	75 21                	jne    c0108212 <do_pgfault+0x137>
                            //(2) if the phy addr isn't exist, then alloc a page & map the phy addr with logical addr
    	pgdir_alloc_page(mm->pgdir, addr, perm);
c01081f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01081f4:	8b 40 0c             	mov    0xc(%eax),%eax
c01081f7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01081fa:	89 54 24 08          	mov    %edx,0x8(%esp)
c01081fe:	8b 55 10             	mov    0x10(%ebp),%edx
c0108201:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108205:	89 04 24             	mov    %eax,(%esp)
c0108208:	e8 07 d6 ff ff       	call   c0105814 <pgdir_alloc_page>
c010820d:	e9 86 00 00 00       	jmp    c0108298 <do_pgfault+0x1bd>
    *    swap_in(mm, addr, &page) : alloc a memory page, then according to the swap entry in PTE for addr,
    *                               find the addr of disk page, read the content of disk page into this memroy page
    *    page_insert ： build the map of phy addr of an Page with the linear addr la
    *    swap_map_swappable ： set the page swappable
    */
        if(swap_init_ok) {
c0108212:	a1 cc 5a 12 c0       	mov    0xc0125acc,%eax
c0108217:	85 c0                	test   %eax,%eax
c0108219:	74 66                	je     c0108281 <do_pgfault+0x1a6>
            struct Page *page=NULL;
c010821b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
            swap_in(mm, addr, &page);
c0108222:	8d 45 e0             	lea    -0x20(%ebp),%eax
c0108225:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108229:	8b 45 10             	mov    0x10(%ebp),%eax
c010822c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108230:	8b 45 08             	mov    0x8(%ebp),%eax
c0108233:	89 04 24             	mov    %eax,(%esp)
c0108236:	e8 69 e6 ff ff       	call   c01068a4 <swap_in>
            page_insert(mm->pgdir, page, addr, perm);
c010823b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010823e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108241:	8b 40 0c             	mov    0xc(%eax),%eax
c0108244:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0108247:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010824b:	8b 4d 10             	mov    0x10(%ebp),%ecx
c010824e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108252:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108256:	89 04 24             	mov    %eax,(%esp)
c0108259:	e8 a0 d4 ff ff       	call   c01056fe <page_insert>
            swap_map_swappable(mm, addr, page, 1);
c010825e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108261:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108268:	00 
c0108269:	89 44 24 08          	mov    %eax,0x8(%esp)
c010826d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108270:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108274:	8b 45 08             	mov    0x8(%ebp),%eax
c0108277:	89 04 24             	mov    %eax,(%esp)
c010827a:	e8 5c e4 ff ff       	call   c01066db <swap_map_swappable>
c010827f:	eb 17                	jmp    c0108298 <do_pgfault+0x1bd>
                                    //    into the memory which page managed.
                                    //(2) According to the mm, addr AND page, setup the map of phy addr <---> logical addr
                                    //(3) make the page swappable.
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0108281:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108284:	8b 00                	mov    (%eax),%eax
c0108286:	89 44 24 04          	mov    %eax,0x4(%esp)
c010828a:	c7 04 24 c4 b9 10 c0 	movl   $0xc010b9c4,(%esp)
c0108291:	e8 bd 80 ff ff       	call   c0100353 <cprintf>
            goto failed;
c0108296:	eb 07                	jmp    c010829f <do_pgfault+0x1c4>
        }
   }
//#endif
   ret = 0;
c0108298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010829f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01082a2:	c9                   	leave  
c01082a3:	c3                   	ret    

c01082a4 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01082a4:	55                   	push   %ebp
c01082a5:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01082a7:	8b 55 08             	mov    0x8(%ebp),%edx
c01082aa:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01082af:	29 c2                	sub    %eax,%edx
c01082b1:	89 d0                	mov    %edx,%eax
c01082b3:	c1 f8 05             	sar    $0x5,%eax
}
c01082b6:	5d                   	pop    %ebp
c01082b7:	c3                   	ret    

c01082b8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01082b8:	55                   	push   %ebp
c01082b9:	89 e5                	mov    %esp,%ebp
c01082bb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01082be:	8b 45 08             	mov    0x8(%ebp),%eax
c01082c1:	89 04 24             	mov    %eax,(%esp)
c01082c4:	e8 db ff ff ff       	call   c01082a4 <page2ppn>
c01082c9:	c1 e0 0c             	shl    $0xc,%eax
}
c01082cc:	c9                   	leave  
c01082cd:	c3                   	ret    

c01082ce <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01082ce:	55                   	push   %ebp
c01082cf:	89 e5                	mov    %esp,%ebp
c01082d1:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01082d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01082d7:	89 04 24             	mov    %eax,(%esp)
c01082da:	e8 d9 ff ff ff       	call   c01082b8 <page2pa>
c01082df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01082e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082e5:	c1 e8 0c             	shr    $0xc,%eax
c01082e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01082eb:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01082f0:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01082f3:	72 23                	jb     c0108318 <page2kva+0x4a>
c01082f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082f8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01082fc:	c7 44 24 08 ec b9 10 	movl   $0xc010b9ec,0x8(%esp)
c0108303:	c0 
c0108304:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c010830b:	00 
c010830c:	c7 04 24 0f ba 10 c0 	movl   $0xc010ba0f,(%esp)
c0108313:	e8 c5 89 ff ff       	call   c0100cdd <__panic>
c0108318:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010831b:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108320:	c9                   	leave  
c0108321:	c3                   	ret    

c0108322 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108322:	55                   	push   %ebp
c0108323:	89 e5                	mov    %esp,%ebp
c0108325:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0108328:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010832f:	e8 f9 96 ff ff       	call   c0101a2d <ide_device_valid>
c0108334:	85 c0                	test   %eax,%eax
c0108336:	75 1c                	jne    c0108354 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0108338:	c7 44 24 08 1d ba 10 	movl   $0xc010ba1d,0x8(%esp)
c010833f:	c0 
c0108340:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0108347:	00 
c0108348:	c7 04 24 37 ba 10 c0 	movl   $0xc010ba37,(%esp)
c010834f:	e8 89 89 ff ff       	call   c0100cdd <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c0108354:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010835b:	e8 0c 97 ff ff       	call   c0101a6c <ide_device_size>
c0108360:	c1 e8 03             	shr    $0x3,%eax
c0108363:	a3 dc 7b 12 c0       	mov    %eax,0xc0127bdc
}
c0108368:	c9                   	leave  
c0108369:	c3                   	ret    

c010836a <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c010836a:	55                   	push   %ebp
c010836b:	89 e5                	mov    %esp,%ebp
c010836d:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108370:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108373:	89 04 24             	mov    %eax,(%esp)
c0108376:	e8 53 ff ff ff       	call   c01082ce <page2kva>
c010837b:	8b 55 08             	mov    0x8(%ebp),%edx
c010837e:	c1 ea 08             	shr    $0x8,%edx
c0108381:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108384:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108388:	74 0b                	je     c0108395 <swapfs_read+0x2b>
c010838a:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108390:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108393:	72 23                	jb     c01083b8 <swapfs_read+0x4e>
c0108395:	8b 45 08             	mov    0x8(%ebp),%eax
c0108398:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010839c:	c7 44 24 08 48 ba 10 	movl   $0xc010ba48,0x8(%esp)
c01083a3:	c0 
c01083a4:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01083ab:	00 
c01083ac:	c7 04 24 37 ba 10 c0 	movl   $0xc010ba37,(%esp)
c01083b3:	e8 25 89 ff ff       	call   c0100cdd <__panic>
c01083b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01083bb:	c1 e2 03             	shl    $0x3,%edx
c01083be:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01083c5:	00 
c01083c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c01083ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01083d5:	e8 d1 96 ff ff       	call   c0101aab <ide_read_secs>
}
c01083da:	c9                   	leave  
c01083db:	c3                   	ret    

c01083dc <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01083dc:	55                   	push   %ebp
c01083dd:	89 e5                	mov    %esp,%ebp
c01083df:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01083e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083e5:	89 04 24             	mov    %eax,(%esp)
c01083e8:	e8 e1 fe ff ff       	call   c01082ce <page2kva>
c01083ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01083f0:	c1 ea 08             	shr    $0x8,%edx
c01083f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01083f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01083fa:	74 0b                	je     c0108407 <swapfs_write+0x2b>
c01083fc:	8b 15 dc 7b 12 c0    	mov    0xc0127bdc,%edx
c0108402:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108405:	72 23                	jb     c010842a <swapfs_write+0x4e>
c0108407:	8b 45 08             	mov    0x8(%ebp),%eax
c010840a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010840e:	c7 44 24 08 48 ba 10 	movl   $0xc010ba48,0x8(%esp)
c0108415:	c0 
c0108416:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c010841d:	00 
c010841e:	c7 04 24 37 ba 10 c0 	movl   $0xc010ba37,(%esp)
c0108425:	e8 b3 88 ff ff       	call   c0100cdd <__panic>
c010842a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010842d:	c1 e2 03             	shl    $0x3,%edx
c0108430:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108437:	00 
c0108438:	89 44 24 08          	mov    %eax,0x8(%esp)
c010843c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108440:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108447:	e8 a1 98 ff ff       	call   c0101ced <ide_write_secs>
}
c010844c:	c9                   	leave  
c010844d:	c3                   	ret    

c010844e <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c010844e:	52                   	push   %edx
    call *%ebx              # call fn
c010844f:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108451:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108452:	e8 28 08 00 00       	call   c0108c7f <do_exit>

c0108457 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108457:	55                   	push   %ebp
c0108458:	89 e5                	mov    %esp,%ebp
c010845a:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010845d:	9c                   	pushf  
c010845e:	58                   	pop    %eax
c010845f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108462:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108465:	25 00 02 00 00       	and    $0x200,%eax
c010846a:	85 c0                	test   %eax,%eax
c010846c:	74 0c                	je     c010847a <__intr_save+0x23>
        intr_disable();
c010846e:	e8 c2 9a ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0108473:	b8 01 00 00 00       	mov    $0x1,%eax
c0108478:	eb 05                	jmp    c010847f <__intr_save+0x28>
    }
    return 0;
c010847a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010847f:	c9                   	leave  
c0108480:	c3                   	ret    

c0108481 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108481:	55                   	push   %ebp
c0108482:	89 e5                	mov    %esp,%ebp
c0108484:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108487:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010848b:	74 05                	je     c0108492 <__intr_restore+0x11>
        intr_enable();
c010848d:	e8 9d 9a ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108492:	c9                   	leave  
c0108493:	c3                   	ret    

c0108494 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108494:	55                   	push   %ebp
c0108495:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108497:	8b 55 08             	mov    0x8(%ebp),%edx
c010849a:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c010849f:	29 c2                	sub    %eax,%edx
c01084a1:	89 d0                	mov    %edx,%eax
c01084a3:	c1 f8 05             	sar    $0x5,%eax
}
c01084a6:	5d                   	pop    %ebp
c01084a7:	c3                   	ret    

c01084a8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01084a8:	55                   	push   %ebp
c01084a9:	89 e5                	mov    %esp,%ebp
c01084ab:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01084ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b1:	89 04 24             	mov    %eax,(%esp)
c01084b4:	e8 db ff ff ff       	call   c0108494 <page2ppn>
c01084b9:	c1 e0 0c             	shl    $0xc,%eax
}
c01084bc:	c9                   	leave  
c01084bd:	c3                   	ret    

c01084be <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01084be:	55                   	push   %ebp
c01084bf:	89 e5                	mov    %esp,%ebp
c01084c1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01084c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c7:	c1 e8 0c             	shr    $0xc,%eax
c01084ca:	89 c2                	mov    %eax,%edx
c01084cc:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c01084d1:	39 c2                	cmp    %eax,%edx
c01084d3:	72 1c                	jb     c01084f1 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01084d5:	c7 44 24 08 68 ba 10 	movl   $0xc010ba68,0x8(%esp)
c01084dc:	c0 
c01084dd:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01084e4:	00 
c01084e5:	c7 04 24 87 ba 10 c0 	movl   $0xc010ba87,(%esp)
c01084ec:	e8 ec 87 ff ff       	call   c0100cdd <__panic>
    }
    return &pages[PPN(pa)];
c01084f1:	a1 2c 7b 12 c0       	mov    0xc0127b2c,%eax
c01084f6:	8b 55 08             	mov    0x8(%ebp),%edx
c01084f9:	c1 ea 0c             	shr    $0xc,%edx
c01084fc:	c1 e2 05             	shl    $0x5,%edx
c01084ff:	01 d0                	add    %edx,%eax
}
c0108501:	c9                   	leave  
c0108502:	c3                   	ret    

c0108503 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0108503:	55                   	push   %ebp
c0108504:	89 e5                	mov    %esp,%ebp
c0108506:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108509:	8b 45 08             	mov    0x8(%ebp),%eax
c010850c:	89 04 24             	mov    %eax,(%esp)
c010850f:	e8 94 ff ff ff       	call   c01084a8 <page2pa>
c0108514:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108517:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010851a:	c1 e8 0c             	shr    $0xc,%eax
c010851d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108520:	a1 40 5a 12 c0       	mov    0xc0125a40,%eax
c0108525:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108528:	72 23                	jb     c010854d <page2kva+0x4a>
c010852a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010852d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108531:	c7 44 24 08 98 ba 10 	movl   $0xc010ba98,0x8(%esp)
c0108538:	c0 
c0108539:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108540:	00 
c0108541:	c7 04 24 87 ba 10 c0 	movl   $0xc010ba87,(%esp)
c0108548:	e8 90 87 ff ff       	call   c0100cdd <__panic>
c010854d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108550:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108555:	c9                   	leave  
c0108556:	c3                   	ret    

c0108557 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0108557:	55                   	push   %ebp
c0108558:	89 e5                	mov    %esp,%ebp
c010855a:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010855d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108560:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108563:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010856a:	77 23                	ja     c010858f <kva2page+0x38>
c010856c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010856f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108573:	c7 44 24 08 bc ba 10 	movl   $0xc010babc,0x8(%esp)
c010857a:	c0 
c010857b:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0108582:	00 
c0108583:	c7 04 24 87 ba 10 c0 	movl   $0xc010ba87,(%esp)
c010858a:	e8 4e 87 ff ff       	call   c0100cdd <__panic>
c010858f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108592:	05 00 00 00 40       	add    $0x40000000,%eax
c0108597:	89 04 24             	mov    %eax,(%esp)
c010859a:	e8 1f ff ff ff       	call   c01084be <pa2page>
}
c010859f:	c9                   	leave  
c01085a0:	c3                   	ret    

c01085a1 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01085a1:	55                   	push   %ebp
c01085a2:	89 e5                	mov    %esp,%ebp
c01085a4:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01085a7:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c01085ae:	e8 51 c3 ff ff       	call   c0104904 <kmalloc>
c01085b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01085b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01085ba:	0f 84 a1 00 00 00    	je     c0108661 <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
    	proc->state = PROC_UNINIT;
c01085c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	proc->pid = -1;
c01085c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085cc:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    	proc->runs = 0;
c01085d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    	proc->kstack = 0;
c01085dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085e0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    	proc->need_resched = 0;
c01085e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085ea:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
    	proc->parent = NULL;
c01085f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085f4:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    	proc->mm = NULL;
c01085fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085fe:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    	memset(&(proc->context), 0, sizeof(struct context));
c0108605:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108608:	83 c0 1c             	add    $0x1c,%eax
c010860b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108612:	00 
c0108613:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010861a:	00 
c010861b:	89 04 24             	mov    %eax,(%esp)
c010861e:	e8 de 14 00 00       	call   c0109b01 <memset>
    	proc->tf = NULL;
c0108623:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108626:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
    	proc->cr3 = boot_cr3;
c010862d:	8b 15 28 7b 12 c0    	mov    0xc0127b28,%edx
c0108633:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108636:	89 50 40             	mov    %edx,0x40(%eax)
    	proc->flags = 0;
c0108639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010863c:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
    	memset(proc->name, 0, PROC_NAME_LEN);
c0108643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108646:	83 c0 48             	add    $0x48,%eax
c0108649:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108650:	00 
c0108651:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108658:	00 
c0108659:	89 04 24             	mov    %eax,(%esp)
c010865c:	e8 a0 14 00 00       	call   c0109b01 <memset>

    }
    return proc;
c0108661:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108664:	c9                   	leave  
c0108665:	c3                   	ret    

c0108666 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108666:	55                   	push   %ebp
c0108667:	89 e5                	mov    %esp,%ebp
c0108669:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010866c:	8b 45 08             	mov    0x8(%ebp),%eax
c010866f:	83 c0 48             	add    $0x48,%eax
c0108672:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108679:	00 
c010867a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108681:	00 
c0108682:	89 04 24             	mov    %eax,(%esp)
c0108685:	e8 77 14 00 00       	call   c0109b01 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010868a:	8b 45 08             	mov    0x8(%ebp),%eax
c010868d:	8d 50 48             	lea    0x48(%eax),%edx
c0108690:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108697:	00 
c0108698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010869b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010869f:	89 14 24             	mov    %edx,(%esp)
c01086a2:	e8 3c 15 00 00       	call   c0109be3 <memcpy>
}
c01086a7:	c9                   	leave  
c01086a8:	c3                   	ret    

c01086a9 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01086a9:	55                   	push   %ebp
c01086aa:	89 e5                	mov    %esp,%ebp
c01086ac:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01086af:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01086b6:	00 
c01086b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01086be:	00 
c01086bf:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01086c6:	e8 36 14 00 00       	call   c0109b01 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01086cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ce:	83 c0 48             	add    $0x48,%eax
c01086d1:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01086d8:	00 
c01086d9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086dd:	c7 04 24 04 7b 12 c0 	movl   $0xc0127b04,(%esp)
c01086e4:	e8 fa 14 00 00       	call   c0109be3 <memcpy>
}
c01086e9:	c9                   	leave  
c01086ea:	c3                   	ret    

c01086eb <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01086eb:	55                   	push   %ebp
c01086ec:	89 e5                	mov    %esp,%ebp
c01086ee:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01086f1:	c7 45 f8 10 7c 12 c0 	movl   $0xc0127c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01086f8:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01086fd:	83 c0 01             	add    $0x1,%eax
c0108700:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108705:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010870a:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c010870f:	7e 0c                	jle    c010871d <get_pid+0x32>
        last_pid = 1;
c0108711:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108718:	00 00 00 
        goto inside;
c010871b:	eb 13                	jmp    c0108730 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c010871d:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c0108723:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108728:	39 c2                	cmp    %eax,%edx
c010872a:	0f 8c ac 00 00 00    	jl     c01087dc <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108730:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108737:	20 00 00 
    repeat:
        le = list;
c010873a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010873d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108740:	eb 7f                	jmp    c01087c1 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108742:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108745:	83 e8 58             	sub    $0x58,%eax
c0108748:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c010874b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010874e:	8b 50 04             	mov    0x4(%eax),%edx
c0108751:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c0108756:	39 c2                	cmp    %eax,%edx
c0108758:	75 3e                	jne    c0108798 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c010875a:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010875f:	83 c0 01             	add    $0x1,%eax
c0108762:	a3 80 4a 12 c0       	mov    %eax,0xc0124a80
c0108767:	8b 15 80 4a 12 c0    	mov    0xc0124a80,%edx
c010876d:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c0108772:	39 c2                	cmp    %eax,%edx
c0108774:	7c 4b                	jl     c01087c1 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108776:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c010877b:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108780:	7e 0a                	jle    c010878c <get_pid+0xa1>
                        last_pid = 1;
c0108782:	c7 05 80 4a 12 c0 01 	movl   $0x1,0xc0124a80
c0108789:	00 00 00 
                    }
                    next_safe = MAX_PID;
c010878c:	c7 05 84 4a 12 c0 00 	movl   $0x2000,0xc0124a84
c0108793:	20 00 00 
                    goto repeat;
c0108796:	eb a2                	jmp    c010873a <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108798:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010879b:	8b 50 04             	mov    0x4(%eax),%edx
c010879e:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
c01087a3:	39 c2                	cmp    %eax,%edx
c01087a5:	7e 1a                	jle    c01087c1 <get_pid+0xd6>
c01087a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087aa:	8b 50 04             	mov    0x4(%eax),%edx
c01087ad:	a1 84 4a 12 c0       	mov    0xc0124a84,%eax
c01087b2:	39 c2                	cmp    %eax,%edx
c01087b4:	7d 0b                	jge    c01087c1 <get_pid+0xd6>
                next_safe = proc->pid;
c01087b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01087b9:	8b 40 04             	mov    0x4(%eax),%eax
c01087bc:	a3 84 4a 12 c0       	mov    %eax,0xc0124a84
c01087c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01087c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01087ca:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c01087cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01087d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01087d3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01087d6:	0f 85 66 ff ff ff    	jne    c0108742 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c01087dc:	a1 80 4a 12 c0       	mov    0xc0124a80,%eax
}
c01087e1:	c9                   	leave  
c01087e2:	c3                   	ret    

c01087e3 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c01087e3:	55                   	push   %ebp
c01087e4:	89 e5                	mov    %esp,%ebp
c01087e6:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01087e9:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01087ee:	39 45 08             	cmp    %eax,0x8(%ebp)
c01087f1:	74 63                	je     c0108856 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01087f3:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c01087f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01087fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108801:	e8 51 fc ff ff       	call   c0108457 <__intr_save>
c0108806:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108809:	8b 45 08             	mov    0x8(%ebp),%eax
c010880c:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108811:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108814:	8b 40 0c             	mov    0xc(%eax),%eax
c0108817:	05 00 20 00 00       	add    $0x2000,%eax
c010881c:	89 04 24             	mov    %eax,(%esp)
c010881f:	e8 ef c3 ff ff       	call   c0104c13 <load_esp0>
            lcr3(next->cr3);
c0108824:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108827:	8b 40 40             	mov    0x40(%eax),%eax
c010882a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c010882d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108830:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108833:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108836:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108839:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010883c:	83 c0 1c             	add    $0x1c,%eax
c010883f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108843:	89 04 24             	mov    %eax,(%esp)
c0108846:	e8 86 06 00 00       	call   c0108ed1 <switch_to>
        }
        local_intr_restore(intr_flag);
c010884b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010884e:	89 04 24             	mov    %eax,(%esp)
c0108851:	e8 2b fc ff ff       	call   c0108481 <__intr_restore>
    }
}
c0108856:	c9                   	leave  
c0108857:	c3                   	ret    

c0108858 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108858:	55                   	push   %ebp
c0108859:	89 e5                	mov    %esp,%ebp
c010885b:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c010885e:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108863:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108866:	89 04 24             	mov    %eax,(%esp)
c0108869:	e8 1d 9f ff ff       	call   c010278b <forkrets>
}
c010886e:	c9                   	leave  
c010886f:	c3                   	ret    

c0108870 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108870:	55                   	push   %ebp
c0108871:	89 e5                	mov    %esp,%ebp
c0108873:	53                   	push   %ebx
c0108874:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108877:	8b 45 08             	mov    0x8(%ebp),%eax
c010887a:	8d 58 60             	lea    0x60(%eax),%ebx
c010887d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108880:	8b 40 04             	mov    0x4(%eax),%eax
c0108883:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010888a:	00 
c010888b:	89 04 24             	mov    %eax,(%esp)
c010888e:	e8 c1 07 00 00       	call   c0109054 <hash32>
c0108893:	c1 e0 03             	shl    $0x3,%eax
c0108896:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010889b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010889e:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c01088a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01088a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01088aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01088ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01088b0:	8b 40 04             	mov    0x4(%eax),%eax
c01088b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01088b6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01088b9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01088bc:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01088bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01088c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01088c8:	89 10                	mov    %edx,(%eax)
c01088ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01088cd:	8b 10                	mov    (%eax),%edx
c01088cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01088d2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01088d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088d8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01088db:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01088de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01088e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01088e4:	89 10                	mov    %edx,(%eax)
}
c01088e6:	83 c4 34             	add    $0x34,%esp
c01088e9:	5b                   	pop    %ebx
c01088ea:	5d                   	pop    %ebp
c01088eb:	c3                   	ret    

c01088ec <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c01088ec:	55                   	push   %ebp
c01088ed:	89 e5                	mov    %esp,%ebp
c01088ef:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c01088f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01088f6:	7e 5f                	jle    c0108957 <find_proc+0x6b>
c01088f8:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c01088ff:	7f 56                	jg     c0108957 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108901:	8b 45 08             	mov    0x8(%ebp),%eax
c0108904:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c010890b:	00 
c010890c:	89 04 24             	mov    %eax,(%esp)
c010890f:	e8 40 07 00 00       	call   c0109054 <hash32>
c0108914:	c1 e0 03             	shl    $0x3,%eax
c0108917:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c010891c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010891f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108922:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108925:	eb 19                	jmp    c0108940 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108927:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010892a:	83 e8 60             	sub    $0x60,%eax
c010892d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108930:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108933:	8b 40 04             	mov    0x4(%eax),%eax
c0108936:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108939:	75 05                	jne    c0108940 <find_proc+0x54>
                return proc;
c010893b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010893e:	eb 1c                	jmp    c010895c <find_proc+0x70>
c0108940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108943:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108946:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108949:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c010894c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010894f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108952:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108955:	75 d0                	jne    c0108927 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108957:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010895c:	c9                   	leave  
c010895d:	c3                   	ret    

c010895e <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c010895e:	55                   	push   %ebp
c010895f:	89 e5                	mov    %esp,%ebp
c0108961:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108964:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010896b:	00 
c010896c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108973:	00 
c0108974:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108977:	89 04 24             	mov    %eax,(%esp)
c010897a:	e8 82 11 00 00       	call   c0109b01 <memset>
    tf.tf_cs = KERNEL_CS;
c010897f:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108985:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c010898b:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c010898f:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108993:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108997:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c010899b:	8b 45 08             	mov    0x8(%ebp),%eax
c010899e:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c01089a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089a4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c01089a7:	b8 4e 84 10 c0       	mov    $0xc010844e,%eax
c01089ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c01089af:	8b 45 10             	mov    0x10(%ebp),%eax
c01089b2:	80 cc 01             	or     $0x1,%ah
c01089b5:	89 c2                	mov    %eax,%edx
c01089b7:	8d 45 ac             	lea    -0x54(%ebp),%eax
c01089ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01089be:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089c5:	00 
c01089c6:	89 14 24             	mov    %edx,(%esp)
c01089c9:	e8 79 01 00 00       	call   c0108b47 <do_fork>
}
c01089ce:	c9                   	leave  
c01089cf:	c3                   	ret    

c01089d0 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c01089d0:	55                   	push   %ebp
c01089d1:	89 e5                	mov    %esp,%ebp
c01089d3:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c01089d6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01089dd:	e8 7f c3 ff ff       	call   c0104d61 <alloc_pages>
c01089e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01089e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01089e9:	74 1a                	je     c0108a05 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c01089eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089ee:	89 04 24             	mov    %eax,(%esp)
c01089f1:	e8 0d fb ff ff       	call   c0108503 <page2kva>
c01089f6:	89 c2                	mov    %eax,%edx
c01089f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01089fb:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c01089fe:	b8 00 00 00 00       	mov    $0x0,%eax
c0108a03:	eb 05                	jmp    c0108a0a <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108a05:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108a0a:	c9                   	leave  
c0108a0b:	c3                   	ret    

c0108a0c <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108a0c:	55                   	push   %ebp
c0108a0d:	89 e5                	mov    %esp,%ebp
c0108a0f:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a15:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a18:	89 04 24             	mov    %eax,(%esp)
c0108a1b:	e8 37 fb ff ff       	call   c0108557 <kva2page>
c0108a20:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108a27:	00 
c0108a28:	89 04 24             	mov    %eax,(%esp)
c0108a2b:	e8 9c c3 ff ff       	call   c0104dcc <free_pages>
}
c0108a30:	c9                   	leave  
c0108a31:	c3                   	ret    

c0108a32 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108a32:	55                   	push   %ebp
c0108a33:	89 e5                	mov    %esp,%ebp
c0108a35:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108a38:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108a3d:	8b 40 18             	mov    0x18(%eax),%eax
c0108a40:	85 c0                	test   %eax,%eax
c0108a42:	74 24                	je     c0108a68 <copy_mm+0x36>
c0108a44:	c7 44 24 0c e0 ba 10 	movl   $0xc010bae0,0xc(%esp)
c0108a4b:	c0 
c0108a4c:	c7 44 24 08 f4 ba 10 	movl   $0xc010baf4,0x8(%esp)
c0108a53:	c0 
c0108a54:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0108a5b:	00 
c0108a5c:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108a63:	e8 75 82 ff ff       	call   c0100cdd <__panic>
    /* do nothing in this project */
    return 0;
c0108a68:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108a6d:	c9                   	leave  
c0108a6e:	c3                   	ret    

c0108a6f <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108a6f:	55                   	push   %ebp
c0108a70:	89 e5                	mov    %esp,%ebp
c0108a72:	57                   	push   %edi
c0108a73:	56                   	push   %esi
c0108a74:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a78:	8b 40 0c             	mov    0xc(%eax),%eax
c0108a7b:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108a80:	89 c2                	mov    %eax,%edx
c0108a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a85:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108a88:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a8b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108a8e:	8b 55 10             	mov    0x10(%ebp),%edx
c0108a91:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108a96:	89 c1                	mov    %eax,%ecx
c0108a98:	83 e1 01             	and    $0x1,%ecx
c0108a9b:	85 c9                	test   %ecx,%ecx
c0108a9d:	74 0e                	je     c0108aad <copy_thread+0x3e>
c0108a9f:	0f b6 0a             	movzbl (%edx),%ecx
c0108aa2:	88 08                	mov    %cl,(%eax)
c0108aa4:	83 c0 01             	add    $0x1,%eax
c0108aa7:	83 c2 01             	add    $0x1,%edx
c0108aaa:	83 eb 01             	sub    $0x1,%ebx
c0108aad:	89 c1                	mov    %eax,%ecx
c0108aaf:	83 e1 02             	and    $0x2,%ecx
c0108ab2:	85 c9                	test   %ecx,%ecx
c0108ab4:	74 0f                	je     c0108ac5 <copy_thread+0x56>
c0108ab6:	0f b7 0a             	movzwl (%edx),%ecx
c0108ab9:	66 89 08             	mov    %cx,(%eax)
c0108abc:	83 c0 02             	add    $0x2,%eax
c0108abf:	83 c2 02             	add    $0x2,%edx
c0108ac2:	83 eb 02             	sub    $0x2,%ebx
c0108ac5:	89 d9                	mov    %ebx,%ecx
c0108ac7:	c1 e9 02             	shr    $0x2,%ecx
c0108aca:	89 c7                	mov    %eax,%edi
c0108acc:	89 d6                	mov    %edx,%esi
c0108ace:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108ad0:	89 f2                	mov    %esi,%edx
c0108ad2:	89 f8                	mov    %edi,%eax
c0108ad4:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108ad9:	89 de                	mov    %ebx,%esi
c0108adb:	83 e6 02             	and    $0x2,%esi
c0108ade:	85 f6                	test   %esi,%esi
c0108ae0:	74 0b                	je     c0108aed <copy_thread+0x7e>
c0108ae2:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108ae6:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108aea:	83 c1 02             	add    $0x2,%ecx
c0108aed:	83 e3 01             	and    $0x1,%ebx
c0108af0:	85 db                	test   %ebx,%ebx
c0108af2:	74 07                	je     c0108afb <copy_thread+0x8c>
c0108af4:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108af8:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108afe:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b01:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b0b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108b11:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108b14:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b17:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b1a:	8b 55 08             	mov    0x8(%ebp),%edx
c0108b1d:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108b20:	8b 52 40             	mov    0x40(%edx),%edx
c0108b23:	80 ce 02             	or     $0x2,%dh
c0108b26:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108b29:	ba 58 88 10 c0       	mov    $0xc0108858,%edx
c0108b2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b31:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b37:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b3a:	89 c2                	mov    %eax,%edx
c0108b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b3f:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108b42:	5b                   	pop    %ebx
c0108b43:	5e                   	pop    %esi
c0108b44:	5f                   	pop    %edi
c0108b45:	5d                   	pop    %ebp
c0108b46:	c3                   	ret    

c0108b47 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108b47:	55                   	push   %ebp
c0108b48:	89 e5                	mov    %esp,%ebp
c0108b4a:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108b4d:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108b54:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108b59:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108b5e:	7e 05                	jle    c0108b65 <do_fork+0x1e>
        goto fork_out;
c0108b60:	e9 06 01 00 00       	jmp    c0108c6b <do_fork+0x124>
    }
    ret = -E_NO_MEM;
c0108b65:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
     * VARIABLES:
     *   proc_list:    the process set's list
     *   nr_process:   the number of process set
     */

    if ((proc = alloc_proc()) == NULL){		// 1. call alloc_proc to allocate a proc_struct
c0108b6c:	e8 30 fa ff ff       	call   c01085a1 <alloc_proc>
c0108b71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108b74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108b78:	75 05                	jne    c0108b7f <do_fork+0x38>
    	goto fork_out;
c0108b7a:	e9 ec 00 00 00       	jmp    c0108c6b <do_fork+0x124>
    }

    if (setup_kstack(proc) < 0){	    	// 2. call setup_kstack to allocate a kernel stack for child process
c0108b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b82:	89 04 24             	mov    %eax,(%esp)
c0108b85:	e8 46 fe ff ff       	call   c01089d0 <setup_kstack>
c0108b8a:	85 c0                	test   %eax,%eax
c0108b8c:	79 05                	jns    c0108b93 <do_fork+0x4c>
    	goto bad_fork_cleanup_proc;
c0108b8e:	e9 dd 00 00 00       	jmp    c0108c70 <do_fork+0x129>
    }

    if (copy_mm(clone_flags, proc) != 0){ 	// 3. call copy_mm to dup OR share mm according clone_flag
c0108b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b9d:	89 04 24             	mov    %eax,(%esp)
c0108ba0:	e8 8d fe ff ff       	call   c0108a32 <copy_mm>
c0108ba5:	85 c0                	test   %eax,%eax
c0108ba7:	74 11                	je     c0108bba <do_fork+0x73>
    	goto bad_fork_cleanup_kstack;
c0108ba9:	90                   	nop

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108baa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bad:	89 04 24             	mov    %eax,(%esp)
c0108bb0:	e8 57 fe ff ff       	call   c0108a0c <put_kstack>
c0108bb5:	e9 b6 00 00 00       	jmp    c0108c70 <do_fork+0x129>

    if (copy_mm(clone_flags, proc) != 0){ 	// 3. call copy_mm to dup OR share mm according clone_flag
    	goto bad_fork_cleanup_kstack;
    }

    proc->parent = current;
c0108bba:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108bc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bc3:	89 50 14             	mov    %edx,0x14(%eax)

    copy_thread(proc, stack, tf); 			// 4. call copy_thread to setup tf & context in proc_struct
c0108bc6:	8b 45 10             	mov    0x10(%ebp),%eax
c0108bc9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bd7:	89 04 24             	mov    %eax,(%esp)
c0108bda:	e8 90 fe ff ff       	call   c0108a6f <copy_thread>

    proc->pid = get_pid();
c0108bdf:	e8 07 fb ff ff       	call   c01086eb <get_pid>
c0108be4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108be7:	89 42 04             	mov    %eax,0x4(%edx)
    hash_proc(proc);						// 5. insert proc_struct into hash_list && proc_list
c0108bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bed:	89 04 24             	mov    %eax,(%esp)
c0108bf0:	e8 7b fc ff ff       	call   c0108870 <hash_proc>
    list_add(&proc_list, &(proc->list_link));
c0108bf5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bf8:	83 c0 58             	add    $0x58,%eax
c0108bfb:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
c0108c02:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c08:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108c0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108c11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c14:	8b 40 04             	mov    0x4(%eax),%eax
c0108c17:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0108c1d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108c20:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0108c23:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c29:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108c2c:	89 10                	mov    %edx,(%eax)
c0108c2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108c31:	8b 10                	mov    (%eax),%edx
c0108c33:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108c36:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108c39:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c3c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108c3f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108c42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108c45:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108c48:	89 10                	mov    %edx,(%eax)
    nr_process ++;
c0108c4a:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108c4f:	83 c0 01             	add    $0x1,%eax
c0108c52:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    wakeup_proc(proc);						// 6. call wakup_proc to make the new child process RUNNABLE
c0108c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c5a:	89 04 24             	mov    %eax,(%esp)
c0108c5d:	e8 e3 02 00 00       	call   c0108f45 <wakeup_proc>

    ret = proc->pid;						// 7. set ret vaule using child proc's pid
c0108c62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c65:	8b 40 04             	mov    0x4(%eax),%eax
c0108c68:	89 45 f4             	mov    %eax,-0xc(%ebp)

fork_out:
    return ret;
c0108c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c6e:	eb 0d                	jmp    c0108c7d <do_fork+0x136>

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c73:	89 04 24             	mov    %eax,(%esp)
c0108c76:	e8 a4 bc ff ff       	call   c010491f <kfree>
    goto fork_out;
c0108c7b:	eb ee                	jmp    c0108c6b <do_fork+0x124>
}
c0108c7d:	c9                   	leave  
c0108c7e:	c3                   	ret    

c0108c7f <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108c7f:	55                   	push   %ebp
c0108c80:	89 e5                	mov    %esp,%ebp
c0108c82:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108c85:	c7 44 24 08 1d bb 10 	movl   $0xc010bb1d,0x8(%esp)
c0108c8c:	c0 
c0108c8d:	c7 44 24 04 5a 01 00 	movl   $0x15a,0x4(%esp)
c0108c94:	00 
c0108c95:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108c9c:	e8 3c 80 ff ff       	call   c0100cdd <__panic>

c0108ca1 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108ca1:	55                   	push   %ebp
c0108ca2:	89 e5                	mov    %esp,%ebp
c0108ca4:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108ca7:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108cac:	89 04 24             	mov    %eax,(%esp)
c0108caf:	e8 f5 f9 ff ff       	call   c01086a9 <get_proc_name>
c0108cb4:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108cba:	8b 52 04             	mov    0x4(%edx),%edx
c0108cbd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cc1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108cc5:	c7 04 24 30 bb 10 c0 	movl   $0xc010bb30,(%esp)
c0108ccc:	e8 82 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0108cd1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108cd8:	c7 04 24 56 bb 10 c0 	movl   $0xc010bb56,(%esp)
c0108cdf:	e8 6f 76 ff ff       	call   c0100353 <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0108ce4:	c7 04 24 63 bb 10 c0 	movl   $0xc010bb63,(%esp)
c0108ceb:	e8 63 76 ff ff       	call   c0100353 <cprintf>
    return 0;
c0108cf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108cf5:	c9                   	leave  
c0108cf6:	c3                   	ret    

c0108cf7 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0108cf7:	55                   	push   %ebp
c0108cf8:	89 e5                	mov    %esp,%ebp
c0108cfa:	83 ec 28             	sub    $0x28,%esp
c0108cfd:	c7 45 ec 10 7c 12 c0 	movl   $0xc0127c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0108d04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d07:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108d0a:	89 50 04             	mov    %edx,0x4(%eax)
c0108d0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d10:	8b 50 04             	mov    0x4(%eax),%edx
c0108d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d16:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d1f:	eb 26                	jmp    c0108d47 <proc_init+0x50>
        list_init(hash_list + i);
c0108d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d24:	c1 e0 03             	shl    $0x3,%eax
c0108d27:	05 00 5b 12 c0       	add    $0xc0125b00,%eax
c0108d2c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108d2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d32:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108d35:	89 50 04             	mov    %edx,0x4(%eax)
c0108d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d3b:	8b 50 04             	mov    0x4(%eax),%edx
c0108d3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d41:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0108d43:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108d47:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c0108d4e:	7e d1                	jle    c0108d21 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0108d50:	e8 4c f8 ff ff       	call   c01085a1 <alloc_proc>
c0108d55:	a3 e0 5a 12 c0       	mov    %eax,0xc0125ae0
c0108d5a:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d5f:	85 c0                	test   %eax,%eax
c0108d61:	75 1c                	jne    c0108d7f <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c0108d63:	c7 44 24 08 7f bb 10 	movl   $0xc010bb7f,0x8(%esp)
c0108d6a:	c0 
c0108d6b:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
c0108d72:	00 
c0108d73:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108d7a:	e8 5e 7f ff ff       	call   c0100cdd <__panic>
    }

    idleproc->pid = 0;
c0108d7f:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d84:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c0108d8b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d90:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c0108d96:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108d9b:	ba 00 20 12 c0       	mov    $0xc0122000,%edx
c0108da0:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c0108da3:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108da8:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c0108daf:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108db4:	c7 44 24 04 97 bb 10 	movl   $0xc010bb97,0x4(%esp)
c0108dbb:	c0 
c0108dbc:	89 04 24             	mov    %eax,(%esp)
c0108dbf:	e8 a2 f8 ff ff       	call   c0108666 <set_proc_name>
    nr_process ++;
c0108dc4:	a1 00 7b 12 c0       	mov    0xc0127b00,%eax
c0108dc9:	83 c0 01             	add    $0x1,%eax
c0108dcc:	a3 00 7b 12 c0       	mov    %eax,0xc0127b00

    current = idleproc;
c0108dd1:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108dd6:	a3 e8 5a 12 c0       	mov    %eax,0xc0125ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c0108ddb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108de2:	00 
c0108de3:	c7 44 24 04 9c bb 10 	movl   $0xc010bb9c,0x4(%esp)
c0108dea:	c0 
c0108deb:	c7 04 24 a1 8c 10 c0 	movl   $0xc0108ca1,(%esp)
c0108df2:	e8 67 fb ff ff       	call   c010895e <kernel_thread>
c0108df7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c0108dfa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108dfe:	7f 1c                	jg     c0108e1c <proc_init+0x125>
        panic("create init_main failed.\n");
c0108e00:	c7 44 24 08 aa bb 10 	movl   $0xc010bbaa,0x8(%esp)
c0108e07:	c0 
c0108e08:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
c0108e0f:	00 
c0108e10:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108e17:	e8 c1 7e ff ff       	call   c0100cdd <__panic>
    }

    initproc = find_proc(pid);
c0108e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108e1f:	89 04 24             	mov    %eax,(%esp)
c0108e22:	e8 c5 fa ff ff       	call   c01088ec <find_proc>
c0108e27:	a3 e4 5a 12 c0       	mov    %eax,0xc0125ae4
    set_proc_name(initproc, "init");
c0108e2c:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e31:	c7 44 24 04 c4 bb 10 	movl   $0xc010bbc4,0x4(%esp)
c0108e38:	c0 
c0108e39:	89 04 24             	mov    %eax,(%esp)
c0108e3c:	e8 25 f8 ff ff       	call   c0108666 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0108e41:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e46:	85 c0                	test   %eax,%eax
c0108e48:	74 0c                	je     c0108e56 <proc_init+0x15f>
c0108e4a:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108e4f:	8b 40 04             	mov    0x4(%eax),%eax
c0108e52:	85 c0                	test   %eax,%eax
c0108e54:	74 24                	je     c0108e7a <proc_init+0x183>
c0108e56:	c7 44 24 0c cc bb 10 	movl   $0xc010bbcc,0xc(%esp)
c0108e5d:	c0 
c0108e5e:	c7 44 24 08 f4 ba 10 	movl   $0xc010baf4,0x8(%esp)
c0108e65:	c0 
c0108e66:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
c0108e6d:	00 
c0108e6e:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108e75:	e8 63 7e ff ff       	call   c0100cdd <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c0108e7a:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e7f:	85 c0                	test   %eax,%eax
c0108e81:	74 0d                	je     c0108e90 <proc_init+0x199>
c0108e83:	a1 e4 5a 12 c0       	mov    0xc0125ae4,%eax
c0108e88:	8b 40 04             	mov    0x4(%eax),%eax
c0108e8b:	83 f8 01             	cmp    $0x1,%eax
c0108e8e:	74 24                	je     c0108eb4 <proc_init+0x1bd>
c0108e90:	c7 44 24 0c f4 bb 10 	movl   $0xc010bbf4,0xc(%esp)
c0108e97:	c0 
c0108e98:	c7 44 24 08 f4 ba 10 	movl   $0xc010baf4,0x8(%esp)
c0108e9f:	c0 
c0108ea0:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c0108ea7:	00 
c0108ea8:	c7 04 24 09 bb 10 c0 	movl   $0xc010bb09,(%esp)
c0108eaf:	e8 29 7e ff ff       	call   c0100cdd <__panic>
}
c0108eb4:	c9                   	leave  
c0108eb5:	c3                   	ret    

c0108eb6 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c0108eb6:	55                   	push   %ebp
c0108eb7:	89 e5                	mov    %esp,%ebp
c0108eb9:	83 ec 08             	sub    $0x8,%esp
    while (1) {
        if (current->need_resched) {
c0108ebc:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108ec1:	8b 40 10             	mov    0x10(%eax),%eax
c0108ec4:	85 c0                	test   %eax,%eax
c0108ec6:	74 07                	je     c0108ecf <cpu_idle+0x19>
            schedule();
c0108ec8:	e8 c1 00 00 00       	call   c0108f8e <schedule>
        }
    }
c0108ecd:	eb ed                	jmp    c0108ebc <cpu_idle+0x6>
c0108ecf:	eb eb                	jmp    c0108ebc <cpu_idle+0x6>

c0108ed1 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0108ed1:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0108ed5:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c0108ed7:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c0108eda:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0108edd:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0108ee0:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0108ee3:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0108ee6:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c0108ee9:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c0108eec:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0108ef0:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0108ef3:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0108ef6:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c0108ef9:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c0108efc:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0108eff:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0108f02:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0108f05:	ff 30                	pushl  (%eax)

    ret
c0108f07:	c3                   	ret    

c0108f08 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108f08:	55                   	push   %ebp
c0108f09:	89 e5                	mov    %esp,%ebp
c0108f0b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108f0e:	9c                   	pushf  
c0108f0f:	58                   	pop    %eax
c0108f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0108f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0108f16:	25 00 02 00 00       	and    $0x200,%eax
c0108f1b:	85 c0                	test   %eax,%eax
c0108f1d:	74 0c                	je     c0108f2b <__intr_save+0x23>
        intr_disable();
c0108f1f:	e8 11 90 ff ff       	call   c0101f35 <intr_disable>
        return 1;
c0108f24:	b8 01 00 00 00       	mov    $0x1,%eax
c0108f29:	eb 05                	jmp    c0108f30 <__intr_save+0x28>
    }
    return 0;
c0108f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108f30:	c9                   	leave  
c0108f31:	c3                   	ret    

c0108f32 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0108f32:	55                   	push   %ebp
c0108f33:	89 e5                	mov    %esp,%ebp
c0108f35:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0108f38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108f3c:	74 05                	je     c0108f43 <__intr_restore+0x11>
        intr_enable();
c0108f3e:	e8 ec 8f ff ff       	call   c0101f2f <intr_enable>
    }
}
c0108f43:	c9                   	leave  
c0108f44:	c3                   	ret    

c0108f45 <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c0108f45:	55                   	push   %ebp
c0108f46:	89 e5                	mov    %esp,%ebp
c0108f48:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0108f4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f4e:	8b 00                	mov    (%eax),%eax
c0108f50:	83 f8 03             	cmp    $0x3,%eax
c0108f53:	74 0a                	je     c0108f5f <wakeup_proc+0x1a>
c0108f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f58:	8b 00                	mov    (%eax),%eax
c0108f5a:	83 f8 02             	cmp    $0x2,%eax
c0108f5d:	75 24                	jne    c0108f83 <wakeup_proc+0x3e>
c0108f5f:	c7 44 24 0c 1c bc 10 	movl   $0xc010bc1c,0xc(%esp)
c0108f66:	c0 
c0108f67:	c7 44 24 08 57 bc 10 	movl   $0xc010bc57,0x8(%esp)
c0108f6e:	c0 
c0108f6f:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c0108f76:	00 
c0108f77:	c7 04 24 6c bc 10 c0 	movl   $0xc010bc6c,(%esp)
c0108f7e:	e8 5a 7d ff ff       	call   c0100cdd <__panic>
    proc->state = PROC_RUNNABLE;
c0108f83:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f86:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c0108f8c:	c9                   	leave  
c0108f8d:	c3                   	ret    

c0108f8e <schedule>:

void
schedule(void) {
c0108f8e:	55                   	push   %ebp
c0108f8f:	89 e5                	mov    %esp,%ebp
c0108f91:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c0108f94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c0108f9b:	e8 68 ff ff ff       	call   c0108f08 <__intr_save>
c0108fa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c0108fa3:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108fa8:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c0108faf:	8b 15 e8 5a 12 c0    	mov    0xc0125ae8,%edx
c0108fb5:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0108fba:	39 c2                	cmp    %eax,%edx
c0108fbc:	74 0a                	je     c0108fc8 <schedule+0x3a>
c0108fbe:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0108fc3:	83 c0 58             	add    $0x58,%eax
c0108fc6:	eb 05                	jmp    c0108fcd <schedule+0x3f>
c0108fc8:	b8 10 7c 12 c0       	mov    $0xc0127c10,%eax
c0108fcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0108fd0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108fd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108fd9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108fdc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108fdf:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c0108fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108fe5:	81 7d f4 10 7c 12 c0 	cmpl   $0xc0127c10,-0xc(%ebp)
c0108fec:	74 15                	je     c0109003 <schedule+0x75>
                next = le2proc(le, list_link);
c0108fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ff1:	83 e8 58             	sub    $0x58,%eax
c0108ff4:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0108ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ffa:	8b 00                	mov    (%eax),%eax
c0108ffc:	83 f8 02             	cmp    $0x2,%eax
c0108fff:	75 02                	jne    c0109003 <schedule+0x75>
                    break;
c0109001:	eb 08                	jmp    c010900b <schedule+0x7d>
                }
            }
        } while (le != last);
c0109003:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109006:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0109009:	75 cb                	jne    c0108fd6 <schedule+0x48>
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010900b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010900f:	74 0a                	je     c010901b <schedule+0x8d>
c0109011:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109014:	8b 00                	mov    (%eax),%eax
c0109016:	83 f8 02             	cmp    $0x2,%eax
c0109019:	74 08                	je     c0109023 <schedule+0x95>
            next = idleproc;
c010901b:	a1 e0 5a 12 c0       	mov    0xc0125ae0,%eax
c0109020:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c0109023:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109026:	8b 40 08             	mov    0x8(%eax),%eax
c0109029:	8d 50 01             	lea    0x1(%eax),%edx
c010902c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010902f:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c0109032:	a1 e8 5a 12 c0       	mov    0xc0125ae8,%eax
c0109037:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010903a:	74 0b                	je     c0109047 <schedule+0xb9>
            proc_run(next);
c010903c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010903f:	89 04 24             	mov    %eax,(%esp)
c0109042:	e8 9c f7 ff ff       	call   c01087e3 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109047:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010904a:	89 04 24             	mov    %eax,(%esp)
c010904d:	e8 e0 fe ff ff       	call   c0108f32 <__intr_restore>
}
c0109052:	c9                   	leave  
c0109053:	c3                   	ret    

c0109054 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c0109054:	55                   	push   %ebp
c0109055:	89 e5                	mov    %esp,%ebp
c0109057:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010905a:	8b 45 08             	mov    0x8(%ebp),%eax
c010905d:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c0109063:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return (hash >> (32 - bits));
c0109066:	b8 20 00 00 00       	mov    $0x20,%eax
c010906b:	2b 45 0c             	sub    0xc(%ebp),%eax
c010906e:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109071:	89 c1                	mov    %eax,%ecx
c0109073:	d3 ea                	shr    %cl,%edx
c0109075:	89 d0                	mov    %edx,%eax
}
c0109077:	c9                   	leave  
c0109078:	c3                   	ret    

c0109079 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0109079:	55                   	push   %ebp
c010907a:	89 e5                	mov    %esp,%ebp
c010907c:	83 ec 58             	sub    $0x58,%esp
c010907f:	8b 45 10             	mov    0x10(%ebp),%eax
c0109082:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109085:	8b 45 14             	mov    0x14(%ebp),%eax
c0109088:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010908b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010908e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0109091:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109094:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0109097:	8b 45 18             	mov    0x18(%ebp),%eax
c010909a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010909d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01090a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01090a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01090a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01090a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01090af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01090b3:	74 1c                	je     c01090d1 <printnum+0x58>
c01090b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01090bd:	f7 75 e4             	divl   -0x1c(%ebp)
c01090c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01090c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01090c6:	ba 00 00 00 00       	mov    $0x0,%edx
c01090cb:	f7 75 e4             	divl   -0x1c(%ebp)
c01090ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01090d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01090d7:	f7 75 e4             	divl   -0x1c(%ebp)
c01090da:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01090dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01090e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01090e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01090e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01090e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01090ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01090ef:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01090f2:	8b 45 18             	mov    0x18(%ebp),%eax
c01090f5:	ba 00 00 00 00       	mov    $0x0,%edx
c01090fa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01090fd:	77 56                	ja     c0109155 <printnum+0xdc>
c01090ff:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109102:	72 05                	jb     c0109109 <printnum+0x90>
c0109104:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0109107:	77 4c                	ja     c0109155 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0109109:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010910c:	8d 50 ff             	lea    -0x1(%eax),%edx
c010910f:	8b 45 20             	mov    0x20(%ebp),%eax
c0109112:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109116:	89 54 24 14          	mov    %edx,0x14(%esp)
c010911a:	8b 45 18             	mov    0x18(%ebp),%eax
c010911d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0109121:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109124:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109127:	89 44 24 08          	mov    %eax,0x8(%esp)
c010912b:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010912f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109132:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109136:	8b 45 08             	mov    0x8(%ebp),%eax
c0109139:	89 04 24             	mov    %eax,(%esp)
c010913c:	e8 38 ff ff ff       	call   c0109079 <printnum>
c0109141:	eb 1c                	jmp    c010915f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0109143:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109146:	89 44 24 04          	mov    %eax,0x4(%esp)
c010914a:	8b 45 20             	mov    0x20(%ebp),%eax
c010914d:	89 04 24             	mov    %eax,(%esp)
c0109150:	8b 45 08             	mov    0x8(%ebp),%eax
c0109153:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0109155:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0109159:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010915d:	7f e4                	jg     c0109143 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010915f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109162:	05 04 bd 10 c0       	add    $0xc010bd04,%eax
c0109167:	0f b6 00             	movzbl (%eax),%eax
c010916a:	0f be c0             	movsbl %al,%eax
c010916d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109170:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109174:	89 04 24             	mov    %eax,(%esp)
c0109177:	8b 45 08             	mov    0x8(%ebp),%eax
c010917a:	ff d0                	call   *%eax
}
c010917c:	c9                   	leave  
c010917d:	c3                   	ret    

c010917e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010917e:	55                   	push   %ebp
c010917f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109181:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0109185:	7e 14                	jle    c010919b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0109187:	8b 45 08             	mov    0x8(%ebp),%eax
c010918a:	8b 00                	mov    (%eax),%eax
c010918c:	8d 48 08             	lea    0x8(%eax),%ecx
c010918f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109192:	89 0a                	mov    %ecx,(%edx)
c0109194:	8b 50 04             	mov    0x4(%eax),%edx
c0109197:	8b 00                	mov    (%eax),%eax
c0109199:	eb 30                	jmp    c01091cb <getuint+0x4d>
    }
    else if (lflag) {
c010919b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010919f:	74 16                	je     c01091b7 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01091a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01091a4:	8b 00                	mov    (%eax),%eax
c01091a6:	8d 48 04             	lea    0x4(%eax),%ecx
c01091a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01091ac:	89 0a                	mov    %ecx,(%edx)
c01091ae:	8b 00                	mov    (%eax),%eax
c01091b0:	ba 00 00 00 00       	mov    $0x0,%edx
c01091b5:	eb 14                	jmp    c01091cb <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01091b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01091ba:	8b 00                	mov    (%eax),%eax
c01091bc:	8d 48 04             	lea    0x4(%eax),%ecx
c01091bf:	8b 55 08             	mov    0x8(%ebp),%edx
c01091c2:	89 0a                	mov    %ecx,(%edx)
c01091c4:	8b 00                	mov    (%eax),%eax
c01091c6:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01091cb:	5d                   	pop    %ebp
c01091cc:	c3                   	ret    

c01091cd <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01091cd:	55                   	push   %ebp
c01091ce:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01091d0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01091d4:	7e 14                	jle    c01091ea <getint+0x1d>
        return va_arg(*ap, long long);
c01091d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01091d9:	8b 00                	mov    (%eax),%eax
c01091db:	8d 48 08             	lea    0x8(%eax),%ecx
c01091de:	8b 55 08             	mov    0x8(%ebp),%edx
c01091e1:	89 0a                	mov    %ecx,(%edx)
c01091e3:	8b 50 04             	mov    0x4(%eax),%edx
c01091e6:	8b 00                	mov    (%eax),%eax
c01091e8:	eb 28                	jmp    c0109212 <getint+0x45>
    }
    else if (lflag) {
c01091ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01091ee:	74 12                	je     c0109202 <getint+0x35>
        return va_arg(*ap, long);
c01091f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01091f3:	8b 00                	mov    (%eax),%eax
c01091f5:	8d 48 04             	lea    0x4(%eax),%ecx
c01091f8:	8b 55 08             	mov    0x8(%ebp),%edx
c01091fb:	89 0a                	mov    %ecx,(%edx)
c01091fd:	8b 00                	mov    (%eax),%eax
c01091ff:	99                   	cltd   
c0109200:	eb 10                	jmp    c0109212 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0109202:	8b 45 08             	mov    0x8(%ebp),%eax
c0109205:	8b 00                	mov    (%eax),%eax
c0109207:	8d 48 04             	lea    0x4(%eax),%ecx
c010920a:	8b 55 08             	mov    0x8(%ebp),%edx
c010920d:	89 0a                	mov    %ecx,(%edx)
c010920f:	8b 00                	mov    (%eax),%eax
c0109211:	99                   	cltd   
    }
}
c0109212:	5d                   	pop    %ebp
c0109213:	c3                   	ret    

c0109214 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0109214:	55                   	push   %ebp
c0109215:	89 e5                	mov    %esp,%ebp
c0109217:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010921a:	8d 45 14             	lea    0x14(%ebp),%eax
c010921d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0109220:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109223:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109227:	8b 45 10             	mov    0x10(%ebp),%eax
c010922a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010922e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109231:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109235:	8b 45 08             	mov    0x8(%ebp),%eax
c0109238:	89 04 24             	mov    %eax,(%esp)
c010923b:	e8 02 00 00 00       	call   c0109242 <vprintfmt>
    va_end(ap);
}
c0109240:	c9                   	leave  
c0109241:	c3                   	ret    

c0109242 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0109242:	55                   	push   %ebp
c0109243:	89 e5                	mov    %esp,%ebp
c0109245:	56                   	push   %esi
c0109246:	53                   	push   %ebx
c0109247:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010924a:	eb 18                	jmp    c0109264 <vprintfmt+0x22>
            if (ch == '\0') {
c010924c:	85 db                	test   %ebx,%ebx
c010924e:	75 05                	jne    c0109255 <vprintfmt+0x13>
                return;
c0109250:	e9 d1 03 00 00       	jmp    c0109626 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0109255:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109258:	89 44 24 04          	mov    %eax,0x4(%esp)
c010925c:	89 1c 24             	mov    %ebx,(%esp)
c010925f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109262:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109264:	8b 45 10             	mov    0x10(%ebp),%eax
c0109267:	8d 50 01             	lea    0x1(%eax),%edx
c010926a:	89 55 10             	mov    %edx,0x10(%ebp)
c010926d:	0f b6 00             	movzbl (%eax),%eax
c0109270:	0f b6 d8             	movzbl %al,%ebx
c0109273:	83 fb 25             	cmp    $0x25,%ebx
c0109276:	75 d4                	jne    c010924c <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0109278:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010927c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109283:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109286:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0109289:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109290:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109293:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0109296:	8b 45 10             	mov    0x10(%ebp),%eax
c0109299:	8d 50 01             	lea    0x1(%eax),%edx
c010929c:	89 55 10             	mov    %edx,0x10(%ebp)
c010929f:	0f b6 00             	movzbl (%eax),%eax
c01092a2:	0f b6 d8             	movzbl %al,%ebx
c01092a5:	8d 43 dd             	lea    -0x23(%ebx),%eax
c01092a8:	83 f8 55             	cmp    $0x55,%eax
c01092ab:	0f 87 44 03 00 00    	ja     c01095f5 <vprintfmt+0x3b3>
c01092b1:	8b 04 85 28 bd 10 c0 	mov    -0x3fef42d8(,%eax,4),%eax
c01092b8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01092ba:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01092be:	eb d6                	jmp    c0109296 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01092c0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01092c4:	eb d0                	jmp    c0109296 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01092c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01092cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01092d0:	89 d0                	mov    %edx,%eax
c01092d2:	c1 e0 02             	shl    $0x2,%eax
c01092d5:	01 d0                	add    %edx,%eax
c01092d7:	01 c0                	add    %eax,%eax
c01092d9:	01 d8                	add    %ebx,%eax
c01092db:	83 e8 30             	sub    $0x30,%eax
c01092de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01092e1:	8b 45 10             	mov    0x10(%ebp),%eax
c01092e4:	0f b6 00             	movzbl (%eax),%eax
c01092e7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01092ea:	83 fb 2f             	cmp    $0x2f,%ebx
c01092ed:	7e 0b                	jle    c01092fa <vprintfmt+0xb8>
c01092ef:	83 fb 39             	cmp    $0x39,%ebx
c01092f2:	7f 06                	jg     c01092fa <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01092f4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01092f8:	eb d3                	jmp    c01092cd <vprintfmt+0x8b>
            goto process_precision;
c01092fa:	eb 33                	jmp    c010932f <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01092fc:	8b 45 14             	mov    0x14(%ebp),%eax
c01092ff:	8d 50 04             	lea    0x4(%eax),%edx
c0109302:	89 55 14             	mov    %edx,0x14(%ebp)
c0109305:	8b 00                	mov    (%eax),%eax
c0109307:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010930a:	eb 23                	jmp    c010932f <vprintfmt+0xed>

        case '.':
            if (width < 0)
c010930c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109310:	79 0c                	jns    c010931e <vprintfmt+0xdc>
                width = 0;
c0109312:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0109319:	e9 78 ff ff ff       	jmp    c0109296 <vprintfmt+0x54>
c010931e:	e9 73 ff ff ff       	jmp    c0109296 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0109323:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010932a:	e9 67 ff ff ff       	jmp    c0109296 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010932f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109333:	79 12                	jns    c0109347 <vprintfmt+0x105>
                width = precision, precision = -1;
c0109335:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109338:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010933b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0109342:	e9 4f ff ff ff       	jmp    c0109296 <vprintfmt+0x54>
c0109347:	e9 4a ff ff ff       	jmp    c0109296 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010934c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0109350:	e9 41 ff ff ff       	jmp    c0109296 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0109355:	8b 45 14             	mov    0x14(%ebp),%eax
c0109358:	8d 50 04             	lea    0x4(%eax),%edx
c010935b:	89 55 14             	mov    %edx,0x14(%ebp)
c010935e:	8b 00                	mov    (%eax),%eax
c0109360:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109363:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109367:	89 04 24             	mov    %eax,(%esp)
c010936a:	8b 45 08             	mov    0x8(%ebp),%eax
c010936d:	ff d0                	call   *%eax
            break;
c010936f:	e9 ac 02 00 00       	jmp    c0109620 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109374:	8b 45 14             	mov    0x14(%ebp),%eax
c0109377:	8d 50 04             	lea    0x4(%eax),%edx
c010937a:	89 55 14             	mov    %edx,0x14(%ebp)
c010937d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010937f:	85 db                	test   %ebx,%ebx
c0109381:	79 02                	jns    c0109385 <vprintfmt+0x143>
                err = -err;
c0109383:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109385:	83 fb 06             	cmp    $0x6,%ebx
c0109388:	7f 0b                	jg     c0109395 <vprintfmt+0x153>
c010938a:	8b 34 9d e8 bc 10 c0 	mov    -0x3fef4318(,%ebx,4),%esi
c0109391:	85 f6                	test   %esi,%esi
c0109393:	75 23                	jne    c01093b8 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0109395:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0109399:	c7 44 24 08 15 bd 10 	movl   $0xc010bd15,0x8(%esp)
c01093a0:	c0 
c01093a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ab:	89 04 24             	mov    %eax,(%esp)
c01093ae:	e8 61 fe ff ff       	call   c0109214 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c01093b3:	e9 68 02 00 00       	jmp    c0109620 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01093b8:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01093bc:	c7 44 24 08 1e bd 10 	movl   $0xc010bd1e,0x8(%esp)
c01093c3:	c0 
c01093c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01093c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01093cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01093ce:	89 04 24             	mov    %eax,(%esp)
c01093d1:	e8 3e fe ff ff       	call   c0109214 <printfmt>
            }
            break;
c01093d6:	e9 45 02 00 00       	jmp    c0109620 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01093db:	8b 45 14             	mov    0x14(%ebp),%eax
c01093de:	8d 50 04             	lea    0x4(%eax),%edx
c01093e1:	89 55 14             	mov    %edx,0x14(%ebp)
c01093e4:	8b 30                	mov    (%eax),%esi
c01093e6:	85 f6                	test   %esi,%esi
c01093e8:	75 05                	jne    c01093ef <vprintfmt+0x1ad>
                p = "(null)";
c01093ea:	be 21 bd 10 c0       	mov    $0xc010bd21,%esi
            }
            if (width > 0 && padc != '-') {
c01093ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01093f3:	7e 3e                	jle    c0109433 <vprintfmt+0x1f1>
c01093f5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01093f9:	74 38                	je     c0109433 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01093fb:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01093fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109401:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109405:	89 34 24             	mov    %esi,(%esp)
c0109408:	e8 ed 03 00 00       	call   c01097fa <strnlen>
c010940d:	29 c3                	sub    %eax,%ebx
c010940f:	89 d8                	mov    %ebx,%eax
c0109411:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109414:	eb 17                	jmp    c010942d <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0109416:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010941a:	8b 55 0c             	mov    0xc(%ebp),%edx
c010941d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109421:	89 04 24             	mov    %eax,(%esp)
c0109424:	8b 45 08             	mov    0x8(%ebp),%eax
c0109427:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0109429:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010942d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109431:	7f e3                	jg     c0109416 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109433:	eb 38                	jmp    c010946d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0109435:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0109439:	74 1f                	je     c010945a <vprintfmt+0x218>
c010943b:	83 fb 1f             	cmp    $0x1f,%ebx
c010943e:	7e 05                	jle    c0109445 <vprintfmt+0x203>
c0109440:	83 fb 7e             	cmp    $0x7e,%ebx
c0109443:	7e 15                	jle    c010945a <vprintfmt+0x218>
                    putch('?', putdat);
c0109445:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109448:	89 44 24 04          	mov    %eax,0x4(%esp)
c010944c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0109453:	8b 45 08             	mov    0x8(%ebp),%eax
c0109456:	ff d0                	call   *%eax
c0109458:	eb 0f                	jmp    c0109469 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010945a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010945d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109461:	89 1c 24             	mov    %ebx,(%esp)
c0109464:	8b 45 08             	mov    0x8(%ebp),%eax
c0109467:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0109469:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010946d:	89 f0                	mov    %esi,%eax
c010946f:	8d 70 01             	lea    0x1(%eax),%esi
c0109472:	0f b6 00             	movzbl (%eax),%eax
c0109475:	0f be d8             	movsbl %al,%ebx
c0109478:	85 db                	test   %ebx,%ebx
c010947a:	74 10                	je     c010948c <vprintfmt+0x24a>
c010947c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109480:	78 b3                	js     c0109435 <vprintfmt+0x1f3>
c0109482:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0109486:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010948a:	79 a9                	jns    c0109435 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010948c:	eb 17                	jmp    c01094a5 <vprintfmt+0x263>
                putch(' ', putdat);
c010948e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109491:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109495:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010949c:	8b 45 08             	mov    0x8(%ebp),%eax
c010949f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c01094a1:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01094a5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01094a9:	7f e3                	jg     c010948e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c01094ab:	e9 70 01 00 00       	jmp    c0109620 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c01094b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01094b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094b7:	8d 45 14             	lea    0x14(%ebp),%eax
c01094ba:	89 04 24             	mov    %eax,(%esp)
c01094bd:	e8 0b fd ff ff       	call   c01091cd <getint>
c01094c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01094c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01094ce:	85 d2                	test   %edx,%edx
c01094d0:	79 26                	jns    c01094f8 <vprintfmt+0x2b6>
                putch('-', putdat);
c01094d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094d9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01094e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01094e3:	ff d0                	call   *%eax
                num = -(long long)num;
c01094e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01094e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01094eb:	f7 d8                	neg    %eax
c01094ed:	83 d2 00             	adc    $0x0,%edx
c01094f0:	f7 da                	neg    %edx
c01094f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01094f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01094f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01094ff:	e9 a8 00 00 00       	jmp    c01095ac <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0109504:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109507:	89 44 24 04          	mov    %eax,0x4(%esp)
c010950b:	8d 45 14             	lea    0x14(%ebp),%eax
c010950e:	89 04 24             	mov    %eax,(%esp)
c0109511:	e8 68 fc ff ff       	call   c010917e <getuint>
c0109516:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109519:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010951c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109523:	e9 84 00 00 00       	jmp    c01095ac <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0109528:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010952b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010952f:	8d 45 14             	lea    0x14(%ebp),%eax
c0109532:	89 04 24             	mov    %eax,(%esp)
c0109535:	e8 44 fc ff ff       	call   c010917e <getuint>
c010953a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010953d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0109540:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0109547:	eb 63                	jmp    c01095ac <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0109549:	8b 45 0c             	mov    0xc(%ebp),%eax
c010954c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109550:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0109557:	8b 45 08             	mov    0x8(%ebp),%eax
c010955a:	ff d0                	call   *%eax
            putch('x', putdat);
c010955c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010955f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109563:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010956a:	8b 45 08             	mov    0x8(%ebp),%eax
c010956d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010956f:	8b 45 14             	mov    0x14(%ebp),%eax
c0109572:	8d 50 04             	lea    0x4(%eax),%edx
c0109575:	89 55 14             	mov    %edx,0x14(%ebp)
c0109578:	8b 00                	mov    (%eax),%eax
c010957a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010957d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0109584:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010958b:	eb 1f                	jmp    c01095ac <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010958d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109590:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109594:	8d 45 14             	lea    0x14(%ebp),%eax
c0109597:	89 04 24             	mov    %eax,(%esp)
c010959a:	e8 df fb ff ff       	call   c010917e <getuint>
c010959f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01095a2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c01095a5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c01095ac:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c01095b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01095b3:	89 54 24 18          	mov    %edx,0x18(%esp)
c01095b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01095ba:	89 54 24 14          	mov    %edx,0x14(%esp)
c01095be:	89 44 24 10          	mov    %eax,0x10(%esp)
c01095c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01095c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01095c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01095cc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01095d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095da:	89 04 24             	mov    %eax,(%esp)
c01095dd:	e8 97 fa ff ff       	call   c0109079 <printnum>
            break;
c01095e2:	eb 3c                	jmp    c0109620 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01095e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095eb:	89 1c 24             	mov    %ebx,(%esp)
c01095ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f1:	ff d0                	call   *%eax
            break;
c01095f3:	eb 2b                	jmp    c0109620 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01095f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095fc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0109603:	8b 45 08             	mov    0x8(%ebp),%eax
c0109606:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0109608:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010960c:	eb 04                	jmp    c0109612 <vprintfmt+0x3d0>
c010960e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109612:	8b 45 10             	mov    0x10(%ebp),%eax
c0109615:	83 e8 01             	sub    $0x1,%eax
c0109618:	0f b6 00             	movzbl (%eax),%eax
c010961b:	3c 25                	cmp    $0x25,%al
c010961d:	75 ef                	jne    c010960e <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010961f:	90                   	nop
        }
    }
c0109620:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0109621:	e9 3e fc ff ff       	jmp    c0109264 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0109626:	83 c4 40             	add    $0x40,%esp
c0109629:	5b                   	pop    %ebx
c010962a:	5e                   	pop    %esi
c010962b:	5d                   	pop    %ebp
c010962c:	c3                   	ret    

c010962d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010962d:	55                   	push   %ebp
c010962e:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0109630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109633:	8b 40 08             	mov    0x8(%eax),%eax
c0109636:	8d 50 01             	lea    0x1(%eax),%edx
c0109639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010963c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010963f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109642:	8b 10                	mov    (%eax),%edx
c0109644:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109647:	8b 40 04             	mov    0x4(%eax),%eax
c010964a:	39 c2                	cmp    %eax,%edx
c010964c:	73 12                	jae    c0109660 <sprintputch+0x33>
        *b->buf ++ = ch;
c010964e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109651:	8b 00                	mov    (%eax),%eax
c0109653:	8d 48 01             	lea    0x1(%eax),%ecx
c0109656:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109659:	89 0a                	mov    %ecx,(%edx)
c010965b:	8b 55 08             	mov    0x8(%ebp),%edx
c010965e:	88 10                	mov    %dl,(%eax)
    }
}
c0109660:	5d                   	pop    %ebp
c0109661:	c3                   	ret    

c0109662 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0109662:	55                   	push   %ebp
c0109663:	89 e5                	mov    %esp,%ebp
c0109665:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109668:	8d 45 14             	lea    0x14(%ebp),%eax
c010966b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010966e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109671:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109675:	8b 45 10             	mov    0x10(%ebp),%eax
c0109678:	89 44 24 08          	mov    %eax,0x8(%esp)
c010967c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010967f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109683:	8b 45 08             	mov    0x8(%ebp),%eax
c0109686:	89 04 24             	mov    %eax,(%esp)
c0109689:	e8 08 00 00 00       	call   c0109696 <vsnprintf>
c010968e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109691:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109694:	c9                   	leave  
c0109695:	c3                   	ret    

c0109696 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109696:	55                   	push   %ebp
c0109697:	89 e5                	mov    %esp,%ebp
c0109699:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010969c:	8b 45 08             	mov    0x8(%ebp),%eax
c010969f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01096a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01096a5:	8d 50 ff             	lea    -0x1(%eax),%edx
c01096a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01096ab:	01 d0                	add    %edx,%eax
c01096ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01096b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01096b7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01096bb:	74 0a                	je     c01096c7 <vsnprintf+0x31>
c01096bd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01096c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01096c3:	39 c2                	cmp    %eax,%edx
c01096c5:	76 07                	jbe    c01096ce <vsnprintf+0x38>
        return -E_INVAL;
c01096c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01096cc:	eb 2a                	jmp    c01096f8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01096ce:	8b 45 14             	mov    0x14(%ebp),%eax
c01096d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01096d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01096d8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01096dc:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01096df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01096e3:	c7 04 24 2d 96 10 c0 	movl   $0xc010962d,(%esp)
c01096ea:	e8 53 fb ff ff       	call   c0109242 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01096ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01096f2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01096f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096f8:	c9                   	leave  
c01096f9:	c3                   	ret    

c01096fa <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01096fa:	55                   	push   %ebp
c01096fb:	89 e5                	mov    %esp,%ebp
c01096fd:	57                   	push   %edi
c01096fe:	56                   	push   %esi
c01096ff:	53                   	push   %ebx
c0109700:	83 ec 24             	sub    $0x24,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109703:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109708:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010970e:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109714:	6b f0 05             	imul   $0x5,%eax,%esi
c0109717:	01 f7                	add    %esi,%edi
c0109719:	be 6d e6 ec de       	mov    $0xdeece66d,%esi
c010971e:	f7 e6                	mul    %esi
c0109720:	8d 34 17             	lea    (%edi,%edx,1),%esi
c0109723:	89 f2                	mov    %esi,%edx
c0109725:	83 c0 0b             	add    $0xb,%eax
c0109728:	83 d2 00             	adc    $0x0,%edx
c010972b:	89 c7                	mov    %eax,%edi
c010972d:	83 e7 ff             	and    $0xffffffff,%edi
c0109730:	89 f9                	mov    %edi,%ecx
c0109732:	0f b7 da             	movzwl %dx,%ebx
c0109735:	89 0d 88 4a 12 c0    	mov    %ecx,0xc0124a88
c010973b:	89 1d 8c 4a 12 c0    	mov    %ebx,0xc0124a8c
    unsigned long long result = (next >> 12);
c0109741:	a1 88 4a 12 c0       	mov    0xc0124a88,%eax
c0109746:	8b 15 8c 4a 12 c0    	mov    0xc0124a8c,%edx
c010974c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109750:	c1 ea 0c             	shr    $0xc,%edx
c0109753:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109756:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109759:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109760:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109763:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109766:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0109769:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010976c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010976f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109772:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109776:	74 1c                	je     c0109794 <rand+0x9a>
c0109778:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010977b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109780:	f7 75 dc             	divl   -0x24(%ebp)
c0109783:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109786:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109789:	ba 00 00 00 00       	mov    $0x0,%edx
c010978e:	f7 75 dc             	divl   -0x24(%ebp)
c0109791:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109794:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109797:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010979a:	f7 75 dc             	divl   -0x24(%ebp)
c010979d:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01097a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01097a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01097a6:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01097a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01097ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01097af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c01097b2:	83 c4 24             	add    $0x24,%esp
c01097b5:	5b                   	pop    %ebx
c01097b6:	5e                   	pop    %esi
c01097b7:	5f                   	pop    %edi
c01097b8:	5d                   	pop    %ebp
c01097b9:	c3                   	ret    

c01097ba <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c01097ba:	55                   	push   %ebp
c01097bb:	89 e5                	mov    %esp,%ebp
    next = seed;
c01097bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01097c0:	ba 00 00 00 00       	mov    $0x0,%edx
c01097c5:	a3 88 4a 12 c0       	mov    %eax,0xc0124a88
c01097ca:	89 15 8c 4a 12 c0    	mov    %edx,0xc0124a8c
}
c01097d0:	5d                   	pop    %ebp
c01097d1:	c3                   	ret    

c01097d2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01097d2:	55                   	push   %ebp
c01097d3:	89 e5                	mov    %esp,%ebp
c01097d5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01097d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01097df:	eb 04                	jmp    c01097e5 <strlen+0x13>
        cnt ++;
c01097e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01097e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01097e8:	8d 50 01             	lea    0x1(%eax),%edx
c01097eb:	89 55 08             	mov    %edx,0x8(%ebp)
c01097ee:	0f b6 00             	movzbl (%eax),%eax
c01097f1:	84 c0                	test   %al,%al
c01097f3:	75 ec                	jne    c01097e1 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01097f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01097f8:	c9                   	leave  
c01097f9:	c3                   	ret    

c01097fa <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01097fa:	55                   	push   %ebp
c01097fb:	89 e5                	mov    %esp,%ebp
c01097fd:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109800:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109807:	eb 04                	jmp    c010980d <strnlen+0x13>
        cnt ++;
c0109809:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010980d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109810:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109813:	73 10                	jae    c0109825 <strnlen+0x2b>
c0109815:	8b 45 08             	mov    0x8(%ebp),%eax
c0109818:	8d 50 01             	lea    0x1(%eax),%edx
c010981b:	89 55 08             	mov    %edx,0x8(%ebp)
c010981e:	0f b6 00             	movzbl (%eax),%eax
c0109821:	84 c0                	test   %al,%al
c0109823:	75 e4                	jne    c0109809 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109825:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109828:	c9                   	leave  
c0109829:	c3                   	ret    

c010982a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010982a:	55                   	push   %ebp
c010982b:	89 e5                	mov    %esp,%ebp
c010982d:	57                   	push   %edi
c010982e:	56                   	push   %esi
c010982f:	83 ec 20             	sub    $0x20,%esp
c0109832:	8b 45 08             	mov    0x8(%ebp),%eax
c0109835:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109838:	8b 45 0c             	mov    0xc(%ebp),%eax
c010983b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010983e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109844:	89 d1                	mov    %edx,%ecx
c0109846:	89 c2                	mov    %eax,%edx
c0109848:	89 ce                	mov    %ecx,%esi
c010984a:	89 d7                	mov    %edx,%edi
c010984c:	ac                   	lods   %ds:(%esi),%al
c010984d:	aa                   	stos   %al,%es:(%edi)
c010984e:	84 c0                	test   %al,%al
c0109850:	75 fa                	jne    c010984c <strcpy+0x22>
c0109852:	89 fa                	mov    %edi,%edx
c0109854:	89 f1                	mov    %esi,%ecx
c0109856:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109859:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010985c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010985f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109862:	83 c4 20             	add    $0x20,%esp
c0109865:	5e                   	pop    %esi
c0109866:	5f                   	pop    %edi
c0109867:	5d                   	pop    %ebp
c0109868:	c3                   	ret    

c0109869 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109869:	55                   	push   %ebp
c010986a:	89 e5                	mov    %esp,%ebp
c010986c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010986f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109872:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109875:	eb 21                	jmp    c0109898 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109877:	8b 45 0c             	mov    0xc(%ebp),%eax
c010987a:	0f b6 10             	movzbl (%eax),%edx
c010987d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109880:	88 10                	mov    %dl,(%eax)
c0109882:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109885:	0f b6 00             	movzbl (%eax),%eax
c0109888:	84 c0                	test   %al,%al
c010988a:	74 04                	je     c0109890 <strncpy+0x27>
            src ++;
c010988c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109890:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109894:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0109898:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010989c:	75 d9                	jne    c0109877 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010989e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01098a1:	c9                   	leave  
c01098a2:	c3                   	ret    

c01098a3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01098a3:	55                   	push   %ebp
c01098a4:	89 e5                	mov    %esp,%ebp
c01098a6:	57                   	push   %edi
c01098a7:	56                   	push   %esi
c01098a8:	83 ec 20             	sub    $0x20,%esp
c01098ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01098ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01098b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01098b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01098ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01098bd:	89 d1                	mov    %edx,%ecx
c01098bf:	89 c2                	mov    %eax,%edx
c01098c1:	89 ce                	mov    %ecx,%esi
c01098c3:	89 d7                	mov    %edx,%edi
c01098c5:	ac                   	lods   %ds:(%esi),%al
c01098c6:	ae                   	scas   %es:(%edi),%al
c01098c7:	75 08                	jne    c01098d1 <strcmp+0x2e>
c01098c9:	84 c0                	test   %al,%al
c01098cb:	75 f8                	jne    c01098c5 <strcmp+0x22>
c01098cd:	31 c0                	xor    %eax,%eax
c01098cf:	eb 04                	jmp    c01098d5 <strcmp+0x32>
c01098d1:	19 c0                	sbb    %eax,%eax
c01098d3:	0c 01                	or     $0x1,%al
c01098d5:	89 fa                	mov    %edi,%edx
c01098d7:	89 f1                	mov    %esi,%ecx
c01098d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01098dc:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01098df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01098e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01098e5:	83 c4 20             	add    $0x20,%esp
c01098e8:	5e                   	pop    %esi
c01098e9:	5f                   	pop    %edi
c01098ea:	5d                   	pop    %ebp
c01098eb:	c3                   	ret    

c01098ec <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01098ec:	55                   	push   %ebp
c01098ed:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01098ef:	eb 0c                	jmp    c01098fd <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01098f1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01098f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01098f9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01098fd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109901:	74 1a                	je     c010991d <strncmp+0x31>
c0109903:	8b 45 08             	mov    0x8(%ebp),%eax
c0109906:	0f b6 00             	movzbl (%eax),%eax
c0109909:	84 c0                	test   %al,%al
c010990b:	74 10                	je     c010991d <strncmp+0x31>
c010990d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109910:	0f b6 10             	movzbl (%eax),%edx
c0109913:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109916:	0f b6 00             	movzbl (%eax),%eax
c0109919:	38 c2                	cmp    %al,%dl
c010991b:	74 d4                	je     c01098f1 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010991d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109921:	74 18                	je     c010993b <strncmp+0x4f>
c0109923:	8b 45 08             	mov    0x8(%ebp),%eax
c0109926:	0f b6 00             	movzbl (%eax),%eax
c0109929:	0f b6 d0             	movzbl %al,%edx
c010992c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010992f:	0f b6 00             	movzbl (%eax),%eax
c0109932:	0f b6 c0             	movzbl %al,%eax
c0109935:	29 c2                	sub    %eax,%edx
c0109937:	89 d0                	mov    %edx,%eax
c0109939:	eb 05                	jmp    c0109940 <strncmp+0x54>
c010993b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109940:	5d                   	pop    %ebp
c0109941:	c3                   	ret    

c0109942 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109942:	55                   	push   %ebp
c0109943:	89 e5                	mov    %esp,%ebp
c0109945:	83 ec 04             	sub    $0x4,%esp
c0109948:	8b 45 0c             	mov    0xc(%ebp),%eax
c010994b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010994e:	eb 14                	jmp    c0109964 <strchr+0x22>
        if (*s == c) {
c0109950:	8b 45 08             	mov    0x8(%ebp),%eax
c0109953:	0f b6 00             	movzbl (%eax),%eax
c0109956:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109959:	75 05                	jne    c0109960 <strchr+0x1e>
            return (char *)s;
c010995b:	8b 45 08             	mov    0x8(%ebp),%eax
c010995e:	eb 13                	jmp    c0109973 <strchr+0x31>
        }
        s ++;
c0109960:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109964:	8b 45 08             	mov    0x8(%ebp),%eax
c0109967:	0f b6 00             	movzbl (%eax),%eax
c010996a:	84 c0                	test   %al,%al
c010996c:	75 e2                	jne    c0109950 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010996e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109973:	c9                   	leave  
c0109974:	c3                   	ret    

c0109975 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109975:	55                   	push   %ebp
c0109976:	89 e5                	mov    %esp,%ebp
c0109978:	83 ec 04             	sub    $0x4,%esp
c010997b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010997e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109981:	eb 11                	jmp    c0109994 <strfind+0x1f>
        if (*s == c) {
c0109983:	8b 45 08             	mov    0x8(%ebp),%eax
c0109986:	0f b6 00             	movzbl (%eax),%eax
c0109989:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010998c:	75 02                	jne    c0109990 <strfind+0x1b>
            break;
c010998e:	eb 0e                	jmp    c010999e <strfind+0x29>
        }
        s ++;
c0109990:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109994:	8b 45 08             	mov    0x8(%ebp),%eax
c0109997:	0f b6 00             	movzbl (%eax),%eax
c010999a:	84 c0                	test   %al,%al
c010999c:	75 e5                	jne    c0109983 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c010999e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01099a1:	c9                   	leave  
c01099a2:	c3                   	ret    

c01099a3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01099a3:	55                   	push   %ebp
c01099a4:	89 e5                	mov    %esp,%ebp
c01099a6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01099a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01099b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099b7:	eb 04                	jmp    c01099bd <strtol+0x1a>
        s ++;
c01099b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01099bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c0:	0f b6 00             	movzbl (%eax),%eax
c01099c3:	3c 20                	cmp    $0x20,%al
c01099c5:	74 f2                	je     c01099b9 <strtol+0x16>
c01099c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01099ca:	0f b6 00             	movzbl (%eax),%eax
c01099cd:	3c 09                	cmp    $0x9,%al
c01099cf:	74 e8                	je     c01099b9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01099d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01099d4:	0f b6 00             	movzbl (%eax),%eax
c01099d7:	3c 2b                	cmp    $0x2b,%al
c01099d9:	75 06                	jne    c01099e1 <strtol+0x3e>
        s ++;
c01099db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01099df:	eb 15                	jmp    c01099f6 <strtol+0x53>
    }
    else if (*s == '-') {
c01099e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01099e4:	0f b6 00             	movzbl (%eax),%eax
c01099e7:	3c 2d                	cmp    $0x2d,%al
c01099e9:	75 0b                	jne    c01099f6 <strtol+0x53>
        s ++, neg = 1;
c01099eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01099ef:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01099f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01099fa:	74 06                	je     c0109a02 <strtol+0x5f>
c01099fc:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109a00:	75 24                	jne    c0109a26 <strtol+0x83>
c0109a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a05:	0f b6 00             	movzbl (%eax),%eax
c0109a08:	3c 30                	cmp    $0x30,%al
c0109a0a:	75 1a                	jne    c0109a26 <strtol+0x83>
c0109a0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a0f:	83 c0 01             	add    $0x1,%eax
c0109a12:	0f b6 00             	movzbl (%eax),%eax
c0109a15:	3c 78                	cmp    $0x78,%al
c0109a17:	75 0d                	jne    c0109a26 <strtol+0x83>
        s += 2, base = 16;
c0109a19:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109a1d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109a24:	eb 2a                	jmp    c0109a50 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109a26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a2a:	75 17                	jne    c0109a43 <strtol+0xa0>
c0109a2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a2f:	0f b6 00             	movzbl (%eax),%eax
c0109a32:	3c 30                	cmp    $0x30,%al
c0109a34:	75 0d                	jne    c0109a43 <strtol+0xa0>
        s ++, base = 8;
c0109a36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109a3a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109a41:	eb 0d                	jmp    c0109a50 <strtol+0xad>
    }
    else if (base == 0) {
c0109a43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109a47:	75 07                	jne    c0109a50 <strtol+0xad>
        base = 10;
c0109a49:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109a50:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a53:	0f b6 00             	movzbl (%eax),%eax
c0109a56:	3c 2f                	cmp    $0x2f,%al
c0109a58:	7e 1b                	jle    c0109a75 <strtol+0xd2>
c0109a5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a5d:	0f b6 00             	movzbl (%eax),%eax
c0109a60:	3c 39                	cmp    $0x39,%al
c0109a62:	7f 11                	jg     c0109a75 <strtol+0xd2>
            dig = *s - '0';
c0109a64:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a67:	0f b6 00             	movzbl (%eax),%eax
c0109a6a:	0f be c0             	movsbl %al,%eax
c0109a6d:	83 e8 30             	sub    $0x30,%eax
c0109a70:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a73:	eb 48                	jmp    c0109abd <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a78:	0f b6 00             	movzbl (%eax),%eax
c0109a7b:	3c 60                	cmp    $0x60,%al
c0109a7d:	7e 1b                	jle    c0109a9a <strtol+0xf7>
c0109a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a82:	0f b6 00             	movzbl (%eax),%eax
c0109a85:	3c 7a                	cmp    $0x7a,%al
c0109a87:	7f 11                	jg     c0109a9a <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109a89:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a8c:	0f b6 00             	movzbl (%eax),%eax
c0109a8f:	0f be c0             	movsbl %al,%eax
c0109a92:	83 e8 57             	sub    $0x57,%eax
c0109a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a98:	eb 23                	jmp    c0109abd <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a9d:	0f b6 00             	movzbl (%eax),%eax
c0109aa0:	3c 40                	cmp    $0x40,%al
c0109aa2:	7e 3d                	jle    c0109ae1 <strtol+0x13e>
c0109aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aa7:	0f b6 00             	movzbl (%eax),%eax
c0109aaa:	3c 5a                	cmp    $0x5a,%al
c0109aac:	7f 33                	jg     c0109ae1 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0109aae:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ab1:	0f b6 00             	movzbl (%eax),%eax
c0109ab4:	0f be c0             	movsbl %al,%eax
c0109ab7:	83 e8 37             	sub    $0x37,%eax
c0109aba:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ac0:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109ac3:	7c 02                	jl     c0109ac7 <strtol+0x124>
            break;
c0109ac5:	eb 1a                	jmp    c0109ae1 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0109ac7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109ace:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109ad2:	89 c2                	mov    %eax,%edx
c0109ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ad7:	01 d0                	add    %edx,%eax
c0109ad9:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109adc:	e9 6f ff ff ff       	jmp    c0109a50 <strtol+0xad>

    if (endptr) {
c0109ae1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109ae5:	74 08                	je     c0109aef <strtol+0x14c>
        *endptr = (char *) s;
c0109ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109aea:	8b 55 08             	mov    0x8(%ebp),%edx
c0109aed:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109aef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109af3:	74 07                	je     c0109afc <strtol+0x159>
c0109af5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109af8:	f7 d8                	neg    %eax
c0109afa:	eb 03                	jmp    c0109aff <strtol+0x15c>
c0109afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109aff:	c9                   	leave  
c0109b00:	c3                   	ret    

c0109b01 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109b01:	55                   	push   %ebp
c0109b02:	89 e5                	mov    %esp,%ebp
c0109b04:	57                   	push   %edi
c0109b05:	83 ec 24             	sub    $0x24,%esp
c0109b08:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b0b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109b0e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0109b12:	8b 55 08             	mov    0x8(%ebp),%edx
c0109b15:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109b18:	88 45 f7             	mov    %al,-0x9(%ebp)
c0109b1b:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109b21:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0109b24:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0109b28:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109b2b:	89 d7                	mov    %edx,%edi
c0109b2d:	f3 aa                	rep stos %al,%es:(%edi)
c0109b2f:	89 fa                	mov    %edi,%edx
c0109b31:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0109b34:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109b3a:	83 c4 24             	add    $0x24,%esp
c0109b3d:	5f                   	pop    %edi
c0109b3e:	5d                   	pop    %ebp
c0109b3f:	c3                   	ret    

c0109b40 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109b40:	55                   	push   %ebp
c0109b41:	89 e5                	mov    %esp,%ebp
c0109b43:	57                   	push   %edi
c0109b44:	56                   	push   %esi
c0109b45:	53                   	push   %ebx
c0109b46:	83 ec 30             	sub    $0x30,%esp
c0109b49:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b52:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109b55:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b58:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109b61:	73 42                	jae    c0109ba5 <memmove+0x65>
c0109b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109b69:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b6c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109b6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b72:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109b75:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109b78:	c1 e8 02             	shr    $0x2,%eax
c0109b7b:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109b7d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109b80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109b83:	89 d7                	mov    %edx,%edi
c0109b85:	89 c6                	mov    %eax,%esi
c0109b87:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109b89:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109b8c:	83 e1 03             	and    $0x3,%ecx
c0109b8f:	74 02                	je     c0109b93 <memmove+0x53>
c0109b91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109b93:	89 f0                	mov    %esi,%eax
c0109b95:	89 fa                	mov    %edi,%edx
c0109b97:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109b9a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0109b9d:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109ba0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109ba3:	eb 36                	jmp    c0109bdb <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109ba5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ba8:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109bab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109bae:	01 c2                	add    %eax,%edx
c0109bb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bb3:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0109bb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109bb9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109bbc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109bbf:	89 c1                	mov    %eax,%ecx
c0109bc1:	89 d8                	mov    %ebx,%eax
c0109bc3:	89 d6                	mov    %edx,%esi
c0109bc5:	89 c7                	mov    %eax,%edi
c0109bc7:	fd                   	std    
c0109bc8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109bca:	fc                   	cld    
c0109bcb:	89 f8                	mov    %edi,%eax
c0109bcd:	89 f2                	mov    %esi,%edx
c0109bcf:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109bd2:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0109bd5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109bd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109bdb:	83 c4 30             	add    $0x30,%esp
c0109bde:	5b                   	pop    %ebx
c0109bdf:	5e                   	pop    %esi
c0109be0:	5f                   	pop    %edi
c0109be1:	5d                   	pop    %ebp
c0109be2:	c3                   	ret    

c0109be3 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109be3:	55                   	push   %ebp
c0109be4:	89 e5                	mov    %esp,%ebp
c0109be6:	57                   	push   %edi
c0109be7:	56                   	push   %esi
c0109be8:	83 ec 20             	sub    $0x20,%esp
c0109beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109bf1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109bf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109bf7:	8b 45 10             	mov    0x10(%ebp),%eax
c0109bfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109bfd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c00:	c1 e8 02             	shr    $0x2,%eax
c0109c03:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109c05:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c0b:	89 d7                	mov    %edx,%edi
c0109c0d:	89 c6                	mov    %eax,%esi
c0109c0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109c11:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0109c14:	83 e1 03             	and    $0x3,%ecx
c0109c17:	74 02                	je     c0109c1b <memcpy+0x38>
c0109c19:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109c1b:	89 f0                	mov    %esi,%eax
c0109c1d:	89 fa                	mov    %edi,%edx
c0109c1f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0109c22:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109c25:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0109c2b:	83 c4 20             	add    $0x20,%esp
c0109c2e:	5e                   	pop    %esi
c0109c2f:	5f                   	pop    %edi
c0109c30:	5d                   	pop    %ebp
c0109c31:	c3                   	ret    

c0109c32 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0109c32:	55                   	push   %ebp
c0109c33:	89 e5                	mov    %esp,%ebp
c0109c35:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0109c38:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0109c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c41:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0109c44:	eb 30                	jmp    c0109c76 <memcmp+0x44>
        if (*s1 != *s2) {
c0109c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c49:	0f b6 10             	movzbl (%eax),%edx
c0109c4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c4f:	0f b6 00             	movzbl (%eax),%eax
c0109c52:	38 c2                	cmp    %al,%dl
c0109c54:	74 18                	je     c0109c6e <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109c56:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c59:	0f b6 00             	movzbl (%eax),%eax
c0109c5c:	0f b6 d0             	movzbl %al,%edx
c0109c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109c62:	0f b6 00             	movzbl (%eax),%eax
c0109c65:	0f b6 c0             	movzbl %al,%eax
c0109c68:	29 c2                	sub    %eax,%edx
c0109c6a:	89 d0                	mov    %edx,%eax
c0109c6c:	eb 1a                	jmp    c0109c88 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0109c6e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109c72:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0109c76:	8b 45 10             	mov    0x10(%ebp),%eax
c0109c79:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109c7c:	89 55 10             	mov    %edx,0x10(%ebp)
c0109c7f:	85 c0                	test   %eax,%eax
c0109c81:	75 c3                	jne    c0109c46 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0109c83:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109c88:	c9                   	leave  
c0109c89:	c3                   	ret    
