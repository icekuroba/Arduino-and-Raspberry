#INCLUDE <P16F877A.INC>		;LIBRERIA CON DEFICIONES PARA EL MICRO UTILIZADO
VALOR1 EQU h'21'	;Asigna espacio en memoria para valor1
VALOR2 EQU h'22'	;Asigna espacio en memoria para valor2
VALOR3 EQU h'23'	;Asigna espacio en memoria para valor3
CONST1 EQU H'20'		;Asigna espacio en memoria para la constante 1
CONST2 EQU H'50'		;Asigna espacio en memoria para la constante 2
CONST3 EQU H'60'		;Asigna espacio en memoria para la constante 3

	ORG 0			;DIRECCIÓN DEL VECTOR DE RESET
	GOTO INICIO		;SALTO A LA DIRECCION DE ROM DE LA ETIQUETA INICIO

	ORG 5			;LAS SIGUIENTES INSTRUCCIONES SE ENSAMBLARÁN A PARTIR
INICIO:
	BSF STATUS,RP0  ;RPO<--1
	BCF STATUS,RP1	;RP1<--0, CAMBIO AL BANCO 1 DE RAM
	CLRF TRISB		;LOS PINES DEL PUERTO B SERÁN SALIDAS
	CLRF TRISD		;LOS PINES DEL PUERTO D SERÁN SALIDAS
	BCF STATUS,RP0	;REGRESA AL BANCO 0 DE RAM
	CLRF PORTB		;Limpieza el puerto B
	CLRF PORTD		;Limpieza el puerto D
	MOVLW H'38'		;w<--H'38', Trabajar con un bus de datos de 8 bits.
	CALL CONTROL	;Llama a la subrutina control
	MOVLW H'0C'		;w<--H'0C', Enciende el LCD, apaga el cursor y su parpadeo
	CALL CONTROL	;Llama a la subrutina control
	MOVLW H'01'		;w<--H'01', Limpia la pantalla del LCD y sitúa al cursor a la primer posición
	CALL CONTROL	;Llama a la subrutina control
	
LOOP
	MOVLW	H'48'	;w<--H'48', Carga el valor ASCII de H
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'4F'	;w<--H'4F', Carga el valor ASCII de O
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'4C'	;w<--H'4C', Carga el valor ASCII de L
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'41'	;w<--H'41', Carga el valor ASCII de A
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'2C'	;w<--H'2C', Carga el valor ASCII de una coma
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'20'	;w<--H'20', Carga el valor ASCII de un espacio
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'4D'	;w<--H'4D', Carga el valor ASCII de M
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'55'	;w<--H'55', Carga el valor ASCII de U
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'4E'	;w<--H'4E', Carga el valor ASCII de N
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'44'	;w<--H'44', Carga el valor ASCII de D
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	H'4F'	;w<--H'4F', Carga el valor ASCII de O
	CALL DATO		;Llama a la subrutina DATO
	MOVLW	"!"	;w<--H'33', Carga el valor ASCII de ! (admiración)
	CALL DATO		;Llama a la subrutina DATO
	CALL RETARDO	;Llama a la subrutina RETARDO
	MOVLW H'01'		;w<--H'01', Limpia la pantalla del LCD y sitúa al cursor a la primer posición
	CALL CONTROL	;Llama a la subrutina control
	CALL RETARDO	;Llama a la subrutina RETARDO
	GOTO LOOP

DATO
	BSF PORTB,0		;Pone un 1 en el bit 0 del puerto B para mandar datos al LCD
	GOTO CARGA

CONTROL BCF PORTB,0	;Pone un 0 en el bit 0 del puerto B para mandar una instruccion de control al LCD
CARGA MOVWF PORTD	;Mueve el valor que se quiere cargar al puerto D
	BSF PORTB,1		;Encender el Enable, conectado al bit 1 del puerto B
	CALL RETARDO	;Llamada a la rutina del retardo
	BCF PORTB,1		;Apagar el Enable del LCD
	CALL RETARDO	;Llamada a la rutina del retardo
	RETURN

RETARDO: ;RETARDO DE 500 ms PARA LOS VALORES DE CARGA ESPECIFICADOS 
	MOVLW  CONST1
	MOVWF  VALOR1
TRE MOVLW  CONST2
	MOVWF  VALOR2		;
DOS MOVLW  CONST3		;
	MOVWF  VALOR3		; SUBRUTINA DE RETARDO 
UNO DECFSZ VALOR3		; DE TRES NIVELES
	GOTO   UNO			; 
	DECFSZ VALOR2		;
	GOTO   DOS
	DECFSZ VALOR1
	GOTO   TRE
	RETURN				;RETORNO DE SUBRUTINA


	END			;EL CODIGO DESPUÉS DE ESTA LÍNEA NO SERÁ ENSAMBLADO
		
