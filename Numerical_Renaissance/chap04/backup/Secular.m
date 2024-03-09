function Secular                                     % Numerical Renaissance Codebase 1.0
% Initialize parameters 
rho=-1;  d=[-1 0 1 2 4 5 6 7]';  w=[-.1 -2 1 2 .3 1 1 .1]';  n=size(d,1);
% (for test purposes only) plot the function to see what's going on.
x=[-11:.001:8]';  for i=1:size(x,1), f(i)=ComputeF(x(i),rho,d,w); end
figure(1);  clf;  plot(x,f,'b-');  axis([-11 8 -30 30]);  grid;  hold on;
% Now look over each interval to find the new roots
if rho>1
  for i=1:n-1
    L=d(i);   R=d(i+1); x=(R+L)/2;      [lambda(i) flambda(i) iter(i)]=FindRoot(x,L,R,rho,d,w);
  end
  L=d(n);     R=1/eps;  x=2*d(n)-d(1);  [lambda(n) flambda(n) iter(n)]=FindRoot(x,L,R,rho,d,w);
else
  L=-1/eps;   R=d(1);   x=2*d(1)-d(n);  [lambda(1) flambda(1) iter(1)]=FindRoot(x,L,R,rho,d,w);
  for i=2:n
    L=d(i-1); R=d(i);   x=(R+L)/2;      [lambda(i) flambda(i) iter(i)]=FindRoot(x,L,R,rho,d,w);
  end
end
iter, lambda, flambda, plot(lambda,flambda,'k*');  
return
% end function Secular

function [x f i]=FindRoot(x,L,R,rho,d,w)
for i=1:200
  f=ComputeF(x,rho,d,w);
  if abs(f)<=1e-6, break, end
  fprime=ComputeFPrime(x,rho,d,w);
  xnew=x-f/fprime;
  if f*rho>0,  R=x; if xnew<=L, xnew=(R+L)/2; end
  else,        L=x; if xnew>=R, xnew=(R+L)/2; end,  end
  x=xnew;
end
return

function [f]=ComputeF(x,rho,d,w);
f=1+rho*(w.^2)'*(1./(d-x));
return

function [fprime]=ComputeFPrime(x,rho,d,w);
fprime=rho*(w.^2)'*(1./(d-x).^2);
return
