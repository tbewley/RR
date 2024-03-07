% script RC_TestQR
% Test the QR decomposition codes 
% Remove various semicolons to print stuff to screen along the way, or leave the
% semicolons in and change M and N to try larger matrices.

disp('Now initializing a random complex square or tall MxN matrix (with M=>N)');
M=5; N=4;                                        % Try tall or square (M>=N),
A=randn(M,N)+i*randn(M,N);                       % real or complex matrices A.
disp('Now testing QRcgs');
[Q,R]=QRcgs(A); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-A),
disp('Now testing QRmgs');
[Q,R]=QRmgs(A); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-A), 

disp('Now initializing any random complex MxN matrix');
M=4; N=5;                                        % Try tall, square, or fat,
B=randn(M,N)+i*randn(M,N);                       % real or complex matrices B.
disp('Now testing QRHouseholder');
[Q,R]=QRHouseholder(B); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-B),

disp('Now initializing a random complex RC_Hessenberg matrix');
M=5; N=4;                                        % Try tall, square, or fat, 
C=randn(M,N)+i*randn(M,N);                       % real or complex matrices C,
for J=1:N-1, for I=J+2:M, C(I,J)=0; end, end,    % forced to be upper RC_Hessenberg.
disp('Now testing RC_QRGivensHessenberg');
[Q,R]=RC_QRGivensHessenberg(C); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-C),
disp('Now testing RC_QRFastGivensHessenberg');
[Q,R]=RC_QRFastGivensHessenberg(C); nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-C),

disp('Now initializing a random complex tridiagonal matrix');
N=50;                                           % Try square, tridiagonal
av=randn(N,1)+i*randn(N,1);                      % real or complex matrices only.
bv=randn(N,1)+i*randn(N,1);
cv=randn(N,1)+i*randn(N,1);
D=diag(av(2:N),-1)+diag(bv,0)+diag(cv(1:N-1),1);
disp('Now running RC_QRFastGivensHessenberg');
tic; [Q,R]=RC_QRFastGivensHessenberg(D); toc,
nonorthogonality=norm(Q'*Q-eye(size(Q'*Q))), residual=norm(Q*R-D),
disp('Now testing QRFastGivensTridiagonal');
tic; [bv,cv,av,type,alpha,beta,d]=QRFastGivensTridiagonal(av,bv,cv); toc,
R1=diag(bv,0)+diag(cv(1:N-1),1)+diag(av(1:N-2),2); Rcheck=norm(R-R1),

% end script RC_TestQR.m
