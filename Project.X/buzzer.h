#ifndef BUZZER_H
#define	BUZZER_H

#include <xc.h> // include processor files - each processor file is guarded.
#define base 3125
#define C4 523 //Do
#define D4 493 //Re
#define E4 440 //Mi
#define F4 392 //Fa
#define G4 349 //So
#define A4 329 //La
#define B4 293 //Si
#define C5 264 //Do

void buzz(int red, int green, int blue);
void Delay (int xc);
void init_buzzer();

int half_cyc = 0;
void buzz(int red, int green, int blue) {
    init_buzzer(); /* Start buzz */
    // 000
    if ((red >= 0 && red <=127) && 
        (green >= 0 && green <=127) &&
        (blue >= 0 && blue <=127)){
        half_cyc = C4;
    } 
    // 100
    else if ((red >= 128 && red <=255) && 
            (green >= 0 && green <=127) &&
            (blue >= 0 && blue <=127)){
        half_cyc = D4;
    }
    // 010
    else if ((red >= 0 && red <=127) && 
            (green >= 128 && green <=255) &&
            (blue >= 0 && blue <=127)){
        half_cyc = E4;
    } 
    // 001
    else if ((red >= 0 && red <=127) &&
            (green >= 0 && green <=127) &&
            (blue >= 128 && blue <=255)){
        half_cyc = F4;
    } 
    // 110
    else if ((red >= 128 && red <=255) &&
            (green >= 128 && green <=255) &&
            (blue >= 0 && blue <=127)){
        half_cyc = G4;
    } 
    // 101
    else if ((red >= 128 && red <=255) &&
            (green >= 0 && green <=127) &&
            (blue >= 128 && blue <=255)){
        half_cyc = A4;
    } 
    // 011
    else if ((red >= 0 && red <=127) &&
            (green >= 128 && green <=255) &&
            (blue >= 128 && blue <=255)){
        half_cyc = B4;
    } 
    // 111
    else if ((red >= 128 && red <=255) &&
            (green >= 128 && green <=255) &&
            (blue >= 128 && blue <=255)){
        half_cyc = C5;
    } 
    CCPR2 = TMR1 + half_cyc;
    Delay(5); //delay i*0.1 s
    
    TRISCbits.TRISC1 = 1; /* End buzz */
}

void Delay (int xc){
    T0CON = 0x84; /* enable TMR0 with prescalerset to 32 */
    if (xc == 1) TMR0 = 0xFFFF - 1 * base; /* set TMR0 to this value so it overflows in 0.1 second */
    else if (xc == 2) TMR0 = 0xFFFF - 2 * base; /* set TMR0 to this value so it overflows in 0.2 second */
    else if (xc == 3) TMR0 = 0xFFFF - 3 * base; /* set TMR0 to this value so it overflows in 0.3 second */
    else if (xc == 4) TMR0 = 0xFFFF - 4 * base; /* set TMR0 to this value so it overflows in 0.4 second */
    else if (xc == 5) TMR0 = 0xFFFF - 5 * base; /* set TMR0 to this value so it overflows in 0.5 second */
    else if (xc == 6) TMR0 = 0xFFFF - 6 * base; /* set TMR0 to this value so it overflows in 0.6 second */
    else if (xc == 7) TMR0 = 0xFFFF - 7 * base; /* set TMR0 to this value so it overflows in 0.7 second */
    else if (xc == 8) TMR0 = 0xFFFF - 8 * base; /* set TMR0 to this value so it overflows in 0.8 second */
    else if (xc == 9) TMR0 = 0xFFFF - 9 * base; /* set TMR0 to this value so it overflows in 0.9 second */
    else if (xc == 10) TMR0 = 0xFFFF - 10 * base; /* set TMR0 to this value so it overflows in 1.0 second */
    INTCONbits.TMR0IF = 0;
    while (!INTCONbits.TMR0IF);
}

void init_buzzer(){
    half_cyc = 0;
    CCPR2 = 0;
    TRISCbits.TRISC1 = 0; /* configure CCP2 pin for output */
    T3CON = 0x81; /* enables Timer3 in 16-bit mode, Timer1 for CCP1 time base */
    T1CON = 0x81; /* enable Timer1 in 16-bit mode */
    CCP2CON = 0x02; /* CCP2 compare mode, pin toggle on match */
    IPR2bits.CCP2IP = 1; /* set CCP2 interrupt to high priority */
    PIR2bits.CCP2IF = 0; /* clear CCP2IF flag */
    PIE2bits.CCP2IE = 1; /* enable CCP2 interrupt */
    INTCON |= 0xC0;/* enable high priority interrupt */
}

void __interrupt(high_priority) Hi_ISR(void)
{
    if(PIR2bits.CCP2IF == 1) {
        PIR2bits.CCP2IF = 0;
        CCPR2 += half_cyc; 
    }
    return ;
}

#endif

