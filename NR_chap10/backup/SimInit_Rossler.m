function [h,T,y,p]=SimInit_Rossler(v)                % Numerical Renaissance Codebase 1.0
h=0.05; T=500; y=[3;3;0.1]; p.a=0.2; p.b=0.2; p.c=5.7; % Simulation and Rossler paramters
if v>=1, figure(1); plot3([y(1)],[y(2)],[y(3)]); title('The Rossler Attractor');
         axis([-11 13 -12 9 0 25]); view(-45,30); hold on; end
if v==2; figure(2); plot(0,h); hold on; title('Evolution of h'); end, pause(0.01);
end % function SimInit_Rossler.m
