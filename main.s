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

	; data on portD
	; CP1 portE 1
	; OE1 poetE 0
	
write_data:
	movlw	0x00
	movwf	TRISD, A ;sets PORTD to output
	movwf	TRISE, A ;sets PORTE to output
	movlw	0x03	;keeps CP1 high and OE1 high. Last 4 bits 0001
	movwf	PORTE, A 
	
	movlw   0x30    ;data to be outputted
	movwf   0x01, A
	movff   0x01, PORTD
	call    write_loop
	return	0
    
write_loop:
	movlw	0x01	;drop CP1 keeping OE1 high last 4 bits: 0001
	movwf	PORTE, A
	movwf	0x03	;raise CP1 keeping OE1 high. last 4 bits: 0011
	movwf	PORTE, A
	movlw	0x01
	movwf	TRISD, A ;sets trisD to 1 (disables outputs?)
	return	0

read_data:
	movlw	0x03 ;keep OE1 and CP1 high. last 4 bits: 0011
	movwf	PORTE, A
	movwf	0x01 ;disabling outputs of portD
	movwf	TRISD, A
	call	read_loop
	return	0

read_loop:
	movlw	0x02 ;drop OE1, keeping CP1 high. Last 4 bits 0010
	movwf	PORTE, A
	movlw	0x03 ;raise OE1, keeping CP1 high. Last 4 bits: 0011
	movwf	PORTE, A
	
	movff	PORTD, PORTJ ;stores read data on portJ
	return	0