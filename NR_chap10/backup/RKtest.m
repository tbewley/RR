% script <a href="matlab:RKtest">RKtest</a>
% Test <a href="matlab:help RK2">RK2</a>, <a href="matlab:help RK4">RK4</a>, <a href="matlab:help RK45">RK45</a>, <a href="matlab:help RKW3_2R">RKW3_2R</a>, <a href="matlab:help RK435_2R">RK435_2R</a>, <a href="matlab:help RK435_3R">RK435_3R</a>, and <a href="matlab:help RK548_3R">RK548_3R</a>
% by simulating the Lorenz or Rossler equation.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

format long; while 1                           
  S=input('Which system (Lorenz, Rossler, or 0 to exit)? ','s');   % PROMPT FOR USER INPUT
  switch S
    case 'Lorenz',  p.sigma=4; p.b=1; p.r=48; x0=[1;1;.01];        % SET UP LORENZ SYSTEM
    case 'Rossler', p.a=.2; p.b=.2; p.c=5.7;  x0=[3;3;.1];         % SET UP ROSSLER SYSTEM
    otherwise, break
  end
  s.T=input('  Over what time interval T (try, e.g., 10)? ');
  m=input('  Which method (RK2, RK4, RK45, RKW3_2R, RK435_2R, RK435_3R, RK548_3R)? ','s');
  if m(1:3)=='RK2',s.c=input('    Value of c (1/2=midpoint, 1=predictor/corrector)? ');end
  switch m
    case {'RK45'}
      disp('    This method uses adaptive timestepping.')
      s.h       =input('    What is the initial timestep h0 (try, e.g., .01)? ');
      s.epsoverT=input('    What is the target accuracy, epsilon/T (try, e.g., .0001)? ');
    otherwise, 
      disp('    This method uses uniform timestepping.')
      s.h       =input('    What is the timestep h (try, e.g., .01)? ');
  end
  v=input('  How verbose (0=fast, 1=plot attactor, 2=also plot h_n)? ');    % SET UP PLOTS
  if v>0, c=input('    Clear the plots first (y or n)? ','s'); if c=='y', close all, end
          figure(1), plot3(x0(1),x0(2),x0(3)), hold on, axis equal, view(-45,30), end
  if v>1, figure(2), plot(0,s.h), hold on, title('h_n versus t_n'), end  
  [x,t]=feval(m,strcat('RHS_',S),x0,0,s,p,v,'PlotLorenzRossler')      % RUN THE SIMULATION
end, disp(' '), format short  % remember: exportfig(gcf,'Lorenzh.eps','bounds','tight');
% end script RKtest
