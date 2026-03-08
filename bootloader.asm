[org 0x7c00] ; bootloader offset

mov bp, 0x8000
mov sp, bp

mov bx, 0x1234
call print_hex

mov bx, 0x9876
call print_hex

mov bx, 0xABCD
call print_hex

mov bx, 0xdede
call print_hex

mov bx, 0xfafa
call print_hex

mov bx, 0x7c00
call print_hex

jmp $

mov bx, MSG_REAL_MODE
call print

call switch_to_pm
jmp $ ; just in case

%define NL 0xA, 0xD ; \n, \r
%include "boot_sect_print_hex.asm"
%include "boot_sect_print.asm"
%include "32bit-gdt.asm"
%include "32bit-print.asm"
%include "32bit-switch.asm"

[bits 32]
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_pm
	jmp $

MSG_REAL_MODE db "Started in 16-bit real mode", NL, 0
MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55
