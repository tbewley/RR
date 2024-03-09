function [U,T]=RR_Schur(U,type)
% function [U,T]=RR_Schur(U,type)
% A convenient wrapper routine for computing the RR_Schur decomposition
% of a matrix A of General (type='g'), Hermitian (type='h'), or Real (type='r') structure.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

if nargin==1, type='r'; end, switch type(1)
  case 'g', lam=RR_EigGeneral(U); case 'h', lam=RR_EigHermitian(U); case 'r', lam=RR_EigReal(U);
end; [U,T]=RR_ShiftedInversePower(U,lam); 
end % function RR_Schur
