% script RC_HessenbergTest
% Test RC_Hessenberg.m on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

A=rand(8), [T,V]=RC_Hessenberg(A), error=norm(A-V*T*V')

% end script RC_HessenbergTest
