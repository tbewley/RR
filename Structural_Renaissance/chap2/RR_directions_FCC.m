% script RR_directions_FCC
% draw representative directions, and planes, of the FCC grid
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 2)
%% Copyright 2026 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
figure(1), clf, hold on, r=0.1; n=8;
for i=-1:0; for j=-1:0; for k=-1:0
   off=[i j k]; drawFCC_cell(r,n,off)
end; end; end
mArrow3([-1 0 0],[0 0 0],'color','red','stemWidth',0.02);
x=[0 0 0 0]; y=[-1 1 1 -1]; z=[1 1 -1 -1];
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-62,11); axis off
print -depsc direction_FCC_001.eps

figure(2), clf, hold on,
for i=-1:0; for j=-1:0; for k=-1:0
   off=[i j k]; drawFCC_cell(r,n,off)
end; end; end
mArrow3([-.5 0 -.5],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 -1 1 1]; y=[-1 1 1 -1]; z=[1 1 -1 -1];
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-62,11); axis off
print -depsc direction_FCC_011.eps

figure(3), clf, hold on,
for i=-1:0; for j=-1:0; for k=-1:0
   off=[i j k]; drawFCC_cell(r,n,off)
end; end; end
h=mArrow3([-1 -1 -1],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 0 1 1 0 -1]; y=[0 -1 -1 0 1 1]; z=[1 1 0 -1 -1 0]; 
h=mArrow3([0 0 0],[0.5 -0.5 0],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5 0.5 0],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[0.5  0 -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[-0.5 0  0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[0 0.5  -0.5],'color','blue','stemWidth',0.02);
h=mArrow3([0 0 0],[0 -0.5  0.5],'color','blue','stemWidth',0.02);
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-8.3,20.6); axis off
print -depsc direction_FCC_111.eps

figure(4), clf, hold on,
for i=-1:0; for j=-1:0; for k=-1:0
   off=[i j k]; drawFCC_cell(r,n,off)
end; end; end
h=mArrow3([-1 -.5 -.5],[0 0 0],'color','red','stemWidth',0.02);
x=[-1 0 1 0]; y=[1 1 -1 -1]; z=[1 -1 -1 1]; 
fill3(x,y,z,'g')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(-8.3,20.6); axis off
print -depsc direction_FCC_112.eps

function drawFCC_cell(r,n,off)
   RR_drawsphere([0 0 0]+off,1,r,n)
   RR_drawsphere([1 0 0]+off,1,r,n)
   RR_drawsphere([0 1 0]+off,1,r,n)
   RR_drawsphere([1 1 0]+off,1,r,n)
   RR_drawsphere([0 0 1]+off,1,r,n)
   RR_drawsphere([1 0 1]+off,1,r,n)
   RR_drawsphere([0 1 1]+off,1,r,n)
   RR_drawsphere([1 1 1]+off,1,r,n)
   RR_drawsphere([0 0.5 0.5]+off,1,r,n)
   RR_drawsphere([1 0.5 0.5]+off,1,r,n)
   RR_drawsphere([0.5 0 0.5]+off,1,r,n)
   RR_drawsphere([0.5 1 0.5]+off,1,r,n)
   RR_drawsphere([0.5 0.5 0]+off,1,r,n)
   RR_drawsphere([0.5 0.5 1]+off,1,r,n)
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
