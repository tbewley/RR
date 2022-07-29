function SampledSine                                 % Numerical Renaissance Codebase 1.0
c=50; x=[0:.01:15]; y=sin(x); figure(1); clf; plot(x,y,'k--'); hold on;
xs=x(1:c:end); ys=y(1:c:end); plot(xs,ys,'kx');
for i=1:size(x,2); yzoh(i)=y(c*floor((i-1)/c)+1); end; plot(x,yzoh,'r-');
ydelay=imag(exp(j*(x-x(2)*c/2))); plot(x,ydelay,'r-.');
hold off; print -depsc SampledSine.eps
end % function SampledSine.m