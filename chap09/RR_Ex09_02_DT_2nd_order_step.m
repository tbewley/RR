% script RR_Ex09_02_DT_2nd_order_step
% This script calculates the {d+,d-,d0}, and {dc,ds}, coefficients in
% the step response of the system G(z)=(1+a1+a0)/(z^2+a1*z+a0).
% It then plugs in values for r=sqrt(a0) and theta=acos(-a1/(2*r)) and plots.
% Numerical Renaissance codebase, Chapter 9, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; syms zeta om_n b0;
sig=zeta*om_n; om_d=om_n*sqrt(1-zeta^2);
pp=-sig+i*om_d; pm=-sig-i*om_d; Y=RR_tf(b0,RR_poly([0,pp,pm],1))
[p,d,k,n]=RR_partial_fraction_expansion(Y)
d0=simplify(d(1))
dc=simplify(d(2)+d(3))
ds=simplify(i*(d(2)-d(3)))

close all; om_n=1; b0=1; t=0:.01:10; eps=1e-7; min=eps; max=1-eps; N=10
for zeta=min:(max-min)/N:max, zeta
  d0_n=eval(subs(d0)); dc_n=eval(subs(dc)); ds_n=eval(subs(ds));
  sig_n=eval(subs(sig)); om_d_n=eval(subs(om_d));
  y=exp(-sig_n*t).*(dc_n*cos(om_d_n*t)+ds_n*sin(om_d_n*t))+d0_n; plot(t,y); hold on
end