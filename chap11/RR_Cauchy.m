% Script Cauchy.m
num=[1 1]; den=[1 0 .25 -1.25]; w=330;

figure(1); clf; theta=[0:pi/200:2*pi]; s=complex(sin(theta)+1.2,cos(theta)+0.8); 
plot(real(s),imag(s),'b-'); hold on; plot(roots(den),'kx'); plot(roots(num),0,'ko');
a=[-1.8 2.5 -1.5 2]; axis(a); axis equal;  b=axis; plot([0 0],b(3:4),'k--',b(1:2),[0 0],'k--');
plot(s(w),'r+');
print -depsc cauchya.eps

figure(2); clf; f=polyval(num,s)./polyval(den,s); plot(f,'b-'); hold on;
b=axis; plot([0 0],b(3:4),'k--',b(1:2),[0 0],'k--'); plot(f(w),'r+');
print -depsc cauchyb.eps

% end Script Cauchy.m