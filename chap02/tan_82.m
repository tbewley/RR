function [out]=tan_82(x)
twopi=2*pi;
c=floor(x/(twopi)); if c==0, y=x; else, y=x-twopi*c; end, o=floor(y/(pi/4));
switch o
  case 1, out= 1/tan_82_eval(pi/2-y);
  case 2, out=-1/tan_82_eval(y-pi/2);    
  case 3, out=  -tan_82_eval(pi-y);
  case 4, out=   tan_82_eval(y-pi);
  case 5, out= 1/tan_82_eval(3*pi/2-y);    
  case 6, out=-1/tan_82_eval(y-3*pi/2);
  case 7, out=  -tan_82_eval(twopi-y);
  otherwise, out=tan_82_eval(y);
end
end
%%%%%%%%%%%%%%%%%
function [out]=tan_82_eval(z)
c1=211.849369664121; c2=-12.5288887278448; c3=269.7350131214121;
c4=-71.4145309347748; z0=4*z/pi; z2=z0*z0; out=z0*(c1+c2*z2)/(c3+z2*(c4+z2));
end