processor 16f877
include <p16f877.inc>

; Definición de variables
posicion EQU 0x20 ; Variable para controlar la posición del LED encendido
contador EQU 0x21 ; Contador para el retardo

valor1 EQU H'24' ; Variables para el retardo
valor2 EQU H'25'
valor3 EQU H'26'

cte1 EQU 20H  ; Constantes para el retardo
cte2 EQU 35H
cte3 EQU 50H

ORG 0x00
GOTO INICIO

; --- Inicio del Programa ---
INICIO:
    BSF STATUS, RP0 ; Cambio a banco 1
    MOVLW 0x06 ; Configura puertos A y E como digitales
    MOVWF ADCON1
    MOVLW 0xFF ; Configura PORTA como entrada
    MOVWF TRISA
    CLRF TRISB ; Configura PORTB como salida
    BCF STATUS, RP0 ; Cambio a banco 0

    CLRF posicion ; La posición inicia en 0 (primer LED)
    MOVLW B'00000001' ; Comenzar con el primer LED encendido
    MOVWF PORTB

; --- Bucle Principal ---
CICLO:
    MOVF PORTA, W ; Leer el estado de PORTA
    ANDLW 0x03 ; Mantener solo los dos bits menos significativos (RA0 y RA1)

    ; Verificar el valor de PORTA para seleccionar la función
    MOVLW 0x00 ; Valor binario 00 para Parpadeo a 1 Hz
    XORWF PORTA, W
    BTFSC STATUS, Z
    CALL PARPADEO_1HZ

    MOVLW 0x01 ; Valor binario 01 para Contador Binario Ascendente
    XORWF PORTA, W
    BTFSC STATUS, Z
    CALL CONTADOR_BINARIO

    MOVLW 0x02 ; Valor binario 10 para Secuencia Personalizada
    XORWF PORTA, W
    BTFSC STATUS, Z
    CALL SECUENCIA_PERSONALIZADA

    MOVLW 0x03 ; Valor binario 11 para Encender y apagar LEDs secuencialmente
    XORWF PORTA, W
    BTFSC STATUS, Z
    CALL ENCENDER_APAGAR_LEDS

    GOTO CICLO

; --- Subrutinas ---

; Subrutina de parpadeo a 1 Hz
PARPADEO_1HZ:
    BSF PORTB, 0 ; Prende el LED en RB0
    CALL RETARDO_500MS
    BCF PORTB, 0 ; Apaga el LED en RB0
    CALL RETARDO_500MS
    RETURN

; Subrutina del contador binario ascendente
CONTADOR_BINARIO:
    MOVF contador, W       ; Cargar el valor actual del contador
    MOVWF PORTB            ; Mostrar el valor del contador en PORTB
    CALL RETARDO_1S        ; Retardo de 1 segundo
    INCF contador, F       ; Incrementa el contador en 1
    MOVF contador, W       ; Cargar el valor del contador después del incremento
    ANDLW B'11111111'      ; Asegurar que solo se consideren los primeros 7 bits (0 a 127)
    MOVWF contador         ; Guardar el valor ajustado del contador
    RETURN

; Subrutina de la secuencia personalizada con retardos entre 500 ms y 1 s
SECUENCIA_PERSONALIZADA:
    BSF PORTB, 0 ; Enciende el LED1
    CALL RETARDO_500MS
    BCF PORTB, 0 ; Apaga el LED1

    BSF PORTB, 1 ; Enciende el LED2
    CALL RETARDO_700MS
    BCF PORTB, 1 ; Apaga el LED2

    BSF PORTB, 2 ; Enciende el LED3
    CALL RETARDO_1S
    BCF PORTB, 2 ; Apaga el LED3
    RETURN

; Subrutina para encender y apagar LEDs secuencialmente
ENCENDER_APAGAR_LEDS:
    MOVF posicion, W ; Obtener la posición actual
    MOVWF PORTB ; Encender el LED correspondiente
    CALL RETARDO_100MS ; Esperar 100 ms
    INCF posicion, F ; Incrementar la posición para el próximo LED
    MOVLW B'00000001'
    MOVWF PORTB ; Resetear a la primera posición después de encender todos los LEDs
    BTFSS STATUS, Z ; Verificar si la posición es mayor a 7 (0 a 7 para 8 LEDs)
    GOTO CICLO
    CLRF posicion ; Reiniciar la posición
    RETURN

; Rutina de retardo de 500 ms
RETARDO_500MS:
    MOVLW cte1
    MOVWF valor1
RETARDO_LOOP1:
    MOVLW cte2
    MOVWF valor2
RETARDO_LOOP2:
    MOVLW cte3
    MOVWF valor3
RETARDO_LOOP3:
    DECFSZ valor3, F
    GOTO RETARDO_LOOP3
    DECFSZ valor2, F
    GOTO RETARDO_LOOP2
    DECFSZ valor1, F
    GOTO RETARDO_LOOP1
    RETURN

; Rutina de retardo de 1 segundo
RETARDO_1S:
    MOVLW D'250'
    MOVWF valor1
    MOVLW D'250'
    MOVWF valor2
RETARDO_1S_LOOP:
    DECFSZ valor1, F
    GOTO RETARDO_1S_LOOP
    DECFSZ valor2, F
    GOTO RETARDO_1S_LOOP
    RETURN

; Rutina de retardo de 700 ms
RETARDO_700MS:
    MOVLW D'175'
    MOVWF valor1
    MOVLW D'175'
    MOVWF valor2
RETARDO_700MS_LOOP:
    DECFSZ valor1, F
    GOTO RETARDO_700MS_LOOP
    DECFSZ valor2, F
    GOTO RETARDO_700MS_LOOP
    RETURN

; Rutina de retardo de 100 ms
RETARDO_100MS:
    MOVLW D'100'
    MOVWF valor1
RETARDO_100MS_LOOP:
    DECFSZ valor1, F
    GOTO RETARDO_100MS_LOOP
    RETURN

FIN:
    END