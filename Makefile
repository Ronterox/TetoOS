all: run clean

# $^ prerequisites
# $< first dependency
# $@ target

bootloader.bin: bootloader.asm
	nasm $^ -f bin -o $@ -l $<.lst || (cat $<.lst | rg error -B 5; exit 1)

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pic -c $^ -o $@

kernel_entry.o: kernel_entry.asm
	nasm $^ -f elf -o $@

kernel.bin: kernel_entry.o kernel.o
	# kernel main at 0x1000
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

os-image.bin: bootloader.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	qemu-system-i386 $<

clean:
	rm -f *.bin *.lst *.o
