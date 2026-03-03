#!/usr/bin/env bash

filepath=$1
version=$2

echo "$filepath -$version"

gcc -m32 -ffreestanding -fno-pic -c "$1" -o object.o $version

objdump -d -M intel object.o

ld -m elf_i386 -o object.bin -Ttext 0x0 --oformat binary object.o

ndisasm -a -u object.bin | rg -v '\s+0000\s+'

rm -f object.o object.bin

