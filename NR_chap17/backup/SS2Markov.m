function [m]=RC_SS2Markov(A,B,C,D,p)
% function [m]=RC_SS2Markov(A,B,C,D,p)
% Compute the first p Markov parameters of a CT or DT system in SS form.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_SS2MarkovTest">RC_SS2MarkovTest</a>.

m(1,1)=D; for k=2:p, m(k,1)=C*A^(k-2)*B; end
end % function RC_SS2Markov