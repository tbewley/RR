%% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clf; figure(1)
global g

F1=RR_tf([1],[1 1]); g.linestyle='k-'; RR_bode(F1,g)

logspace(-1.5,1.5,500)); hold on
subplot(2,1,1); axis([.05 20 .05 1.2])
plot([1 100],[1 0.01],'k--');
subplot(2,1,2); axis([.05 20 -100 10])
plot([.01 100],[0 0],'k--');
plot([.01 100],[-90 -90],'k--');
plot([.2 5],[0 -90],'k--');
pause;

clf; figure(2)
F2=RR_tf([1],[1 2*0.01  1]); g.linestyle='k-' ; g.omega=logspace(-1,1,500); bode(F2); hold on
F2=RR_tf([1],[1 2*0.1   1]); g.linestyle='k-.'; g.omega=logspace(-1,1,500); bode(F2); 
F2=RR_tf([1],[1 2*0.2   1]); g.linestyle='k-.'; g.omega=logspace(-1,1,500); bode(F2); 
F2=RR_tf([1],[1 2*0.3   1]); g.linestyle='k-.'; g.omega=logspace(-1,1,500); bode(F2); 
F2=RR_tf([1],[1 2*0.5   1]); g.linestyle='k-.'; g.omega=logspace(-1,1,500); bode(F2); 
F2=RR_tf([1],[1 2*0.707 1]); g.linestyle='r-' ; g.omega=logspace(-1,1,500); bode(F2); 
F2=RR_tf([1],[1 2*1     1]); g.linestyle='b--'; g.omega=logspace(-1,1,500); bode(F2); 
subplot(2,1,1); axis([.1 10 .01 30])
subplot(2,1,2); axis([.1 10 -180 0])
% print -depsc Bode2nd.eps