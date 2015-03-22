# 练习一
1. 通过运行make V=和观察makefile文件得到ucore.img的生成过程。

```
UCOREIMG	:= $(call totarget,ucore.img)

$(UCOREIMG): $(kernel) $(bootblock)
	$(V)dd if=/dev/zero of=$@ count=10000
	$(V)dd if=$(bootblock) of=$@ conv=notrunc
	$(V)dd if=$(kernel) of=$@ seek=1 conv=notrunc

$(call create_target,ucore.img)
```
发现ucore.img的生成依赖于kernel和bootblock

2. 通过观察tools/sign.c里面的代码可以得知，主要的特征为：


- 大小为512字节
- 最后两位分别为0x55, 0xAA