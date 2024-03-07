function [AB,JB]=Golden(AA,AB,AC,JA,JB,JC,T,X,P,V)   % Numerical Renaissance Codebase 1.0
% INPUT: {AA,AB,AC} bracket a minimum of J(A)=ComputeJ(X+A*P), with values {JA,JB,JC}.
% OUTPUT: AB locally minimizes J(A), with accuracy T*abs(AB) and value JB.
% WARNING: this routine is slow.  Use Brent instead.
if abs(AB-AA) > abs(AC-AB); [AA,AC]=Swap(AA,AC); [JA,JC]=Swap(JA,JC); end  % Reorder data
for ITER=1:50
  if abs(AC-AB) < T*abs(AB)+1e-25, ITER, return, end
  AN = AB + 0.236068*(AC-AB);  JN = ComputeJ(X+AN*P,V);
  if (JN > JB)
    AC=AA; JC=JA; AA=AN; JA=JN;  % Center new triplet on AB (AB already in position)
  else
    AA=AB; JA=JB; AB=AN; JB=JN;  % Center new triplet on AN (AC already in position)
  end
  if V, disp(sprintf('%9.5f %9.5f %9.5f %9.5f %9.5f %9.5f',AA,AB,AC,JA,JB,JC)); end
end
end % function Golden
