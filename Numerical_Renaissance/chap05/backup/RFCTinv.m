function [u]=RFCTinv(uhatC,N)
% function [u]=RFCTinv(uhatC,N)
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.11.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFCT.  Trial: RFCTtest.

uhatC(1)=2*uhatC(1); uhatC(N+1)=2*uhatC(N+1);  % Simply apply Fact 4.7.
u=RFCT(uhatC,N)*N/2;
u(1)=2*u(1); u(N+1)=2*u(N+1);
end % function RFCTinv
