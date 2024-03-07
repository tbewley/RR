function [uhatS]=RC_RFST(u,N)
% function [uhatS]=RC_RFST(u,N)
% INPUT: u is a real column vector of length N-1 where N=2^s.
% OUTPUT: uhatS is a real column vector of length N-1. 
% This code combines the u_j according to (5.47a), computes its RFFT, 
% then extracts the uhat^s_n according to (5.47b).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFSTinv, RFCT, RFFT.  Verify with: RFSTtest.

w(1)=0; w(2:N)=(u(N-1:-1:1)-u)+(u+u(N-1:-1:1)).*sin([1:N-1]'*pi/N); what=RFFT(w,N); 
uhatS(1,1)=real(what(1)); uhatS(2:2:N-2,1)=imag(what(2:N/2));
for n=3:2:N-1; uhatS(n,1)=uhatS(n-2,1)+2*real(what((n-1)/2+1)); end
end % function RC_RFST
