% script RC_DAREdoublingTest
% Test RC_DARE.m with random F and random Q>0, S>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=6; Q=randn(n); Q=Q*Q'; S=randn(n); S=S*S'; F=randn(n);
Y=real(RC_DARE(F,S,Q)),   error_RC_DARE        =norm(F'*Y*inv(eye(n)+S*Y)*F-Y+Q)
Z=RC_DAREevolving(F,S,Q), error_RC_DAREevolving=norm(F'*Z*inv(eye(n)+S*Z)*F-Z+Q)
X=RC_DAREdoubling(F,S,Q), error_RC_DAREdoubling=norm(F'*X*inv(eye(n)+S*X)*F-X+Q)

% end script RC_DAREdoublingTest
