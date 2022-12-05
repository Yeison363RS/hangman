%include "asm_io.inc"

LINE_FEED equ 10

%macro read_string 2
    pusha

    mov edi, %1
    mov ecx, %2

loopstrstart:
    call read_char
    cmp al, LINE_FEED
    je loopstrend
    mov [edi], al
    inc edi
    loop loopstrstart

loopstrend:
    mov byte [edi], 0
    popa
%endmacro

    ;Segmento de datos , en este segmento se definen los datos del sistema
    segment .data
        principalMenu   db    "           __| |____________________________________________| |__",10
                        db    "♠♠        (__   ____________________________________________   __)    ♠♠",10
                        db    "♠♠           | |                                            | |       ♠♠",10
                        db    "♠♠           | |        ¡Bienvenido a la Calculadora!       | |       ♠♠",10
                        db    "♠♠           | |                                            | |       ♠♠",10
                        db    "♠♠           | |                                            | |       ♠♠",10
                        db    "♠♠           | |      Ingresa el número de la opción        | |       ♠♠",10
                        db    "♠♠           | |      que deseas realizar                   | |       ♠♠",10
                        db    "♠♠           | |                                            | |       ♠♠",10
                        db    "♠♠           | |      1.Sumar dos números                   | |       ♠♠",10
                        db    "♠♠           | |      2.Restar dos números                  | |       ♠♠",10
                        db    "♠♠           | |      3.Multiplicar dos números             | |       ♠♠",10
                        db    "♠♠           | |      4.Dividir dos números                 | |       ♠♠",10
                        db    "♠♠           | |      5.Salir de la calculadora             | |       ♠♠",10
                        db    "♠♠         __| |____________________________________________| |__     ♠♠",10                    
                        db    "♠♠        (__   ____________________________________________   __)    ♠♠",10
                        db    "♠♠           | |                                            | |       ♠♠",0

        show_welcome     db "¡Bienvenido a la calculadora !" ,0
        read_name  db "Ingresa tu nombre",0
        read_number_1  db "Ingresa el primer operando",0
        read_number_2  db "Ingresa el segundo operando",0
        result_sum      db " el resultado de la suma de ",0
        result_subs     db " el resultado de la resta de ",0
        result_multiply db " el resultado de la multiplicación de ",0
        result_divided  db " el resultado de la división de ",0
        line_result db "****************************************************************************",0
        sum_signe      db " + ",0
        subs_signe      db " - ",0
        multiply_signe      db " x ",0
        divided_signe      db " / ",0
        result_general  db " es ",0
        result_cotient  db " y el residuo es ",0
        validation_zero  db "xxxxxxxxxx---NO ES POSIBLE DIVIDIR ENTRE 0---xxxxxxxxxx",0



    ;Segmento de variables , en este segmento se definen las variables del sistema
    segment .bss
        name resb 22
        option resd 1 
        number1 resd 1
        number2 resd 1
        result resd 1
        cotient resd 1
 
    ;Segmento de código , en este segmento se define el código del sistema
    segment .text
        global asm_main

asm_main:
    enter   0,0               ; Inicio del segmento de código
    pusha

    ;Solicitar nombre del usuario
    mov eax , show_welcome
    call print_string
    mov eax , read_name
    call print_string
    call print_nl
    call read_string name , 20

init:
    ;Mostrar menú principal
    mov eax , principalMenu
    call print_string
    call print_nl
    ;Leer opcion del menú principal
    call read_int
    mov [option], eax
    mov eax, [option]
    cmp eax,1
    je sum
    cmp eax,2
    je subst
    cmp eax,3
    je mu
    cmp eax,4
    je divid
    cmp eax,5
    je finish
    jmp finish
    
sum:
    ;Mostrar el mensaje para leer el primer operando
    mov eax , read_number_1
    call print_string
    call print_nl
    ;Leer el primer operando
    call read_int
    mov [number1], eax  
    ;Mostrar el mensaje para leer el segundo operando  
    mov eax , read_number_2
    call print_string
    call print_nl
    ;Leer el segundo operando
    call read_int
    mov [number2], eax
    ;Calcular la suma y guardarla en result
    mov eax,[number1]
    add eax,[number2]
    mov [result],eax
    ;Mostrar mensaje de la suma 
    mov eax,line_result
    call print_string
    call print_nl
    mov eax,name
    call print_string
    mov eax,result_sum
    call print_string
    mov eax,[number1]
    call print_int
    mov eax,sum_signe
    call print_string
    mov eax,[number2]
    call print_int
    mov eax,result_general
    call print_string
    mov eax,[result]
    call print_int
    call print_nl
    mov eax,line_result
    call print_string
    call print_nl
    call print_nl
    call print_nl
    jmp init

subst:
    ;Mostrar el mensaje para leer el primer operando
    mov eax , read_number_1
    call print_string
    call print_nl
    ;Leer el primer operando
    call read_int
    mov [number1], eax  
    ;Mostrar el mensaje para leer el segundo operando  
    mov eax , read_number_2
    call print_string
    call print_nl
    ;Leer el segundo operando
    call read_int
    mov [number2], eax
    ;Calcular la resta y guardarla en result
    mov eax,[number1]
    sub eax,[number2]
    mov [result],eax
    ;Mostrar mensaje de la resta 
    mov eax,line_result
    call print_string
    call print_nl
    mov eax,name
    call print_string
    mov eax,result_subs
    call print_string
    mov eax,[number1]
    call print_int
    mov eax,subs_signe
    call print_string
    mov eax,[number2]
    call print_int
    mov eax,result_general
    call print_string
    mov eax,[result]
    call print_int
    call print_nl
    mov eax,line_result
    call print_string
    call print_nl
    jmp init

mu:
    ;Mostrar el mensaje para leer el primer operando
    mov eax , read_number_1
    call print_string
    call print_nl
    ;Leer el primer operando
    call read_int
    mov [number1], eax  
    ;Mostrar el mensaje para leer el segundo operando  
    mov eax , read_number_2
    call print_string
    call print_nl
    ;Leer el segundo operando
    call read_int
    mov [number2], eax
   ;Calcular la multiplicación y guardarla en result
    mov eax,[number1]
    imul eax,[number2]
    mov [result],eax
    ;Mostrar mensaje de la multiplicación 
    mov eax,line_result
    call print_string
    call print_nl
    mov eax,name
    call print_string
    mov eax,result_multiply
    call print_string
    mov eax,[number1]
    call print_int
    mov eax,multiply_signe
    call print_string
    mov eax,[number2]
    call print_int
    mov eax,result_general
    call print_string
    mov eax,[result]
    call print_int
    call print_nl
    mov eax,line_result
    call print_string
    call print_nl
    jmp init

divid:
    ;Mostrar el mensaje para leer el primer operando
    mov eax , read_number_1
    call print_string
    call print_nl
    ;Leer el primer operando
    call read_int
    mov [number1], eax  
    ;Mostrar el mensaje para leer el segundo operando  
    mov eax , read_number_2
    call print_string
    call print_nl
    ;Leer el segundo operando
    call read_int
    mov [number2], eax

    ;Validar división por cero
    mov eax,[number2]
    cmp eax,0
    je nodivided
    ;Calcular la división y guardarla en result
    mov eax,[number1]
    cdq                       ; initialize edx by sign extension
    mov  ecx, [number2]          ; can't divide by immediate value
    idiv ecx               ; edx:eax / ecx
    mov  [result], eax          ; save quotient into ecx
    mov [cotient],edx
    ;Mostrar mensaje de la resta 
    mov eax,line_result
    call print_string
    call print_nl
    mov eax,name
    call print_string
    mov eax,result_divided
    call print_string
    mov eax,[number1]
    call print_int
    mov eax,divided_signe
    call print_string
    mov eax,[number2]
    call print_int
    mov eax,result_general
    call print_string
    mov eax,[result]
    call print_int
    mov eax,result_cotient
    call print_string
    mov eax,[cotient]
    call print_int
    call print_nl
    mov eax,line_result
    call print_string
    call print_nl
    jmp init
nodivided:
    mov eax,validation_zero
    call print_string
    call print_nl 
    call print_nl
    call print_nl
    jmp init

finish:

    popa 
    mov eax, 0
    leave
    ret
