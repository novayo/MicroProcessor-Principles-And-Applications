#include "usart.h"

void USART_Init(long baud_rate)
{
    float temp;
    TRISC6=0;                       
    TRISC7=1;                       
    temp=Baud_value;     
    SPBRG=(int)temp;                
    TXSTA=0x20;                    
    RCSTA=0x90;                     
} 
void USART_TxChar(char out)
{        
        while(TXIF==0);           
        TXREG=out;                 
                                       
}
char USART_RxChar()
{

    while(RCIF==0);                
    return(RCREG);                 
}
void USART_SendString(const char *out)
{
   while(*out!='\0')
   {            
        USART_TxChar(*out);
        out++;
   }
}
void display(int R,int G,int B)
{
    if(R<128)
    {
        if(G<128)
        {
            if(B<128)
            {
                USART_SendString("Black");
            }
            else
            {
                USART_SendString("Blue");
            }
        }
        else
        {
            
            if(B<128)
            {
                USART_SendString("Lime");
            }
            else
            {
                USART_SendString("Cyan");
            }
        }
    }
    else
    {
        if(G<128)
        {
            if(B<128)
            {
                USART_SendString("Red");
            }
            else
            {
                USART_SendString("Magenta");
            }
        }
        else
        {
            
            if(B<128)
            {
                USART_SendString("Yellow");
            }
            else
            {
                USART_SendString("White");
            }
        }
    }
}

