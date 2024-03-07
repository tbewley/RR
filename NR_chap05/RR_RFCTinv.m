function [u]=RC_RFCTinv(uhatC,N)
% function [u]=RC_RFCTinv(uhatC,N)
% Compute the inverse FCT via applciation of Fact 5.7.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFCT.  Verify with: RFCTtest.

uhatC(1)=2*uhatC(1); uhatC(N+1)=2*uhatC(N+1); u=RC_RFCT(uhatC,N)*N/2;
u(1)=2*u(1); u(N+1)=2*u(N+1);
end % function RC_RFCTinv
