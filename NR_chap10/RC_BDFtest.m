function RC_BDFtest
% function <a href="matlab:RC_BDFtest">RC_BDFtest</a>
% Test <a href="matlab:help RC_IEiter">RC_IEiter</a>, <a href="matlab:help RC_BDF2iter">RC_BDF2iter</a>, <a href="matlab:help RC_BDF3iter">RC_BDF3iter</a>, <a href="matlab:help RC_BDF4iter">RC_BDF4iter</a>, <a href="matlab:help RC_BDF5iter">RC_BDF5iter</a>, and <a href="matlab:help RC_BDF6iter">RC_BDF6iter</a>
% by simulating the Lorenz or Rossler equation.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

format long; while 1                           
  S=input('Which system (Lorenz, Rossler, or 0 to exit)? ','s');   % PROMPT FOR USER INPUT
  switch S
    case 'Lorenz',  p.sigma=4; p.b=1; p.r=48; x=[1;1;.01];         % SET UP LORENZ SYSTEM
    case 'Rossler', p.a=.2; p.b=.2; p.c=5.7;  x=[3;3;.1];          % SET UP ROSSLER SYSTEM
    otherwise, break
  end
  s.MaxTime=input('  Over what time interval T (try, e.g., 10)? ');
  disp('  Available methods: RC_IEiter, RC_BDF2iter, RC_BDF3iter, RC_BDF4iter, RC_BDF5iter, RC_BDF6iter')
  m  =input('  Which method? ','s'); order=1; if length(m)==8, order=str2num(m(4)); end
  s.h=input('  What is the timestep h (try, e.g., .01)? ');
  s.MaxIters=input('  How many iterations per timestep (try, e.g., 2)? ');
  v  =input('  How verbose (0=fast, 1=plot attactor, 2=also plot h_n)? ');  % SET UP PLOTS
  if v>0, c=input('    Clear the plots first (y or n)? ','s'); if c=='y', close all, end
          figure(1), plot3(x(1),x(2),x(3)), hold on, axis equal, view(-45,30), end
  if v>1, figure(2), plot(0,s.h), hold on, title('h_n versus t_n'), end  

  t=0; s.MaxSteps=1;  % PERFORM (order-1) STEPS USING LOWER-ORC_RDER BDF SCHEMES TO SET UP s.f
  if order>1, [x,t,s]=RC_IEiter  (strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>2, [x,t,s]=RC_BDF2iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>3, [x,t,s]=RC_BDF3iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>4, [x,t,s]=RC_BDF4iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>5, [x,t,s]=RC_BDF5iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  s.MaxSteps=1e6;
  [x,t]=feval(m,strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); x(:,1), t     % SIMULATE!
end, disp(' '), format short
end % function RC_BDFtest
