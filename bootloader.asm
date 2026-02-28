; Simple 16-bit x86 BIOS bootloader that prints "Hello World"
; Assemble with: nasm -f bin bootloader.asm -o bootloader.bin

org 0x7C00          ; BIOS loads bootloader at this address

start:
    xor ax, ax      ; Set up DS to 0
    mov ds, ax
    mov si, message ; Load message address

print_char:
    lodsb           ; Load next character into AL
    or al, al       ; Check if null terminator
    jz halt         ; If zero, halt
    mov ah, 0x0E    ; BIOS teletype function
    int 0x10        ; Call BIOS video interrupt
    jmp print_char  ; Repeat for next character

halt:
    jmp halt        ; Infinite loop

message: db "Hello World!", 0

; Boot signature (must be at end of 512 bytes)
times 510 - ($ - $$) db 0
dw 0xAA55
