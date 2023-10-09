bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    a db 2h
    b db 3h
    c db 6h
    d db 33h
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;[100-10*a+4*(b+c)]-d - PROBLEM MUL/DIV 25 byte
        mov al, 10
        mov ah, 0
        mov cl, [a]
        mul cl
        mov bx, 0
        mov bl, al; BL = 10*a
        
        mov al, 100d
        sub al, bl
        mov bl, al ; BL = 100 - 10*a
        
        mov al, [b]
        add al, [c]
        mov ah, 0
        mov cl, 4
        mul cl; AL = 4*(b+c)
        add bl, al; BL = 100 - 10*a + 4*(b+c)
        
        sub bl, [d]; BL = (100 - 10*a + 4*(b+c)) - d
        mov al, bl; AL = BL
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
