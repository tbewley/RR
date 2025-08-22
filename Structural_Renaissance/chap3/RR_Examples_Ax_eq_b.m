% script RR_Examples_Ax_eq_b
% This self explanatory script just runs through the several Ax=b examples in §3.1-3.3 of SR.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clc, A=diag([2 3 4]),       b=[3; 9; 8],    x=A\b, error=norm(A*x-b), pause
clc, A=[2 3 4;0 2 5;0 0 4], b=[25; 16; 8],  x=A\b, error=norm(A*x-b), pause
clc, A=[1 2 3;4 5 6;7 8 0], b=[10; 28; 37], x=A\b, error=norm(A*x-b), pause
clc, A=[0 4 5;2 1 0;8 8 7], b=[6; 0; 8],    x=A\b, error=norm(A*x-b), pause
clc, disp('Now running a very big (10000 x 10000) Ax=b problem.  Please be patient.'),
     A=rand(10000,10000); b=rand(10000,1); tic, x=A\b; toc, error=norm(A*x-b), pause
clc, A=[1 2 3;4 5 6;7 8 9], b=[11; 29; 47],  x=A\b, error=norm(A*x-b),   pause
     x1=[1 5 0]', error1=norm(A*x1-b), x2=[2 3 1]', error2=norm(A*x2-b), pause
clc, A=[1 2 3;4 5 6;7 8 9], bbad=[11; 29; 48], xbad=A\bbad, error_bad=norm(A*xbad-b), pause
clc, A=[1 2 3;4 5 6;7 8 9], [C,L,R,N]=RR_Subspaces(A,false)