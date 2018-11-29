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

    ORG 0x00
    BRA Init
    
    ORG 0x08
    BRA ISR
    
    ISR:
	LOCAL RB
	LOCAL RE
	LOCAL BLINK_1S
	LOCAL SKIP
	BCF PIR1, TMR2IF ;清空FALG BIT
	
	BTFSC LATE, 0
	BRA BLINK_1S
	
	BTFSC TRISE, 0
	BRA SKIP
	
	INCF LATA
	BTFSS LATA, 3 ;IF PROTA 變成 8，做了8次(255*8 = 2040 接近 976*2)
	BRA RB
	
	BTFSC TRISA, 4
	BRA RE

	SKIP:
	INCF TRISA
	
	BTFSC TRISA, 0
	BSF LATD, 0
	BTFSC TRISA, 1
	BSF LATD, 1
	BTFSC TRISA, 2
	BSF LATD, 2
	BTFSC TRISA, 3
	BSF LATD, 3
	
	RLCF TRISA
	
	
	
	CLRF TRISE
	CLRF LATA
	
	RB:
	    RETFIE FAST
	RE:
	    CLRF TRISE
	    CLRF LATA
	    CLRF TRISA
	    INCF LATE
	    BCF LATD, 0
	    BCF LATD, 1
	    BCF LATD, 2
	    BCF LATD, 3
	    BRA RB
	BLINK_1S:
	    INCF LATA
	    BTFSS LATA, 2 ;IF PROTA 變成 4，做了4次(255*4 = 1020 接近 976)
	    BRA RB
	    
	    INCF TRISE
	    CLRF LATE
	    CLRF LATA
	    BRA RB
	    
    Init:
	CALL INIT_IO
	CALL INIT_TMR2
	BSF RCON, IPEN
	BSF INTCON, GIEH
	
    MAIN:
	GOTO MAIN
	
    INIT_IO:
	CLRF TRISD
	CLRF PORTD
	RETURN

    INIT_TMR2:
	MOVLW B'01111111' ; POSTSCALE = 1:16 , PRESCALE = 1:16
	MOVWF T2CON
	MOVLW d'255'  ; 但TMR2是8BITS(最大到255)，一樣是預設的1MHz，設定的是POSTSCALE = 1:16 , PRESCALE = 1:16，故1秒鐘為 = (1000000/4)/16/16 = 976
	MOVWF PR2
	CLRF LATA
	CLRF TRISA
	CLRF TRISE
	CLRF LATE
	MOVLW 3
	MOVWF LATE
	
	BSF IPR1, TMR2IP
	BCF PIR1, TMR2IF
	BSF PIE1, TMR2IE
	
	RETURN
	
	END
	


