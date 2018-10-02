LIST p=18f4520		    ; 1, 2行設定板子型號
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   ; 設定板子初始化 => 使 Oscillator 的 port function 設定在 RA6 和 RA7
    CONFIG WDT = OFF	    ; 設定板子初始化 => 關掉 Watchdog Timer
    org   0x00		    ; 程式都從 0x00 開始
Initial:
start:
    clrf WREG
    clrf TRISD
    
    incf WREG
    movlw 0x03
    addlw 0x06
    addwf TRISD, 1
here:
    decfsz TRISD    ; 執行9次，類似於for迴圈
    goto here
continue:
    btfsc TRISD, 0
    addwf TRISD, 1
    
end











