% script 2024 143a midterm problem 1

clear, close all
Fap1=RR_tf([1 -1],[1 1]) % define Fap1 using num and den polynomials
figure(1), RR_bode(Fap1)
figure(2), RR_step(Fap1)
figure(3), g.T=10; RR_impulse(Fap1,g)

Fap1a=RR_tf([1],[-1],1)

