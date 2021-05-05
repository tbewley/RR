% script plot_encoder_signals
% Plot the signals from quadrature (AB) and commutation (UVW) encoders
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

figure(1); clf
plot([0 1 1 2 2 3 3 4 4 5 5 6 6 7],[1 1 0 0 1 1 0 0 1 1 0 0 1 1],'b-','LineWidth',2);
hold on, axis([0.25 3.75 -0.5 1.5]), axis equal, axis off, 
plot(-0.5+[0 1 1 2 2 3 3 4 4 5 5 6 6 7],0.09+[0 0 1 1 0 0 1 1 0 0 1 1 0 0],'r--','LineWidth',2)
print -depsc quad_encoder_signals

figure(2); clf
plot(-1+[0 1 1 2 2 3 3 4 4 5 5 6 6 7],[1 1 0 0 1 1 0 0 1 1 0 0 1 1],'b-','LineWidth',2);
hold on, axis([2.5/6 27.5/6 -0.5 1.5]), axis equal, axis off,
plot(-1/3+[0 1 1 2 2 3 3 4 4 5 5 6 6 7],0.09+[0 0 1 1 0 0 1 1 0 0 1 1 0 0],'r--','LineWidth',2)
plot(1/3+[0 1 1 2 2 3 3 4 4 5 5 6 6 7],-0.09+[0 0 1 1 0 0 1 1 0 0 1 1 0 0],'m-.','LineWidth',2)
print -depsc UVW_encoder_signals
