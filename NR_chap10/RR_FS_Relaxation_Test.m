% script <a href="matlab:FS_RC_CSD_Test">FS_Relaxation_Test</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.7.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also FS_Bisection_Test, FS_RC_CSD_Test.  Depends on Penta from Exercise 2.3!

if exist('Penta')~=2, disp('You must do Exercise 2.3 before running this code'), break, end
m=-.08; beta=2*m/(m+1); h=0.01; etamax=10; figure(1); clf; axis([-0 1.1 0 6]); hold on
n=1+etamax/h, a=zeros(n,1); b=a; c=a; d=a; e=a; x=a; for i=1:n, f(i)=etamax*i/n; end
c(1:2,1)=1;  c(n-1:n,1)=1/h; b(n-1:n,1)=-1/h; x(n-1:n,1)=1; % Enforce boundary conditions.
for k=3:n-2; a(k)=-0.5/h^3; e(k)= 0.5/h^3; x(k)=-beta; end  % Set up pentadiagonal solve.
for i=1:20                                                  % Start the iteration.
  for k=3:n-2;
    b(k)= 1/h^3 + 0.5*f(k)/h^2 + beta * (f(k+1)-f(k-1))/(2*h)^2;    % Finish setting up
    c(k)=       -     f(k)/h^2 +  0.5 * (f(k+1)-2*f(k)+f(k-1))/h^2; % the pentadiagonal
    d(k)=-1/h^3 + 0.5*f(k)/h^2 - beta * (f(k+1)-f(k-1))/(2*h)^2;    % solve.
  end
  f=Penta(a,b,c,d,e,x,n);                                           % Do the solve.
end
plot((f(2:n)-f(1:n-1))/h,[0:h:etamax-h],'k-')                       % Plot.
% end script FS_Relaxation_Test
