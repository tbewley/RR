function RK45Test


end % function RK45Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,T,y,p]=SimInit_Lorenz(v)      % Set up simulation and Lorenz paramters             
h=0.01; T=500; y=[1;1;0.01]; p.sigma=4; p.b=1; p.r=48; 
if v>=1, figure(1); clf; plot3([y(1)],[y(2)],[y(3)]); hold on  % Initialize plots
axis([-23 23 -23 23 -23 23]); view(-45,30); title('The Lorenz Attractor'); end
if v==2; figure(2); clf; plot(0,h); hold on; title('Evolution of h'); end
end % function SimInit_Lorenz.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [h,T,y,p]=SimInit_Rossler(v)     % Set up simulation and Rossler paramters  
h=0.05; T=500; y=[3;3;0.1]; p.a=0.2; p.b=0.2; p.c=5.7; 
if v>=1, figure(1); plot3([y(1)],[y(2)],[y(3)]); title('The Rossler Attractor');
axis([-11 13 -12 9 0 25]); view(-45,30); hold on; end
if v==2; figure(2); plot(0,h); hold on; title('Evolution of h'); end, pause(0.01);
end % function SimInit_Rossler.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function SimPlot_Lorenz_Rossler(y,yn,t,tn,h,hn,v)    
figure(1), plot3([y(1) yn(1)],[y(2) yn(2)],[y(3) yn(3)]), hold on
if v==2, figure(2), plot([t, tn],[h hn]), hold on, end, pause(0.01),
end % function SimPlot_Lorenz_Rossler.m
