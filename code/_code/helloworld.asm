BITS 64

section .text
global _start

strlen:
    mov rax,0                   ; make sure there's no junk in the register
.looplabel:
    cmp byte [rdi],0            ; subtract zero from the value of the memory location
                                ; pointed to by rax and set the flags, but don't change rax
    je  .end                    ; go to the end if we're finished
    inc rdi                     ; setup the loop by going to the next character
    inc rax                     ; add one to our character count
    jmp .looplabel              ; if the character wasn't the null character, go back
.end:
    ret                         ; otherwise, if it is, return from our function!
                                ; whatever place in the code called it can use rcx as
                                ; the length of its string
    
_start:
    mov   rdi, msg              ;  eax = strlen(rdi = msg)
    call  strlen

    add   al, '0'               ; This converts the number into a
                                ; usable character that will can
                                ; be printed
    mov  [len],al               ; Move this character to a string that can
                                ; be printed
    
    mov   rax, 1                ; sys_write
    mov   rdi, 1                ; stdout
    mov   rsi, len              ; pointer to beginning of our length string
    mov   rdx, 2                ; length of our length string is two
                                ; chars, the number & return
    syscall                     ; transfer control to the kernel

    mov   rax, 60               ; sys_exit
    mov   rdi, 0                ; exit(0)
    syscall                     ; transfer control to the kernel

section .data
    msg db "hello",0xA,0        ; define all these bytes as beginning
                                ; at the label msg
    len db 0,0xA                ; this is the string that will eventually be printed
                                ; the zero is a placeholder and 0xA is ascii for
                                ; return
