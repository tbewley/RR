function RC_Burgers_RKW3CN_FD                           % Numerical Renaissance Codebase 1.0
% This function simulates Burgers equation with homogeneous Dirichlet BCs.
% RKW3/CN timestepping is used (explicit on nonlinear terms, implicit on linear terms)
% with a 2nd-order central FD method in space.
% ---------- Initialize the simulation paramters (user input)  ----------
L=100; Tmax=50; N=100; dt=0.5; PlotInterval=1;
dx=L/N; x=(0:N)*dx; y=-sin(pi*x/L)-sin(2*pi*x/L)+sin(6*pi*x/L); PlotXY(x,y,0,0,L,-3,3)
% --------------------------- end user input ---------------------------- 
% Precalculate the time-stepping coefficients used in the computation. 
h_bar = dt*[8/15 2/15  1/3];     d=h_bar/(2*dx^2);          a= -h_bar/(2*dx^2); 
beta_bar = [1    25/8  9/4];     e=beta_bar.*h_bar/(2*dx);  b=1+h_bar/dx^2;
zeta_bar = [0   -17/8 -5/4];     f=zeta_bar.*h_bar/(2*dx);  c= -h_bar/(2*dx^2);
for k=1:Tmax/dt
  for rk=1:3 %%%%%%%%%%%%%%%%%%%%%%%% ALL 3 RK SUBSTEPS %%%%%%%%%%%%%%%%%%%%%%%%
     % Compute nonlinear term r(y)                                   
     % (defer scaling by coefficient)                                % Leading-order cost:
     r=-y(2:N).*(y(3:N+1)-y(1:N-1));                                        % ~ 2N
     % Compute entire rhs
     if (rk==1)
        rhs=y(2:N) +d(rk)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) +e(rk)*r;            % ~ 7N
     else
        rhs=y(2:N) +d(rk)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) +e(rk)*r +f(rk)*rhs; % ~ 9N
     end       
     % Solve for new y
     y(2:N)=RC_ThomasTT(a(rk),b(rk),c(rk),rhs',N-1);                           % ~ 8N
     % Save r (in rhs) for the next timestep                            --------------
     if (rk<3) rhs=r; end                                               % Total: ~ 55N
  end %%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%
  if (mod(k,PlotInterval)==0) PlotXY(x,y,k*dt,0,L,-3,3); end            
end                                                                     
end % function RC_Burgers_RKW3CN_FD.m