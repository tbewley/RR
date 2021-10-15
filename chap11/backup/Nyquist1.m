% script Nyquist1.m
clear; num=21.5239*[1 0.3]; den=[1 12 20 0 0]; w=720; R=9; eps=1/3;

% num=1; den=[1 2 1 0];  w=720; R=9; eps=1/3;
% num=20; den=[1 9 -10]; w=720; R=50; eps=1/500;

figure(1); clf; theta=[0:pi/100:pi]; s=complex(sin(theta),cos(theta)); s1=[R*s]; s2=sqrt(-1)*[-R:0.02:-eps]; s3=eps*conj(s); s4=sqrt(-1)*[eps:0.02:R]; s=[s1 s2 s3 s4];
plot(real(s1),imag(s1),'b--'); hold on; plot(real(s2),imag(s2),'b-.');  plot(real(s3),imag(s3),'b:');  plot(real(s4),imag(s4),'b-'); 
plot(complex(roots(den)),'kx'); plot(complex(roots(num)),0,'ko');
axis equal;
b=axis*1.05; plot(b(1:2),[0 0],'k--'); % plot([0 0],b(3:4),'k--');
plot(s(w),'r+');
print -depsc cauchyc.eps

figure(2); clf;
f1=polyval(num,s1)./polyval(den,s1); f2=polyval(num,s2)./polyval(den,s2); f3=polyval(num,s3)./polyval(den,s3); f4=polyval(num,s4)./polyval(den,s4); f=polyval(num,s)./polyval(den,s);
plot(real(f1),imag(f1),'b--'); hold on; plot(real(f2),imag(f2),'b-.');  plot(real(f3),imag(f3),'b:');  plot(real(f4),imag(f4),'b-');
b=axis; plot([0 0],b(3:4),'k--'); plot(b(1:2),[0 0],'k--');
plot(f(w),'r+');  plot(-1,0,'k+')
print -depsc cauchyd.eps

% end script Nyquist1.m