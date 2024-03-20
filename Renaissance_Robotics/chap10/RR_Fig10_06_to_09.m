% script RR_Fig10_06_to_09
% Illustrate how to use the fundamental tools of classical control design (that is,
% root locus, open-loop Bode, Nyquist, closed-loop Bode, and step response) on a
% representative control design problem, as considered in the text.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 10)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

close all;
G=RR_tf([1 .3],[1 12 20 0 0]);    % Plant      = G(s) = (s+.3)/[s^2(s+2)(s+10)]
D=RR_tf(15);                      % Controller = D(s) = 15
T=G*D/(1+G*D);                    % Closed-loop System

g.K=logspace(-3.5,4,400); g.axes=[-3 1 -2 2];
g.omega=logspace(-2,3,100); g.line=1; g.style='k-';
figure(1), RR_rlocus(G,D,g)                                                                             
figure(2), RR_bode(G*D,g)
figure(3), g.T=15; g.h=.01; RR_step(T,g) 
figure(4), g.line=0; RR_bode(T,g)           
% g.figs=5; g.figL=6; g.eps=.2; g.R=4; Nyquist(numGD,denGD,g) TODO: redo this.

% end script Figures_18_4_through_18_8
