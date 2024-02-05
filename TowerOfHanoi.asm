section .bss
    buffer resb 16  ; buffer size for receiving input
section .text                         

global _start   ; Start of the code

_start:   ; Start of the program

    ; Main function
    push ebp   ; Save the value of the ebp register on the stack
    mov ebp, esp   ; Set up a new frame pointer (ebp) pointing to the top of the stack

    ; Write messages to the user
    mov edx, len_title   ; Length of the title message
    mov ecx, title_msg   ; Title message
    mov ebx, 1   ; File descriptor for standard output (stdout)
    mov eax, 4   ; System call number indicating a write operation
    int 128  ; Software interrupt to the kernel

    mov edx, len_user   ; Length of the user instruction message
    mov ecx, user_msg   ; User instruction message
    mov ebx, 1   ; File descriptor for standard output (stdout)
    mov eax, 4   ; System call number for write
    int 128  ; Software interrupt

    ; Read user input
    mov eax, 3   ; System call number for read
    mov ebx, 0   ; File descriptor for standard input (stdin)
    lea ecx, [buffer]   ; Address of the input buffer
    mov edx, 16   ; Maximum number of characters to read
    int 128   ; Software interrupt

    ; Convert the string to a number
    xor eax, eax   ; Clear the eax register
    lea esi, [buffer]   ; Address of the input buffer

convert:
    movzx edx, byte [esi]   ; Convert a byte to an integer value
    cmp dl, 0x0A   ; Check if it is a newline character
    je done   ; If yes, exit the loop
    cmp dl, '9'   ; Check if the character is greater than '9' (not a number)
    jg _start   ; If yes, go back to the start of the code
    imul eax, 10   ; Multiply the current number by 10
    sub edx, '0'   ; Convert the ASCII character to a numeric value
    add eax, edx   ; Add the numeric value to the accumulator
    inc esi   ; Move to the next character
    jmp convert   ; Jump back to the beginning of the loop

done:
    ; Initial setup for the Tower of Hanoi game
    push dword 2   ; Auxiliary Tower
    push dword 3   ; Destination Tower
    push dword 1   ; Source Tower
    push eax   ; Number of disks
    
    call hanoi   ; Call the recursive Hanoi function

    ; Generate a kernel interrupt to terminate the program
    mov eax, 1   ; System call number for exit
    mov ebx, 0   ; Standard exit code
    int 128   ; Software interrupt to the kernel

; Recursive Tower of Hanoi function
hanoi: 

    ; [ebp+8] Number of remaining disks on the source tower
    ; [ebp+12] Source Tower
    ; [ebp+16] Auxiliary Tower
    ; [ebp+20] Destination Tower

    ; Hanoi function
    push ebp   ; Save the value of the ebp register on the stack
    mov ebp, esp   ; Set up a new frame pointer (ebp) pointing to the top of the stack

    mov eax, [ebp+8]   ; Move the number of disks on the source tower to the eax register

    cmp eax, 0   ; Check if there are still disks to be moved on the source tower
    je unpile   ; If not, jump to unpile

    ; First recursion    
    push dword [ebp+16]   ; Push the Auxiliary Tower
    push dword [ebp+20]   ; Push the Destination Tower
    push dword [ebp+12]   ; Push the Source Tower
    
    dec eax   ; Remove the top disk from the source tower to be placed on another tower
    push dword eax   ; Push the number of remaining disks to be moved on the source tower
    
    call hanoi   ; Call the Hanoi function -> recursion
    
    add esp, 16   ; After returning from the Hanoi function call, remove the "garbage" from the stack

    ; Print the movements
    push dword [ebp+16]   ; Push the Destination Tower
    push dword [ebp+12]   ; Push the Source Tower
    push dword [ebp+8]   ; Push the Disk
    
    call print   ; Call the imprime function to print the movements
    
    add esp, 12   ; After returning from the Hanoi function call, remove the "garbage" from the stack

    ; Second recursion
    push dword [ebp+12]   ; Push the Source Tower
    push dword [ebp+16]   ; Push the Work Tower
    push dword [ebp+20]   ; Push the Destination Tower
    
    mov eax, [ebp+8]   ; Move the number of remaining disks to the eax register
    
    dec eax   ; Remove the top disk from the source tower to be placed on another tower
    push dword eax   ; Push the number of remaining disks to be moved on the source tower
    
    call hanoi   ; Call the Hanoi function -> recursion

unpile: 

    mov esp, ebp   ; Set the base of the stack pointer (ebp) to the top
    pop ebp   ; Pop the top element of the stack and store the value in ebp
    ret   ; Pop the last value from the top of the stack and jump to it (return line in this case)

; Function to print movements
print:

    ; Print function
    push ebp   ; Save the value of the ebp register on the stack
    mov ebp, esp   ; Set up a new frame pointer (ebp) pointing to the top of the stack

    ; Convert values to ASCII and print
    mov eax, [ebp + 8]   ; Move the disk to be moved to the eax register
    add al, 48   ; Convert to ASCII
    mov [disk], al   ; Put the value in [disk] for printing

    mov eax, [ebp + 12]   ; Move the tower from which the disk came to the eax register
    add al, 64   ; Convert to ASCII
    mov [exit_tower], al   ; Put the value in [exit_tower] for printing

    mov eax, [ebp + 16]   ; Move the tower to which the disk went to the eax register
    add al, 64   ; Convert to ASCII
    mov [to_tower], al   ; Put the value in [to_tower] for printing

    ; Write the formatted movement message
    mov edx, length   ; Length of the message
    mov ecx, fullmsg   ; Formatted message
    mov ebx, 1   ; File descriptor for standard output (stdout)
    mov eax, 4   ; System call number for write
    int 128   ; Software interrupt to the kernel

    ; End of the print function
    mov esp, ebp   ; Set the base of the stack pointer (ebp) to the top
    pop ebp   ; Pop the top element of the stack and store the value in ebp
    ret   ; Pop the last value from the top of the stack and jump to it (return line)

section .data                         

    ; Defining messages
    fullmsg:
        msg: db "Moved disk "         
        disk: db " "
               db " from Tower "
        exit_tower: db " "  
                     db " to Tower "     
        to_tower: db " ", 0xa  ; To break the line
        
        length equ $-fullmsg
        
        title_msg:
        title: db 0xa, "<Assembly Tower of Hanoi>", 0xa
        len_title equ $-title_msg
    user_msg:
        for_user: db 0xa, "How many disks do you want to play with? (1-9)", 32  ;32 for space instead of line break
        len_user equ $-user_msg
