#include <xc.inc>
 
global Keypad_Init
    
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
    
    call    Keypad_Read_Rows
    call    Keypad_Get_Output
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
    
Keypad_loop:
    movlw   0xFF
    cpfseq  PORTJ, A
    call    check_1
    bra	    Keypad_loop

check_1:
    movlw   0xEE    ;corresponds to keypress 1
    cpfseq  PORTJ, A
    call    check_2
    ;do things here
    return

check_2:
    movlw   0xED    ;corresponds to keypress 2
    cpfseq  PORTJ, A
    call    check_3
    ;do things here
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
    