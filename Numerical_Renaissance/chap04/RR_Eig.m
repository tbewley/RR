function [lam,S]=RR_Eig(S,type)
% function [lam,S]=RR_Eig(S,type)
% A convenient wrapper routine for computing the eigenvalues and eigenvectors
% of a matrix A of General (type='g'), Hermitian (type='h'), or Real (type='r') structure.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

if nargin==1, type='r'; end, switch type(1)
  case 'g', lam=RR_EigGeneral(S); case 'h', lam=RR_EigHermitian(S); case 'r', lam=RR_EigReal(S);
end, if nargout==2, [S]=RR_ShiftedInversePower(S,lam); end
end % function RR_Eig
