function [d,c]=Deadbeat(b,a)
% function [d,c]=Deadbeat(b,a)
% Find a ripple-free deadbeat controller D(z)=d(z)/c(z) for a stable plant G(z)=b(z)/a(z).
% Algorithm due to Sirisena (1985).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.4.3.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also ?.  Verify with DeadbeatTest.

n=length(a)-1; m=length(b)-1; d=a; c=[PolyVal(b,1) zeros(1,n)]-[zeros(1,n-m) b];
end % function Deadbeat
