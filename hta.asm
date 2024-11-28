; Function to convert a byte to "0xHH" format (where HH is the byte)
hex_to_ascii:
    push dx
    mov dx, ax
    push ax             ; Save AX
    push bx             ; Save BX
    push si             ; Save SI
    
    mov si, di       ; Point SI to the buffer's pointer stored in di

    ; Write "0x" to the buffer
    mov byte [si], '0'  ; Store '0' at buffer[si]
    inc si              ; Increment SI
    mov byte [si], 'x'  ; Store 'x' at buffer[si]
    inc si              ; Increment SI

    ; Convert high nibble to ASCII (first digit)
    mov al, dl      ; Load the byte from the stack into AL (correct address for the first argument)
    shr al, 4           ; Shift AL to the right by 4 bits to get the high nibble
    call byte_to_ascii  ; Convert high nibble to ASCII and store in AL
    mov [si], al        ; Store the ASCII character in the buffer
    inc si              ; Increment SI to point to the next buffer location

    ; Convert low nibble to ASCII (second digit)
    mov al, dl      ; Reload the original byte from the stack
    and al, 0x0F        ; Mask the high nibble, leaving the low nibble
    call byte_to_ascii  ; Convert low nibble to ASCII and store in AL
    mov [si], al        ; Store the ASCII character in the buffer
    inc si              ; Increment SI to point to the next buffer location

    ; Null-terminate the string
    mov byte [si], 0    ; Null-terminate the string

    pop si              ; Restore SI
    pop bx              ; Restore BX
    pop ax              ; Restore AX
    pop dx
    ret

; Helper function to convert a nibble to ASCII
byte_to_ascii:
    cmp al, 9           ; Check if the nibble is <= 9
    jbe .low_digit      ; If yes, it's a digit ('0' to '9')

    ; Convert to character 'A' to 'F' for 10 to 15
    add al, 'A' - 10     ; Convert 10-15 to 'A'-'F'
    ret

.low_digit:
    add al, '0'         ; Convert 0-9 to '0'-'9'
    ret
