function RR_Plot_Truss(Q,P,C,U,x);
N=[Q P]; [m,n]=size(C); [d,q]=size(Q); [d,p]=size(P);
close all; figure(1);
axis equal, axis tight, axis([-0.05 1.05 -0.3 0.4]), hold on
if max(Q(2,:))==0; fac=0; else, fac=1; end
fill(P(1,1)+[-.035     0 .035*fac],P(2,2)+[-.05 0 -.05],'k-')
fill(P(1,2)+[-.035*fac 0 .035    ],P(2,2)+[-.05 0 -.05],'k-')
N=[Q P]; 
for i=1:m
  [i1,d1]=max(C(i,:)); [i2,d2]=min(C(i,:)); 
  if x(i)<-0.01, sy='r-'; elseif x(i)>0.01, sy='b-'; else, sy='k--'; end
  plot([N(1,d1) N(1,d2)],[N(2,d1) N(2,d2)],sy,"LineWidth",3)
end
disp('In members: blue=tension, red=compression, black dashed=no force')
fac=0.1; for i=1:q
  plot([N(1,i) N(1,i)+fac*U(1,i)],[N(2,i) N(2,i)+fac*U(2,i)],'k-',"LineWidth",3)
end