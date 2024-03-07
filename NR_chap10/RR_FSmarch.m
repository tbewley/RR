function y=FSmarch(x,v,m)
% function y=FSmarch(x,v,m)
% This is an ancillary code to FS_Bisection_Test and FS_RC_CSD_Test.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.7.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

h=0.01; etamax=10; eta=0; f=[0; 0; x];  if v; f2save=real(f(2));  etasave=eta;  end;
for n=1:etamax/h                % March Falkner-Skan equation over [0,etamax] with RK4
  k1=RKrhs(f,m); k2=RKrhs(f+(h/2)*k1,m); k3=RKrhs(f+(h/2)*k2,m); k4=RKrhs(f+h*k3,m);
  f=f+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;  eta=eta+h;
  if v; f2save=[f2save; real(f(2))];  etasave=[etasave; eta]; end
end
if v; if m<0; s='b-.'; elseif m>0; s='r--'; else; s='k-'; end; plot(f2save,etasave,s); end
y=f(2)-1;
end % function FSmarch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [fp] = RKrhs(f,m)
beta=2*m/(m+1);  fp=[f(2); f(3); -f(1)*f(3) - beta*(1-f(2)^2)];
end % function RKrhs
