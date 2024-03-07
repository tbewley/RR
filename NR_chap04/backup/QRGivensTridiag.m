function [b,c,a,cc,ss] = RC_QRGivensTridiag(a,b,c)
% function [b,c,a,cc,ss] = RC_QRGivensTridiag(a,b,c)
% Compute a QR decomposition of a square tridiagonal matrix A=tridiag(a,b,c) by
% applying a sequence of n-1 Givens rotations directly to the tridiagonal elements.
% The result returned is the three nonzero diagonals [b,c,a] of the upper tridiagonal
% matrix R, and the n-1 values of c and s for each of the n-1 rotations performed, which
% is more efficient in this case than returning Q itself (which is upper RC_Hessenberg).
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=size(b); for i=1:n-1, [cc(i),ss(i)]=RC_RotateCompute(b(i),a(i+1)); if cc(i)~=1
  b(i)  =conj(cc(i))*b(i)  -conj(ss(i))*a(i+1);       % Eqn (1.12a), row i
  temp  =conj(cc(i))*c(i)  -conj(ss(i))*b(i+1);
  a(i)  =                  -conj(ss(i))*c(i+1);
  b(i+1)=     ss(i) *c(i)  +cc(i)*b(i+1);             % Eqn (1.12a), row k=i+1
  c(i+1)=     cc(i) *c(i+1);               c(i)=temp;
end, end
end % function RC_QRGivensTridiag