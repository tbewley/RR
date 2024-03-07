% script RC_NLeggedThomasTest                           % Numerical Renaissance Codebase 1.0
% Test NLeggedThomas.m on an n-legged problem with random coefficients.
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

clear; format compact;
m=1; n=5; p=3; % There are m systems, each with n legs of length p but different RHS {G,e}.
A=randn(p,n), B=randn(p,n), C=randn(p,n), d=randn(1,n+1), G=randn(p,n,m); e=randn(1,m);
[X,y] = NLeggedThomas(A,B,C,G,d,e,n,p)
for mm=1:m
  for i=1:n
    Ai=diag([A(2:p,i); 0],-1) + diag([B(1:p,i); 0],0) + diag([C(1:p,i)],1);
    norm(Ai*[X(:,i,mm); y(mm)] - [G(:,i,mm); 0])
    z(i,1) = X(p,i,mm);
  end
  z(n+1,1) = y(mm);
  norm(d*z - e(mm))
end
% end script RC_NLeggedThomasTest