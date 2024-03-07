function RC_AMtest
% Test <a href="matlab:help RC_CNiter">RC_CNiter</a>, <a href="matlab:help RC_AM3iter">RC_AM3iter</a>, <a href="matlab:help RC_AM4iter">RC_AM4iter</a>, <a href="matlab:help RC_AM5iter">RC_AM5iter</a>, and <a href="matlab:help RC_AM6iter">RC_AM6iter</a>
% by simulating the Lorenz or Rossler equation.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

format long; while 1                           
  S=input('Which system (Lorenz, Rossler, or 0 to exit)? ','s');   % PROMPT FOR USER INPUT
  switch S
    case 'Lorenz',  p.sigma=4; p.b=1; p.r=48; x=[1;1;.01];         % SET UP LORENZ SYSTEM
    case 'Rossler', p.a=.2; p.b=.2; p.c=5.7;  x=[3;3;.1];          % SET UP ROSSLER SYSTEM
    otherwise, break
  end
  s.MaxTime=input('  Over what time interval T (try, e.g., 10)? ');
  disp('  Available methods: RC_CNiter, RC_AM3iter, RC_AM4iter, RC_AM5iter, RC_AM6iter')
  m  =input('  Which method? ','s'); order=2; if length(m)==7, order=str2num(m(3)); end
  s.h=input('  What is the timestep h (try, e.g., .01)? ');
  s.MaxIters=input('  How many iterations per timestep (try, e.g., 2)? ');
  v  =input('  How verbose (0=fast, 1=plot attactor, 2=also plot h_n)? ');  % SET UP PLOTS
  if v>0, c=input('    Clear the plots first (y or n)? ','s'); if c=='y', close all, end
          figure(1), plot3(x(1),x(2),x(3)), hold on, axis equal, view(-45,30), end
  if v>1, figure(2), plot(0,s.h), hold on, title('h_n versus t_n'), end  

  t=0; s.MaxSteps=1;  % PERFORM (order-1) STEPS USING LOWER-ORC_RDER AM SCHEMES TO SET UP s.f
  s.f(:,1)=feval(strcat('RHS_',S),x,p);
  if order>2, [x,t,s]=RC_CNiter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>3, [x,t,s]=RC_AM3iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>4, [x,t,s]=RC_AM4iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  if order>5, [x,t,s]=RC_AM5iter(strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler'); end
  s.MaxSteps=1e6;
  [x,t]=feval(m,strcat('RHS_',S),x,t,s,p,v,'PlotLorenzRossler')                % SIMULATE!
end, disp(' '), format short
end % function RC_AMtest
