org 0x7c00
bits 16

jmp 0x0000:start
nop

; macros
%include "macros.asm"

; constants
KERNEL_OFFSET equ 0x500 ; where to load the kernel to

; symbols
BOOT_DRIVE:
    db 0x00

; includes
includes:
    %include "disk.asm"

; entry point
start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    ; setup stack
    mov bp, 0x9000
    mov sp, bp

    ; setup registers for disk load call
    mov bx, KERNEL_OFFSET ; bx -> destination
    mov dh, 2             ; dh -> num sectors
    mov cl, 0x02 ; start from sector 2
                 ; (as sector 1 is our boot sector)

    ; load sector to disk
    call disk_load

    call KERNEL_OFFSET
    jmp $

; make use of all our empty space
times (240-($-$$)) db 0
db "wow that's some nice empty space you got there"
; padding to 510 to fit the last two bytes
times (510-($-$$)) db 0
; magic bytes
dw 0xaa55
