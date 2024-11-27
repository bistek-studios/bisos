db " put.asm "
%include "put.asm"

;
; int85h (put)
; arguments: ah - type of put
;            bx - putdata
;            cx - length (if ah is 0x01)
;
db " int85h "
global int85h
int85h:
    cmp ah, 0x00 ; use preferred put mode
    mov ah, [0x500]

    cmp ah, 0x01
    je .nullterminatedstring ; Push a pointer to a string, then call puts

    cmp ah, 0x02
    je .predefinedlengthstring ; Push length and pointer, then call putl

    cmp ah, 0x03
    je .ahbyte ; Push a byte, then call putc

    cmp ah, 0x04
    je .newline ; Print a newline

    jmp .badAH
.nullterminatedstring:
    ; Handle null-terminated string (puts)
    push bx       ; Push the pointer to the string
    call puts     ; Call puts
    add sp, 2     ; Clean up the stack
    jmp .return   ; Return from interrupt
.predefinedlengthstring:
    ; Handle predefined-length string (putl)
    push cx       ; Push length of the string
    push bx       ; Push pointer to the string
    call putl     ; Call putl
    add sp, 4     ; Clean up the stack
    jmp .return   ; Return from interrupt
.ahbyte:
    ; Handle single byte (putc)
    push bx       ; Push the byte
    call putc     ; Call putc
    add sp, 2     ; Clean up the stack
    jmp .return   ; Return from interrupt
.newline:
    ; Print a newline (puts with a predefined string)
    mov si, .crlf ; Load the address of CRLFNULL string
    call puts     ; Call puts
    jmp .return   ; Return from interrupt
.crlf: db CRLFNULL
.msgBadAH: db "bad AH value. needs to be 00-05", CRLFNULL
.badAH:
    mov si,.msgBadAH
    call puts
    cli
    hlt
    jmp .return   ; Return from interrupt
.return:
    mov ah, 0
    iret

;
; int84h (set system data)
; arguments: ah - type
;            dx - data (usually only the lower half is used)
;
db " int84h "
global int84h
int84h:
    cmp ah, 0x00
    je .preferredputmode

    jmp .badAH
.preferredputmode:
    mov [0x500], dl
    iret
.msgBadAH: db "bad AH value. needs to be 00-04", CRLFNULL
.badAH:
    mov si,.msgBadAH
    call puts
    cli
    hlt

    iret