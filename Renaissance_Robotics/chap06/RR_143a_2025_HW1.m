% script RR_143a_2025_HW1

clear; syms L1 L2 L3 L4 L5 L6 L7 L8 L9 x y z u
eqn1= L1*x+L2*y==0;
eqn2= L3*x+L4*y+L5*z==0;
eqn3= L6*x+L7*y+L8*z==L9*u;
sol=solve(eqn1,eqn2,eqn3,x,y,z); G=sol.y/u
