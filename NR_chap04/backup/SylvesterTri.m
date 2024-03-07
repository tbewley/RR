function X=RC_SylvesterTri(A,B,C,g,m,n)                 % Numerical Renaissance Codebase 1.0
% This function finds the X=X_(mxn) that satisfies A X - X B = g C, where A=A_(mxm) and
% B=B_(nxn) are upper triangular, g is a scaler with 0 < g <= 1, and C=C_(mxn) is full.
for b=m:-1:max(1,m-n+1);    s=m-b+1;   % b=initially big index, s=initially small index
  X(b,s)        = g*C(b,s) / (A(b,b)-B(s,s));  
  X(1:b-1,s)    = (A(1:b-1,1:b-1)-B(s,s)*eye(b-1,b-1)) \ (g*C(1:b-1,s)-A(1:b-1,b)*X(b,s));
  X(b,s+1:n)    = (g*C(b,s+1:n)+X(b,s)*B(s,s+1:n)) / (A(b,b)*eye(n-s,n-s)-B(s+1:n,s+1:n));
  C(1:b-1,s+1:n)= C(1:b-1,s+1:n) + (X(1:b-1,s)*B(s,s+1:n)-A(1:b-1,b)*X(b,s+1:n)) /g;
end
end % function RC_SylvesterTri.m