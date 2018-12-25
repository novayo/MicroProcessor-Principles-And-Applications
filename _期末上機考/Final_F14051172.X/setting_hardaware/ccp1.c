#include <xc.h>

void CCP1_Initialize() {
    TRISCbits.TRISC2=0;	// RC2 pin is output.
    TMR2=0;
    T3CON = 0x81;
    T1CON = 0x81;
    PR2 = 199;
    CCPR1L = 0;
    T2CON = 0x05;
    CCP1CON=0x0C;		
    INTCON |= 0xC0;/* enable high priority interrupt */
    PIR1bits.CCP1IF=0;
    IPR1bits.CCP1IP = 1;
    PIE1bits.CCP1IE = 1; /* enable CCP1 interrupt */
}
