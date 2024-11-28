org 0x7E00
bits 16

jmp _start
nop

%include "macros.asm"

; header
bisos_name: db "BISOS bootloader stage 2"
bisos_version: db "1.x"
bisos_information: db " created by bis "
bisos_disk_num: db 0

db " code "
global _start
_start:
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov bp, 0x9000
    mov sp, bp
    call setupinterrupts
    push ax
    push dx
    mov ah, 0x00
    mov dl, 0x01
    int 0x84
    pop dx
    pop ax
    
    mov [bisos_disk_num], dl

    push ax
    push bx
    mov ah, 0
    mov bx, msg_loading
    int 85h
    pop bx
    pop ax

    ; setup registers for disk load call
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 4             ; dh -> num sectors
    mov dl, [bisos_disk_num]
    mov cl, 0x05 ; start from sector 4
                 ; (as sectors 1-4 are our bootloader)

    ; load sector to disk
    call disk_load

    jmp KERNEL_OFFSET

    mov ah, 0
    mov bx, msg_failure
    int 0x85
    jmp $

db " includes "
db " interrupts.asm "
%include "interrupts.asm"
db " disk.asm "
%include "disk.asm"

db " symbols/constants "
msg_hello_world: db "hello world", CRLFNULL
msg_failure: db "failed to load kernel into memory", CRLFNULL
msg_loading: db "loading kernel", CRLFNULL
KERNEL_OFFSET equ 0x8400

times 1536-($-$$) db 0