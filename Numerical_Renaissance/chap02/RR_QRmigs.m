function [Q,R,D,r,L] = RR_QRmigs(A)
% function [Q,R,D,r,L] = RR_QRmigs(A)
% Compute the INTEGER QR decomposition, A=Q*D^(-1)*R, and rank r, of any small
% integer mxn matrix A via Modified Integer Gram-Schmidt.  Note that the integer
% matrices Q and L orthogonally span the column space and left nullspace of A.
% INPUTS:  A = a small (possibly, rectangular) integer matrix
% OUTPUTS: Q = a integer matrix with orthogonal columns, spans column space of A
%          R = an upper-triangular integer matrix
%          D = a diagonal integer matrix            (note that A=Q*D^(-1)*R)
%          r = the rank of A
%          L = a integer matrix with orthogonal columns, spans left nullspace of A
% TESTS: A=randi(11,6,4)-6, [Q,R,D,r,L]=RR_QRmigs(A), Q*inv(D)*R, Q'*Q, L'*L, Q'*L
%        A=randi(6,4,6)-3,  [Q,R,D,r,L]=RR_QRmigs(A),  Q'*Q
% NOTE: All internal calculations performed using 64-bit integer arithmetic only; final
% result converted to double for convenience (for doing matrix operations) in Matlab.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2025 by Thomas Bewley, published under BSD 3-Clause License. 

[m,n]=size(A); Q=int64(A); % Convert to 64-bit integers
for i=1:n                  % orthogonalize the columns of Q
  Q(:,i)=Q(:,i)/RR_gcd_vec(Q(:,i)); f(i)=dot_product(Q(:,i),Q(:,i));
  if f(i)>0, for j=i+1:n;
    Q(:,j)=f(i)*Q(:,j)-Q(:,i)*dot_product(Q(:,i),Q(:,j));
  end, end
end
index=[1:n]; for i=1:n     % strip out the zero columns of Q
  if f(i)==0, l=length(index);
    for j=1:l, if index(j)==i
      index=index([1:j-1,j+1:l]); break
    end, end
  end  
end, Q=Q(:,index); f=f(index); r=length(index);

L=int64(eye(m)); for j=1:r % orthogonalize columns of L against Q
  for i=1:m
    L(:,i)=f(j)*L(:,i)-Q(:,j)*dot_product(Q(:,j),L(:,i));
    L(:,i)=L(:,i)/RR_gcd_vec(L(:,i));
  end
end
for j=1:m                  % orthogonalize the columns of L
  h(j)=dot_product(L(:,j),L(:,j));
  for i=j+1:m
    L(:,i)=h(j)*L(:,i)-L(:,j)*dot_product(L(:,j),L(:,i));
    L(:,i)=L(:,i)/RR_gcd_vec(L(:,i));
  end
end
index=[1:m]; for i=1:m     % strip out the zero columns of L
  if dot_product(L(:,i),L(:,i))==0, l=length(index);
    for j=1:l, if index(j)==i
      index=index([1:j-1,j+1:l]); break
    end, end
  end  
end, L=L(:,index);
Q=double(Q); L=double(L); % convert to double (Matlab default)
R=Q'*A; D=Q'*Q;           % generate R and D
end % function QRmigs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [p]=dot_product(u,v)
p=0; for i=1:length(u), p=p+u(i)*v(i); end
end
