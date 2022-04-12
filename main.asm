;
; 7_Segment_LED.asm
;
; Created: 06.08.2020 16:10:17
; Author : Mamarasulov Z.
;


; Replace with your application code
.org $000
	rjmp INIT
;==============================INITIALIZE==============================
INIT: 
	ldi r16, LOW(RAMEND)
	out SPL, r16
	ldi r16, HIGH(RAMEND)
	out SPH, r16

	ldi r16, (1 << PB0)
	out DDRB, r16

	ldi r16, (1 << PA2) | (1 << PA1) | (1 << PA0)
	out DDRA, r16

	ldi r16, (0 << CS02) | (0 << CS01) | (1 << CS00)
	out TCCR0, r16
;==============================MAIN_LOOP===============================
MAIN_LOOP:
	rcall SUBROUTINE_0
	rcall SUBROUTINE_1
	rcall SUBROUTINE_2
	push r17
	push r16
	rcall SUBROUTINE_3
	rcall SUBROUTINE_4
	push r18
	rcall DELAY
	pop r18
	pop r16
	pop r17
	rjmp MAIN_LOOP
;==============================SUBROUTINE_0============================
SUBROUTINE_0:
	inc r16
	cpi r16, 10
	brne PC + 6
	clr r16
	inc r17
	cpi r17, 10
	brne PC + 2
	clr r17
	ret
;==============================SUBROUTINE_1============================
SUBROUTINE_1:
	ldi ZH, HIGH(2 * NUM)
	ldi ZL, LOW(2 * NUM)
	add ZL, r16
	lpm
	mov r1, r0
	ret
;==============================SUBROUTINE_2============================
SUBROUTINE_2:
	ldi ZH, HIGH(2 * NUM)
	ldi ZL, LOW(2 * NUM)
	add ZL, r17
	lpm
	mov r2, r0
	ret
;==============================SUBROUTINE_3============================
SUBROUTINE_3:
	ldi r16, $10
SUBROUTINE_3_:
	sbrc r1, $7
	sbi PORTA, $2
	sbi PORTA, $1
	cbi PORTA, $1
	cbi PORTA, $2
	rol r2
	rol r1
	clc
	dec r16
	brne SUBROUTINE_3_
	sbi PORTA, $0
	cbi PORTA, $0
	ret
;==============================SUBROUTINE_4============================
SUBROUTINE_4:
	ldi r16, $01
	eor r18, r16
	out PORTB, r18
	ret
;===============================DELAY==================================
DELAY:
	ldi r18, $8
LOOP_0:
	ldi r17, $b1
LOOP_1:
	ldi r16, $bb
LOOP_2:
	dec r16
	brne LOOP_2
	dec r17
	nop
	brne LOOP_1
	dec r18
	brne LOOP_0
	ret
;==============================NUMBERS==================================
NUM:  .db $3f, $06, $5b, $4f	; '0', '1', '2', '3'
      .db $66, $6d, $7d, $07	; '4', '5', '6', '7'
      .db $7f, $6f			    ; '8', '9'
