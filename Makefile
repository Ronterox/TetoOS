all: run clean

bootloader.bin: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin

run: bootloader.bin
	qemu-system-i386 bootloader.bin

clean:
	rm -f bootloader.bin
