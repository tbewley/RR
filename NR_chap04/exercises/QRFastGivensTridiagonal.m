function [bv,cv,av,type,alpha,beta,d] = QRFastGivensTridiagonal(av,bv,cv,m)
% function [bv,cv,av,type,alpha,beta,d] = QRFastGivensTridiagonal(av,bv,cv,m)
% Compute a QR decomposition of a square tridiagonal matrix A=tridiag(av,bv,cv) by
% applying a sequence of m-1 fast Givens transforms directly to the tridiagonal
% elements.  The result returned is the three nonzero diagonals [bv,cv,av] of the 
% upper tridiagonal matrix R and the m-1 values of [type,alpha,beta] parameterizing 
% each transform performed, along with the corresponding d vector.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

d=ones(m,1);
for i=1:m-1
   if av(i+1)==0,
     type(i)=2; alpha(i)=0; beta(i)=0;
   else     
     alpha(i)=-bv(i)/av(i+1); beta(i)=-alpha(i)*d(i+1)/d(i);
     gamma=-(real(alpha(i))*real(beta(i))+imag(alpha(i))*imag(beta(i)));
     if gamma<=1
       type(i)=1; d([i i+1])=(1+gamma)*d([i+1 i]);   % (1.19) and (1.15a) [cf. Alg 1.3]
       bv(i)=conj(beta(i))*bv(i)+av(i+1); t=conj(beta(i))*cv(i)+bv(i+1); av(i)=cv(i+1);
       bv(i+1)=cv(i)+alpha(i)*bv(i+1);    cv(i+1)=alpha(i)*cv(i+1);      cv(i)=t;
     else 
       type(i)=2; d([i i+1])=(1+1/gamma)*d([i i+1]);                         % (1.19)
       alpha(i)=1/alpha(i); beta(i)=1/beta(i); 
       bv(i)=bv(i)+conj(beta(i))*av(i+1);  t=cv(i)+conj(beta(i))*bv(i+1);    % (1.15a)
       av(i)=conj(beta(i))*cv(i+1);        bv(i+1)=alpha(i)*cv(i)+bv(i+1);
       cv(i+1)=cv(i+1);                    cv(i)=t;
     end
   end
end
end % function QRFastGivensTridiagonal.m
