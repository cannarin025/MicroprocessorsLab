#include <xc.inc>

extrn	Keypad_Init, Keypad_Loop, LCD_Setup  ; external subroutine

psect	code, abs
org	0x0
goto	start

start:
    call	LCD_Setup
    call	Keypad_Init
    goto	$
    