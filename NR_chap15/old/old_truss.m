function x=truss(x)
global d
d.N=6; d.ab=1; d.ar=1; d.eps=1e-20;  d.alpha=0.02;
Draw(x); J=ComputeJ(x);
for i=1:10;
  g=ComputeGrad(x); g.h(d.N*d.N,1)=0; g.v(d.N*d.N,1)=0;
  x.h=x.h-d.alpha*g.h;   x.v=x.v-d.alpha*g.v;
  Draw(x);
end;
% end function truss

function Draw(x)
global d
figure(1); clf; hold on; axis equal; axis([0 10 -1.5 1.5]);
for i=1:d.N; k=1+(i-1)*d.N; plot([0 x.h(i)],[-1 x.v(i)],'b-'); plot([0 x.h(k)],[1 x.v(k)],'r-'); end
for i=1:d.N; for j=2:d.N; k=i+(j-1)*d.N; t=i  +(j-2)*d.N; plot([x.h(t) x.h(k)],[x.v(t) x.v(k)],'b-'); end; end
for i=2:d.N; for j=1:d.N; k=i+(j-1)*d.N; t=i-1+(j-1)*d.N; plot([x.h(t) x.h(k)],[x.v(t) x.v(k)],'r-'); end; end
hold off;
% end function Draw

function [J] = ComputeJ(x)
global d
for i=1:d.N; k=1+(i-1)*d.N; bl(i,1)=sqrt((x.h(i))^2+(-1-x.v(i))^2); rl(k,1)=sqrt((x.h(k))^2+(1-x.v(k))^2); end
for i=1:d.N; for j=2:d.N; k=i+(j-1)*d.N; kjm=i  +(j-2)*d.N; bl(k,1)=sqrt((x.h(kjm)-x.h(k))^2+(x.v(kjm)-x.v(k))^2); end; end
for i=2:d.N; for j=1:d.N; k=i+(j-1)*d.N; kim=i-1+(j-1)*d.N; rl(k,1)=sqrt((x.h(kim)-x.h(k))^2+(x.v(kim)-x.v(k))^2); end; end
NN=(d.N)^2; A=zeros(2*NN,2*NN); b=zeros(2*NN,1); b(2*NN,1)=1;
for i=1:d.N; for j=1:d.N; k=i+(j-1)*d.N; kim=i-1+(j-1)*d.N; kip=i+1+(j-1)*d.N; kjm=i+(j-2)*d.N; kjp=i+(j)*d.N;
  if j>1;   p=ATAN2((x.v(k)-x.v(kjm)),(x.h(k)-x.h(kjm)));
  else;     p=ATAN2((x.v(k)- (-1)   ),(x.h(k)- (0)    )); end; A(k,k  )=cos(p); A(NN+k,k  )=sin(p);
  if j<d.N; p=ATAN2((x.v(k)-x.v(kjp)),(x.h(k)-x.h(kjp)));      A(k,kjp)=cos(p); A(NN+k,kjp)=sin(p); end       
  if i>1;   p=ATAN2((x.v(kim)-x.v(k)),(x.h(kim)-x.h(k)));
  else;     p=ATAN2(((1)     -x.v(k)),((0)     -x.h(k))); end; A(k,NN+k  )=-cos(p); A(NN+k,NN+k  )=-sin(p);
  if i<d.N; p=ATAN2((x.v(kip)-x.v(k)),(x.h(kip)-x.h(k)));      A(k,NN+kip)=-cos(p); A(NN+k,NN+kip)=-sin(p); end       
end; end;
x=A\b; bf=x(1:NN,1); rf=x(NN+1:2*NN,1);
J = d.ab*(.1+sqrt(abs(bf)))'*(bl.*bl) + d.ar*(.1+abs(rf))'*(rl);
% end function ComputeJ

function [f] = ATAN2(dy,dx)
if  real(dx)>0, f=atan(dy/dx); else, f=pi-atan(-dy/dx); end;
% end function ATAN2

function [g] = ComputeGrad(x)
global d; im=sqrt(-1); NN=(d.N)^2;
for i=1:d.N; for j=1:d.N; k=i+(j-1)*d.N;
  xe=x; xe.h(k,1)=xe.h(k,1)+im*d.eps; g.h(k,1)=imag(ComputeJ(xe))/d.eps;
  xe=x; xe.v(k,1)=xe.v(k,1)+im*d.eps; g.v(k,1)=imag(ComputeJ(xe))/d.eps;
end; end
% end function ComputeGrad
