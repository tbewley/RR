% script RR_Fig_11_17_phase_lead_lag_compensators
% Plot the max phase lead or lag of a lead (p/z>1) or lag (p/z<1) controller,
% plotted versus alpha=p/z, centered at om=sqrt(p*z)
% Renaissance Robotics codebase, Chapter 11, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear, close all, N=400; a=logspace(-3,3,N); om=1
for k=1:N, z=om/sqrt(a(k)); p=om*sqrt(a(k)); ph(k)=rad2deg(phase((i+z)/(i+p))); end
semilogx(a,ph), grid, axis([10^-3 10^3 -90 90])