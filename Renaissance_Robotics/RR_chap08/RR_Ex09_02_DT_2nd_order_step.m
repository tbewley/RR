% script RR_Ex09_02_DT_2nd_order_step
% This script calculates the {d+,d-,d0}, and {dc,ds}, coefficients in
% the analytical solution to the step response of the DT system
%   G(z)=(1+a1+a0)/(z^2+a1*z+a0).
% It then plugs in values for r=sqrt(a0) and theta=acos(-a1/(2*r)) and plots,
% and compares against the corresponding numerical solutions determined by RR_step.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap08
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear; syms pp pm          % Compute solution analytically
b0=(1-pp)*(1-pm)
Y=RR_tf(RR_poly([b0 0]),RR_poly([pp pm 1],1)); Y.h=1;
[p,d,k,n]=RR_partial_fraction_expansion(Y)
d0=simplify(d(1))          % These should match what you can
dm=simplify(d(2)/pm)       % easily calculate by hand using the
dp=simplify(d(3)/pp)       % Heaviside coverup method
dc=simplify(dp+dm)
ds=simplify(i*(dp-dm));
syms a1 a0
pp=(-a1+sqrt(a1^2-4*a0))/2;
pm=(-a1-sqrt(a1^2-4*a0))/2;
ds1=simplify(i*(subs(dp)-subs(dm)))
close all; kmax=60; k=0:1:kmax;  % Now make some plots
for fig=1:2
  figure(fig), switch fig
     case 1, theta=pi/10; disp('theta=pi/10')
     case 2, theta=pi/5;  disp('theta=pi/5')
  end
  for r=0.7:0.1:1.0, r
    a0=r^2; a1=-2*r*cos(theta);
    dc_n=eval(subs(dc)); ds_n=eval(subs(ds));
    y=r.^k.*(dc_n*cos(theta*k)+ds_n*sin(theta*k))+1;
    plot(k,y,'k-o'); hold on
  end
  axis([0 kmax 0 2])
end

clear; g.N=60; g.ls_y='k-o'  % Now, just do it all with RR_step!
for fig=3:4
  figure(fig), switch fig
     case 3, theta=pi/10; disp('theta=pi/10'), 
     case 4, theta=pi/5;  disp('theta=pi/5')
  end
  for r=0.7:0.1:1.0
    r, a0=r^2; a1=-2*r*cos(theta);
    G=RR_tf(1+a1+a0,[1 a1 a0]); G.h=1; RR_step(G,g); hold on
  end
  axis([0 g.N 0 2])
end
% Note: the approach using RR_step extends quite easily to more complicated G(z).
