% Test script for RR_CALE, RR_CARE, RR_DALE, and RR_DARE         % Numerical Renaissance Codebase 1.0
clear; n=40; S=rand(n); Q=rand(n); S=S*S'; Q=Q*Q'; A=rand(n); F=rand(n); 
X=RR_CALE(A,Q); eRR_CALE=norm(A'*X+X*A+Q), X=RR_CARE(A,S,Q); eRR_CARE=norm(A'*X+X*A-X*S*X+Q)
X=RR_DALE(F,Q); eRR_DALE=norm(F'*X*F-X+Q), X=RR_DARE(F,S,Q); eRR_DARE=norm(F'*X*inv(eye(n)+S*X)*F-X+Q)
