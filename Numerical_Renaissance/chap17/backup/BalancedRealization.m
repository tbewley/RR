function [A,B,C,HankelSingularValues] = RR_BalancedRealization(A,B,C,MODE)
% function [A,B,C,HankelSingularValues] = RR_BalancedRealization(A,B,C,MODE)
% Compute a balanced realization of a state-space system with Hurwitz A, resulting in
% a system with equal and diagonal controllability and observability grammians with
% the Hankel singular values listed in decreasing order on the main diagonal of both.
% Works for MODE='CT' (default) or 'DT'.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Trial: <a href="matlab:help RR_BalancedRealizationTest">RR_BalancedRealizationTest</a>.

if nargin==3, MODE='CT'; end
P=RR_CtrbGrammian(A,B,MODE); Q=RR_ObsvGrammian(A,C,MODE); n=length(A); G=Cholesky(P,n);
[Lambda,U,V]=SVD(G'*Q*G); HankelSingularValues=diag(Lambda).^(1/2);
T=G*U*diag(HankelSingularValues.^(-1/2)); Ti=inv(T); A=Ti*A*T; B=Ti*B; C=C*T;

end % function RR_BalancedRealization