% script RR_DALEtest
% Test RR_DALE with random F and random Q>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=40; Q=randn(n); Q=Q*Q'; F=randn(n);
X=RR_DALE(F,Q,n); error_RR_DALE=norm(F*X*F'-X+Q)

% end script RR_DALEtest
