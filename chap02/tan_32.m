% tan_32.m 
% from the Renaissance Robotics codebase, by Thomas Bewley

function [out]=tan_32(x)
twopi=2*pi;
c=floor(x/(twopi)); if c==0, y=x; else, y=x-twopi*c; end, o=floor(y/(pi/4)),
switch o
  case 1, out= 1/tan_32_eval(pi/2-y);
  case 2, out=-1/tan_32_eval(y-pi/2);    
  case 3, out=  -tan_32_eval(pi-y);
  case 4, out=   tan_32_eval(y-pi);
  case 5, out= 1/tan_32_eval(3*pi/2-y);    
  case 6, out=-1/tan_32_eval(y-3*pi/2);
  case 7, out=  -tan_32_eval(twopi-y);
  otherwise, out=tan_32_eval(y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=tan_32_eval(z)
c1=-3.6112171; c2=-4.6133253; z0=4*z/pi; out=c1*z0/(c2+z0*z0);
end
