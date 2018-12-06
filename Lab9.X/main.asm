LIST p=18f4520
#include<p18f4520.inc>

; CONFIG1H
  CONFIG  OSC = INTIO67         ; Oscillator Selection bits (Internal oscillator block, port function on RA6 and RA7)
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = OFF            ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable bits (Brown-out Reset enabled in hardware only (SBOREN is disabled))
  CONFIG  BORV = 3              ; Brown Out Reset Voltage bits (Minimum setting)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = PORTC        ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) not protected from table reads executed in other blocks)

    L1 equ 0x24
    L2 equ 0x25	
 
    ORG 0x00
    BRA Init
    ORG 0x08
    BRA ISR
    
    DELAY MACRO num1,num2
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
    
    ISR:
	BTFSC INTCON, INT0IF ; 將Flag bit清除
	BRA RUN
	
	BTFSC PIR1, TMR2IF
	BRA BACK
	
	RUN:
	; ----- SET DUTY TIME -----
	; (CCPRxL + CCPxCON(bit5 4))*石英震盪器(週期)*TMR2的預除器 = 2400 * 10^(-6) => 90度
	; (CCPRxL + CCPxCON(bit5 4)) = 2400 / 2 / 16 = 75
	; CCPRxL = 75/4 = 18.25 = 18
	; 4~18
	
	RLNCF LATA
	INCF LATA
	
	;BTFSC LATA, 0
	;BRA SET00
	BTFSC LATA, 4
	BRA GGO
	BTFSC LATA, 3
	BRA SET11
	BTFSC LATA, 2
	BRA SET10
	BTFSC LATA, 1
	BRA SET01
	
	
	BRA BACK
	
	GGO:
	CLRF LATA
	BCF CCP1CON, 4
	BCF CCP1CON, 5
	INCF CCPR1L
	MOVLW d'19'
	CPFSEQ CCPR1L
	BRA BACK
	BRA STOP
	
	BACK:
	CALL DEL
	BTG LATD, 0
	BCF PIR1, TMR2IF ;清空FALG BIT
	RETFIE
	
	SET01: ; CCPxCON(bit5 4) 0 1
	BSF CCP1CON, 4
	BCF CCP1CON, 5
	BRA BACK
	
	SET10: ; CCPxCON(bit5 4) 0 1
	BCF CCP1CON, 4
	BSF CCP1CON, 5
	BRA BACK
	
	SET11: ; CCPxCON(bit5 4) 0 1
	BSF CCP1CON, 4
	BSF CCP1CON, 5
	BRA BACK
	
DEL:
    DELAY D'200', D'18'
    RETURN
    
    Init:
	; ----- set PWM period = [PR2+1]*4*石英震盪器(週期)*TMR2的預除器 -----
	; 石英震盪器(週期) = 1/0.5MHz = 2 * 10^(-6)
	BCF OSCCON, 6
	BSF OSCCON, 5
	BSF OSCCON, 4
	
	; [PR2+1]*4*石英震盪器(週期)*TMR2的預除器 = 20ms = 20000 * 10^(-6)
	; [PR2+1] = 20000/4/2/16 = 156.25 = 156
	; PR2 = 155
	
	MOVLW B'00000111' ; POSTSCALE = 1:1 , PRESCALE = 1:16
	MOVWF T2CON
	MOVLW d'155'  
	MOVWF PR2
	
	; ----- SET DUTY TIME -----
	; (CCPRxL + CCPxCON(bit5 4))*石英震盪器(週期)*TMR2的預除器 = 500 * 10^(-6) => -90度
	; (CCPRxL + CCPxCON(bit5 4)) = 500 / 2 / 16 = 15.625 = 16
	; CCPRxL*4 = 16
	; CCPRxL = 16/4 =  4
	
	CLRF LATA ; FOR CCPxCON(bit5 4)
	BCF CCP1CON, 4
	BCF CCP1CON, 5
	CLRF CCPR1L
	MOVLW D'4'
	
	MOVWF CCPR1L
	MOVLW B'00001100'
	MOVWF CCP1CON
	
	; ----- set CCPx to output (RC2 / 17) -----
	CLRF TRISC
	CLRF PORTC
	BSF LATC, 2
	
	CLRF TRISD
	CLRF PORTD
	BSF LATD, 0
	
	; ----- SET TMR2 -----
	BSF IPR1, TMR2IP
	BCF PIR1, TMR2IF ;清空FALG BIT
	BSF PIE1, TMR2IE
	
	BSF RCON, IPEN
	BSF INTCON, GIEH
	
	; ----- set BUTTON -----
	MOVLW 0x0Fb
	MOVWF ADCON1, 0 ;將AN12轉成digital輸出
	BSF INTCON, INT0IE ; 開啟 INT0 External Interrupt Enable bit 
	BCF INTCON, INT0IF ; 將Flag bit清除
	BSF INTCON2, INTEDG0 ;1~0時觸發
Main:
    GOTO Main
STOP:
CLRF LATD
end





