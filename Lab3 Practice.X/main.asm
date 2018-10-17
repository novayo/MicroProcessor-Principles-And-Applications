LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	
    
Init:
    clrf WREG    ; 0, 1
    addlw 0x00  ; 2, 3
    incf TRISA   ; 4, 5 
    nop        ; 6, 7 
    nop        ; 8, 9 
    nop         
    nop         
    nop         
    nop        ; 10, 11
    nop        ; 12, 13
    
Start:
    bc 12       ; 14, 15
    incf WREG    ; 16, 17
    addlw 0x00  ; 18, 19
    clrf WREG
    incf WREG 
    nop 
    nop ; 20, 21
    nop ; 22, 23
    nop ; 24, 25
    nop ; 26, 27
    nop ; 28, 29
    nop
    nop 
    nop
    nop ; 30, 31
    
    
    
    
    
end


