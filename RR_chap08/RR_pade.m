function F=RR_pade(d,n,m,color)
% function F=RR_pade(d,n,m,color)
% Computes an (m,n)'th order Pade approximation of a delay of duration d.
% Notes: RR_pade is well behaved only up to about n=16.
%        Step responses look best for m slightly smaller than n.
% As opposed to Matlab's version, RR_pade can handle d being a symbolic.
% INPUTS: d=duration of the delay (OPTIONAL, taken as symbolic if omitted)
%         n=order of denominator  (OPTIONAL, default=2)
%         m=order of numerator    (OPTIONAL, default=n)
%         color=color of lines/symbols plots (OPTIONAL, plots suppressed if omitted)
% OUTPUT: F=transfer function, of type RR_tf, approximating a delay
% TESTS:  syms d; n=4; F=RR_pade(d,n)
%         d=5; close all; F_4=RR_pade(d,4,4,'k'); F_3_4=RR_pade(d,4,3,'r'); pause
%              close all; F_8=RR_pade(d,8,8,'k'); F_7_8=RR_pade(d,8,7,'r'); pause
%              close all; F_15_16=RR_pade(d,16,15,'r');
%                         F_14_16=RR_pade(d,16,14,'b');
%                         F_13_16=RR_pade(d,16,13,'k');
%% Renaissance Robotics codebase, Chapter 8, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<1, syms d; end
if nargin<2, n=2;    else, if n<1, error('need n>=1'), end, end
if nargin<3, m=n;    else, if n<m, error('need n>=m'), end, end
num=[]; den=[];
for k=n:-1:0
  b(k+1)=factorial(m+n-k)*factorial(n)/(factorial(m+n)*factorial(k)*factorial(n-k));
  den=[den double(b(k+1)/b(n+1))*d^k];
  if k<=m
    a(k+1)=factorial(m+n-k)*factorial(m)/(factorial(m+n)*factorial(k)*factorial(m-k));
  	num=[num (-1)^k*double(a(k+1)/b(n+1))*d^k]; end
end
F=RR_tf(num,den); 
if nargin==4 & ~F.den.s
  figure(1), plot(roots(F.num.poly),strcat(color,'o')), hold on
             plot(roots(F.den.poly),strcat(color,'x')), axis equal, grid on
  g.ls_y=strcat(color,'-'); 
  figure(2), RR_step(F,g); hold on; figure(3), RR_ramp(F,g); hold on;
end
