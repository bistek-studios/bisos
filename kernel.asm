org 0x7E00
bits 16

%include "macros.asm"

jmp _start
nop

; header
bisos_name: db "BISOS"
bisos_version: db "1.x"
bisos_information: db " created by bis "

db " code "
global _start
_start:
    push 79
    push 24
    push 0x02
    call clearscreen
    add sp, 6
    push 0x0000
    call movecursor
    add sp, 2
    push 0x0101
    call offsetcursor
    push msgl_hello_world_len
    push msgl_hello_world
    call putl
    add sp, 4
    call offsetcursor
    push msgl_how_len
    push msgl_how
    call putl
    add sp, 4
    call offsetcursor
    add sp, 2
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
    cmp ah, ")"
    je .bufferkey
    push ax ; ah khpm
    call putc
    pop ax
    push si
    push di
    mov si, buffer
    mov di, [bufferpointer]
    add si, di
    mov [si], al
    add si, 1
    add di, 1
    push ax
    xor ax, ax
    mov [si], al
    pop ax
    mov [bufferpointer], di
    pop di
    pop si
    jmp .returntoloop
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
    mov bx, 0x0100
    push bx
    call offsetcursor
    pop bx
    pop bx
.detectdwords:
    push eax
    push ebx
.exit:
    mov eax, dword [buffer]
    mov ebx, dword [dword_exit]
    cmp eax, ebx
    jne .help
    call escaped
.help:
    mov eax, dword [buffer]
    mov ebx, dword [dword_help]
    cmp eax, ebx
    jne .finishdetectingdwords
    call helpmsg
.finishdetectingdwords:
    pop ebx
    pop eax
.returntoputnewline:
    call clearbuffer
    jmp .returntoloop
.uparrow:
    push dx
    mov dx, 0x0001
    push dx
    call offsetcursornegative
    pop dx
    call cursorpos
    mov dl, 01
    push dx
    call movecursor
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
    push si
    push di
    push ax
    mov ax, 0
    mov si, buffer
    mov di, [bufferpointer]
    sub di, 1
    cmp di, 0
    jl .lessthan0
    jmp .notlessthan0
.lessthan0:
    add di, 1
.notlessthan0:
    add si, di
    mov [si], ah
    mov [bufferpointer], di
    pop ax
    pop di
    pop si
    jmp .returntoloop
.bufferkey:
    push eax
    mov eax, buffer
    push eax
    call puts
    pop eax
    pop eax
    jmp .returntoloop

escaped:
    push 79
    push 24
    push 0x07
    call clearscreen
    add sp, 6
    push 0x0000
    call movecursor
    add sp, 2
    push msg_escaped
    call puts
    add sp, 2
    jmp $

clearbuffer:
    push bp
    mov bp, sp
    push ax
    xor ax, ax
    mov [buffer], al
    mov [bufferpointer], al
    pop ax
    mov sp, bp
    pop bp
    ret

helpmsg:
    push bp
    mov bp, sp
    push msg_help
    call puts
    add sp, 2
    push 0x0100
    call offsetcursor
    add sp, 2
    mov sp, bp
    pop bp
    ret

db " includes "
db "    put.asm    "
%include "put.asm"
db "  stdio.asm  "
%include "stdio.asm"

db " symbols/constants "
msgl_hello_world: db "TYPING SIMULATOR 2023", ENDL
msgl_hello_world_len equ $-msgl_hello_world
msgl_how: db "to exit this mode, well, good luck...", ENDL
msgl_how_len equ $-msgl_how
msg_escaped: db "you have escaped from typing simulator 2023. it was nice meeting you.", CRLFNULL
msg_help: db "well your heart's in the right place. commands are the way to go here", CRLFNULL
dword_exit: db "exit"
dword_help: db "help"

; buffer
buffer:
    EMPTY equ $-buffer
    times 1024-($-buffer) db 0
bufferpointer: dw EMPTY
bufferdecoded: times 2 db 0

db "magic padding"
times 4096-($-$$) db 0