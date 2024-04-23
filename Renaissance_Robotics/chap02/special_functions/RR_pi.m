% script RR_pi
% Calculate pi=4*(F(2)+F(3)) with F(x)=1/x-1/(3x^3)+1/(5x^5)-1/(7x^7)+1/(9x^9)-...
% where F(x)=arctan(1/x).  Gets 15 significant figures in (45+1)/2=23 steps
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, N=45, p=0;
for k=1:2:N, k, s=(-1)^((k-1)/2); p=p+s*(4/(k*2^k)+4/(k*3^k)); end, p