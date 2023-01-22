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

    ; Initialize the process table
    mov eax, 0x1000
    mov [process_table], eax

    ; Create the first process
    call create_process

    ; Switch to the first process
    call switch_to_process

    ; Halt the system
    hlt

create_process:
    ; Allocate memory for the process
    mov eax, 0x1000
    call allocate_memory

    ; Initialize the process descriptor
    mov eax, [process_table]
    mov [eax], esp
    add eax, 4
    mov [eax], 0x1000
    add eax, 4
    mov [eax], 0x1 ; running state
    add eax, 4
    mov [eax], 0x0 ; not waiting
    add eax, 4
    mov [eax], 0x0 ; no parent
    add eax, 4
    mov [eax], 0x0 ; no children
    add eax, 4
    mov [eax], 0x0 ; no file descriptor
    add eax, 4
    mov [eax], 0x0 ; no message queue

    ; Update the process table pointer
    add dword [process_table], 0x20
    ret

switch_to_process:
    ; Save the current process state
    mov eax, [current_process]
    mov ebx, [eax]
    mov [esp], ebx

    ; Find the next running process
    mov eax, [process_table]
    mov ebx, [eax]
    mov [current_process], ebx
    add eax, 4
    mov ebx, [eax]
    cmp ebx, 0x1
    je found
    add eax, 0x20
    jmp switch_to_process

found:
    ; Load the next process state
    mov ebx, [eax]
    mov [esp], ebx
    ret

allocate_memory:
    ; Allocate memory using BIOS Interrupt 0x15
    mov ax, 0x9000
    mov bx, eax
    int 0x15
    ret

section .bss
    stack_end: resb 0x1000
    process_table: resb 0x1000
    current_process: resb 4
