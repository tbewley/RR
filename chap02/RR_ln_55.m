function [out]=RR_ln_55(x)
% function [out]=RR_ln_55(x)
% INPUT:  any x>0
% OUTPUT: ln(x), with about 5.5 digits of precision (or better)
% TEST:   x=(randn)^2, a=log(x), b=RR_ln_55(x), residual=norm(a-b)/norm(a)
% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

ln2=0.693147180559945; 
k=floor(0.5+x/ln2); r=x-k*ln2;

xb=dec2bin(typecast(x,'uint32'),32)

out=2^k*exp_55(r);
end
%%%%%%%%%%%%%%%%%
function [out]=exp_55(r) 
a=12+r^2; b=6*r; out=(a+b)/(a-b);
end