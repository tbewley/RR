
figure(1); clf; clear; d=[0 3 6 9]; e=[0 -3.5 -7 -10.5]; f=[0 3 6 9];
drawsphere([0,3,0],0); hold on; drawsphere([1+d(2),2+e(2),1+f(2)],1); drawsphere([2+d(3),1+e(3),2+f(3)],1); drawsphere([3+d(4),0+e(4),3+f(4)],1);
X=[ 0 0 0 1 1 1 1 1 0 0 0 0; 0 0 1 1 1 0 1 1 0 0 1 1]; 
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0; 0 1 0 1 0 1 1 0 1 1 1 0]; 
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1; 1 0 0 0 1 1 0 1 1 1 0 1]; 
XS=[X X X X X X X X X 1+X 1+X 1+X 1+X 1+X 1+X 1+X 1+X 1+X 2+X 2+X 2+X 2+X 2+X 2+X 2+X 2+X 2+X];
YS=[Y Y Y 1+Y 1+Y 1+Y 2+Y 2+Y 2+Y Y Y Y 1+Y 1+Y 1+Y 2+Y 2+Y 2+Y Y Y Y 1+Y 1+Y 1+Y 2+Y 2+Y 2+Y];
ZS=[Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z Z 1+Z 2+Z];
X=[0 3; 0+d(4) 3+d(4) ]; Y=[0 3; 0+e(4) 3+e(4) ]; Z=[0 3; 0+f(4) 3+f(4) ];
h=line(X,Y,Z); set(h,'LineWidth',3); set(h,'Color',[0 0 1]);
for i=1:4
  h=line(XS+d(i),YS+e(i),ZS+f(i)); set(h,'LineWidth',3); set(h,'Color',[0 1 0]);
end
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 6344code.eps; print -dpng 6344code.png; pause



figure(1); clf; clear; d=[0 2 4]; e=[0 -2.5 -5]; f=[0 2 4];
drawsphere([0,2,0],0); hold on; drawsphere([1,1,1],1); drawsphere([2,0,2],1); drawsphere([2,1,0],1); drawsphere([1,0,0],1);
drawsphere([0,0,1],1); drawsphere([0,1,2],1);  drawsphere([2,2,1],1); drawsphere([1,2,2],1); 
drawsphere([0+d(2),0+e(2),0+f(2)],1); drawsphere([2+d(2),2+e(2),0+f(2)],1); drawsphere([0+d(2),2+e(2),2+f(2)],1);
drawsphere([1+d(2),1+e(2),0+f(2)],1); drawsphere([0+d(2),1+e(2),1+f(2)],1); drawsphere([1+d(2),2+e(2),1+f(2)],1);
drawsphere([1+d(2),0+e(2),2+f(2)],1); drawsphere([2+d(2),1+e(2),2+f(2)],1); drawsphere([2+d(2),0+e(2),1+f(2)],1); 
drawsphere([2+d(3),2+e(3),2+f(3)],1); drawsphere([0+d(3),0+e(3),2+f(3)],1); drawsphere([2+d(3),0+e(3),0+f(3)],1);
drawsphere([1+d(3),1+e(3),2+f(3)],1); drawsphere([2+d(3),1+e(3),1+f(3)],1); drawsphere([1+d(3),0+e(3),1+f(3)],1);
drawsphere([1+d(3),2+e(3),0+f(3)],1); drawsphere([0+d(3),1+e(3),0+f(3)],1); drawsphere([0+d(3),2+e(3),1+f(3)],1); 
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 1+X 1+X 1+X 1+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 1+Y 1+Y Y Y 1+Y 1+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 1+Z Z 1+Z Z 1+Z Z 1+Z];
X=[0 2; 0+d(3) 2+d(3) ]; Y=[0 2; 0+e(3) 2+e(3) ]; Z=[0 2; 0+f(3) 2+f(3) ];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 0 1]);
for i=1:3
  h=line(XS+d(i),YS+e(i),ZS+f(i)); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
end
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 4323code.eps; print -dpng 4323code.png; pause

figure(1); clf; clear; d=[0 2 4]; e=[0 -2.5 -5]; f=[0 2 4];
drawsphere([0,2,0],0); hold on; drawsphere([1+d(2),1+e(2),1+f(2)],1); drawsphere([2+d(3),0+e(3),2+f(3)],1);
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 1+X 1+X 1+X 1+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 1+Y 1+Y Y Y 1+Y 1+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 1+Z Z 1+Z Z 1+Z Z 1+Z];
X=[0 2; 0+d(3) 2+d(3) ]; Y=[0 2; 0+e(3) 2+e(3) ]; Z=[0 2; 0+f(3) 2+f(3) ];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 0 1]);
for i=1:3
  h=line(XS+d(i),YS+e(i),ZS+f(i)); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
end
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 4143code.eps; print -dpng 4143code.png; pause

figure(1); clf; clear; d=[0 2 4]; e=[0 -2.5 -5]; f=[0 2 4];
drawsphere([0,2,0],0); hold on; drawsphere([1,1,1],1); drawsphere([2,0,2],1);
drawsphere([1+d(2),2+e(2),2+f(2)],1); drawsphere([2+d(2),1+e(2),0+f(2)],1); drawsphere([0+d(2),0+e(2),1+f(2)],1);
drawsphere([2+d(3),2+e(3),1+f(3)],1); drawsphere([0+d(3),1+e(3),2+f(3)],1); drawsphere([1+d(3),0+e(3),0+f(3)],1);
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 1+X 1+X 1+X 1+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 1+Y 1+Y Y Y 1+Y 1+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 1+Z Z 1+Z Z 1+Z Z 1+Z];
X=[0 2; 0+d(3) 2+d(3) ]; Y=[0 2; 0+e(3) 2+e(3) ]; Z=[0 2; 0+f(3) 2+f(3) ];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 0 1]);
for i=1:3
  h=line(XS+d(i),YS+e(i),ZS+f(i)); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
end
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 4233code.eps; print -dpng 4233code.png;  pause






figure(1); clf; clear;
drawsphere([0,1,0],0); hold on; drawsphere([0,0,1],1); drawsphere([1,0,0],1); drawsphere([1,1,1],1);
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 322code.eps; pause;

figure(1); clf; clear;
a=-0.5; b=0.5; A=-0.9; B=0.9;
drawsphere([A,B,A],0); hold on; drawsphere([A,A,B],1); drawsphere([B,A,A],1); drawsphere([B,B,B],1) 
drawsphere([b,a,b],1); hold on; drawsphere([b,b,a],1); drawsphere([a,b,b],1); drawsphere([a,a,a],1) 
X=[ a a a b b b b b a a a a A A A B B B B B A A A A a a a a b b b b;  
    a a b b b a b b a a b b A A B B B A B B A A B B A A A A B B B B];
Y=[ a a a b b b a a b a b a A A A B B B A A B A B A a a b b a a b b;
    a b a b a b b a b b b a A B A B A B B A B B B A A A B B A A B B];
Z=[ a a a b b b a a a b a b A A A B B B A A A B A B a b a b a b a b;
    b a a a b b a b b b a b B A A A B B A B B B A B A B A B A B A B];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 432code.eps; pause;

figure(1); clf; clear;
drawsphere([0,1,0],0)
hold on;
drawsphere([1,0,1],1) 
axis equal
view(-57,22);  shading interp;  
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 313code.eps; pause;

figure(1); clf; clear;
a=-0.5; b=0.5; A=-0.9; B=0.9;
drawsphere([A,B,A],0); hold on; drawsphere([b,a,b],1); 
X=[ a a a b b b b b a a a a A A A B B B B B A A A A a a a a b b b b;  
    a a b b b a b b a a b b A A B B B A B B A A B B A A A A B B B B];
Y=[ a a a b b b a a b a b a A A A B B B A A B A B A a a b b a a b b;
    a b a b a b b a b b b a A B A B A B B A B B B A A A B B A A B B];
Z=[ a a a b b b a a a b a b A A A B B B A A A B A B a b a b a b a b;
    b a a a b b a b b b a b B A A A B B A B B B A B A B A B A B A B];
h=line(X,Y,Z); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 414code.eps; pause;

figure(1); clf; clear;
drawsphere([0,2,0],0); hold on; drawsphere([1,1,1],1); drawsphere([2,0,2],1); drawsphere([2,1,0],1); drawsphere([1,0,0],1);
drawsphere([0,0,1],1); drawsphere([0,1,2],1);  drawsphere([2,2,1],1); drawsphere([1,2,2],1); 
axis equal
view(-75,10);  shading interp;  
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 1+X 1+X 1+X 1+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 1+Y 1+Y Y Y 1+Y 1+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 1+Z Z 1+Z Z 1+Z Z 1+Z];
h=line(XS,YS,ZS); set(h,'LineWidth',5); set(h,'Color',[0 1 0]);
hold off; axis equal; axis off; view(-104,10); shading interp; camlight('right','infinite');
print -depsc2 3223code.eps;





break

figure(1); clf; clear;   s=sqrt(3)/2;
drawcircle1([0, 0, 0],1,0.5); hold on;
drawcircle1([1, 0, 0],1,0.5);
drawcircle1([2, 0, 0],1,0.5);
drawcircle1([-1, 0, 0],1,0.5);
drawcircle1([-2, 0, 0],1,0.5);
drawcircle1([-1.5, s, 0],1,0.5); drawcircle1([-1.5, -s, 0],1,0.5); 
drawcircle1([-0.5, s, 0],1,0.5); drawcircle1([-0.5, -s, 0],1,0.5); 
drawcircle1([0.5, s, 0],1,0.5);  drawcircle1([0.5, -s, 0],1,0.5);   
drawcircle1([1.5, s, 0],1,0.5);  drawcircle1([1.5, -s, 0],1,0.5);  
X=[-2.75 -2.25 -2.25  -2.375  -1.875  -0.875   0.125    -2.325  -1.825   -0.875    0.125   1.125  ;  
	2.75  2.25  2.25  -1.125  -0.125   0.875   1.875    -1.125  -0.125    0.875    1.875   2.375  ];
Y=[  0     s    -s    -.75*s -1.75*s -1.75*s -1.75*s    0.75*s  1.75*s   1.75*s   1.75*s  1.75*s  ;
	 0     s    -s    1.75*s  1.75*s  1.75*s  1.75*s   -1.75*s -1.75*s  -1.75*s  -1.75*s  -.75*s  ];
h=line(X,Y);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[0.5; 0; -0.5; -0.5;  0; 0.5; 0.5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[  t; r;    t;   -t; -r;  -t;   t];
h1=line(X,Y);
set(h1,'LineWidth',2,'LineStyle','--'); 
set(h,'Color',[0 0 0]);
print -depsc2 tripack.eps;

figure(1); clf; clear;   s=sqrt(3)/2;
drawcircle1([0, 0, 0],1,0.5); hold on;
drawcircle1([1, 0, 0],1,0.5);
drawcircle1([-1, 0, 0],1,0.5);
drawcircle1([-1, 1, 0],1,0.5); drawcircle1([-1, -1, 0],1,0.5); 
drawcircle1([ 0, 1, 0],1,0.5); drawcircle1([ 0, -1, 0],1,0.5); 
drawcircle1([ 1, 1, 0],1,0.5); drawcircle1([ 1, -1, 0],1,0.5);  
X=[-1.75 -1.75 -1.75 -1 0 1;  
    1.75  1.75  1.75 -1 0 1];
Y=[ 0  1 -1 -1.75 -1.75 -1.75;
    0  1 -1  1.75  1.75  1.75];
Z=[ 2  2  2 2 2 2;
    2  2  2 2 2 2];
h=line(X,Y,Z);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[ .5 -.5  -.5  .5 .5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[ .5  .5  -.5 -.5 .5];
Z=[ 2   2   2   2    2];
h1=line(X,Y,Z);
set(h1,'LineWidth',2,'LineStyle','--'); 
set(h,'Color',[0 0 0]);
print -depsc2 squarepack.eps;

figure(1); clf; clear;   s=sqrt(3)/2;
drawcircle1([0, 0, 0],1,0.5); hold on;
drawcircle1([1, 0, 0],1,0.5);
drawcircle1([-2, 0, 0],1,0.5);
drawcircle1([-1.5, s, 0],1,0.5); drawcircle1([-1.5, -s, 0],1,0.5); 
drawcircle1([-0.5, s, 0],1,0.5); drawcircle1([-0.5, -s, 0],1,0.5); 
drawcircle1([1.5, s, 0],1,0.5);  drawcircle1([ 1.5, -s, 0],1,0.5);  
X=[-2.75 -0   -1.5   1.5  -1.5  1.5   -2   -1.875    -0.5     -0.5    1    1.125   -2    -1.825    -0.5    -0.5     1    1.125  ;  
	-2    1    -.5   2.25  -.5  2.25 -1.5   -1.5    -0.125     0     1.5    1.5    -1.5   -1.5    -0.125     0       1.5    1.5   ];
Y=[  0    0     s     s    -s   -s     0   -1.75*s     s      -s      0   -1.75*s   0     1.75*s    -s    s     0    1.75*s ;
	 0    0     s     s    -s   -s     s      -s     1.75*s    0      s     -s     -s       s     -1.75*s     0       -s       s   ];
Z=[  2    2     2     2     2    2     2       2        2      2      2      2      2       2        2        2        2       2   ;
	 2    2     2     2     2    2     2       2        2      2      2      2      2       2        2        2        2       2   ];
h=line(X,Y,Z);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[0.5 -1  0.5 0.5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[ s   0  -s   s ];
Z=[ 2   2   2   2 ];
h1=line(X,Y,Z);
set(h1,'LineWidth',2,'LineStyle','--'); 
set(h,'Color',[0 0 0]);
print -depsc2 hexpack.eps;

figure(1); clf; clear;   s=sqrt(3)/2; r=1/sqrt(3)
drawcircle([0, 0, 0],r,2); hold on;
drawcircle([1, 0, 0],r,2);
drawcircle([2, 0, 0],r,2);
drawcircle([-1, 0, 0],r,2);
drawcircle([-2, 0, 0],r,2);
drawcircle([-1.5, s, 0],r,2); drawcircle([-1.5, -s, 0],r,2); 
drawcircle([-0.5, s, 0],r,2); drawcircle([-0.5, -s, 0],r,2); 
drawcircle([0.5, s, 0],r,2);  drawcircle([0.5, -s, 0],r,2);   
drawcircle([1.5, s, 0],r,2);  drawcircle([1.5, -s, 0],r,2);  
X=[-2.75 -2.25 -2.25  -2.375  -1.875  -0.875   0.125    -2.325  -1.825   -0.875    0.125   1.125  ;  
	2.75  2.25  2.25  -1.125  -0.125   0.875   1.875    -1.125  -0.125    0.875    1.875   2.375  ];
Y=[  0     s    -s    -.75*s -1.75*s -1.75*s -1.75*s    0.75*s  1.75*s   1.75*s   1.75*s  1.75*s  ;
	 0     s    -s    1.75*s  1.75*s  1.75*s  1.75*s   -1.75*s -1.75*s  -1.75*s  -1.75*s  -.75*s  ];
Z=[  2     2     2       2       2       2       2        2       2        2        2       2     ;
	 2     2     2       2       2       2       2        2       2        2        2       2     ];
h=line(X,Y,Z);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[0.5; 0; -0.5; -0.5;  0; 0.5; 0.5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[  t; r;    t;   -t; -r;  -t;   t];
Z=[  2; 2;    2;    2;  2;   2;   2];
h1=line(X,Y,Z);
set(h1,'LineWidth',1.5,'LineStyle','--'); 
set(h,'Color',[0 0 0]);
print -depsc2 tricover.eps;

figure(1); clf; clear;   s=sqrt(3)/2; r=1/sqrt(2);
drawcircle([0, 0, 0],r,2); hold on;
drawcircle([1, 0, 0],r,2);
drawcircle([-1, 0, 0],r,2);
drawcircle([-1, 1, 0],r,2); drawcircle([-1, -1, 0],r,2); 
drawcircle([ 0, 1, 0],r,2); drawcircle([ 0, -1, 0],r,2); 
drawcircle([ 1, 1, 0],r,2); drawcircle([ 1, -1, 0],r,2);  
X=[-1.75 -1.75 -1.75 -1 0 1;  
    1.75  1.75  1.75 -1 0 1];
Y=[ 0  1 -1 -1.75 -1.75 -1.75;
    0  1 -1  1.75  1.75  1.75];
Z=[ 2  2  2 2 2 2;
    2  2  2 2 2 2];
h=line(X,Y,Z);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[ .5 -.5  -.5  .5 .5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[ .5  .5  -.5 -.5 .5];
Z=[ 2   2   2   2    2];
h1=line(X,Y,Z);
set(h1,'LineWidth',2,'LineStyle','--'); 
set(h,'Color',[0 0 0]);
print -depsc2 squarecover.eps;

figure(1); clf; clear;   s=sqrt(3)/2;  r=1;
drawcircle([0, 0, 0],r,2); hold on;
drawcircle([1, 0, 0],r,2);
drawcircle([-2, 0, 0],r,2);
drawcircle([-1.5, s, 0],r,2); drawcircle([-1.5, -s, 0],r,2); 
drawcircle([-0.5, s, 0],r,2); drawcircle([-0.5, -s, 0],r,2); 
drawcircle([1.5, s, 0],r,2);  drawcircle([ 1.5, -s, 0],r,2);  
X=[-2.75 -0   -1.5   1.5  -1.5  1.5   -2   -1.875    -0.5     -0.5    1    1.125   -2    -1.825    -0.5    -0.5     1    1.125  ;  
	-2    1    -.5   2.25  -.5  2.25 -1.5   -1.5    -0.125     0     1.5    1.5    -1.5   -1.5    -0.125     0       1.5    1.5   ];
Y=[  0    0     s     s    -s   -s     0   -1.75*s     s      -s      0   -1.75*s   0     1.75*s    -s    s     0    1.75*s ;
	 0    0     s     s    -s   -s     s      -s     1.75*s    0      s     -s     -s       s     -1.75*s     0       -s       s   ];
Z=[  2    2     2     2     2    2     2       2        2      2      2      2      2       2        2        2        2       2   ;
	 2    2     2     2     2    2     2       2        2      2      2      2      2       2        2        2        2       2   ];
h=line(X,Y,Z);
set(h,'LineWidth',2); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 .6]); view(0,90);  shading interp;  axis equal; axis off; 
X=[0.5 -1  0.5 0.5]; t=0.5*tan(pi/6); r=sqrt(t^2+0.5^2);
Y=[ s   0  -s   s ];
Z=[ 2   2   2   2 ];
h1=line(X,Y,Z);
set(h1,'LineWidth',2,'LineStyle','--'); 
set(h,'Color',[0 0 0]); axis([-2.75 2.25 -1.5 1.5])
print -depsc2 hexcover.eps;

pause;



figure(1); clf; clear;   s=sqrt(3)/2; r=1/sqrt(3); w=3;
drawcircle([0, 0, 0],r,w); hold on;
drawcircle([0.5, s, 0],r,w)
drawcircle([1, 0, 0],r,w)
X=[-0.75 -0.375 1.375;  
	 1.75  0.875 0.125];
Y=[  0    -.75*s -.75*s;
	  0    1.75*s 1.75*s];
Z=[  2 2 2;
	  2 2 2];
h=line(X,Y,Z);
set(h,'LineWidth',5); hold off; % camlight('right','infinite');
set(h,'Color',[0 0 0]); view(0,90);  shading interp;  axis equal; axis off; 



figure(1); clf; clear;
drawsphere([0,1,0],0); hold on; drawsphere([0,0,1],1); drawsphere([1,0,0],1); drawsphere([1,1,1],0) 
drawsphere([0,1,2],0); drawsphere([0,0,3],1); drawsphere([1,0,2],1); drawsphere([1,1,3],1) 
drawsphere([0,3,0],0); drawsphere([0,2,1],0); drawsphere([1,2,0],0); drawsphere([1,3,1],0) 
drawsphere([2,1,0],0); drawsphere([2,0,1],1); drawsphere([3,0,0],1); drawsphere([3,1,1],1) 
drawsphere([2,3,2],0); drawsphere([2,2,3],1); drawsphere([3,2,2],1); drawsphere([3,3,3],1) 
drawsphere([0,3,2],0); drawsphere([0,2,3],1); drawsphere([1,2,2],0); drawsphere([1,3,3],1) 
drawsphere([2,3,0],0); drawsphere([2,2,1],0); drawsphere([3,2,0],1); drawsphere([3,3,1],1) 
drawsphere([2,1,2],0); drawsphere([2,0,3],1); drawsphere([3,0,2],1); drawsphere([3,1,3],1) 
axis equal
view(-75,10);  shading interp;  
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 2+X 2+X 2+X 2+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 2+Y 2+Y Y Y 2+Y 2+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 2+Z Z 2+Z Z 2+Z Z 2+Z];
h=line(XS,YS,ZS);
set(h,'LineWidth',3); hold off;
set(h,'Color',[0 1 0]);
camlight('right','infinite');
axis off; % view(38,22);
print -depsc2 322codefull.eps; break; pause;


figure(1); clf; clear;
drawsphere([0,1,0],0); hold on; drawsphere([1,0,1],1) 
drawsphere([0,1,2],0); drawsphere([1,0,3],1) 
drawsphere([0,3,0],0); drawsphere([1,2,1],0) 
drawsphere([2,1,0],0); drawsphere([3,0,1],1) 
drawsphere([2,3,2],0); drawsphere([3,2,3],1) 
drawsphere([0,3,2],0); drawsphere([1,2,3],1) 
drawsphere([2,3,0],0); drawsphere([3,2,1],1) 
drawsphere([2,1,2],0); drawsphere([3,0,3],1) 
axis equal
view(-75,10);  shading interp;  
X=[ 0 0 0 1 1 1 1 1 0 0 0 0;  
    0 0 1 1 1 0 1 1 0 0 1 1]; XS=[X X X X 2+X 2+X 2+X 2+X];
Y=[ 0 0 0 1 1 1 0 0 1 0 1 0;
    0 1 0 1 0 1 1 0 1 1 1 0]; YS=[Y Y 2+Y 2+Y Y Y 2+Y 2+Y];
Z=[ 0 0 0 1 1 1 0 0 0 1 0 1;
    1 0 0 0 1 1 0 1 1 1 0 1]; ZS=[Z 2+Z Z 2+Z Z 2+Z Z 2+Z];
h=line(XS,YS,ZS);
set(h,'LineWidth',3); hold off;
set(h,'Color',[0 1 0]);
camlight('right','infinite');
axis off; % view(38,22);
print -depsc2 313codefull.eps; pause;

figure(1); clf; clear;
drawsphere([0,0,0],-1)
hold on;
drawsphere([0.5,0.5,0],0)
drawsphere([0.5,-0.5,0],0)
drawsphere([-0.5,0.5,0],0)
drawsphere([-0.5,-0.5,0],0)
drawsphere([0.5,0,0.5],1) 
drawsphere([0.5,0,-0.5],0) 
drawsphere([-0.5,0,0.5],1) 
drawsphere([-0.5,0,-0.5],0) 
drawsphere([0,0.5,0.5],0) 
drawsphere([0,0.5,-0.5],1) 
drawsphere([0,-0.5,0.5],0) 
drawsphere([0,-0.5,-0.5],1) 
axis equal
view(-58,26);  shading interp; 
X=[0 0 0 0;;  
   0.5 -0.5 0 0];
Y=[0 0 0 0;
   0 0 0.5 -0.5];
Z=[0 0 0 0;
   0.5 0.5 -0.5 -0.5];
h=line(X,Y,Z);
set(h,'LineWidth',5);
set(h,'Color',[0 0 0]);
X=[-0.5 -0.5 -0.5 -0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5;  
	0.5 0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 0.5 0.5];
Y=[-0.5 -0.5 0.5 0.5 -0.5 -0.5 -0.5 -0.5 -0.5 0.5 0.5 -0.5;
	-0.5 -0.5 0.5 0.5 0.5 0.5 0.5 0.5 -0.5 0.5 0.5 -0.5];
Z=[-0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 -0.5 -0.5 -0.5 -0.5;
	-0.5 0.5 0.5 -0.5 -0.5 0.5 0.5 -0.5 0.5 0.5 0.5 0.5];
h=line(X,Y,Z);
set(h,'LineWidth',5); hold off; camlight('right','infinite');
set(h,'Color',[0 1 0]); 
axis off; view(38,22);
print -depsc2 posbasefcc.eps; pause;

figure(1); clf; clear; s=sqrt(3)/2;  s1=3*s/2; d=.5; l=-0.5-d;  r=4.5+d; f=.6
drawsphere(f*[0, 0, 0],1); hold on;
drawsphere(f*[1, 0,     0],-1) 
drawsphere(f*[2, 0,     0], 0) 
drawsphere(f*[ 0.5, -s, 0],0)
drawsphere(f*[ 1.5, -s, 0],1)
drawsphere(f*[ 0.5,  s, 0],0)
drawsphere(f*[ 1.5,  s, 0],1)
X=f*[ l l l 1   -.75  .25 1.5  1.25  1.75   -.75  .25  1.25;  
	  3 3 0 3    .75   1  1.75 2.75  1.5     .75   1  2.75];
Y=f*[-s s 0 0   -s1   -s1  s    -s1  -s1     s1   s1    s1 ;
     -s s 0 0    s1    0   s1    s1  -s     -s1    0  -s1 ];
Z=f*[ 0 0 0 0    0     0   0     0    0      0     0    0   ;
	  0 0 0 0    0     0   0     0    0      0     0   0   ];
h=line(X,Y,Z);
set(h,'LineWidth',4); hold off; camlight('right','infinite');
set(h,'Color',[0 1 0]); view(0,90);  shading interp;  axis equal; axis off; 
X=f*[0  1   1 ;  
	 1 1.5 1.5 ];
Y=f*[0  0   0 ;
	 0  s  -s ];
Z=f*[0  0   0  ;
	 0  0   0 ];
h1=line(X,Y,Z);
set(h1,'LineWidth',8);
set(h1,'Color',[0 0 0]);
print -depsc2 posbasetri.eps; pause;

figure(1); clf; clear;
drawsphere([0,0,0],1)
hold on;
drawsphere([0,0,1],0) 
drawsphere([0,1,0],0) 
drawsphere([0,1,1],1) 
drawsphere([1,0,0],0) 
drawsphere([1,0,1],1) 
drawsphere([1,1,0],1) 
drawsphere([1,1,1],0) 
drawsphere([0.5,0.5,0.5],-1) 
axis equal
view(-57,22);  shading interp;  
X=[ 0.5 0.5 0.5  0.5;  
    0   0   1    1  ];
Y=[ 0.5 0.5 0.5  0.5;
    0   1   0    1  ];
Z=[ 0.5 0.5 0.5  0.5;
    1   0   0    1  ];
h=line(X,Y,Z);
set(h,'LineWidth',5); hold off;
set(h,'Color',[0 1 0]);
X=[0.5 0.5 0.5 0.5 ;  
   0   0   1   1   ];
Y=[0.5 0.5 0.5 0.5 ;
   0   1   0   1   ];
Z=[0.5 0.5 0.5 0.5 ;
   0   1   1   0   ];
h=line(X,Y,Z);
set(h,'LineWidth',5); hold off; camlight('right','infinite');
set(h,'Color',[0 0 0]); axis off; view
print -depsc2 posbasebcc.eps; pause;
