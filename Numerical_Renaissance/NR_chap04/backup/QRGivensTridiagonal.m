function [bv,cv,av,c,s] = QRGivensTridiagonal(av,bv,cv)
% Compute a QR decomposition of a square tridiagonal matrix A=tridiag(av,bv,cv) by
% applying a sequence of N-1 Givens rotations directly to the tridiagonal elements.
% The result returned is the three nonzero diagonals [bv,cv,av] of the upper 
% tridiagonal matrix Q and the N-1 values of c and s from each rotation performed.
N=size(bv);
for i=1:N-1
   f=bv(i); g=av(i+1); gs=real(conj(g)*g); fs=real(conj(f)*f);
   if gs==0, c(i)=1; s(i)=0;  else     
     if fs>=gs, c(i)=1/sqrt(1+gs/fs); s(i)=-c(i)*g/f;       % Eqn (1.12)
     else,      s(i)=1/sqrt(1+fs/gs); c(i)=-s(i)*f/g;  end
     bv(i)=conj(c(i))*bv(i)-conj(s(i))*av(i+1);             % Eqn (1.11a), row i
     temp =conj(c(i))*cv(i)-conj(s(i))*bv(i+1);
     av(i)=                -conj(s(i))*cv(i+1);
     bv(i+1)=s(i)*cv(i)+c(i)*bv(i+1);                       % Eqn (1.11a), row i+1
     cv(i+1)=c(i)*cv(i+1);
     cv(i)=temp;
   end
end
% end function QRGivensTridiagonal.m