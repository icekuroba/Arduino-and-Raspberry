#include <p16F877A.inc>

    ; --- Obtiene la representacion en diplay de un numero
    ;     y la muestra en la salida
    mostrarNumero macro numero, salida
        movfw numero; Pasamos las unidades a w
        call TABLA; Obtenemos su presentacion en display
        movwf salida; Lo enviamos a la salida
    endm
    
    dig0 equ h'20'; Guardara el valor de las unidades
    dig1 equ h'21'; Guardara el valor de las decenas

    valor1 equ h'22'; Asigna espacio en memoria para valor1
    valor2 equ h'23'; Asigna espacio en memoria para valor2
    valor3 equ h'24'; Asigna espacio en memoria para valor3
	
    cte1 equ 20h; Asigna valor a la constante 1
    cte2 equ 50h; Asigna valor a la constante 2
    cte3 equ 60h; Asigna valor a la constante 3
    
    org 0
    goto inicio

	org 5

inicio:
    
    bsf STATUS, RP0; RP0 < --- 1
    bcf STATUS, RP1; RP1 < --- 0, acceso a banco de memoria 01
    movlw b'000001'
    movwf TRISC; Selecciona el bit mas bajo del puerto C como entrada
    clrf TRISB; Selecciona el puerto B como salida (decenas)
	clrf TRISD; Selecciona el puerto D como salida (unidades)
	bcf STATUS, RP0; RP0 <--- 0, regreso al banco de memoria 00
	clrf PORTB; limpieza del puerto B
    clrf PORTD; limpieza del puerto D
    clrw; limpieza de W
	movlw 0x02
	movwf dig0; Se inician las unidades en 0
	movlw 0x09
	movwf dig1; Se inician las decenas en 0

loop:

    call RETARDO; Espera entre conteos
    btfsc PORTC, 0; Tomamos la direccion del conteo
    goto sube_U; Incrementa en 1 las unidades
    goto baja_U; Disminuye en 1 las unidades

sube_U:

    movfw dig0; w <-- Unidades
    sublw 0x09; Revisamos si su valor es 9
    btfsc STATUS, Z; De serlo, aumentamos las decenas
    goto sube_D; Incrementa en 1 las unidades
    incf dig0, 1; Aumenta en 1 las unidades
    goto muestra; Actualiza el valor en display

sube_D:

    clrf dig0; Las unidades se vuelven cero
    incf dig1; Incrementamos las decenas
    movfw dig1; w <-- decenas
    sublw 0x0A; Revisamos si el valor es 10
    btfsc STATUS, Z; Omitimos de no serlo
    clrf dig1; Las decenas se vuelven 0
    goto muestra; Actualiza el valor en display

baja_U:

    movfw dig0; w <-- Unidades
    xorlw 0x00; Revisamos si su valor es 0
    btfsc STATUS, Z; De serlo, disminuimos las decenas
    goto baja_D; Incrementa en 1 las unidades
    decf dig0; Disminuye en 1 las unidades
    goto muestra; Actualiza el valor en display

baja_D:

    movlw 0x09; w <-- 9
    movwf dig0; Las unidades se vuelven nueve
    movfw dig1; w <-- Decenas
    xorlw 0x00; Revisamos si su valor es 0
    btfsc STATUS, Z; De serlo, el valor de w cambia
    movlw 0x0A; w <-- 10
    movwf dig1; dig1 <-- w
    decf dig1, 1; se disminuye su valor

muestra:

    ; Actualicamos la representacion de las salidas
    mostrarNumero dig0, PORTD; Unidades
    mostrarNumero dig1, PORTB; Decenas
    goto loop; Volvemos a la ejecucion 

; --- Genera un retardo de 250 ms
RETARDO

    MOVLW cte1
    MOVWF valor1; Coloca constante 1 en valor1

tres:

    MOVLW cte2
    MOVWF valor2; Coloca constante 2 en valor2

dos:

    MOVLW cte3
    MOVWF valor3; Coloca constante 3 en valor3

uno:

    decfsz valor3; Decrementa valor1 hasta llegar a 0
    goto uno; Mientras valor1 =/= 0, vuelve a etiqueta uno
    decfsz valor2; Decrementa valor2 hasta llegar a 0
    goto dos; Mientras valor2 =/= 0, vuelve a etiqueta dos
    decfsz valor1; Decrementa valor3 hasta llegar a 0
    goto tres; Mientras valor3 =/= 0, vuelve a etiqueta tres
    return; Termina el retrado cuando todos los valores son 0

return

; --- Coloca en W el numero segun el valor del contador
TABLA

    andlw 0x0F; Se elimina la parte alta
    addwf PCL, F; se desplaza segun el numero ingresado
    
    ; --- Se devuelve la representacion del numero
    retlw 0x3F; 0
    retlw 0x06; 1
    retlw 0x5B; 2
    retlw 0x4F; 3
    retlw 0x66; 4
    retlw 0x6D; 5
    retlw 0x7D; 6
    retlw 0x87; 7
    retlw 0x7F; 8
    retlw 0x67; 9
    retlw 0x77; A
    retlw 0x7C; B
    retlw 0x39; C
    retlw 0x5E; D
    retlw 0x79; E 
    retlw 0x71; F


end;