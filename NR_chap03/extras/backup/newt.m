% newt.m
% Given an initial guess for the solution x and the auxiliary functions
% compute_f.m and compute_A.m to compute a function and the corresponding
% Jacobian, solve a nonlinear system using Newton-Raphson.  Note that f may
% be a scalar function or a system of nonlinear functions of any dimension.
res=1;  i=1;                               
while (res>1e-10)
   f=compute_f(x);  A=compute_A(x);        % Compute function and Jacobian
   res=norm(f);                            % Compute residual
   x_save(i,:)=x';                         % Save x, f, and the residual
   f_save(i,:)=f';  res_save(i,1)=res;
   x=x-(A\f);                              % Solve system for next x 
   i=i+1;                                  % Increment index
end
evals=i-1;
% end newt.m
