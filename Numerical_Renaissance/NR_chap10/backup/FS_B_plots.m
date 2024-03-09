function FS_B_plots                                  % Numerical Renaissance Codebase 1.0
figure(1); clf; axis([-0 1.1 0 6]); hold on; format compact;
m=-0.08, f3l=0; f3u=1; yl=FS_March(f3l,1,'r--',m); yu=FS_March(f3u,1,'r--',m);
while abs(f3u-f3l)>6e-10   % Refine guess for f'''(0) using bisection algorithm
  f3=(f3u+f3l)/2, y=FS_March(f3,1,'b-.',m);  if yl*y<0; f3u=f3; yu=y; else; f3l=f3; yl=y; end
end
f3=(f3u+f3l)/2, disp(sprintf('Error in terminal condition = %0.5g',FS_March(f3,1,'k-',m)))
print -depsc FSshoot.eps
end % function FS_B_plots.m

function y=FS_March(x,v,s,m)
h=0.01; etamax=10; eta=0; f=[0; 0; x];  if v; f2save=real(f(2));  etasave=eta;  end;
for n=1:etamax/h                % March Falkner-Skan equation over [0,etamax] with RK4
  k1=ComputeRHS(f,m);
  k2=ComputeRHS(f+(h/2)*k1,m);
  k3=ComputeRHS(f+(h/2)*k2,m);
  k4=ComputeRHS(f+h*k3,m);
  f=f+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;  eta=eta+h;
  if v; f2save=[f2save; real(f(2))];  etasave=[etasave; eta]; end
end
plot(f2save,etasave,s); y=f(2)-1;
end % function FS_March.m

function [fp] = ComputeRHS(f,m)
beta=2*m/(m+1);  fp=[f(2); f(3); -f(1)*f(3) - beta*(1-f(2)^2)];
end % function ComputeRHS.m
