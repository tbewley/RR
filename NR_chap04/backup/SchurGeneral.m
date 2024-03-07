function [A,varargout] = RC_SchurGeneral(A,varargin)
% [T,U]=RC_SchurGeneral(A) for an MxN complex A with |lambda_1|>|lambda_2|>... 
% computes an uppter tridiagonal T and a unitary U such that A = U T U^H.  
% [lambda]=RC_SchurGeneral(A) only computes T, then only returns the eigenvalues.
% After an initial RC_Hessenberg decomposition, several shifted QR steps are taken using
% the RC_QRFastGivensHessenberg algorithm.  If only computing the eigenvalues, T is
% deflated when T(m,m) converges; if not, the shift is stepped from (m,m) to (2,2).
n=size(A,1);  m=n;
if nargin==1, if nargout<=1; A=RC_Hessenberg(A); else; [A,U]=RC_Hessenberg(A); end, end
for step=1:20*n    % (Note that loop should break well before step=20*n.)
  d=ones(n,1); mu=A(m,m); for i=1:m; A(i,i)=A(i,i)-mu; end   % Initialize d and shift A.
  for i=1:m-1     % Apply the same algorithm as in RC_QRFastGivensHessenberg.
    [A(:,i:n),type(i),alpha(i),beta(i),d([i i+1])]=FastGivens(A(:,i:n),i,i+1,d(i),d(i+1));
  end
  for i=1:m-1     % Apply the postmultiplications directly to A (thus computing R*Q)
    if type(i)==1, A(1:i+1,[i i+1])=[beta(i)*A(1:i+1,i)+A(1:i+1,i+1), ...
                                     A(1:i+1,i)+conj(alpha(i))*A(1:i+1,i+1)];
    else           A(1:i+1,[i i+1])=[A(1:i+1,i)+beta(i)*A(1:i+1,i+1), ...
                                     conj(alpha(i))*A(1:i+1,i)+A(1:i+1,i+1)]; end
  end                                                            
  for i=1:m, s(i)=1/sqrt(d(i));    
             A(i,max(i-1,1):end)=A(i,max(i-1,1):end)*s(i);        % Scale A
             A(1:min(i+1,n),i)=A(1:min(i+1,n),i)*s(i); 
             A(i,i)=A(i,i)+mu; end                            % Unshift A
  if nargout==2
    for i=1:m-1   % If requested, also compute the transformation matrix U
      if type(i)==1, U(:,[i i+1])=[beta(i)*U(:,i)+U(:,i+1), ...
                                   U(:,i)+conj(alpha(i))*U(:,i+1)];
      else           U(:,[i i+1])=[U(:,i)+beta(i)*U(:,i+1), ...
                                   conj(alpha(i))*U(:,i)+U(:,i+1)]; end
    end           
    for i=1:m,  U(:,i)=U(:,i)*s(i);  end                      % Scale U
  end
  if abs(A(m,m-1))< 1e-12*(abs(A(m,m))+abs(A(m-1,m-1)))       % If A(m,m) converged...
    if nargout<=1, if m>2, A(1:n-1,1:n-1)=RC_SchurGeneral(A(1:n-1,1:n-1),1); end; % Deflate
                   if nargin==1, A=diag(A); end;              % Define output
                   break
    else,          if m>2, m=m-1;                      % Shift by next diagonal element
                   elseif nargin==1, varargout(1)={U}; break, end;  % Define output
    end
  end
end
% end function RC_SchurGeneral.m