; Clear comments












RETRIES equ 3




disk_read :
	pusha
	xor cx, cx


disk_loop :
	inc cx

	push dx
	push cx

	mov ah, 0x2
	mov al, dh
	mov ch, 0
	mov cl, 0x2
	mov dh, 0


	int 0x13

	pop cx
	pop dx

	jc disk_error

	cmp al, dh
jne sectors_error


disk_done :
	popa
	ret


reset_disk :
	mov ah, 0x0
	int 0x13
	ret


disk_error :
	
	call reset_disk

	cmp cx, RETRIES
jl  disk_loop

	mov bx, DISK_ERROR
	call print
	mov bh, 0
mov bl, ah
	call print_hex

	jmp disk_done


sectors_error :
	
	call reset_disk

	cmp cx, RETRIES
jl  disk_loop

	mov bx, SECTORS_ERROR
	call print

	jmp disk_done


DISK_ERROR: db "Disk read error: ", 0
SECTORS_ERROR: db "Incorrect number of sectors read", 0
