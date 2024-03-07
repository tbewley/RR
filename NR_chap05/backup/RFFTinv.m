function [u]=RFFTinv(uh,N)
% function [u]=RFFTinv(uh,N)
% This routine was written by inverting the steps of RFFT and doing them in reverse.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT.  Verify with: RFFTtest.

wh(1)=real(uh(1,1))+imag(uh(1,1)) + i*(real(uh(1,1))-imag(uh(1,1)));
wh(N/4+1)=(real(uh(N/4+1,1)) -i*imag(uh(N/4+1,1)))*2;
M=N/2+2;
for n=2:N/4
  wh(n)=uh(n,1)+conj(uh(M-n,1))+(uh(n,1)-conj(uh(M-n,1)))*i*exp(2*pi*i*(n-1)/N);
  wh(M-n)=conj(uh(n,1))+uh(M-n,1)+(conj(uh(n,1))-uh(M-n,1))*i*exp(-2*pi*i*(n-1)/N);
end
w=FFTdirect(wh,N/2,1);
u(1:2:N-1,1)=real(w)';  u(2:2:N,1)=imag(w)';
end % function RFFTinv
