[bits 32] ; using 32-bit protected mode

; Dereference pointer

; Set variables
; Or Operation
; Add Operation

; Function call
; Function Params

; Ifs

; Code block

; this is how constants are defined
VIDEO_MEMORY equ 0xB8000
WHITE_ON_BLACK equ 0x0F

print_pm :
	pusha
	mov edi, VIDEO_MEMORY


loop_pm :
	mov ah, WHITE_ON_BLACK
	mov al, [ebx]

	cmp al, 0
je done_pm

	mov [edi], ax
	add edi, 2 ; 2 bytes each vid memory block
	inc ebx

	jmp loop_pm


done_pm :
	popa
	ret

