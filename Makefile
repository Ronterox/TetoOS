all: run clean

bootloader.bin: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin -l bootloader.lst || (cat bootloader.lst | rg error -B 5; exit 1)

kernel.o: kernel.c
	gcc -m32 -ffreestanding -fno-pic -c kernel.c -o kernel.o

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

kernel.bin: kernel_entry.o kernel.o
	# kernel main at 0x1000
	ld -m elf_i386 -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

os-image.bin: bootloader.bin kernel.bin
	cat bootloader.bin kernel.bin > os-image.bin

run: os-image.bin
	qemu-system-i386 os-image.bin

clean:
	rm -f *.bin *.lst *.o
