inicializar_puertos:
	in temp,DDRB
	andi templ, ~(1<<PINB0) ; configurar entrada (PB0 echo US)
	ori templ,(1<<PINB1)|(1<<PINB2) ;configurar como salida (PB1 servo, PB2 trigger US)
	out DDRB,templ

	in templ,PORTB
	andi templ,~((1<<PINB1)|(1<<PINB2)) ; inicializar salidas en 0
	out PORTB,templ

    in templ, DDRD
    ori templ, (1<<PIND7) ; configurar como salida (PD7 laser)
    out DDRD, templ

	in templ,PORTD
	andi templ,~(1<<PIND7) ; inicializar salidas en 0 (PD7 laser)
	out PORTD,templ

    ret

inicializar_interrupciones:
    ; configurar PB0 como interrupcion PC
    lds templ, PCICR
    ori templ,(1<<PCIE0)
	sts	PCICR, templ
    lds templ, PCMSK0
    ori templ,(1<<PCINT0)
	sts PCMSK0, templ
    ret

/*
 * Timer 0 se usa para contar el pulso de trigger, y para contar la duracion del echo
 */
inicializar_timer0:
	; habilitar interrupcion por comparacion con A
	lds templ, timsk0
	ori templ, (1<<OCIE0A)
	sts timsk0, templ

    ; inicializar timer0 en modo CTC
	in templ, tccr0A
	andi templ, ~((1<<wgm00)|(1<<COM0A1))
    ori templ, (1<<wgm01)|(1<<COM0A0)
	out tccr0A, templ

	in templ, tccr0B
	andi templ, ~(1<<wgm02)
	out tccr0B, templ
    ret

/*
 * Timer 1 se utiliza para generar el PWM que recibe el servo
 * Inicialmente la frecuencia es tal que el servo este en 0 grados
 */
inicializar_timer1:
	push templ
	push temph
	push temp

	; cargar maximo ICR1 = TOP
	ldi temph,HIGH(TOP)
	ldi templ,LOW(TOP)
	; guardar global interrupt flag
	in temp,SREG
	; deshabilitar  interrucioness
	cli
	sts ICR1H,temph
	sts ICR1L,templ
	out SREG,temp

	; cargar comparador OCR1A = POSICION_INICIO Ton=0.5ms -> 0° 
	ldi templ,LOW(POSICION_INICIAL)
	ldi temph,HIGH(POSICION_INICIAL)
	in temp, sreg
	cli
	sts ocr1ah, temph
	sts ocr1al, templ
	out sreg, temp


	lds templ,TCCR1A
	ori templ,(1<<COM1A1) ; configurar OC1A clear when up, set when down 
	andi templ,0b10001100 ; configurar toggle de OC1A y fase correcta
	sts TCCR1A,templ
	
	lds templ,TCCR1B
	ori templ,(1<<WGM13)|(1<<CS11) ; configurar fase correcta
	andi templ,0b11110010 ; configurar fase correcta y prescaler 8
	sts TCCR1B,templ

	pop temp
	pop temph
	pop templ
	ret


/*
 * Timer 2 se usa para contar el timepo entre mediciones hasta mover el servo
 * y para contar el timepo durante el cual se esta apuntando con el laser
 */
inicializar_timer2:
	; habilitar interrupcion por overflow TIM2
	lds templ, timsk2
	ori templ, (1<<TOIE2)
	sts timsk2, templ

    ; inicializar timer2 en modo NORMAL
	lds templ, tccr2A
	andi templ, ~((1<<wgm20)|(1<<wgm21))
	sts tccr2A, templ

	lds templ, tccr2B
	andi templ, ~(1<<wgm22)
	sts tccr2B, templ

    clr contador_timer2
    ret


USART_Init:
    push templ
    push temph

    ; Baud rate = 9600
    ldi temph, 0xF0
    lds templ, UBRR0H
    and temph, templ
    sts UBRR0H, temph

    ldi templ, 103
    sts UBRR0L, templ

    ; habilitar interrupicion reciever

    ldi templ, (1<<RXEN0)|(1<<RXCIE0)|(1<<TXEN0)
    sts UCSR0B,templ

    ; Formato Asincronico, 8 data, 1 stop bit
    ldi templ, (1<<USBS0)|(3<<UCSZ00)
    sts UCSR0C,templ

    pop temph
    pop templ
    ret

configurar_sleep:
	; Modo de sleep: Power-Save
	in templ,SMCR
	andi templ,~((1<<SM2))
	ori templ, (1<<SM1)|(1<<SM0)
	out SMCR, templ
	
	ret