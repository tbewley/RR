% Test script for RC_CALE, RC_CARE, RC_DALE, and RC_DARE         % Numerical Renaissance Codebase 1.0
clear; n=40; S=rand(n); Q=rand(n); S=S*S'; Q=Q*Q'; A=rand(n); F=rand(n); 
X=RC_CALE(A,Q); eRC_CALE=norm(A'*X+X*A+Q), X=RC_CARE(A,S,Q); eRC_CARE=norm(A'*X+X*A-X*S*X+Q)
X=RC_DALE(F,Q); eRC_DALE=norm(F'*X*F-X+Q), X=RC_DARE(F,S,Q); eRC_DARE=norm(F'*X*inv(eye(n)+S*X)*F-X+Q)
