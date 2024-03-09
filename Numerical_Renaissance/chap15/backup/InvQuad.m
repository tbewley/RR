function [AB,JB]=InvQuad(AA,AB,AC,JA,JB,JC,T,X,P,V) % Numerical Renaissance Codebase 1.0
% INPUT: {AA,AB,AC} bracket a minimum of J(A)=ComputeJ(X+A*P), with values {JA,JB,JC}.
% OUTPUT: AB locally minimizes J(A), with accuarcy T*abs(AB) and value JB.
% WARNING: this routine stalls on functions like J(A)=A^6+A.  Use Brent instead.
if AA>AC; [AA,AC]=Swap(AA,AC); [JA,JC]=Swap(JA,JC); end
for ITER=1:500;                                           % {AA,AB,AC} is starting triplet
  T1=T*abs(AB)+1.E-25;  T3=T1*0.99;                       % Initialize
  AM=0.5*(AA+AC); if abs(AC-AA)<4.*T1; ITER, return; end             % Check convergence
  T=(AB-AA)*(JB-JC); D=(AB-AC)*(JB-JA); N=(AB-AC)*D-(AB-AA)*T; D=2*(T-D);  % Parabolic fit
  AINC=N/D;                                                                % [see (15.2)]
  if (AB-AA<T1 & AINC<=0); AINC=T3; elseif (AC-AB<T1 & AINC>=0); AINC=-T3; end
  if abs(AINC)<T1; AN=AB+T3*sign(AINC); else; AN=AB+AINC; end; JN=ComputeJ(X+AN*P,V);
  if (AB-AA)*(AN-AB)>0;                            % N is between B and C
    if (JN > JB) AC=AN; JC=JN;                     % {AA,AB,AN} is new triplet
    else         AA=AB; JA=JB; AB=AN; JB=JN; end;  % {AB,AN,AC} is new triplet
  else                                             % N is between A and B
    if (JN > JB) AA=AN; JA=JN;                     % {AN,AB,AC} is new triplet
    else         AC=AB; JC=JB; AB=AN; JB=JN; end;  % {AA,AN,AB} is new triplet
  end
  if V, disp(sprintf('%19.15f %19.15f %19.15f',AA,AB,AC)); end
end
end % function InvQuad