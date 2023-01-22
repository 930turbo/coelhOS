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

    ; Initialize the file system
    call init_file_system

    ; Main loop
    loop:
        hlt
        jmp loop

init_file_system:
    ; Initialize the file system
    mov eax, 0x1000
    mov [free_space_pointer], eax
    ret

create_file:
    ; Create a new file
    mov eax, [free_space_pointer]
    add eax, [ebx]
    mov [free_space_pointer], eax
    mov [eax], ebx    ; store the file name at the start of the file
    ret

open_file:
    ; Open an existing file
    mov eax, [start_of_files]
    mov ebx, [eax]
    cmp ebx, [edx]
    je found
    add eax, [ebx]
    jmp open_file

found:
    ; File found, return the address
    mov eax, ebx
    ret

delete_file:
    ; Delete an existing file
    mov eax, [start_of_files]
    mov ebx, [eax]
    cmp ebx, [edx]
    je found_delete
    add eax, [ebx]
    jmp delete_file

found_delete:
    ; File found, mark it as deleted
    mov byte [eax], 0
    ret

section .bss
    stack_end: resb 0x1000
    free_space_pointer: resb 4
    start_of_files: resb 4
