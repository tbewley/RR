function [OM,r] = RC_ObsvMatrix(A,C)
% function [OM,r] = RC_ObsvMatrix(A,C)
% Compute the observability matrix [C; C*A; C*A^2; ... C*A^(n-1)] and its rank r.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.5.2.1 and 20.5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_ObsvMatrixTest">RC_ObsvMatrixTest</a>.

[no,n]=size(C); OM=[C]; for i=1:n-1, OM=[OM; OM(end-no+1:end,:)*A]; end
if nargout>1; [U,S,V,r]=SVD(OM); end
end % function RC_ObsvMatrix
