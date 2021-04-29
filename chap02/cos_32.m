% cos_32.m 
% from the Renaissance Robotics codebase, by Thomas Bewley

function [out]=cos_32(x)
c=floor(x/(2*pi)); if c==0, y=x; else, y=x-2*pi*c; end, q=floor(y/(pi/2));
switch q
  case 1, out=-cos_32_eval(pi-y);
  case 2, out=-cos_32_eval(y-pi);    
  case 3, out= cos_32_eval(2*pi-y);
  otherwise, out=cos_32_eval(y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=cos_32_eval(z)
c1=0.99940307; c2=-0.49558072; c3=0.03679168;
z2=z*z; out=c1+z2*(c2+c3*z2);
end
    
