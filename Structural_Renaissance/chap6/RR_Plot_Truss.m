function RR_Plot_Truss(Q,P,C,U,x);
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clf, hold on
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
CQ=C(:,1:q); CP=C(:,q+(1:p)); M=N*C';       
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end
VP=D*diag(x)*CP % Compute reaction forces

for i=1:q
  fprintf('Externally-applied load at free node #%d: %0.5g N\n',i,norm(U(:,i)))
end
for i=1:p
  fprintf('Reaction force at pinned node #%d: %0.5g N\n',i,norm(VP(:,i)))
end
t1=sum(U,2);
fprintf('Sum of all applied forces in (x,y) = (%0.5g, %0.5g) N\n',t1(1),t1(2))
t1=sum(VP,2);
fprintf('Sum of all reaction forces in (x,y) = (%0.5g, %0.5g) N\n',t1(1),t1(2))
for i=1:m
  if x(i)>0, fprintf('Pure tension in member #%d = %0.5g N\n',i,x(i))
  else,      fprintf('Pure compression in member #%d = %0.5g N\n',i,abs(x(i))), end
end
mx=max(x); fprintf('maximum tension (red, bold)      = %0.5g\n',mx)
mn=min(x); fprintf('maximum compression (blue, bold) = %0.5g\n',abs(mn))
fac_b=1*(max(max(N))-min(min(N))); fac_f=0.1/max(max([U VP]))*fac_b; 

figure(1), axis equal, axis tight, grid, hold on, h=max(Q(2,:));
if d==2
  fill(P(1,1)+[-.035 0 .035]*fac_b,P(2,1)+[-.05 0 -.05]*fac_b,'k-')
  fill(P(1,2)+[-.035 0 .035]*fac_b,P(2,2)+[-.05 0 -.05]*fac_b,'k-')
  for i=1:m
    [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:));  lw=3; 
    if x(i)<-0.01,    sy='b-'; if x(i)<mn*0.9, lw=6; end
    elseif x(i)>0.01, sy='r-'; if x(i)>mx*0.9, lw=6; end
    else, sy='k-'; end
    plot([N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],sy,"LineWidth",lw)
  end
  for i=1:q
    if h>0
      f=quiver(Q(1,i),Q(2,i),fac_f*U(1,i),fac_f*U(2,i),0);
    else
      f=quiver(Q(1,i)-fac_f*U(1,i),Q(2,i)-fac_f*U(2,i),fac_f*U(1,i),fac_f*U(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:p
    if h>0
      f=quiver(P(1,i)-fac_f*VP(1,i),P(2,i)-fac_f*VP(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    else
      f=quiver(P(1,i),P(2,i),fac_f*VP(1,i),fac_f*VP(2,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
else % d=3 case
  fac_b=fac_b*0.07; fac_f=fac_f*2; 
  for i=1:p, RR_Plot_Pyramid(P(:,i),fac_b), end
  for i=1:m
    [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:));  lw=3; 
    if x(i)<-0.01,    sy='b-'; if x(i)<mn*0.9, lw=6; end
    elseif x(i)>0.01, sy='r-'; if x(i)>mx*0.9, lw=6; end
    else, sy='k-'; end
    plot3([N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],[N(3,d1) N(3,d2)],sy,"LineWidth",lw)
  end
  for i=1:q
    if h>0, f=quiver3(Q(1,i)-fac_f*U(1,i), Q(2,i)-fac_f*U(2,i), Q(3,i)-fac_f*U(3,i), ...
                      fac_f*U(1,i),        fac_f*U(2,i),        fac_f*U(3,i),0);
    else,   f=quiver3(Q(1,i),       Q(2,i),       Q(3,i), ...
                      fac_f*U(1,i), fac_f*U(2,i), fac_f*U(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','m');
  end
  for i=1:p
    if h*VP(3,i)>0,
            f=quiver3(P(1,i)-fac_f*VP(1,i), P(2,i)-fac_f*VP(2,i), P(3,i)-fac_f*VP(3,i), ...
                      fac_f*VP(1,i),        fac_f*VP(2,i),        fac_f*VP(3,i),0);
    else,   f=quiver3(P(1,i),        P(2,i),        P(3,i), ...
                      fac_f*VP(1,i), fac_f*VP(2,i), fac_f*VP(3,i),0);
    end
    set(f,'MaxHeadSize',10000,'linewidth',3,'color','r');
  end
  view(-75.3,6.05)
end