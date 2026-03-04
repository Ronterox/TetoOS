[org 0x7c00] ; bootloader offset

mov bx, HELLOWORD

call print
call print

jmp $

print:
	pusha

	mov ah, 0xe
	mov al, [bx]

loop:
	cmp al, 0
	je end

	int 0x10

	inc bx
	mov al, [bx]

	jmp loop

end:
	mov al, 0xA
	int 0x10

	mov al, 0xD
	int 0x10

	popa
	ret

; %include "boot_sect_print.asm"
; %include "32bit-gdt.asm"
; %include "32bit-print.asm"
; %include "32bit-switch.asm"

; [bits 32]

; MSG_REAL_MODE db "Started in 16-bit real mode", 0
; MSG_PROT_MODE db "Loaded 32-bit protected mode", 0

HELLOWORD db "Hola Alberto!", 0

; bootsector
times 510-($-$$) db 0
dw 0xaa55
