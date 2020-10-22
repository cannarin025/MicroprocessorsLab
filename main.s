    #include <pic18_chip_select.inc>
    #include <xc.inc>


psect    code, abs
    
main:
    org    0x0
    goto    start


    org    0x100            ; Main code starts here at address 0x100
    
delay:
    decfsz    0x06, A            ; decrement f02 and skip next if f02 = 0
    bra    delay
    decfsz    0x07, A            ; decrement f02 and skip next if f02 = 0
    bra    delay
    decfsz    0x08, A            ; decrement f02 and skip next if f02 = 0
    bra    delay
    return
    
start:
    movlw    0x0            ; set W = 0
    movwf    0x00, A            ; set f00 = 0 (current counter)
    movwf    TRISC, A        ; set TRISC = 0 (counter light)
    movwf    TRISJ, A        ; set TRISD = 0 (finish light)
    movlw    0x40            ; set W = 99 - VARY THIS TO SEE EFFECT
    movwf    0x01, A            ; set f01 = 99 (final counter)
    bra    test1            ; go to test1
    
loop1:
    incf    0x00, F, A        ; set f00 = f00 + 1
    movff    0x00, PORTC        ; set PORTB = f00
    movlw    0xfd            ; set W = 256 (timer)
    movwf    0x06, A            ; set timer f06 = W (=256)
    movlw    0x2b
    movwf    0x07, A            ; set timer f07 = W (=256)
    movlw    0x52            ; set W = 80
    movwf    0x08, A            ; set timer f08 = W (=80)
    movf    0x01, W            ; set W = f01 (=99)
    call    delay            ; run the delay
    
test1:
    movf    0x01, W            ; set W = f01 (=99)
    cpfsgt    0x00,  A        ; if f00 (current) > f01 (= 99): skip next
    bra    loop1            ; go to loop1
    movlw    0xff
    movwf    PORTJ, A        ; turn on the finishing light
    
    goto    $
    end    main
    
 




