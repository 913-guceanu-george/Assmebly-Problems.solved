bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf, fopen, fread, fclose
import scanf msvcrt.dll
import exit msvcrt.dll
import printf msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll   ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    filename db "in.txt", 0
    fd dd 0
    format db "Number of even digits=%d", 0
    mode db "r", 0
    buff resb 100
    count db 0
    

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;A text file is given. Read the content of the file, count the number of even digits and display the result on the screen. The name of text file is defined in the data segment.
        ; exit(0)
        push dword mode
        push dword filename
        call [fopen]
        add esp, 4*2
        
        mov [fd], eax
        mov [count], byte 0
        
        .loop:
            push dword [fd]
            push dword 100
            push dword 1
            push dword buff
            call [fread]
            add esp, 4*4
            
            cmp eax, 0
            je .end
            
            mov ecx, eax
            
            mov esi, buff
            .parse:
                mov ebx, dword [count]
                lodsb
                cmp al, "0"
                    je .add_count
                cmp al, "2"
                    je .add_count
                cmp al, "4"
                    je .add_count
                cmp al, "6"
                    je .add_count
                cmp al, "8"
                    je .add_count
                dec ecx
                jmp .parse
                    .add_count:
                        add [count], byte 1
                    
            loop .parse
        jmp .loop
        .end:
        push dword [count]
        push dword format
        call [printf]
        add esp, 4*2
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
