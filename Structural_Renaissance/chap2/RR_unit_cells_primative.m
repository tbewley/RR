% script RR_unit_cells_primative
% draws the primative unit cells of BCC, FCC, diamond, and HCP grids
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 2)
%% Copyright 2026 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, close all
figure(1), clf, hold on, r=0.15; % rhombohedral
for i=1:4
  switch i
    case 1, c=[0 0 0];
    case 2, c=[-1 0 0];
    case 3, c=[0 1 0];
    case 4, c=[0 0 -1];
  end
  RR_drawsphere(c+[0 0 0],0,r)
  RR_drawsphere(c+[1 0 0],0,r)
  RR_drawsphere(c+[0 1 0],0,r)
  RR_drawsphere(c+[1 1 0],0,r)
  RR_drawsphere(c+[0 0 1],0,r)
  RR_drawsphere(c+[1 0 1],0,r)
  RR_drawsphere(c+[0 1 1],0,r)
  RR_drawsphere(c+[1 1 1],0,r)
  RR_drawsphere(c+[1 1 1],0,r)
  RR_drawsphere(c+[0.5 0.5 0.5],1,r)
  plot3(c(1)+[0 0],c(2)+[0 0],c(3)+[0 1],'k-')
  plot3(c(1)+[0 0],c(2)+[0 1],c(3)+[1 1],'k-')
  plot3(c(1)+[0 0],c(2)+[1 1],c(3)+[1 0],'k-')
  plot3(c(1)+[0 0],c(2)+[1 0],c(3)+[0 0],'k-')
  plot3(c(1)+[1 1],c(2)+[0 0],c(3)+[0 1],'k-')
  plot3(c(1)+[1 1],c(2)+[0 1],c(3)+[1 1],'k-')
  plot3(c(1)+[1 1],c(2)+[1 1],c(3)+[1 0],'k-')
  plot3(c(1)+[1 1],c(2)+[1 0],c(3)+[0 0],'k-')
  plot3(c(1)+[0 1],c(2)+[0 0],c(3)+[0 0],'k-')
  plot3(c(1)+[0 1],c(2)+[0 0],c(3)+[1 1],'k-')
  plot3(c(1)+[0 1],c(2)+[1 1],c(3)+[0 0],'k-')
  plot3(c(1)+[0 1],c(2)+[1 1],c(3)+[1 1],'k-')
end
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off
s1=[-.5 .5 .5];
s2=[0 0 0];
s3=[0.5 0.5 -0.5];
s4=[0 1 0];
s5=[0 1 1];
s6=[0.5 1.5 0.5];
s7=[1 1 0];
s8=[0.5 0.5 0.5]; r=r*.5;
RR_drawsphere(s1,1,r)
RR_drawsphere(s2,1,r)
RR_drawsphere(s3,1,r)
RR_drawsphere(s4,1,r)
RR_drawsphere(s5,1,r)
RR_drawsphere(s6,1,r)
RR_drawsphere(s7,1,r)
RR_drawsphere(s8,1,r)
fill3([s1(1) s2(1) s3(1) s4(1)],[s1(2) s2(2) s3(2) s4(2)],[s1(3) s2(3) s3(3) s4(3)],'g','LineWidth',2)
fill3([s5(1) s6(1) s7(1) s8(1)],[s5(2) s6(2) s7(2) s8(2)],[s5(3) s6(3) s7(3) s8(3)],'g','LineWidth',2)
fill3([s3(1) s2(1) s8(1) s7(1)],[s3(2) s2(2) s8(2) s7(2)],[s3(3) s2(3) s8(3) s7(3)],'g','LineWidth',2)
fill3([s1(1) s2(1) s8(1) s5(1)],[s1(2) s2(2) s8(2) s5(2)],[s1(3) s2(3) s8(3) s5(3)],'g','LineWidth',2)
fill3([s1(1) s4(1) s6(1) s5(1)],[s1(2) s4(2) s6(2) s5(2)],[s1(3) s4(3) s6(3) s5(3)],'g','LineWidth',2)
fill3([s6(1) s7(1) s3(1) s4(1)],[s6(2) s7(2) s3(2) s4(2)],[s6(3) s7(3) s3(3) s4(3)],'g','LineWidth',2)

figure(2), clf, hold on
RR_drawsphere([0 0 0],0,r)
RR_drawsphere([1 0 0],0,r)
RR_drawsphere([0 1 0],0,r)
RR_drawsphere([1 1 0],0,r)
RR_drawsphere([0 0 1],0,r)
RR_drawsphere([1 0 1],0,r)
RR_drawsphere([0 1 1],0,r)
RR_drawsphere([1 1 1],0,r)
RR_drawsphere([0 0.5 0.5],1,r)
RR_drawsphere([1 0.5 0.5],1,r)
RR_drawsphere([0.5 0 0.5],1,r)
RR_drawsphere([0.5 1 0.5],1,r)
RR_drawsphere([0.5 0.5 0],1,r)
RR_drawsphere([0.5 0.5 1],1,r)
plot3([0 0],[0 0],[0 1],'k-')
plot3([0 0],[0 1],[1 1],'k-')
plot3([0 0],[1 1],[1 0],'k-')
plot3([0 0],[1 0],[0 0],'k-')
plot3([1 1],[0 0],[0 1],'k-')
plot3([1 1],[0 1],[1 1],'k-')
plot3([1 1],[1 1],[1 0],'k-')
plot3([1 1],[1 0],[0 0],'k-')
plot3([0 1],[0 0],[0 0],'k-')
plot3([0 1],[0 0],[1 1],'k-')
plot3([0 1],[1 1],[0 0],'k-')
plot3([0 1],[1 1],[1 1],'k-')
s1=[0 .5 0.5];
s2=[.5 0 0.5];
s3=[0.5 0.5 0];
s4=[0 1 0];
s5=[.5 .5 1];
s6=[0.5 1 0.5];
s7=[1 .5 .5];
s8=[1 0 1]; r=r*.5;
RR_drawsphere(s1,1,r)
RR_drawsphere(s2,1,r)
RR_drawsphere(s3,1,r)
RR_drawsphere(s4,1,r)
RR_drawsphere(s5,1,r)
RR_drawsphere(s6,1,r)
RR_drawsphere(s7,1,r)
RR_drawsphere(s8,1,r)
fill3([s1(1) s2(1) s3(1) s4(1)],[s1(2) s2(2) s3(2) s4(2)],[s1(3) s2(3) s3(3) s4(3)],'g','LineWidth',2)
fill3([s5(1) s6(1) s7(1) s8(1)],[s5(2) s6(2) s7(2) s8(2)],[s5(3) s6(3) s7(3) s8(3)],'g','LineWidth',2)
fill3([s3(1) s2(1) s8(1) s7(1)],[s3(2) s2(2) s8(2) s7(2)],[s3(3) s2(3) s8(3) s7(3)],'g','LineWidth',2)
fill3([s1(1) s2(1) s8(1) s5(1)],[s1(2) s2(2) s8(2) s5(2)],[s1(3) s2(3) s8(3) s5(3)],'g','LineWidth',2)
fill3([s1(1) s4(1) s6(1) s5(1)],[s1(2) s4(2) s6(2) s5(2)],[s1(3) s4(3) s6(3) s5(3)],'g','LineWidth',2)
fill3([s6(1) s7(1) s3(1) s4(1)],[s6(2) s7(2) s3(2) s4(2)],[s6(3) s7(3) s3(3) s4(3)],'g','LineWidth',2)
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off

figure(3), clf, hold on, r=sqrt(3)/8;
RR_drawsphere_octant(r,[0 0 0],[ 1  1  1])
RR_drawsphere_octant(r,[1 0 0],[-1  1  1])
RR_drawsphere_octant(r,[0 1 0],[ 1 -1  1])
RR_drawsphere_octant(r,[1 1 0],[-1 -1  1])
RR_drawsphere_octant(r,[0 0 1],[ 1  1 -1])
RR_drawsphere_octant(r,[1 0 1],[-1  1 -1])
RR_drawsphere_octant(r,[0 1 1],[ 1 -1 -1])
RR_drawsphere_octant(r,[1 1 1],[-1 -1 -1])
RR_drawsphere_octant(r,[1 1 1],[-1 -1 -1])
RR_drawsphere_half(r,[0 0.5 0.5],1,1)
RR_drawsphere_half(r,[1 0.5 0.5],1,-1)
RR_drawsphere_half(r,[0.5 0 0.5],2,1)
RR_drawsphere_half(r,[0.5 1 0.5],2,-1)
RR_drawsphere_half(r,[0.5 0.5 0],3,1)
RR_drawsphere_half(r,[0.5 0.5 1],3,-1)
RR_drawsphere([0.25 0.25 0.25],1,r,52)
RR_drawsphere([0.75 0.75 0.25],1,r,52)
RR_drawsphere([0.75 0.25 0.75],1,r,52)
RR_drawsphere([0.25 0.75 0.75],1,r,52)
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off

figure(4), clf, hold on, r=1/2; s=sind(60); s2=sind(60)/3; h=sqrt(8/3); N=36
RR_drawsphere1([0   0   0],1,r,N)
RR_drawsphere1([1   0   0],1,r,N)
RR_drawsphere1([0.5 s   0],1,r,N)
RR_drawsphere1([1.5 s   0],1,r,N)
RR_drawsphere1([0   0   h],1,r,N)
RR_drawsphere1([1   0   h],1,r,N)
RR_drawsphere1([0.5 s   h],1,r,N)
RR_drawsphere1([1.5 s   h],1,r,N)
RR_drawsphere1([0.5 0+s2 h/2],1,r,2*N)
RR_drawsphere1([1.5 0+s2 h/2],1,r,2*N)
RR_drawsphere1([1   s+s2 h/2],1,r,2*N)
for i=1:8
  switch i
    case 1, phi=linspace(0,pi/3,7); x=0; y=0; z=0;
    case 2, z=h;
    case 3, phi=linspace(pi/3,pi,14); x=1; y=0; z=0;
    case 4, z=h;
    case 5, phi=linspace(-2*pi/3,0,14); x=0.5; y=s; z=0;
    case 6, z=h;
    case 7, phi=linspace(-pi,-2*pi/3,7); x=1.5; y=s; z=0;
    case 8, z=h;
  end
  fill3([0 r*cos(phi)]+x,[0 r*sin(phi)]+y,[0 0*phi]+z,'g')
end
for i=1:20
  switch i
    case 1,  phi=linspace(-pi/2,0,17);   x=0;    y=0;  z=h; a=1; b=0;
    case 2,  phi=linspace(0,pi/2,17);    x=0;    y=0;  z=0;
    case 3,  phi=linspace(-pi/2,0,17);   x=0.5;  y=s;  z=h;
    case 4,  phi=linspace(0,pi/2,17);    x=0.5;  y=s;  z=0;
    case 5,  phi=linspace(-pi,-pi/2,17); x=1;    y=0;  z=h;
    case 6,  phi=linspace(pi/2,pi,17);   x=1;    y=0;  z=0;
    case 7,  phi=linspace(-pi,-pi/2,17); x=1.5;  y=s;  z=h;
    case 8,  phi=linspace(pi/2,pi,17);   x=1.5;  y=s;  z=0;
    case 9,  phi=linspace(-pi/2,0,17);   x=1;    y=0;  z=h; a=cosd(60); b=sind(60);
    case 10, phi=linspace(0,pi/2,17);    x=1;    y=0;  z=0;
    case 11, phi=linspace(-pi/2,0,17);   x=0;    y=0;  z=h;
    case 12, phi=linspace(0,pi/2,17);    x=0;    y=0;  z=0;
    case 13, phi=linspace(-pi,-pi/2,17); x=1.5;  y=s;  z=h;
    case 14, phi=linspace(pi/2,pi,17);   x=1.5;  y=s;  z=0;
    case 15, phi=linspace(-pi,-pi/2,17); x=0.5;  y=s;  z=h;
    case 16, phi=linspace(pi/2,pi,17);   x=0.5;  y=s;  z=0;
    case 17, phi=linspace(-pi,pi,1024);  x=0.5;  y=0;  z=h/2; a=1; b=0; r=0.41;
    case 18, phi=linspace(-pi,pi,1024);  x=1;    y=s;  z=h/2; 
    case 19, phi=linspace(-pi,pi,1024);  x=1.25; y=s/2; z=h/2; a=cosd(60); b=sind(60);
    case 20, phi=linspace(-pi,pi,1024);  x=0.25; y=s/2; z=h/2;
end
  if i<17
    fill3([0 a*r*cos(phi)]+x,[0 b*r*cos(phi)]+y,[0 r*sin(phi)]+z,'g')
  else 
    fill3(a*r*cos(phi)+x,b*r*cos(phi)+y,r*sin(phi)+z,'g')
  end
end
plot3([1 .5],[0 s],[h h],'k-'); plot3([1 .5],[0 s],[0 0],'k-')
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off

figure(5), clf, hold on, r=1/2; s=sind(60); s2=sind(60)/3; h=sqrt(8/3); N=36
RR_drawsphere2([0   0   0],1,r,N)
RR_drawsphere2([1   0   0],1,r,N)
RR_drawsphere2([-0.5 s  0],1,r,N)
RR_drawsphere2([0.5 s   0],1,r,N)
RR_drawsphere2([1.5 s   0],1,r,N)
RR_drawsphere2([0   2*s 0],1,r,N)
RR_drawsphere2([1   2*s 0],1,r,N)
RR_drawsphere2([0   0   h],1,r,N)
RR_drawsphere2([1   0   h],1,r,N)
RR_drawsphere2([-0.5 s  h],1,r,N)
RR_drawsphere2([0.5 s   h],1,r,N)
RR_drawsphere2([1.5 s   h],1,r,N)
RR_drawsphere2([0   2*s h],1,r,N)
RR_drawsphere2([1   2*s h],1,r,N)
RR_drawsphere2([0.5 0+s2 h/2],1,r,2*N)
RR_drawsphere2([1.5 0+s2 h/2],1,r,2*N)
RR_drawsphere2([1   s+s2 h/2],1,r,2*N)
RR_drawsphere2([0   s+s2 h/2],1,r,2*N)
RR_drawsphere2([-0.5 0+s2 h/2],1,r,2*N)
RR_drawsphere2([0.5  2*s+s2 h/2],1,r,2*N)
for i=1:14
  switch i
    case 1, phi=linspace(0,2*pi/3,14); x=0; y=0; z=0;
    case 2, z=h;
    case 3, phi=linspace(pi/3,pi,14); x=1; y=0; z=0;
    case 4, z=h;
    case 5, phi=linspace(-4*pi/3,-2*pi/3,14); x=1.5; y=s; z=0;
    case 6, z=h;
    case 7, phi=linspace(-2*pi/3,0,14); x=0; y=2*s; z=0;
    case 8, z=h;
    case 9, phi=linspace(-pi,-pi/3,14); x=1; y=2*s; z=0;
    case 10, z=h;
    case 11, phi=linspace(-pi/3,pi/3,14); x=-0.5; y=s; z=0;
    case 12, z=h;
    case 13, phi=linspace(0,2*pi,42); x=0.5; y=s; z=0;
    case 14, z=h;
  end
  if i<13
    fill3([0 r*cos(phi)]+x,[0 r*sin(phi)]+y,[0 0*phi]+z,'g')
  else 
    fill3(r*cos(phi)+x,r*sin(phi)+y,0*phi+z,'g')
  end    
end
for i=1:30
  switch i
    case 1,  phi=linspace(-pi/2,0,17);   x=0;    y=0;   z=h; a=1; b=0;
    case 2,  phi=linspace(0,pi/2,17);    x=0;    y=0;   z=0;
    case 3,  phi=linspace(-pi,-pi/2,17); x=1;    y=2*s; z=h;
    case 4,  phi=linspace(pi/2,pi,17);   x=1;    y=2*s; z=0;
    case 5,  phi=linspace(-pi,-pi/2,17); x=1;    y=0;   z=h;
    case 6,  phi=linspace(pi/2,pi,17);   x=1;    y=0;   z=0;
    case 7,  phi=linspace(-pi/2,0,17);   x=0;    y=2*s; z=h;
    case 8,  phi=linspace(0,pi/2,17);    x=0;    y=2*s; z=0;
    case 9,  phi=linspace(-pi/2,0,17);   x=1;    y=0;   z=h; a=cosd(60); b=sind(60);
    case 10, phi=linspace(0,pi/2,17);    x=1;    y=0;   z=0;
    case 11, phi=linspace(-pi,-pi/2,17); x=1.5;  y=s;   z=h;
    case 12, phi=linspace(pi/2,pi,17);   x=1.5;  y=s;   z=0;
    case 13, phi=linspace(pi/2,pi,17);   x=0;    y=2*s; z=0;
    case 14, phi=linspace(-pi,-pi/2,17); x=0;    y=2*s; z=h;
    case 15, phi=linspace(-pi/2,0,17);   x=-0.5; y=s;   z=h;
    case 16, phi=linspace(0,pi/2,17);    x=-0.5; y=s;   z=0;
    case 17, phi=linspace(-pi/2,0,17);   x=1.5;  y=s;   z=h; a=cosd(120); b=sind(120);
    case 18, phi=linspace(0,pi/2,17);    x=1.5;  y=s;   z=0;
    case 19, phi=linspace(-pi,-pi/2,17); x=1;    y=2*s; z=h;
    case 20, phi=linspace(pi/2,pi,17);   x=1;    y=2*s; z=0;
    case 21, phi=linspace(-pi/2,0,17);   x=0;    y=0;   z=h;
    case 22, phi=linspace(0,pi/2,17);    x=0;    y=0;   z=0;
    case 23, phi=linspace(-pi,-pi/2,17); x=-0.5; y=s;   z=h;
    case 24, phi=linspace(pi/2,pi,17);   x=-0.5; y=s;   z=0;
    case 25, phi=linspace(-pi,pi,1024);  x=0.5;  y=0;   z=h/2; a=1; b=0; r=0.41;
    case 26, phi=linspace(-pi,pi,1024);  x=0.5;  y=2*s; z=h/2; 
    case 27, phi=linspace(-pi,pi,1024);  x=1.25; y=s/2; z=h/2; a=cosd(60); b=sind(60);
    case 28, phi=linspace(-pi,pi,1024);  x=-0.25; y=3*s/2; z=h/2;
    case 29, phi=linspace(-pi,pi,1024);  x=1.25; y=3*s/2; z=h/2; a=cosd(120); b=sind(120);
    case 30, phi=linspace(-pi,pi,1024);  x=-0.25; y=s/2; z=h/2;
end
  if i<25
    fill3([0 a*r*cos(phi)]+x,[0 b*r*cos(phi)]+y,[0 r*sin(phi)]+z,'g')
  else 
    fill3(a*r*cos(phi)+x,b*r*cos(phi)+y,r*sin(phi)+z,'g')
  end
end
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(24,10); axis off

figure(6), clf, hold on, r=1/6; s=sind(60); s2=sind(60)/3; h=sqrt(8/3);
RR_drawsphere([0   0   0],0,r)
RR_drawsphere([1   0   0],0,r)
RR_drawsphere([-0.5 s  0],0,r)
RR_drawsphere([0.5 s   0],0,r)
RR_drawsphere([1.5 s   0],0,r)
RR_drawsphere([0   2*s 0],0,r)
RR_drawsphere([1   2*s 0],0,r)
RR_drawsphere([0   0   h],0,r)
RR_drawsphere([1   0   h],0,r)
RR_drawsphere([-0.5 s  h],0,r)
RR_drawsphere([0.5 s   h],0,r)
RR_drawsphere([1.5 s   h],0,r)
RR_drawsphere([0   2*s h],0,r)
RR_drawsphere([1   2*s h],0,r)
RR_drawsphere([0.5 0+s2 h/2],1,r)
RR_drawsphere([1   s+s2 h/2],1,r)
RR_drawsphere([0   s+s2 h/2],1,r)
fill3([0 1 1 0],[0 0 0 0],[0 0 h h],'g','LineWidth',2)
fill3([1 1 0.5 0.5],[0 0 s s],[0 h h 0],'g','LineWidth',2)
fill3([0.5 0.5 -0.5 -0.5],[s s s s],[h 0 0 h],'g','LineWidth',2)
fill3([-0.5 -0.5 0 0],[s s 0 0],[h 0 0 h],'g','LineWidth',2)
fill3([0 0 0.5 0.5],[0 0 s s],[h 0 0 h],'g','LineWidth',2)
fill3([0 1 0.5 -0.5],[0 0 s s],[h h h h],'g','LineWidth',2)
fill3([0 1 0.5 -0.5],[0 0 s s],[0 0 0 0],'g','LineWidth',2)
xlabel('X'); ylabel('Y'); zlabel('Z'); axis equal; view(123.65,20); axis off
print -depsc unit_cell_HCP_primitive.eps
