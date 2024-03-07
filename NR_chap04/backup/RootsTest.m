% script RC_RootsTest
% Test RC_Roots on a couple of specified polynomials.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

a=RC_Roots([1 -1 0 0 -1 1]), for i=1:5; res(i)=a(i)^5-a(i)^4-a(i)+1; end, residual_a=norm(res)
b=RC_Roots([1  0 0 0 -1 1]), for i=1:5; res(i)=b(i)^5       -b(i)+1; end, residual_b=norm(res)

% end script RC_RootsTest
