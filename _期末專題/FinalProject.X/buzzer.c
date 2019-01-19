/*
 * File:   buzzer.c
 * Author: user
 *
 * Created on 2019年1月10日, 下午 9:44
 */


#include <xc.h>
#include "Buzzer.h"

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
    MSdelay(750); //delay i*0.1 s
    
    TRISCbits.TRISC1 = 1; /* End buzz */
    MSdelay(250);
}

void MSdelay(unsigned int val)
{
     unsigned int i,j;
        for(i=0;i<val;i++)
            for(j=0;j<165;j++);      /*This count Provide delay of 1 ms for 8MHz Frequency */
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
    //INTCON |= 0xC0;/* enable high priority interrupt */
}


