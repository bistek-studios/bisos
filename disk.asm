
disk_load:
    pusha

    mov ah, 0x02 ; read mode
    

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt

    popa
    ret


disk_reset:
    pusha

    mov ah, 0x00 ; reset mode
    

    ; dl = drive number is set as input to disk_load
    ; es:bx = buffer pointer is set as input as well

    int 0x13      ; BIOS interrupt

    popa
    ret