; Clear comments














print_hex :
	pusha
	mov cx, 0






hex_loop :
	cmp cx, 4
jge end_hex
	inc cx

	mov ax, bx
	and ax, 0x000f ; everything zero but the last byte

	add al, '0' ; Turn into ascii

	cmp al, 0x39
jle step2 ; if a letter

	add ax, 0x7


step2 :
	mov di, HEX_OUT + 6
	sub di, cx
	mov [di], al

	ror bx, 4
	jmp hex_loop


end_hex :
	mov bx, HEX_OUT
	call print
	popa
	ret


HEX_OUT db "0x0000", NL, 0

