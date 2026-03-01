mov ah, 0x0e ; tty mode
mov al, 'H'
int 0x10

mov ah, 0x0e ; tty mode
mov al, 'E'
int 0x10

mov ah, 0x0e ; tty mode
mov al, 'L'
int 0x10

mov ah, 0x0e ; tty mode
mov al, 'L'
int 0x10

mov ah, 0x0e ; tty mode
mov al, 'O'
int 0x10

jmp $

times 510 - ($ - $$) db 0 ; 512 bytes total we need 2 at the end so 510
dw 0xAA55 ; Ocuppies word (2 bytes)
