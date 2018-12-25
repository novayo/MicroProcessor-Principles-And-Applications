#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
#define C4 262
#define F4 349
#define G4 392
#define A4 440
#define B4 494
#define E4 329
#define C5 523
#define D5 587
#define E5 659
#define F5 698
#define G5 783
// using namespace std;
#define base 7812
void DDelay (int xc)
{
    switch (xc){
        case 1: /* create 0.1 second delay (sixteenth note) */
            T0CON = 0x84; /* enable TMR0 with prescalerset to 32 */
            //T0CONbits.T0CS = 0;
            TMR0 = 0xFFFF - base; /* set TMR0 to this value so it overflows in 0.25 second */
            INTCONbits.TMR0IF = 0;
            while (!INTCONbits.TMR0IF);
            break;
       case 2: /* create 0.2 second delay (eighth note) */
            T0CON = 0x84; /* set prescalerto Timer0 to 32 */
            //T0CONbits.T0CS = 0;
            TMR0 = 0xFFFF -2 * base; /* set TMR0 to this value so it overflows in 0.5 second */
            INTCONbits.TMR0IF = 0;
            while (!INTCONbits.TMR0IF);
            break;
       case 3: /* create 0.2 second delay (eighth note) */
            T0CON = 0x84; /* set prescalerto Timer0 to 32 */
            //T0CONbits.T0CS = 0;
            TMR0 = 0xFFFF -3 * base; /* set TMR0 to this value so it overflows in 0.5 second */
            INTCONbits.TMR0IF = 0;
            while (!INTCONbits.TMR0IF);
            break;
       case 4: /* create 0.2 second delay (eighth note) */
            T0CON = 0x84; /* set prescalerto Timer0 to 32 */
            //T0CONbits.T0CS = 0;
            TMR0 = 0xFFFF -4 * base; /* set TMR0 to this value so it overflows in 0.5 second */
            INTCONbits.TMR0IF = 0;
            while (!INTCONbits.TMR0IF);
            break;
        default:
            break;
    }
}

int mode1 = 0;
int mode2 = 0;
int mode3 = 0;
char str[10];
int leds;
void Mode1() // print "Hello world"
{
    leds = str[6] - 48;
    int unit = str[8] - 48;
    ClearBuffer();
    while(strcmp(GetString(), "q") != 0){
        ClearBuffer();
        // TODO 
        // Output the result on Command-line Interface.
        if (leds == 1){
            LATDbits.LATD0 = 1;
            LATDbits.LATD1 = 0;
            LATDbits.LATD2 = 0;
            LATDbits.LATD3 = 0;
        } else if (leds == 2){
            LATDbits.LATD0 = 1;
            LATDbits.LATD1 = 1;
            LATDbits.LATD2 = 0;
            LATDbits.LATD3 = 0;
        } else if (leds == 3){
            LATDbits.LATD0 = 1;
            LATDbits.LATD1 = 1;
            LATDbits.LATD2 = 1;
            LATDbits.LATD3 = 0;
        } else if (leds == 4){
            LATDbits.LATD0 = 1;
            LATDbits.LATD1 = 1;
            LATDbits.LATD2 = 1;
            LATDbits.LATD3 = 1;
        } else{
            UART_Write_Text(" GG");
        }
        DDelay(unit);
        LATDbits.LATD0 = 0;
        LATDbits.LATD1 = 0;
        LATDbits.LATD2 = 0;
        LATDbits.LATD3 = 0;
        DDelay(unit);
    }
    LATDbits.LATD0 = 0;
    LATDbits.LATD1 = 0;
    LATDbits.LATD2 = 0;
    LATDbits.LATD3 = 0;
    mode1 = 0;
}

void Mode2() { // Output Voltage
    ClearBuffer();
    int i=0;
    int digital = 0;
    float voltage = 0.0;
    while(strcmp(GetString(), "q") != 0){
        ClearBuffer();
        digital=ADC_Read(0);
        voltage = digital* ((float)5/1023); // 5v / 2^10-1  (10bits)
        CCPR1L = (int)voltage * 40;
        //sprintf(str, "%d|", CCPR1L);
        //UART_Write_Text(str); // ????
        while(CCPR1L < 199){
            for(i = 0 ; i < 100 ; i++) ; // a delay time
            CCPR1L++;
        }
        while(CCPR1L > (int)voltage){
            for(i = 0 ; i < 100 ; i++) ; // a delay time
            CCPR1L--;
        }
    }
    CCPR1 = 0x00;
    mode2=0;
}

int per_arrp[30] = { G5, E5, E5, 0, F5, D5, D5, 0, C5, D5, E5, F5, G5, G5, G5, 0,
G5, E5, E5, 0, F5, D5, D5, 0, C5, E5, G5, G5, E5, 0
};
int wait[2] = {1};

int per_arrp1[19] = { E4, G4, A4, A4, 0, A4, B4, C5, C5, 0, C5, D5, B4, B4, 0, A4, G4, A4, 0
};
int wait1[19] = {1,1,2,1,1,1,1,2,1,1,1,1,2,1,1,1,1,3,1};
int half_cyc = 0;
void Mode3() { // Output Voltage
    int i;
    TRISCbits.TRISC1 = 0; /* configure CCP1 pin for output */
    T3CON = 0x81; /* enables Timer3 in 16-bit mode, Timer1 for CCP1 time base */
    T1CON = 0x81; /* enable Timer1 in 16-bit mode */
    CCP2CON = 0x02; /* CCP1 compare mode, pin toggle on match */
    IPR2bits.CCP2IP = 1; /* set CCP1 interrupt to high priority */
    PIR2bits.CCP2IF = 0; /* clear CCP1IF flag */
    PIE2bits.CCP2IE = 1; /* enable CCP1 interrupt */
    INTCON |= 0xC0;/* enable high priority interrupt */
    while(strcmp(GetString(), "q") != 0){
        if (strcmp("music 1", str) == 0){
                i= 0;
                half_cyc = per_arrp[0];
                CCPR2 = TMR1 + half_cyc;
                while (i< 30) {
                    half_cyc= per_arrp[i]; /* get the cycle count for half period of the note */
                    DDelay (wait[i%2]);/* stay for the duration of the note */
                    i++;
                }

                INTCON &= 0x3F; /* disable interrupt */
                DDelay (3);
                DDelay (3);
                INTCON |= 0xC0; /* re-enable interrupt */
        } else if (strcmp("music 2", str) == 0){
                i= 0;
                half_cyc = per_arrp[0];
                CCPR2 = TMR1 + half_cyc;
                while (i< 19) {
                    half_cyc= per_arrp1[i]; /* get the cycle count for half period of the note */
                    DDelay (wait1[i]);/* stay for the duration of the note */
                    i++;
                }

                INTCON &= 0x3F; /* disable interrupt */
                DDelay (3);
                DDelay (3);
                INTCON |= 0xC0; /* re-enable interrupt */
        }
    }
    //CCP1_Initialize();
    CCPR2 = 0;
    mode3=0;
    ClearBuffer();
}

void main(void) 
{
    SYSTEM_Initialize() ;
    int q = 1;
    while(1) {
        // TODO
        // "clear" > clear UART Buffer()
        strcpy(str, GetString());
        if (mode1 == 1){
            if (strlen(str) == 9){ 
                Mode1();
            } else if (strcmp("q", str) == 0){
                mode1 = 0;
            }
            continue;
        }
        if (mode2 == 1){
            if (strcmp("breathe", str) == 0){ 
                Mode2();
            } else if (strcmp("q", str) == 0){
                mode2 = 0;
            }
            continue;
        }
        if (mode3 == 1){
            if (strlen(str) == 7){ 
                Mode3();
            } else if (strcmp("q", str) == 0){
                mode3 = 0;
            }
            continue;
        }
        if (strcmp("q", str) == 0){ 
            ClearBuffer();
            q = 1;
        }
        // "mode1" > start Mode1 function as above
        else if (strcmp("s", str) == 0) { //stop music
            ClearBuffer();
            UART_Write_Text("s");
            q=0;
            
        }
        // "mode2" > start Mode2 function as above
        else if (strcmp("p", str) == 0) { //play music
            ClearBuffer();
            UART_Write_Text("p");
            q=0;
            
        }
        if (q == 1){
            if (strcmp("Mode1", str) == 0){  // blink 2 1
                ClearBuffer();
                mode1 = 1;
            } else if (strcmp("Mode2", str) == 0) { // breathe
                ClearBuffer();
                mode2 = 1;
            } else if (strcmp("Mode3", str) == 0) { // music 1
                ClearBuffer();
                mode3 = 1;
            }
        }
    }
    return;
    
}

// old version: 
// void interrupt high_priority Hi_ISR(void)
void __interrupt(high_priority) Hi_ISR(void)
{
    if (mode2 == 1){
        if(PIR1bits.CCP1IF == 1) {
            RC2 ^= 1;
            PIR1bits.CCP1IF = 0;
            TMR3 = 0;
        }
        return ;
    } else if (mode3 == 1){
        if(PIR2bits.CCP2IF == 1) {
            //RC2 ^= 1;
            PIR2bits.CCP2IF = 0;
            //TMR3 = 0;
            CCPR2 += half_cyc; 
        }
        return ;
    } else{
        if(PIR1bits.CCP1IF == 1) {
            RC2 ^= 1;
            PIR1bits.CCP1IF = 0;
            TMR3 = 0;
        }
        if(PIR2bits.CCP2IF == 1) {
            RC2 ^= 1;
            PIR2bits.CCP2IF = 0;
            TMR3 = 0;
        }
        return ;
    }
}