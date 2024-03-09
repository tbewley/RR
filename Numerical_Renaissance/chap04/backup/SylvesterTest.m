% script RR_SylvesterTest
% Test RR_Sylvester with random A and B and C.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

m=4, n=5, A=rand(m,m); B=rand(n,n); C=rand(m,n);
g=1; X=RR_Sylvester(A,B,C,g,m,n), norm(A*X-X*B-g*C)

% end script RR_SylvesterTest
