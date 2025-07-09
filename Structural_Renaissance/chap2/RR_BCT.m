% BCC cube
clear;
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1]*2/sqrt(3);
figure(2); clf; for i=1:size(pts,1); drawsphere(pts(i,:),0,0.5); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(summer)
% print -dpdf 'bcc.pdf'

% FCC cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0; 0.5 0 0.5; 0.5 1 0.5; 0 0.5 0.5; 1 0.5 0.5; ...
     0 0 1; 0 1 1; 1 0 1; 1 1 1; 0.5 0.5 1]*sqrt(2);
figure(1); clf; for i=1:size(pts,1); drawsphere(pts(i,:),0,0.5); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(summer)
% print -dpdf 'fcc.pdf'
pt=[0 1 0.5]*sqrt(2); hold on; drawsphere(pt,0,0.208,50); 
% print -dpdf 'fcc_plus_carbon.pdf'

% BCT cube
p0=[ 0 0 0;  0 1 0;   1   1   0;   1     0    0; 0.5 0.5 0.5; 0  0 1;  0   1    1; 1 1 1; 1 0 1];
p1=[-1 0 0; -1 0 1; -0.5 0.5 0.5; -0.5 -0.5 0.5;  0  -1   0;  0 -1 1; 0.5 -0.5 0.5; ...
     1 2 0;  1 2 1;  1.5 0.5 0.5;  1.5  1.5 0.5;  2   1   0;  2  1 1; 0.5  1.5 0.5];
p2=[ 0 1 0;  1 1 0;   1   0   0;   0.5  0.5 0.5;  0   1   1;  1  1 1;  1   0    1; ...
     1 2 0;  1 2 1;  1.5 0.5 0.5;  1.5  1.5 0.5;  2   1   0;  2  1 1; 0.5  1.5 0.5];
p3=[-1 0 0; -1 0 1; -0.5 0.5 0.5; -0.5 -0.5 0.5;  0  -1   0;  0 -1 1; 0.5 -0.5 0.5; ...
     0 0 0;  0 0 1];
for i=1:3; l0(i,:)=[p0(1,i) p0(2,i) p0(3,i) p0(4,i) p0(1,i) p0(6,i) p0(7,i) p0(8,i) p0(9,i) p0(6,i) ...
                    p0(9,i) p0(4,i) p0(3,i) p0(8,i) p0(7,i) p0(2,i)]; end
for i=1:3; l1(i,:)=[p0(2,i) p0(4,i) p1(12,i) p1(8,i) p0(2,i) p0(7,i) p0(9,i) p1(13,i) p1(9,i) p0(7,i) ...
                    p0(9,i) p0(4,i) p1(12,i) p1(13,i) p1(9,i) p1(8,i)]; end
for i=1:3; l2(i,:)=[p0(4,i) p1(5,i) p1(1,i)  p0(2,i) p1(1,i) p1(2,i) p0(7,i) p1(2,i) ...
                    p1(6,i) p0(9,i) p1(6,i) p1(5,i)]; end
thetamin=asind((1/sqrt(3))); thetamax=45; N=5
dtheta=(thetamax-thetamin)/N;
for frame=1:N+1
  theta=thetamin+(frame-1)*dtheta,   v_scale=2*sind(theta);  h_scale=sqrt(2)*cosd(theta);
  p0s(:,1:2)=p0(:,1:2)*h_scale;  p0s(:,3)=p0(:,3)*v_scale;
  p1s(:,1:2)=p1(:,1:2)*h_scale;  p1s(:,3)=p1(:,3)*v_scale;
  l0s(1:2,:)=l0(1:2,:)*h_scale;  l0s(3,:)=l0(3,:)*v_scale;
  l1s(1:2,:)=l1(1:2,:)*h_scale;  l1s(3,:)=l1(3,:)*v_scale;
  l2s(1:2,:)=l2(1:2,:)*h_scale;  l2s(3,:)=l2(3,:)*v_scale;
  figure(3); clf;
  plot3(l2s(1,:),l2s(2,:),l2s(3,:),'b-','linewidth',1); hold on
  plot3(l1s(1,:),l1s(2,:),l1s(3,:),'r-','linewidth',1)
  plot3(l0s(1,:),l0s(2,:),l0s(3,:),'k-','linewidth',3)
  for i=1:size(p0s,1); drawsphere(p0s(i,:),0,0.2,20); end
  for i=1:size(p1s,1); drawsphere(p1s(i,:),0,0.2,20,0.2); end
  axis([-3 5 -3 5 -1 3]); axis off; axis equal; view(-302,11); colormap(summer); pause(0.01);
%  filename="frame"+frame+".pdf"; if frame<N+1, print(3,'-dpdf','-vector','-fillpage',filename); end
end

figure(3); clf; frame=5
p2s(:,1:2)=p2(:,1:2)*h_scale;  p2s(:,3)=p2(:,3)*v_scale;
p3s(:,1:2)=p3(:,1:2)*h_scale;  p3s(:,3)=p3(:,3)*v_scale;
plot3(l2s(1,:),l2s(2,:),l2s(3,:),'b-','linewidth',1); hold on
plot3(l0s(1,:),l0s(2,:),l0s(3,:),'k-','linewidth',1)
plot3(l1s(1,:),l1s(2,:),l1s(3,:),'r-','linewidth',3)
for i=1:size(p2s,1); drawsphere(p2s(i,:),0,0.2,20); end
for i=1:size(p3s,1); drawsphere(p3s(i,:),0,0.2,20,0.2); end
axis([-3 5 -3 5 -1 3]); axis off; axis equal; view(-302,11); colormap(summer);
% print(3,'-dpdf','-vector','-fillpage',filename);