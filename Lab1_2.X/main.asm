; 實驗題目 : 用btfss實現 1+2+3+4+5.....+16
LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00		    
Initial:
    clrf TRISD
    clrf WREG
here:
    incf WREG
    addwf TRISD, 1
    btfss WREG, 4
    goto here    
end





