.include "m328pdef.inc"

/*
 * EQUS DE ESTADOS
 */
 
.equ    BIT_ESTADO_TRIGGER  =   0 ; bit 0 -> indica trigger
.equ    BIT_ESTADO_ECHO     =   1 ; bit 1 -> indica echo
.equ    BIT_ESTADO_ACCION   =   2 ; bit 2 -> indica que hay que hacer una accion
.equ    BIT_ESTADO_MIDIENDO =   3 ; bit 3 -> estado midiendo
.equ    BIT_ESTADO_DATA     =   4 ; bit 4 -> guardar datos
.equ    BIT_ESTADO_SERVO    =   5 ; bit 5 -> mover servo
.equ    BIT_ESTADO_PROCESAR =   6 ; bit 6 -> procesar los datos
.equ    BIT_ESTADO_APUNTAR  =   7 ; bit 7 -> aapuntar el laser

.equ ESTADO_REPOSO = 0x00
.equ ESTADO_RESET = 0b0000_0100
.equ ESTADO_MIDIENDO = 0b0000_1000
.equ ESTADO_MEDIR = 0b0000_1100
.equ ESTADO_MANDAR_TRIGGER = 0b0000_1101
.equ ESTADO_CONTAR_ECHO = 0b0000_1110
.equ ESTADO_TRIGGER = 0b0000_1001
.equ ESTADO_ECHO = 0b0000_1010
.equ ESTADO_GUARDAR_DATA = 0b0001_1100
.equ ESTADO_MOVER_SERVO = 0b0010_1100
.equ ESTADO_PROCESAR = 0b0100_0100
.equ ESTADO_APUNTAR = 0b1000_0100
.equ ESTADO_APUNTANDO = 0b1000_0000

/*
 * EQUS  DE MOTOR
 */
.equ TOP = 20000 ; da el periodo del timer 1, T = 20ms
.equ POSICION_INICIAL = 500
.equ MAX_OCR1A =  2500
.equ CANT_STEPS = 20
.equ STEP = 2000/CANT_STEPS
.equ MAX_CONTADOR_SERVO = 10
.equ MAX_CONTADOR_LASER = 183 ; 3 segundos

/*
 * EQUS DE SENSOR DE ULTRASONIDO
 */
.equ LETRA_INICIO_MEDICION = 's'
.equ TOP_TRIGGER = 159 ; tope para OCRA cuadno buscamos generar 10us
.equ TOP_ECHO = 93 ; genera interrupciones cada el tiempo que el sonido recorre 1mm (ida y vuelta)

; Alias def
.def    contador_timer2 = r17
.def    data_output = r18
.def    data_input = r19
.def    templ = r20
.def    temph = r21
.def    temp = r22
.def    estado = r23
.def    contadorh = r24
.def    contadorl = r25

.dseg
.org SRAM_START

; Variables
mediciones:      .byte   (CANT_STEPS+1)*2 ; cada punto medido tiene dos bytes
posicion_minima: .byte   3 ;|posicion|distancia(alta)|distancia(baja)
dato_ascii:      .byte 5
dato_convertir:  .byte 2

.cseg
.org 0x0000
	rjmp main
.org PCI0addr
    rjmp handler_PCI0
.org OC0Aaddr 
    rjmp handler_timer0
.org OVF2addr
    rjmp handler_timer2
.org URXCaddr
    rjmp handler_USART_receive

.org INT_VECTORS_SIZE

main:
	ldi r16,HIGH(RAMEND)
	out sph,r16
	ldi r16,LOW(RAMEND)
	out spl,r16


    rcall inicializar_puertos
    rcall inicializar_interrupciones
    rcall inicializar_timer0
    rcall inicializar_timer1
    rcall inicializar_timer2
    rcall USART_init

    ldi estado, ESTADO_REPOSO

    rcall configurar_sleep

    ; Habilitacion de interrupciones globales
    sei

main_loop:
	in templ, SMCR
	ori templ, (1<<SE)
    sleep
	andi templ, ~(1<<SE)
	out SMCR, templ

    ; Se ejecuto alguna int, se fija en que estado esta
    cpi estado, ESTADO_REPOSO
    breq main_loop

    sbrs estado, BIT_ESTADO_MIDIENDO ; se fija si esta midiendo
    rjmp chequear_procesar
    
    ; Esta midiendo, se fija que tiene que hacer
    sbrs estado, BIT_ESTADO_ACCION
    rjmp main_loop

    cpi estado, ESTADO_MEDIR
    brne continuar_medicion
    
    ; inicia la medicion
    ldi xl, LOW(mediciones)
    ldi xh, HIGH(mediciones)

	ldi estado,ESTADO_MANDAR_TRIGGER

continuar_medicion:
    sbrs estado, BIT_ESTADO_TRIGGER ; se fija si tiene que empezar a contar echo o mandar el trigger
    rjmp chequear_echo

    rcall generar_trigger
    rcall iniciar_timer2
    rjmp main_loop

chequear_echo:
	sbrs estado, BIT_ESTADO_ECHO
	rjmp chequear_guardar_data

    rcall contar_echo
    rjmp main_loop

chequear_guardar_data: ; chequear si hay que mover el servo o guardar los datos
    sbrs estado, BIT_ESTADO_DATA
    rjmp chequear_estado_servo

    ;hay que guardar los datos
    rcall guardar_datos

chequear_estado_servo:
    sbrs estado,BIT_ESTADO_SERVO
    rjmp main_loop

    ; chequer no estar al final
    lds templ, ocr1al
	lds temph, ocr1ah
	ldi temp,  HIGH(MAX_OCR1A)
	cpse temph,	temp
	rjmp aumentar_servo
	ldi temp, LOW(MAX_OCR1A)
	cpse templ, temp
	rjmp aumentar_servo
    
    ; esta al final, cambia de estado y procesa
    ldi estado,ESTADO_PROCESAR
    rjmp chequear_procesar
    
aumentar_servo:
    rcall mover_servo
    ldi estado, ESTADO_MANDAR_TRIGGER
    rjmp main_loop
    
chequear_procesar:
	; procesa y envia datos
    cpi estado,ESTADO_PROCESAR
    brne chequear_apuntando
    rcall procesar_datos
    rcall enviar_datos
    ldi estado, ESTADO_APUNTAR
    rjmp chequear_apuntando
    rjmp main_loop

chequear_apuntando:
    sbrs estado, BIT_ESTADO_APUNTAR
    brne chequear_reset 

    cpi estado, ESTADO_APUNTAR
    brne main_loop ; esta apuntando y esperando
    rcall apuntar_laser

	ldi estado, ESTADO_APUNTANDO
    rjmp main_loop

chequear_reset:
    cpi estado, ESTADO_RESET
    brne main_loop

    rcall reset
    rjmp main_loop

.include "Rutinas.asm"
.include "Inicializaciones.asm"
.include "Interrupciones.asm"

tabla_posicion: .db "Posicion: ", 0x00
tabla_distancia: .db "Distancia: ", 0x00
dato_resta:	.db HIGH(10000),LOW(10000),HIGH(1000),LOW(1000),HIGH(100),LOW(100),HIGH(10),LOW(10),HIGH(1),LOW(1)