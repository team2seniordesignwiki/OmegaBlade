; FILE: timer1_0.asm - WORKS!
; AUTH: P.Oh
; DATE: 1.0 - 04/14/02 16:00
; DESC: 1.0 - Internal timer, blink LED every 32.8 msec
; NOTE: Tested on PIC16F84-04/P.  
;       Page numbers in code are in Easy Pic'n book.
;	4 MHz crystal yields 1 MHz internal clock frequency.
;	"option" is set to divide internal clock by 256.
;	This results in 1 MHz/256 = 3906.25 Hz or 256 usec.
;	tmr0 bit 7 (128 decimal) is checked, thus yielding
;	128*256 usec = 32.8 msec delay loop
; REFs: Easy Pic'n p. 113

	list	p=16F84
	radix	hex

;----------------------------------------------------------------------
;	cpu equates (memory map)
portB	equ	0x06		; (p. 10 defines port address)
count	equ	0x0c
tmr0	equ	0x01
;----------------------------------------------------------------------

	org	0x000
start	clrwdt			; clear watchdog timer
	movlw	b'11010111'	; assign prescaler, internal clock
				; and divide by 256 see p. 106
	option
	movlw	0x00		; set w = 0
	tris	portB		; port B is output
	clrf	portB		; port B all low
go	bsf	portB, 0	; RB0 = 1, thus LED on p. 28
	call	delay
	bcf	portB, 0	; RB0 = 0, thus LED off
	call	delay
	goto	go		; repeat forever

delay	clrf	tmr0		; clear TMR0, start counting
again	btfss	tmr0, 7		; if bit 7 = 1
	goto	again		; no, then check again
	return			; else exit delay

	end
;----------------------------------------------------------------------
; at blast time, select:
;	memory uprotected
;	watchdog timer disabled
;	standard crystal (4 MHz)
;	power-up timer on
