	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	bra 	test
loop:
	call	delay_setup
	incf 	0x06, W, A
	movff 	0x06, PORTC
test:
	movwf	0x06, A		    ; Test for end of loop condition
	movlw 	0xFF		    ;end condition
	cpfseq 	0x06, A
	bra 	loop	; Not yet finished goto start of loop again
	movlw	0x0
	goto 	$		    ; hold program at end

delay_setup:
    movlw   0xFF ;delay value 1
    movwf   0x01, A
    call    delay1
    return 0
 
delay1:
    movlw   0xFF ;delay value 2
    movwf   0x02, A
    call    delay2
    decfsz  0x01, A
    bra	    delay1
    return 0

delay2:
    decfsz  0x02, A
    bra	    delay2
    return 0
	
    