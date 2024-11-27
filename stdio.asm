global clearscreen
clearscreen:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x07        ; tells BIOS to scroll down window
    mov al, 0x00        ; clear entire window
    mov bh, [bp+4]        ; white on black
    mov cx, 0x00        ; specifies top left of screen as (0,0)
    mov dh, [bp+6]        ; 18h = 24 rows of chars
    mov dl, [bp+8]        ; 4fh = 79 cols of chars
    int 0x10        ; calls video interrupt

    popa
    mov sp, bp
    pop bp
    ret

global movecursor
movecursor:
    push bp
    mov bp, sp
    pusha

    mov dx, [bp+4]      ; get the argument from the stack. |bp| = 2, |arg| = 2
    mov ah, 0x02        ; set cursor position
    mov bh, 0x00        ; page 0 - doesn't matter, we're not using double-buffering
    int 0x10

    popa
    mov sp, bp
    pop bp
    ret

global scanc
scanc:
    push bp
    mov bp, sp

    mov ah, 00h
    int 16h

    mov sp, bp
    pop bp
    ret

global cursorpos
cursorpos:
    push bp
    mov bp, sp

    push ax
    push bx

    mov ah, 0x03
    mov bh, 0
    int 10h

    pop bx
    pop ax

    mov sp, bp
    pop bp
    ret

global offsetcursor
offsetcursor:
    push bp
    mov bp, sp

    push ax
    push dx

    call cursorpos
    mov ah, [bp+4]
    mov al, [bp+5]
    add dh, ah
    add dl, al
    push dx
    call movecursor
    pop dx
    
    pop dx
    pop ax

    mov sp, bp
    pop bp
    ret

global offsetcursornegative
offsetcursornegative:
    push bp
    mov bp, sp

    push ax
    push dx

    call cursorpos
    mov ah, [bp+4]
    mov al, [bp+5]
    sub dh, ah
    sub dl, al
    push dx
    call movecursor
    pop dx
    
    pop dx
    pop ax

    mov sp, bp
    pop bp
    ret