
print:
	pusha

loop:
	mov al, [bx]
	cmp al, 0
	je end

	mov ah, 0xE ; Is not ensured ah will be kept the same after int 0x10
	int 0x10

	inc bx
	jmp loop

end:
	popa
	ret
