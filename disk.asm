
disk_load:
    pusha

    mov ah, 0x02 ; read mode
    mov al, dh   ; read dh number of sectors
    mov ch, 0x00 ; cylinder 0
    mov dh, 0x00 ; head 0

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt

    popa
    ret