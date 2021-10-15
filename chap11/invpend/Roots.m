function x = Roots(a)                                % Numerical Renaissance Codebase 1.0
% Compute the roots of a polynomial a_0 x^n + a_1 x^(n-1) + ... + a_n = 0 with |a_0|>0.
n=size(a,2); A=[-a(2:n)/a(1); eye(n-2,n-1)]; x=Eig(A);
end % function Roots.m