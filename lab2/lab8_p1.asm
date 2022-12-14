bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, scanf, printf
import scanf msvcrt.dll
import exit msvcrt.dll
import printf msvcrt.dll
   ; our data is declared here (the variables needed by our program)
section .data use 32
    ; ...
    a resd 1
    b resd 1
    rez dw 0
    format db "%d", 0
    format_rez db "%d+%d=%d", 0

; our code starts here
section .code use 32
    start:
        ;Two natural numbers a and b (a, b: dword, defined in the data segment) are given. Calculate their sum and display the result in the following format: "<a> + <b> = <result>". ;Example: "1 + 2 = 3"
        ;The values will be displayed in decimal format (base 10) with sign.
        
        ;mov eax, [a]
        ;add eax, [b]
        
        push dword a
        push dword format
        call [scanf]
        add esp, 4*2
        
        
        push dword b
        push dword format
        call [scanf]
        add esp, 4*2
        

        mov eax, 0
        add eax, [a]
        add eax, [b]
        
        push dword eax
        push dword [b]
        push dword [a]
        push dword format_rez
        call[printf]
        add esp, 4*4
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
