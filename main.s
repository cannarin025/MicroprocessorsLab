	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	call	SPI_MasterInit
	movlw 	0x0
	movwf	TRISC, A	    ; Port C all outputs
	bra 	test
loop:
	call	delay1s_setup
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
    
alternete_delay_start:
    movlw   0xFF    ;start value 1
    movwf   0x21, A
    movlw   0xFF    ;start value 2
    movwf   0x22, A
    movlw   0xFF
    movwf   0x23, A
    call    alternate_delay
    return 0
   
alternate_delay:
    decfsz  0x21, A
    bra	    alternate_delay
    decfsz  0x22, A
    bra	    alternate_delay
    decfsz  0x23, A
    bra	    alternate_delay
    return 0
    
delay1s_setup: 
    movlw   0xfd    ; set W = 256 (timer)
    movwf   0x06, A    ; set timer f06 = W (=256)
    movlw   0x2b
    movwf   0x07, A    ; set timer f07 = W (=256)
    movlw   0x52    ; set W = 80
    movwf   0x08, A    ; set timer f08 = W (=80)
    call    delay1s    ; run the delay
    return

delay1s:
    decfsz  0x06, A    ; decrement f02 and skip next if f02 = 0
    bra	    delay1s
    decfsz  0x07, A    ; decrement f02 and skip next if f02 = 0
    bra	    delay1s
    decfsz  0x08, A    ; decrement f02 and skip next if f02 = 0
    bra	    delay1s
    return


SPI_MasterInit:	    ;set clock edge to negative
    bcf	    CKE	    ;CKE bit in SSP2STAT
		    ;MSSP enable; CKP=1; SPI master, click = Fosc/64 (1MHz)
    movlw   (SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
    movwf   SSP2CON1, A
		    ;SDO2 output; SCK2 outpup
    bcf	    TRISD, PORTD_SDO2_POSN, A	;SDO2 output
    bcf	    TRISD, PORTD_SCK2_POSN, A	;SCK2 output
    return
    
SPI_MasterTransmit: ;Start transmission of data (held in W)
    movwf   SSP2BUF, A	;write data to output buffer
 
Wait_transmit:	    ;wait for transmission to complete
    btfss   SSP2IF  ;check interrupt flag to see if data has been sent
    bra	    Wait_transmit
    bcf	    SSP2IF  ;clear interrupt flag
    return