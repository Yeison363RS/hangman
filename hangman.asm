

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"

%macro random 1
        pusha
        mov ecx, 0xff   ; set value for the divider (255)
        rdtsc           ; this instruction get how many CPU ticks took place since the procesor was reset
        xor edx, edx    ; clean edx register
        and eax, ecx    ; calculate random number between 0 and 255

        imul eax, %1    ; make the operation random_number * parameter 1   
        mov edi, eax    ; mov resul multiplication to the edi register
        idiv ecx        ; make the operation edi/ecx (result_Mult)/(255)
                        ;the result of division stays like this 
                        ;edi (dividend)
                        ;ecx (divisor)
                        ;eax (Quotient)
                        ;edx (remainder)

        mov [number],eax; move the Quotient to memory direction of variable number 

        popa
%endmacro

%macro choose_word 0
        
        pusha

        mov ecx, 0      ;  
        mov ebx, words  ; locate the memory direction of dictionary words in ebx register
        mov esi, hidden ; locate the memory direction of variable hidden (word to play) in ebx register

%%cw01:
        cmp ecx, [number]; the number actual word in the dictionary 
                        ; selected is equals to random number to play  
        je %%cw03       ; if compation is true skip to label cw3, if is false follow the execution flow 
        mov al, [ebx]   ; get the next character located in the memory direction ebx register does it move to al of eax register
        cmp al, 0       ; the character in al of eax register is equals to 0 (null) will be final of a word
        je %%cw02       ; if compation is true skip to label cw02, if is false follow the execution
        inc ebx         ; put the ebx the memory direction of next character on the sequence of characters of dictionary words
        jmp %%cw01      ; skip to label cw01 (to read next character)
%%cw02:
        inc ecx         ; increase the number of actual word in the dictionary
        inc ebx         ; put the ebx the memory direction of next character on the sequence of characters of dictionary words
        jmp %%cw01      ; skip to label cw01
%%cw03:
        mov al, [ebx]   ; move the character indicate for ebx register memory space to al of eax register
        mov [esi], al   ; move the character in al of eax register to memory direction stored in esi register

        cmp al, 0       ; the character stored in al of eax register is equals to 0 (null) namely the end of word
        je %%cw04        ; if compation is true skip to label cw04(end route in to word)
        inc ebx         ; put the ebx the memory direction of next character on the sequence of characters of dictionary words
        inc esi         ; put the esi the memory direction of next character for add to word found
        jmp %%cw03          ; if compation is true skip to label cw3 namely move the next character to the variable hidden 
%%cw04:
        popa
%endmacro

%macro init_secret_word 0
        pusha 

        mov esi, hidden ; move the memory direction of first character of the word to esi register
        mov edi, secret ; move the memory of the word secret (namely the representation word with * simbols) to esi register
%%isw01:
        mov al, [esi]   ; move the character of memory direction esi register to al of eax register 
        cmp al, 0       ; the character stored in al of eax register is equals to 0 (null) namely the end of word
        je %%isw02      ; if compation is true skip to label cw02 (end route in to hidden word)
        mov byte [edi],HIDDEN_CHAR; move the character * to memory direction of secret word (edi register) 
        inc esi         ; put the esi the memory direction of next character (*) for add to secret word
        inc edi         ; put the edi the memory direction of next character word to guess
        jmp %%isw01     ; skip to label isw02
%%isw02:
        mov byte [edi], 0;      

        popa
%endmacro

%macro showing_word 0

        pusha 
        mov eax, secret
        call print_string
        call print_nl
        popa

%endmacro

%macro show_message 0
        pusha
        mov esi, msgsacci ; /////move the memory direction of first character of the word to esi register
        mov edi, msg  ; /////move the memory of the word secret (namely the representation word with * simbols) to esi register
        mov ecx,1       ;//// 
%%ss01:
        mov al, [esi]   ; move the character of memory direction esi register to al of eax register 
        inc esi         ; put the esi the memory direction of next character (*) for add to secret word
        cmp ecx,ebx
        je %%ss04
        cmp al, 0       ; the character stored in al of eax register is equals to 0 (null) namely the end of word
        je %%ss02      ; if compation is true skip to label cw02 (end route in to hidden word) 
        jmp %%ss01      ; skip to label isw02
%%ss02:
        inc ecx
        jmp %%ss01        
%%ss04:
        mov al, [esi]
        cmp al, 0
        je %%end_pro
        mov [edi], al
        inc edi
        inc esi
        jmp %%ss04
%%end_pro:
        mov byte [edi], 0;
        popa 
%endmacro

%macro show_scene 1
        pusha
        mov esi, scenes ; /////move the memory direction of first character of the word to esi register
        mov edi, scene  ; /////move the memory of the word secret (namely the representation word with * simbols) to esi register
        mov ecx,1       ;//// 
%%ss01:
        mov al, [esi]   ; move the character of memory direction esi register to al of eax register 
        inc esi         ; put the esi the memory direction of next character (*) for add to secret word
        cmp ecx, %1
        je %%ss04
        cmp al, 0       ; the character stored in al of eax register is equals to 0 (null) namely the end of word
        je %%ss02      ; if compation is true skip to label cw02 (end route in to hidden word) 
        jmp %%ss01      ; skip to label isw02
%%ss02:
        inc ecx
        jmp %%ss01        
%%ss04:
        mov al, [esi]
        cmp al, 0
        je %%end_pro
        mov [edi], al
        inc edi
        inc esi
        jmp %%ss04
%%end_pro:
        mov byte [edi], 0;
        popa 
%endmacro

%macro verify_character 0
        pusha
        mov esi, secret ; /////
        mov edi, hidden
        mov ebx, 0
        mov ecx, 0
        jmp %%pp02;
%%pp02:
        mov al, [esi]
        cmp al, 0
        je %%end
        cmp al, [character]
        je %%pp01
        mov al, [edi]
        mov ah,[HIDDEN_CHAR]
        cmp al, ah
        je %%pp04
        jmp %%pp03
%%pp04:
        inc ebx
        mov [not_found],ebx
        jmp %%pp03
%%pp03:
        inc edi
        inc esi
        jmp %%pp02;
%%pp01:
        mov al, [edi]
        mov ah,[HIDDEN_CHAR]
        cmp al, ah
        je %%pp03
        mov [edi], esi
        inc edi
        inc esi
        inc ecx
        jmp %%pp02

%%end:
        popa
%endmacro

segment .data
        msgsacci  db "█▀ ▄▀█ █   █  █ ▄▀█ █▀▄ █▀█",10
                  db "▄█ █▀█ █▄▄  ▀▄▀ █▀█ █▄▀ █▄█",0
                db "▄▀█ █░█ █▀█ █▀█ █▀▀ ▄▀█ █▀▄ █▀█",10
                db "█▀█ █▀█ █▄█ █▀▄ █▄▄ █▀█ █▄▀ █▄█",0

        scenes db "",10
                db "",10
                db "",10
                db "",10
                db "",10
                db "              \   _   /",10
                db "               \('_')/",10
                db "                  ██",10
                db "                  ██",10
                db "                 /  \",10
                db "________________/____\______",0
                db "__",10
                db "||",10
                db "||",10
                db "||",10
                db "||               \   _   /",10
                db "||                \('_')/",10
                db "||                  ██",10
                db "||                  ██",10
                db "||                  / \",10
                db "||_________________/___\______",0
                db "_______",10
                db "_______",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||     \   _   /",10
                db "||      \('_')/",10
                db "||        ██",10
                db "||        ██",10
                db "||        / \",10
                db "||_______/___\_________",0
                db "_______________",10
                db "_______________|",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||         _",10
                db "||    ___('_')___",10
                db "||        ██",10
                db "||        ██",10
                db "||        /  \",10
                db "||_______/____\______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||         _",10
                db "||       ('_')",10
                db "||       /██\",10
                db "||      / ██ \",10
                db "||        /  \",10
                db "||_______/____\______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||             °",10
                db "||             °",10
                db "||            °",10
                db "||          °",10
                db "||        °  _",10
                db "||       ° ('_')",10
                db "||     ° __/██\",10
                db "||° °       ██ \",10
                db "||          / \",10
                db "||_________/___\______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||               ° °",10
                db "||                _  °",10
                db "||              ('_') °°°",10
                db "||             / ██ \__C°°",10
                db "||            /  ██  ",10
                db "||               /  \",10
                db "||             _/____\_",10
                db "||            |________|",10
                db "||              ||  ||",10
                db "||______________||__||_______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||              °",10
                db "||            °  °",10
                db "||          °  _  °",10
                db "||          °(;_;)°",10
                db "||          / ██ \",10
                db "||         /  ██  \",10
                db "||           /  \",10
                db "||         _/____\_",10
                db "||        |________|",10
                db "||          ||  ||",10
                db "||__________||__||_______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||              °",10
                db "||            °  °",10
                db "||          °  _  °",10
                db "||         °(;L;)°",10
                db "||         / ██ \",10
                db "||        /  ██  \",10
                db "||          /  \",10
                db "||        _/__ _\",10
                db "||        |__|   ",10
                db "||          ||  ",10
                db "||__________||___________",0
                db "_______________________"
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||              °",10
                db "||            °  °",10
                db "||          °  _  °",10
                db "||          °(*L*)°",10
                db "||           |██|",10
                db "||           |██|",10
                db "||            | | ",10
                db "||            | |",10
                db "||            " "",10
                db "||           ",10
                db "||_____________________",0

                
        messagges db "Felicitaciones Ganaste" ,0
                db "Mejor suerte para la proxima, vuelve a intentarlo" ,0

        words   db "COLOMBIA" ,0
                db "FRANCIA" ,0
                db "EU" ,0
                db "ALEMANIA" ,0
                db "PERU" ,0
                db "ARGENTINA" ,0
        msg_input db "Ingrese una letra"

segment .bss

        WORDS_LEN equ 6
        HIDDEN_CHAR     equ '*'     ;hidden char
        MAX_WORD_LEN    equ 10      ;max length for sentences in the dictionary
        PLAYER_LIVES    equ 3       ;player lives
        MAX_SCENES    equ 9       ;player lives
        INIT_SCENE    equ 1       ;player lives

        hidden  resb MAX_WORD_LEN   ;reserve space for store the characters hidden for length secret word 
        secret  resb MAX_WORD_LEN   ;reserve space for store the characters of secret word
        number  resb 1              ;reserve space for random number generated 
        lives   resb 1              ;reserve space for number lives while playing
        scene_num   resb 1          ;reserve space for number lives while playing
        scene   resb 350          ;reserve space for number lives while playing
        msg   resb 350          ;reserve space for number lives while playing
        not_found resb 1
        character resb 1 

segment .text

        global  asm_main

        asm_main:
                enter   0,0              ; setup routine
                pusha

                mov byte [scene_num],INIT_SCENE
                random WORDS_LEN        ; call macro that generate a random number
                choose_word             ; call macro that choose a word based on random number
                init_secret_word        ; call macro that preparing the word to be shown
                mov byte [lives], PLAYER_LIVES;Assigns the intial number lives
        play:   
                showing_word            ; call macro showing_word   
                mov eax , msg_input
                call print_string
                call print_nl
                call read_char
                mov [character], al
                call verify_character
                cmp ecx, 0
                je pg01
                cmp ebx,0
                je pg03
                jmp play 
        pg01:
                mov eax,[lives]           ;??
                cmp eax, 0
                je pg02
                sub eax,1
                show_scene [scene_num]
                mov eax , scene
                call print_string
        pg02:
                mov eax,[scene_num],
                inc eax
                mov [scene_num],eax
                cmp eax,[MAX_SCENES]
        pg04:
                show_scene [scene_num]
                mov eax , scene
                call print_string
                mov ebx,2
                show_message
                jmp end_progra 
        pg03:
                mov ebx,1
                show_message
                jmp end_progra

        end_progra:

                popa
                mov     eax, 0            ; return back to C
                leave                     
                ret