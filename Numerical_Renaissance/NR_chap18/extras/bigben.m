function bigben;                            
T=50; h=0.002; t=0;                                                % simulation parameters
g.sigma=4; g.b=1; g.r=48;                                          % Lorenz parameters
g.N1=1000; g.N2=1000; g.N3=1000; g.L1=100; g.L2=100; g.L3=100;        % grid parameters
g.N12=g.N1*g.N2; g.N123=g.N12*g.N3;
g.dx1=g.L1/(g.N1-1); g.dx2=g.L2/(g.N2-1); g.dx3=g.L3/(g.N3-1);
g.x1=-g.L1/2:g.dx1:g.L1/2; g.x2=-g.L2/2:g.dx2:g.L2/2; g.x3=-g.L3/2:g.dx3:g.L3/2;
i=g.N1*.55; j=g.N2*.55; k=g.N3*.55; % Initialize P
l=1+i+g.N1*j+g.N12*k; P=sparse(l,1,1,g.N123,1,1); sP=calculate_sparsity(P,g);  
y=[g.x1(i+1); g.x2(j+1); g.x3(k+1)]; yall=[y]; Lorenz_Plot(P,yall,g,sP),
for timestep=1:T/h                               % Time update of probability distribution.
  [u]=compute_u(sP,g);
  k1=RHS_P(P,sP,u,g); sK=calculate_sparsity(k1,g);
  k2=RHS_P(sum2(P,h*k1/2,sK,g),sK,u,g);
  k3=RHS_P(sum2(P,h*k2/2,sK,g),sK,u,g);
  k4=RHS_P(sum2(P,h*k3  ,sK,g),sK,u,g);
  P=sum5(P,h*k1/6,h*k2/3,h*k3/3,h*k4/6,sK,g); 
  for n=1:sK.N, l=sK.l(n); if P(l)<0.001, P(l)=0; end, end   % Apply threshold
  sP=calculate_sparsity(P,g);  
  k1=RHS_y(y,g); k2=RHS_y(y+(h/2)*k1,g); k3=RHS_y(y+(h/2)*k2,g); k4=RHS_y(y+h*k3,g);
  y=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;  yall=[yall y];
  if mod(timestep,10)==0, P=P/sum(P); Lorenz_Plot(P,yall,g,sP), end, t=t+h;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Lorenz_Plot(P,y,g,s)
Lm=10; figure(1), plot3([0 0],[0 0],[-Lm Lm],'k-'), hold on, axis([-Lm Lm -Lm Lm -Lm Lm])
plot3([-Lm Lm],[0 0],[0 0],'k-'), plot3([0 0],[-Lm Lm],[0 0],'k-')
for n=1:s.N
  l=s.l(n); plot3(g.x1(s.i(n)+1),g.x2(s.j(n)+1),g.x3(s.k(n)+1),'b.','MarkerSize',20*P(l)^(1/3)+1);
end,
plot3(y(1,:),y(2,:),y(3,:),'r-'); plot3(y(1,end),y(2,end),y(3,end),'r*','MarkerSize',20);
hold off, drawnow
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [s]=calculate_sparsity(P,g)
s.l=find(P); s.N=length(s.l); lm=s.l-1;
s.i=mod(lm,g.N1); s.j=mod(floor(lm/g.N1),g.N2); s.k=floor(lm/g.N12);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a]=sum2(b,c,s,g)
a=sparse(g.N123,1); for n=1:s.N, l=s.l(n); a(l)=b(l)+c(l); end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [a]=sum5(b,c,d,e,f,s,g)
a=sparse(g.N123,1); for n=1:s.N, l=s.l(n); a(l)=b(l)+c(l)+d(l)+e(l)+f(l); end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u]=compute_u(s,g);
u=sparse(g.N123,3);
for n=1:s.N
  l=s.l(n); i=s.i(n); j=s.j(n); k=s.k(n);
  u(l      ,1)=g.sigma*(g.x2(j)-(g.x1(i+1)+g.x1(i))/2);
  u(l-1    ,1)=g.sigma*(g.x2(j)-(g.x1(i)+g.x1(i-1))/2);
  u(l      ,2)=-(g.x2(j+1)+g.x2(j))/2-g.x1(i)*g.x3(k);
  u(l-g.N1 ,2)=-(g.x2(j)+g.x2(j-1))/2-g.x1(i)*g.x3(k);
  u(l      ,3)=-g.b*(g.x3(k+1)+g.x3(k))/2+g.x1(i)*g.x2(j)-g.b*g.r;
  u(l-g.N12,3)=-g.b*(g.x3(k)+g.x3(k-1))/2+g.x1(i)*g.x2(j)-g.b*g.r;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [k]=RHS_P(P,s,u,g) 
f=sparse(g.N123,3); k=sparse(g.N123,1);
for n=1:s.N,  l=s.l(n);
  f(l      ,1)=(P(l)+P(l+1    ))*u(l      ,1)/2;
  f(l-1    ,1)=(P(l)+P(l-1    ))*u(l-1    ,1)/2;
  f(l      ,2)=(P(l)+P(l+g.N1 ))*u(l      ,2)/2;
  f(l-g.N1 ,2)=(P(l)+P(l-g.N1 ))*u(l-g.N1 ,2)/2;
  f(l      ,3)=(P(l)+P(l+g.N12))*u(l      ,3)/2;
  f(l-g.N12,3)=(P(l)+P(l-g.N12))*u(l-g.N12,3)/2;
end
for n=1:s.N, for inc=0:6, l=s.l;
    switch inc
	  case 1, l=l+1;     case 2, l=l-1;
	  case 3, l=l+g.N1;  case 4, l=l-g.N1;
	  case 5, l=l+g.N12; case 6, l=l-g.N12;
    end
    k(l)=-(f(l,1)-f(l-1,1))/g.dx1-(f(l,2)-f(l-g.N1,2))/g.dx2-(f(l,3)-f(l-g.N12,3))/g.dx3;
end, end
end % function RHS_P
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [k]=RHS_y(y,g)                           
k=[g.sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -g.b*y(3)+y(1)*y(2)-g.b*g.r];
end % function RHS_y
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [phi]=MC(theta), phi=max(0,min((1+theta)/2,2,2*theta)); end
function [phi]=MC(theta), phi=(theta+abs(theta))/(1+abs(theta)); end
