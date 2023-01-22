section .text
    global _start

_start:
    ; Set up the stack
    mov esp, stack_end
    sub esp, 0x1000

    ; Set up the segment registers
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Initialize the GDT
    lgdt [gdt_descriptor]

    ; Enable protected mode
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax

    ; Jump to the code segment
    jmp 0x8:flush

flush:
    ; Flush the instruction cache
    mov eax, cr3
    mov cr3, eax

; GDT
gdt:
    ; Null descriptor
    dq 0x0
    ; Code segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0
    ; Data segment descriptor
    dw 0xFFFF
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_descriptor:
    dw gdt_limit - gdt
    dd gdt

section .bss
    stack_end: resb 0x1000
