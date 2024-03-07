gradient_method = 1;  momentum_reset = 10;  x=x_init;

alpha=0.01;  g=zeros(size(x));  J(iter)=Compute_J(x);  gradient_method_this_step = 0;

for iter = 2:max_iter;
  g = Compute_g(x);  res=g'*g;
  switch gradient_method_this_step
    case 0; beta = 0;                     % Steepest descent
    case 1; beta = res / reso;            % CG (Fletcher-Reeves)
    case 2; beta = (res - g'*go) / reso;  % CG (Polak-Ribiere)
  end
  p = - g + beta * p;

% Now compute best alpha via line minimization.
   ax=0.;                  fa=J(iter-1);
   bx=max(0.001,alpha);    fb=Compute_J(x+bx*p);
   [ax,bx,cx,fa,fb,fc]=mnbrak(ax,bx,fa,fb,x,p);
   [J(iter),alpha]    =brent (ax,bx,cx,fa,fb,fc,tol_alpha,max_iter_alpha,x,p);

% Finally, update the optimization variable.
   x = x + alpha * p;

% Set gradient method for next step, check for convergence, and exit loop if done.
  gradient_method_this_step = gradient_method;
  residual = J(iter-1) - J(iter);
  % Reset to steepest descent from time to time, or if problems with CG search. 
  if rem(iter,momentum_reset)==1 | residual < min_residual | alpha < 0              
    if gradient_method_this_step>0, gradient_method_this_step=0;    
    else disp('I should be breaking out now...'),  break;  % or finish iterating.
    end
  end
  go=g;  reso=res;  
end;

Compute