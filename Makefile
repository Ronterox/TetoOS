all: run clean

KERNEL_OFFSET = 0x1000

CC = gcc
ASM = nasm
LINKER = ld -m elf_i386
GDB = gdb
QEMU = qemu-system-i386

CFLAGS = -g -m32 -ffreestanding -fno-pic

# $^ prerequisites
# $< first dependency
# $@ target

# first rule runs by default
os-image.bin: bootloader.bin kernel.bin
	cat $^ > $@

bootloader.bin: bootloader.asm
	${ASM} $^ -f bin -o $@ -l $<.lst || (cat $<.lst | rg error -B 5; exit 1)

kernel.o: kernel.c
	${CC} ${CFLAGS} -c $^ -o $@

kernel_entry.o: kernel_entry.asm
	${ASM} $^ -f elf -o $@

kernel.bin: kernel_entry.o kernel.o
	# kernel main at 0x1000
	${LINKER} -o $@ -Ttext ${KERNEL_OFFSET} $^ --oformat binary

# debugging purposes
kernel.elf: kernel_entry.o kernel.o
	${LINKER} -o $@ -Ttext ${KERNEL_OFFSET} $^

# connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	${QEMU} -s $< &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

run: os-image.bin
	${QEMU} $<

run-debug: debug clean

clean:
	rm -f *.bin *.lst *.o
