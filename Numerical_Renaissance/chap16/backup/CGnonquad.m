function x=CGnonquad(x,N,v)                          % Numerical Renaissance Codebase 1.0
% Minimize the function in ComputeJ.m using the nonquadratic conjugate gradient method
alpha=1e-10; meth=0; resetmeth=10; maxiter=20; maxiteralpha=50; minres=1e-6; tolalpha=0.01;
eps=1e-15;   flag=0; currentmeth=0; J(1)=ComputeJ(x); if v==1; Draw(x); end;
for iter=2:maxiter;
  g=ComputeGradCSD(x,N,eps); res=g'*g;
  switch currentmeth
    case 0; p=-g;                       % Steepest descent
    case 1; p=-g+(res/reso)*p;          % Conjugate gradient (Fletcher-Reeves)
    case 2; p=-g+((res-g'*go)/reso)*p;  % Conjugate gradient (Polak-Ribiere)
  end
% Now compute best alpha via line minimization.
  [ax,bx,cx,fa,fb,fc]=Bracket(0.,alpha,J(iter-1),x,p);
  [J(iter),alpha]    =Brent(ax,bx,cx,fa,fb,fc,tolalpha,maxiteralpha,x,p);
% Finally, update the optimization variable.
  x=x+alpha*p; Draw(x);
% Set gradient method for next step, check for convergence, and exit loop if done.
  currentmeth=meth;
  % Reset to steepest descent from time to time, or if problems with CG search. 
  if (rem(iter,resetmeth)==1); currentmeth=0; end
  if (res < minres | alpha <= 0)
    if flag==1; disp('optimization complete'); J, return; end; % or finish iterating.
    currentmeth=0; flag=1;
  else flag=0;
  end  
  go=g;  reso=res;  
end;
disp('maxiter reached'); J
end % function CGnonquad