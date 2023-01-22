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

    ; Initialize the process manager
    call init_process_manager

    ; Main loop
    loop:
        ; Check for new processes to schedule
        call schedule_processes
        ; Execute the current process
        call execute_process
        jmp loop

init_process_manager:
    ; Initialize the process manager
    mov eax, 0x1000
    mov [process_pointer], eax
    ret

schedule_processes:
    ; Check for new processes to schedule
    mov eax, [process_pointer]
    cmp byte [eax], 0
    je no_new_process
    ; A new process is ready, schedule it
    mov [current_process], eax
    add eax, [eax]
    mov [process_pointer], eax
    ret

execute_process:
    ; Execute the current process
    mov eax, [current_process]
    call [eax]
    ret

create_process:
    ; Create a new process
    mov eax, [process_pointer]
    mov [eax], ebx
    add eax, 4
    mov [eax], ebx
    mov [process_pointer], eax
    ret

section .bss
    stack_end: resb 0x1000
    process_pointer: resb 4
    current_process: resb 4
