% script RR_Subspaces_Test
% Uses RR_Subspaces to print out some interesting facts about a few interesting matrices.
% The results that this script generates are helpful for understanding the Strang plot.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, format short
clc, A=[1 2 3;4 5 6;7 8 0];
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A);

clc, A=[2 -2 -4;-1 3 4;1 -2 -3];
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A);
disp('here is a surprise! A is idempotent!');
A, A_times_A=A*A, pause, disp(' ')

clc, A=[2 2 -2;5 1 -3;1 5 -3];
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A);
disp('here is a surprise! (A is nilpotent of degree 3)');
A, A_times_A=A*A, A_times_A_times_A=A*A*A, pause

clc, A=[1 2;3 4;0 0];
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A);

clc, A=[1 2 0;3 4 0];
[C,L,R,N,Ap,r,n,m]=RR_Subspaces(A);

disp('Some pretty nifty stuff, eh?')