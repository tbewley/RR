function [lam,S]=Eig(S,type)                         % Numerical Renaissance Codebase 1.0
if nargin==1, type='real'; end
switch type(1)
  case 'g', lam=EigGeneral(S); case 'h', lam=EigHermitian(S); case 'r', lam=EigReal(S);
end, if nargout==2, [S]=ShiftedInversePower(S,lam); end
end % function Eig.m