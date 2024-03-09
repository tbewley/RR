function [J] = ComputeJ(x)
global d
x(d.NN+1:2*d.NN-1,1)=x(d.NN+1:2*d.NN-1,1); x(d.NN,1)=10; x(2*d.NN,1)=0;
for i=1:d.N; k=1+(i-1)*d.N; l(i,1)=sqrt((x(i))^2+(-1-x(i+d.NN))^2);
  l(k+d.NN,1)=sqrt((x(k))^2+(1-x(k+d.NN))^2); end
for i=1:d.N; for j=2:d.N; k=i+(j-1)*d.N; kjm=i  +(j-2)*d.N;
  l(k     ,1)=sqrt((x(kjm)-x(k))^2+(x(kjm+d.NN)-x(k+d.NN))^2); end; end
for i=2:d.N; for j=1:d.N; k=i+(j-1)*d.N; kim=i-1+(j-1)*d.N;
  l(k+d.NN,1)=sqrt((x(kim)-x(k))^2+(x(kim+d.NN)-x(k+d.NN))^2); end; end
A=zeros(2*d.NN,2*d.NN); b=zeros(2*d.NN,1); b(2*d.NN,1)=1;
for i=1:d.N; for j=1:d.N; k=i+(j-1)*d.N;
  kim=i-1+(j-1)*d.N; kip=i+1+(j-1)*d.N; kjm=i+(j-2)*d.N; kjp=i+(j)*d.N;
  if j>1;   p=ATAN2(x(k  +d.NN)-x(kjm+d.NN),x(k  )-x(kjm));
  else;     p=ATAN2(x(k  +d.NN)+1          ,x(k  )-0     ); end;
  A(k,k       )=cos(p); A(k+d.NN,k        )=sin(p);
  if j<d.N; p=ATAN2(x(k  +d.NN)-x(kjp+d.NN),x(k  )-x(kjp));
  A(k,kjp     )=cos(p); A(k+d.NN,kjp      )=sin(p); end       
  if i>1;   p=ATAN2(x(kim+d.NN)-x(k  +d.NN),x(kim)-x(k  ));
  else;     p=ATAN2(1          -x(k  +d.NN),0     -x(k  )); end;
  A(k,k  +d.NN)=-cos(p); A(k+d.NN,k  +d.NN)=-sin(p);
  if i<d.N; p=ATAN2(x(kip+d.NN)-x(k  +d.NN),x(kip)-x(k  ));     
  A(k,kip+d.NN)=-cos(p); A(k+d.NN,kip+d.NN)=-sin(p); end       
end; end;
f=A\b; J=0;
for k=1:2*d.NN;
  if f(k)>0; J=J+d.bmc*(d.rega+(f(k)))*(l(k))^2;
  else;      J=J+d.tmc*(d.regb+abs(f(k)))*(l(k))^d.pow; end
end;
% end function ComputeJ

function [f] = ATAN2(dy,dx)
if  real(dx)>0, f=atan(dy/dx); else, f=pi-atan(-dy/dx); end;
% end function ATAN2
