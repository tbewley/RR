function dist=RC_DistanceDL(a,b,W,verbose)
% function dist=RC_DistanceDL(a,b,W,verbose)
% Compute the weighted Damerau-Levenshtein distance between two strings; {W.D,W.I,W.S,W.E}
% are the weights on Deletion, Insertion, Substitution, and Exchange (of adjacent symbols
% only), all taken as 1 by default.  Implements Algorithm S of Lowrance & Wagner (1975).
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_DistanceOSA.  Verify with RC_DistanceDLtest.

Al=length(a); Bl=length(b); if Al==0 | Bl==0, dist=Al+Bl; return, end
if nargin<3, W.D=1; W.I=1; W.S=1; W.C=1; W.E=1; end, INF=Al+Bl+1; H=INF*ones(Al+2,Bl+2);
for i=0:Al, H(i+2,2)=i*W.D; end % Initialize pure deletions and insertions.
for j=0:Bl, H(2,j+2)=j*W.I; end % (Note that H indices are incremented by 2 wrt LW75.)
Alphabet=Unique([a b]);         % Alphabet contains all symbols used in this problem.
for i=1:Al, A(i)=StrFind(Alphabet,a(i)); end  % Convert characters in a and b to integers.
for i=1:Bl, B(i)=StrFind(Alphabet,b(i)); end, DA(1:length(Alphabet))=0;
for i=1:Al, DB=0; for j=1:Bl, i1=DA(B(j)); j1=DB;
  % When the code gets here, DA(c) holds either 0 or the largest index I, with 1<I<i, such
  % that a(I)=c for each member c of Alphabet; in particular, i1 holds the largest index
  % I, with 1<I<i, such that a(I)=b(j).  Similarly, j1 holds either 0 or the largest
  % index J, with 1<J<j, such that b(J)=a(i).  Knowledge of i1 & j1 enables "Operation *":
  %  1) start from the first i1 symbols of a, modified to match the first j1 symbols of b;
  %  2) Delete those elements corresponding to the elements between i1 and i in a;
  %  3) Exchange the element corresponding to i1 in a with the (new) element to its right;
  %  4) Insert the appropriate symbols to match the elements between j1 and j in b.
  if A(i)==B(j), d=0; DB=j; else, d=W.S; end
  H(i+2,j+2)=min([ H(i+1,j+2)+W.D, H(i+2,j+1)+W.I, H(i+1,j+1)+d, ...  % Simple D, I, or S.
      H(i1+1,j1+1)+(i-i1-1)*W.D+W.E+(j-j1-1)*W.I]);  % <- Operation *, as described above.
end, DA(A(i))=i; end, dist=H(Al+2,Bl+2);  if nargin>3, H, end
end % function RC_DistanceDL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function b=Unique(a)  % A (nonalphebatized) replacement for Matlab's 'unique' fn.
b=[]; for i=1:length(a), t=StrFind(b,a(i)); if length(t)==0, b=[b a(i)]; end, end
end % function Unique
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function c=StrFind(a,b) % A (single-symbol) replacement for Matlab's 'strfind' fn.
c=[]; for i=1:length(a), if a(i)==b; c=[c i]; end, end
end % function Unique