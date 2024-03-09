function y=FS_March(x,verbose,m)
h=0.01; etamax=10; eta=0; f=[0; 0; x];  if verbose; f2save=real(f(2));  etasave=eta;  end;
for n=1:etamax/h                % March Falkner-Skan equation over [0,etamax] with RK4
  k1=ComputeRHS(f,m);
  k2=ComputeRHS(f+(h/2)*k1,m);
  k3=ComputeRHS(f+(h/2)*k2,m);
  k4=ComputeRHS(f+h*k3,m);
  f=f+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;  eta=eta+h;
  if verbose; f2save=[f2save; real(f(2))];  etasave=[etasave; eta]; end;
end
if verbose; 
  if m<0; s='b-.'; elseif m>0; s='r--'; else; s='k-'; end;  plot(f2save,etasave,s);
end;
y=f(2)-1;
% end function FS_March.m

function [fp] = ComputeRHS(f,m)
beta=2*m/(m+1);  fp=[f(2); f(3); -f(1)*f(3) - beta*(1-f(2)^2)];
% end function ComputeRHS.m
