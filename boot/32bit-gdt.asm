; [bits 32] when is a data structure it doesn't really matter

gdt_start: ; don't remove the labels, they're needed to compute sizes and jumps
	dd 0x0
	dd 0x0

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36
gdt_code:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:
	dw 0xffff
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0

gdt_end: ; just for size calculations

; GDT descriptor
gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start

; define some constants for later use
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
