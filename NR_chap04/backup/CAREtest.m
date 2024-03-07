% script RC_CAREtest
% Test RC_CARE with random A and random Q>0, S>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=40; Q=randn(n); Q=Q*Q'; S=randn(n); S=S*S'; A=randn(n);
X=RC_CARE(A,S,Q); error_RC_CARE=norm(A'*X+X*A-X*S*X+Q)

% end script RC_CAREtest
