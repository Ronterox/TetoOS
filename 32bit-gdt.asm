gdt_start: ; don't remove the labels, they're needed to compute sizes and jumps

; GDT for code segment. base = 0x00000000, length = 0xfffff
; for flags, refer to os-dev.pdf document, page 36
gdt_code:

; GDT for data segment. base and length identical to code segment
; some flags changed, again, refer to os-dev.pdf
gdt_data:

gdt_end:

; GDT descriptor
gdt_descriptor:

; define some constants for later use
CODE_SEG
DATA_SEG
