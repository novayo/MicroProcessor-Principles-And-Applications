#include <xc.h>
#include <pic18f4520.h>
#pragma config OSC  = INTIO67,WDT=OFF,LVP=OFF
#pragma PBADEN = 1 //set AN0~AN12 as analog input

void adc_init(void);
void ccp2_init(void);
void tmr_init(void);

int ans[10];
int i=0;
void __interrupt(high_priority) Hi_ISR(void)
{
    //deal ccp2 interrupt and adc interrupt
    if(PIR1bits.ADIF){//AD conversion finish
        ans[i] = ADRES;
        i++;
        if (i==10) i = 0;
        
        PIR1bits.ADIF = 0;
        ADCON0bits.ADON = 1;
        PIR2bits.CCP2IF = 0;
    }
    else if(PIR2bits.CCP2IF){ //special event triger
        PIR2bits.CCP2IF = 0;
        //CCPR2 = 250000/8;
    }
    return ;
}

void main(void) {
    //change OSC if you want
    //    OSCCONbits.IRCF = ??;
    // set 2Mhz
    //OSCCON.bits.IRCF2 = 1;
    //OSCCON.bits.IRCF1 = 0;
    //OSCCON.bits.IRCF0 = 1;
    adc_init();
    ccp2_init();
    tmr_init();
    while(1);
    return;
}

void adc_init(void){
    //datasheet p232 TABLE 19-2
    //Configure the A/D module
    
    //ADCON0
    //select analog channel
    ADCON0bits.CHS3 = 0;
    ADCON0bits.CHS2 = 1;
    ADCON0bits.CHS1 = 1;
    ADCON0bits.CHS0 = 1;
    //ADCON0bits.GO = 0;
    ADCON0bits.ADON = 1;
    //set TRIS
    TRISEbits.TRISE2 = 1; //set as input
    //Turn on A/D module
    ADCON0bits.GO = 1;
    //ADCON1 //set refer voltage
    ADCON1bits.VCFG1 = 0;
    ADCON1bits.VCFG0 = 0;

    //ADCON2
    //A/D Conversion Clock
    ADCON2bits.ADCS2 = 1;
    ADCON2bits.ADCS1 = 1;
    ADCON2bits.ADCS0 = 1;
    //Acquisition Time
    ADCON2bits.ACQT2 = 0;
    ADCON2bits.ACQT1 = 0;
    ADCON2bits.ACQT0 = 1;
    //left or right justified
    ADCON2bits.ADFM = 1;
    //Configure A/D interrupt(optional)
    PIE1bits.ADIE = 1;
    IPR1bits.ADIP = 1;
    //enable Interrupt Priority mode
    RCONbits.IPEN = 1;
    INTCONbits.GIE = 1;
    INTCONbits.PEIE = 1; //agfweagfwagawgwargaw
}

void ccp2_init(void){
    //Configure CCP2 mode,ref datasheet p139
    //CCP2CON = 0b00001011;
    CCP2CONbits.CCP2M3 = 1;
    CCP2CONbits.CCP2M2 = 0;
    CCP2CONbits.CCP2M1 = 1;
    CCP2CONbits.CCP2M0 = 1;
    //configure CCP2 interrupt
    PIE2bits.CCP2IE = 1;
    IPR2bits.CCP2IP = 1;  //gaerwgwaegwargargear
    //configure CCP2 comparator value
    // 石英震盪器 = 1MHz -> 1000000/4 = 250000
    // 250000 / T3預除器 = 250000/8 = 31250
    CCPR2 = 250000/8;
}

void tmr_init(void){
    //set up timer3, ref datasheet p135
    //no need to turn up timer3 interrupt
    T3CONbits.RD16 = 1;
    T3CONbits.T3CCP2 = 1;
    T3CONbits.T3CCP1 = 1;
    T3CONbits.TMR3ON =1;
}