function [U,T]=RC_Schur(U,type)
% function [U,T]=RC_Schur(U,type)
% A convenient wrapper routine for computing the RC_Schur decomposition
% of a matrix A of General (type='g'), Hermitian (type='h'), or Real (type='r') structure.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

if nargin==1, type='r'; end
switch type(1)
  case 'g', lam=RC_EigGeneral(U); case 'h', lam=RC_EigHermitian(U); case 'r', lam=RC_EigReal(U);
end; [U,T]=RC_ShiftedInversePower(U,lam); 
end % function RC_Schur
