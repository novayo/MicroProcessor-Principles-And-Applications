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
	
rrcf4time macro origf, destf ; rotate your orginal register to destination for 4 times
			     ; Clear your destination first.
	endm
	
; Build the delay macro 
	
Init:	bsf OSCCON, IRCF2 ; Internal Oscillator Frequency is set 4Mhz
	bsf OSCCON, IRCF1 ; Don't remove 3 lines !!!
	bcf OSCCON, IRCF0 
			  
			  ; Setting button1&button2 interrupt configuration on INTx(Just pick any 2 from Int0-Int2)  
			  ;
			  ;		  
			  ; Setting config for lighting LED (RD3-RD0)	
	bcf Button1Flag
	bcf Button2Flag
Divide:  ; divde 
	; You can write macro of divide, or not.
	; Input1 is Dividend, Input2 is Division. 
	; For example, 0xFFC / 0x11h =  0xFF0...0xC.
	; 0xFFC: Dividend (0xF: DividendH, 0xFC: DividendL). 
	; 0X11: Division.  0XFF0: Quotient. 0xc: Remainder
	; You must push result values to QUOTIENT(0X130), REMAINDERL(0x121) before you shift values.
Transfer:  
	; rotate register	
	; transfer values to specified file registers.
	; you can design a better method you think.
	
mainLoop: bra mainLoop
	  ; You must add some codes, then make your hardware is operated successfully.
	  ; about intx of button , just pick any 2 from int0-int2
	  ; Writing delay macro on interrupt service routine will get zero score.
	  ; hint: Button1Flag&Button2Flag are good partners!
	 
q_blink: 	; Designing Quotient_blink for Subroutine
	return 
r_blink: 	; Designing Remainder_blink for Subroutine
	return 
	
isr:	; Don't create Delay here!
	END