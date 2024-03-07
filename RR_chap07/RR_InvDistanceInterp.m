function [fn]=RC_InvDistanceInterp(xn,c,f,p,R)
% function [fn]=RC_InvDistanceInterp(xn,c,f,p,R)
% Given the data {c,f}, compute the inverse distance interpolant fn at a new point xn.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_PolyharmonicSpline.  Verify with RC_InvDistanceInterpTest.

N=length(f); C=0; fn=0;
for i=1:N, d=norm(xn-c(:,i),2); if d<R, C=C+1/d^p; fn=fn+f(i)/d^p; end, end, fn=fn/C;
end % function RC_InvDistanceInterp
