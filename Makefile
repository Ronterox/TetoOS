C_SOURCES = $(wildcard kernel/*.c)
OBJS = ${C_SOURCES:.c=.o}

CC = gcc
ASM = nasm
LINKER = ld -m elf_i386
GDB = gdb
QEMU = qemu-system-i386

CFLAGS = -masm=intel -g -m32 -ffreestanding -fno-pic

# $^ prerequisites
# $< first dependency
# $@ target

run-os: run clean
run-debug: debug clean

# first rule runs by default
os-image.bin: boot/bootloader.bin kernel.bin
	cat $^ > $@

run: os-image.bin
	${QEMU} $<

kernel.bin: boot/kernel_entry.o ${OBJS}
	# kernel main at 0x1000
	${LINKER} -o $@ -T linker.ld $^ --oformat binary

# debugging purposes
kernel.elf: boot/kernel_entry.o ${OBJS}
	${LINKER} -o $@ -T linker.ld $^

# connection to qemu and load our kernel-object file with symbols
debug: os-image.bin kernel.elf
	${QEMU} -s $< &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

%.o: %.c
	${CC} ${CFLAGS} -c $^ -o $@

%.o: %.asm
	${ASM} $^ -f elf -l $<.lst -o $@ || (cat $<.lst | rg error -B 5; exit 1)

%.bin: %.asm
	${ASM} $^ -f bin -l $<.lst -o $@ || (cat $<.lst | rg error -B 5; exit 1)

clean:
	rm -f *.bin *.dis *.o *.elf *.lst
	rm -f boot/*.bin boot/*.lst boot/*.o kernel/*.o drivers/*.o
