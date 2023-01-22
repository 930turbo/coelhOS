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

    ; Initialize the memory manager
    call init_memory_manager

    ; Main loop
    loop:
        hlt
        jmp loop

init_memory_manager:
    ; Initialize the memory manager
    mov eax, 0x1000
    mov [free_memory_pointer], eax
    ret

allocate_memory:
    ; Allocate memory
    mov eax, [free_memory_pointer]
    add eax, [ebx]
    mov [free_memory_pointer], eax
    ret

deallocate_memory:
    ; Deallocate memory
    sub eax, [ebx]
    mov [free_memory_pointer], eax
    ret

; Additional functions for memory management

check_free_memory:
    ; Check the amount of free memory
    mov eax, [free_memory_pointer]
    sub eax, [start_of_memory]
    ret

check_used_memory:
    ; Check the amount of used memory
    mov eax, [start_of_memory]
    sub eax, [free_memory_pointer]
    ret

section .bss
    stack_end: resb 0x1000
    free_memory_pointer: resb 4
    start_of_memory: resb 4
