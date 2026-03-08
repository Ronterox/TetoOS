; receiving the data in 'dx'
; For the examples we'll assume that we're called with dx=0x1234
print_hex:
	pusha
	mov cx, 0

; Strategy: get the last char of 'dx', then convert to ASCII
; Numeric ASCII values: '0' (ASCII 0x30) to '9' (0x39), so just add 0x30 to byte N.
; For alphabetic characters A-F: 'A' (ASCII 0x41) to 'F' (0x46) we'll add 0x40
; Then, move the ASCII byte to the correct position on the resulting string
hex_loop:
	cmp cx, 4
	jge end_hex
	inc cx

	mov ax, bx
	xor dx, dx

	mov si, 0x10 ; 16 hex digits
	div si ; divs ax, result on ax, rem in dx

	mov bx, ax ; update new  0x1234 -> 0x123
	add dx, '0' ; Turn into ascii

	cmp dx, 0x39
	jle step2

	add dx, 0x7

step2:
	mov di, HEX_OUT + 6
	sub di, cx
	mov [di], dl

	jmp hex_loop

end_hex:
	mov bx, HEX_OUT
	call print

	popa
	ret

HEX_OUT db "0x0000", NL, 0

