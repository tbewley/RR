% script RR_diophantine_test
% Tests the Diophantine code on both integers and polynomials
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 
  
clc, disp('Set up a simple integer Diophantine problem (solve a*x+b*y=f for x and y)')
a=RR_int32(385),  b=RR_int32(357), f=RR_int32(21)
[x,y,r,t]=RR_diophantine(a,b,f), residual=a*x+b*y-f, pause
disp('A different solution, a*X+b*Y=f (X=x+(b/g)*k, Y=y-(a/g)*k, randomly-generated k)')
k=randi([-10 10]), X=x+r*k, Y=y-t*k, residual=a*X+b*Y-f, pause

disp('The following case does NOT work, as fbad is not a multiple of the GCF!')
fbad=RR_int32(25), [x,y,r,t]=RR_diophantine(a,b,fbad), residual=a*x+b*y-fbad, disp('Note nonzero residual!'), pause

clear, disp(' ') % now switch everything from RR_int types to RR_poly types

disp('Set up the Diophantine problem (solve a*x1+b*y1=f1 for x1 and y1) in NR Example 19.9')
b=RR_poly([-2 2],1), a=RR_poly([-1 1 -3 3],1), f1=RR_poly([-1 -1 -3 -3],1)
[x1,y1] = RR_diophantine(a,b,f1), test1=trim(a*x1+b*y1), residual1=norm(f1-test1)
fprintf('Note that the solution {x1,y1} is improper (x1.n<y1.n), but solves a*x1+b*y1=f1 with ~ zero residual\n\n'), pause

disp('Modify f and try again (solve a*x2+b*y2=f2 for x2 and y2).')
f2=RR_poly([-1 -1 -3 -3 -30 -30 -30 -30],1)
[x2,y2] = RR_diophantine(a,b,f2), test2=trim(a*x2+b*y2), residual2=norm(f2-test2)
fprintf('Note that the solution {x2,y2} is strictly proper (x2.n>y2.n), and solves a*x2+b*y2=f2 with ~ zero residual\n\n'), pause

disp('Set up a new Diophantine problem')
b=RR_poly([0.0306 0.0455]), a=RR_poly([1 -3.9397 3.3201]), f=RR_poly([1 0 0 0])
[x,y] = RR_diophantine(a,b,f), test=trim(a*x+b*y), residual=norm(f-test)
fprintf('Note that the solution {x,y} is semi-proper (x.n=y.n), and solves a*x+b*y=f with ~ zero residual\n\n'), pause

disp('Set up a new Diophantine problem')
b=RR_poly([1 -1 -2]), a=RR_poly([1 2 -13 -14 24]), f=RR_poly([1 8 22 24 9])
[x,y] = RR_diophantine(a,b,f), test=trim(a*x+b*y), residual=norm(f-test)
fprintf('Note that the solution {x,y} is improper (x.n<y.n), but solves a*x+b*y=f with ~ zero residual\n\n'), pause

disp('Set up a new Diophantine problem')
b=RR_poly([-2 2 -4 4],1), a=RR_poly([-1 1 -3 3 -5 5],1)
f=RR_poly([-1 -1 -3 -3 -5 -5],1)
[x,y] = RR_diophantine(a,b,f), test=trim(a*x+b*y), residual1=norm(f-test)
fprintf('Note that the solution {x,y} is improper (x.n<y.n), and solves a*x+b*y=f with ~ zero residual\n\n')

disp('Set up a new Diophantine problem')
b=RR_poly([-2 2 -4 4],1), a=RR_poly([-1 1 -3 3 -5 5],1)
f=RR_poly([-1 -1 -3 -3 -5 -5 -20 -20 -20 -20 -20],1)
[x,y] = RR_diophantine(a,b,f), test=trim(a*x+b*y), residual1=norm(f-test)
fprintf('Note that the solution {x,y} is proper (x.n=y.n), and solves a*x+b*y=f with ~ zero residual\n\n')

% end script RR_DiophantineTest
