function Q=RC_DAREdoubling(F,S,Q,n,steps)
% function X=RC_DAREdoubling(F,S,Q,n,steps)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0. 
% This code uses an elegant and efficient approach known as the doubling algorithm.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

for iter=1:steps
  E=inv(eye(n)+Q*S); Fnew=F*E'*F; Qnew=Q+F'*E*Q*F; S=S+F*S*E*F'; F=Fnew; Q=Qnew;
end
end % function RC_DAREdoubling
