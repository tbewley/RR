function [AA,AB,AC,JA,JB,JC]=BracketPress(AA,AB,JA,X,P,V)
% Numerical Renaissance Codebase 1.0
% INPUT: {AA,AB} are guesses of A near a minimum of J(A)=ComputeJ(X+A*P), with JA=J(AA).
% OUTPUT: {AA,AB,AC} bracket the minimum of J(A), with values {JA,JB,JC}.
JB=ComputeJ(X+AB*P,V);  if JB>JA; [AA,AB]=Swap(AA,AB); [JA,JB]=Swap(JA,JB); end
AC=AB+2*(AB-AA); JC=ComputeJ(X+AC*P,V);
while JB>=JC                      % At this point, {AA,AB,AC} has JA>=JB>=JC.
  flag=0; AL=AB+100*(AC-AB);      % Will allow exploration out to AL during this iteration.
  T=(AB-AA)*(JB-JC); D=(AB-AC)*(JB-JA); N=(AB-AC)*D-(AB-AA)*T; D=2.*(T-D); 
  if (D==0), AN=AL; else; AN=AB+N/D; end              % Do a parabolic fit [see (15.2)]
  if (AB-AN)*(AN-AC) > 0.                             % Fitted point AN between AB and AC.
    JN=ComputeJ(X+AN*P,V);                            % Evaluate fitted point AN.
    if     JN<JC, AA=AB; AB=AN; JA=JB; JB=JN; return; % {AB,AN,AC} is a bracketing triplet!
    elseif JN>JB, AC=AN;        JC=JN;        return; % {AA,AB,AN} is a bracketing triplet!
    else   AN=AC+4*(AC-AB); JN=ComputeJ(X+AN*P,V);    % Fit not useful. Compute new AN.
    end
  elseif (AN-AC)*(AL-AN) > 0.                         % Fitted point AN between AC and AL.
    JN=ComputeJ(X+AN*P,V);                            % Evaluate fitted point AN.
    if JN<JC                                          % Function still not increasing. 
      AB=AC; AC=AN; AN=AC+4*(AC-AB); JB=JC; JC=JN; JN=ComputeJ(X+AN*P,V); % Compute new AN.
    end
  elseif (AL-AN)*(AC-AL)>=0.                          % Fitted point at or beyond AL limit.
    AN=AL; JN=ComputeJ(X+AN*P,V);                     % Evaluate limit point AL.
  else
    AN=AC+4*(AC-AB); JN=ComputeJ(X+AN*P,V);           % All other cases: compute new AN.
  end
  AA=AB; AB=AC; AC=AN; JA=JB; JB=JC; JC=JN;           % {AB,AC,AN} -> {AA,AB,AC}
end
end % function BracketPress