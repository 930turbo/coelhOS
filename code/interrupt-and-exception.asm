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

    ; Initialize the IDT
    lidt [idt_descriptor]

    ; Enable interrupts
    sti

    ; Main loop
    loop:
        hlt
        jmp loop

; Interrupt Service Routines (ISRs)

isr_0:
    ; Handle divide by zero exception
    pusha
    mov eax, [esp + 0x14]
    mov [current_exception], eax
    call handle_exception
    popa
    iretd

isr_1:
    ; Handle debug exception
    pusha
    mov eax, [esp + 0x14]
    mov [current_exception], eax
    call handle_exception
    popa
    iretd

; and so on for other ISRs

handle_exception:
    ; Handle the current exception
    mov eax, [current_exception]
    cmp eax, 0
    je divide_by_zero
    cmp eax, 1
    je debug
    jmp default_handler

divide_by_zero:
    ; Handle divide by zero exception
    mov eax, "Divide by zero exception"
    call print_exception
    jmp end

debug:
    ; Handle debug exception
    mov eax, "Debug exception"
    call print_exception
    jmp end

default_handler:
    ; Handle unhandled exception
    mov eax, "Unhandled exception"
    call print_exception

end:
    ; End the handling of the exception
    ret

print_exception:
    ; Print the exception message
    pusha
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 0x80
    popa
    ret

section .bss
    stack_end: resb 0x1000
    idt: resb 256*8
    idt_descriptor: resb 6
    current_exception: resb 4
