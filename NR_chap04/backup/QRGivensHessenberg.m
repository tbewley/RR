function [A,Q] = RC_QRGivensHessenberg(A)
% function [A,Q] = RC_QRGivensHessenberg(A)
% Compute a QR decomposition A=QR by applying a sequence of min(n,m-1) Givens rotations
% to an mxn upper RC_Hessenberg matrix A to reduce it to upper triangular form.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[m,n]=size(A);  Q=eye(m,m);      % Note: R is returned in the modified A.
for i=1:min(n,m-1)
  [c,s]=RotateCompute(A(i,i),A(i+1,i)); [A]=Rotate(A,c,s,i,i+1,i,n,'L'); 
  [Q]=Rotate(Q,c,s,i,i+1,1,m,'R');
end
end % function RC_QRGivensHessenberg