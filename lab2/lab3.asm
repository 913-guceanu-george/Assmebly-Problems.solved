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
    a DW 1829h
    b DW 1439h
    c DD 0
    aux dw 0

; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;Given the words A and B, compute the doubleword C as follows:
        ;the bits 0-6 of C have the value 0
        ;the bits 7-9 of C are the same as the bits 0-2 of A
        ;the bits 10-15 of C are the same as the bits 8-13 of B
        ;the bits 16-31 of C have the value 1
        
        mov eax, 0
        mov ax, [a]
        ror EAX, 13
        mov [a], ax ; now we have in a only the bits 0-2
        
        mov eax, 0
        mov ax, [b]
        ror eax, 7
        mov [aux], ax ; bits 8-16
        mov eax, 0
        mov ax, [aux]
        ror eax, 6 ; bits 8-13 are in front
        mov [aux], ax
        sub ax, [aux]
        rol eax, 6
        mov [b], ax ; now we have in b the bits 8-13 of b
        
        mov ebx, 0
        mov bx, -1 ; 16 bits of 1
        rol ebx, 6
        add bx, [b]
        rol ebx, 3
        add bx, [a]
        rol ebx, 7
        mov [c],ebx
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
