function [bv] = RC_EigHermitian(A)
% [lambda]=RC_EigHermitian(A) for an NxN Hermitian A with |lambda_1|>|lambda_2|>... 
% computes the eigenvalues lambda.  
% After an initial RC_Hessenberg decomposition, several explicitly-shifted QR steps
% are taken using the QRFastGivensTridiagonal algorithm.  
% When T(m,m) converges, the shift is stepped from (m,m) to (m-1,m-1).
n=size(A,1);  m=n;
A=RC_Hessenberg(A); av=[0; diag(A,-1)]; bv=diag(A,0); cv=[diag(A,1); 0]; N=size(A,1);
for step=1:20*n    % (Note that loop should break well before step=20*n.)
  d=ones(n,1); mu=bv(m); for i=1:m; bv(i)=bv(i)-mu; end   % Initialize d and shift A.
  [bv,cv,av,type,alpha,beta,d] = QRFastGivensTridiagonal(av,bv,cv,m); 
  for i=1:m-1;  % Apply the postmultiplications directly to A (thus computing R*Q)
     if type(i)==1;
       if i>1, cv(i-1)=beta(i)*cv(i-1)+av(i-1); end   % Eqn (1.11b), column i
       temp   =        beta(i)*bv(i)  +cv(i);              
       cv(i)  = bv(i)+  conj(alpha(i))*cv(i);         % Eqn (1.11b), column i+1
       bv(i+1)=       conj(alpha(i))*bv(i+1);                         
       bv(i)=temp; 
     else
       if i>1, cv(i-1)=cv(i-1)+beta(i)*av(i-1); end   % Eqn (1.11b), column i
       temp   =        bv(i)  +beta(i)*cv(i);              
       cv(i)  =   conj(alpha(i))*bv(i)+cv(i);         % Eqn (1.11b), column i+1
       bv(i+1)=                      bv(i+1);                         
       bv(i)=temp; 
     end
  end
  for i=1:m, s(i)=1/sqrt(d(i));
             bv(i)=bv(i)*s(i);                  cv(i)=cv(i)*s(i);  % Scale A 
             if i>1, cv(i-1)=cv(i-1)*s(i); end, bv(i)=bv(i)*s(i);   
             bv(i)=bv(i)+mu;                                       % Unshift A
  end
  av(2:end)=conj(cv(1:end-1));  av(1)=0;  
  if abs(av(m))< 1e-13*(abs(bv(m))+abs(bv(m-1)))       % If A(m,m) converged...
    if m>2, m=m-1;            % Shift by next diagonal element
    else  break, end 
  end
end; if step==20*n, disp('RC_EigHermitian did not converge'), end
% end function RC_EigHermitian.m