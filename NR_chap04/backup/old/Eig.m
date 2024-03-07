function [lam,S]=RC_Eig(S,type)
% function [lam,S]=RC_Eig(S,type)
% A convenient wrapper routine for computing the eigenvalues and eigenvectors
% of a matrix A of General (type='g'), Hermitian (type='h'), or Real (type='r') structure.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

if nargin==1, type='r'; end
switch type(1)
  case 'g', lam=RC_EigGeneral(S); case 'h', lam=RC_EigHermitian(S); case 'r', lam=RC_EigReal(S);
end, if nargout==2, [S]=RC_ShiftedInversePower(S,lam); end
end % function RC_Eig
