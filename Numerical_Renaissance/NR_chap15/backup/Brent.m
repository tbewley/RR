function [AB,JB]=Brent(AA,AB,AC,JA,JB,JC,TOL,X,P,V)  % Numerical Renaissance Codebase 1.0
% INPUT: {AA,AB,AC} bracket a minimum of J(A)=ComputeJ(X+A*P), with values {JA,JB,JC}.
% OUTPUT: AB locally minimizes J(A), with accuarcy TOL*abs(AB) and value JB.
AINC=0; AL=min(AC,AA); AR=max(AC,AA);
if (abs(AB-AA) > abs(AC-AB)); [AA,AC]=Swap(AA,AC); [JA,JC]=Swap(JA,JC); end;
for ITER=1:50;
  if ITER<3; AINT=2*(AR-AL); end; TOL1=TOL*abs(AB)+1E-25; TOL2=2*TOL1; FLAG=0; % Initialize
  AM=(AL+AR)/2; if (AR-AL)/2+abs(AB-AM)<TOL2; ITER, return; end        % Check convergence
  if (abs(AINT)>TOL1 | ITER<3)
    % Perform a parabolic fit based on points {AA,AB,AC} [see (15.2)]
    T=(AB-AA)*(JB-JC); D=(AB-AC)*(JB-JA); N=(AB-AC)*D-(AB-AA)*T; D=2*(T-D); 
    if D<0.; N=-N; D=-D; end; T=AINT; AINT=AINC;
    if (abs(N)<abs(D*T/2) & N>D*(AL-AB) & N<D*(AR-AB)) % AINC=N/D within reasonable range?
      AINC=N/D; AN=AB+AINC; FLAG=1;                    % Success! AINC is new increment.
      if (AN-AL<TOL2 | AR-AN<TOL2); AINC=abs(TOL1)*sign(AM-AB); end  % Fix if AN near ends
    end
  end
  % If parabolic fit unsuccessful, do golden section step based on bracket {AL,AB,AR}
  if FLAG==0; if AB>AM; AINT=AL-AB; else; AINT=AR-AB; end; AINC=0.381966*AINT; end
  if abs(AINC)>TOL1; AN=AB+AINC; else; AN=AB+abs(TOL1)*sign(AINC); end
  JN=ComputeJ(X+AN*P,V);
  if JN<=JB                                   % Keep 6 (not necessarily distinct) points
    if AN>AB; AL=AB; else; AR=AB; end         % defining the interval from one iteration
    AC=AA; JC=JA; AA=AB; JA=JB; AB=AN; JB=JN; % to the next:
  else                                        % {AL,AB,AR} bracket the minimum
    if AN<AB; AL=AN; else; AR=AN; end         % AB=Lowest point, most recent if tied w/ AA
    if (JN<=JA | AA==AB)                      % AA=Second-to-lowest point.
      AC=AA; JC=JA; AA=AN; JA=JN;             % AC=Third-to-lowest point
    elseif (JN<=JC | AC==AB | AC==AA)         % AN=Newest point
      AC=AN; JC=JN;                           % Parabolic fit based on {AA,AB,AC}
    end                                       % Golden section search based on {AL,AB,AR}
  end
  if V, disp(sprintf('%d %9.5f %9.5f %9.5f %9.5f %9.5f',FLAG,AA,AB,AC,AL,AR)); end
end
end % function Brent