[bits 32]
[extern main] ; linkable not compiled on here
call main ; call, the linker will know where it's placed in memory
jmp $
