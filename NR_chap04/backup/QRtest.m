% script RC_TestQR                                      % Numerical Renaissance Codebase 1.0
% Test the QR decomposition codes 
% Remove various semicolons to print stuff to screen along the way, or leave the
% semicolons in and change M and N to try larger matrices.

disp('Now testing RC_QRFastGivensHessenberg');
[R,Q]=RC_QRFastGivensHessenberg(C); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-C),

disp('Now initializing a random complex tridiagonal matrix');
N=50;                                           % Try square, tridiagonal
av=randn(N,1)+i*randn(N,1);                      % real or complex matrices only.
bv=randn(N,1)+i*randn(N,1);
cv=randn(N,1)+i*randn(N,1);
D=diag(av(2:N),-1)+diag(bv,0)+diag(cv(1:N-1),1);
disp('Now running RC_QRFastGivensHessenberg');
tic; [R,Q]=RC_QRFastGivensHessenberg(D); toc,
nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-D),
disp('Now testing QRFastGivensTridiagonal');
tic; [bv,cv,av,type,alpha,beta,d]=QRFastGivensTridiagonal(av,bv,cv,N); toc,
for i=1:N,  s=1/sqrt(d(i));  av(i)=av(i)*s;  bv(i)=bv(i)*s;  cv(i)=cv(i)*s;  end 
R1=diag(bv,0)+diag(cv(1:N-1),1)+diag(av(1:N-2),2); Rcheck=norm(R-R1),

% end script RC_TestQR.m
