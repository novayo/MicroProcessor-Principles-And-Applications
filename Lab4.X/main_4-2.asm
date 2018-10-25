; Protect your rgstr!
; Request:
;   1. Implement a stack-like array 0x100
;   2. Assign the value: 0x140=8, 0x116=7, 0x154=6
;   3. RCALL to the “mclear” subroutine
;	- RCALL “mclear”
;	- Push
;	- multiplying all of them 
;	- Clear 3 registers
;	- Resume the value before entering into “mclear”
;	- RETRUN

LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	
    
Init:
    movlf MACRO literal, reg
	    movlw literal
	    addwf reg, 1, 1
	    clrf WREG
	    endm
	    
    lfsr FSR0, 0x100
    movlb 1
    movlf 0x08, 0x140
    movlf 0x07, 0x116
    movlf 0x06, 0x154
    
Main:
    
    NOP
    rcall mclear
    movlf 0x08, 0x140
    movlf 0x07, 0x116
    movlf 0x06, 0x154
    rcall Return0
mclear:
    ; push
    movff 0x140, POSTINC0
    movff 0x116, POSTINC0
    movff 0x154, INDF0
    
    ;multi a * b
    movff INDF0, WREG
    mulwf INDF0
    
    ;multi (a*b) * c
    movff INDF0, WREG
    mulwf PROD
    
    clrf 0x140
    clrf 0x116
    clrf 0x154
    
    return
    
Return0:
end

