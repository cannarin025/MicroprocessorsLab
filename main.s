	#include <pic18_chip_select.inc>
	#include <xc.inc>

psect	code, abs
	
main:
	org	0x0
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	call	write_data
	call	read_data
	goto	$

	; data on portE
	; CP1 portE 1
	; OE1 poetE 0
	
write_data:
	movlw	0x00
	movwf	TRISE, A ;sets PORTE to output
	movwf	TRISB, A ;sets PORTD to output
	movlw	0x03	;keeps CP1 high and OE1 high. Last 4 bits 0001
	movwf	PORTD, A 
	
	movlw   0x69    ;data to be outputted
	movwf   0x01, A
	movff   0x01, LATE
	call    write_loop
	return	0
    
write_loop:
	movlw	0x01	;drop CP1 keeping OE1 high last 4 bits: 0001
	movwf	PORTD, A
	movwf	0x03	;raise CP1 keeping OE1 high. last 4 bits: 0011
	movwf	PORTD, A
	movlw	0x01
	movwf	TRISE, A ;sets trisE to 1 (disables outputs?)
	return	0

read_data:
	movlw	0x03 ;keep OE1 and CP1 high. last 4 bits: 0011
	movwf	PORTD, A
	movwf	0x01 ;disabling outputs of portE
	movwf	TRISE, A
	call	read_loop
	return	0

read_loop:
	movlw	0x02 ;drop OE1, keeping CP1 high. Last 4 bits 0010
	movwf	PORTD, A
	movlw	0x03 ;raise OE1, keeping CP1 high. Last 4 bits: 0011
	movwf	PORTD, A
	
	movff	PORTE, 0x02 ;stores read data in register 0x02
	return	0`