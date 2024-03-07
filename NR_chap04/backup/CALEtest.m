% script RR_CALEtest
% Test RR_CALE with random A and random Q>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=40; Q=randn(n); Q=Q*Q'; A=randn(n);
X=RR_CALE(A,Q); error_RR_CALE=norm(A*X+X*A'+Q)

% end script RR_CALEtest
