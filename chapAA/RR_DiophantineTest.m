% script RR_DiophantineTest
% Tests the Diophantine code on both integers and polynomials
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clc, disp('Set up a simple integer Diophantine problem (solve a*x+b*y=f for x and y)')
a=RR_int(385),  b=RR_int(357), f=RR_int(21)
[x,y,r,t]=RR_Diophantine(a,b,f), residual=a*x+b*y-f, pause
disp('A different solution, a*X+b*Y=f (X=x+(b/g)*k, Y=y-(a/g)*k, randomly-generated k)')
k=randi([-10 10]), X=x+r*k, Y=y-t*k, residual=a*X+b*Y-f, pause

disp('The following case does NOT work, as fbad is not a multiple of the GCF!')
fbad=RR_int(25), [x,y,r,t]=RR_Diophantine(a,b,fbad), residual=a*x+b*y-fbad, disp('Note nonzero residual.'), pause

clear, disp(' ') % now switch everything from RR_int types to RR_poly types

disp('Set up the Diophantine problem (solve a*x1+b*y1=f1 for x1 and y1) in NR Example 19.9')
b=RR_poly([-2 2],1), a=RR_poly([-1 1 -3 3],1), f1=RR_poly([-1 -1 -3 -3],1)
[x1,y1] = RR_Diophantine(a,b,f1), test1=trim(a*x1+b*y1), residual1=norm(f1-test1)
fprintf('Note that the solution {x1,y1} is improper (x1.n<y1.n), but solves a*x1+b*y1=f1 with ~ zero residual\n\n'), pause

disp('Modify f and try again (solve a*x2+b*y2=f2 for x2 and y2).')
f2=RR_poly([-1 -1 -3 -3 -30 -30 -30 -30],1)
[x2,y2] = RR_Diophantine(a,b,f2), test2=trim(a*x2+b*y2), residual2=norm(f2-test2)
fprintf('Note that the solution {x2,y2} is proper (x2.n>y2.n), and solves a*x2+b*y2=f2 with ~ zero residual\n\n'), pause

disp('Now set up the Diophantine problem (solve a3*x3+b3*y3=f3 for x3 and y3) in NR Example 19.13')
b3=RR_poly([0.0306 0.0455]), a3=RR_poly([1 -3.9397 3.3201]), f3=RR_poly([1 0 0 0])
[x3,y3] = RR_Diophantine(a3,b3,f3), test3=trim(a3*x3+b3*y3), residual3=norm(f3-test3)
fprintf('Note that the solution {x3,y3} is semi-proper (x3.n=y3.n), and solves a3*x3+b3*y3=f3 with ~ zero residual\n\n'), pause

disp('Now set up one more Diophantine problem (solve a4*x4+b4*y4=f4 for x4 and y4)')
b4=RR_poly([1 -1 -2]), a4=RR_poly([1 2 -13 -14 24]), f4=RR_poly([1 8 22 24 9])
[x4,y4] = RR_Diophantine(a4,b4,f4), test4=trim(a4*x4+b4*y4), residual4=norm(f4-test4)
fprintf('Note that the solution {x4,y4} is improper (x4.n<y4.n), and solves a4*x4+b4*y4=f4 with ~ zero residual\n\n')

% end script RR_DiophantineTest
