function [uhatC]=RFCT(u,N)
% function [uhatC]=RFCT(u,N)
% INPUT: u is a real column vector of length N+1 where N=2^s.
% OUTPUT: uhatC is a real column vector of length N+1. 
% This code combines the u_j according to (5.48a), computes its RFFT, 
% then extracts the uhat^c_n according to (5.48b).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFCTinv, RFST, RFFT.  Verify with: RFSTtest.

w(1:N)=(u(1:N)+u(N+1:-1:2))+(u(N+1:-1:2)-u(1:N)).*sin([0:N-1]'*pi/N);
what=RFFT(w,N); 
uhatC(1,1)=real(what(1))/2; uhatC(N+1,1)=imag(what(1))/2; uhatC(3:2:N-1)=real(what(2:N/2));
u(1)=u(1)/2; u(N+1)=u(N+1)/2; uhatC(2,1)=(2/N)*cos(pi*[0:N]/N)*u;
for n=3:2:N-1; uhatC(n+1,1)=uhatC(n-1,1)-2*imag(what((n-1)/2+1)); end
end % function RFCT
