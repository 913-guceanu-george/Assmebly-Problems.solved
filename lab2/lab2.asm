bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

                          
; Expr: (A*B) +/- (C*D) where
; A - byte
; B, C - word
;D - dword                          
                          
                          
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 3h
    b db 11h
    c db 21h
    d db 7h

; our code starts here
segment code use32 class=code
    start:
        ;(c+d+d)-(a+a+b) - PROBLEM 25 ADDITIONS SUBSTRACTIONS
        mov eax, 0
        mov ebx, 0
        mov al, [c]; AL = 21h
        add al, [d]; AL = 28h
        add al, [d]; AL = 2Fh
        
        mov bl, al; BL = 2Fh
        
        mov al, [a]; AL = 3h
        add al, [a]; AL = 6h
        add al, [b]; AL = 17h
        
        sub bl, al; BL = 2Fh - 17h = 18h
        mov al, bl; AL = 18h
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
