% script RC_DAREtest
% Test RC_DARE & RC_DAREdoubling with random F and random Q>0, S>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

RC_RDEtest

M   =[F+S*inv(F')*Q, -S*inv(F'); -inv(F')*Q, inv(F')];
Minv=[inv(F), inv(F)*S; Q*inv(F), F'+Q*inv(F)*S];     check=norm(eye(2*n)-M*Minv)

Y=real(RC_DARE(F,S,Q,n)),      error_RC_DARE          =norm(F'*Y*inv(eye(n)+S*Y)*F-Y+Q)
Z=RC_DAREdoubling(F,S,Q,n,10), error_RC_DAREdoubling  =norm(F'*Z*inv(eye(n)+S*Z)*F-Z+Q)

% end script RC_DAREtest
