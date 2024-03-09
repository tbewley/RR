
n=10
av=[0; randn(n-1,1)]; bv=randn(n,1); cv=[randn(n-1,1); 0];
A=diag(av(2:n),-1)+diag(bv,0)+diag(cv(1:n-1),1)


[bv,cv,av,c,s] = QRGivensTridiag(av,bv,cv)
Q=dia

