#include "setting_hardaware/setting.h"
#include <stdlib.h>
#include "stdio.h"
#include "string.h"
// using namespace std;

char str[10];

void Mode1() // print "Hello world"
{
    ClearBuffer();
    // TODO 
    // Output the result on Command-line Interface.
    UART_Write_Text("Hello "); // ????
    UART_Write_Text("world"); // ????
}

void Mode2() { // Output Voltage 
    ClearBuffer();
    int digital = 0;
    float voltage = 0.0;
    while(strcmp(GetString(), "z") != 0) // TODO design a condition. Return to main function when the while loop is over.
    {
        ClearBuffer();
        digital=ADC_Read(0);
        voltage = digital* ((float)5/1023); // 5v / 2^10-1  (10bits)
        // TODO
        // Output the voltage on CLI.
        // The voltage must have the second digit after the decimal point.
        sprintf(str, "%f", voltage); // ????
        UART_Write_Text(str); // ????
        for(int i = 0 ; i < 10000 ; i++) ; // a delay time
        
    }
    
    ClearBuffer();
}

void main(void) 
{
    
    SYSTEM_Initialize() ;
    
    while(1) {
        // TODO
        // "clear" > clear UART Buffer()
        strcpy(str, GetString());
        if (strcmp("clear", str) == 0) ClearBuffer();
        // "mode1" > start Mode1 function as above
        else if (strcmp("mode1", str) == 0) Mode1();
        // "mode2" > start Mode2 function as above
        else if (strcmp("mode2", str) == 0) Mode2();
        
        //if (strlen(str) > 5) ClearBuffer();
    }
    return;
    
}

// old version: 
// void interrupt high_priority Hi_ISR(void)
void __interrupt(high_priority) Hi_ISR(void)
{
    if(PIR1bits.CCP1IF == 1) {
        RC2 ^= 1;
        PIR1bits.CCP1IF = 0;
        TMR3 = 0;
    }
    return ;
}