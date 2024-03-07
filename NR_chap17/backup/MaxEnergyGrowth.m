function [thetamax,x0]=RR_MaxEnergyGrowth(A,Q,tau,MODE)
% function [thetamax,x0]=RR_MaxEnergyGrowth(A,Q,tau,[MODE])
% Compute the maximum possible growth of the quantity x^H Q x over the specified period.
% For MODE='CT' (default), considers the system dx/dt=A*x over the time interval [0,tau].
% For MODE='DT', considers the system x_(k+1)=F*x_k over tau timesteps.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RR_MaxEnergyGrowthTest">RR_MaxEnergyGrowthTest</a>.

if nargin==3, MODE='CT'; end, Qhi=Inv(sqrtm(Q));
if MODE=='CT', Phi=RR_MatrixExponential(A,tau); else, Phi=A^tau; end
[lam,S]=RR_Eig(Qhi*Phi'*Q*Phi*Qhi,'h');
thetamax=lam(end); x0=Qhi*S(:,end); x0=x0/sqrt(x0'*Q*x0);
end % function RR_MaxEnergyGrowth