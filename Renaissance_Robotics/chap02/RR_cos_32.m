function [out]=RR_cos_32(x)
% function [out]=RR_cos_32(x)
% INPUT:  any real x
% OUTPUT: cos(x), with about 3.2 digits of precision
% TEST:   x=randn, a=cos(x), b=RR_cos_32(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap02
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

c=floor(x/(2*pi)); if c==0, y=x; else, y=x-2*pi*c; end, q=1+floor(y/(pi/2));
switch q
  case 1, out= cos_32_eval(y);          % Range reduction to 0<=z<pi/2
  case 2, out=-cos_32_eval(pi-y);
  case 3, out=-cos_32_eval(y-pi);    
  case 4, out= cos_32_eval(2*pi-y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=cos_32_eval(z)  % Chebyshev series expansion from Hart (1978)
c1=0.99940307; c2=-0.49558072; c3=0.03679168;
z2=z*z; out=c1+z2*(c2+c3*z2);
end
    