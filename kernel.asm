org 0x500
bits 16

%include "macros.asm"

jmp _start
nop

db " code "
global _start
_start:
    push 79
    push 24
    push 0x1F
    call clearscreen
    push 0x00000000
    call movecursor
    push msgl_hello_world_len
    push msgl_hello_world
    call putl
    push msgl_how_len
    push msgl_how
    call putl
    jmp typingsimulator2023

typingsimulator2023:
.loop:
    call scanc
    cmp ah, 0x1c
    je .putnewline
    cmp ah, 0x49
    je .uparrow
    cmp ah, 0x0E
    je .backspace
    push ax ; ah khpm
    call putc
    pop ax
.returntoloop:
    jmp .loop
.putnewline:
    push bx
    mov bx, 0x0A
    push bx
    call putc
    pop bx
    mov bx, 0x0D
    push bx
    call putc
    pop bx
    pop bx
    jmp .returntoloop
.uparrow:
    push dx
    call cursorpos
    sub dh, 1
    push dx
    call movecursor
    pop dx
    pop dx
    jmp .returntoloop
.backspace:
    push ax
    mov al, 0x08
    push ax
    call putc
    mov al, 0x20
    push ax
    call putc
    pop ax
    call putc
    pop ax
    pop ax
    jmp .returntoloop

db " includes "
db "    put.asm    "
%include "put.asm"
db "  stdio.asm  "
%include "stdio.asm"

db " symbols/constants "
msgl_hello_world: db "TYPING SIMULATOR 2023", ENDL
msgl_hello_world_len equ $-msgl_hello_world
msgl_how: db "to exit this mode, type, well, good luck...", ENDL
msgl_how_len equ $-msgl_how

db "magic padding"
times 999-($-$$) db 0
yeah: db "end! thanks for wamtching"