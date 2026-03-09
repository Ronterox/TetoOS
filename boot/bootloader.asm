[org 0x7c00] ; bootloader offset

KERNEL_OFFSET equ 0x1000

mov [BOOT_DRIVE], dl
mov bp, 0x8000
mov sp, bp

mov bx, [BOOT_DRIVE]
call print_hex

mov bx, MSG_REAL_MODE
call print

call load_kernel
call switch_to_pm
jmp $ ; just in case

%define NL 0xA, 0xD ; \n, \r
%include "boot/boot_sect_print_hex.asm"
%include "boot/boot_sect_print.asm"
%include "boot/boot_sect_disk.asm"
%include "boot/32bit-gdt.asm"
%include "boot/32bit-print.asm"
%include "boot/32bit-switch.asm"

[bits 16]
load_kernel:
	mov bx, MSG_KERNEL_LOAD
	call print

	mov bx, KERNEL_OFFSET
	mov dh, 2
	mov dl, [BOOT_DRIVE]
	call disk_read

	ret

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_pm
	call KERNEL_OFFSET ; this gives control to the kernel
	jmp $

MSG_REAL_MODE db "Started in 16-bit real mode", NL, 0
MSG_KERNEL_LOAD db "Loading kernel into memory...", NL, 0

MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

BOOT_DRIVE db 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55
