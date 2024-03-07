% script <a href="matlab:StretchedFourierTest">StretchedFourierTest</a>
% Plot the grid used in the stretched Fourier method for given values of L, beta, and N,
% then define a function on the stretched grid and differentiate using (5.50) and (5.51).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.12.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, close all, L=5, beta=.8, N=64  % First, compute a stretched grid (fiddle here!)
s=[0:1/N:1-1/N]; alpha=(-beta+sqrt(beta^2+4/L^2))/2, t=atan(sqrt(1+beta/alpha)*tan(pi*s));
for j=1:N, if t(j)<0, t(j)=t(j)+pi; end, end  % Needed to shift the atan output to [0,pi].
x=t/(pi*sqrt(alpha*(alpha+beta)));
figure(1); plot(s,x,'+',s,x*0,'k+',s*0,x,'r+'), e=.001; axis([0-e 1+e 0-e L+e])

% Now, set up a periodic function on the stretched grid to differentiate. (fiddle here!)
k1=6*pi/L; u=sin(x*k1);
fe=k1*cos(x*k1); ge=-k1^2*sin(x*k1); % fe and ge are the exact 1st & 2nd derivatives of u

uhat=FFTdirect(u,N,-1);                                       % Compute FFT (in s) of u.
uhat=[uhat(N/2+2:N) uhat(1:N/2) 0]; k(1,:)=2*pi*[-N/2+1:N/2]; % Order uhat & k sequentially

a(2:N)  =-i*k(1:N-1)*beta/4;                     % Using (5.50), numerically compute du/dx
b(1:N)  = i*k(1:N)  *(alpha+beta/2);
c(1:N-1)=-i*k(2:N)  *beta/4;
fhat(1)=b(1).*uhat(1)+c(1).*uhat(1); 
fhat(2:N-1)=a(2:N-1).*uhat(1:N-2)+b(2:N-1).*uhat(2:N-1)+c(2:N-1).*uhat(3:N);
fhat(N)=a(N).*uhat(N-1)+b(N).*uhat(N);
fhat=[fhat(N/2:N) fhat(1:N/2-1)]; f=FFTdirect(fhat,N,1);
figure(2); plot(x,real(f),'x',x,fe,'-'), title('First derivative of u')

a(3:N)  =-k(1:N-2).*(k(1:N-2)+2*pi)*beta^2/16;   % Using (5.51), compute d^2u/dx^2
b(2:N)  = k(1:N-1).*(k(1:N-1)+  pi)*(2*alpha*beta+beta^2)/4;
c(1:N)  =-k(1:N).^2*(alpha^2+alpha*beta+3*beta^2/8);
d(1:N-1)= k(2:N)  .*(k(2:N)  -  pi)*(2*alpha*beta+beta^2)/4;
e(1:N-2)=-k(3:N)  .*(k(3:N)  -2*pi)*beta^2/16;
ghat(1)=c(1)*uhat(1)+d(1)*uhat(2)+e(1)*uhat(3);
ghat(2)=b(2)*uhat(1)+c(2)*uhat(2)+d(2)*uhat(3)+e(2)*uhat(4);
ghat(3:N-2)=a(3:N-2).*uhat(1:N-4)+b(3:N-2).*uhat(2:N-3)+c(3:N-2).*uhat(3:N-2)+...
            d(3:N-2).*uhat(4:N-1)+e(3:N-2).*uhat(5:N);
ghat(N-1)=a(N-1)*uhat(N-3)+b(N-1)*uhat(N-2)+c(N-1)*uhat(N-1)+d(N-1)*uhat(N);
ghat(N)  =a(N)  *uhat(N-2)+b(N)  *uhat(N-1)+c(N)  *uhat(N);
ghat=[ghat(N/2:N) ghat(1:N/2-1)]; g=FFTdirect(ghat,N,1);
figure(3); plot(x,real(g),'x',x,ge,'-'), title('Second derivative of u')

% end script StretchedFourierTest
