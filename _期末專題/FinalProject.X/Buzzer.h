#ifndef BUZZER_H
#define	BUZZER_H

#include <xc.h> // include processor files - each processor file is guarded.
#define base 3125
#define C4 523 //Do
#define D4 493 //Re
#define E4 440 //Mi
#define F4 392 //Fa
#define G4 349 //So
#define A4 329 //La
#define B4 293 //Si
#define C5 264 //Do

void buzz(int red, int green, int blue);
void Delay (int xc);
void init_buzzer();
void MSdelay(unsigned int val);


#endif

