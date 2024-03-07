function x = RC_Roots(a)
% function x = RC_Roots(a)
% Compute the roots of a polynomial a(1)*x^n+a(2)*x^(n-1)+...+a(n+1)=0 with |a(1)|>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Depends on <a href="matlab:help RC_Eig">RC_Eig</a>.

n=size(a,2); A=[-a(2:n)/a(1); eye(n-2,n-1)]; x=RC_Eig(A);
end % function RC_Roots
