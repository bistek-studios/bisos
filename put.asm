%include "putsc.asm"

db " putcfrommem "
putcfrommem:
    push bp
    mov bp, sp

    push eax
    push ebx
    push si

    mov si, [bp+4]

    mov al, [si]
    mov ah, 0x0E
    mov bx, 0
    int 10h

    pop si
    pop ebx
    pop eax

    mov sp, bp
    pop bp
    ret

db " putcfromax "
putcfromax:
    push bp
    mov bp, sp

    push bx

    mov bx, 0
    mov ah, 0x0E
    int 10h

    pop bx

    mov sp, bp
    pop bp
    ret

db " putd "
putd:
    push bp
    mov bp, sp
    pusha
    mov al, [bp+4]
    push ax
    call putc
    pop ax
    mov al, [bp+6]
    push ax
    call putc
    pop ax
.return:
    popa
    mov sp, bp
    pop bp
    ret

db " putl "
putl:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]
    mov bx, [bp+6]
    mov cx, 0
.loop:
    mov al, [si]
    add si, 1
    push ax
    call putc
    pop ax
    add cx, 1
    cmp cx, bx
    jne .loop
.return:
    popa
    mov sp, bp
    pop bp
    ret