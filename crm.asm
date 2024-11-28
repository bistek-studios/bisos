clear_interrupt_return_data:
    push ecx
    push edx
    ; Set ECX to the starting address of the return data section (0x700)
    mov     ecx, 0x700
    ; Set EDX to the ending address of the return data section (0x8FF)
    mov     edx, 0x8FF
    ; Loop from 0x700 to 0x8FF
.clear_loop:
    mov     byte [ecx], 0    ; Set byte at ECX to 0
    inc     ecx              ; Increment ECX to the next byte
    cmp     ecx, edx         ; Compare ECX with 0x8FF
    jle     .clear_loop       ; If ECX <= 0x8FF, repeat
    pop edx
    pop ecx
    ret
