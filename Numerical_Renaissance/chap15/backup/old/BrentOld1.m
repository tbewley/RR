function [AB,JB] = Brent1(AA,AB,AC,JA,JB,JC,TOL,xx,pp)
% INPUT: {AA,AB,AC} bracket a minimum of J(A)=ComputeJ(X+A*P), with values {JA,JB,JC}.
% OUTPUT: AB minimizes J(A)=ComputeJ(X+A*P), with function value JB.
% TOL*abs(AB)+EPS is the accuracy of the answer.

CGOLD=.3819660; AINC=0;  FLAG3 = 0;
AL=min(AC,AA); AR=max(AC,AA);
for ITER=1:50;
  if (abs(AB-AA) > abs(AC-AB)); Swap(AA,AC); Swap(JA,JC); end;  % Reorder the data
  AMID=0.5*(AL+AR);
  if ITER < 3;  AINT=2.*(AR-AL); end
  TOL1=TOL*abs(AB)+1.E-30;  TOL2=2.*TOL1;
  if abs(AB-AMID)<=(TOL2-.5*(AR-AL)); FLAG3=1; return; end
  FLAG2 = 0;
  if abs(AINT) > TOL1 | ITER <= 2
    R=(AB-AA)*(JB-JC); Q=(AB-AC)*(JB-JA); P=(AB-AC)*Q-(AB-AA)*R; Q=2.*(Q-R);
    if Q > 0.; P=-P; end
    Q=abs(Q);  ETEMP=AINT;  AINT=AINC;
    if ~(abs(P) >= abs(0.5*Q*ETEMP) | P <= Q*(AL-AB) | P >= Q*(AR-AB))
      AINC=P/Q;   ANEW=AB+AINC;
      if (ANEW-AL < TOL2 | AR-ANEW < TOL2); AINC=abs(TOL1)*sign(AMID-AB); end
      FLAG2 = 1;
    end
  end
  if FLAG2 == 0; if AB >= AMID;  AINT=AL-AB; else; AINT=AR-AB; end; AINC=CGOLD*AINT; end
  if abs(AINC) >= TOL1; ANEW=AB+AINC; else; ANEW=AB+abs(TOL1)*sign(AINC); end
  JNEW=ComputeJ(xx+ANEW*pp);
  disp(sprintf('%d %d %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f %12.6f',ITER,FLAG2,AA,AB,ANEW,AC,JA,JB,JNEW,JC));     
  if JNEW <= JB
    if ANEW >= AB; AL=AB; else; AR=AB; end
    AC=AA; JC=JA; AA=AB; JA=JB; AB=ANEW; JB=JNEW;
  else
    if ANEW < AB; AL=ANEW; else; AR=ANEW; end
    if JNEW <= JA | AA == AB
      AC=AA; JC=JA; AA=ANEW; JA=JNEW;
    elseif JNEW <= JC | AC == AB | AC == AA
      AC=ANEW; JC=JNEW;
    end
  end
end
disp('Line minimization did not converge to prescribed tolerance.')
% end function Brent1.m
