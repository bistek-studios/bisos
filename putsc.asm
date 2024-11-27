db " putc "
putc:
    push bp
    mov bp, sp

    push ax
    push bx

    mov bx, 0
    mov al, [bp+4]
    mov ah, 0x0E
    int 10h

    pop bx
    pop ax

    mov sp, bp
    pop bp
    ret

db " puts "
puts:
    push bp
    mov bp, sp
    pusha
    mov si, [bp+4]
    mov bx, 0
    mov ah, 0x0e
.char:
    mov al, [si]        ; get the current char from our pointer position
    add si, 1       ; keep incrementing si until we see a null char
    or al, 0x00
    je .return          ; end if the string is done
    push ax
    call putc
    pop ax
    jmp .char       ; keep looping
.return:
    popa
    mov sp, bp
    pop bp
    ret