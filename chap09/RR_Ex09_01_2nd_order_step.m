% script RR_Ex09_01_2nd_order_step
% This script calculates the {d+,d-,d0}, and {dc,dc}, coefficients in
% the step response of the system G(s)=b0/(s^2+a1*s+a0).
% (so much easier to avoid algebra errors this way!)
% Numerical Renaissance codebase, Chapter 9, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; syms zeta om_n b0;
sig=zeta*om_n; om_d=om_n*sqrt(1-zeta^2);
pp=-sig+i*om_d; pm=-sig-i*om_d; Y=RR_tf(b0,RR_poly([0,pp,pm],1))
[p,d,k,n]=RR_partial_fraction_expansion(Y)
d0=simplify(d(1))
dc=simplify(d(2)+d(3))
ds=simplify(i*(d(2)-d(3)))