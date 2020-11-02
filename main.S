#include <xc.inc>

extrn	Keypad_Init  ; external subroutine	

psect	code, abs
org	0x0
goto	start

start:
    call	Keypad_Init
    goto	$