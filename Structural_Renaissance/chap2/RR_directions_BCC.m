% script RR_directions_BCC
% draw the slip directions, and planes, of the BCC grid
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 2)
%% Copyright 2026 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

n=30; close all;
figure(1), clf, hold on,
for i=-1:0; for j=-1:0; for k=-1:0
   off=[i j k]; drawBCC_cell(r,n,off)
end; end; end
mArrow3([-1 0 -1],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 -1 1 1]; y=[-1 1 1 -1]; z=[1 1 -1 -1];
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-67.1,13.1); axis off
h=mArrow3([0 0 0],[0.5  0.5 -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[0.5 -0.5 -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5  0.5 0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5 -0.5 0.5],'color','blue','stemWidth',0.02);
print -depsc direction_BCC_011.eps

figure(2), clf, hold on,
for i=-1:0; for j=-1:0; for k=-2:0
   off=[i j k]; drawBCC_cell(r,n,off)
end; end; end
h=mArrow3([-1 -1 -2],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 -1 1 1]; y=[-1 1 1 -1]; z=[1 0 -1 0]; 
h=mArrow3([0 0 0],[ 0.5  0.5 -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5 -0.5  0.5],'color','blue','stemWidth',0.02);
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-78.52,13.05);  axis off
print -depsc direction_BCC_112.eps

figure(3), clf, hold on,
for i=-2:1; for j=-1:0; for k=-3:0
   off=[i j k]; drawBCC_cell(r,n,off)
end; end; end
for i=-1:-1; for j=-2:-2; for k=-3:-3
   off=[i j k]; drawBCC_cell(r,n,off)
end; end; end
h=mArrow3([-1 -2 -3],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 -2 1 2]; y=[-1 1 1 -1]; z=[1 0 -1 0]; 
h=mArrow3([0 0 0],[ 0.5  0.5 -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5 -0.5  0.5],'color','blue','stemWidth',0.02);
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(16.05,11.04); axis off
print -depsc direction_BCC_123.eps

function drawBCC_cell(r,n,off)
   RR_drawsphere([0 0 0]+off,1,r,n)
   RR_drawsphere([1 0 0]+off,1,r,n)
   RR_drawsphere([0 1 0]+off,1,r,n)
   RR_drawsphere([1 1 0]+off,1,r,n)
   RR_drawsphere([0 0 1]+off,1,r,n)
   RR_drawsphere([1 0 1]+off,1,r,n)
   RR_drawsphere([0 1 1]+off,1,r,n)
   RR_drawsphere([1 1 1]+off,1,r,n)
   RR_drawsphere([0.5 0.5 0.5]+off,1,r,n)
   plot3([0 1]+off(1),[0 0]+off(2),[0 0]+off(3),'k-');
   plot3([0 0]+off(1),[0 1]+off(2),[0 0]+off(3),'k-');
   plot3([1 0]+off(1),[1 1]+off(2),[0 0]+off(3),'k-');
   plot3([1 1]+off(1),[1 0]+off(2),[0 0]+off(3),'k-');
   plot3([0 1]+off(1),[0 0]+off(2),[1 1]+off(3),'k-');
   plot3([0 0]+off(1),[0 1]+off(2),[1 1]+off(3),'k-');
   plot3([1 0]+off(1),[1 1]+off(2),[1 1]+off(3),'k-');
   plot3([1 1]+off(1),[1 0]+off(2),[1 1]+off(3),'k-');
   plot3([0 0]+off(1),[0 0]+off(2),[0 1]+off(3),'k-');
   plot3([1 1]+off(1),[0 0]+off(2),[0 1]+off(3),'k-');
   plot3([0 0]+off(1),[1 1]+off(2),[0 1]+off(3),'k-');
   plot3([1 1]+off(1),[1 1]+off(2),[0 1]+off(3),'k-');
end
