handler_USART_receive:
	push temp
	in temp, sreg
    push temp

    ; Leer el dato
    rcall USART_receive

    ; Chequear estar en ESTADO_REPOSO, si no lo esta, entonces se ignora la entrada
    cpi estado, ESTADO_REPOSO
    brne salir_handler_USART_recieve

    ; verificar que sea el correcto
    cpi data_input, LETRA_INICIO_MEDICION
    brne salir_handler_USART_recieve
    ldi estado, ESTADO_MEDIR

salir_handler_USART_recieve:
    pop temp
	out sreg, temp
	pop temp
    reti 

/*
 * Verifica si fue por flanco ascendente o descendente
 * Si fue ascendente inicia el timer para el echo y cambia el estado a ESTADO_ECHO
 * Si fue descendente mide la distancia y cambia el estado a ESTADO_GUARDAR_DATA
 */
handler_PCI0:
	push temp
	in temp, sreg
    push temp

    ; Verificacion del pinb 0
	sbis pinb, 0
    rjmp fin_echo

    ldi estado, ESTADO_CONTAR_ECHO
    rjmp salir_handler_PCI0
    
fin_echo:
    rcall frenar_timer0
    ldi estado, ESTADO_GUARDAR_DATA

salir_handler_PCI0:
    pop temp
	out sreg, temp
	pop temp
    reti


/*
 * Verificia por que termino de contar
 * Si termino en estado trigger, pone un 0 en el trigger
 * Si termino por estado echo aumenta el contador
 */
handler_timer0:
	push temp
	in temp, sreg
    push temp

    cpi estado, ESTADO_TRIGGER
    brne  incrementar_contador_echo
    rcall frenar_timer0
    cbi PORTB, PINB2 ; poner en bajo el pin de trigger
    ldi estado, ESTADO_MIDIENDO
    rjmp salir_handler_timer0

incrementar_contador_echo:
	inc contadorl
	cpi contadorl,0x00
	breq carry ; El contadorl llego a su maximo, entonces se debe incrementar el contadorh
    rjmp salir_handler_timer0
	
carry:
	inc contadorh

salir_handler_timer0:
    pop temp
	out sreg, temp
	pop temp
    reti

/*
 * Verifica si esta contando tiempo entre mediciones del servo o tiempo de apuntado del laser
 * Si finalizo el tiempo de apuntar, cambia el estado a ESTADO_RESET
 * Si finalizo el tiempo entre mediciones, cambia el estado a ESTADO_MOVER_SERVO
 */
handler_timer2:
	push temp
	in temp, sreg
	push temp
	push templ

    cpi estado, ESTADO_APUNTANDO
    breq timer_laser

    ldi templ, MAX_CONTADOR_SERVO
    cp contador_timer2, templ
    breq fin_timer_servo
    inc contador_timer2
    rjmp salir_handler_timer2

fin_timer_servo:
    rcall frenar_timer2
    ldi estado, ESTADO_MOVER_SERVO
	clr contador_timer2

timer_laser:
    cpi contador_timer2, MAX_CONTADOR_LASER
    breq fin_timer_laser
    inc contador_timer2
    rjmp salir_handler_timer2

fin_timer_laser:
    rcall frenar_timer2
    clr contador_timer2
    ldi estado, ESTADO_RESET
salir_handler_timer2:
	pop templ
	pop temp
	out sreg, temp
	pop temp    
    reti