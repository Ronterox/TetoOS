RETRIES equ 3

; load 'dh' sectors from drive 'dl' into ES:BX
; dh given by user, es:bx given by user, es is offset=0x0 so just set bx regularly
; also dl given by user
disk_read:
	pusha

	xor cx, cx
	jmp disk_loop

disk_error:
	cmp cx, RETRIES
	jl disk_loop

	mov bx, DISK_ERROR
	call print

	xor bx, bx
	mov bl, ah
	call print_hex

	jmp disk_done

sectors_error:
	cmp cx, RETRIES
	jl disk_loop

	mov bx, SECTORS_ERROR
	call print

	jmp disk_done

disk_loop:
	inc cx

	push dx ; save because is all modified dl and dh

	mov ah, 0x2
	mov al, dh ; sectors to read 1-128
	mov ch, 0 ; cylinder 0-1023
	mov cl, 0x2 ; sector number 1-17, sector 1 is bootloader (512), rest is fine
	mov dh, 0 ; head 0-15
	; dl is set by user is the drive or floppy code
	; bx is set by user for output address

	int 0x13 ; read disk sectors
	pop dx

	jc disk_error

	cmp al, dh ; target sectors
	jne sectors_error

disk_done:
	popa
	ret

DISK_ERROR: db "Disk read error: ", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
