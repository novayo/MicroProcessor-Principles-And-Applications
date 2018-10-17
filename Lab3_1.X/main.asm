;Implement two logic operations below:
;    1. NAND: 10110101 NAND 01111100, and store result in LATD
;    2. NOR: 10010110 NOR 01101001, and store result in LATC
;Tips:
;    Use WREG as your temporary register.
;    Use AND, OR, XOR instructions to finish ONLY.

LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	
    
Init:
    MOVLW b'11111111
    ADDWF LATD, 1, 0
    ADDWF LATC, 1, 0
    CLRF WREG
    NOP
    
NAND:
    MOVLW b'10110101
    ANDLW b'01111100
    XORWF LATD, 1, 0
    NOP

NOR:
    MOVLW   b'10010110
    IORLW b'01101001
    XORWF LATC, 1, 0
    NOP
    
end





