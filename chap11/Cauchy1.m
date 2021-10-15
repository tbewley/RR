% Script Cauchy.m
clear;  num=21.5239*[1 0.3]; den=[1 12 20 0 0]; w=720; R=9; eps=1/3;

figure(1); clf; theta=[0:pi/100:pi]; s=complex(sin(theta),cos(theta)); s=[R*s sqrt(-1)*[-R:0.02:-eps] eps*conj(s) sqrt(-1)*[eps:0.02:R]];
plot(real(s),imag(s),'b-'); hold on; plot(complex(roots(den)),'kx'); plot(complex(roots(num)),0,'ko'); axis equal;
b=axis*1.05; plot([0 0],b(3:4),'k--',b(1:2),[0 0],'k--');
plot(s(w),'r+');
print -depsc cauchyc.eps

figure(2); clf; f=polyval(num,s)./polyval(den,s); plot(f,'b-'); hold on;
b=axis; plot([0 0],b(3:4),'k--',b(1:2),[0 0],'k--'); plot(f(w),'r+');  plot(-1,0,'k+')
print -depsc cauchyd.eps

% end Script Cauchy.m