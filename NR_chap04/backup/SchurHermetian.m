function [A] = RC_SchurHermetian(A,p)
% Apply the QR algorithm p times to the Hermetian matrix A, leveraging the fact that 
% RC_Hessenberg.m returns a tridiagonal matrix, so the QR algorithm can be performed 
% just on the [av,bv,cv] vectors that make up the (tridiagonal) A at each step.
A=RC_Hessenberg(A); av=[0; diag(A,-1)]; bv=diag(A,0); cv=[diag(A,1); 0]; N=size(A,1);
for i=1:p;
   [bv,cv,av,c,s]=QRGivensTridiagonal(av,bv,cv);
   % Now calculate R*Q, given the N-1 values of [c,s] comprising each rotation (rather
   % than Q itself) and the nonzero diagonals [bv,cv,av] of the (uppertriangular) R.
   for i=1:N-1; if c(i)~=0     
     if i>1, cv(i-1)=c(i)*cv(i-1)-s(i)*av(i-1);  end     % Eqn (1.6b), column i
     temp   =     c(i) *bv(i) -    s(i) *cv(i);              
     cv(i)  =conj(s(i))*bv(i)+conj(c(i))*cv(i);          % Eqn (1.6b), column i+1
     bv(i+1)=                 conj(c(i))*bv(i+1);                         
     bv(i)=temp; 
   end, end  
   av(2:end)=conj(cv(1:end-1));
end;
% now put the av, bv, cv back into the matrix where A used to be.
A=diag(av(2:end),-1)+diag(bv)+diag(cv(1:end-1),1);
% end function RC_SchurHermetian.m
