function [A,Q] = RC_QRFastGivensHessenberg(A) 
% function [A,Q] = RC_QRFastGivensHessenberg(A) 
% Compute a QR decomposition A=QR by applying a sequence of min(n,m-1) fast Givens
% transforms to an mxn upper RC_Hessenberg matrix A to reduce it to upper triangular form.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[m,n]=size(A);  Q=eye(m,m); d=ones(m,1);
for i=1:min(n,m-1)
  [a,b,gamma,donothing,d([i i+1])]=FastGivensCompute(A(i,i),A(i+1,i),d(i),d(i+1));
  [A]=FastGivens(A,a,b,gamma,donothing,i,i+1,i,n,'L');
  [Q]=FastGivens(Q,a,b,gamma,donothing,i,i+1,1,m,'R');
end
for i=1:m,  dt=1/sqrt(d(i));  Q(:,i)=Q(:,i)*dt;  A(i,:)=A(i,:)*dt;  end 
end % function RC_QRFastGivensHessenberg