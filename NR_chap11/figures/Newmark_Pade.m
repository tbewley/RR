figure(2); clf; axis([-2 2 -.2 1.2]); xlabel('x'); ylabel('u'); hold on;
[q,x]=RC_Wave1D_Newmark_Pade(4,4,1.0,128,.01);
figure(2); plot(x,q,'b-');
[q,x]=RC_Wave1D_Newmark_Pade(4,4,1.0,128,.02);
figure(2); plot(x,q,'r--');
[q,x]=RC_Wave1D_Newmark_Pade(4,4,1.0,128,.04);
figure(2); plot(x,q,'k-.');
set(gca,'box','on')
% print -depsc RC_Wave1D_Newmark_Pade1.eps
