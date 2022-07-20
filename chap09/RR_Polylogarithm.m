function [Li_num,Li_den]=RR_Polylogarithm(p,r)
% function [Li_num,Li_den]=RR_Polylogarithm(p,r)
% Compute Li_{-p}(x)=(x d/dx)^p [x/(1-x)] for x=r/z for integer p>0, as a rational function of z.
% By Table 9.1 of RR, Li_{-p}(r/z) is the Z transform of k^p r^k for integer p>0.
% INPUT:  p=order of power in above formula
%         r=constant in above formula
% OUTPUT: Li_num,Li_den= numerator and denominator of Li_{-p}(r/z)
% TEST1:  clear;  [Li_num,Li_den]=RR_Polylogarithm(1,.1), roots(Li_den)
% TEST2:  syms r; [Li_num,Li_den]=RR_Polylogarithm(2,r ), roots(Li_den)
% TEST3:  syms r; [Li_num,Li_den]=RR_Polylogarithm(3,r ), roots(Li_den)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Note: uses various subroutines from the companion NR codebase.

Li_num=[]; Li_den=NR_PolyPower([1/r -1],p+1);
for k=p:-1:0, Li_num=[0 Li_num]+NR_Factorial(k)*StirlingNumber(p+1,k+1)*NR_PolyPower([1/r -1],p-k); end
Li_num=Li_num/Li_den(1); Li_den=Li_den/Li_den(1);
end % function RR_Polylogarithm
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function s=StirlingNumber(n,k)
s=0; for j=0:k, s=s+(-1)^(k-j)*NR_Choose(k,j)*j^n; end, s=s/NR_Factorial(k);
end % function StirlingNumber