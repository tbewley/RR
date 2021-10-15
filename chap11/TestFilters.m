clear; w=linspace(.01,2.5,1000)';

[num,den]=ButterworthFilter(4)
figure(1); clf; patch([0 0.669 0.669 0],[-0.1 -0.1 .9615 .9615],[.85 .85 .85]); hold on; patch([1.488 2.5 2.5 1.488],[0.04 0.04 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[0.669 1.488]); set(gca,'XTickLabel',{'p','s'}); % print -depsc butt4.eps

[num,den]=ChebyshevFilter(4,.2)
figure(2); clf; patch([0 0.9996 0.9996 0],[-0.1 -0.1 .9615 .9615],[.85 .85 .85]); hold on; patch([1.5115 2.5 2.5 1.5115],[0.04 0.04 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[.9995 1.5115]); set(gca,'XTickLabel',{'p','s'}); % print -depsc cheb14.eps

[num,den]=InverseChebyshevFilter(4,.2)
figure(3); clf; patch([0 0.661 0.661 0],[-0.1 -0.1 .9615 .9615],[.85 .85 .85]); hold on; patch([1.0 2.5 2.5 1.0],[0.04 0.04 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[0.661 1.0]); set(gca,'XTickLabel',{'p','s'}); % print -depsc cheb24.eps

[num,den]=EllipticFilter(4,.2,1.114);
figure(4); clf; patch([0 0.9996 0.9996 0],[-0.1 -0.1 .9615 .9615],[.85 .85 .85]); hold on; patch([1.114 2.5 2.5 1.114],[0.04 0.04 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]);  set(gca,'XTick',[0.9996 1.114]); set(gca,'XTickLabel',{'p','s'}); % print -depsc elliptic4.eps

[num,den]=ButterworthFilter(8)
figure(5); clf; patch([0 .7503 .7503 0],[-0.1 -0.1 .99 .99],[.85 .85 .85]); hold on; patch([1.331 2.5 2.5 1.331],[0.01 0.01 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[.7503 1.331]); set(gca,'XTickLabel',{'p','s'}); % print -depsc butt.eps

[num,den]=ChebyshevFilter(8,.1)
figure(6); clf; patch([0 .9995 .9995 0],[-0.1 -0.1 .99 .99],[.85 .85 .85]); hold on; patch([1.227 2.5 2.5 1.227],[0.01 0.01 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[.9995 1.227]); set(gca,'XTickLabel',{'p','s'}); % print -depsc cheb1.eps

[num,den]=InverseChebyshevFilter(8,.1)
figure(7); clf; patch([0 .8151 .8151 0],[-0.1 -0.1 .99 .99],[.85 .85 .85]); hold on; patch([0.9997 2.5 2.5 0.9997],[0.01 0.01 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]); set(gca,'XTick',[.8151 0.9997]); set(gca,'XTickLabel',{'p','s'}); % print -depsc cheb2.eps

[num,den]=EllipticFilter(8,.1,1.011);
figure(8); clf; patch([0 0.9996 0.9996 0],[-0.1 -0.1 .99 .99],[.85 .85 .85]); hold on; patch([1.0115 2.5 2.5 1.0115],[0.01 0.01 1.1 1.1],[.85 .85 .85]); plot([0 2.5],[1 1],'k-');
MagBodeLinear1(num,den,w); axis([0 2.5 0 1.004]);  set(gca,'XTick',[0.9996 1.0115]); set(gca,'XTickLabel',{'p','s'}); % print -depsc elliptic.eps

figure(9); clf; plot(w,angle(polyval(num,i*w)./polyval(den,i*w))*180/pi,'c-','LineWidth',2); axis([0 1.01 -360 0]); grid; % print -depsc ellipticphase.eps
