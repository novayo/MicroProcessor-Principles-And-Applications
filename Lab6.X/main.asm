LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67  ; 用內建的震盪器
    CONFIG WDT = OFF	   
    CONFIG LVP = OFF
    
    
#define SWITCH PORTA, 4
L1 EQU 0x14
L2 EQU 0x15
org   0x00	
    
; DELAY 0.25ms
DELAY MACRO NUM1, NUM2
    LOCAL LOOP1 ;local macro內的label
    LOCAL LOOP2
    MOVLW d'180'
    MOVWF L2
    LOOP2:
	MOVLW d'200'
	MOVWF L1
    LOOP1:
	NOP
	NOP
	NOP
	NOP
	DECFSZ L1
	BRA LOOP1
	DECFSZ L2
	BRA LOOP2
    ENDM
DELAY d'200', d'180'

    CLRF PORTA ; 將input設成開關，故要看開關的狀態，而這裡用RA4
    CLRF LATA ; 將RA0~RA7 輸出設為0，因為RA4要設成input
    BSF TRISA, 4 ;RA4 is input
    
    MOVLW 0x0f
    MOVWF ADCON1 ; 將輸入設成Digital，詳細看spec的 p.224 (之後會用到)
    
    CLRF TRISD ;RD0 is output
    CLRF LATD ;等等要來設定輸出是1
    
    LOOP:
	BCF LATD, 0 ;RD0 輸出設成0 (燈泡會暗)
	BCF LATD, 1 ;RD1 輸出設成0 (燈泡會暗)
	BCF LATD, 2 ;RD2 輸出設成0 (燈泡會暗)
	BCF LATD, 3 ;RD3 輸出設成0 (燈泡會暗)
	BTFSS SWITCH ; 如果第4個bit(定義在define)變成0的話，下一行設成NOP，否則就不做事
	BRA LOOP
    LOOP1:
	BCF LATD, 3 ;RD3 輸出設成0 (燈泡會暗)
	BSF LATD, 0 ;RD0 輸出設成1 (燈泡會亮)
	DELAY d'800', d'720' ; DELAY 1s
	
	BCF LATD, 0 ;RD0 輸出設成0 (燈泡會暗)
	BSF LATD, 1 ;RD1 輸出設成1 (燈泡會亮)
	DELAY d'800', d'720' ; DELAY 1s
	
	BCF LATD, 1 ;RD1 輸出設成0 (燈泡會暗)
	BSF LATD, 2 ;RD2 輸出設成1 (燈泡會亮)
	DELAY d'800', d'720' ; DELAY 1s
	
	BCF LATD, 2 ;RD2 輸出設成0 (燈泡會暗)
	BSF LATD, 3 ;RD3 輸出設成1 (燈泡會亮)
	DELAY d'800', d'720' ; DELAY 1s
	
	BRA LOOP1
	
END

