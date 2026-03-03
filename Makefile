all: run clean

bootloader.bin: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin -l bootloader.lst || (cat bootloader.lst | rg error -B 5; exit 1)

run: bootloader.bin
	qemu-system-i386 bootloader.bin

clean:
	rm -f bootloader.bin bootloader.lst
