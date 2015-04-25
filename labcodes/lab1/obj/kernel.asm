
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 40 34 00 00       	call   10346c <memset>

    cons_init();                // init the console
  10002c:	e8 3e 15 00 00       	call   10156f <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 00 36 10 00 	movl   $0x103600,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 1c 36 10 00 	movl   $0x10361c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 58 2a 00 00       	call   102ab2 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 53 16 00 00       	call   1016b2 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 cb 17 00 00       	call   10182f <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 f9 0c 00 00       	call   100d62 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 b2 15 00 00       	call   101620 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 02 0c 00 00       	call   100c94 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 21 36 10 00 	movl   $0x103621,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 2f 36 10 00 	movl   $0x10362f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 3d 36 10 00 	movl   $0x10363d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 4b 36 10 00 	movl   $0x10364b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 59 36 10 00 	movl   $0x103659,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 88 36 10 00 	movl   $0x103688,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 a7 36 10 00 	movl   $0x1036a7,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 cb 12 00 00       	call   10159b <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 78 29 00 00       	call   102c85 <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 52 12 00 00       	call   10159b <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 1f 12 00 00       	call   1015c4 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 ac 36 10 00    	movl   $0x1036ac,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 ac 36 10 00 	movl   $0x1036ac,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 2c 3f 10 00 	movl   $0x103f2c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 84 b6 10 00 	movl   $0x10b684,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 85 b6 10 00 	movl   $0x10b685,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 5d d6 10 00 	movl   $0x10d65d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 1e 2c 00 00       	call   1032e0 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 b6 36 10 00 	movl   $0x1036b6,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 cf 36 10 00 	movl   $0x1036cf,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 f5 35 10 	movl   $0x1035f5,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 ff 36 10 00 	movl   $0x1036ff,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 17 37 10 00 	movl   $0x103717,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 30 37 10 00 	movl   $0x103730,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 5a 37 10 00 	movl   $0x10375a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 76 37 10 00 	movl   $0x103776,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return ebp;
  10099b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i = 0, j = 0;
  1009a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for (i=0; i< STACKFRAME_DEPTH; i++){
  1009b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009be:	e9 8a 00 00 00       	jmp    100a4d <print_stackframe+0xbd>
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d1:	c7 04 24 88 37 10 00 	movl   $0x103788,(%esp)
  1009d8:	e8 35 f9 ff ff       	call   100312 <cprintf>
		for (j=0; j<4; j++)
  1009dd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009e4:	eb 28                	jmp    100a0e <print_stackframe+0x7e>
			cprintf("0x%08x ", ((uint32_t*)ebp)[2 + j]);
  1009e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009e9:	83 c0 02             	add    $0x2,%eax
  1009ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f6:	01 d0                	add    %edx,%eax
  1009f8:	8b 00                	mov    (%eax),%eax
  1009fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fe:	c7 04 24 a4 37 10 00 	movl   $0x1037a4,(%esp)
  100a05:	e8 08 f9 ff ff       	call   100312 <cprintf>
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i = 0, j = 0;
	for (i=0; i< STACKFRAME_DEPTH; i++){
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
		for (j=0; j<4; j++)
  100a0a:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a0e:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a12:	7e d2                	jle    1009e6 <print_stackframe+0x56>
			cprintf("0x%08x ", ((uint32_t*)ebp)[2 + j]);
		cprintf("\n");
  100a14:	c7 04 24 ac 37 10 00 	movl   $0x1037ac,(%esp)
  100a1b:	e8 f2 f8 ff ff       	call   100312 <cprintf>
		print_debuginfo(eip-1);
  100a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a23:	83 e8 01             	sub    $0x1,%eax
  100a26:	89 04 24             	mov    %eax,(%esp)
  100a29:	e8 ae fe ff ff       	call   1008dc <print_debuginfo>
		eip = ((uint32_t*)ebp)[1];
  100a2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a31:	83 c0 04             	add    $0x4,%eax
  100a34:	8b 00                	mov    (%eax),%eax
  100a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = ((uint32_t*)ebp)[0];
  100a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3c:	8b 00                	mov    (%eax),%eax
  100a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (ebp == 0) break;
  100a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a45:	75 02                	jne    100a49 <print_stackframe+0xb9>
  100a47:	eb 0e                	jmp    100a57 <print_stackframe+0xc7>
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i = 0, j = 0;
	for (i=0; i< STACKFRAME_DEPTH; i++){
  100a49:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4d:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a51:	0f 8e 6c ff ff ff    	jle    1009c3 <print_stackframe+0x33>
		print_debuginfo(eip-1);
		eip = ((uint32_t*)ebp)[1];
		ebp = ((uint32_t*)ebp)[0];
		if (ebp == 0) break;
	}
}
  100a57:	c9                   	leave  
  100a58:	c3                   	ret    

00100a59 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a59:	55                   	push   %ebp
  100a5a:	89 e5                	mov    %esp,%ebp
  100a5c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a66:	eb 0c                	jmp    100a74 <parse+0x1b>
            *buf ++ = '\0';
  100a68:	8b 45 08             	mov    0x8(%ebp),%eax
  100a6b:	8d 50 01             	lea    0x1(%eax),%edx
  100a6e:	89 55 08             	mov    %edx,0x8(%ebp)
  100a71:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a74:	8b 45 08             	mov    0x8(%ebp),%eax
  100a77:	0f b6 00             	movzbl (%eax),%eax
  100a7a:	84 c0                	test   %al,%al
  100a7c:	74 1d                	je     100a9b <parse+0x42>
  100a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100a81:	0f b6 00             	movzbl (%eax),%eax
  100a84:	0f be c0             	movsbl %al,%eax
  100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a8b:	c7 04 24 30 38 10 00 	movl   $0x103830,(%esp)
  100a92:	e8 16 28 00 00       	call   1032ad <strchr>
  100a97:	85 c0                	test   %eax,%eax
  100a99:	75 cd                	jne    100a68 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	75 02                	jne    100aa7 <parse+0x4e>
            break;
  100aa5:	eb 67                	jmp    100b0e <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa7:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aab:	75 14                	jne    100ac1 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aad:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab4:	00 
  100ab5:	c7 04 24 35 38 10 00 	movl   $0x103835,(%esp)
  100abc:	e8 51 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac4:	8d 50 01             	lea    0x1(%eax),%edx
  100ac7:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad4:	01 c2                	add    %eax,%edx
  100ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad9:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100adb:	eb 04                	jmp    100ae1 <parse+0x88>
            buf ++;
  100add:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae4:	0f b6 00             	movzbl (%eax),%eax
  100ae7:	84 c0                	test   %al,%al
  100ae9:	74 1d                	je     100b08 <parse+0xaf>
  100aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  100aee:	0f b6 00             	movzbl (%eax),%eax
  100af1:	0f be c0             	movsbl %al,%eax
  100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af8:	c7 04 24 30 38 10 00 	movl   $0x103830,(%esp)
  100aff:	e8 a9 27 00 00       	call   1032ad <strchr>
  100b04:	85 c0                	test   %eax,%eax
  100b06:	74 d5                	je     100add <parse+0x84>
            buf ++;
        }
    }
  100b08:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b09:	e9 66 ff ff ff       	jmp    100a74 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b11:	c9                   	leave  
  100b12:	c3                   	ret    

00100b13 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b13:	55                   	push   %ebp
  100b14:	89 e5                	mov    %esp,%ebp
  100b16:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b19:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b20:	8b 45 08             	mov    0x8(%ebp),%eax
  100b23:	89 04 24             	mov    %eax,(%esp)
  100b26:	e8 2e ff ff ff       	call   100a59 <parse>
  100b2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b32:	75 0a                	jne    100b3e <runcmd+0x2b>
        return 0;
  100b34:	b8 00 00 00 00       	mov    $0x0,%eax
  100b39:	e9 85 00 00 00       	jmp    100bc3 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b45:	eb 5c                	jmp    100ba3 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b47:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4d:	89 d0                	mov    %edx,%eax
  100b4f:	01 c0                	add    %eax,%eax
  100b51:	01 d0                	add    %edx,%eax
  100b53:	c1 e0 02             	shl    $0x2,%eax
  100b56:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b5b:	8b 00                	mov    (%eax),%eax
  100b5d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b61:	89 04 24             	mov    %eax,(%esp)
  100b64:	e8 a5 26 00 00       	call   10320e <strcmp>
  100b69:	85 c0                	test   %eax,%eax
  100b6b:	75 32                	jne    100b9f <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b70:	89 d0                	mov    %edx,%eax
  100b72:	01 c0                	add    %eax,%eax
  100b74:	01 d0                	add    %edx,%eax
  100b76:	c1 e0 02             	shl    $0x2,%eax
  100b79:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b7e:	8b 40 08             	mov    0x8(%eax),%eax
  100b81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b84:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b87:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b8a:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b8e:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b91:	83 c2 04             	add    $0x4,%edx
  100b94:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b98:	89 0c 24             	mov    %ecx,(%esp)
  100b9b:	ff d0                	call   *%eax
  100b9d:	eb 24                	jmp    100bc3 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b9f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba6:	83 f8 02             	cmp    $0x2,%eax
  100ba9:	76 9c                	jbe    100b47 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bab:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb2:	c7 04 24 53 38 10 00 	movl   $0x103853,(%esp)
  100bb9:	e8 54 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc3:	c9                   	leave  
  100bc4:	c3                   	ret    

00100bc5 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc5:	55                   	push   %ebp
  100bc6:	89 e5                	mov    %esp,%ebp
  100bc8:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bcb:	c7 04 24 6c 38 10 00 	movl   $0x10386c,(%esp)
  100bd2:	e8 3b f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd7:	c7 04 24 94 38 10 00 	movl   $0x103894,(%esp)
  100bde:	e8 2f f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100be3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be7:	74 0b                	je     100bf4 <kmonitor+0x2f>
        print_trapframe(tf);
  100be9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bec:	89 04 24             	mov    %eax,(%esp)
  100bef:	e8 47 0f 00 00       	call   101b3b <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf4:	c7 04 24 b9 38 10 00 	movl   $0x1038b9,(%esp)
  100bfb:	e8 09 f6 ff ff       	call   100209 <readline>
  100c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c07:	74 18                	je     100c21 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c09:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 f8 fe ff ff       	call   100b13 <runcmd>
  100c1b:	85 c0                	test   %eax,%eax
  100c1d:	79 02                	jns    100c21 <kmonitor+0x5c>
                break;
  100c1f:	eb 02                	jmp    100c23 <kmonitor+0x5e>
            }
        }
    }
  100c21:	eb d1                	jmp    100bf4 <kmonitor+0x2f>
}
  100c23:	c9                   	leave  
  100c24:	c3                   	ret    

00100c25 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c25:	55                   	push   %ebp
  100c26:	89 e5                	mov    %esp,%ebp
  100c28:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c32:	eb 3f                	jmp    100c73 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c37:	89 d0                	mov    %edx,%eax
  100c39:	01 c0                	add    %eax,%eax
  100c3b:	01 d0                	add    %edx,%eax
  100c3d:	c1 e0 02             	shl    $0x2,%eax
  100c40:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c45:	8b 48 04             	mov    0x4(%eax),%ecx
  100c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4b:	89 d0                	mov    %edx,%eax
  100c4d:	01 c0                	add    %eax,%eax
  100c4f:	01 d0                	add    %edx,%eax
  100c51:	c1 e0 02             	shl    $0x2,%eax
  100c54:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c59:	8b 00                	mov    (%eax),%eax
  100c5b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c63:	c7 04 24 bd 38 10 00 	movl   $0x1038bd,(%esp)
  100c6a:	e8 a3 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c76:	83 f8 02             	cmp    $0x2,%eax
  100c79:	76 b9                	jbe    100c34 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c80:	c9                   	leave  
  100c81:	c3                   	ret    

00100c82 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c82:	55                   	push   %ebp
  100c83:	89 e5                	mov    %esp,%ebp
  100c85:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c88:	e8 b9 fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c92:	c9                   	leave  
  100c93:	c3                   	ret    

00100c94 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c94:	55                   	push   %ebp
  100c95:	89 e5                	mov    %esp,%ebp
  100c97:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c9a:	e8 f1 fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca4:	c9                   	leave  
  100ca5:	c3                   	ret    

00100ca6 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca6:	55                   	push   %ebp
  100ca7:	89 e5                	mov    %esp,%ebp
  100ca9:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cac:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cb1:	85 c0                	test   %eax,%eax
  100cb3:	74 02                	je     100cb7 <__panic+0x11>
        goto panic_dead;
  100cb5:	eb 48                	jmp    100cff <__panic+0x59>
    }
    is_panic = 1;
  100cb7:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cbe:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc1:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cca:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cce:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd5:	c7 04 24 c6 38 10 00 	movl   $0x1038c6,(%esp)
  100cdc:	e8 31 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce8:	8b 45 10             	mov    0x10(%ebp),%eax
  100ceb:	89 04 24             	mov    %eax,(%esp)
  100cee:	e8 ec f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cf3:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100cfa:	e8 13 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cff:	e8 22 09 00 00       	call   101626 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d0b:	e8 b5 fe ff ff       	call   100bc5 <kmonitor>
    }
  100d10:	eb f2                	jmp    100d04 <__panic+0x5e>

00100d12 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d12:	55                   	push   %ebp
  100d13:	89 e5                	mov    %esp,%ebp
  100d15:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d18:	8d 45 14             	lea    0x14(%ebp),%eax
  100d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d21:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d25:	8b 45 08             	mov    0x8(%ebp),%eax
  100d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2c:	c7 04 24 e4 38 10 00 	movl   $0x1038e4,(%esp)
  100d33:	e8 da f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d42:	89 04 24             	mov    %eax,(%esp)
  100d45:	e8 95 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d4a:	c7 04 24 e2 38 10 00 	movl   $0x1038e2,(%esp)
  100d51:	e8 bc f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d56:	c9                   	leave  
  100d57:	c3                   	ret    

00100d58 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d58:	55                   	push   %ebp
  100d59:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d5b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d60:	5d                   	pop    %ebp
  100d61:	c3                   	ret    

00100d62 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d62:	55                   	push   %ebp
  100d63:	89 e5                	mov    %esp,%ebp
  100d65:	83 ec 28             	sub    $0x28,%esp
  100d68:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d6e:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d72:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d76:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7a:	ee                   	out    %al,(%dx)
  100d7b:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d81:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d85:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d89:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8d:	ee                   	out    %al,(%dx)
  100d8e:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d94:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d98:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d9c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da0:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da1:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100da8:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dab:	c7 04 24 02 39 10 00 	movl   $0x103902,(%esp)
  100db2:	e8 5b f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100db7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dbe:	e8 c1 08 00 00       	call   101684 <pic_enable>
}
  100dc3:	c9                   	leave  
  100dc4:	c3                   	ret    

00100dc5 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc5:	55                   	push   %ebp
  100dc6:	89 e5                	mov    %esp,%ebp
  100dc8:	83 ec 10             	sub    $0x10,%esp
  100dcb:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd1:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dd5:	89 c2                	mov    %eax,%edx
  100dd7:	ec                   	in     (%dx),%al
  100dd8:	88 45 fd             	mov    %al,-0x3(%ebp)
  100ddb:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de5:	89 c2                	mov    %eax,%edx
  100de7:	ec                   	in     (%dx),%al
  100de8:	88 45 f9             	mov    %al,-0x7(%ebp)
  100deb:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100df5:	89 c2                	mov    %eax,%edx
  100df7:	ec                   	in     (%dx),%al
  100df8:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dfb:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e01:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e05:	89 c2                	mov    %eax,%edx
  100e07:	ec                   	in     (%dx),%al
  100e08:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e0b:	c9                   	leave  
  100e0c:	c3                   	ret    

00100e0d <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e0d:	55                   	push   %ebp
  100e0e:	89 e5                	mov    %esp,%ebp
  100e10:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e13:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1d:	0f b7 00             	movzwl (%eax),%eax
  100e20:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e27:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2f:	0f b7 00             	movzwl (%eax),%eax
  100e32:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e36:	74 12                	je     100e4a <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e38:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e3f:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e46:	b4 03 
  100e48:	eb 13                	jmp    100e5d <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e51:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e54:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e5b:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e5d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e64:	0f b7 c0             	movzwl %ax,%eax
  100e67:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e6b:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e73:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e77:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e78:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7f:	83 c0 01             	add    $0x1,%eax
  100e82:	0f b7 c0             	movzwl %ax,%eax
  100e85:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e89:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e8d:	89 c2                	mov    %eax,%edx
  100e8f:	ec                   	in     (%dx),%al
  100e90:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e93:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e97:	0f b6 c0             	movzbl %al,%eax
  100e9a:	c1 e0 08             	shl    $0x8,%eax
  100e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea0:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea7:	0f b7 c0             	movzwl %ax,%eax
  100eaa:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eae:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eba:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ebb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec2:	83 c0 01             	add    $0x1,%eax
  100ec5:	0f b7 c0             	movzwl %ax,%eax
  100ec8:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ecc:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed0:	89 c2                	mov    %eax,%edx
  100ed2:	ec                   	in     (%dx),%al
  100ed3:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ed6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eda:	0f b6 c0             	movzbl %al,%eax
  100edd:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee3:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100eeb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef1:	c9                   	leave  
  100ef2:	c3                   	ret    

00100ef3 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ef3:	55                   	push   %ebp
  100ef4:	89 e5                	mov    %esp,%ebp
  100ef6:	83 ec 48             	sub    $0x48,%esp
  100ef9:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eff:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f03:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f07:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f0b:	ee                   	out    %al,(%dx)
  100f0c:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f12:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f16:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f1a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
  100f1f:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f25:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f29:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2d:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f31:	ee                   	out    %al,(%dx)
  100f32:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f38:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f3c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f40:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
  100f45:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f4b:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f4f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f53:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
  100f58:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f5e:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f62:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f66:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f6a:	ee                   	out    %al,(%dx)
  100f6b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f71:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f75:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f79:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f7d:	ee                   	out    %al,(%dx)
  100f7e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f84:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f88:	89 c2                	mov    %eax,%edx
  100f8a:	ec                   	in     (%dx),%al
  100f8b:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f8e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f92:	3c ff                	cmp    $0xff,%al
  100f94:	0f 95 c0             	setne  %al
  100f97:	0f b6 c0             	movzbl %al,%eax
  100f9a:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f9f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa5:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fa9:	89 c2                	mov    %eax,%edx
  100fab:	ec                   	in     (%dx),%al
  100fac:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100faf:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fb5:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fb9:	89 c2                	mov    %eax,%edx
  100fbb:	ec                   	in     (%dx),%al
  100fbc:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fbf:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fc4:	85 c0                	test   %eax,%eax
  100fc6:	74 0c                	je     100fd4 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fc8:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fcf:	e8 b0 06 00 00       	call   101684 <pic_enable>
    }
}
  100fd4:	c9                   	leave  
  100fd5:	c3                   	ret    

00100fd6 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd6:	55                   	push   %ebp
  100fd7:	89 e5                	mov    %esp,%ebp
  100fd9:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe3:	eb 09                	jmp    100fee <lpt_putc_sub+0x18>
        delay();
  100fe5:	e8 db fd ff ff       	call   100dc5 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fee:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ff4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ff8:	89 c2                	mov    %eax,%edx
  100ffa:	ec                   	in     (%dx),%al
  100ffb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ffe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101002:	84 c0                	test   %al,%al
  101004:	78 09                	js     10100f <lpt_putc_sub+0x39>
  101006:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10100d:	7e d6                	jle    100fe5 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10100f:	8b 45 08             	mov    0x8(%ebp),%eax
  101012:	0f b6 c0             	movzbl %al,%eax
  101015:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10101b:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10101e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101022:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101026:	ee                   	out    %al,(%dx)
  101027:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10102d:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101031:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101035:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101039:	ee                   	out    %al,(%dx)
  10103a:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101040:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101044:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101048:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10104c:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10104d:	c9                   	leave  
  10104e:	c3                   	ret    

0010104f <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10104f:	55                   	push   %ebp
  101050:	89 e5                	mov    %esp,%ebp
  101052:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101055:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101059:	74 0d                	je     101068 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10105b:	8b 45 08             	mov    0x8(%ebp),%eax
  10105e:	89 04 24             	mov    %eax,(%esp)
  101061:	e8 70 ff ff ff       	call   100fd6 <lpt_putc_sub>
  101066:	eb 24                	jmp    10108c <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101068:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10106f:	e8 62 ff ff ff       	call   100fd6 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101074:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10107b:	e8 56 ff ff ff       	call   100fd6 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101080:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101087:	e8 4a ff ff ff       	call   100fd6 <lpt_putc_sub>
    }
}
  10108c:	c9                   	leave  
  10108d:	c3                   	ret    

0010108e <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10108e:	55                   	push   %ebp
  10108f:	89 e5                	mov    %esp,%ebp
  101091:	53                   	push   %ebx
  101092:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101095:	8b 45 08             	mov    0x8(%ebp),%eax
  101098:	b0 00                	mov    $0x0,%al
  10109a:	85 c0                	test   %eax,%eax
  10109c:	75 07                	jne    1010a5 <cga_putc+0x17>
        c |= 0x0700;
  10109e:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a8:	0f b6 c0             	movzbl %al,%eax
  1010ab:	83 f8 0a             	cmp    $0xa,%eax
  1010ae:	74 4c                	je     1010fc <cga_putc+0x6e>
  1010b0:	83 f8 0d             	cmp    $0xd,%eax
  1010b3:	74 57                	je     10110c <cga_putc+0x7e>
  1010b5:	83 f8 08             	cmp    $0x8,%eax
  1010b8:	0f 85 88 00 00 00    	jne    101146 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010be:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c5:	66 85 c0             	test   %ax,%ax
  1010c8:	74 30                	je     1010fa <cga_putc+0x6c>
            crt_pos --;
  1010ca:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d1:	83 e8 01             	sub    $0x1,%eax
  1010d4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010da:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010df:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010e6:	0f b7 d2             	movzwl %dx,%edx
  1010e9:	01 d2                	add    %edx,%edx
  1010eb:	01 c2                	add    %eax,%edx
  1010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f0:	b0 00                	mov    $0x0,%al
  1010f2:	83 c8 20             	or     $0x20,%eax
  1010f5:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010f8:	eb 72                	jmp    10116c <cga_putc+0xde>
  1010fa:	eb 70                	jmp    10116c <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010fc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101103:	83 c0 50             	add    $0x50,%eax
  101106:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10110c:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101113:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  10111a:	0f b7 c1             	movzwl %cx,%eax
  10111d:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101123:	c1 e8 10             	shr    $0x10,%eax
  101126:	89 c2                	mov    %eax,%edx
  101128:	66 c1 ea 06          	shr    $0x6,%dx
  10112c:	89 d0                	mov    %edx,%eax
  10112e:	c1 e0 02             	shl    $0x2,%eax
  101131:	01 d0                	add    %edx,%eax
  101133:	c1 e0 04             	shl    $0x4,%eax
  101136:	29 c1                	sub    %eax,%ecx
  101138:	89 ca                	mov    %ecx,%edx
  10113a:	89 d8                	mov    %ebx,%eax
  10113c:	29 d0                	sub    %edx,%eax
  10113e:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101144:	eb 26                	jmp    10116c <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101146:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  10114c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101153:	8d 50 01             	lea    0x1(%eax),%edx
  101156:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10115d:	0f b7 c0             	movzwl %ax,%eax
  101160:	01 c0                	add    %eax,%eax
  101162:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101165:	8b 45 08             	mov    0x8(%ebp),%eax
  101168:	66 89 02             	mov    %ax,(%edx)
        break;
  10116b:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10116c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101173:	66 3d cf 07          	cmp    $0x7cf,%ax
  101177:	76 5b                	jbe    1011d4 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101179:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117e:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101184:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101189:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101190:	00 
  101191:	89 54 24 04          	mov    %edx,0x4(%esp)
  101195:	89 04 24             	mov    %eax,(%esp)
  101198:	e8 0e 23 00 00       	call   1034ab <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119d:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011a4:	eb 15                	jmp    1011bb <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011a6:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011ae:	01 d2                	add    %edx,%edx
  1011b0:	01 d0                	add    %edx,%eax
  1011b2:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011bb:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011c2:	7e e2                	jle    1011a6 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011c4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011cb:	83 e8 50             	sub    $0x50,%eax
  1011ce:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011d4:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011db:	0f b7 c0             	movzwl %ax,%eax
  1011de:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e2:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011e6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011ea:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011ee:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ef:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f6:	66 c1 e8 08          	shr    $0x8,%ax
  1011fa:	0f b6 c0             	movzbl %al,%eax
  1011fd:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101204:	83 c2 01             	add    $0x1,%edx
  101207:	0f b7 d2             	movzwl %dx,%edx
  10120a:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10120e:	88 45 ed             	mov    %al,-0x13(%ebp)
  101211:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101215:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101219:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10121a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101221:	0f b7 c0             	movzwl %ax,%eax
  101224:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101228:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10122c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101230:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101234:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101235:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10123c:	0f b6 c0             	movzbl %al,%eax
  10123f:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101246:	83 c2 01             	add    $0x1,%edx
  101249:	0f b7 d2             	movzwl %dx,%edx
  10124c:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101250:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101253:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101257:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
}
  10125c:	83 c4 34             	add    $0x34,%esp
  10125f:	5b                   	pop    %ebx
  101260:	5d                   	pop    %ebp
  101261:	c3                   	ret    

00101262 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101262:	55                   	push   %ebp
  101263:	89 e5                	mov    %esp,%ebp
  101265:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10126f:	eb 09                	jmp    10127a <serial_putc_sub+0x18>
        delay();
  101271:	e8 4f fb ff ff       	call   100dc5 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101276:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10127a:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101280:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101284:	89 c2                	mov    %eax,%edx
  101286:	ec                   	in     (%dx),%al
  101287:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10128a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10128e:	0f b6 c0             	movzbl %al,%eax
  101291:	83 e0 20             	and    $0x20,%eax
  101294:	85 c0                	test   %eax,%eax
  101296:	75 09                	jne    1012a1 <serial_putc_sub+0x3f>
  101298:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10129f:	7e d0                	jle    101271 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a4:	0f b6 c0             	movzbl %al,%eax
  1012a7:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ad:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b4:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	c9                   	leave  
  1012ba:	c3                   	ret    

001012bb <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012bb:	55                   	push   %ebp
  1012bc:	89 e5                	mov    %esp,%ebp
  1012be:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c1:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c5:	74 0d                	je     1012d4 <serial_putc+0x19>
        serial_putc_sub(c);
  1012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ca:	89 04 24             	mov    %eax,(%esp)
  1012cd:	e8 90 ff ff ff       	call   101262 <serial_putc_sub>
  1012d2:	eb 24                	jmp    1012f8 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012d4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012db:	e8 82 ff ff ff       	call   101262 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012e7:	e8 76 ff ff ff       	call   101262 <serial_putc_sub>
        serial_putc_sub('\b');
  1012ec:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f3:	e8 6a ff ff ff       	call   101262 <serial_putc_sub>
    }
}
  1012f8:	c9                   	leave  
  1012f9:	c3                   	ret    

001012fa <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012fa:	55                   	push   %ebp
  1012fb:	89 e5                	mov    %esp,%ebp
  1012fd:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101300:	eb 33                	jmp    101335 <cons_intr+0x3b>
        if (c != 0) {
  101302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101306:	74 2d                	je     101335 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101308:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130d:	8d 50 01             	lea    0x1(%eax),%edx
  101310:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101316:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101319:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101324:	3d 00 02 00 00       	cmp    $0x200,%eax
  101329:	75 0a                	jne    101335 <cons_intr+0x3b>
                cons.wpos = 0;
  10132b:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101332:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101335:	8b 45 08             	mov    0x8(%ebp),%eax
  101338:	ff d0                	call   *%eax
  10133a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10133d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101341:	75 bf                	jne    101302 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101343:	c9                   	leave  
  101344:	c3                   	ret    

00101345 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101345:	55                   	push   %ebp
  101346:	89 e5                	mov    %esp,%ebp
  101348:	83 ec 10             	sub    $0x10,%esp
  10134b:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101351:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101355:	89 c2                	mov    %eax,%edx
  101357:	ec                   	in     (%dx),%al
  101358:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10135b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10135f:	0f b6 c0             	movzbl %al,%eax
  101362:	83 e0 01             	and    $0x1,%eax
  101365:	85 c0                	test   %eax,%eax
  101367:	75 07                	jne    101370 <serial_proc_data+0x2b>
        return -1;
  101369:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136e:	eb 2a                	jmp    10139a <serial_proc_data+0x55>
  101370:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101376:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10137a:	89 c2                	mov    %eax,%edx
  10137c:	ec                   	in     (%dx),%al
  10137d:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101380:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101384:	0f b6 c0             	movzbl %al,%eax
  101387:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10138a:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10138e:	75 07                	jne    101397 <serial_proc_data+0x52>
        c = '\b';
  101390:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10139a:	c9                   	leave  
  10139b:	c3                   	ret    

0010139c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10139c:	55                   	push   %ebp
  10139d:	89 e5                	mov    %esp,%ebp
  10139f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a2:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013a7:	85 c0                	test   %eax,%eax
  1013a9:	74 0c                	je     1013b7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013ab:	c7 04 24 45 13 10 00 	movl   $0x101345,(%esp)
  1013b2:	e8 43 ff ff ff       	call   1012fa <cons_intr>
    }
}
  1013b7:	c9                   	leave  
  1013b8:	c3                   	ret    

001013b9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013b9:	55                   	push   %ebp
  1013ba:	89 e5                	mov    %esp,%ebp
  1013bc:	83 ec 38             	sub    $0x38,%esp
  1013bf:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c9:	89 c2                	mov    %eax,%edx
  1013cb:	ec                   	in     (%dx),%al
  1013cc:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013cf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d3:	0f b6 c0             	movzbl %al,%eax
  1013d6:	83 e0 01             	and    $0x1,%eax
  1013d9:	85 c0                	test   %eax,%eax
  1013db:	75 0a                	jne    1013e7 <kbd_proc_data+0x2e>
        return -1;
  1013dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e2:	e9 59 01 00 00       	jmp    101540 <kbd_proc_data+0x187>
  1013e7:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ed:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f1:	89 c2                	mov    %eax,%edx
  1013f3:	ec                   	in     (%dx),%al
  1013f4:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f7:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013fb:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013fe:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101402:	75 17                	jne    10141b <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101404:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101409:	83 c8 40             	or     $0x40,%eax
  10140c:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101411:	b8 00 00 00 00       	mov    $0x0,%eax
  101416:	e9 25 01 00 00       	jmp    101540 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10141b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141f:	84 c0                	test   %al,%al
  101421:	79 47                	jns    10146a <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101423:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101428:	83 e0 40             	and    $0x40,%eax
  10142b:	85 c0                	test   %eax,%eax
  10142d:	75 09                	jne    101438 <kbd_proc_data+0x7f>
  10142f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101433:	83 e0 7f             	and    $0x7f,%eax
  101436:	eb 04                	jmp    10143c <kbd_proc_data+0x83>
  101438:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143c:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101443:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10144a:	83 c8 40             	or     $0x40,%eax
  10144d:	0f b6 c0             	movzbl %al,%eax
  101450:	f7 d0                	not    %eax
  101452:	89 c2                	mov    %eax,%edx
  101454:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101459:	21 d0                	and    %edx,%eax
  10145b:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101460:	b8 00 00 00 00       	mov    $0x0,%eax
  101465:	e9 d6 00 00 00       	jmp    101540 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10146a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146f:	83 e0 40             	and    $0x40,%eax
  101472:	85 c0                	test   %eax,%eax
  101474:	74 11                	je     101487 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101476:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10147a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147f:	83 e0 bf             	and    $0xffffffbf,%eax
  101482:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101487:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148b:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101492:	0f b6 d0             	movzbl %al,%edx
  101495:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149a:	09 d0                	or     %edx,%eax
  10149c:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a5:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014ac:	0f b6 d0             	movzbl %al,%edx
  1014af:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b4:	31 d0                	xor    %edx,%eax
  1014b6:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014bb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c0:	83 e0 03             	and    $0x3,%eax
  1014c3:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014ca:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ce:	01 d0                	add    %edx,%eax
  1014d0:	0f b6 00             	movzbl (%eax),%eax
  1014d3:	0f b6 c0             	movzbl %al,%eax
  1014d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014d9:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014de:	83 e0 08             	and    $0x8,%eax
  1014e1:	85 c0                	test   %eax,%eax
  1014e3:	74 22                	je     101507 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e5:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014e9:	7e 0c                	jle    1014f7 <kbd_proc_data+0x13e>
  1014eb:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ef:	7f 06                	jg     1014f7 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f1:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f5:	eb 10                	jmp    101507 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f7:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014fb:	7e 0a                	jle    101507 <kbd_proc_data+0x14e>
  1014fd:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101501:	7f 04                	jg     101507 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101503:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101507:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10150c:	f7 d0                	not    %eax
  10150e:	83 e0 06             	and    $0x6,%eax
  101511:	85 c0                	test   %eax,%eax
  101513:	75 28                	jne    10153d <kbd_proc_data+0x184>
  101515:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10151c:	75 1f                	jne    10153d <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10151e:	c7 04 24 1d 39 10 00 	movl   $0x10391d,(%esp)
  101525:	e8 e8 ed ff ff       	call   100312 <cprintf>
  10152a:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101530:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101534:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101538:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10153c:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10153d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101540:	c9                   	leave  
  101541:	c3                   	ret    

00101542 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101542:	55                   	push   %ebp
  101543:	89 e5                	mov    %esp,%ebp
  101545:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101548:	c7 04 24 b9 13 10 00 	movl   $0x1013b9,(%esp)
  10154f:	e8 a6 fd ff ff       	call   1012fa <cons_intr>
}
  101554:	c9                   	leave  
  101555:	c3                   	ret    

00101556 <kbd_init>:

static void
kbd_init(void) {
  101556:	55                   	push   %ebp
  101557:	89 e5                	mov    %esp,%ebp
  101559:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10155c:	e8 e1 ff ff ff       	call   101542 <kbd_intr>
    pic_enable(IRQ_KBD);
  101561:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101568:	e8 17 01 00 00       	call   101684 <pic_enable>
}
  10156d:	c9                   	leave  
  10156e:	c3                   	ret    

0010156f <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156f:	55                   	push   %ebp
  101570:	89 e5                	mov    %esp,%ebp
  101572:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101575:	e8 93 f8 ff ff       	call   100e0d <cga_init>
    serial_init();
  10157a:	e8 74 f9 ff ff       	call   100ef3 <serial_init>
    kbd_init();
  10157f:	e8 d2 ff ff ff       	call   101556 <kbd_init>
    if (!serial_exists) {
  101584:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101589:	85 c0                	test   %eax,%eax
  10158b:	75 0c                	jne    101599 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10158d:	c7 04 24 29 39 10 00 	movl   $0x103929,(%esp)
  101594:	e8 79 ed ff ff       	call   100312 <cprintf>
    }
}
  101599:	c9                   	leave  
  10159a:	c3                   	ret    

0010159b <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10159b:	55                   	push   %ebp
  10159c:	89 e5                	mov    %esp,%ebp
  10159e:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a4:	89 04 24             	mov    %eax,(%esp)
  1015a7:	e8 a3 fa ff ff       	call   10104f <lpt_putc>
    cga_putc(c);
  1015ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1015af:	89 04 24             	mov    %eax,(%esp)
  1015b2:	e8 d7 fa ff ff       	call   10108e <cga_putc>
    serial_putc(c);
  1015b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ba:	89 04 24             	mov    %eax,(%esp)
  1015bd:	e8 f9 fc ff ff       	call   1012bb <serial_putc>
}
  1015c2:	c9                   	leave  
  1015c3:	c3                   	ret    

001015c4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015c4:	55                   	push   %ebp
  1015c5:	89 e5                	mov    %esp,%ebp
  1015c7:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015ca:	e8 cd fd ff ff       	call   10139c <serial_intr>
    kbd_intr();
  1015cf:	e8 6e ff ff ff       	call   101542 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015d4:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015da:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015df:	39 c2                	cmp    %eax,%edx
  1015e1:	74 36                	je     101619 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e3:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e8:	8d 50 01             	lea    0x1(%eax),%edx
  1015eb:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f1:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f8:	0f b6 c0             	movzbl %al,%eax
  1015fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015fe:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101603:	3d 00 02 00 00       	cmp    $0x200,%eax
  101608:	75 0a                	jne    101614 <cons_getc+0x50>
            cons.rpos = 0;
  10160a:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101611:	00 00 00 
        }
        return c;
  101614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101617:	eb 05                	jmp    10161e <cons_getc+0x5a>
    }
    return 0;
  101619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10161e:	c9                   	leave  
  10161f:	c3                   	ret    

00101620 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101623:	fb                   	sti    
    sti();
}
  101624:	5d                   	pop    %ebp
  101625:	c3                   	ret    

00101626 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101626:	55                   	push   %ebp
  101627:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101629:	fa                   	cli    
    cli();
}
  10162a:	5d                   	pop    %ebp
  10162b:	c3                   	ret    

0010162c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10162c:	55                   	push   %ebp
  10162d:	89 e5                	mov    %esp,%ebp
  10162f:	83 ec 14             	sub    $0x14,%esp
  101632:	8b 45 08             	mov    0x8(%ebp),%eax
  101635:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101639:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163d:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101643:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101648:	85 c0                	test   %eax,%eax
  10164a:	74 36                	je     101682 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10164c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101650:	0f b6 c0             	movzbl %al,%eax
  101653:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101659:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10165c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101660:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101664:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101665:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101669:	66 c1 e8 08          	shr    $0x8,%ax
  10166d:	0f b6 c0             	movzbl %al,%eax
  101670:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101676:	88 45 f9             	mov    %al,-0x7(%ebp)
  101679:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101681:	ee                   	out    %al,(%dx)
    }
}
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101684:	55                   	push   %ebp
  101685:	89 e5                	mov    %esp,%ebp
  101687:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10168a:	8b 45 08             	mov    0x8(%ebp),%eax
  10168d:	ba 01 00 00 00       	mov    $0x1,%edx
  101692:	89 c1                	mov    %eax,%ecx
  101694:	d3 e2                	shl    %cl,%edx
  101696:	89 d0                	mov    %edx,%eax
  101698:	f7 d0                	not    %eax
  10169a:	89 c2                	mov    %eax,%edx
  10169c:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a3:	21 d0                	and    %edx,%eax
  1016a5:	0f b7 c0             	movzwl %ax,%eax
  1016a8:	89 04 24             	mov    %eax,(%esp)
  1016ab:	e8 7c ff ff ff       	call   10162c <pic_setmask>
}
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016b2:	55                   	push   %ebp
  1016b3:	89 e5                	mov    %esp,%ebp
  1016b5:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b8:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016bf:	00 00 00 
  1016c2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c8:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016cc:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016d0:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d4:	ee                   	out    %al,(%dx)
  1016d5:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016db:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016df:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e3:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e7:	ee                   	out    %al,(%dx)
  1016e8:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016ee:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016f2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016fa:	ee                   	out    %al,(%dx)
  1016fb:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101701:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101705:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101709:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10170d:	ee                   	out    %al,(%dx)
  10170e:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101714:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101718:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10171c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
  101721:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101727:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  10172b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10172f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101733:	ee                   	out    %al,(%dx)
  101734:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  10173a:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10173e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101742:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101746:	ee                   	out    %al,(%dx)
  101747:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10174d:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  101751:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101755:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101759:	ee                   	out    %al,(%dx)
  10175a:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101760:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101764:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101768:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
  10176d:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101773:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101777:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10177b:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10177f:	ee                   	out    %al,(%dx)
  101780:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101786:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  10178a:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10178e:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101792:	ee                   	out    %al,(%dx)
  101793:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101799:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10179d:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017a1:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a5:	ee                   	out    %al,(%dx)
  1017a6:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017ac:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017b0:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017b4:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017b8:	ee                   	out    %al,(%dx)
  1017b9:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017bf:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017c3:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c7:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017cb:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017cc:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d3:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d7:	74 12                	je     1017eb <pic_init+0x139>
        pic_setmask(irq_mask);
  1017d9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e0:	0f b7 c0             	movzwl %ax,%eax
  1017e3:	89 04 24             	mov    %eax,(%esp)
  1017e6:	e8 41 fe ff ff       	call   10162c <pic_setmask>
    }
}
  1017eb:	c9                   	leave  
  1017ec:	c3                   	ret    

001017ed <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ed:	55                   	push   %ebp
  1017ee:	89 e5                	mov    %esp,%ebp
  1017f0:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f3:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017fa:	00 
  1017fb:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  101802:	e8 0b eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101807:	c7 04 24 6a 39 10 00 	movl   $0x10396a,(%esp)
  10180e:	e8 ff ea ff ff       	call   100312 <cprintf>
    panic("EOT: kernel seems ok.");
  101813:	c7 44 24 08 78 39 10 	movl   $0x103978,0x8(%esp)
  10181a:	00 
  10181b:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101822:	00 
  101823:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  10182a:	e8 77 f4 ff ff       	call   100ca6 <__panic>

0010182f <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10182f:	55                   	push   %ebp
  101830:	89 e5                	mov    %esp,%ebp
  101832:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];

    int i;
    for (i=0; i< 32; i++)
  101835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10183c:	e9 c0 00 00 00       	jmp    101901 <idt_init+0xd2>
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], 0);
  101841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101844:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10184b:	89 c2                	mov    %eax,%edx
  10184d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101850:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101857:	00 
  101858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185b:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101862:	00 08 00 
  101865:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101868:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10186f:	00 
  101870:	83 e2 e0             	and    $0xffffffe0,%edx
  101873:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10187a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101884:	00 
  101885:	83 e2 1f             	and    $0x1f,%edx
  101888:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10188f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101892:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101899:	00 
  10189a:	83 ca 0f             	or     $0xf,%edx
  10189d:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a7:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ae:	00 
  1018af:	83 e2 ef             	and    $0xffffffef,%edx
  1018b2:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bc:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c3:	00 
  1018c4:	83 e2 9f             	and    $0xffffff9f,%edx
  1018c7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d8:	00 
  1018d9:	83 ca 80             	or     $0xffffff80,%edx
  1018dc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e6:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ed:	c1 e8 10             	shr    $0x10,%eax
  1018f0:	89 c2                	mov    %eax,%edx
  1018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f5:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018fc:	00 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];

    int i;
    for (i=0; i< 32; i++)
  1018fd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101901:	83 7d fc 1f          	cmpl   $0x1f,-0x4(%ebp)
  101905:	0f 8e 36 ff ff ff    	jle    101841 <idt_init+0x12>
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], 0);
    for (i=32; i< 256; i++)
  10190b:	c7 45 fc 20 00 00 00 	movl   $0x20,-0x4(%ebp)
  101912:	e9 c3 00 00 00       	jmp    1019da <idt_init+0x1ab>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);
  101917:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191a:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101921:	89 c2                	mov    %eax,%edx
  101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101926:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10192d:	00 
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101938:	00 08 00 
  10193b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193e:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101945:	00 
  101946:	83 e2 e0             	and    $0xffffffe0,%edx
  101949:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101953:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10195a:	00 
  10195b:	83 e2 1f             	and    $0x1f,%edx
  10195e:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10196f:	00 
  101970:	83 e2 f0             	and    $0xfffffff0,%edx
  101973:	83 ca 0e             	or     $0xe,%edx
  101976:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101987:	00 
  101988:	83 e2 ef             	and    $0xffffffef,%edx
  10198b:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10199c:	00 
  10199d:	83 e2 9f             	and    $0xffffff9f,%edx
  1019a0:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019aa:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1019b1:	00 
  1019b2:	83 ca 80             	or     $0xffffff80,%edx
  1019b5:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1019bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019bf:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1019c6:	c1 e8 10             	shr    $0x10,%eax
  1019c9:	89 c2                	mov    %eax,%edx
  1019cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ce:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019d5:	00 
    extern uintptr_t __vectors[];

    int i;
    for (i=0; i< 32; i++)
        SETGATE(idt[i], 1, GD_KTEXT, __vectors[i], 0);
    for (i=32; i< 256; i++)
  1019d6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019da:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019e1:	0f 8e 30 ff ff ff    	jle    101917 <idt_init+0xe8>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], 0);

    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT, __vectors[T_SYSCALL], 3);
  1019e7:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  1019ec:	66 a3 a0 f4 10 00    	mov    %ax,0x10f4a0
  1019f2:	66 c7 05 a2 f4 10 00 	movw   $0x8,0x10f4a2
  1019f9:	08 00 
  1019fb:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  101a02:	83 e0 e0             	and    $0xffffffe0,%eax
  101a05:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101a0a:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  101a11:	83 e0 1f             	and    $0x1f,%eax
  101a14:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101a19:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a20:	83 e0 f0             	and    $0xfffffff0,%eax
  101a23:	83 c8 0e             	or     $0xe,%eax
  101a26:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a2b:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a32:	83 e0 ef             	and    $0xffffffef,%eax
  101a35:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a3a:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a41:	83 c8 60             	or     $0x60,%eax
  101a44:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a49:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101a50:	83 c8 80             	or     $0xffffff80,%eax
  101a53:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101a58:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101a5d:	c1 e8 10             	shr    $0x10,%eax
  101a60:	66 a3 a6 f4 10 00    	mov    %ax,0x10f4a6
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], 3);
  101a66:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101a6b:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101a71:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101a78:	08 00 
  101a7a:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101a81:	83 e0 e0             	and    $0xffffffe0,%eax
  101a84:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101a89:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101a90:	83 e0 1f             	and    $0x1f,%eax
  101a93:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101a98:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101a9f:	83 e0 f0             	and    $0xfffffff0,%eax
  101aa2:	83 c8 0e             	or     $0xe,%eax
  101aa5:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101aaa:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ab1:	83 e0 ef             	and    $0xffffffef,%eax
  101ab4:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101ab9:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101ac0:	83 c8 60             	or     $0x60,%eax
  101ac3:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101ac8:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101acf:	83 c8 80             	or     $0xffffff80,%eax
  101ad2:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101ad7:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101adc:	c1 e8 10             	shr    $0x10,%eax
  101adf:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  101ae5:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101aec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101aef:	0f 01 18             	lidtl  (%eax)

    lidt(&idt_pd);
}
  101af2:	c9                   	leave  
  101af3:	c3                   	ret    

00101af4 <trapname>:

static const char *
trapname(int trapno) {
  101af4:	55                   	push   %ebp
  101af5:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	83 f8 13             	cmp    $0x13,%eax
  101afd:	77 0c                	ja     101b0b <trapname+0x17>
        return excnames[trapno];
  101aff:	8b 45 08             	mov    0x8(%ebp),%eax
  101b02:	8b 04 85 e0 3c 10 00 	mov    0x103ce0(,%eax,4),%eax
  101b09:	eb 18                	jmp    101b23 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101b0b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101b0f:	7e 0d                	jle    101b1e <trapname+0x2a>
  101b11:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101b15:	7f 07                	jg     101b1e <trapname+0x2a>
        return "Hardware Interrupt";
  101b17:	b8 9f 39 10 00       	mov    $0x10399f,%eax
  101b1c:	eb 05                	jmp    101b23 <trapname+0x2f>
    }
    return "(unknown trap)";
  101b1e:	b8 b2 39 10 00       	mov    $0x1039b2,%eax
}
  101b23:	5d                   	pop    %ebp
  101b24:	c3                   	ret    

00101b25 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101b25:	55                   	push   %ebp
  101b26:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101b28:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b2f:	66 83 f8 08          	cmp    $0x8,%ax
  101b33:	0f 94 c0             	sete   %al
  101b36:	0f b6 c0             	movzbl %al,%eax
}
  101b39:	5d                   	pop    %ebp
  101b3a:	c3                   	ret    

00101b3b <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101b3b:	55                   	push   %ebp
  101b3c:	89 e5                	mov    %esp,%ebp
  101b3e:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101b41:	8b 45 08             	mov    0x8(%ebp),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 f3 39 10 00 	movl   $0x1039f3,(%esp)
  101b4f:	e8 be e7 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101b54:	8b 45 08             	mov    0x8(%ebp),%eax
  101b57:	89 04 24             	mov    %eax,(%esp)
  101b5a:	e8 a1 01 00 00       	call   101d00 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b66:	0f b7 c0             	movzwl %ax,%eax
  101b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6d:	c7 04 24 04 3a 10 00 	movl   $0x103a04,(%esp)
  101b74:	e8 99 e7 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b80:	0f b7 c0             	movzwl %ax,%eax
  101b83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b87:	c7 04 24 17 3a 10 00 	movl   $0x103a17,(%esp)
  101b8e:	e8 7f e7 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b93:	8b 45 08             	mov    0x8(%ebp),%eax
  101b96:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b9a:	0f b7 c0             	movzwl %ax,%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 2a 3a 10 00 	movl   $0x103a2a,(%esp)
  101ba8:	e8 65 e7 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101bad:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb0:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101bb4:	0f b7 c0             	movzwl %ax,%eax
  101bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbb:	c7 04 24 3d 3a 10 00 	movl   $0x103a3d,(%esp)
  101bc2:	e8 4b e7 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bca:	8b 40 30             	mov    0x30(%eax),%eax
  101bcd:	89 04 24             	mov    %eax,(%esp)
  101bd0:	e8 1f ff ff ff       	call   101af4 <trapname>
  101bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  101bd8:	8b 52 30             	mov    0x30(%edx),%edx
  101bdb:	89 44 24 08          	mov    %eax,0x8(%esp)
  101bdf:	89 54 24 04          	mov    %edx,0x4(%esp)
  101be3:	c7 04 24 50 3a 10 00 	movl   $0x103a50,(%esp)
  101bea:	e8 23 e7 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 34             	mov    0x34(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101c00:	e8 0d e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	8b 40 38             	mov    0x38(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 71 3a 10 00 	movl   $0x103a71,(%esp)
  101c16:	e8 f7 e6 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101c22:	0f b7 c0             	movzwl %ax,%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 80 3a 10 00 	movl   $0x103a80,(%esp)
  101c30:	e8 dd e6 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	8b 40 40             	mov    0x40(%eax),%eax
  101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3f:	c7 04 24 93 3a 10 00 	movl   $0x103a93,(%esp)
  101c46:	e8 c7 e6 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101c52:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c59:	eb 3e                	jmp    101c99 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5e:	8b 50 40             	mov    0x40(%eax),%edx
  101c61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c64:	21 d0                	and    %edx,%eax
  101c66:	85 c0                	test   %eax,%eax
  101c68:	74 28                	je     101c92 <print_trapframe+0x157>
  101c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c6d:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c74:	85 c0                	test   %eax,%eax
  101c76:	74 1a                	je     101c92 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c7b:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101c82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c86:	c7 04 24 a2 3a 10 00 	movl   $0x103aa2,(%esp)
  101c8d:	e8 80 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c92:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c96:	d1 65 f0             	shll   -0x10(%ebp)
  101c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c9c:	83 f8 17             	cmp    $0x17,%eax
  101c9f:	76 ba                	jbe    101c5b <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca4:	8b 40 40             	mov    0x40(%eax),%eax
  101ca7:	25 00 30 00 00       	and    $0x3000,%eax
  101cac:	c1 e8 0c             	shr    $0xc,%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 a6 3a 10 00 	movl   $0x103aa6,(%esp)
  101cba:	e8 53 e6 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	89 04 24             	mov    %eax,(%esp)
  101cc5:	e8 5b fe ff ff       	call   101b25 <trap_in_kernel>
  101cca:	85 c0                	test   %eax,%eax
  101ccc:	75 30                	jne    101cfe <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101cce:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd1:	8b 40 44             	mov    0x44(%eax),%eax
  101cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd8:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101cdf:	e8 2e e6 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce7:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101ceb:	0f b7 c0             	movzwl %ax,%eax
  101cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf2:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101cf9:	e8 14 e6 ff ff       	call   100312 <cprintf>
    }
}
  101cfe:	c9                   	leave  
  101cff:	c3                   	ret    

00101d00 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101d00:	55                   	push   %ebp
  101d01:	89 e5                	mov    %esp,%ebp
  101d03:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101d06:	8b 45 08             	mov    0x8(%ebp),%eax
  101d09:	8b 00                	mov    (%eax),%eax
  101d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0f:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101d16:	e8 f7 e5 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101d1e:	8b 40 04             	mov    0x4(%eax),%eax
  101d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d25:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101d2c:	e8 e1 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101d31:	8b 45 08             	mov    0x8(%ebp),%eax
  101d34:	8b 40 08             	mov    0x8(%eax),%eax
  101d37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3b:	c7 04 24 ef 3a 10 00 	movl   $0x103aef,(%esp)
  101d42:	e8 cb e5 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101d47:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4a:	8b 40 0c             	mov    0xc(%eax),%eax
  101d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d51:	c7 04 24 fe 3a 10 00 	movl   $0x103afe,(%esp)
  101d58:	e8 b5 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d60:	8b 40 10             	mov    0x10(%eax),%eax
  101d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d67:	c7 04 24 0d 3b 10 00 	movl   $0x103b0d,(%esp)
  101d6e:	e8 9f e5 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d73:	8b 45 08             	mov    0x8(%ebp),%eax
  101d76:	8b 40 14             	mov    0x14(%eax),%eax
  101d79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d7d:	c7 04 24 1c 3b 10 00 	movl   $0x103b1c,(%esp)
  101d84:	e8 89 e5 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d89:	8b 45 08             	mov    0x8(%ebp),%eax
  101d8c:	8b 40 18             	mov    0x18(%eax),%eax
  101d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d93:	c7 04 24 2b 3b 10 00 	movl   $0x103b2b,(%esp)
  101d9a:	e8 73 e5 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101da2:	8b 40 1c             	mov    0x1c(%eax),%eax
  101da5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101da9:	c7 04 24 3a 3b 10 00 	movl   $0x103b3a,(%esp)
  101db0:	e8 5d e5 ff ff       	call   100312 <cprintf>
}
  101db5:	c9                   	leave  
  101db6:	c3                   	ret    

00101db7 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101db7:	55                   	push   %ebp
  101db8:	89 e5                	mov    %esp,%ebp
  101dba:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc0:	8b 40 30             	mov    0x30(%eax),%eax
  101dc3:	83 f8 2f             	cmp    $0x2f,%eax
  101dc6:	77 21                	ja     101de9 <trap_dispatch+0x32>
  101dc8:	83 f8 2e             	cmp    $0x2e,%eax
  101dcb:	0f 83 04 01 00 00    	jae    101ed5 <trap_dispatch+0x11e>
  101dd1:	83 f8 21             	cmp    $0x21,%eax
  101dd4:	0f 84 81 00 00 00    	je     101e5b <trap_dispatch+0xa4>
  101dda:	83 f8 24             	cmp    $0x24,%eax
  101ddd:	74 56                	je     101e35 <trap_dispatch+0x7e>
  101ddf:	83 f8 20             	cmp    $0x20,%eax
  101de2:	74 16                	je     101dfa <trap_dispatch+0x43>
  101de4:	e9 b4 00 00 00       	jmp    101e9d <trap_dispatch+0xe6>
  101de9:	83 e8 78             	sub    $0x78,%eax
  101dec:	83 f8 01             	cmp    $0x1,%eax
  101def:	0f 87 a8 00 00 00    	ja     101e9d <trap_dispatch+0xe6>
  101df5:	e9 87 00 00 00       	jmp    101e81 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks += 1;
  101dfa:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101dff:	83 c0 01             	add    $0x1,%eax
  101e02:	a3 08 f9 10 00       	mov    %eax,0x10f908
    	if (ticks % TICK_NUM == 0)
  101e07:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101e0d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101e12:	89 c8                	mov    %ecx,%eax
  101e14:	f7 e2                	mul    %edx
  101e16:	89 d0                	mov    %edx,%eax
  101e18:	c1 e8 05             	shr    $0x5,%eax
  101e1b:	6b c0 64             	imul   $0x64,%eax,%eax
  101e1e:	29 c1                	sub    %eax,%ecx
  101e20:	89 c8                	mov    %ecx,%eax
  101e22:	85 c0                	test   %eax,%eax
  101e24:	75 0a                	jne    101e30 <trap_dispatch+0x79>
    		print_ticks();
  101e26:	e8 c2 f9 ff ff       	call   1017ed <print_ticks>
        break;
  101e2b:	e9 a6 00 00 00       	jmp    101ed6 <trap_dispatch+0x11f>
  101e30:	e9 a1 00 00 00       	jmp    101ed6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e35:	e8 8a f7 ff ff       	call   1015c4 <cons_getc>
  101e3a:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e3d:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e41:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e45:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e4d:	c7 04 24 49 3b 10 00 	movl   $0x103b49,(%esp)
  101e54:	e8 b9 e4 ff ff       	call   100312 <cprintf>
        break;
  101e59:	eb 7b                	jmp    101ed6 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e5b:	e8 64 f7 ff ff       	call   1015c4 <cons_getc>
  101e60:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e63:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e67:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e73:	c7 04 24 5b 3b 10 00 	movl   $0x103b5b,(%esp)
  101e7a:	e8 93 e4 ff ff       	call   100312 <cprintf>
        break;
  101e7f:	eb 55                	jmp    101ed6 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e81:	c7 44 24 08 6a 3b 10 	movl   $0x103b6a,0x8(%esp)
  101e88:	00 
  101e89:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  101e90:	00 
  101e91:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101e98:	e8 09 ee ff ff       	call   100ca6 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ea4:	0f b7 c0             	movzwl %ax,%eax
  101ea7:	83 e0 03             	and    $0x3,%eax
  101eaa:	85 c0                	test   %eax,%eax
  101eac:	75 28                	jne    101ed6 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101eae:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb1:	89 04 24             	mov    %eax,(%esp)
  101eb4:	e8 82 fc ff ff       	call   101b3b <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101eb9:	c7 44 24 08 7a 3b 10 	movl   $0x103b7a,0x8(%esp)
  101ec0:	00 
  101ec1:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  101ec8:	00 
  101ec9:	c7 04 24 8e 39 10 00 	movl   $0x10398e,(%esp)
  101ed0:	e8 d1 ed ff ff       	call   100ca6 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101ed5:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ed6:	c9                   	leave  
  101ed7:	c3                   	ret    

00101ed8 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101ed8:	55                   	push   %ebp
  101ed9:	89 e5                	mov    %esp,%ebp
  101edb:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ede:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee1:	89 04 24             	mov    %eax,(%esp)
  101ee4:	e8 ce fe ff ff       	call   101db7 <trap_dispatch>
}
  101ee9:	c9                   	leave  
  101eea:	c3                   	ret    

00101eeb <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101eeb:	1e                   	push   %ds
    pushl %es
  101eec:	06                   	push   %es
    pushl %fs
  101eed:	0f a0                	push   %fs
    pushl %gs
  101eef:	0f a8                	push   %gs
    pushal
  101ef1:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101ef2:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101ef7:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101ef9:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101efb:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101efc:	e8 d7 ff ff ff       	call   101ed8 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f01:	5c                   	pop    %esp

00101f02 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f02:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f03:	0f a9                	pop    %gs
    popl %fs
  101f05:	0f a1                	pop    %fs
    popl %es
  101f07:	07                   	pop    %es
    popl %ds
  101f08:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f09:	83 c4 08             	add    $0x8,%esp
    iret
  101f0c:	cf                   	iret   

00101f0d <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $0
  101f0f:	6a 00                	push   $0x0
  jmp __alltraps
  101f11:	e9 d5 ff ff ff       	jmp    101eeb <__alltraps>

00101f16 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $1
  101f18:	6a 01                	push   $0x1
  jmp __alltraps
  101f1a:	e9 cc ff ff ff       	jmp    101eeb <__alltraps>

00101f1f <vector2>:
.globl vector2
vector2:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $2
  101f21:	6a 02                	push   $0x2
  jmp __alltraps
  101f23:	e9 c3 ff ff ff       	jmp    101eeb <__alltraps>

00101f28 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $3
  101f2a:	6a 03                	push   $0x3
  jmp __alltraps
  101f2c:	e9 ba ff ff ff       	jmp    101eeb <__alltraps>

00101f31 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $4
  101f33:	6a 04                	push   $0x4
  jmp __alltraps
  101f35:	e9 b1 ff ff ff       	jmp    101eeb <__alltraps>

00101f3a <vector5>:
.globl vector5
vector5:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $5
  101f3c:	6a 05                	push   $0x5
  jmp __alltraps
  101f3e:	e9 a8 ff ff ff       	jmp    101eeb <__alltraps>

00101f43 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $6
  101f45:	6a 06                	push   $0x6
  jmp __alltraps
  101f47:	e9 9f ff ff ff       	jmp    101eeb <__alltraps>

00101f4c <vector7>:
.globl vector7
vector7:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $7
  101f4e:	6a 07                	push   $0x7
  jmp __alltraps
  101f50:	e9 96 ff ff ff       	jmp    101eeb <__alltraps>

00101f55 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f55:	6a 08                	push   $0x8
  jmp __alltraps
  101f57:	e9 8f ff ff ff       	jmp    101eeb <__alltraps>

00101f5c <vector9>:
.globl vector9
vector9:
  pushl $9
  101f5c:	6a 09                	push   $0x9
  jmp __alltraps
  101f5e:	e9 88 ff ff ff       	jmp    101eeb <__alltraps>

00101f63 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f63:	6a 0a                	push   $0xa
  jmp __alltraps
  101f65:	e9 81 ff ff ff       	jmp    101eeb <__alltraps>

00101f6a <vector11>:
.globl vector11
vector11:
  pushl $11
  101f6a:	6a 0b                	push   $0xb
  jmp __alltraps
  101f6c:	e9 7a ff ff ff       	jmp    101eeb <__alltraps>

00101f71 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f71:	6a 0c                	push   $0xc
  jmp __alltraps
  101f73:	e9 73 ff ff ff       	jmp    101eeb <__alltraps>

00101f78 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f78:	6a 0d                	push   $0xd
  jmp __alltraps
  101f7a:	e9 6c ff ff ff       	jmp    101eeb <__alltraps>

00101f7f <vector14>:
.globl vector14
vector14:
  pushl $14
  101f7f:	6a 0e                	push   $0xe
  jmp __alltraps
  101f81:	e9 65 ff ff ff       	jmp    101eeb <__alltraps>

00101f86 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f86:	6a 00                	push   $0x0
  pushl $15
  101f88:	6a 0f                	push   $0xf
  jmp __alltraps
  101f8a:	e9 5c ff ff ff       	jmp    101eeb <__alltraps>

00101f8f <vector16>:
.globl vector16
vector16:
  pushl $0
  101f8f:	6a 00                	push   $0x0
  pushl $16
  101f91:	6a 10                	push   $0x10
  jmp __alltraps
  101f93:	e9 53 ff ff ff       	jmp    101eeb <__alltraps>

00101f98 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f98:	6a 11                	push   $0x11
  jmp __alltraps
  101f9a:	e9 4c ff ff ff       	jmp    101eeb <__alltraps>

00101f9f <vector18>:
.globl vector18
vector18:
  pushl $0
  101f9f:	6a 00                	push   $0x0
  pushl $18
  101fa1:	6a 12                	push   $0x12
  jmp __alltraps
  101fa3:	e9 43 ff ff ff       	jmp    101eeb <__alltraps>

00101fa8 <vector19>:
.globl vector19
vector19:
  pushl $0
  101fa8:	6a 00                	push   $0x0
  pushl $19
  101faa:	6a 13                	push   $0x13
  jmp __alltraps
  101fac:	e9 3a ff ff ff       	jmp    101eeb <__alltraps>

00101fb1 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fb1:	6a 00                	push   $0x0
  pushl $20
  101fb3:	6a 14                	push   $0x14
  jmp __alltraps
  101fb5:	e9 31 ff ff ff       	jmp    101eeb <__alltraps>

00101fba <vector21>:
.globl vector21
vector21:
  pushl $0
  101fba:	6a 00                	push   $0x0
  pushl $21
  101fbc:	6a 15                	push   $0x15
  jmp __alltraps
  101fbe:	e9 28 ff ff ff       	jmp    101eeb <__alltraps>

00101fc3 <vector22>:
.globl vector22
vector22:
  pushl $0
  101fc3:	6a 00                	push   $0x0
  pushl $22
  101fc5:	6a 16                	push   $0x16
  jmp __alltraps
  101fc7:	e9 1f ff ff ff       	jmp    101eeb <__alltraps>

00101fcc <vector23>:
.globl vector23
vector23:
  pushl $0
  101fcc:	6a 00                	push   $0x0
  pushl $23
  101fce:	6a 17                	push   $0x17
  jmp __alltraps
  101fd0:	e9 16 ff ff ff       	jmp    101eeb <__alltraps>

00101fd5 <vector24>:
.globl vector24
vector24:
  pushl $0
  101fd5:	6a 00                	push   $0x0
  pushl $24
  101fd7:	6a 18                	push   $0x18
  jmp __alltraps
  101fd9:	e9 0d ff ff ff       	jmp    101eeb <__alltraps>

00101fde <vector25>:
.globl vector25
vector25:
  pushl $0
  101fde:	6a 00                	push   $0x0
  pushl $25
  101fe0:	6a 19                	push   $0x19
  jmp __alltraps
  101fe2:	e9 04 ff ff ff       	jmp    101eeb <__alltraps>

00101fe7 <vector26>:
.globl vector26
vector26:
  pushl $0
  101fe7:	6a 00                	push   $0x0
  pushl $26
  101fe9:	6a 1a                	push   $0x1a
  jmp __alltraps
  101feb:	e9 fb fe ff ff       	jmp    101eeb <__alltraps>

00101ff0 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ff0:	6a 00                	push   $0x0
  pushl $27
  101ff2:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ff4:	e9 f2 fe ff ff       	jmp    101eeb <__alltraps>

00101ff9 <vector28>:
.globl vector28
vector28:
  pushl $0
  101ff9:	6a 00                	push   $0x0
  pushl $28
  101ffb:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ffd:	e9 e9 fe ff ff       	jmp    101eeb <__alltraps>

00102002 <vector29>:
.globl vector29
vector29:
  pushl $0
  102002:	6a 00                	push   $0x0
  pushl $29
  102004:	6a 1d                	push   $0x1d
  jmp __alltraps
  102006:	e9 e0 fe ff ff       	jmp    101eeb <__alltraps>

0010200b <vector30>:
.globl vector30
vector30:
  pushl $0
  10200b:	6a 00                	push   $0x0
  pushl $30
  10200d:	6a 1e                	push   $0x1e
  jmp __alltraps
  10200f:	e9 d7 fe ff ff       	jmp    101eeb <__alltraps>

00102014 <vector31>:
.globl vector31
vector31:
  pushl $0
  102014:	6a 00                	push   $0x0
  pushl $31
  102016:	6a 1f                	push   $0x1f
  jmp __alltraps
  102018:	e9 ce fe ff ff       	jmp    101eeb <__alltraps>

0010201d <vector32>:
.globl vector32
vector32:
  pushl $0
  10201d:	6a 00                	push   $0x0
  pushl $32
  10201f:	6a 20                	push   $0x20
  jmp __alltraps
  102021:	e9 c5 fe ff ff       	jmp    101eeb <__alltraps>

00102026 <vector33>:
.globl vector33
vector33:
  pushl $0
  102026:	6a 00                	push   $0x0
  pushl $33
  102028:	6a 21                	push   $0x21
  jmp __alltraps
  10202a:	e9 bc fe ff ff       	jmp    101eeb <__alltraps>

0010202f <vector34>:
.globl vector34
vector34:
  pushl $0
  10202f:	6a 00                	push   $0x0
  pushl $34
  102031:	6a 22                	push   $0x22
  jmp __alltraps
  102033:	e9 b3 fe ff ff       	jmp    101eeb <__alltraps>

00102038 <vector35>:
.globl vector35
vector35:
  pushl $0
  102038:	6a 00                	push   $0x0
  pushl $35
  10203a:	6a 23                	push   $0x23
  jmp __alltraps
  10203c:	e9 aa fe ff ff       	jmp    101eeb <__alltraps>

00102041 <vector36>:
.globl vector36
vector36:
  pushl $0
  102041:	6a 00                	push   $0x0
  pushl $36
  102043:	6a 24                	push   $0x24
  jmp __alltraps
  102045:	e9 a1 fe ff ff       	jmp    101eeb <__alltraps>

0010204a <vector37>:
.globl vector37
vector37:
  pushl $0
  10204a:	6a 00                	push   $0x0
  pushl $37
  10204c:	6a 25                	push   $0x25
  jmp __alltraps
  10204e:	e9 98 fe ff ff       	jmp    101eeb <__alltraps>

00102053 <vector38>:
.globl vector38
vector38:
  pushl $0
  102053:	6a 00                	push   $0x0
  pushl $38
  102055:	6a 26                	push   $0x26
  jmp __alltraps
  102057:	e9 8f fe ff ff       	jmp    101eeb <__alltraps>

0010205c <vector39>:
.globl vector39
vector39:
  pushl $0
  10205c:	6a 00                	push   $0x0
  pushl $39
  10205e:	6a 27                	push   $0x27
  jmp __alltraps
  102060:	e9 86 fe ff ff       	jmp    101eeb <__alltraps>

00102065 <vector40>:
.globl vector40
vector40:
  pushl $0
  102065:	6a 00                	push   $0x0
  pushl $40
  102067:	6a 28                	push   $0x28
  jmp __alltraps
  102069:	e9 7d fe ff ff       	jmp    101eeb <__alltraps>

0010206e <vector41>:
.globl vector41
vector41:
  pushl $0
  10206e:	6a 00                	push   $0x0
  pushl $41
  102070:	6a 29                	push   $0x29
  jmp __alltraps
  102072:	e9 74 fe ff ff       	jmp    101eeb <__alltraps>

00102077 <vector42>:
.globl vector42
vector42:
  pushl $0
  102077:	6a 00                	push   $0x0
  pushl $42
  102079:	6a 2a                	push   $0x2a
  jmp __alltraps
  10207b:	e9 6b fe ff ff       	jmp    101eeb <__alltraps>

00102080 <vector43>:
.globl vector43
vector43:
  pushl $0
  102080:	6a 00                	push   $0x0
  pushl $43
  102082:	6a 2b                	push   $0x2b
  jmp __alltraps
  102084:	e9 62 fe ff ff       	jmp    101eeb <__alltraps>

00102089 <vector44>:
.globl vector44
vector44:
  pushl $0
  102089:	6a 00                	push   $0x0
  pushl $44
  10208b:	6a 2c                	push   $0x2c
  jmp __alltraps
  10208d:	e9 59 fe ff ff       	jmp    101eeb <__alltraps>

00102092 <vector45>:
.globl vector45
vector45:
  pushl $0
  102092:	6a 00                	push   $0x0
  pushl $45
  102094:	6a 2d                	push   $0x2d
  jmp __alltraps
  102096:	e9 50 fe ff ff       	jmp    101eeb <__alltraps>

0010209b <vector46>:
.globl vector46
vector46:
  pushl $0
  10209b:	6a 00                	push   $0x0
  pushl $46
  10209d:	6a 2e                	push   $0x2e
  jmp __alltraps
  10209f:	e9 47 fe ff ff       	jmp    101eeb <__alltraps>

001020a4 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020a4:	6a 00                	push   $0x0
  pushl $47
  1020a6:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020a8:	e9 3e fe ff ff       	jmp    101eeb <__alltraps>

001020ad <vector48>:
.globl vector48
vector48:
  pushl $0
  1020ad:	6a 00                	push   $0x0
  pushl $48
  1020af:	6a 30                	push   $0x30
  jmp __alltraps
  1020b1:	e9 35 fe ff ff       	jmp    101eeb <__alltraps>

001020b6 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $49
  1020b8:	6a 31                	push   $0x31
  jmp __alltraps
  1020ba:	e9 2c fe ff ff       	jmp    101eeb <__alltraps>

001020bf <vector50>:
.globl vector50
vector50:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $50
  1020c1:	6a 32                	push   $0x32
  jmp __alltraps
  1020c3:	e9 23 fe ff ff       	jmp    101eeb <__alltraps>

001020c8 <vector51>:
.globl vector51
vector51:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $51
  1020ca:	6a 33                	push   $0x33
  jmp __alltraps
  1020cc:	e9 1a fe ff ff       	jmp    101eeb <__alltraps>

001020d1 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $52
  1020d3:	6a 34                	push   $0x34
  jmp __alltraps
  1020d5:	e9 11 fe ff ff       	jmp    101eeb <__alltraps>

001020da <vector53>:
.globl vector53
vector53:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $53
  1020dc:	6a 35                	push   $0x35
  jmp __alltraps
  1020de:	e9 08 fe ff ff       	jmp    101eeb <__alltraps>

001020e3 <vector54>:
.globl vector54
vector54:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $54
  1020e5:	6a 36                	push   $0x36
  jmp __alltraps
  1020e7:	e9 ff fd ff ff       	jmp    101eeb <__alltraps>

001020ec <vector55>:
.globl vector55
vector55:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $55
  1020ee:	6a 37                	push   $0x37
  jmp __alltraps
  1020f0:	e9 f6 fd ff ff       	jmp    101eeb <__alltraps>

001020f5 <vector56>:
.globl vector56
vector56:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $56
  1020f7:	6a 38                	push   $0x38
  jmp __alltraps
  1020f9:	e9 ed fd ff ff       	jmp    101eeb <__alltraps>

001020fe <vector57>:
.globl vector57
vector57:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $57
  102100:	6a 39                	push   $0x39
  jmp __alltraps
  102102:	e9 e4 fd ff ff       	jmp    101eeb <__alltraps>

00102107 <vector58>:
.globl vector58
vector58:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $58
  102109:	6a 3a                	push   $0x3a
  jmp __alltraps
  10210b:	e9 db fd ff ff       	jmp    101eeb <__alltraps>

00102110 <vector59>:
.globl vector59
vector59:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $59
  102112:	6a 3b                	push   $0x3b
  jmp __alltraps
  102114:	e9 d2 fd ff ff       	jmp    101eeb <__alltraps>

00102119 <vector60>:
.globl vector60
vector60:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $60
  10211b:	6a 3c                	push   $0x3c
  jmp __alltraps
  10211d:	e9 c9 fd ff ff       	jmp    101eeb <__alltraps>

00102122 <vector61>:
.globl vector61
vector61:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $61
  102124:	6a 3d                	push   $0x3d
  jmp __alltraps
  102126:	e9 c0 fd ff ff       	jmp    101eeb <__alltraps>

0010212b <vector62>:
.globl vector62
vector62:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $62
  10212d:	6a 3e                	push   $0x3e
  jmp __alltraps
  10212f:	e9 b7 fd ff ff       	jmp    101eeb <__alltraps>

00102134 <vector63>:
.globl vector63
vector63:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $63
  102136:	6a 3f                	push   $0x3f
  jmp __alltraps
  102138:	e9 ae fd ff ff       	jmp    101eeb <__alltraps>

0010213d <vector64>:
.globl vector64
vector64:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $64
  10213f:	6a 40                	push   $0x40
  jmp __alltraps
  102141:	e9 a5 fd ff ff       	jmp    101eeb <__alltraps>

00102146 <vector65>:
.globl vector65
vector65:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $65
  102148:	6a 41                	push   $0x41
  jmp __alltraps
  10214a:	e9 9c fd ff ff       	jmp    101eeb <__alltraps>

0010214f <vector66>:
.globl vector66
vector66:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $66
  102151:	6a 42                	push   $0x42
  jmp __alltraps
  102153:	e9 93 fd ff ff       	jmp    101eeb <__alltraps>

00102158 <vector67>:
.globl vector67
vector67:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $67
  10215a:	6a 43                	push   $0x43
  jmp __alltraps
  10215c:	e9 8a fd ff ff       	jmp    101eeb <__alltraps>

00102161 <vector68>:
.globl vector68
vector68:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $68
  102163:	6a 44                	push   $0x44
  jmp __alltraps
  102165:	e9 81 fd ff ff       	jmp    101eeb <__alltraps>

0010216a <vector69>:
.globl vector69
vector69:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $69
  10216c:	6a 45                	push   $0x45
  jmp __alltraps
  10216e:	e9 78 fd ff ff       	jmp    101eeb <__alltraps>

00102173 <vector70>:
.globl vector70
vector70:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $70
  102175:	6a 46                	push   $0x46
  jmp __alltraps
  102177:	e9 6f fd ff ff       	jmp    101eeb <__alltraps>

0010217c <vector71>:
.globl vector71
vector71:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $71
  10217e:	6a 47                	push   $0x47
  jmp __alltraps
  102180:	e9 66 fd ff ff       	jmp    101eeb <__alltraps>

00102185 <vector72>:
.globl vector72
vector72:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $72
  102187:	6a 48                	push   $0x48
  jmp __alltraps
  102189:	e9 5d fd ff ff       	jmp    101eeb <__alltraps>

0010218e <vector73>:
.globl vector73
vector73:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $73
  102190:	6a 49                	push   $0x49
  jmp __alltraps
  102192:	e9 54 fd ff ff       	jmp    101eeb <__alltraps>

00102197 <vector74>:
.globl vector74
vector74:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $74
  102199:	6a 4a                	push   $0x4a
  jmp __alltraps
  10219b:	e9 4b fd ff ff       	jmp    101eeb <__alltraps>

001021a0 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $75
  1021a2:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021a4:	e9 42 fd ff ff       	jmp    101eeb <__alltraps>

001021a9 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $76
  1021ab:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021ad:	e9 39 fd ff ff       	jmp    101eeb <__alltraps>

001021b2 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $77
  1021b4:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021b6:	e9 30 fd ff ff       	jmp    101eeb <__alltraps>

001021bb <vector78>:
.globl vector78
vector78:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $78
  1021bd:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021bf:	e9 27 fd ff ff       	jmp    101eeb <__alltraps>

001021c4 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $79
  1021c6:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021c8:	e9 1e fd ff ff       	jmp    101eeb <__alltraps>

001021cd <vector80>:
.globl vector80
vector80:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $80
  1021cf:	6a 50                	push   $0x50
  jmp __alltraps
  1021d1:	e9 15 fd ff ff       	jmp    101eeb <__alltraps>

001021d6 <vector81>:
.globl vector81
vector81:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $81
  1021d8:	6a 51                	push   $0x51
  jmp __alltraps
  1021da:	e9 0c fd ff ff       	jmp    101eeb <__alltraps>

001021df <vector82>:
.globl vector82
vector82:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $82
  1021e1:	6a 52                	push   $0x52
  jmp __alltraps
  1021e3:	e9 03 fd ff ff       	jmp    101eeb <__alltraps>

001021e8 <vector83>:
.globl vector83
vector83:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $83
  1021ea:	6a 53                	push   $0x53
  jmp __alltraps
  1021ec:	e9 fa fc ff ff       	jmp    101eeb <__alltraps>

001021f1 <vector84>:
.globl vector84
vector84:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $84
  1021f3:	6a 54                	push   $0x54
  jmp __alltraps
  1021f5:	e9 f1 fc ff ff       	jmp    101eeb <__alltraps>

001021fa <vector85>:
.globl vector85
vector85:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $85
  1021fc:	6a 55                	push   $0x55
  jmp __alltraps
  1021fe:	e9 e8 fc ff ff       	jmp    101eeb <__alltraps>

00102203 <vector86>:
.globl vector86
vector86:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $86
  102205:	6a 56                	push   $0x56
  jmp __alltraps
  102207:	e9 df fc ff ff       	jmp    101eeb <__alltraps>

0010220c <vector87>:
.globl vector87
vector87:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $87
  10220e:	6a 57                	push   $0x57
  jmp __alltraps
  102210:	e9 d6 fc ff ff       	jmp    101eeb <__alltraps>

00102215 <vector88>:
.globl vector88
vector88:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $88
  102217:	6a 58                	push   $0x58
  jmp __alltraps
  102219:	e9 cd fc ff ff       	jmp    101eeb <__alltraps>

0010221e <vector89>:
.globl vector89
vector89:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $89
  102220:	6a 59                	push   $0x59
  jmp __alltraps
  102222:	e9 c4 fc ff ff       	jmp    101eeb <__alltraps>

00102227 <vector90>:
.globl vector90
vector90:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $90
  102229:	6a 5a                	push   $0x5a
  jmp __alltraps
  10222b:	e9 bb fc ff ff       	jmp    101eeb <__alltraps>

00102230 <vector91>:
.globl vector91
vector91:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $91
  102232:	6a 5b                	push   $0x5b
  jmp __alltraps
  102234:	e9 b2 fc ff ff       	jmp    101eeb <__alltraps>

00102239 <vector92>:
.globl vector92
vector92:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $92
  10223b:	6a 5c                	push   $0x5c
  jmp __alltraps
  10223d:	e9 a9 fc ff ff       	jmp    101eeb <__alltraps>

00102242 <vector93>:
.globl vector93
vector93:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $93
  102244:	6a 5d                	push   $0x5d
  jmp __alltraps
  102246:	e9 a0 fc ff ff       	jmp    101eeb <__alltraps>

0010224b <vector94>:
.globl vector94
vector94:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $94
  10224d:	6a 5e                	push   $0x5e
  jmp __alltraps
  10224f:	e9 97 fc ff ff       	jmp    101eeb <__alltraps>

00102254 <vector95>:
.globl vector95
vector95:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $95
  102256:	6a 5f                	push   $0x5f
  jmp __alltraps
  102258:	e9 8e fc ff ff       	jmp    101eeb <__alltraps>

0010225d <vector96>:
.globl vector96
vector96:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $96
  10225f:	6a 60                	push   $0x60
  jmp __alltraps
  102261:	e9 85 fc ff ff       	jmp    101eeb <__alltraps>

00102266 <vector97>:
.globl vector97
vector97:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $97
  102268:	6a 61                	push   $0x61
  jmp __alltraps
  10226a:	e9 7c fc ff ff       	jmp    101eeb <__alltraps>

0010226f <vector98>:
.globl vector98
vector98:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $98
  102271:	6a 62                	push   $0x62
  jmp __alltraps
  102273:	e9 73 fc ff ff       	jmp    101eeb <__alltraps>

00102278 <vector99>:
.globl vector99
vector99:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $99
  10227a:	6a 63                	push   $0x63
  jmp __alltraps
  10227c:	e9 6a fc ff ff       	jmp    101eeb <__alltraps>

00102281 <vector100>:
.globl vector100
vector100:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $100
  102283:	6a 64                	push   $0x64
  jmp __alltraps
  102285:	e9 61 fc ff ff       	jmp    101eeb <__alltraps>

0010228a <vector101>:
.globl vector101
vector101:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $101
  10228c:	6a 65                	push   $0x65
  jmp __alltraps
  10228e:	e9 58 fc ff ff       	jmp    101eeb <__alltraps>

00102293 <vector102>:
.globl vector102
vector102:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $102
  102295:	6a 66                	push   $0x66
  jmp __alltraps
  102297:	e9 4f fc ff ff       	jmp    101eeb <__alltraps>

0010229c <vector103>:
.globl vector103
vector103:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $103
  10229e:	6a 67                	push   $0x67
  jmp __alltraps
  1022a0:	e9 46 fc ff ff       	jmp    101eeb <__alltraps>

001022a5 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $104
  1022a7:	6a 68                	push   $0x68
  jmp __alltraps
  1022a9:	e9 3d fc ff ff       	jmp    101eeb <__alltraps>

001022ae <vector105>:
.globl vector105
vector105:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $105
  1022b0:	6a 69                	push   $0x69
  jmp __alltraps
  1022b2:	e9 34 fc ff ff       	jmp    101eeb <__alltraps>

001022b7 <vector106>:
.globl vector106
vector106:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $106
  1022b9:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022bb:	e9 2b fc ff ff       	jmp    101eeb <__alltraps>

001022c0 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $107
  1022c2:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022c4:	e9 22 fc ff ff       	jmp    101eeb <__alltraps>

001022c9 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $108
  1022cb:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022cd:	e9 19 fc ff ff       	jmp    101eeb <__alltraps>

001022d2 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $109
  1022d4:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022d6:	e9 10 fc ff ff       	jmp    101eeb <__alltraps>

001022db <vector110>:
.globl vector110
vector110:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $110
  1022dd:	6a 6e                	push   $0x6e
  jmp __alltraps
  1022df:	e9 07 fc ff ff       	jmp    101eeb <__alltraps>

001022e4 <vector111>:
.globl vector111
vector111:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $111
  1022e6:	6a 6f                	push   $0x6f
  jmp __alltraps
  1022e8:	e9 fe fb ff ff       	jmp    101eeb <__alltraps>

001022ed <vector112>:
.globl vector112
vector112:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $112
  1022ef:	6a 70                	push   $0x70
  jmp __alltraps
  1022f1:	e9 f5 fb ff ff       	jmp    101eeb <__alltraps>

001022f6 <vector113>:
.globl vector113
vector113:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $113
  1022f8:	6a 71                	push   $0x71
  jmp __alltraps
  1022fa:	e9 ec fb ff ff       	jmp    101eeb <__alltraps>

001022ff <vector114>:
.globl vector114
vector114:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $114
  102301:	6a 72                	push   $0x72
  jmp __alltraps
  102303:	e9 e3 fb ff ff       	jmp    101eeb <__alltraps>

00102308 <vector115>:
.globl vector115
vector115:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $115
  10230a:	6a 73                	push   $0x73
  jmp __alltraps
  10230c:	e9 da fb ff ff       	jmp    101eeb <__alltraps>

00102311 <vector116>:
.globl vector116
vector116:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $116
  102313:	6a 74                	push   $0x74
  jmp __alltraps
  102315:	e9 d1 fb ff ff       	jmp    101eeb <__alltraps>

0010231a <vector117>:
.globl vector117
vector117:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $117
  10231c:	6a 75                	push   $0x75
  jmp __alltraps
  10231e:	e9 c8 fb ff ff       	jmp    101eeb <__alltraps>

00102323 <vector118>:
.globl vector118
vector118:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $118
  102325:	6a 76                	push   $0x76
  jmp __alltraps
  102327:	e9 bf fb ff ff       	jmp    101eeb <__alltraps>

0010232c <vector119>:
.globl vector119
vector119:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $119
  10232e:	6a 77                	push   $0x77
  jmp __alltraps
  102330:	e9 b6 fb ff ff       	jmp    101eeb <__alltraps>

00102335 <vector120>:
.globl vector120
vector120:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $120
  102337:	6a 78                	push   $0x78
  jmp __alltraps
  102339:	e9 ad fb ff ff       	jmp    101eeb <__alltraps>

0010233e <vector121>:
.globl vector121
vector121:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $121
  102340:	6a 79                	push   $0x79
  jmp __alltraps
  102342:	e9 a4 fb ff ff       	jmp    101eeb <__alltraps>

00102347 <vector122>:
.globl vector122
vector122:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $122
  102349:	6a 7a                	push   $0x7a
  jmp __alltraps
  10234b:	e9 9b fb ff ff       	jmp    101eeb <__alltraps>

00102350 <vector123>:
.globl vector123
vector123:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $123
  102352:	6a 7b                	push   $0x7b
  jmp __alltraps
  102354:	e9 92 fb ff ff       	jmp    101eeb <__alltraps>

00102359 <vector124>:
.globl vector124
vector124:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $124
  10235b:	6a 7c                	push   $0x7c
  jmp __alltraps
  10235d:	e9 89 fb ff ff       	jmp    101eeb <__alltraps>

00102362 <vector125>:
.globl vector125
vector125:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $125
  102364:	6a 7d                	push   $0x7d
  jmp __alltraps
  102366:	e9 80 fb ff ff       	jmp    101eeb <__alltraps>

0010236b <vector126>:
.globl vector126
vector126:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $126
  10236d:	6a 7e                	push   $0x7e
  jmp __alltraps
  10236f:	e9 77 fb ff ff       	jmp    101eeb <__alltraps>

00102374 <vector127>:
.globl vector127
vector127:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $127
  102376:	6a 7f                	push   $0x7f
  jmp __alltraps
  102378:	e9 6e fb ff ff       	jmp    101eeb <__alltraps>

0010237d <vector128>:
.globl vector128
vector128:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $128
  10237f:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102384:	e9 62 fb ff ff       	jmp    101eeb <__alltraps>

00102389 <vector129>:
.globl vector129
vector129:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $129
  10238b:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102390:	e9 56 fb ff ff       	jmp    101eeb <__alltraps>

00102395 <vector130>:
.globl vector130
vector130:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $130
  102397:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10239c:	e9 4a fb ff ff       	jmp    101eeb <__alltraps>

001023a1 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $131
  1023a3:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023a8:	e9 3e fb ff ff       	jmp    101eeb <__alltraps>

001023ad <vector132>:
.globl vector132
vector132:
  pushl $0
  1023ad:	6a 00                	push   $0x0
  pushl $132
  1023af:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023b4:	e9 32 fb ff ff       	jmp    101eeb <__alltraps>

001023b9 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023b9:	6a 00                	push   $0x0
  pushl $133
  1023bb:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023c0:	e9 26 fb ff ff       	jmp    101eeb <__alltraps>

001023c5 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $134
  1023c7:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023cc:	e9 1a fb ff ff       	jmp    101eeb <__alltraps>

001023d1 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023d1:	6a 00                	push   $0x0
  pushl $135
  1023d3:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023d8:	e9 0e fb ff ff       	jmp    101eeb <__alltraps>

001023dd <vector136>:
.globl vector136
vector136:
  pushl $0
  1023dd:	6a 00                	push   $0x0
  pushl $136
  1023df:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1023e4:	e9 02 fb ff ff       	jmp    101eeb <__alltraps>

001023e9 <vector137>:
.globl vector137
vector137:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $137
  1023eb:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1023f0:	e9 f6 fa ff ff       	jmp    101eeb <__alltraps>

001023f5 <vector138>:
.globl vector138
vector138:
  pushl $0
  1023f5:	6a 00                	push   $0x0
  pushl $138
  1023f7:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023fc:	e9 ea fa ff ff       	jmp    101eeb <__alltraps>

00102401 <vector139>:
.globl vector139
vector139:
  pushl $0
  102401:	6a 00                	push   $0x0
  pushl $139
  102403:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102408:	e9 de fa ff ff       	jmp    101eeb <__alltraps>

0010240d <vector140>:
.globl vector140
vector140:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $140
  10240f:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102414:	e9 d2 fa ff ff       	jmp    101eeb <__alltraps>

00102419 <vector141>:
.globl vector141
vector141:
  pushl $0
  102419:	6a 00                	push   $0x0
  pushl $141
  10241b:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102420:	e9 c6 fa ff ff       	jmp    101eeb <__alltraps>

00102425 <vector142>:
.globl vector142
vector142:
  pushl $0
  102425:	6a 00                	push   $0x0
  pushl $142
  102427:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10242c:	e9 ba fa ff ff       	jmp    101eeb <__alltraps>

00102431 <vector143>:
.globl vector143
vector143:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $143
  102433:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  102438:	e9 ae fa ff ff       	jmp    101eeb <__alltraps>

0010243d <vector144>:
.globl vector144
vector144:
  pushl $0
  10243d:	6a 00                	push   $0x0
  pushl $144
  10243f:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102444:	e9 a2 fa ff ff       	jmp    101eeb <__alltraps>

00102449 <vector145>:
.globl vector145
vector145:
  pushl $0
  102449:	6a 00                	push   $0x0
  pushl $145
  10244b:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102450:	e9 96 fa ff ff       	jmp    101eeb <__alltraps>

00102455 <vector146>:
.globl vector146
vector146:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $146
  102457:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10245c:	e9 8a fa ff ff       	jmp    101eeb <__alltraps>

00102461 <vector147>:
.globl vector147
vector147:
  pushl $0
  102461:	6a 00                	push   $0x0
  pushl $147
  102463:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102468:	e9 7e fa ff ff       	jmp    101eeb <__alltraps>

0010246d <vector148>:
.globl vector148
vector148:
  pushl $0
  10246d:	6a 00                	push   $0x0
  pushl $148
  10246f:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102474:	e9 72 fa ff ff       	jmp    101eeb <__alltraps>

00102479 <vector149>:
.globl vector149
vector149:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $149
  10247b:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102480:	e9 66 fa ff ff       	jmp    101eeb <__alltraps>

00102485 <vector150>:
.globl vector150
vector150:
  pushl $0
  102485:	6a 00                	push   $0x0
  pushl $150
  102487:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10248c:	e9 5a fa ff ff       	jmp    101eeb <__alltraps>

00102491 <vector151>:
.globl vector151
vector151:
  pushl $0
  102491:	6a 00                	push   $0x0
  pushl $151
  102493:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102498:	e9 4e fa ff ff       	jmp    101eeb <__alltraps>

0010249d <vector152>:
.globl vector152
vector152:
  pushl $0
  10249d:	6a 00                	push   $0x0
  pushl $152
  10249f:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024a4:	e9 42 fa ff ff       	jmp    101eeb <__alltraps>

001024a9 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024a9:	6a 00                	push   $0x0
  pushl $153
  1024ab:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024b0:	e9 36 fa ff ff       	jmp    101eeb <__alltraps>

001024b5 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024b5:	6a 00                	push   $0x0
  pushl $154
  1024b7:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024bc:	e9 2a fa ff ff       	jmp    101eeb <__alltraps>

001024c1 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024c1:	6a 00                	push   $0x0
  pushl $155
  1024c3:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024c8:	e9 1e fa ff ff       	jmp    101eeb <__alltraps>

001024cd <vector156>:
.globl vector156
vector156:
  pushl $0
  1024cd:	6a 00                	push   $0x0
  pushl $156
  1024cf:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024d4:	e9 12 fa ff ff       	jmp    101eeb <__alltraps>

001024d9 <vector157>:
.globl vector157
vector157:
  pushl $0
  1024d9:	6a 00                	push   $0x0
  pushl $157
  1024db:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1024e0:	e9 06 fa ff ff       	jmp    101eeb <__alltraps>

001024e5 <vector158>:
.globl vector158
vector158:
  pushl $0
  1024e5:	6a 00                	push   $0x0
  pushl $158
  1024e7:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1024ec:	e9 fa f9 ff ff       	jmp    101eeb <__alltraps>

001024f1 <vector159>:
.globl vector159
vector159:
  pushl $0
  1024f1:	6a 00                	push   $0x0
  pushl $159
  1024f3:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024f8:	e9 ee f9 ff ff       	jmp    101eeb <__alltraps>

001024fd <vector160>:
.globl vector160
vector160:
  pushl $0
  1024fd:	6a 00                	push   $0x0
  pushl $160
  1024ff:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102504:	e9 e2 f9 ff ff       	jmp    101eeb <__alltraps>

00102509 <vector161>:
.globl vector161
vector161:
  pushl $0
  102509:	6a 00                	push   $0x0
  pushl $161
  10250b:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102510:	e9 d6 f9 ff ff       	jmp    101eeb <__alltraps>

00102515 <vector162>:
.globl vector162
vector162:
  pushl $0
  102515:	6a 00                	push   $0x0
  pushl $162
  102517:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10251c:	e9 ca f9 ff ff       	jmp    101eeb <__alltraps>

00102521 <vector163>:
.globl vector163
vector163:
  pushl $0
  102521:	6a 00                	push   $0x0
  pushl $163
  102523:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102528:	e9 be f9 ff ff       	jmp    101eeb <__alltraps>

0010252d <vector164>:
.globl vector164
vector164:
  pushl $0
  10252d:	6a 00                	push   $0x0
  pushl $164
  10252f:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102534:	e9 b2 f9 ff ff       	jmp    101eeb <__alltraps>

00102539 <vector165>:
.globl vector165
vector165:
  pushl $0
  102539:	6a 00                	push   $0x0
  pushl $165
  10253b:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102540:	e9 a6 f9 ff ff       	jmp    101eeb <__alltraps>

00102545 <vector166>:
.globl vector166
vector166:
  pushl $0
  102545:	6a 00                	push   $0x0
  pushl $166
  102547:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10254c:	e9 9a f9 ff ff       	jmp    101eeb <__alltraps>

00102551 <vector167>:
.globl vector167
vector167:
  pushl $0
  102551:	6a 00                	push   $0x0
  pushl $167
  102553:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102558:	e9 8e f9 ff ff       	jmp    101eeb <__alltraps>

0010255d <vector168>:
.globl vector168
vector168:
  pushl $0
  10255d:	6a 00                	push   $0x0
  pushl $168
  10255f:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102564:	e9 82 f9 ff ff       	jmp    101eeb <__alltraps>

00102569 <vector169>:
.globl vector169
vector169:
  pushl $0
  102569:	6a 00                	push   $0x0
  pushl $169
  10256b:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102570:	e9 76 f9 ff ff       	jmp    101eeb <__alltraps>

00102575 <vector170>:
.globl vector170
vector170:
  pushl $0
  102575:	6a 00                	push   $0x0
  pushl $170
  102577:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10257c:	e9 6a f9 ff ff       	jmp    101eeb <__alltraps>

00102581 <vector171>:
.globl vector171
vector171:
  pushl $0
  102581:	6a 00                	push   $0x0
  pushl $171
  102583:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102588:	e9 5e f9 ff ff       	jmp    101eeb <__alltraps>

0010258d <vector172>:
.globl vector172
vector172:
  pushl $0
  10258d:	6a 00                	push   $0x0
  pushl $172
  10258f:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102594:	e9 52 f9 ff ff       	jmp    101eeb <__alltraps>

00102599 <vector173>:
.globl vector173
vector173:
  pushl $0
  102599:	6a 00                	push   $0x0
  pushl $173
  10259b:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025a0:	e9 46 f9 ff ff       	jmp    101eeb <__alltraps>

001025a5 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025a5:	6a 00                	push   $0x0
  pushl $174
  1025a7:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025ac:	e9 3a f9 ff ff       	jmp    101eeb <__alltraps>

001025b1 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025b1:	6a 00                	push   $0x0
  pushl $175
  1025b3:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025b8:	e9 2e f9 ff ff       	jmp    101eeb <__alltraps>

001025bd <vector176>:
.globl vector176
vector176:
  pushl $0
  1025bd:	6a 00                	push   $0x0
  pushl $176
  1025bf:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025c4:	e9 22 f9 ff ff       	jmp    101eeb <__alltraps>

001025c9 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025c9:	6a 00                	push   $0x0
  pushl $177
  1025cb:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025d0:	e9 16 f9 ff ff       	jmp    101eeb <__alltraps>

001025d5 <vector178>:
.globl vector178
vector178:
  pushl $0
  1025d5:	6a 00                	push   $0x0
  pushl $178
  1025d7:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1025dc:	e9 0a f9 ff ff       	jmp    101eeb <__alltraps>

001025e1 <vector179>:
.globl vector179
vector179:
  pushl $0
  1025e1:	6a 00                	push   $0x0
  pushl $179
  1025e3:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1025e8:	e9 fe f8 ff ff       	jmp    101eeb <__alltraps>

001025ed <vector180>:
.globl vector180
vector180:
  pushl $0
  1025ed:	6a 00                	push   $0x0
  pushl $180
  1025ef:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1025f4:	e9 f2 f8 ff ff       	jmp    101eeb <__alltraps>

001025f9 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025f9:	6a 00                	push   $0x0
  pushl $181
  1025fb:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102600:	e9 e6 f8 ff ff       	jmp    101eeb <__alltraps>

00102605 <vector182>:
.globl vector182
vector182:
  pushl $0
  102605:	6a 00                	push   $0x0
  pushl $182
  102607:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10260c:	e9 da f8 ff ff       	jmp    101eeb <__alltraps>

00102611 <vector183>:
.globl vector183
vector183:
  pushl $0
  102611:	6a 00                	push   $0x0
  pushl $183
  102613:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102618:	e9 ce f8 ff ff       	jmp    101eeb <__alltraps>

0010261d <vector184>:
.globl vector184
vector184:
  pushl $0
  10261d:	6a 00                	push   $0x0
  pushl $184
  10261f:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102624:	e9 c2 f8 ff ff       	jmp    101eeb <__alltraps>

00102629 <vector185>:
.globl vector185
vector185:
  pushl $0
  102629:	6a 00                	push   $0x0
  pushl $185
  10262b:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102630:	e9 b6 f8 ff ff       	jmp    101eeb <__alltraps>

00102635 <vector186>:
.globl vector186
vector186:
  pushl $0
  102635:	6a 00                	push   $0x0
  pushl $186
  102637:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10263c:	e9 aa f8 ff ff       	jmp    101eeb <__alltraps>

00102641 <vector187>:
.globl vector187
vector187:
  pushl $0
  102641:	6a 00                	push   $0x0
  pushl $187
  102643:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102648:	e9 9e f8 ff ff       	jmp    101eeb <__alltraps>

0010264d <vector188>:
.globl vector188
vector188:
  pushl $0
  10264d:	6a 00                	push   $0x0
  pushl $188
  10264f:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102654:	e9 92 f8 ff ff       	jmp    101eeb <__alltraps>

00102659 <vector189>:
.globl vector189
vector189:
  pushl $0
  102659:	6a 00                	push   $0x0
  pushl $189
  10265b:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102660:	e9 86 f8 ff ff       	jmp    101eeb <__alltraps>

00102665 <vector190>:
.globl vector190
vector190:
  pushl $0
  102665:	6a 00                	push   $0x0
  pushl $190
  102667:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10266c:	e9 7a f8 ff ff       	jmp    101eeb <__alltraps>

00102671 <vector191>:
.globl vector191
vector191:
  pushl $0
  102671:	6a 00                	push   $0x0
  pushl $191
  102673:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102678:	e9 6e f8 ff ff       	jmp    101eeb <__alltraps>

0010267d <vector192>:
.globl vector192
vector192:
  pushl $0
  10267d:	6a 00                	push   $0x0
  pushl $192
  10267f:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102684:	e9 62 f8 ff ff       	jmp    101eeb <__alltraps>

00102689 <vector193>:
.globl vector193
vector193:
  pushl $0
  102689:	6a 00                	push   $0x0
  pushl $193
  10268b:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102690:	e9 56 f8 ff ff       	jmp    101eeb <__alltraps>

00102695 <vector194>:
.globl vector194
vector194:
  pushl $0
  102695:	6a 00                	push   $0x0
  pushl $194
  102697:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10269c:	e9 4a f8 ff ff       	jmp    101eeb <__alltraps>

001026a1 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026a1:	6a 00                	push   $0x0
  pushl $195
  1026a3:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026a8:	e9 3e f8 ff ff       	jmp    101eeb <__alltraps>

001026ad <vector196>:
.globl vector196
vector196:
  pushl $0
  1026ad:	6a 00                	push   $0x0
  pushl $196
  1026af:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026b4:	e9 32 f8 ff ff       	jmp    101eeb <__alltraps>

001026b9 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026b9:	6a 00                	push   $0x0
  pushl $197
  1026bb:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026c0:	e9 26 f8 ff ff       	jmp    101eeb <__alltraps>

001026c5 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026c5:	6a 00                	push   $0x0
  pushl $198
  1026c7:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026cc:	e9 1a f8 ff ff       	jmp    101eeb <__alltraps>

001026d1 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026d1:	6a 00                	push   $0x0
  pushl $199
  1026d3:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026d8:	e9 0e f8 ff ff       	jmp    101eeb <__alltraps>

001026dd <vector200>:
.globl vector200
vector200:
  pushl $0
  1026dd:	6a 00                	push   $0x0
  pushl $200
  1026df:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1026e4:	e9 02 f8 ff ff       	jmp    101eeb <__alltraps>

001026e9 <vector201>:
.globl vector201
vector201:
  pushl $0
  1026e9:	6a 00                	push   $0x0
  pushl $201
  1026eb:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1026f0:	e9 f6 f7 ff ff       	jmp    101eeb <__alltraps>

001026f5 <vector202>:
.globl vector202
vector202:
  pushl $0
  1026f5:	6a 00                	push   $0x0
  pushl $202
  1026f7:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026fc:	e9 ea f7 ff ff       	jmp    101eeb <__alltraps>

00102701 <vector203>:
.globl vector203
vector203:
  pushl $0
  102701:	6a 00                	push   $0x0
  pushl $203
  102703:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102708:	e9 de f7 ff ff       	jmp    101eeb <__alltraps>

0010270d <vector204>:
.globl vector204
vector204:
  pushl $0
  10270d:	6a 00                	push   $0x0
  pushl $204
  10270f:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102714:	e9 d2 f7 ff ff       	jmp    101eeb <__alltraps>

00102719 <vector205>:
.globl vector205
vector205:
  pushl $0
  102719:	6a 00                	push   $0x0
  pushl $205
  10271b:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102720:	e9 c6 f7 ff ff       	jmp    101eeb <__alltraps>

00102725 <vector206>:
.globl vector206
vector206:
  pushl $0
  102725:	6a 00                	push   $0x0
  pushl $206
  102727:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10272c:	e9 ba f7 ff ff       	jmp    101eeb <__alltraps>

00102731 <vector207>:
.globl vector207
vector207:
  pushl $0
  102731:	6a 00                	push   $0x0
  pushl $207
  102733:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  102738:	e9 ae f7 ff ff       	jmp    101eeb <__alltraps>

0010273d <vector208>:
.globl vector208
vector208:
  pushl $0
  10273d:	6a 00                	push   $0x0
  pushl $208
  10273f:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102744:	e9 a2 f7 ff ff       	jmp    101eeb <__alltraps>

00102749 <vector209>:
.globl vector209
vector209:
  pushl $0
  102749:	6a 00                	push   $0x0
  pushl $209
  10274b:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102750:	e9 96 f7 ff ff       	jmp    101eeb <__alltraps>

00102755 <vector210>:
.globl vector210
vector210:
  pushl $0
  102755:	6a 00                	push   $0x0
  pushl $210
  102757:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10275c:	e9 8a f7 ff ff       	jmp    101eeb <__alltraps>

00102761 <vector211>:
.globl vector211
vector211:
  pushl $0
  102761:	6a 00                	push   $0x0
  pushl $211
  102763:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102768:	e9 7e f7 ff ff       	jmp    101eeb <__alltraps>

0010276d <vector212>:
.globl vector212
vector212:
  pushl $0
  10276d:	6a 00                	push   $0x0
  pushl $212
  10276f:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102774:	e9 72 f7 ff ff       	jmp    101eeb <__alltraps>

00102779 <vector213>:
.globl vector213
vector213:
  pushl $0
  102779:	6a 00                	push   $0x0
  pushl $213
  10277b:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102780:	e9 66 f7 ff ff       	jmp    101eeb <__alltraps>

00102785 <vector214>:
.globl vector214
vector214:
  pushl $0
  102785:	6a 00                	push   $0x0
  pushl $214
  102787:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10278c:	e9 5a f7 ff ff       	jmp    101eeb <__alltraps>

00102791 <vector215>:
.globl vector215
vector215:
  pushl $0
  102791:	6a 00                	push   $0x0
  pushl $215
  102793:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102798:	e9 4e f7 ff ff       	jmp    101eeb <__alltraps>

0010279d <vector216>:
.globl vector216
vector216:
  pushl $0
  10279d:	6a 00                	push   $0x0
  pushl $216
  10279f:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027a4:	e9 42 f7 ff ff       	jmp    101eeb <__alltraps>

001027a9 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027a9:	6a 00                	push   $0x0
  pushl $217
  1027ab:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027b0:	e9 36 f7 ff ff       	jmp    101eeb <__alltraps>

001027b5 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027b5:	6a 00                	push   $0x0
  pushl $218
  1027b7:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027bc:	e9 2a f7 ff ff       	jmp    101eeb <__alltraps>

001027c1 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027c1:	6a 00                	push   $0x0
  pushl $219
  1027c3:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027c8:	e9 1e f7 ff ff       	jmp    101eeb <__alltraps>

001027cd <vector220>:
.globl vector220
vector220:
  pushl $0
  1027cd:	6a 00                	push   $0x0
  pushl $220
  1027cf:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027d4:	e9 12 f7 ff ff       	jmp    101eeb <__alltraps>

001027d9 <vector221>:
.globl vector221
vector221:
  pushl $0
  1027d9:	6a 00                	push   $0x0
  pushl $221
  1027db:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1027e0:	e9 06 f7 ff ff       	jmp    101eeb <__alltraps>

001027e5 <vector222>:
.globl vector222
vector222:
  pushl $0
  1027e5:	6a 00                	push   $0x0
  pushl $222
  1027e7:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1027ec:	e9 fa f6 ff ff       	jmp    101eeb <__alltraps>

001027f1 <vector223>:
.globl vector223
vector223:
  pushl $0
  1027f1:	6a 00                	push   $0x0
  pushl $223
  1027f3:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027f8:	e9 ee f6 ff ff       	jmp    101eeb <__alltraps>

001027fd <vector224>:
.globl vector224
vector224:
  pushl $0
  1027fd:	6a 00                	push   $0x0
  pushl $224
  1027ff:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102804:	e9 e2 f6 ff ff       	jmp    101eeb <__alltraps>

00102809 <vector225>:
.globl vector225
vector225:
  pushl $0
  102809:	6a 00                	push   $0x0
  pushl $225
  10280b:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102810:	e9 d6 f6 ff ff       	jmp    101eeb <__alltraps>

00102815 <vector226>:
.globl vector226
vector226:
  pushl $0
  102815:	6a 00                	push   $0x0
  pushl $226
  102817:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10281c:	e9 ca f6 ff ff       	jmp    101eeb <__alltraps>

00102821 <vector227>:
.globl vector227
vector227:
  pushl $0
  102821:	6a 00                	push   $0x0
  pushl $227
  102823:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102828:	e9 be f6 ff ff       	jmp    101eeb <__alltraps>

0010282d <vector228>:
.globl vector228
vector228:
  pushl $0
  10282d:	6a 00                	push   $0x0
  pushl $228
  10282f:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102834:	e9 b2 f6 ff ff       	jmp    101eeb <__alltraps>

00102839 <vector229>:
.globl vector229
vector229:
  pushl $0
  102839:	6a 00                	push   $0x0
  pushl $229
  10283b:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102840:	e9 a6 f6 ff ff       	jmp    101eeb <__alltraps>

00102845 <vector230>:
.globl vector230
vector230:
  pushl $0
  102845:	6a 00                	push   $0x0
  pushl $230
  102847:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10284c:	e9 9a f6 ff ff       	jmp    101eeb <__alltraps>

00102851 <vector231>:
.globl vector231
vector231:
  pushl $0
  102851:	6a 00                	push   $0x0
  pushl $231
  102853:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102858:	e9 8e f6 ff ff       	jmp    101eeb <__alltraps>

0010285d <vector232>:
.globl vector232
vector232:
  pushl $0
  10285d:	6a 00                	push   $0x0
  pushl $232
  10285f:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102864:	e9 82 f6 ff ff       	jmp    101eeb <__alltraps>

00102869 <vector233>:
.globl vector233
vector233:
  pushl $0
  102869:	6a 00                	push   $0x0
  pushl $233
  10286b:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102870:	e9 76 f6 ff ff       	jmp    101eeb <__alltraps>

00102875 <vector234>:
.globl vector234
vector234:
  pushl $0
  102875:	6a 00                	push   $0x0
  pushl $234
  102877:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10287c:	e9 6a f6 ff ff       	jmp    101eeb <__alltraps>

00102881 <vector235>:
.globl vector235
vector235:
  pushl $0
  102881:	6a 00                	push   $0x0
  pushl $235
  102883:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102888:	e9 5e f6 ff ff       	jmp    101eeb <__alltraps>

0010288d <vector236>:
.globl vector236
vector236:
  pushl $0
  10288d:	6a 00                	push   $0x0
  pushl $236
  10288f:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102894:	e9 52 f6 ff ff       	jmp    101eeb <__alltraps>

00102899 <vector237>:
.globl vector237
vector237:
  pushl $0
  102899:	6a 00                	push   $0x0
  pushl $237
  10289b:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028a0:	e9 46 f6 ff ff       	jmp    101eeb <__alltraps>

001028a5 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028a5:	6a 00                	push   $0x0
  pushl $238
  1028a7:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028ac:	e9 3a f6 ff ff       	jmp    101eeb <__alltraps>

001028b1 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028b1:	6a 00                	push   $0x0
  pushl $239
  1028b3:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028b8:	e9 2e f6 ff ff       	jmp    101eeb <__alltraps>

001028bd <vector240>:
.globl vector240
vector240:
  pushl $0
  1028bd:	6a 00                	push   $0x0
  pushl $240
  1028bf:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028c4:	e9 22 f6 ff ff       	jmp    101eeb <__alltraps>

001028c9 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028c9:	6a 00                	push   $0x0
  pushl $241
  1028cb:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028d0:	e9 16 f6 ff ff       	jmp    101eeb <__alltraps>

001028d5 <vector242>:
.globl vector242
vector242:
  pushl $0
  1028d5:	6a 00                	push   $0x0
  pushl $242
  1028d7:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1028dc:	e9 0a f6 ff ff       	jmp    101eeb <__alltraps>

001028e1 <vector243>:
.globl vector243
vector243:
  pushl $0
  1028e1:	6a 00                	push   $0x0
  pushl $243
  1028e3:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1028e8:	e9 fe f5 ff ff       	jmp    101eeb <__alltraps>

001028ed <vector244>:
.globl vector244
vector244:
  pushl $0
  1028ed:	6a 00                	push   $0x0
  pushl $244
  1028ef:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1028f4:	e9 f2 f5 ff ff       	jmp    101eeb <__alltraps>

001028f9 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028f9:	6a 00                	push   $0x0
  pushl $245
  1028fb:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102900:	e9 e6 f5 ff ff       	jmp    101eeb <__alltraps>

00102905 <vector246>:
.globl vector246
vector246:
  pushl $0
  102905:	6a 00                	push   $0x0
  pushl $246
  102907:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10290c:	e9 da f5 ff ff       	jmp    101eeb <__alltraps>

00102911 <vector247>:
.globl vector247
vector247:
  pushl $0
  102911:	6a 00                	push   $0x0
  pushl $247
  102913:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102918:	e9 ce f5 ff ff       	jmp    101eeb <__alltraps>

0010291d <vector248>:
.globl vector248
vector248:
  pushl $0
  10291d:	6a 00                	push   $0x0
  pushl $248
  10291f:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102924:	e9 c2 f5 ff ff       	jmp    101eeb <__alltraps>

00102929 <vector249>:
.globl vector249
vector249:
  pushl $0
  102929:	6a 00                	push   $0x0
  pushl $249
  10292b:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102930:	e9 b6 f5 ff ff       	jmp    101eeb <__alltraps>

00102935 <vector250>:
.globl vector250
vector250:
  pushl $0
  102935:	6a 00                	push   $0x0
  pushl $250
  102937:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10293c:	e9 aa f5 ff ff       	jmp    101eeb <__alltraps>

00102941 <vector251>:
.globl vector251
vector251:
  pushl $0
  102941:	6a 00                	push   $0x0
  pushl $251
  102943:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102948:	e9 9e f5 ff ff       	jmp    101eeb <__alltraps>

0010294d <vector252>:
.globl vector252
vector252:
  pushl $0
  10294d:	6a 00                	push   $0x0
  pushl $252
  10294f:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102954:	e9 92 f5 ff ff       	jmp    101eeb <__alltraps>

00102959 <vector253>:
.globl vector253
vector253:
  pushl $0
  102959:	6a 00                	push   $0x0
  pushl $253
  10295b:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102960:	e9 86 f5 ff ff       	jmp    101eeb <__alltraps>

00102965 <vector254>:
.globl vector254
vector254:
  pushl $0
  102965:	6a 00                	push   $0x0
  pushl $254
  102967:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10296c:	e9 7a f5 ff ff       	jmp    101eeb <__alltraps>

00102971 <vector255>:
.globl vector255
vector255:
  pushl $0
  102971:	6a 00                	push   $0x0
  pushl $255
  102973:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102978:	e9 6e f5 ff ff       	jmp    101eeb <__alltraps>

0010297d <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10297d:	55                   	push   %ebp
  10297e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102980:	8b 45 08             	mov    0x8(%ebp),%eax
  102983:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102986:	b8 23 00 00 00       	mov    $0x23,%eax
  10298b:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10298d:	b8 23 00 00 00       	mov    $0x23,%eax
  102992:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102994:	b8 10 00 00 00       	mov    $0x10,%eax
  102999:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10299b:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a0:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029a2:	b8 10 00 00 00       	mov    $0x10,%eax
  1029a7:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029a9:	ea b0 29 10 00 08 00 	ljmp   $0x8,$0x1029b0
}
  1029b0:	5d                   	pop    %ebp
  1029b1:	c3                   	ret    

001029b2 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  1029b2:	55                   	push   %ebp
  1029b3:	89 e5                	mov    %esp,%ebp
  1029b5:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  1029b8:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  1029bd:	05 00 04 00 00       	add    $0x400,%eax
  1029c2:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1029c7:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1029ce:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1029d0:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1029d7:	68 00 
  1029d9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029de:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029e4:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029e9:	c1 e8 10             	shr    $0x10,%eax
  1029ec:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029f1:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029f8:	83 e0 f0             	and    $0xfffffff0,%eax
  1029fb:	83 c8 09             	or     $0x9,%eax
  1029fe:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a03:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a0a:	83 c8 10             	or     $0x10,%eax
  102a0d:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a12:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a19:	83 e0 9f             	and    $0xffffff9f,%eax
  102a1c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a21:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a28:	83 c8 80             	or     $0xffffff80,%eax
  102a2b:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a30:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a37:	83 e0 f0             	and    $0xfffffff0,%eax
  102a3a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a46:	83 e0 ef             	and    $0xffffffef,%eax
  102a49:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a4e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a55:	83 e0 df             	and    $0xffffffdf,%eax
  102a58:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a5d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a64:	83 c8 40             	or     $0x40,%eax
  102a67:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a6c:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a73:	83 e0 7f             	and    $0x7f,%eax
  102a76:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a7b:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a80:	c1 e8 18             	shr    $0x18,%eax
  102a83:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a88:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a8f:	83 e0 ef             	and    $0xffffffef,%eax
  102a92:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a97:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a9e:	e8 da fe ff ff       	call   10297d <lgdt>
  102aa3:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102aa9:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aad:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102ab0:	c9                   	leave  
  102ab1:	c3                   	ret    

00102ab2 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102ab2:	55                   	push   %ebp
  102ab3:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102ab5:	e8 f8 fe ff ff       	call   1029b2 <gdt_init>
}
  102aba:	5d                   	pop    %ebp
  102abb:	c3                   	ret    

00102abc <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102abc:	55                   	push   %ebp
  102abd:	89 e5                	mov    %esp,%ebp
  102abf:	83 ec 58             	sub    $0x58,%esp
  102ac2:	8b 45 10             	mov    0x10(%ebp),%eax
  102ac5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  102acb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102ace:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102ad1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102ad4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ad7:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102ada:	8b 45 18             	mov    0x18(%ebp),%eax
  102add:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ae3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102ae6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ae9:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102af6:	74 1c                	je     102b14 <printnum+0x58>
  102af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102afb:	ba 00 00 00 00       	mov    $0x0,%edx
  102b00:	f7 75 e4             	divl   -0x1c(%ebp)
  102b03:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b09:	ba 00 00 00 00       	mov    $0x0,%edx
  102b0e:	f7 75 e4             	divl   -0x1c(%ebp)
  102b11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b14:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b1a:	f7 75 e4             	divl   -0x1c(%ebp)
  102b1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b20:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b26:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b2c:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b2f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b32:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b35:	8b 45 18             	mov    0x18(%ebp),%eax
  102b38:	ba 00 00 00 00       	mov    $0x0,%edx
  102b3d:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b40:	77 56                	ja     102b98 <printnum+0xdc>
  102b42:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102b45:	72 05                	jb     102b4c <printnum+0x90>
  102b47:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102b4a:	77 4c                	ja     102b98 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102b4c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102b4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b52:	8b 45 20             	mov    0x20(%ebp),%eax
  102b55:	89 44 24 18          	mov    %eax,0x18(%esp)
  102b59:	89 54 24 14          	mov    %edx,0x14(%esp)
  102b5d:	8b 45 18             	mov    0x18(%ebp),%eax
  102b60:	89 44 24 10          	mov    %eax,0x10(%esp)
  102b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b67:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102b72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b79:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7c:	89 04 24             	mov    %eax,(%esp)
  102b7f:	e8 38 ff ff ff       	call   102abc <printnum>
  102b84:	eb 1c                	jmp    102ba2 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102b86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b8d:	8b 45 20             	mov    0x20(%ebp),%eax
  102b90:	89 04 24             	mov    %eax,(%esp)
  102b93:	8b 45 08             	mov    0x8(%ebp),%eax
  102b96:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102b98:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102b9c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102ba0:	7f e4                	jg     102b86 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102ba2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102ba5:	05 b0 3d 10 00       	add    $0x103db0,%eax
  102baa:	0f b6 00             	movzbl (%eax),%eax
  102bad:	0f be c0             	movsbl %al,%eax
  102bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  102bb7:	89 04 24             	mov    %eax,(%esp)
  102bba:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbd:	ff d0                	call   *%eax
}
  102bbf:	c9                   	leave  
  102bc0:	c3                   	ret    

00102bc1 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102bc1:	55                   	push   %ebp
  102bc2:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102bc4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102bc8:	7e 14                	jle    102bde <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102bca:	8b 45 08             	mov    0x8(%ebp),%eax
  102bcd:	8b 00                	mov    (%eax),%eax
  102bcf:	8d 48 08             	lea    0x8(%eax),%ecx
  102bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  102bd5:	89 0a                	mov    %ecx,(%edx)
  102bd7:	8b 50 04             	mov    0x4(%eax),%edx
  102bda:	8b 00                	mov    (%eax),%eax
  102bdc:	eb 30                	jmp    102c0e <getuint+0x4d>
    }
    else if (lflag) {
  102bde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102be2:	74 16                	je     102bfa <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102be4:	8b 45 08             	mov    0x8(%ebp),%eax
  102be7:	8b 00                	mov    (%eax),%eax
  102be9:	8d 48 04             	lea    0x4(%eax),%ecx
  102bec:	8b 55 08             	mov    0x8(%ebp),%edx
  102bef:	89 0a                	mov    %ecx,(%edx)
  102bf1:	8b 00                	mov    (%eax),%eax
  102bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  102bf8:	eb 14                	jmp    102c0e <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfd:	8b 00                	mov    (%eax),%eax
  102bff:	8d 48 04             	lea    0x4(%eax),%ecx
  102c02:	8b 55 08             	mov    0x8(%ebp),%edx
  102c05:	89 0a                	mov    %ecx,(%edx)
  102c07:	8b 00                	mov    (%eax),%eax
  102c09:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c0e:	5d                   	pop    %ebp
  102c0f:	c3                   	ret    

00102c10 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c10:	55                   	push   %ebp
  102c11:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c17:	7e 14                	jle    102c2d <getint+0x1d>
        return va_arg(*ap, long long);
  102c19:	8b 45 08             	mov    0x8(%ebp),%eax
  102c1c:	8b 00                	mov    (%eax),%eax
  102c1e:	8d 48 08             	lea    0x8(%eax),%ecx
  102c21:	8b 55 08             	mov    0x8(%ebp),%edx
  102c24:	89 0a                	mov    %ecx,(%edx)
  102c26:	8b 50 04             	mov    0x4(%eax),%edx
  102c29:	8b 00                	mov    (%eax),%eax
  102c2b:	eb 28                	jmp    102c55 <getint+0x45>
    }
    else if (lflag) {
  102c2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c31:	74 12                	je     102c45 <getint+0x35>
        return va_arg(*ap, long);
  102c33:	8b 45 08             	mov    0x8(%ebp),%eax
  102c36:	8b 00                	mov    (%eax),%eax
  102c38:	8d 48 04             	lea    0x4(%eax),%ecx
  102c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3e:	89 0a                	mov    %ecx,(%edx)
  102c40:	8b 00                	mov    (%eax),%eax
  102c42:	99                   	cltd   
  102c43:	eb 10                	jmp    102c55 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102c45:	8b 45 08             	mov    0x8(%ebp),%eax
  102c48:	8b 00                	mov    (%eax),%eax
  102c4a:	8d 48 04             	lea    0x4(%eax),%ecx
  102c4d:	8b 55 08             	mov    0x8(%ebp),%edx
  102c50:	89 0a                	mov    %ecx,(%edx)
  102c52:	8b 00                	mov    (%eax),%eax
  102c54:	99                   	cltd   
    }
}
  102c55:	5d                   	pop    %ebp
  102c56:	c3                   	ret    

00102c57 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102c57:	55                   	push   %ebp
  102c58:	89 e5                	mov    %esp,%ebp
  102c5a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102c5d:	8d 45 14             	lea    0x14(%ebp),%eax
  102c60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c66:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  102c6d:	89 44 24 08          	mov    %eax,0x8(%esp)
  102c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c74:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c78:	8b 45 08             	mov    0x8(%ebp),%eax
  102c7b:	89 04 24             	mov    %eax,(%esp)
  102c7e:	e8 02 00 00 00       	call   102c85 <vprintfmt>
    va_end(ap);
}
  102c83:	c9                   	leave  
  102c84:	c3                   	ret    

00102c85 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102c85:	55                   	push   %ebp
  102c86:	89 e5                	mov    %esp,%ebp
  102c88:	56                   	push   %esi
  102c89:	53                   	push   %ebx
  102c8a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102c8d:	eb 18                	jmp    102ca7 <vprintfmt+0x22>
            if (ch == '\0') {
  102c8f:	85 db                	test   %ebx,%ebx
  102c91:	75 05                	jne    102c98 <vprintfmt+0x13>
                return;
  102c93:	e9 d1 03 00 00       	jmp    103069 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c9f:	89 1c 24             	mov    %ebx,(%esp)
  102ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca5:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102ca7:	8b 45 10             	mov    0x10(%ebp),%eax
  102caa:	8d 50 01             	lea    0x1(%eax),%edx
  102cad:	89 55 10             	mov    %edx,0x10(%ebp)
  102cb0:	0f b6 00             	movzbl (%eax),%eax
  102cb3:	0f b6 d8             	movzbl %al,%ebx
  102cb6:	83 fb 25             	cmp    $0x25,%ebx
  102cb9:	75 d4                	jne    102c8f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102cbb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102cbf:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102cc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cc9:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ccc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102cd3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cd6:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102cd9:	8b 45 10             	mov    0x10(%ebp),%eax
  102cdc:	8d 50 01             	lea    0x1(%eax),%edx
  102cdf:	89 55 10             	mov    %edx,0x10(%ebp)
  102ce2:	0f b6 00             	movzbl (%eax),%eax
  102ce5:	0f b6 d8             	movzbl %al,%ebx
  102ce8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102ceb:	83 f8 55             	cmp    $0x55,%eax
  102cee:	0f 87 44 03 00 00    	ja     103038 <vprintfmt+0x3b3>
  102cf4:	8b 04 85 d4 3d 10 00 	mov    0x103dd4(,%eax,4),%eax
  102cfb:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102cfd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d01:	eb d6                	jmp    102cd9 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d03:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d07:	eb d0                	jmp    102cd9 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d09:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d13:	89 d0                	mov    %edx,%eax
  102d15:	c1 e0 02             	shl    $0x2,%eax
  102d18:	01 d0                	add    %edx,%eax
  102d1a:	01 c0                	add    %eax,%eax
  102d1c:	01 d8                	add    %ebx,%eax
  102d1e:	83 e8 30             	sub    $0x30,%eax
  102d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d24:	8b 45 10             	mov    0x10(%ebp),%eax
  102d27:	0f b6 00             	movzbl (%eax),%eax
  102d2a:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d2d:	83 fb 2f             	cmp    $0x2f,%ebx
  102d30:	7e 0b                	jle    102d3d <vprintfmt+0xb8>
  102d32:	83 fb 39             	cmp    $0x39,%ebx
  102d35:	7f 06                	jg     102d3d <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d37:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102d3b:	eb d3                	jmp    102d10 <vprintfmt+0x8b>
            goto process_precision;
  102d3d:	eb 33                	jmp    102d72 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102d3f:	8b 45 14             	mov    0x14(%ebp),%eax
  102d42:	8d 50 04             	lea    0x4(%eax),%edx
  102d45:	89 55 14             	mov    %edx,0x14(%ebp)
  102d48:	8b 00                	mov    (%eax),%eax
  102d4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102d4d:	eb 23                	jmp    102d72 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102d4f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d53:	79 0c                	jns    102d61 <vprintfmt+0xdc>
                width = 0;
  102d55:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102d5c:	e9 78 ff ff ff       	jmp    102cd9 <vprintfmt+0x54>
  102d61:	e9 73 ff ff ff       	jmp    102cd9 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102d66:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102d6d:	e9 67 ff ff ff       	jmp    102cd9 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102d72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d76:	79 12                	jns    102d8a <vprintfmt+0x105>
                width = precision, precision = -1;
  102d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d7b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d7e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102d85:	e9 4f ff ff ff       	jmp    102cd9 <vprintfmt+0x54>
  102d8a:	e9 4a ff ff ff       	jmp    102cd9 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102d8f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102d93:	e9 41 ff ff ff       	jmp    102cd9 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102d98:	8b 45 14             	mov    0x14(%ebp),%eax
  102d9b:	8d 50 04             	lea    0x4(%eax),%edx
  102d9e:	89 55 14             	mov    %edx,0x14(%ebp)
  102da1:	8b 00                	mov    (%eax),%eax
  102da3:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da6:	89 54 24 04          	mov    %edx,0x4(%esp)
  102daa:	89 04 24             	mov    %eax,(%esp)
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	ff d0                	call   *%eax
            break;
  102db2:	e9 ac 02 00 00       	jmp    103063 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102db7:	8b 45 14             	mov    0x14(%ebp),%eax
  102dba:	8d 50 04             	lea    0x4(%eax),%edx
  102dbd:	89 55 14             	mov    %edx,0x14(%ebp)
  102dc0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102dc2:	85 db                	test   %ebx,%ebx
  102dc4:	79 02                	jns    102dc8 <vprintfmt+0x143>
                err = -err;
  102dc6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102dc8:	83 fb 06             	cmp    $0x6,%ebx
  102dcb:	7f 0b                	jg     102dd8 <vprintfmt+0x153>
  102dcd:	8b 34 9d 94 3d 10 00 	mov    0x103d94(,%ebx,4),%esi
  102dd4:	85 f6                	test   %esi,%esi
  102dd6:	75 23                	jne    102dfb <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102dd8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102ddc:	c7 44 24 08 c1 3d 10 	movl   $0x103dc1,0x8(%esp)
  102de3:	00 
  102de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102de7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102deb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dee:	89 04 24             	mov    %eax,(%esp)
  102df1:	e8 61 fe ff ff       	call   102c57 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102df6:	e9 68 02 00 00       	jmp    103063 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102dfb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102dff:	c7 44 24 08 ca 3d 10 	movl   $0x103dca,0x8(%esp)
  102e06:	00 
  102e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102e11:	89 04 24             	mov    %eax,(%esp)
  102e14:	e8 3e fe ff ff       	call   102c57 <printfmt>
            }
            break;
  102e19:	e9 45 02 00 00       	jmp    103063 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e1e:	8b 45 14             	mov    0x14(%ebp),%eax
  102e21:	8d 50 04             	lea    0x4(%eax),%edx
  102e24:	89 55 14             	mov    %edx,0x14(%ebp)
  102e27:	8b 30                	mov    (%eax),%esi
  102e29:	85 f6                	test   %esi,%esi
  102e2b:	75 05                	jne    102e32 <vprintfmt+0x1ad>
                p = "(null)";
  102e2d:	be cd 3d 10 00       	mov    $0x103dcd,%esi
            }
            if (width > 0 && padc != '-') {
  102e32:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e36:	7e 3e                	jle    102e76 <vprintfmt+0x1f1>
  102e38:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102e3c:	74 38                	je     102e76 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e3e:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102e41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e44:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e48:	89 34 24             	mov    %esi,(%esp)
  102e4b:	e8 15 03 00 00       	call   103165 <strnlen>
  102e50:	29 c3                	sub    %eax,%ebx
  102e52:	89 d8                	mov    %ebx,%eax
  102e54:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102e57:	eb 17                	jmp    102e70 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102e59:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e60:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e64:	89 04 24             	mov    %eax,(%esp)
  102e67:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102e6c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102e70:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e74:	7f e3                	jg     102e59 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102e76:	eb 38                	jmp    102eb0 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102e78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102e7c:	74 1f                	je     102e9d <vprintfmt+0x218>
  102e7e:	83 fb 1f             	cmp    $0x1f,%ebx
  102e81:	7e 05                	jle    102e88 <vprintfmt+0x203>
  102e83:	83 fb 7e             	cmp    $0x7e,%ebx
  102e86:	7e 15                	jle    102e9d <vprintfmt+0x218>
                    putch('?', putdat);
  102e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e8f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102e96:	8b 45 08             	mov    0x8(%ebp),%eax
  102e99:	ff d0                	call   *%eax
  102e9b:	eb 0f                	jmp    102eac <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea4:	89 1c 24             	mov    %ebx,(%esp)
  102ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eaa:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102eac:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102eb0:	89 f0                	mov    %esi,%eax
  102eb2:	8d 70 01             	lea    0x1(%eax),%esi
  102eb5:	0f b6 00             	movzbl (%eax),%eax
  102eb8:	0f be d8             	movsbl %al,%ebx
  102ebb:	85 db                	test   %ebx,%ebx
  102ebd:	74 10                	je     102ecf <vprintfmt+0x24a>
  102ebf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ec3:	78 b3                	js     102e78 <vprintfmt+0x1f3>
  102ec5:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102ec9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ecd:	79 a9                	jns    102e78 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ecf:	eb 17                	jmp    102ee8 <vprintfmt+0x263>
                putch(' ', putdat);
  102ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ed8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102edf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee2:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102ee4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ee8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eec:	7f e3                	jg     102ed1 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102eee:	e9 70 01 00 00       	jmp    103063 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102ef3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102efa:	8d 45 14             	lea    0x14(%ebp),%eax
  102efd:	89 04 24             	mov    %eax,(%esp)
  102f00:	e8 0b fd ff ff       	call   102c10 <getint>
  102f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f08:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f0e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f11:	85 d2                	test   %edx,%edx
  102f13:	79 26                	jns    102f3b <vprintfmt+0x2b6>
                putch('-', putdat);
  102f15:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f18:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f1c:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f23:	8b 45 08             	mov    0x8(%ebp),%eax
  102f26:	ff d0                	call   *%eax
                num = -(long long)num;
  102f28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f2b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f2e:	f7 d8                	neg    %eax
  102f30:	83 d2 00             	adc    $0x0,%edx
  102f33:	f7 da                	neg    %edx
  102f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f38:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102f3b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f42:	e9 a8 00 00 00       	jmp    102fef <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f4e:	8d 45 14             	lea    0x14(%ebp),%eax
  102f51:	89 04 24             	mov    %eax,(%esp)
  102f54:	e8 68 fc ff ff       	call   102bc1 <getuint>
  102f59:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f5c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102f5f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102f66:	e9 84 00 00 00       	jmp    102fef <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f72:	8d 45 14             	lea    0x14(%ebp),%eax
  102f75:	89 04 24             	mov    %eax,(%esp)
  102f78:	e8 44 fc ff ff       	call   102bc1 <getuint>
  102f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f80:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102f83:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102f8a:	eb 63                	jmp    102fef <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f93:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9d:	ff d0                	call   *%eax
            putch('x', putdat);
  102f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa6:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102fad:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb0:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102fb2:	8b 45 14             	mov    0x14(%ebp),%eax
  102fb5:	8d 50 04             	lea    0x4(%eax),%edx
  102fb8:	89 55 14             	mov    %edx,0x14(%ebp)
  102fbb:	8b 00                	mov    (%eax),%eax
  102fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102fc7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102fce:	eb 1f                	jmp    102fef <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102fd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fd7:	8d 45 14             	lea    0x14(%ebp),%eax
  102fda:	89 04 24             	mov    %eax,(%esp)
  102fdd:	e8 df fb ff ff       	call   102bc1 <getuint>
  102fe2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102fe8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102fef:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ff3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff6:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ffa:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ffd:	89 54 24 14          	mov    %edx,0x14(%esp)
  103001:	89 44 24 10          	mov    %eax,0x10(%esp)
  103005:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103008:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10300b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10300f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103013:	8b 45 0c             	mov    0xc(%ebp),%eax
  103016:	89 44 24 04          	mov    %eax,0x4(%esp)
  10301a:	8b 45 08             	mov    0x8(%ebp),%eax
  10301d:	89 04 24             	mov    %eax,(%esp)
  103020:	e8 97 fa ff ff       	call   102abc <printnum>
            break;
  103025:	eb 3c                	jmp    103063 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103027:	8b 45 0c             	mov    0xc(%ebp),%eax
  10302a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10302e:	89 1c 24             	mov    %ebx,(%esp)
  103031:	8b 45 08             	mov    0x8(%ebp),%eax
  103034:	ff d0                	call   *%eax
            break;
  103036:	eb 2b                	jmp    103063 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103038:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303f:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103046:	8b 45 08             	mov    0x8(%ebp),%eax
  103049:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  10304b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  10304f:	eb 04                	jmp    103055 <vprintfmt+0x3d0>
  103051:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103055:	8b 45 10             	mov    0x10(%ebp),%eax
  103058:	83 e8 01             	sub    $0x1,%eax
  10305b:	0f b6 00             	movzbl (%eax),%eax
  10305e:	3c 25                	cmp    $0x25,%al
  103060:	75 ef                	jne    103051 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  103062:	90                   	nop
        }
    }
  103063:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103064:	e9 3e fc ff ff       	jmp    102ca7 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  103069:	83 c4 40             	add    $0x40,%esp
  10306c:	5b                   	pop    %ebx
  10306d:	5e                   	pop    %esi
  10306e:	5d                   	pop    %ebp
  10306f:	c3                   	ret    

00103070 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103070:	55                   	push   %ebp
  103071:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  103073:	8b 45 0c             	mov    0xc(%ebp),%eax
  103076:	8b 40 08             	mov    0x8(%eax),%eax
  103079:	8d 50 01             	lea    0x1(%eax),%edx
  10307c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  103082:	8b 45 0c             	mov    0xc(%ebp),%eax
  103085:	8b 10                	mov    (%eax),%edx
  103087:	8b 45 0c             	mov    0xc(%ebp),%eax
  10308a:	8b 40 04             	mov    0x4(%eax),%eax
  10308d:	39 c2                	cmp    %eax,%edx
  10308f:	73 12                	jae    1030a3 <sprintputch+0x33>
        *b->buf ++ = ch;
  103091:	8b 45 0c             	mov    0xc(%ebp),%eax
  103094:	8b 00                	mov    (%eax),%eax
  103096:	8d 48 01             	lea    0x1(%eax),%ecx
  103099:	8b 55 0c             	mov    0xc(%ebp),%edx
  10309c:	89 0a                	mov    %ecx,(%edx)
  10309e:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a1:	88 10                	mov    %dl,(%eax)
    }
}
  1030a3:	5d                   	pop    %ebp
  1030a4:	c3                   	ret    

001030a5 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1030a5:	55                   	push   %ebp
  1030a6:	89 e5                	mov    %esp,%ebp
  1030a8:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1030ab:	8d 45 14             	lea    0x14(%ebp),%eax
  1030ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1030b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1030bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c9:	89 04 24             	mov    %eax,(%esp)
  1030cc:	e8 08 00 00 00       	call   1030d9 <vsnprintf>
  1030d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1030d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1030d7:	c9                   	leave  
  1030d8:	c3                   	ret    

001030d9 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1030d9:	55                   	push   %ebp
  1030da:	89 e5                	mov    %esp,%ebp
  1030dc:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1030df:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	01 d0                	add    %edx,%eax
  1030f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1030fa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1030fe:	74 0a                	je     10310a <vsnprintf+0x31>
  103100:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103103:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103106:	39 c2                	cmp    %eax,%edx
  103108:	76 07                	jbe    103111 <vsnprintf+0x38>
        return -E_INVAL;
  10310a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10310f:	eb 2a                	jmp    10313b <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103111:	8b 45 14             	mov    0x14(%ebp),%eax
  103114:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103118:	8b 45 10             	mov    0x10(%ebp),%eax
  10311b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10311f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103122:	89 44 24 04          	mov    %eax,0x4(%esp)
  103126:	c7 04 24 70 30 10 00 	movl   $0x103070,(%esp)
  10312d:	e8 53 fb ff ff       	call   102c85 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103132:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103135:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103138:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10313b:	c9                   	leave  
  10313c:	c3                   	ret    

0010313d <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10313d:	55                   	push   %ebp
  10313e:	89 e5                	mov    %esp,%ebp
  103140:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103143:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10314a:	eb 04                	jmp    103150 <strlen+0x13>
        cnt ++;
  10314c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103150:	8b 45 08             	mov    0x8(%ebp),%eax
  103153:	8d 50 01             	lea    0x1(%eax),%edx
  103156:	89 55 08             	mov    %edx,0x8(%ebp)
  103159:	0f b6 00             	movzbl (%eax),%eax
  10315c:	84 c0                	test   %al,%al
  10315e:	75 ec                	jne    10314c <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103163:	c9                   	leave  
  103164:	c3                   	ret    

00103165 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  103165:	55                   	push   %ebp
  103166:	89 e5                	mov    %esp,%ebp
  103168:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10316b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103172:	eb 04                	jmp    103178 <strnlen+0x13>
        cnt ++;
  103174:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10317b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10317e:	73 10                	jae    103190 <strnlen+0x2b>
  103180:	8b 45 08             	mov    0x8(%ebp),%eax
  103183:	8d 50 01             	lea    0x1(%eax),%edx
  103186:	89 55 08             	mov    %edx,0x8(%ebp)
  103189:	0f b6 00             	movzbl (%eax),%eax
  10318c:	84 c0                	test   %al,%al
  10318e:	75 e4                	jne    103174 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103190:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103193:	c9                   	leave  
  103194:	c3                   	ret    

00103195 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  103195:	55                   	push   %ebp
  103196:	89 e5                	mov    %esp,%ebp
  103198:	57                   	push   %edi
  103199:	56                   	push   %esi
  10319a:	83 ec 20             	sub    $0x20,%esp
  10319d:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1031a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031af:	89 d1                	mov    %edx,%ecx
  1031b1:	89 c2                	mov    %eax,%edx
  1031b3:	89 ce                	mov    %ecx,%esi
  1031b5:	89 d7                	mov    %edx,%edi
  1031b7:	ac                   	lods   %ds:(%esi),%al
  1031b8:	aa                   	stos   %al,%es:(%edi)
  1031b9:	84 c0                	test   %al,%al
  1031bb:	75 fa                	jne    1031b7 <strcpy+0x22>
  1031bd:	89 fa                	mov    %edi,%edx
  1031bf:	89 f1                	mov    %esi,%ecx
  1031c1:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1031c4:	89 55 e8             	mov    %edx,-0x18(%ebp)
  1031c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  1031ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1031cd:	83 c4 20             	add    $0x20,%esp
  1031d0:	5e                   	pop    %esi
  1031d1:	5f                   	pop    %edi
  1031d2:	5d                   	pop    %ebp
  1031d3:	c3                   	ret    

001031d4 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1031d4:	55                   	push   %ebp
  1031d5:	89 e5                	mov    %esp,%ebp
  1031d7:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1031da:	8b 45 08             	mov    0x8(%ebp),%eax
  1031dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1031e0:	eb 21                	jmp    103203 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1031e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031e5:	0f b6 10             	movzbl (%eax),%edx
  1031e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031eb:	88 10                	mov    %dl,(%eax)
  1031ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031f0:	0f b6 00             	movzbl (%eax),%eax
  1031f3:	84 c0                	test   %al,%al
  1031f5:	74 04                	je     1031fb <strncpy+0x27>
            src ++;
  1031f7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1031fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1031ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  103203:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103207:	75 d9                	jne    1031e2 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103209:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10320c:	c9                   	leave  
  10320d:	c3                   	ret    

0010320e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10320e:	55                   	push   %ebp
  10320f:	89 e5                	mov    %esp,%ebp
  103211:	57                   	push   %edi
  103212:	56                   	push   %esi
  103213:	83 ec 20             	sub    $0x20,%esp
  103216:	8b 45 08             	mov    0x8(%ebp),%eax
  103219:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10321c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  103222:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103225:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103228:	89 d1                	mov    %edx,%ecx
  10322a:	89 c2                	mov    %eax,%edx
  10322c:	89 ce                	mov    %ecx,%esi
  10322e:	89 d7                	mov    %edx,%edi
  103230:	ac                   	lods   %ds:(%esi),%al
  103231:	ae                   	scas   %es:(%edi),%al
  103232:	75 08                	jne    10323c <strcmp+0x2e>
  103234:	84 c0                	test   %al,%al
  103236:	75 f8                	jne    103230 <strcmp+0x22>
  103238:	31 c0                	xor    %eax,%eax
  10323a:	eb 04                	jmp    103240 <strcmp+0x32>
  10323c:	19 c0                	sbb    %eax,%eax
  10323e:	0c 01                	or     $0x1,%al
  103240:	89 fa                	mov    %edi,%edx
  103242:	89 f1                	mov    %esi,%ecx
  103244:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103247:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10324a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  10324d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103250:	83 c4 20             	add    $0x20,%esp
  103253:	5e                   	pop    %esi
  103254:	5f                   	pop    %edi
  103255:	5d                   	pop    %ebp
  103256:	c3                   	ret    

00103257 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  103257:	55                   	push   %ebp
  103258:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10325a:	eb 0c                	jmp    103268 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  10325c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103260:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103264:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  103268:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10326c:	74 1a                	je     103288 <strncmp+0x31>
  10326e:	8b 45 08             	mov    0x8(%ebp),%eax
  103271:	0f b6 00             	movzbl (%eax),%eax
  103274:	84 c0                	test   %al,%al
  103276:	74 10                	je     103288 <strncmp+0x31>
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	0f b6 10             	movzbl (%eax),%edx
  10327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103281:	0f b6 00             	movzbl (%eax),%eax
  103284:	38 c2                	cmp    %al,%dl
  103286:	74 d4                	je     10325c <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103288:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10328c:	74 18                	je     1032a6 <strncmp+0x4f>
  10328e:	8b 45 08             	mov    0x8(%ebp),%eax
  103291:	0f b6 00             	movzbl (%eax),%eax
  103294:	0f b6 d0             	movzbl %al,%edx
  103297:	8b 45 0c             	mov    0xc(%ebp),%eax
  10329a:	0f b6 00             	movzbl (%eax),%eax
  10329d:	0f b6 c0             	movzbl %al,%eax
  1032a0:	29 c2                	sub    %eax,%edx
  1032a2:	89 d0                	mov    %edx,%eax
  1032a4:	eb 05                	jmp    1032ab <strncmp+0x54>
  1032a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032ab:	5d                   	pop    %ebp
  1032ac:	c3                   	ret    

001032ad <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  1032ad:	55                   	push   %ebp
  1032ae:	89 e5                	mov    %esp,%ebp
  1032b0:	83 ec 04             	sub    $0x4,%esp
  1032b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032b6:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032b9:	eb 14                	jmp    1032cf <strchr+0x22>
        if (*s == c) {
  1032bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1032be:	0f b6 00             	movzbl (%eax),%eax
  1032c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032c4:	75 05                	jne    1032cb <strchr+0x1e>
            return (char *)s;
  1032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c9:	eb 13                	jmp    1032de <strchr+0x31>
        }
        s ++;
  1032cb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1032cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d2:	0f b6 00             	movzbl (%eax),%eax
  1032d5:	84 c0                	test   %al,%al
  1032d7:	75 e2                	jne    1032bb <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1032d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1032de:	c9                   	leave  
  1032df:	c3                   	ret    

001032e0 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1032e0:	55                   	push   %ebp
  1032e1:	89 e5                	mov    %esp,%ebp
  1032e3:	83 ec 04             	sub    $0x4,%esp
  1032e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1032ec:	eb 11                	jmp    1032ff <strfind+0x1f>
        if (*s == c) {
  1032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f1:	0f b6 00             	movzbl (%eax),%eax
  1032f4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1032f7:	75 02                	jne    1032fb <strfind+0x1b>
            break;
  1032f9:	eb 0e                	jmp    103309 <strfind+0x29>
        }
        s ++;
  1032fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1032ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103302:	0f b6 00             	movzbl (%eax),%eax
  103305:	84 c0                	test   %al,%al
  103307:	75 e5                	jne    1032ee <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103309:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10330c:	c9                   	leave  
  10330d:	c3                   	ret    

0010330e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10330e:	55                   	push   %ebp
  10330f:	89 e5                	mov    %esp,%ebp
  103311:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  103314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10331b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103322:	eb 04                	jmp    103328 <strtol+0x1a>
        s ++;
  103324:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103328:	8b 45 08             	mov    0x8(%ebp),%eax
  10332b:	0f b6 00             	movzbl (%eax),%eax
  10332e:	3c 20                	cmp    $0x20,%al
  103330:	74 f2                	je     103324 <strtol+0x16>
  103332:	8b 45 08             	mov    0x8(%ebp),%eax
  103335:	0f b6 00             	movzbl (%eax),%eax
  103338:	3c 09                	cmp    $0x9,%al
  10333a:	74 e8                	je     103324 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  10333c:	8b 45 08             	mov    0x8(%ebp),%eax
  10333f:	0f b6 00             	movzbl (%eax),%eax
  103342:	3c 2b                	cmp    $0x2b,%al
  103344:	75 06                	jne    10334c <strtol+0x3e>
        s ++;
  103346:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10334a:	eb 15                	jmp    103361 <strtol+0x53>
    }
    else if (*s == '-') {
  10334c:	8b 45 08             	mov    0x8(%ebp),%eax
  10334f:	0f b6 00             	movzbl (%eax),%eax
  103352:	3c 2d                	cmp    $0x2d,%al
  103354:	75 0b                	jne    103361 <strtol+0x53>
        s ++, neg = 1;
  103356:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10335a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103365:	74 06                	je     10336d <strtol+0x5f>
  103367:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  10336b:	75 24                	jne    103391 <strtol+0x83>
  10336d:	8b 45 08             	mov    0x8(%ebp),%eax
  103370:	0f b6 00             	movzbl (%eax),%eax
  103373:	3c 30                	cmp    $0x30,%al
  103375:	75 1a                	jne    103391 <strtol+0x83>
  103377:	8b 45 08             	mov    0x8(%ebp),%eax
  10337a:	83 c0 01             	add    $0x1,%eax
  10337d:	0f b6 00             	movzbl (%eax),%eax
  103380:	3c 78                	cmp    $0x78,%al
  103382:	75 0d                	jne    103391 <strtol+0x83>
        s += 2, base = 16;
  103384:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103388:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  10338f:	eb 2a                	jmp    1033bb <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103391:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103395:	75 17                	jne    1033ae <strtol+0xa0>
  103397:	8b 45 08             	mov    0x8(%ebp),%eax
  10339a:	0f b6 00             	movzbl (%eax),%eax
  10339d:	3c 30                	cmp    $0x30,%al
  10339f:	75 0d                	jne    1033ae <strtol+0xa0>
        s ++, base = 8;
  1033a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033a5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  1033ac:	eb 0d                	jmp    1033bb <strtol+0xad>
    }
    else if (base == 0) {
  1033ae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033b2:	75 07                	jne    1033bb <strtol+0xad>
        base = 10;
  1033b4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  1033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1033be:	0f b6 00             	movzbl (%eax),%eax
  1033c1:	3c 2f                	cmp    $0x2f,%al
  1033c3:	7e 1b                	jle    1033e0 <strtol+0xd2>
  1033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c8:	0f b6 00             	movzbl (%eax),%eax
  1033cb:	3c 39                	cmp    $0x39,%al
  1033cd:	7f 11                	jg     1033e0 <strtol+0xd2>
            dig = *s - '0';
  1033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d2:	0f b6 00             	movzbl (%eax),%eax
  1033d5:	0f be c0             	movsbl %al,%eax
  1033d8:	83 e8 30             	sub    $0x30,%eax
  1033db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033de:	eb 48                	jmp    103428 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e3:	0f b6 00             	movzbl (%eax),%eax
  1033e6:	3c 60                	cmp    $0x60,%al
  1033e8:	7e 1b                	jle    103405 <strtol+0xf7>
  1033ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1033ed:	0f b6 00             	movzbl (%eax),%eax
  1033f0:	3c 7a                	cmp    $0x7a,%al
  1033f2:	7f 11                	jg     103405 <strtol+0xf7>
            dig = *s - 'a' + 10;
  1033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033f7:	0f b6 00             	movzbl (%eax),%eax
  1033fa:	0f be c0             	movsbl %al,%eax
  1033fd:	83 e8 57             	sub    $0x57,%eax
  103400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103403:	eb 23                	jmp    103428 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  103405:	8b 45 08             	mov    0x8(%ebp),%eax
  103408:	0f b6 00             	movzbl (%eax),%eax
  10340b:	3c 40                	cmp    $0x40,%al
  10340d:	7e 3d                	jle    10344c <strtol+0x13e>
  10340f:	8b 45 08             	mov    0x8(%ebp),%eax
  103412:	0f b6 00             	movzbl (%eax),%eax
  103415:	3c 5a                	cmp    $0x5a,%al
  103417:	7f 33                	jg     10344c <strtol+0x13e>
            dig = *s - 'A' + 10;
  103419:	8b 45 08             	mov    0x8(%ebp),%eax
  10341c:	0f b6 00             	movzbl (%eax),%eax
  10341f:	0f be c0             	movsbl %al,%eax
  103422:	83 e8 37             	sub    $0x37,%eax
  103425:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10342b:	3b 45 10             	cmp    0x10(%ebp),%eax
  10342e:	7c 02                	jl     103432 <strtol+0x124>
            break;
  103430:	eb 1a                	jmp    10344c <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103432:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103436:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103439:	0f af 45 10          	imul   0x10(%ebp),%eax
  10343d:	89 c2                	mov    %eax,%edx
  10343f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103442:	01 d0                	add    %edx,%eax
  103444:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  103447:	e9 6f ff ff ff       	jmp    1033bb <strtol+0xad>

    if (endptr) {
  10344c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103450:	74 08                	je     10345a <strtol+0x14c>
        *endptr = (char *) s;
  103452:	8b 45 0c             	mov    0xc(%ebp),%eax
  103455:	8b 55 08             	mov    0x8(%ebp),%edx
  103458:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10345a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  10345e:	74 07                	je     103467 <strtol+0x159>
  103460:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103463:	f7 d8                	neg    %eax
  103465:	eb 03                	jmp    10346a <strtol+0x15c>
  103467:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10346a:	c9                   	leave  
  10346b:	c3                   	ret    

0010346c <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  10346c:	55                   	push   %ebp
  10346d:	89 e5                	mov    %esp,%ebp
  10346f:	57                   	push   %edi
  103470:	83 ec 24             	sub    $0x24,%esp
  103473:	8b 45 0c             	mov    0xc(%ebp),%eax
  103476:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103479:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  10347d:	8b 55 08             	mov    0x8(%ebp),%edx
  103480:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103483:	88 45 f7             	mov    %al,-0x9(%ebp)
  103486:	8b 45 10             	mov    0x10(%ebp),%eax
  103489:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  10348c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  10348f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103493:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103496:	89 d7                	mov    %edx,%edi
  103498:	f3 aa                	rep stos %al,%es:(%edi)
  10349a:	89 fa                	mov    %edi,%edx
  10349c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10349f:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  1034a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1034a5:	83 c4 24             	add    $0x24,%esp
  1034a8:	5f                   	pop    %edi
  1034a9:	5d                   	pop    %ebp
  1034aa:	c3                   	ret    

001034ab <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1034ab:	55                   	push   %ebp
  1034ac:	89 e5                	mov    %esp,%ebp
  1034ae:	57                   	push   %edi
  1034af:	56                   	push   %esi
  1034b0:	53                   	push   %ebx
  1034b1:	83 ec 30             	sub    $0x30,%esp
  1034b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1034c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c3:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  1034c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1034cc:	73 42                	jae    103510 <memmove+0x65>
  1034ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1034da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1034dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1034e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034e3:	c1 e8 02             	shr    $0x2,%eax
  1034e6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1034e8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1034eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034ee:	89 d7                	mov    %edx,%edi
  1034f0:	89 c6                	mov    %eax,%esi
  1034f2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1034f4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1034f7:	83 e1 03             	and    $0x3,%ecx
  1034fa:	74 02                	je     1034fe <memmove+0x53>
  1034fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1034fe:	89 f0                	mov    %esi,%eax
  103500:	89 fa                	mov    %edi,%edx
  103502:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  103505:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103508:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10350b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10350e:	eb 36                	jmp    103546 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103510:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103513:	8d 50 ff             	lea    -0x1(%eax),%edx
  103516:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103519:	01 c2                	add    %eax,%edx
  10351b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10351e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103521:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103524:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  103527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10352a:	89 c1                	mov    %eax,%ecx
  10352c:	89 d8                	mov    %ebx,%eax
  10352e:	89 d6                	mov    %edx,%esi
  103530:	89 c7                	mov    %eax,%edi
  103532:	fd                   	std    
  103533:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103535:	fc                   	cld    
  103536:	89 f8                	mov    %edi,%eax
  103538:	89 f2                	mov    %esi,%edx
  10353a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  10353d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103540:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103543:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  103546:	83 c4 30             	add    $0x30,%esp
  103549:	5b                   	pop    %ebx
  10354a:	5e                   	pop    %esi
  10354b:	5f                   	pop    %edi
  10354c:	5d                   	pop    %ebp
  10354d:	c3                   	ret    

0010354e <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  10354e:	55                   	push   %ebp
  10354f:	89 e5                	mov    %esp,%ebp
  103551:	57                   	push   %edi
  103552:	56                   	push   %esi
  103553:	83 ec 20             	sub    $0x20,%esp
  103556:	8b 45 08             	mov    0x8(%ebp),%eax
  103559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10355c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103562:	8b 45 10             	mov    0x10(%ebp),%eax
  103565:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10356b:	c1 e8 02             	shr    $0x2,%eax
  10356e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103573:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103576:	89 d7                	mov    %edx,%edi
  103578:	89 c6                	mov    %eax,%esi
  10357a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10357c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10357f:	83 e1 03             	and    $0x3,%ecx
  103582:	74 02                	je     103586 <memcpy+0x38>
  103584:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103586:	89 f0                	mov    %esi,%eax
  103588:	89 fa                	mov    %edi,%edx
  10358a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10358d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103590:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103593:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103596:	83 c4 20             	add    $0x20,%esp
  103599:	5e                   	pop    %esi
  10359a:	5f                   	pop    %edi
  10359b:	5d                   	pop    %ebp
  10359c:	c3                   	ret    

0010359d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  10359d:	55                   	push   %ebp
  10359e:	89 e5                	mov    %esp,%ebp
  1035a0:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1035a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1035a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1035a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  1035af:	eb 30                	jmp    1035e1 <memcmp+0x44>
        if (*s1 != *s2) {
  1035b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035b4:	0f b6 10             	movzbl (%eax),%edx
  1035b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035ba:	0f b6 00             	movzbl (%eax),%eax
  1035bd:	38 c2                	cmp    %al,%dl
  1035bf:	74 18                	je     1035d9 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1035c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1035c4:	0f b6 00             	movzbl (%eax),%eax
  1035c7:	0f b6 d0             	movzbl %al,%edx
  1035ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1035cd:	0f b6 00             	movzbl (%eax),%eax
  1035d0:	0f b6 c0             	movzbl %al,%eax
  1035d3:	29 c2                	sub    %eax,%edx
  1035d5:	89 d0                	mov    %edx,%eax
  1035d7:	eb 1a                	jmp    1035f3 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1035d9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1035dd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1035e1:	8b 45 10             	mov    0x10(%ebp),%eax
  1035e4:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035e7:	89 55 10             	mov    %edx,0x10(%ebp)
  1035ea:	85 c0                	test   %eax,%eax
  1035ec:	75 c3                	jne    1035b1 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1035ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1035f3:	c9                   	leave  
  1035f4:	c3                   	ret    
