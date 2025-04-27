function RR_Plot_Frame(Q,C,U,x,P,R,S,M);

if nargin<7, S=[]; if nargin<6, R=[]; if nargin<5, P=[]; end, end, end, N=[Q P R S];
[m,n]=size(C); [ds,s]=size(S); [dr,r]=size(R); [dp,p]=size(P); [d,q]=size(Q);
if nargin<8, M=zeros(1,m); end

figure(1), clf, hold on, axis off, axis equal
[m,n]=size(C); [d,p]=size(P); [d,r]=size(R); [d,q]=size(Q);

F(1:m,1:n,1:d)=0; V(1:2,1:p+r)=0;
for i=1:m, for j=1:n, if C(i,j)==1, for k=1:2, F(i,j,k)=x(1); x=x(2:end); end,end,end,end

for i=1:p, for k=1:d, VP(k,i)=x(1);       x=x(2:end); end, end
for i=1:r,            VR(:,i)=[0,x(1)];   x=x(2:end); end 
for i=1:s, for k=1:d, VS(k,i)=x(1);       x=x(2:end); end, end
for i=1:s, if d==2,         MS(i)=x(1);   x=x(2:end);
           else, for k=1:d, MS(k,i)=x(1); x=x(2:end); end
end, end

if d==2 % plot d=2 case
  [row,col] = find(C'); % This finds the row and col of nonzero entries of C'
  member=0;
  for i=1:length(row)
    switch mod(col(i),6)
      case 1, sy='b-';
      case 2, sy='g-';
      case 3, sy='r-';
      case 4, sy='c-';
      case 5, sy='m-';
      case 0, sy='k-'; 
    end
    newx=N(1,row(i)); newy=N(2,row(i));
    if col(i)>member, member=member+1;
    else, plot([lastx newx],[lasty newy],sy,"LineWidth",6); end
    lastx=newx; lasty=newy;
  end
  flip=[1 1];
  fac=0.3; for i=1:p
    fill(P(1,i)+fac*[-.2 0 .2],P(2,i)+flip(i)*fac*[-.3 0 -.3],'k-')
  end
  fac=0.3; for i=1:r
    fill(R(1,i)+fac*[-.2 0 .2],R(2,i)+fac*[-.3 0 -.3],'k-')
    RR_drawcircle2([R(1,i)-fac*.1 R(2,i)-fac*.37],fac*.07,3,'k')
    RR_drawcircle2([R(1,i)+fac*.1 R(2,i)-fac*.37],fac*.07,3,'k')
  end
  fac=0.5; h=-1; for i=1:q
    if h>0
      f=quiver(N(1,i),N(2,i),fac*U(1,i),fac*U(2,i),0);
    else
      f=quiver(N(1,i)-fac*U(1,i),N(2,i)-fac*U(2,i),fac*U(1,i),fac*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  h=-1; for i=1:p
    if h*flip(i)*sign(VP(2,i))>0
      f=quiver(P(1,i),P(2,i),fac*VP(1,i),fac*VP(2,i),0);
    else
      f=quiver(P(1,i)-fac*VP(1,i),P(2,i)-fac*VP(2,i),fac*VP(1,i),fac*VP(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  h=-1; for i=1:r
    if h*flip(i)*sign(VR(2,i))>0
      f=quiver(R(1,i),R(2,i),fac*VR(1,i),fac*VR(2,i),0);
    else
      f=quiver(R(1,i)-fac*VR(1,i),R(2,i)-fac*VR(2,i),fac*VR(1,i),fac*VR(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  axis tight
else % plot d=3 case
  % TODO
end
end % function RR_Plot_Frame
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function RR_drawcircle2(loc,r,w,c)
if nargin<4; c=[0 .7 0], end
N=40;
THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*r;
[X,Y] = pol2cart(THETA,RHO);
X=X+loc(1);
Y=Y+loc(2);
Z=0*X;
H=line(X,Y,Z);
set(H,'LineWidth',w);
set(H,'Color',c);
end % function RR_drawcircle2