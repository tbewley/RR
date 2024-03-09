function FS_Direct(x,verbose,m)                      % Numerical Renaissance Codebase 1.0
m=-.09; beta=2*m/(m+1); h=0.01; etamax=10; figure(1); clf; axis([0 1 0 6]); hold on
n=1+etamax/h, a=zeros(n,1); b=a; c=a; d=a; e=a; x=a; for i=1:n, f(i)=etamax*i/n; end
etaplot=[0:h:etamax-h]'; plot((f(2:n)-f(1:n-1))/h,etaplot,'r--');
c(1:2,1)=1;  c(n-1:n,1)=1/h; b(n-1:n,1)=-1/h; x(n-1:n,1)=1; % Enforce boundary conditions.
for k=3:n-2; a(k)=-0.5/h^3; e(k)= 0.5/h^3; x(k)=-beta; end  % Set up pentadiagonal solve.
for i=1:20                                                  % Start the iteration.
  for k=3:n-2;
    b(k)= 1/h^3 + 0.5*f(k)/h^2 + beta * (f(k+1)-f(k-1))/(2*h)^2;    % Finish setting up
    c(k)=       -     f(k)/h^2 +  0.5 * (f(k+1)-2*f(k)+f(k-1))/h^2; % the pentadiagonal
    d(k)=-1/h^3 + 0.5*f(k)/h^2 - beta * (f(k+1)-f(k-1))/(2*h)^2;    % solve.
  end
  f=Penta(a,b,c,d,e,x,n); plot((f(2:n)-f(1:n-1))/h,etaplot,'b-.');  % Do the solve.  Plot.
end
plot((f(2:n)-f(1:n-1))/h,etaplot,'k-'); hold off;
end % function FS_Direct