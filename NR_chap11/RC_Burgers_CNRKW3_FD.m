function RC_Burgers_CRCKW3_FD
% function <a href="matlab:RC_Burgers_CRCKW3_FD">RC_Burgers_CRCKW3_FD</a>
% Simulate the 1D Burgers on 0<x<L with homogeneous Dirichlet BCs using CN/RKW3 in time
% (explicit on nonlinear terms, implicit on linear terms) & 2nd-order central FD in space.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 11.2.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap11">Chapter 11</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Burgers_CRCKW3_FD_RS, with 2 registers & 57 flops/timestep (instead of 3 & 55),
% and RC_Burgers_KS_CRCKW3_PS with a pseudospectral implementation.

%%%%%%%%%%%%%%%%%%%% Initialize the simulation paramters (user input) %%%%%%%%%%%%%%%%%%%%
L=100; Tmax=50; N=100; dt=0.5; PlotInterval=1;
dx=L/N; x=(0:N)*dx; y=-sin(pi*x/L)-sin(2*pi*x/L)+sin(6*pi*x/L); RC_PlotXY(x,y,0,0,L,-3,3)
%%%%%%%%%%%% Precalculate the time-stepping coefficients used in the simulation %%%%%%%%%%
h_bar = dt*[8/15 2/15  1/3];     d=h_bar/(2*dx^2);          a= -h_bar/(2*dx^2); 
beta_bar = [1    25/8  9/4];     e=beta_bar.*h_bar/(2*dx);  b=1+h_bar/dx^2;
zeta_bar = [0   -17/8 -5/4];     f=zeta_bar.*h_bar/(2*dx);  c= -h_bar/(2*dx^2);
for k=1:Tmax/dt
  for rk=1:3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALL 3 RK SUBSTEPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Compute nonlinear term r(y), & defer scaling until next step %  Leading-order cost:
     r=-y(2:N).*(y(3:N+1)-y(1:N-1));                                           % ~ 2N
     % Compute entire rhs, and apply all the correct scalings
     if (rk==1)
        rhs=y(2:N) +d(rk)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) +e(rk)*r;               % ~ 7N
     else
        rhs=y(2:N) +d(rk)*(y(3:N+1)-2*y(2:N)+y(1:N-1)) +e(rk)*r +f(rk)*rhs;    % ~ 9N
     end       
     % Solve for new y
     y(2:N)=RC_ThomasTT(a(rk),b(rk),c(rk),rhs',N-1);                              % ~ 8N
     % Save r (in rhs) for the next timestep                            --------------
     if (rk<3) rhs=r; end                                               % Total: ~ 55N
  end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (mod(k,PlotInterval)==0) RC_PlotXY(x,y,k*dt,0,L,-3,3); end            
end                                                                     
end % function RC_Burgers_CRCKW3_FD
