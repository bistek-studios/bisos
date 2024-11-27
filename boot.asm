org 0x7c00
bits 16

jmp 0x0000:start
nop

; macros
%include "macros.asm"

; constants
STAGE2_OFFSET equ 0x7E00 ; where to load the kernel to

; symbols
BOOT_DRIVE:
    db 0x00

; includes
includes:
    %include "disk.asm"

; entry point
start:
    ; setup registers for disk load call
    mov bx, STAGE2_OFFSET ; bx -> destination
    mov dh, 2             ; dh -> num sectors
    mov cl, 0x02 ; start from sector 2
                 ; (as sector 1 is our boot sector)

    ; load sector to disk
    call disk_load

    call STAGE2_OFFSET
    jmp $

; padding to 510 to fit the last two bytes
times (510-($-$$)) db 0
; magic bytes
dw 0xaa55
