function Q=RC_DAREdoubling(F,S,Q,n,steps)
% function X=RC_DAREdoubling(F,S,Q,n,steps)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0. 
% This code uses an elegant and efficient approach known as the doubling algorithm.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALE, RC_CARE, RC_DALE, RC_DARE, RC_RDE.  Verify with RC_DAREtest.

for iter=1:steps
  E=inv(eye(n)+Q*S); Fnew=F*E'*F; Qnew=Q+F'*E*Q*F; S=S+F*S*E*F'; F=Fnew; Q=Qnew;
end
end % function RC_DAREdoubling
