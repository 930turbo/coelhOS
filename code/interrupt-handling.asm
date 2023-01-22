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

    ; Initialize the interrupt manager
    call init_interrupt_manager

    ; Main loop
    loop:
        hlt
        jmp loop

init_interrupt_manager:
    ; Initialize the interrupt manager
    mov eax, 0x1000
    mov [interrupt_pointer], eax
    ret

handle_interrupt:
    ; Handle an interrupt
    mov eax, [interrupt_pointer]
    cmp byte [eax], 0
    je no_interrupt
    ; An interrupt is pending, handle it
    call [eax]
    add eax, [eax]
    mov [interrupt_pointer], eax
    ret

register_interrupt_handler:
    ; Register an interrupt handler
    mov eax, [interrupt_pointer]
    mov [eax], ebx
    add eax, 4
    mov [eax], ebx
    mov [interrupt_pointer], eax
    ret

section .bss
    stack_end: resb 0x1000
    interrupt_pointer: resb 4
