function [A,B,C,G] = BlockThomas(A,B,C,G,n,m)        % Numerical Renaissance Codebase 1.0
% This function solves the system FX=G for X using the Thomas algorithm, where
% F = tridiag(A,B,C), and A, B, and C are tensors of size (1:m,1:m,1:n). That is,
% each block of A, B, and C is m x m, and there are n such blocks on the main diagonal.
% The three diagonals of F are replaced by the M_ij and U on exit, and the tensor G
% is replaced by the solution X of the original system.
for j = 1:n-1,                                
   A(:,:,j+1) = - A(:,:,j+1) /  B(:,:,j);        
   B(:,:,j+1) = B(:,:,j+1)   + A(:,:,j+1)*C(:,:,j);         
   G(:,:,j+1) = G(:,:,j+1)   + A(:,:,j+1)*G(:,:,j);    
end                                        
G(:,:,n) = B(:,:,n) \ G(:,:,n);
for i = n-1:-1:1,
   G(:,:,i) = B(:,:,i) \ ( G(:,:,i) - C(:,:,i) * G(:,:,i+1) );
end
end % function BlockThomas.m
