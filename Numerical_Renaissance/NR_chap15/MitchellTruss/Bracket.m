function [aa,ab,ac,Ja,Jb,Jc]=Bracket(ComputeJ,aa,ab,Ja,x,p,params,verbose);
% Numerical Renaissance Codebase 1.0
% INPUT: {aa,ab} are guesses of alpha parameter near a minimum of ComputeJ(x+alpha*p).
% OUTPUT: {aa,ab,ac} bracket the alpha that minimizes ComputeJ(x+alpha*p).
% For convenience, anything lumped into params is just passed along to the ComputeJ fn.
Jb=ComputeJ(x+ab*p,params);  if Jb>Ja; [aa,ab]=Swap(aa,ab); [Ja,Jb]=Swap(Ja,Jb); end
ac=ab+2*(ab-aa); Jc=ComputeJ(x+ac*p,params);
while (Jb>Jc)                                    % At this point, {aa,ab,ac} has Ja>Jb>Jc.
  an=ac+2.0*(ac-ab); Jn=ComputeJ(x+an*p,params); % Compute new point an outside of triplet
  aa=ab; ab=ac; ac=an;  Ja=Jb; Jb=Jc; Jc=Jn;     % {ab,ac,an} -> {aa,ab,ac}
end
end % function Bracket