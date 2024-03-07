function [P,r] = RC_CtrbGramian(A,B,MODE)
% function [P,r] = RC_CtrbGramian(A,B,[MODE])
% Compute the controllability grammian P and its rank r of a Hurwitz state-space system.
% If MODE='CT' (default), A*P+P*A'+B*B'=0.  If MODE='DT', P=A*P*A'+B*B'.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.5.1.2 and 20.5.3.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_CtrbGramianTest">RC_CtrbGramianTest</a>.

if nargin==2, MODE='CT'; end, if MODE=='CT', P=RC_CALE(A,B*B'); else, P=RC_DALE(A,B*B'); end
if A==real(A), P=real(P); end, if nargout>1; [U,S,V,r]=RC_SVD(P); end
end % function RC_CtrbGramian
