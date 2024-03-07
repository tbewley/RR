% RC_BlockThomasTest                                    % Numerical Renaissance Codebase 1.0
% This script tests the BlockThomas.m algorithm.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.

n=5; m=3;
A=randn(m,m,n); B=randn(m,m,n); C=randn(m,m,n); G=randn(m,1,n);  
g=reshape(G,m*n,1);
F=zeros(m*n,m*n); 
for i=1:n;   F((i-1)*m+1:i*m,(i-1)*m+1:(i  )*m)=B(:,:,i); end;
for i=2:n;   F((i-1)*m+1:i*m,(i-2)*m+1:(i-1)*m)=A(:,:,i); end;
for i=1:n-1; F((i-1)*m+1:i*m,(i  )*m+1:(i+1)*m)=C(:,:,i); end;
[A,B,C,G] = RC_BlockThomas(A,B,C,G,n,m);
x=reshape(G,m*n,1);  error=norm(F*x-g)
