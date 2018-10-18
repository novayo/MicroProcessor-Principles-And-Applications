; 1. Add from 1, 2, … to XX, and store in LATA.
;    Tips: 
;        a. Use WREG as a incrementally temporary register.
;        b. ADDWF is a good instruction for sum of two registers.
;        c. If there are nothing change about Overflow Bit in STATUS register, Branch back and do this sum loop.
;        d. Use above Control Operation and see the result, what happen? And what is the value of XX finally?
;           ANS: 16
; 
; 2. After finishing the summation, use GOTO to the label named Rotate. And label Rotate must under these:
;    NOP
;    NOP
;    NOP
;    GOTO Initial
; 3. Give value 0xBF to your LATB register, and do any one of following two options:
;    Option A: Rotate Left and store in WREG, C = 1, what is result?
;        ANS: b'00011110
;    Option B: Rotate Right and store in WREG, C = 1, what is result?
;    Take Care about your STATUS register

LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	
    
Init:
    CLRF WREG
    CLRF LATA
    
    NOP
Start:
    INCF WREG
    ADDWF LATA, 1, 0 ;8
    BNOV 6 
    
    NOP 
    
    NOP
    NOP
    NOP
    GOTO Initial

Initial:
    NOP
    GOTO Rotate

    NOP
    NOP
    
Rotate:
    MOVLW 0xBF
    ADDWF LATB, 1, 0
    RLCF LATB, 0, 0
    
    NOP
end