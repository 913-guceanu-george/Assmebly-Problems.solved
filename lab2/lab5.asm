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
    text db "ana are mere si un cojoc"
    len equ $-text
    wordlen db 0
    backup_cx dw 0
    backup_esi dd 0
    backup_edi dd 0
    aux1 resb len
    aux2 resb len
    rez resb len
    
;Being given a string of bytes representing a text (succession of words separated by spaces), 
;determine which words are palindromes (meaning may be interpreted the same way in either forward or reverse direction)
; ex.: "cojoc", "capac" etc.

    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, 0
        mov esi, text
        mov edi, aux1
        mov ah, byte [wordlen]
        
        while:
            mov al, [esi]
            inc esi ; loads in AL the current byte of 
            cmp al, ' ' ; compares the current letter of the string with a space
            je check_palindrom ; if it is a space, it means we reached the end of a word, otherwise it continues with the code
            stosb ; stores in aux1 the words one by one

            add ah, 1 ; computing the word's length
            cmp cx, len
            je end
            inc cx ; if end of word not reached we still have to dec ecx, so our main loop works properly
            jmp while ; jumping until we reach the end of word
            check_palindrom:
                mov [aux1], edi ; we need to have our string in a 'variable'
                mov [backup_esi], esi
                mov [backup_edi], edi
                mov esi, aux1 ; we load it into esi to cross it
                mov edi, aux2 ; here we will compute the reverse of the word

                mov [wordlen], ah; we'll need it in order to parse the words

                std ; setting DF=1 so that we can take the string from aux1 in reverse order

                mov [backup_cx], cx ; backing up cx so we now where we are left
                mov cx, 0
                mov cl, [wordlen]
                while2:
                    lodsb 
                    stosb ; loading string from aux1 in reverse
                loop while2
                mov cl, [wordlen] ; now we will check if aux1=aux2 letter by letter
                cld ; we go from start to end this time
                mov esi, aux1
                mov cx, 0
                mov cl, [wordlen]
                while3:
                    lodsb
                    mov bl, al ; we move into bl the first letter of aux1
                    mov esi, aux2 ; first letter of aux2 in al 
                    cmp al, bl ; comparing them
                    jne end_while3 ; at first letter that's not the same, it goes back to the main loop
                loop while3
                ; loading in rez the first word that is a palindrome
                mov cl, [wordlen]
                mov ch, 0
                mov esi, aux1
                mov edi, rez
                load:
                    lodsb
                    stosb
                loop load
                mov [rez], edi
                end_while3: ; Here it will restore cx back to the first character that's a space, hence the decrement
                    mov cx, [backup_cx]
                    inc cx
                    mov esi, [backup_esi]
                    mov edi, [backup_edi]
                    cmp cx, len
        jne while
        end:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
