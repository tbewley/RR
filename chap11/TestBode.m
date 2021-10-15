clf                                                  % Numerical Renaissance Codebase 1.0
Bode([1],[1 2*0.01 1],logspace(-1,1,500),'k-'); hold on
Bode([1],[1 2*0.1 1],logspace(-1,1,500),'k-.')
Bode([1],[1 2*0.2 1],logspace(-1,1,500),'k-.')
Bode([1],[1 2*0.3 1],logspace(-1,1,500),'k-.')
Bode([1],[1 2*0.5 1],logspace(-1,1,500),'k-.')
Bode([1],[1 2*0.707 1],logspace(-1,1,500),'r-')
Bode([1],[1 2*1 1],logspace(-1,1,500),'b--')
subplot(2,1,1); axis([.1 10 .01 30])
subplot(2,1,2); axis([.1 10 -180 0])
print -depsc Bode2nd.eps

clf
Bode([1],[1 1],logspace(-1.5,1.5,500),'k-'); hold on
subplot(2,1,1); axis([.05 20 .05 1.2])
plot([1 100],[1 0.01],'k--');
subplot(2,1,2); axis([.05 20 -100 10])
plot([.01 100],[0 0],'k--');
plot([.01 100],[-90 -90],'k--');
plot([.2 5],[0 -90],'k--');
print -deps Bode1st.eps
