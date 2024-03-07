% script RR_HessenbergTest
% Test RR_Hessenberg on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

A=rand(8), [T,V]=RR_Hessenberg(A), error=norm(A-V*T*V')

% end script RR_HessenbergTest
