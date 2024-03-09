% script StretchMeshTest
% Test <a href="matlab:help StretchMesh">StretchMesh</a> by constructing a few interesting 1D grids.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also PlotMeshTest.

clear; x=[0:.1:1]; n=length(x); a=ones(n,1); off=1.5; xmin=0; xmax=1; close all
yh=0.1*a; y0=a*0; y1=-a*0.1; y2=-a*0.2; yc=-0.3*a; 

xh=   off+StretchMesh(x,'h',xmin,xmax,1.75);
xc=   off+StretchMesh(x,'c',xmin,xmax)
x00=      StretchMesh(x,'p',xmin,xmax,0,0);
x10=  off+StretchMesh(x,'p',xmin,xmax,1,0);
x20=2*off+StretchMesh(x,'p',xmin,xmax,2,0);
x01=      StretchMesh(x,'p',xmin,xmax,0,1);
x11=  off+StretchMesh(x,'p',xmin,xmax,1,1);
x21=2*off+StretchMesh(x,'p',xmin,xmax,2,1);
x02=      StretchMesh(x,'p',xmin,xmax,0,2);
x12=  off+StretchMesh(x,'p',xmin,xmax,1,2);
x22=2*off+StretchMesh(x,'p',xmin,xmax,2,2);
figure(1), plot(xh,yh,'k+',xc,yc,'k+',x00,y0,'k+',x01,y1,'k+',x02,y2,'k+',x10,y0,'k+', ...
     x11,y1,'k+',x12,y2,'k+',x20,y0,'k+',x21,y1,'k+',x22,y2,'k+'); axis off; axis tight

xx=[0:.01:1]; xxh=(xx(1:end-1)+xx(2:end))/2; dx=xx(2:end)-xx(1:end-1)

yh1=StretchMesh(xx,'h',0,1,1.2);  yh1d=(yh1(2:end)-yh1(1:end-1))./dx;
yh2=StretchMesh(xx,'h',0,1,1.75); yh2d=(yh2(2:end)-yh2(1:end-1))./dx;
yh3=StretchMesh(xx,'h',0,1,3);    yh3d=(yh3(2:end)-yh3(1:end-1))./dx;
figure(2), clf; axis tight
[AX,H1,H2] = plotyy(xx,[yh1' yh2' yh3'],xxh,[yh1d' yh2d' yh3d'])     % Note use of plotyy -
set(H1(1),'Color','k'); set(H1(2),'Color','b'); set(H1(3),'Color','r'); % this fn is useful
set(H2(1),'Color','k'); set(H2(2),'Color','b'); set(H2(3),'Color','r'); % when saving space
set(H1,'LineStyle','-'); set(H2,'LineStyle','-.');                      % in an article.
axis on; % print -depsc stretchfn_tanh.eps

yp1=StretchMesh(xx,'p',0,1,0,0);  yp1d=(yp1(2:end)-yp1(1:end-1))./dx;
yp2=StretchMesh(xx,'p',0,1,1,1);  yp2d=(yp2(2:end)-yp2(1:end-1))./dx;
yp3=StretchMesh(xx,'p',0,1,2,2);  yp3d=(yp3(2:end)-yp3(1:end-1))./dx;
figure(3), clf; axis tight
[AX,H1,H2] = plotyy(xx,[yp1' yp2' yp3'],xxh,[yp1d' yp2d' yp3d'])
set(H1(1),'Color','k'); set(H1(2),'Color','b'); set(H1(3),'Color','r'); 
set(H2(1),'Color','k'); set(H2(2),'Color','b'); set(H2(3),'Color','r'); 
set(H1,'LineStyle','-'); set(H2,'LineStyle','-.'); 
axis on; % print -depsc stretchfn_poly.eps

yc1=StretchMesh(xx,'c',0,1);  yc1d=(yc1(2:end)-yc1(1:end-1))./dx;
figure(4), clf; axis tight
[AX,H1,H2] = plotyy(xx,yc1,xxh,yc1d)
set(H1(1),'Color','k');
set(H2(1),'Color','k');
set(H1,'LineStyle','-'); set(H2,'LineStyle','-.'); 
axis on; % print -depsc stretchfn_cos.eps

% end script StretchMeshTest