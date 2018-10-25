; Fibonacci sequence
; Request:
;   1. compute Fn (n = 9), and the default value is F0 = 1, F1 = 2
;   2. 0x14 = 0x12 + 0x13
;   3. implement the following 2 function:
;	    Macro: MOVLF(literal, F) 
;	    Subroutine: Fib(n)   //RCALL and RETURN
; *Iteration in Fib function: Modify the Program Counter value rather than using GOTO

LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	

Init:
    movlf MACRO literal, reg
	  movlw literal
	  movwf reg
	  clrf WREG
	  endm	  
	 
    clrf WREG
    clrf 0x12
    clrf 0x13
    clrf 0x14
    movlf 0x00, 0x12
    movlf 0x01, 0x13
    
    movlf 0x09, LATA ; Find Fn
    movlw 0x01
    subwf LATA, 1, 0
    clrf WREG
Main:
    
    
    NOP
    NOP
    NOP

    rcall Fibonacci
    movlw 26
    decfsz LATA
    movwf PCL

    rcall Return0
    
Fibonacci:
    clrf WREG
    movff 0x12, WREG
    addwf 0x13, 0
    movwf 0x14
    movff 0x13, 0x12
    movff 0x14, 0x13
    clrf WREG
    return

Return0:
    end