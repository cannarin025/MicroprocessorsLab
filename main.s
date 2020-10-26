	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	call	write_data_1
	call	write_data_2
	call	read_data_1
	call	read_data_2
	goto	$

	; data on portD
	; OE1 portE 0 0000 0001
	; CP1 portE 1 0000 0010
	; OE2 portE 4 0001 0000
	; CP2 portE 5 0010 0000
	
write_data_1:
	movlw	0x00
	movwf	TRISE, A ;sets PORTE to output
	movlw	0x33	 ;keeps CP1 high and OE1 high. Last 4 bits 0011
	movwf	PORTE, A 
	movlw	0x00
	movwf	TRISD, A ;sets PORTD to output
	
	
	movlw   0xFF	;data to be outputted
	movwf   0x01, A
	movff   0x01, LATD
	call    write_loop_1
	return	0
    
write_loop_1:
	movlw	0x31	;drop CP1 keeping OE1 high last 4 bits: 0001
	movwf	LATE, A
	call	delay_init
	movlw	0x33	;raise CP1 keeping OE1 high. last 4 bits: 0011
	movwf	LATE, A
	movlw	0xFF
	movwf	TRISD, A ;sets trisD to 1 (disables outputs?)
	return	0

write_data_2:
	movlw	0x00
	movwf	TRISE, A ;sets PORTE to output
	movlw	0x33	 ;keeps CP2 high and OE2 high. Last 4 bits 1111
	movwf	PORTE, A 
	movlw	0x00
	movwf	TRISD, A ;sets PORTD to output
	
	
	movlw   0x00    ;data to be outputted
	movwf   0x01, A
	movff   0x01, LATD
	call    write_loop_2
	return	0
	
write_loop_2:
	movlw	0x13	;drop CP2 keeping OE2 high last 4 bits: 0001
	movwf	LATE, A
	call	delay_init
	movlw	0x33	;raise CP2 keeping OE2 high. last 4 bits: 0011
	movwf	LATE, A
	movlw	0xFF
	movwf	TRISD, A ;sets trisD to 1 (disables outputs?)
	return	0

read_data_1:
	movlw	0x00
	movwf	TRISH, A ;sets portJ to output
	movlw	0x33	;keep OE1 and CP1 high. last 4 bits: 0011
	movwf	LATE, A
	movlw	0xFF	;disabling outputs of portD
	movwf	TRISD, A
	call	read_loop_1
	return	0

read_loop_1:
	movlw	0x32 ;drop OE1, keeping CP1 high. Last 4 bits 0010
	movwf	LATE, A
	
	;data has been read
	movff	PORTD, PORTH ;stores read data on portJ
	
	movlw	0x33 ;raise OE1, keeping CP1 high. Last 4 bits: 0011
	movwf	LATE, A
	
	
	return	0

read_data_2:
	movlw	0x00
	movwf	TRISJ, A ;sets portJ to output
	movlw	0x33	;keep OE1 and CP1 high. last 4 bits: 0011
	movwf	LATE, A
	movlw	0xFF	;disabling outputs of portD
	movwf	TRISD, A
	call	read_loop_2
	return	0

read_loop_2:
	movlw	0x23 ;drop OE1, keeping CP1 high. Last 4 bits 0010
	movwf	LATE, A
	
	;data has been read
	movff	PORTD, PORTJ ;stores read data on portJ
	
	movlw	0x33 ;raise OE1, keeping CP1 high. Last 4 bits: 0011
	movwf	LATE, A
	
	
	return	0
	
delay_init:
    movlw   0xFF
    movwf   0x05, A
    call    delay_loop
    return  0
   
delay_loop:
    decfsz  0x05, A
    bra	    delay_loop
    return  0
    