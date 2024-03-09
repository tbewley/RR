function [out]=RR_tan_82(x)
% function [out]=RR_tan_82(x)
% INPUT:  any real x [note: tan(x) diverges near x=pi/2+n*pi for integer n]
% OUTPUT: cos(x), with about 8.2 digits of precision
% TEST:   x=randn, a=tan(x), b=RR_tan_82(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

twopi=2*pi;
c=floor(x/(twopi)); if c==0, y=x; else, y=x-twopi*c; end, o=floor(y/(pi/4));
switch o
  case 0, out=   tan_82_eval(y);        % Range reduction
  case 1, out= 1/tan_82_eval(pi/2-y);
  case 2, out=-1/tan_82_eval(y-pi/2);    
  case 3, out=  -tan_82_eval(pi-y);
  case 4, out=   tan_82_eval(y-pi);
  case 5, out= 1/tan_82_eval(3*pi/2-y);    
  case 6, out=-1/tan_82_eval(y-3*pi/2);
  case 7, out=  -tan_82_eval(twopi-y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=tan_82_eval(z)  % Chebyshev series expansion from Hart (1978)
c1=211.849369664121; c2=-12.5288887278448; c3=269.7350131214121;
c4=-71.4145309347748; z0=4*z/pi; z2=z0*z0; out=z0*(c1+c2*z2)/(c3+z2*(c4+z2));
end