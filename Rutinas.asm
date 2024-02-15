frenar_timer0:
    push templ
    in templ, TCCR0B
	andi templ, ~((1<<cs02)|(1<<cs01)|(1<<cs00))
	out TCCR0B, templ
    clr templ
    out TCNT0, templ
    pop templ

    ret

frenar_timer2:
    push templ
	lds templ, TCCR2B
	andi templ, ~((1<<cs22)|(1<<cs21)|(1<<cs20))
	sts TCCR2B, templ
    pop templ
    ret

/*
 * Inicia el Timer 2 con prescaler 1024
 */
iniciar_timer2:
    clr templ
    sts TCNT2, templ

    lds templ, TCCR2B
	ori templ, (1<<CS22)|(1<<CS21)|(1<<CS20)
	sts TCCR2B, templ
    ret

/*
 * Pone en alto el pin de trigger e inicia el timer0 preescaler 1
 * y configura el tope para contar hasta 10us
 */
generar_trigger:

    sbi PORTB,PINB2
    ldi estado, ESTADO_TRIGGER

    ; configuracion del tope
    ldi templ, TOP_TRIGGER
    out OCR0A, templ

    ; activar contador (prescaler 1)
	in templ, TCCR0B
	ori templ, (1<<cs00)
	andi templ, ~((1<<cs01)|(1<<cs02))
	out TCCR0B, templ

    ret

/*
 * Inicia el timer0 con prescaler 1 para contar cuanto tiempo estuvo el echo en alto
 */
contar_echo:
	
	clr contadorl
	clr contadorh
    ldi estado, ESTADO_ECHO

    ; configuracion del tope
    ldi templ, TOP_ECHO
    out OCR0A, templ

    ; activar contador (prescaler 1)
	in templ, tccr0B
	ori templ, (1<<cs00)
	andi templ, ~((1<<cs01)|(1<<cs02))
	out tccr0B, templ

    ret

/*
 * Guarda en RAM (mediciones) la parte alta y la parte baja de la medicion
 */
guardar_datos:
    st x+, contadorh
    st x+, contadorl
    ldi estado, ESTADO_MIDIENDO
    ret

/*
 * Aumenta la posicion del servo en un paso
 */
mover_servo:
	ldi temp, STEP

	add templ, temp
	clr temp
	adc temph, temp

	in temp, sreg
	cli
	sts ocr1ah, temph
	sts ocr1al, templ
	out sreg, temp

fin_servo:
	ret

/*
 * Busca el minimo valor en la tabla mediciones y la posicion de ese minimo y lo guarda en posicion minima
 * En caso de tener varios minimos iguales busca el que se encuentra en el medio
 */
procesar_datos:

    ldi xl, LOW(mediciones)
    ldi xh, HIGH(mediciones)

    ; toma el primero como minimo
    ld temph, x+ ; los  minimos siempre los guarda en los temps
    ld templ, x+
    clr contadorl ; guarda el paso actual
    clr contadorh ; guarda el paso minimo
	clr temp ; guarda la cantidad de iguales seguidos 
loop_datos:
    inc contadorl

    cpi contadorl,CANT_STEPS ; 2 veces la cantidad de pasos porque cada paso tiene parte alta y baja
    breq fin_loop_datos
    ld r17, x+ ; lo usa para avanzar en la tabla
    ld r16, x+

    cp temph, r17
    brlo loop_datos
	cp r17, temph
    brlo cambiar_minimo

    cp templ, r16
    brlo loop_datos
	cp r16, templ
    brlo cambiar_minimo

	; sino, son iguales 
	; carga el minimo
    mov templ, r16
    mov temph, r17
	
	;sigue avanzando con el puntero y para buscar si hay mas iguales
	mov yl,xl
	mov yh,xh

loop_iguales:
	inc temp
	cpi contadorl,CANT_STEPS 
    breq fin_loop_datos_en_igual

	ld r17,y+
	ld r16,y+
	cp temph, r17
	brne fin_iguales

	cp templ,r16
	brne fin_iguales

	; nuevamente es igual
	inc contadorl
	rjmp loop_iguales

; sirve si termina la tabla mientra se esta en el loop de iguales
fin_loop_datos_en_igual:
	lsr temp ; divide temp por dos para encontrar el medio
	mov contadorh, contadorl
	sub contadorh,temp
	rjmp fin_loop_datos

fin_iguales:
	lsr temp ; divide temp por dos para encontrar el medio
	mov contadorh, contadorl
	sub contadorh,temp
	clr temp
	subi yl,0x02
	sbc yh,temp

	; posiciona los punteros al ultimo que fue igual
	mov xl,yl
	mov xh,yh

	rjmp loop_datos

cambiar_minimo:
    mov contadorh, contadorl
    mov templ, r16
    mov temph, r17

	rjmp loop_datos

fin_loop_datos:
	
    ldi xl, LOW(posicion_minima)
    ldi xh, HIGH(posicion_minima)

    st x+, contadorh
    st x+, temph
    st x, templ
    ret

/*
 * Envia todos los datos de las mediciones, primero la parte alta, luego la parte baja
 * Luego de todas las mediciones envia la posicion del minimo y luego su valor (parte alta y baja)
 */
enviar_datos:
    push contadorh
	ldi xl, LOW(mediciones)
    ldi xh, HIGH(mediciones)

    ldi contadorh, CANT_STEPS + 1
loop_enviar:
    dec contadorh
    cpi contadorh, 0X00
    breq fin_enviar_datos

    ld data_output,x+
	rcall USART_transmit

	ld data_output,x+
	rcall USART_transmit

    rjmp loop_enviar
fin_enviar_datos:
	ldi xl, LOW(posicion_minima)
    ldi xh, HIGH(posicion_minima)

	ld data_output,x+
	rcall USART_transmit
	ld data_output,x+
	rcall USART_transmit
	ld data_output,x
	rcall USART_transmit

    rcall enviar_ascii

    pop contadorh
    ret

/*
 * Busca la posicion del minimo en la tabla y mueve el servo a esa posicion
 * Prende el laser 
 */
apuntar_laser:
	ldi xl, LOW(posicion_minima)
	ldi xh, HIGH(posicion_minima)

    ld temp, x+ ; guarda la posicion del minimo en temp
    ldi temph, STEP

    
    mul temp, temph ; parte baja en r0 y parte alta en r1

    ldi templ, LOW(POSICION_INICIAL)
	ldi temph, HIGH(POSICION_INICIAL)

    add r0, templ
    adc r1, temph

    ; cargar en OCR1A
    in temp, sreg
    cli
    sts OCR1AH, r1
    sts OCR1AL, r0
    out sreg, temp

    ; prender laser
    sbi portd, PORTD7

    ; iniciar timer2
    clr contador_timer2
    rcall iniciar_timer2

    ret


USART_Transmit:
	push templ
loop_transmit:
    ; Esperar a que el buffer este vacio
    lds templ, UCSR0A
    sbrs templ, UDRE0
    rjmp loop_transmit
    ; Poner data_output en el buffer, enviar los datos
    sts UDR0,data_output
	pop templ
    ret

USART_receive:
    ; Esperar a que los datos sean recibidos
    lds templ, UCSR0A
    sbrs templ, RXC0
    rjmp USART_Receive
    ; Obtener y devolver los datos del buffer
    lds data_input, UDR0
    ret

/*
 * Vuelve al estado inicial el servo y apaga el laser
 */
reset:
    ; apagar el laser
    cbi portd, PORTD7
    ; volver al servo a la posicion inicial
    ldi templ,LOW(POSICION_INICIAL)

	ldi temph,HIGH(POSICION_INICIAL)
	in temp, sreg
	cli
	sts ocr1ah, temph
	sts ocr1al, templ
	out sreg, temp

    ldi estado, ESTADO_REPOSO
    ret

enviar_ascii:
    ldi zl,LOW(tabla_posicion<<1)
	ldi zh,HIGH(tabla_posicion<<1)
mandar_tabla_posicion_ascii:
	lpm data_output,Z+
	cpi data_output,0x00
	breq mandar_posicion_ascii
    rcall USART_Transmit
    rjmp mandar_tabla_posicion_ascii
    
mandar_posicion_ascii:
    ; leer el minimo
    ldi xl,LOW(posicion_minima)
	ldi xh,HIGH(posicion_minima)

    ldi yl, LOW(dato_convertir)
    ldi yh, HIGH(dato_convertir)

    clr temp
    st y+, temp

    ld temp, x+
    st y+, temp

    rcall hex_a_ascii

    ldi yl, LOW(dato_ascii)
    ldi yh, HIGH(dato_ascii)

    ; solo interesan los ultimos 2 digitos entonces se avanza el puntero
    ld temp, y+
    ld temp, y+
    ld temp, y+

    ld data_output, y+
    rcall USART_transmit
    
    ld data_output, y+
    rcall USART_transmit

    ldi zl,LOW(tabla_distancia<<1)
    ldi zh,HIGH(tabla_distancia<<1)
mandar_tabla_distancia_ascii:
	lpm data_output,Z+
	cpi data_output,0x00
	breq mandar_distancia_ascii
    rcall USART_Transmit
    rjmp mandar_tabla_distancia_ascii
    
mandar_distancia_ascii:

    ldi yl, LOW(dato_convertir)
    ldi yh, HIGH(dato_convertir)

    ld temp, x+ ; leer y guardar la parte alta
    st y+, temp

    ld temp, x+ ; leer y guardar la parte baja
    st y+, temp

    rcall hex_a_ascii

    ldi yl, LOW(dato_ascii)
    ldi yh, HIGH(dato_ascii)

    ldi contadorh, 6 ; son 5 digitos los que hay que mandar
loop_enviar_distancia_ascii:

    dec contadorh
    cpi contadorh, 0x00
    breq salir_enviar_ascii
    
    ld data_output, y+
    rcall USART_transmit

    rjmp loop_enviar_distancia_ascii

salir_enviar_ascii:
    ret

hex_a_ascii:
    push xl
    push xh
    push yl
    push yh
    push zl
    push zh

    ldi xl, LOW(dato_convertir)
    ldi xh, HIGH(dato_convertir)
    ld temph,x+
    ld templ,x

	clr r4 ; contador
    ldi zl, LOW(dato_resta<<1)
    ldi zh, HIGH(dato_resta<<1)
    ldi yl, LOW(dato_ascii)
    ldi yh, HIGH(dato_ascii)

cargar_datos:
	clr r1
    lpm r3,z+
    lpm r2,z+
	ldi temp,5
	cp r4,temp
	breq fin_conversion
loop_resta:
    sub templ,r2
    sbc temph,r3
    in temp, sreg
    sbrc temp,SREG_C
	rjmp siguiente
    inc r1
    rjmp loop_resta
siguiente:
	ldi temp, 0x30
    add r1, temp
	st y+,r1
	add templ, r2
	adc temph, r3
	inc r4
	rjmp cargar_datos
fin_conversion:
    pop zh
    pop zl
    pop yh
    pop yl
    pop xh
    pop xl
	ret	