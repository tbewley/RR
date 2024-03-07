M=4, N=5, A=rand(M,M); B=rand(N,N); C=rand(M,N);     % Numerical Renaissance Codebase 1.0
g=1; X=RC_Sylvester(A,B,C,g,M,N), norm(A*X-X*B-g*C)
