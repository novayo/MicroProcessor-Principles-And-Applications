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


; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setting file register address.
  L1 equ 0x126
 L2 equ 0x127
COUNT EQU 0X100	    
DIVISORH EQU 0X110   
DIVISORL EQU 0X111
REMAINDERH EQU 0X120
REMAINDERL EQU 0X121
QUOTIENT EQU 0x0130 ; 


#define Button1Flag 0X160, 0 ; You can use it or not.
#define Button2Flag 0X170, 0 ; You can use it or not.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
; Teacher assistent will provide input data.
Input1H EQU 0x0F 
Input1L EQU 0x7C 
Input2  EQU 0x6F ; 0xF7C/0x6F = 0x23 ... 0x4F
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  
ORG 0X00  
bra Init
ORG 0X08 ; setting interrupt service routine 
bra isr	
	
DELAY MACRO num1,num2 ;1Mhz = 250000 = 1s      4Mhz = 200 180 => 1/4s   200 180*2
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
  
rrcf4time macro origf, destf ; rotate your orginal register to destination for 4 times
			     ; Clear your destination first.
	endm
	
; Build the delay macro 
	
Init:	bsf OSCCON, IRCF2 ; Internal Oscillator Frequency is set 4Mhz
	bsf OSCCON, IRCF1 ; Don't remove 3 lines !!!
	bcf OSCCON, IRCF0 
	
	
	CLRF PORTB
	CLRF LATB
	BSF TRISB, 0
	CLRF TRISD
	CLRF PORTD
	clrf 0x133
	clrf 0x134
	clrf 0x123
	clrf 0x124

	;設定INT0
	BSF INTCON, INT0IE ; 開啟 INT0 External Interrupt Enable bit 
	BCF INTCON, INT0IF ; 將Flag bit清除
	BSF INTCON2, INTEDG0 ;1~0時觸發
	BSF INTCON, GIE    ; 開啟是否跳進ISR
	
	incf BSR
	CLRF PORTB
	CLRF LATB
	BSF TRISB, 0
	CLRF TRISD
	CLRF PORTD 

	MOVLW 0x0Fb
	MOVWF ADCON1, 0 ;將AN12轉成digital輸出

	;設定INT0
	BSF INTCON, INT0IE ; 開啟 INT0 External Interrupt Enable bit
	BSF INTCON3, INT1IE ; 開啟 INT0 External Interrupt Enable bit
	
	BCF INTCON, INT0IF ; 將Flag bit清除
	BCF INTCON3, INT1IF ; 將Flag bit清除
	
	BSF INTCON2, INTEDG0 ;1~0時觸發
	BSF INTCON2, INTEDG1 ;1~0時觸發
	
	BSF INTCON, GIE    ; 開啟是否跳進ISR
			  ; Setting button1&button2 interrupt configuration on INTx(Just pick any 2 from Int0-Int2)  
			  ;
			  ;		  
			  ; Setting config for lighting LED (RD3-RD0)	
	bcf Button1Flag
	bcf Button2Flag
	
	movlw d'9'
	movwf COUNT ;COUNT store 9
	
	clrf REMAINDERH
	clrf REMAINDERL
	clrf QUOTIENT
	clrf DIVISORH
	clrf DIVISORL
	
	movlw 0x07 ; Dividend
	movwf REMAINDERH, 1
	movlw 0xAC ; Dividend
	movwf REMAINDERL, 1
	movlw 0x3E ; Divisor
	movwf DIVISORH, 1
	;clrf REMAINDERH
	
Divide:  ; divde 
	; if Remainder-Divisor<0
	clrf 0x002
	clrf 0x001
	clrf 0x003
	clrf 0x004
	movff REMAINDERH, WREG
	subwf DIVISORH, 0 ;result in wreg
	movff WREG, 0x001
	btfsc STATUS, N
	bra go_n
	
	
	movff REMAINDERL, WREG
	subwf DIVISORL, 0 ;result in wreg
	movff WREG, 0x003
	btfss STATUS, N
	bra not_n
go_n:
	;Quotient Rotates left 1 bit, then setting 0 at bit0 of Quotient.
	bcf STATUS, C
	bcf STATUS, DC
	RLCF QUOTIENT
	bcf QUOTIENT, 0

	bcf STATUS, C
	
	;Divisor Rotates right 1 bit.
	btfsc DIVISORH, 0
	incf 0x002
	
	RRCF DIVISORH
	RRCF DIVISORL
	btfsc 0x002, 0
	bsf DIVISORL, 7
	
	bcf STATUS, C
	bcf STATUS, DC
	bra E
    not_n:
	bcf STATUS, C
	bcf STATUS, DC
	;Remainder-Divisor>=0, Remainder = Remainder - Divsior
	movff 0x001, REMAINDERH
	movff 0x003, REMAINDERL
	
	;Quotient Rotates left 1 bit, then setting 1 at bit0 of Quotient.
	RLCF QUOTIENT
	bsf QUOTIENT, 0
	bcf STATUS, C
	
	;Divisor Rotates right 1 bit.
	btfsc DIVISORH, 0
	incf 0x004
	
	RRCF DIVISORH
	RRCF DIVISORL
	btfsc 0x004, 0
	bsf DIVISORL, 7
	
	bcf STATUS, C
	bcf STATUS, DC
	
	; You can write macro of divide, or not.
	; Input1 is Dividend, Input2 is Division. 
	; For example, 0xFFC / 0x11h =  0xFF0...0xC.
	; 0xFFC: Dividend (0xF: DividendH, 0xFC: DividendL). 
	; 0X11: Division.  0XFF0: Quotient. 0xc: Remainder
	; You must push result values to QUOTIENT(0X130), REMAINDERL(0x121) before you shift values.
    E:
	decfsz COUNT
	bra Divide
	
	
	
Transfer:
clrf 0x133
	btfss LATA, 0
	bsf 0x134, 0
	btfss LATA, 1
	bsf 0x134, 1
	btfss LATA, 2
	bsf 0x134, 2
	btfss LATA, 3
	bsf 0x134, 3
clrf 0x134
	btfss LATA, 4
	bsf 0x133, 4
	btfss LATA, 5
	bsf 0x133, 5
	btfss LATA, 6
	bsf 0x133, 6
	btfss LATA, 7
	bsf 0x133, 7
	
clrf 0x123
	btfss LATC, 0
	bsf 0x123, 0
	btfss LATC, 1
	bsf 0x123, 1
	btfss LATC, 2
	bsf 0x123, 2
	btfss LATC, 3
	bsf 0x123, 3
clrf 0x124
	btfss LATC, 4
	bsf 0x124, 4
	btfss LATC, 5
	bsf 0x124, 5
	btfss LATC, 6
	bsf 0x124, 6
	btfss LATC, 7
	bsf 0x124, 7

	; rotate register	
	; transfer values to specified file registers.
	; you can design a better method you think.
	clrf LATC
	movlw 0x1F
	movff WREG, LATC
	clrf LATA
	movlw 0x2A
	movff WREG, LATA
mainLoop: 
    ;bra en
    
    bra mainLoop
	  ; You must add some codes, then make your hardware is operated successfully.
	  ; about intx of button , just pick any 2 from int0-int2
	  ; Writing delay macro on interrupt service routine will get zero score.
	  ; hint: Button1Flag&Button2Flag are good partners!
	 
q_blink: 	; Designing Quotient_blink for Subroutine
	DELAY d'200', d'360' ;DELAY 0.5s
	btfsc LATC, 4
	bsf PORTD, 0
	btfsc LATC, 5
	bsf PORTD, 1
	btfsc LATC, 6
	bsf PORTD, 2
	btfsc LATC, 7
	bsf PORTD, 3
	DELAY d'200', d'720' ;DELAY 1s
	clrf PORTD ;將RD0關掉
	
	DELAY d'200', d'360' ;DELAY 0.5s
	btfsc LATC, 0
	bsf PORTD, 0
	btfsc LATC, 1
	bsf PORTD, 1
	btfsc LATC, 2
	bsf PORTD, 2
	btfsc LATC, 3
	bsf PORTD, 3
	DELAY d'200', d'720' ;DELAY 1s
	clrf PORTD ;將RD0關掉
	
	return 
r_blink: 	; Designing Remainder_blink for Subroutine
	DELAY d'200', d'360' ;DELAY 0.5s
	btfsc LATA, 4
	bsf PORTD, 0
	btfsc LATA, 5
	bsf PORTD, 1
	btfsc LATA, 6
	bsf PORTD, 2
	btfsc LATA, 7
	bsf PORTD, 3
	DELAY d'200', d'720' ;DELAY 1s
	clrf PORTD ;將RD0關掉
	
	DELAY d'200', d'360' ;DELAY 0.5s
	
	btfsc LATA, 0
	bsf PORTD, 0
	btfsc LATA, 1
	bsf PORTD, 1
	btfsc LATA, 2
	bsf PORTD, 2
	btfsc LATA, 3
	bsf PORTD, 3
	DELAY d'200', d'720' ;DELAY 1s
	clrf PORTD ;將RD0關掉
	return 
	
isr:	; Don't create Delay here!
	btfsc INTCON, INT0IF
	rcall q_blink
	
	btfss INTCON, INT0IF
	rcall r_blink
	
	BCF INTCON, INT0IF ; 將Flag bit清除 ; q
	BCF INTCON3, INT1IF ; 將Flag bit清除 ; r
	RETFIE
en:
	END


