function RR_Plot_Frame(Q,P,R,C,U,M,x);
% NOTE: this routine does not yet work fully.
figure(1), clf, hold on, axis off, axis equal
N=[Q P]; [m,n]=size(C); [d,p]=size(P); [d,r]=size(R); [d,q]=size(Q);

for i=1:m, for j=1:n,
  if C(i,j)==1, for k=1:2, exp="f"+k+"_"+i+"_"+j+"=x(1)"; eval(exp); x=x(2:end); end, end,
end, end

for k=1:2, for i=1:p+r, V(k,i)=x(1); x=x(2:end); end, end,

if d==2
  [row,col] = find(C'); % This finds the row and col of nonzero entries of C'
  member=0;
  for i=1:length(row)
    switch col(i)
      case 1, sy='b-';
      case 2, sy='g-';
      case 3, sy='r-';
      case 4, sy='c-';
      case 5, sy='m-';
      otherwise, sy='k-'; 
    end
    newx=N(1,row(i)); newy=N(2,row(i));
    if col(i)>member, member=member+1;
    else, plot([lastx newx],[lasty newy],sy,"LineWidth",6); end
    lastx=newx; lasty=newy;
  end
  flip=[1 -1];
  fac=1; for i=1:p
    fill(P(1,i)+fac*[-.2 0 .2],P(2,i)+flip(i)*fac*[-.3 0 -.3],'k-')
  end
  fac=0.75; h=-1; for i=1:q
    if h>0
      f=quiver(N(1,i),N(2,i),fac*U(1,i),fac*U(2,i),0);
    else
      f=quiver(N(1,i)-fac*U(1,i),N(2,i)-fac*U(2,i),fac*U(1,i),fac*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  fac=0.75; h=1; for i=1:p
    if h>0
      f=quiver(P(1,i),P(2,i),fac*U(1,i),fac*U(2,i),0);
    else
      f=quiver(P(1,i)-fac*U(1,i),P(2,i)-fac*U(2,i),fac*U(1,i),fac*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end

else % d=3 case
  % TODO.
end
end % function RR_Plot_Frame