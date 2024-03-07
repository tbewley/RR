function [A,Q] = RC_QRGivensHessenberg(A)
% function [A,Q] = RC_QRGivensHessenberg(A)
% Compute a QR decomposition A=QR by applying a sequence of min(n,m-1) Givens rotations
% to an mxn upper RC_Hessenberg matrix A to reduce it to upper triangular form.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Depends on <a href="matlab:help RotateCompute">RotateCompute</a>, <a href="matlab:help Rotate">Rotate</a>.

[m,n]=size(A);  Q=eye(m,m);      % Note: R is returned in the modified A.
for i=1:min(n,m-1)
  [c,s]=RotateCompute(A(i,i),A(i+1,i)); [A]=Rotate(A,c,s,i,i+1,i,n,'L'); 
  [Q]=Rotate(Q,c,s,i,i+1,1,m,'R');
end
end % function RC_QRGivensHessenberg
