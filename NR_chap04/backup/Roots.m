function x = RC_Roots(a)
% function x = RC_Roots(a)
% Compute the roots of a polynomial a(1)*x^n+a(2)*x^(n-1)+...+a(n+1)=0 with |a(1)|>0.
% Uses RC_Eig.m from Section 4.4.5 of RC.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=size(a,2); A=[-a(2:n)/a(1); eye(n-2,n-1)]; x=RC_Eig(A);
end % function RC_Roots
