; Lab2 for class A
;    1. Please build one arrays which can push 8 values. The value of one array is “1” to “8.
;    2. Inverts the value of the array. The mean is “1~8” become “8~1”.
; Lab2 for class B
;   1. Please build two arrays which can push 8 values. The value of one array is “1” to “8”,  the other is “8” to “1”.
;   2. Add two arrays to one array .
    
LIST p=18f4520		    
#include<p18f4520.inc>
    CONFIG OSC = INTIO67   
    CONFIG WDT = OFF	    
    org   0x00	
    
Start:
    clrf WREG
    lfsr FSR0, 0x120
    lfsr FSR1, 0x130

; 完成陣列1~8
S1:
    incf WREG
    btfss WREG, 3
    movff WREG, POSTINC0 ;為了最後指到0x128，讓第8筆資料在迴圈外執行，避免最後指到0x129
    btfss WREG, 3
    bra S1
movff WREG, INDF0 ;

clrf WREG
; 轉至整個陣列
S2:
    incf WREG
    movff POSTDEC0, POSTINC1
    btfss WREG, 3
    bra S2

end
