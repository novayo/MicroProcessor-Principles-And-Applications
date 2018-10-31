// A*B=C
// carry C B A
// 
// 8 bit -> n=8
// while(n--){
//  carry_C_B -> right shift at the same time
//  if(B0 == 0) continue;
//  else C = C + A  //care carry
// }
// final ans is C_B
    
#include "xc.inc"
GLOBAL _mul
    
PSECT mytext, local, class=CODE, reloc=2
 
_mul:
Init:
    /* A*B=C */
    // A
    MOVFF 0x001, LATA
    
    // B
    MOVFF 0x003, LATB 
    
    // C
    CLRF LATC 
    
    // N = 8
    MOVLW 8
    MOVFF WREG, LATD
    
For:
    //tmp
    CLRF LATE 
    
    // If C0 == 1, tmp = 1
    BTFSC LATC, 0
    INCF LATE
    
    // Right-shift C and B
    RRCF LATC
    RRCF LATB
    
    // If tmp == 1, B7 = 1
    BTFSC LATE, 0
    BSF LATB, 7
    
    // If B0 == 0, continue
    BTFSS LATB, 0
    GOTO Continue
    
    // else C=C+A
    MOVFF LATA, WREG
    ADDWF LATC, F
    
Continue:    
    DECFSZ LATD
    GOTO For
    
    // C_B is an answer (C_B is 16 bits -> But I only return B(8 bits) back to main.c)
    MOVFF LATB, 0x001
    
    RETURN





