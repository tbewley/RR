function [b,a]=RR_RationalSimplify(b,a)
% function [b,a]=RR_RationalSimplify(b,a)
% Simplify a rational function b(s)/a(s) [or b(z)/a(z)] by dividing out common factors,
% strippling leading zeros, then normalizing both by a(1).
% INPUT:  b=vector of polynomial coefficients in numerator
%         a=vector of polynomial coefficients in denominator
% OUTPUT: b=vector of polynomial coefficients in simplified numerator
%         a=vector of polynomial coefficients in simplified denominator
% TEST:   num=RR_PolyConv([1 10],[1 1],[1 10],[1 5]), den=RR_PolyConv([1 5],[1 10],[1 2])
%         roots_num_before=roots(num)', roots_den_before=roots(den)'
%         [num,den]=RR_RationalSimplify(num,den)
%         roots_num_after=roots(num)', roots_den_after=roots(den)', num, den
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

f=1; while f; x=roots(a); y=roots(b); f=0; for i=1:length(x); for j=1:length(y);
  if abs(x(i)-y(j))<1e-6, f=1; a=RR_PolyDiv(a,[1 -x(i)]); b=RR_PolyDiv(b,[1 -x(i)]); break, end
end, if f, break, end, end, end
a=a(find(abs(a)>1e-10,1):end); b=b(find(abs(b)>1e-10,1):end); b=b/a(1); a=a/a(1);
end % function RR_RationalSimplify