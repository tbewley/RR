function [AB,JB] = Brent(AA,AB,AC,JA,JB,JC,TOL,X,P)
% INPUT: {AA,AB,AC} bracket a minimum of J(A)=ComputeJ(X+A*P), with values {JA,JB,JC}.
% OUTPUT: AB minimizes J(A)=ComputeJ(X+A*P), with function value JB.
% TOL*abs(AB)+EPS is the accuracy of the answer.

Z=sqrt(5.)-2.; EPS=1e-25; AINC=0; TOL1=0; iter=0; flag1=0;
while (abs(AC-AA) > 2*TOL1)
  if (abs(AB-AA) > abs(AC-AB)); Swap(AA,AC); Swap(JA,JC); end;  % Reorder the data
  AL=min(AC,AA); AR=max(AC,AA); AMID=0.5*(AC+AA); AINT=AR-AL;
  TOL1=TOL*abs(AB)+EPS;  TOL2=2.*TOL1;  TOL3=TOL1*0.99;  FLAG = 0;
  if (abs(AINT) > TOL1)                      % Try an inverse quadratic interpolation step
    DBA=AB-AA; DCB=AC-AB; DCA=AC-AA;
    den=2.*(JA*DCB-JB*DCA+JC*DBA);
    if (den~=0.)
      AINC=(JA*DCB^2+JB*DCA*(DBA-DCB)-JC*DBA^2)/den; ANEW=AB+AINC;
      if (ANEW-AL > AINT/10 & AR-ANEW > AINT/10); FLAG=1; end                  % success!
      if (AB-AL<TOL1 & ANEW<AB & flag1==0); AINC=TOL3; FLAG=1, flag1=1;
      elseif (AR-AB<TOL1 & ANEW>AB & flag1==0); AINC=-TOL3; FLAG=1, flag1=1;
      else flag1=0;
      end
    end 
  end
  if FLAG==0; AINC=Z*(AC-AB); end    % ... if inv quad step fails, try golden section step
  if abs(AINC)>=TOL3; ANEW=AB+AINC; else; if AINC>0; ANEW=AB+TOL3; else; ANEW=AB-TOL3; end; end;
  JNEW=ComputeJ(X+ANEW*P); % Perform the new function evaluation.
  if (AB-AA)*(ANEW-AB)>0;   % Keep the three points defining the new bracketing triplet.
    if (JNEW > JB) AC=AA; JC=JA; AA=ANEW; JA=JNEW; 
    else           AA=AB; JA=JB; AB=ANEW; JB=JNEW; end;
  else
    if (JNEW > JB) AA=ANEW; JA=JNEW; 
    else           AC=AB; JC=JB; AB=ANEW; JB=JNEW; end;
  end
end
% end function Brent.m