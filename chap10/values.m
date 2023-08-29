% script values.m
% note: for R=1 ohm, omega0=10^4 rad/s, Q=5, 
% which give reasonable component values...
R=1; omega0=10000; Q=5; c1=0
syms L C
eqn1= omega0==1/sqrt(L*C)
eqn2= Q==(1+c1)*sqrt(L/C)/R
sol=solve(eqn1,eqn2,L,C);
L_value=simplify(sol.L)
C_value=simplify(sol.C)
% Exact result is L=500 uH (microHenries), C=20 uF (microFarads)
% Now convert to common values in the E24 family:
L_E24=RR_common_resistor_values(eval(L_value(2)),24,'closest')
C_E24=RR_common_resistor_values(eval(C_value(2)),24,'closest')
% In E24, we have: L=510 uH, C=? uF
