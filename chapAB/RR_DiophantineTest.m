% script RR_DiophantineTest
% Tests the Diophantine code on both integers and polynomials
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Set up a simple integer Diophantine problem (solve a*x+b*y=f for x and y)')
a=RR_int(385),  b=RR_int(357), f=RR_int(21)
[x,y,r,t]=RR_Diophantine(a,b,f), residual=a*x+b*y-f, pause
disp('A different (randomly generated) solution to the same problem')
k=randi([-10 10]), xk=x+r*k, yk=y+t*k, residualk=a*xk+b*yk-f, pause

disp('The following case does NOT work, as f_fail is not a multiple of the GCF!')
f=RR_int(25), [x,y,r,t]=RR_Diophantine(a,b,f), residualk=a*xk+b*yk-f, disp('Note nonzero residual.'), pause

clear % now switch everything from RR_int types to RR_poly types

disp('Set up the Diophantine problem (solve a*x1+b*y1=f1 for x1 and y1) in NR Example 19.9')
b=RR_poly([-2 2],'roots'), a=RR_poly([-1 1 -3 3],'roots'), f1=RR_poly([-1 -1 -3 -3],'roots')
[x1,y1] = RR_Diophantine(a,b,f1), test1=a*x1+b*y1, residual1=norm(f1-test1)
fprintf('Note that the solution {x1,y1} is improper, but solves a*x1+b*y1=f1, with ~ zero residual\n\n'), pause

disp('Modify f and try again (solve a*x2+b*y2=f2 for x2 and y2).')
f2=RR_poly([-1 -1 -3 -3 -30 -30 -30 -30],'roots')
[x2,y2] = RR_Diophantine(a,b,f2), test2=a*x2+b*y2, residual2=norm(f2-test2)
fprintf('Note that the solution {x2,y2} is proper, and solves a*x2+b*y2=f2\n\n'), pause

disp('Now set up the Diophantine problem (solve a3*x3+b3*y3=f3 for x3 and y3) in NR Example 19.13')
b3=RR_poly([0.0306 0.0455]), a3=RR_poly([1 -3.9397 3.3201]), f3=RR_poly([1 0 0 0])
[x3,y3] = RR_Diophantine(a3,b3,f3), test3=a3*x3+b3*y3, residual3=norm(f3-test3)
fprintf('Note that this solution {x,y} is semi-proper, and solves a3*x3+b3*y3=f3\n\n'), pause

disp('Now set up one more Diophantine problem (solve a4*x4+b4*y4=f4 for x4 and y4)')
b4=RR_poly([1 -1 -2]), a4=RR_poly([1 2 -13 -14 24]), f4=RR_poly([1 8 22 24 9])
[x4,y4] = RR_Diophantine(a4,b4,f4), test4=a4*x4+b4*y4, residual4=norm(f4-test4)
fprintf('Note that this solution {x,y} is improper, and solves a4*x4+b4*y4=f4\n\n')

% end script RR_DiophantineTest
