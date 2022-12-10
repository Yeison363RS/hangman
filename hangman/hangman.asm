

;
; file: skel.asm
; This file is a skeleton that can be used to start assembly programs.

%include "asm_io.inc"
LINE_FEED equ 10
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
        cmp ecx, [number]; the number current word in the dictionary 
                        ; selected is equals to random number to play  
        je %%cw03       ; if compation is true skip to label cw3, if is false follow the execution flow 
        mov al, [ebx]   ; get the next character located in the memory direction ebx register does it move to al of eax register
        cmp al, 0       ; the character in al of eax register is equals to 0 (null) will be final of a word
        je %%cw02       ; if compation is true skip to label cw02, if is false follow the execution
        inc ebx         ; put the ebx the memory direction of next character on the sequence of characters of dictionary words
        jmp %%cw01      ; skip to label cw01 (to read next character)
%%cw02:
        inc ecx         ; increase the number of current word in the dictionary
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
        mov byte [edi], 0 ;add the final character to the secret word to be displayed 

        popa
%endmacro

%macro showing_word 0

        pusha 
        mov eax, secret         ;put the the representation with special characters of the secret word
        call print_string       ;call function for printing the secret word stored in eax register
        call print_nl           ;call function for printing a jump line
        popa                    

%endmacro

%macro show_message 1
        pusha
        mov esi, msgsacci       ;move the memory direction of first character of the dictionary of message to esi register
        mov edi, msg            ;move the memory direction  of first character of message to edi register
        mov ecx,1               ;put value of first message in the dictionary of messages
%%sm01:
        mov al, [esi]           ;move the character of memory direction esi register to al of eax register 
        inc esi                 ;increse the memory direction into dictionary of the messages
        cmp cl,%1               ;compare the number of message current with the message wants to print
        je %%sm04               ;if the compation is correct skip to label sm04
        cmp al, 0               ;compare the character stored in al of eax register with 0 (null) namely the end of word
        je %%sm02               ; if compation is true skip to label sm02 (end of a message) 
        jmp %%sm01              ; if fails the previus comparations skip to label sm01
%%sm02:
        inc ecx                 ;increment the counter to indicate the number of message current
        jmp %%sm01              ;skip to label sm01
%%sm04:
        mov al, [esi]           ;put the of the message located in the dictionary of messages
        cmp al, 0               ;compare if character with 0 for indicate the end of the message selected
        je %%end_pro            ;if the compation is correct skip to label end_pro
        mov [edi], al           ;put the character selected in the dictionary of messages into message will be shown 
        inc edi                 ;increase the number of memory allocated into the dictionary of messages
        inc esi                 ;increase the number of memory allocated into the message to be displayed
        jmp %%sm04              ;skip to label sm04 to take the next character
%%end_pro:
        mov byte [edi], 0;      ;add the final character to the message to be displayed
        mov eax , msg           ;put the message to be displayed to the eax register
        call print_string       ;call function to print the message seleted
        call print_nl           ;call function for printing a jump line
        popa 
%endmacro

%macro show_scene 1
        pusha
        mov esi, scenes ;move the memory direction of first character of the dictionary of scenes the game to esi register
        mov edi, scene  ;move the memory direction  of first character of scene to be displayed to edi register
        mov ecx,1       ;put value of first scene in the dictionary of scenes of the game
%%ss01:
        mov al, [esi]   ;move the character of the dictionary of scenes to the memory direction esi register to al of eax register 
        inc esi         ;increse the memory direction into dictionary of the messages
        cmp cl, %1      ;compare the number current of scene in the dictionary with the number that who wants
        je %%ss04       ;if the comparation is equals skip to label ss04 to take the next character
        cmp al, 0       ;compare the character stored in al of eax register with 0 (null) namely the end of a scene
        je %%ss02       ;if compation is true skip to label ss02 (end of the a scene) 
        jmp %%ss01      ; skip to label iss02
%%ss02:
        inc ecx         ;increase the counter of number current scene actual
        jmp %%ss01      ; skip to label iss01
%%ss04:
        mov al, [esi]   ;place in eax register the character indicated of dictionary of scenes
        cmp al, 0       ;compare the character stored in eax register with 0
        je %%end_pro    ;if in the comparation are equals skip to label end_pro this indicates end of scene selected
        mov [edi], al   ;put the character selected in the dictionary of scenes into scene will be shown
        inc edi         ;increase the number of memory allocated into the scene to be displayed
        inc esi         ;increase the number of memory allocated into the dictionary of scenes
        jmp %%ss04      ; skip to label iss04
%%end_pro:
        mov byte [edi], 0;add the final character to the scene to be displayed
        mov eax , scene ;put the scene to be displayed to the eax register
        call print_string ;call function to print the scene seleted
        popa 
%endmacro

%macro verify_character 0
        pusha
        mov esi, hidden ;put the memory direction of first character hidden word the game to esi register
        mov edi, secret ;put the memory direction of first character secret word the game to edi register
        mov ebx, 0      ;put the intial value 0, it represents the character still without finding
        mov ecx, 0      ;put the intial value 0, it represents the matches the character joined with hidden word
        mov [not_f],bl  ;put the intial value 0, to variable not_f
        mov [matches],cl;put the intial value 0, to variable matches the character
        jmp %%vc02;     ;skip to the label vc02     
%%vc02:
        mov al, [esi]   ;put the character indicate inside the hidden word to eax register
        cmp al, 0       ;compare the character of eax register with 0 is namely the end of the hidden word
        je %%end_m      ;if the comparation is equals skip to label end_m
        cmp al, [character];compare the character in al with the joined from the player to eax register
        je %%vc01       ;if the comparation is equals skip to vc01 label 
        mov al, [edi]   ;put the character indicate inside the hidden word to eax register
        mov dl,HIDDEN_CHAR;put the character that represents the characters without to find in the eax register
        cmp al, dl      ;compare the character in al with the character that represents the character without to find
        je %%vc04       ;if comparation es equals skip to vc04 label
        jmp %%vc05      ;skip to the label vc05
%%vc04:
        mov bl,[not_f]  ;put the number actual of characters without to find by the player in to ebx register
        add ebx,1       ;increase +1 the number stored in ebx register 
        mov [not_f],bl  ;put the number actual of characters without to find by the player into variable not_f
        jmp %%vc05      ;skip to the label vc05
%%vc03:
        mov al, [character];put the character joined for the player in to eax register
        mov [edi], al   ;put the character joined for the player in the memory allocated of the secret word
        inc edi         ;increase the number of memory allocated into the secret word
        inc esi         ;increase the number of memory allocated into the hidden word
        mov cl,[matches];put the number actual of characters that match with the hidden word in to ecx register
        add ecx,1       ;increase +1 the number stored in the ecx register
        mov [matches],cl;put the number actual of characters that match with the hidden word to variable not_f
        jmp %%vc02      ;skip to the label vc02
%%vc05:
        inc edi         ;increase the number of memory allocated into the secret word
        inc esi         ;increase the number of memory allocated into the hidden word
        jmp %%vc02;     ;skip to the label vc02

%%vc01:
        mov al, [edi]   ;put the character indicate inside the hidden word to eax register
        mov dl,HIDDEN_CHAR;put the character that represents the characters without to find in the eax register
        cmp al, dl      ;compare the character in al with the character that represents the character without to find
        je %%vc03       ;if comparation es equals skip to vc03 label
        jmp %%vc05      ;skip to the label vc05

%%end_m:
        mov [matches],cl;put the number actual of characters that match with the hidden word to variable not_f
        popa
%endmacro

segment .data
                        ;Create dictionary of messages for the player

        msgsacci  db " █▀ █▀█ █   █  █ █▀█ █▀▄ █▀█",10
                  db "▄█ █▀█ █▄▄  ▀▄▀ █▀█ █▄▀ █▄█",0
                db "  █▀█ █░█ █▀█ █▀█ █▀▀ █▀█ █▀▄ █▀█",10
                db " █▀█ █▀█ █▄█ █▀▄ █▄▄ █▀█ █▄▀ █▄█",0

                        ;Create dictionary of scenes for the player
        scenes db "",10
                db "",10
                db "",10
                db "",10
                db "",10
                db "              \\   _   /",10
                db "               \\('_')/",10
                db "                  ██",10
                db "                  ██",10
                db "                 /  \\",10
                db "________________/____\\______",0
                db "_______",10
                db "_______",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||     \\   _   /",10
                db "||      \\('_')/",10
                db "||        ██",10
                db "||        ██",10
                db "||        / \\",10
                db "||_______/___\\_________",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||",10
                db "||         _",10
                db "||       ('_')",10
                db "||       /██\\",10
                db "||      / ██ \\",10
                db "||        /  \\",10
                db "||_______/____\\______",0
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
                db "||     ° __/██\\",10
                db "||° °       ██ \\",10
                db "||          / \\",10
                db "||_________/___\\______",0
                db "_______________________",10
                db "_______________|_|_____|",10
                db "||              °",10
                db "||              °",10
                db "||               ° °",10
                db "||                _  °",10
                db "||              ('_') °°°",10
                db "||             / ██ \\__C°°",10
                db "||            /  ██  ",10
                db "||               /  \\",10
                db "||             _/____\\_",10
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
                db "||          / ██ \\",10
                db "||         /  ██  \\",10
                db "||           /  \\",10
                db "||         _/____\\_",10
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
                db "||         / ██ \\",10
                db "||        /  ██  \\",10
                db "||          /  \\",10
                db "||        _/__ _\\",10
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
                db "||            - -",10
                db "||           ",10
                db "||_____________________",0

                ;Create dictionary of words to choose randomly
        words   db "VICENT VAN GOGH" ,0
                db "DIEGO VELAZQUEZ" ,0
                db "PABLO PICASSO" ,0
                db "CLAUDE MONET" ,0
                db "PAUL CEZANNE" ,0
                db "FRANCISCO DE GOYA" ,0
                db "LEONARDO DA VINCI" ,0
                db "REMBRANDT" ,0
                db "SANDRO BOTTICELLI" ,0
                db "MIGUEL ANGEL" ,0
                db "SALVADOR DALI" ,0
                db "REMBRANDT" ,0
                db "ANTONIO CANO" ,0
                db "DEBORA ARANGO" ,0
                db "FERNANDO BOTERO" ,0
                db "REMBRANDT" ,0
                db "CARAVAGGIO" ,0
                db "GUSTAV KLIMT" ,0
                db "HENRI MATISSE" ,0
                db "RENE MAGRITTE" ,0
                db "SALVADOR DALI" ,0

        ;Create the constant with de message to indicate the player the entry of characters

        msg_input db "Ingrese una letra (SOLO MAYUSCULAS)",0

        menu    db    "            ------------------------------------------------",10
                db    "           |  --------------------------------------------  |",10
                db    "           | |                                            | |",10
                db    "           | |     ¡BIENVENIDO AL JUEGO DEL AHORCADO!     | |",10
                db    "           | |                                            | |",10
                db    "           | |      Ingresa el número de la opción        | |",10
                db    "           | |      que desea                             | |",10
                db    "           | |                                            | |",10
                db    "           | |      1.Jugar                               | |",10
                db    "           | |      2.Salir del juego                     | |",10
                db    "           |  --------------------------------------------  |",10                    
                db    "            -------------------------------------------------   ",0
        msg_lives db "VIDAS RESTANTES: ",0
segment .bss

        WORDS_LEN equ 21
        HIDDEN_CHAR     equ '*'     ;hidden char
        MAX_WORD_LEN    equ 18      ;max length for sentences in the dictionary of words to choose
        PLAYER_LIVES    equ 8       ;constant to save the player lives
        INIT_SCENE    equ 0       ;constant to save the number of scene initial

        hidden  resb MAX_WORD_LEN   ;reserve space for store the characters hidden for length secret word 
        secret  resb MAX_WORD_LEN   ;reserve space for store the characters of secret word
        number  resb 1              ;reserve space for random number generated 
        lives   resb 1          ;reserve space for number lives while playing
        scene_num   resb 1      ;reserve space for number of current scene while playing
        scene   resb 350        ;reserve space for characters a current scene  while playing
        msg   resb 350          ;reserve space for characters a current message the end game
        not_f resb 1            ;reserve space for number of characters a current that is not discovered while playing
        character resb 1        ;reserve space for character that the player entry while playing
        matches resb 1          ;reserve space for number of characters that match with the current hidden word
        option resb 1           ;reserve space for numeber of de option that the player wants to perform

segment .text

        global  asm_main

        asm_main:
                enter   0,0              ; setup routine
                pusha
        init:
                mov eax , menu
                call print_string       ;call the function for print the string allocated in the memory location the eax register
                call print_nl           ;call the function to print line break
                call read_int           ;call the function to read the integer (what the player wants)
                mov [option], eax       ;put the option in the variable option
                mov eax, [option]       ;put the value of variable option to eax register
                cmp eax,1               ;compare if the eax register value is equals to 1
                je game                 ;if the comparison is correct skip to game label
                jmp end_progra          ;skip to the end_progra label
        game:

                random WORDS_LEN        ; call macro that generate a random number
                choose_word             ; call macro that choose a word based on random number
                init_secret_word        ; call macro that preparing the word to be shown
                mov byte [lives], PLAYER_LIVES;Assigns the intial number lives
                mov byte [scene_num],INIT_SCENE;Assigns the intial number of the scene
                showing_word            ; call macro showing_word   
                mov eax , msg_input     ;put the message for the player during enters characters
                call print_string       ;call the function for print the string allocated in the memory location the eax register
                call print_nl           ;call the function to print line break
                jmp play                ;skip to the play label

        pri_ind:
                mov eax , msg_lives
                call print_string       ;call the function for print the string allocated in the memory location the eax register
                mov eax,0
                mov al,[lives]          ;put the current number lives to eax register
                call print_int          ;call the function to print integer stored in the eax register
                call print_nl           ;call the function to print line break
                mov al,[scene_num]      ;put the current scene number in the eax register
                show_scene [scene_num]  ;call the function to print the current scene
                call print_nl           ;call the function to print line break
                showing_word            ; call macro for show the secret word
                call print_nl           ; call the function to print line break  
                mov eax , msg_input     ;put the message for the player during enters characters
                call print_string       ;call the function for print the string allocated in the memory location the eax register
                call print_nl           ;call the function to print line break
        play:
                call read_char          ;call function to read the character
                cmp al, LINE_FEED       ;compare if the character entered is equals to character of line break  
                je play                 ;if the comparison is correct skip to play label
                mov byte [character],al ;put the character joined by the player to the variable character
                verify_character        ;call macro for if verify the character is into the hidden word
                mov cl,[matches]        ;put the current number of matches the character inside the hidden word
                mov bl,[not_f]          ;put the current number of characters without finding

        loop_game:
                cmp bl,0                ;compare if number of characters without finding is 0 
                je pg03                 ;if the comparison is correct skip to pg03 label
                cmp cl,0                ;compare if number of matches with the character is entered by the player
                je pg01                 ;if the comparison is correct skip to pg01 label
                mov eax , msg_input     ;put the message for the player during enters characters
                showing_word            ; call macro for show the secret word   
                call print_string       ;call the fuction for print the string allocated in the memory location the eax register
                call print_nl           ;call the fuction to print line break
                jmp play                ;skip to the play label
        pg01:
                mov al,[lives]          ;put the current number lives to eax register
                sub eax,1               ;substract 1 to value of eax register
                mov [lives],al          ;put the current number of lives to variable lives
                mov al,[scene_num]      ;put the current number of scene to eax register
                add eax,1               ;add 1 to value of eax register
                mov [scene_num],al      ;put the current number of scene to variable scene_num
                mov al,[lives]          ;put the current number lives to eax register
                cmp al,0                ;compare if number lives in the eax register is equals to 0
                je pg04                 ;if the comparison is correct skip to the pri_ind label
                jmp pri_ind             ;skip to the pri_ind label
        pg04:
                mov eax , msg_lives
                call print_string       ;call the fuction for print the string allocated in the memory location the eax register
                mov eax,0               ;put 0 value in the eax register for clean all register
                mov al,[lives]          ;put the current number lives to eax register
                call print_int          ;call the fuction to print integer stored in the eax register
                call print_nl           ;call the fuction to print line break
                show_scene [scene_num]  ;call the fuction to print the current scene
                call print_nl           ;call the fuction to print line break
                show_message 2          ;call macro for show the message of player looser
                jmp init                ;skip to the init label
        pg03:   
                call print_nl           ;call the fuction to print line break
                showing_word            ; call macro for show the secret word
                call print_nl           ;call the fuction to print line break
                show_message 1          ;call macro for show the message of player winner
                jmp init                ;skip to the init label

        end_progra:

                popa
                mov     eax, 0            ; return back to C
                leave                     
                ret