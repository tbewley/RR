function [f] = ATAN2(dy,dx)
if  real(dx)>0, f=atan(dy/dx); else, f=pi-atan(-dy/dx); end;
end % function ATAN2
