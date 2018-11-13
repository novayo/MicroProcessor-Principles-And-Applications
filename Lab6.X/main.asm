LIST p=18f4520		
#include<p18f4520.inc>
    CONFIG  OSC = INTIO67       ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
    CONFIG  WDT = OFF           ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
    CONFIG  LVP = OFF

#define SWITCH PORTA,4    
    L1	    EQU 0X14
    L2	    EQU 0X15
DELAY2 MACRO num1,num2
    BTFSC SWITCH
    DELAYY d'800', d'320'
    local LOOP1	;prevent compile error
    local LOOP2               
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1                   
	MOVWF L1  
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	BTFSS SWITCH 
	bra BLINK
	DECFSZ L1,1
	    GOTO LOOP1	
	DECFSZ L2,1
	    GOTO LOOP2
    ENDM
DELAY MACRO num1,num2
    BTFSC SWITCH
    DELAYY d'800', d'320'
    local LOOP1	;prevent compile error
    local LOOP2               
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1                   
	MOVWF L1  
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	BTFSS SWITCH
	bra BLINK_REVERSE
	DECFSZ L1,1
	    GOTO LOOP1
	DECFSZ L2,1
	    GOTO LOOP2
    ENDM

DELAYY MACRO num1,num2
    local LOOP1	;prevent compile error
    local LOOP2               
    MOVLW num2
    MOVWF L2
    LOOP2:
	MOVLW num1                   
	MOVWF L1  
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1,1
	    GOTO LOOP1
	DECFSZ L2,1
	    GOTO LOOP2
    ENDM
    
ORG	0x00 ; setting initial address
    
INITIAL:    
	movlw 0x10	    ;2'b0001_0000
	movff WREG, TRISA   ;TRISA = WREG
	movlw 0x00	    ;2'b0000_0000
    	movff WREG, TRISD   ;TRISD = WREG
	movlw 0x11	    ;2'b0001_0001
	movff WREG, LATD    ;LATD = WREG
	clrf WREG
	clrf PORTA

		
BLINK:
	DELAY d'200', 10
	RLNCF LATD
	GOTO BLINK
	
BLINK_REVERSE:
	DELAY2 d'200', 10
	RRNCF LATD
	GOTO BLINK_REVERSE

	END