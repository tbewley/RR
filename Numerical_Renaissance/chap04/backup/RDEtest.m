% script RR_RDEtest
% Test RR_RDE with random F and random Q>0, S>0, simply by marching the DRE to steady
% state and making sure that the result satisfies the corresponding RR_DARE.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; format compact; n=6; Q=randn(n); Q=Q*Q'; S=randn(n); S=S*S'; F=randn(n);
X=RR_RDE(eye(n),F,S,Q,n,1024), error_RR_RDEsteadystate=norm(F'*X*inv(eye(n)+S*X)*F-X+Q)

% end script RR_RDEtest
