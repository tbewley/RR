c=1.75; hashwidth=0.1;
x=[-1:.05:1]; N=length(x); f=tanh(c*x)/tanh(c);

figure(1), clf, plot(x,f,'k-'), hold on;
plot([-1 1],[0 0],'k-'), plot([0 0],[-1.1 1.1],'k-')
for i=1:N
plot([x(i) x(i)],[0 f(i)],'b-',[x(i) 0],[f(i) f(i)],'r-')
end
hold off; axis equal; axis tight;
print -depsc stretch_tanh.eps

figure(2), clf, plot([0 0],[-1.05 1.05],'k-'), hold on
for i=1:N, plot([-hashwidth hashwidth],[f(i) f(i)],'r-');end
axis([-0.1 0.1 -1.05 1.05]); axis equal; axis tight; axis off; hold off;
print -depsc stretch_tanh_hash.eps
