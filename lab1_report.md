# 练习一
## 1. 通过运行make V=和观察makefile文件得到ucore.img的生成过程。

```
UCOREIMG	:= $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)
```
发现ucore.img的生成依赖于kernel和bootblock。
##### 对于kernel的生成依赖于如下代码
```
kernel = $(call totarget,kernel)

$(kernel): tools/kernel.ld

$(kernel): $(KOBJS)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -T tools/kernel.ld -o $@ $(KOBJS)
	@$(OBJDUMP) -S $@ > $(call asmfile,kernel)
	@$(OBJDUMP) -t $@ | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,kernel)
```

其中kernel的生成依赖于kernel.ld以及$(KOBJS)

而$(KOBJS)依赖于语句
```
KOBJS	= $(call read_packet,kernel libs)
```
其中kernel和libs又分别来自于
```
$(call add_files_cc,$(call listf_cc,$(KSRCDIR)),kernel,$(KCFLAGS))
$(call add_files_cc,$(call listf_cc,$(LIBDIR)),libs,)
```
这两条语句找到kern和libs中的.c文件并进行编译生成.o，主要有
```
init.o readline.o stdio.o kdebug.o
kmonitor.o panic.o clock.o console.o intr.o picirq.o trap.o
trapentry.o vectors.o pmm.o  printfmt.o string.o
```
它们的生成过程比较类似，举init.o的生成为例。会调用如下代码
```
gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 \
	-gstabs -nostdinc  -fno-stack-protector \
	-Ilibs/ -Ikern/debug/ -Ikern/driver/ \
	-Ikern/trap/ -Ikern/mm/ -c kern/init/init.c \
	-o obj/kern/init/init.o
```
得到所有的.o文件后，通过ld命令得到最终的kernel.o

##### 对于bootblock的生成依赖于如下代码
```
bootfiles = $(call listf_cc,boot)
$(foreach f,$(bootfiles),$(call cc_compile,$(f),$(CC),$(CFLAGS) -Os -nostdinc))

bootblock = $(call totarget,bootblock)

$(bootblock): $(call toobj,$(bootfiles)) | $(call totarget,sign)
	@echo + ld $@
	$(V)$(LD) $(LDFLAGS) -N -e start -Ttext 0x7C00 $^ -o $(call toobj,bootblock)
	@$(OBJDUMP) -S $(call objfile,bootblock) > $(call asmfile,bootblock)
	@$(OBJDUMP) -t $(call objfile,bootblock) | $(SED) '1,/SYMBOL TABLE/d; s/ .* / /; /^$$/d' > $(call symfile,bootblock)
	@$(OBJCOPY) -S -O binary $(call objfile,bootblock) $(call outfile,bootblock)
	@$(call totarget,sign) $(call outfile,bootblock) $(bootblock)

$(call create_target,bootblock)
```

bootblack的生成需要bootasm.o bootmain.o和sign，

分别对它们进行编译，得到bootblock。
## 2. 通过观察tools/sign.c里面的代码可以得知，主要的特征为：


- 大小为512字节
- 最后两位分别为0x55, 0xAA
