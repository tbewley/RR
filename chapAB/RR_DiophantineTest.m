% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Set up the Diophantine problem (solve a*x1+b*y1=f1 for x1 and y1) in NR Example 19.9')
b=[1 0 -4], a=[1 0 -10 0 9], f1=RR_PolyConv([1 1],[1 1],[1 3],[1 3])
[x1,y1] = RR_Diophantine(a,b,f1)
test1=RR_PolyAdd(RR_PolyConv(a,x1),RR_PolyConv(b,y1)); residual1=norm(RR_PolyAdd(f1,-test1))
fprintf('Note that the solution {x1,y1} is improper, but solves a*x1+b*y1=f1, with ~ zero residual\n\n'), pause

disp('Modify f and try again (solve a*x2+b*y2=f2 for x2 and y2).')
f2=RR_PolyConv([1 1],[1 1],[1 3],[1 3],[1 30],[1 30],[1 30],[1 30])
[x2,y2] = RR_Diophantine(a,b,f2)
test2=RR_PolyAdd(RR_PolyConv(a,x2),RR_PolyConv(b,y2)); residual2=norm(RR_PolyAdd(f2,-test2))
fprintf('Note that the solution {x2,y2} is proper, and solves a*x2+b*y2=f2\n\n'), pause

disp('Now set up the Diophantine problem (solve a3*x3+b3*y3=f3 for x3 and y3) in NR Example 19.13')
b3=[0.0306 0.0455], a3=[1 -3.9397 3.3201], f3=[1 0 0 0]
[x3,y3] = RR_Diophantine(a3,b3,f3)
test3=RR_PolyAdd(RR_PolyConv(a3,x3),RR_PolyConv(b3,y3)); residual=norm(RR_PolyAdd(f3,-test3))
fprintf('Note that this solution {x,y} is semi-proper, and solves a3*x3+b3*y3=f3\n\n'), pause

disp('Now set up one more Diophantine problem (solve a4*x4+b4*y4=f4 for x4 and y4)')
b4=[1 -1 -2], a4=[1 2 -13 -14 24], f4=[1 8 22 24 9]
[x4,y4] = RR_Diophantine(a4,b4,f4)
test4=RR_PolyAdd(RR_PolyConv(a4,x4),RR_PolyConv(b4,y4)); residual=norm(RR_PolyAdd(f4,-test4))
fprintf('Note that this solution {x,y} is improper, and solves a4*x4+b4*y4=f4\n\n')

% end scritp RR_DiophantineTest
