function [out]=RR_cos_73(x)
% function [out]=RR_cos_73(x)
% INPUT:  any real x
% OUTPUT: cos(x), with about 7.3 digits of precision
% TEST:   x=randn, a=cos(x), b=RR_cos_73(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

c=floor(x/(2*pi)); if c==0, y=x; else, y=x-2*pi*c; end, q=1+floor(y/(pi/2));
switch q
  case 1, out= cos_73_eval(y);          % Range reduction to 0<=z<pi/2
  case 2, out=-cos_73_eval(pi-y);
  case 3, out=-cos_73_eval(y-pi);    
  case 4, out= cos_73_eval(2*pi-y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=cos_73_eval(z)  % Chebyshev series expansion from Hart (1978)
c1= 0.999999953464;  c2=-0.4999999053455; c3=0.0416635846769;
c4=-0.0013853704264; c5=0.00002315393167;
z2=z^2; out=c1+z2*(c2+z2*(c3+z2*(c4+c5*z2)));
end