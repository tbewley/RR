% script RR_Example_2_1
% Computes the static loads in the three-story building considered in Example 2.1 of RC. 
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% Depends on RR_GaussPP

disp('Now computing the static loads in the three-story building of Example 2.1 of RC.')
a=1/sqrt(2); m=1000; g=9.8;
A = [
0  0  0  0  1  0  0  0  0  0  0 -a;
0  0  0  0  0  1  0  0  0  0  0  0;
0  0  1  0 -1  0  0  0  0  0 -a  0;
0  0  0  1  0 -1  0  0  0  0  0  a;
1  0 -1  0  0  0  0  0  0 -a  0  0;
0  1  0 -1  0  0  0  0  0  0  a  0;
0  0  0  0  0  0  0  0 -1  0  0  a;
0  0  0  0  0  0  0  0  1  0  0  0;
0  0  0  0  0  0  0 -1  0  0  a  0;
0  0  0  0  0  0  0  1  0  0  0 -a;
0  0  0  0  0  0 -1  0  0  a  0  0;
0  0  0  0  0  0  1  0  0  0 -a  0];
c=m*g/2; d=a*1000; b=[c;c+d;c-d;c+d;c-d;c+d;0;d;-d;d;-d;d];
format long g; forces=RR_GaussPP(A,b,12), format short, disp(' ')

% end script RR_Example_2_1.m
