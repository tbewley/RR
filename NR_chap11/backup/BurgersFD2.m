% RC_BurgersFD2.m
% ... (preliminary code identical to that in RC_BurgersFD1) ...
for k=1:TimeSteps
   %%%%%%%%%%%%%%%%%%%%%%%% FIRST RK SUBSTEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute nonlinear term r(y)                                       Approximate
   % (defer scaling by coefficient, result stored in z)                   Cost
   z(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                  % (2N)
   % Compute entire rhs (result stored in y)
   y(2:N)=y(2:N) + d(1)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) + e(1)*z(2:N);      % (7N)
   % Solve for y at end of first RK step (result stored in y)
   y(2:N)=RC_ThomasTT(a(1),b(1),c(1),y(2:N)',N-1);                           % (8N)
   %%%%%%%%%%%%%%%%%%%%%%%% SECOND RK SUBSTEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute entire rhs, including the computation of r(y)
   % (result stored in z)
   z(2:N)=y(2:N) + d(2)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) - ...               % (11N)
          e(2)*y(2:N).*(y(3:N+1)-y(1:N-1)) + f(2)*z(2:N);
   % TRICK: now RECOMPUTE nonlinear term r(y)
   % (defer scaling, result stored in y)
   y(2:N)=-y(2:N).*(y(3:N+1)-y(1:N-1));                                  % (2N)
   % Solve for y at end of second RK step (result stored in z)
   z(2:N)=RC_ThomasTT(a(2),b(2),c(2),z(2:N)',N-1);  z(N+1)=0;                % (8N)
   %%%%%%%%%%%%%%%%%%%%%%%% THIRD RK SUBSTEP %%%%%%%%%%%%%%%%%%%%%%%%
   % Compute entire rhs, including the computation of r(y)
   % (result stored in y)
   y(2:N)=z(2:N) + d(3)*(z(3:N+1)-2*z(2:N)+z(1:N-1)) - ...               % (11N)
          e(3)*z(2:N).*(z(3:N+1)-z(1:N-1)) + f(3)*y(2:N); 
   % Solve for y at new timestep (result stored in y)
   y(2:N)=RC_ThomasTT(a(3),b(3),c(3),y(2:N)',N-1);                           % (8N)
   if (mod(TimeStep,PlotInterval)==0) ploty(y,TimeStep*dt,N,dx); end
   %%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%
if (mod(k,PlotInterval)==0) PlotXY(x,y,k*dt,0,L,-3,3); end  % (see Alg 12.1)
end 
% end script RC_BurgersFD2.m
