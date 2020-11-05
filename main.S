#include <xc.inc>

extrn	Keypad_Init, Keypad_Loop;, LCD_Setup, LCD_Clear  ; external subroutine	

psect	code, abs
org	0x0
goto	start

start:
    ;call	LCD_Setup
    ;call	LCD_Clear
    call	Keypad_Init
    goto	$
    