#include <xc.h>
#include <pic18f4520.h>
#include "string.h"
#include <stdio.h>
#include "Configuration_Header_File.h"
#include "usart.h"
#include "Buzzer.h"
unsigned int overflow_count=0;
unsigned int R,G,B;
extern int half_cyc;
void Timer_Init();                  
unsigned long Frequency_Count();
unsigned int MapRGB(unsigned long,unsigned long,unsigned long);
void OSCILLATOR_Initialize(void);

#define Select_LED LATD    
void main(void) {
    unsigned long r,g,b,clear;
    //unsigned int R,G,B;
    unsigned char value[10];
    OSCCON = 0x72;                      /*internal 8 MHz */
    Timer_Init();                        
    OSCILLATOR_Initialize();
    TRISDbits.TRISD0=0;                 /*  S3 output port */
    TRISDbits.TRISD1=0;                 /*  S2 output port */
    USART_Init(9600);                   
    
    while(1)
     {        
        Select_LED = 0x00;              
        r = Frequency_Count();          
        R = MapRGB(6000,100000,r);     
        if(R>255)
            R = 255;
        sprintf(value," %d   ",R);
        USART_SendString(value);
        
        Select_LED = 0x03;              
        g = Frequency_Count();          
        G = MapRGB(5000,60000,g);      
        if(G>255)
            G = 255;
        sprintf(value," %d  ",G);
        USART_SendString(value);
        
        Select_LED = 0x01;              
        b = Frequency_Count();          
        B = MapRGB(6000,95000,b);      
        if(B>255)
            B = 255;
        sprintf(value,"%d   ",B);
        USART_SendString(value);
        USART_TxChar(0x0A);
        USART_TxChar(0x0D);
        buzz(R,G,B);
        //display(R,G,B);
        
        memset(value,0,10);
        
     }
    return;
}
void __interrupt(high_priority) Hi_ISR(void){
    if(PIR2bits.CCP2IF == 1) {
        PIR2bits.CCP2IF = 0;
        CCPR2 += half_cyc; 
    }
    if(INTCONbits.TMR0IF){
        overflow_count++;
        TMR0IF=0;
    }
}
void Timer_Init()
{
    TRISAbits.RA4 = 1;
    T0CON = 0x28;
    TMR0IE = 1;
    TMR0IF = 0;
    INTCONbits.GIE=1;
    INTCONbits.PEIE=1;
}

void OSCILLATOR_Initialize(void)
{
    IRCF2 = 1; // default setting 8M Hz
    IRCF1 = 1;
    IRCF0 = 1; 
    RCON = 0x0000;
}
unsigned long Frequency_Count()
{
    unsigned long count;       
    TMR0 = 0;
    T0CONbits.TMR0ON=1;             
    MSdelay(100);                   
    T0CONbits.TMR0ON=0;             
    count = TMR0;                   
    count = 10*(count + ((65536*overflow_count)));  
    overflow_count=0;
    return (count);   
}

unsigned int MapRGB(unsigned long min, unsigned long max,unsigned long count)
{
    unsigned int val;
    val = 255*(float)((float)(count - min)/(float)(max-min));
    return val;
}
