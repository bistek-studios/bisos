org 0x7c00
bits 16

jmp 0x0000:start

; macros
%include "macros.asm"

; entry point
start:
    ; setup registers for disk load call
    mov bx, STAGE2_OFFSET ; bx -> destination
    mov al, 3             ; dh -> num sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0
    mov cl, 0x02 ; start from sector 2
                 ; (as sectors 1 is our boot sector)

    ; load sector to disk
    call disk_load

    jmp STAGE2_OFFSET

; includes
includes:
    %include "disk.asm"

; constants
STAGE2_OFFSET equ 0x7E00 ; where to load the kernel to

; symbols
BOOT_DRIVE: db 0

; padding to 510 to fit the last two bytes
times (510-($-$$)) db 0
; magic bytes
dw 0xaa55
