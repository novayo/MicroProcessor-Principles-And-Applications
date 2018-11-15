#include "p18f4520.inc"

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
  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as analog input channels on Reset)
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

 COUNT_VAL equ (.256-3)
 L1 equ 0x24
 L2 equ 0x25
 ORG 0x00
 GOTO Initial
 
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
	BRA LOOP1
	DECFSZ L2,1
	BRA LOOP2
    ENDM

Blink MACRO r
    local E
    BTFSS r, INT0IF
    GOTO E
 
    BSF PORTD, 0 ;將RD0點亮
    DELAY d'400', d'360' ;DELAY 0.5s
    BCF PORTD, 0 ;將RD0關掉
    
    BSF PORTD, 1 ;將RD1點亮
    DELAY d'400', d'360' ;DELAY 0.5s
    BCF PORTD, 1 ;將RD1關掉
    
    BSF PORTD, 2 ;將RD2點亮
    DELAY d'400', d'360' ;DELAY 0.5s
    BCF PORTD, 2 ;將RD2關掉
    
    BSF PORTD, 3 ;將RD3點亮
    DELAY d'400', d'360' ;DELAY 0.5s
    BCF PORTD, 3 ;將RD3關掉
E:   
ENDM

ISR:
    ORG 0x08
    
    ; 這裡放ISR要執行的程式
    Blink INTCON
    
    BCF INTCON, INT0IF ; 將Flag bit清除
    RETFIE
    
Initial:
    CLRF PORTB
    CLRF LATB
    BSF TRISB, 0
    CLRF TRISD
    CLRF PORTD 
    
    MOVLW 0x0Fb
    MOVWF ADCON1, 0 ;將AN12轉成digital輸出
    
    ;設定INT0
    BSF INTCON, INT0IE ; 開啟 INT0 External Interrupt Enable bit 
    BCF INTCON, INT0IF ; 將Flag bit清除
    BSF INTCON2, INTEDG0 ;1~0時觸發
    BSF INTCON, GIE    ; 開啟是否跳進ISR
    
Main:
    GOTO Main
    
END


