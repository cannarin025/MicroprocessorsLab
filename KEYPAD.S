#include <xc.inc>
 
global Keypad_Init, Keypad_Loop
    
psect    udata_acs   ; named variables in access ram
delay_curr:    ds 1   ; reserve 1 byte for current counter val
delay_count1:    ds 1   ; reserve 1 byte for counting
delay_count2:    ds 1   ; reserve 1 byte for counting
delay_count3:    ds 1   ; reserve 1 byte for counting
wtemp:        ds 1    ; reserve 1 byte for temp w val
    
psect    Keypad_code, class=CODE

    
Keypad_Init:
    banksel PADCFG1
    bsf	    REPU
    clrf    LATE, A 
    
    movlw   0x00
    movwf   TRISJ, A
    
    movlw   0x00
    movwf   TRISH, A
    
    call    Keypad_Loop
    return
    
Keypad_Read_Rows:
    movlw   0x0F	;sets ports 0-3 as input, pins 4-7 as output
    movwf   TRISE, A
    movlw   10
    call    delay_sec
    movff   PORTE, 0x08
    call    Keypad_Read_Col
    return

Keypad_Read_Col:
    movlw   0xF0
    movwf   TRISE, A
    movlw   10
    call    delay_sec
    movff   PORTE, 0x09
    return
    
Keypad_Get_Output:
    movf    0x08, 0	;loads 0x08 (rows) into W
    ADDWF   0x09, A	;performs addition of rows with 0x09 (columns)
    movff   0x09, PORTJ ;outputs row (dim) in 1st 4 bits and col (dim) in last 4 bits
    return
    
Keypad_Loop:
    call    Keypad_Read_Rows
    call    Keypad_Get_Output
    movlw   0xFF
    cpfseq  PORTJ, A
    call    check_1
    bra	    Keypad_Loop
    
Keypad_Get_Value:
    return

check_1:
    movlw   0x77    ;corresponds to keypress 1
    cpfseq  PORTJ, A
    bra    check_2
    
    ;do things if button corresponds to 1
    movlw   0x01    ;displays button value on portH
    movwf   PORTH, A
    
    return

check_2:
    movlw   0xB7    ;corresponds to keypress 2
    cpfseq  PORTJ, A
    bra   check_3
    
    ;do things if button corresponds to 2
    movlw   0x02    ;displays button value on portH
    movwf   PORTH, A
    
    return

check_3:
    movlw   0xD7    ;corresponds to keypress 3
    cpfseq  PORTJ, A
    bra    check_4
    
    ;do things if button corresponds to 3
    movlw   0x03   ;displays button value on portH
    movwf   PORTH, A
    
    return

check_4:
    movlw   0x7B    ;corresponds to keypress 4
    cpfseq  PORTJ, A
    bra    check_5
    
    ;do things if button corresponds to 4
    movlw   0x04   ;displays button value on portH
    movwf   PORTH, A
    
    return

check_5:
    movlw   0xBB    ;corresponds to keypress 5
    cpfseq  PORTJ, A
    bra    check_6
    
    ;do things if button corresponds to 5
    movlw   0x05   ;displays button value on portH
    movwf   PORTH, A
    
    return
    
check_6:
    movlw   0xDB    ;corresponds to keypress 6
    cpfseq  PORTJ, A
    bra	    check_7
    
    ;do things if button corresponds to 6
    movlw   0x06   ;displays button value on portH
    movwf   PORTH, A
    
    return

check_7:
    movlw   0x7D    ;corresponds to keypress 7
    cpfseq  PORTJ, A
    bra	    check_8
    
    ;do things if button corresponds to 7
    movlw   0x07   ;displays button value on portH
    movwf   PORTH, A
    
    return
    
check_8:
    movlw   0xBD    ;corresponds to keypress 8
    cpfseq  PORTJ, A
    bra	    check_9
    
    ;do things if button corresponds to 8
    movlw   0x08   ;displays button value on portH
    movwf   PORTH, A
    
    return
    
check_9:
    movlw   0xDD    ;corresponds to keypress 9
    cpfseq  PORTJ, A
    ;bra    check_A
    return
    ;do things if button corresponds to 9
    movlw   0x09   ;displays button value on portH
    movwf   PORTH, A
    
    return
    ;carry on with this etc...

delay_sec:
    movwf   wtemp, A
    movlw   0x00
    movwf   delay_curr, A
    incf    delay_curr, F, A        ; set f00 = f00 + 1
    movlw   0xfd            ; set W = 256 (timer)
    movwf   delay_count1, A            ; set timer f06 = W (=256)
    movlw   0x2b
    movwf   delay_count2, A            ; set timer f07 = W (=256)
    movlw   0x52            ; set W = 80
    movwf   delay_count3, A            ; set timer f08 = W (=80)
    call    delay            ; run the delay
    movf    wtemp, W, A
    return
   
delay:
    decfsz  delay_count1, A            ; decrement f02 and skip next if f02 = 0
    bra	    delay
    decfsz  delay_count2, A            ; decrement f02 and skip next if f02 = 0
    bra	    delay
    decfsz  delay_count3, A            ; decrement f02 and skip next if f02 = 0
    bra	    delay
    return
    