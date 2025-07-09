
brightsummer=brighten(summer,0.35)
% planets1
pts=[1 1 0; 1 2 0; 2 1 0; 2 2 0; 1.5 .5 .5; .5 1.5 .5; 2.5 1.5 .5; 1.5 2.5 .5;
	 1 1 1; 2 1 1; 1 2 1; 2 2 1;]; pts(:,3)=pts(:,3)*sqrt(2)
figure(2); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([1.5 1.5 .5*sqrt(2)],1);
axis equal; axis off; hold off; view(-77,10); colormap(brightsummer), pause
% print -dpdf 'planets1.pdf'

s=sind(60); y=tand(30)*.5; h= sqrt(6)*2/3/2;
pts=[1 0 0; 2 0 0; 0.5 s 0; 2.5 s 0; 1 2*s 0; 2 2*s 0; 1 s+y h; 2 s+y h; 1.5 y h; 1 s-y -h; 2 s-y -h; 1.5 2*s-y -h]; 
figure(3); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([1.5 s 0],1);
axis equal; axis off; hold off; view(-77,18); colormap(brightsummer), pause
% print -dpdf 'planets2.pdf'

% planets3
a= 2/(1+sqrt(5));
pts=1/sqrt(a^2+1)*[0 a 1; 0 a -1; 0 -a 1; 0 -a -1; 1 0 a; 1 0 -a; -1 0 a; -1 0 -a; a 1 0; a -1 0; -a 1 0; -a -1 0];
figure(4); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([0,0,0],1);
axis equal; axis off; hold off; view(-131,14); colormap(brightsummer), pause
% print -dpdf 'planets3.pdf'

% square base
pts=[0 0 0; 0 1 0; 0 2 0; 0 3 0;
     1 0 0; 1 1 0; 1 2 0; 1 3 0;
     2 0 0; 2 1 0; 2 2 0; 2 3 0;
     3 0 0; 3 2 0; 3 3 0;
     .5 .5 .5; 1.5 .5 .5; 2.5 .5 .5;
     .5 1.5 .5; 1.5 1.5 .5; 2.5 1.5 .5;
     .5 2.5 .5; 1.5 2.5 .5; 2.5 2.5 .5;
	1 1 1; 2 1 1; 1 2 1; 2 2 1; 1.5 1.5 1.5]; pts(:,3)=pts(:,3)*sqrt(2);
figure(5); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([3 1 0],1);
axis equal; axis off; hold off; view(-77,18); colormap(brightsummer), pause
% print -dpdf 'stack_square.pdf'

% oblong base
pts=[0 0 0; 0 1 0; 0 2 0; 0 3 0; 0 4 0;
     1 0 0; 1 1 0; 1 2 0; 1 3 0; 1 4 0;
     2 0 0; 2 1 0; 2 2 0; 2 3 0; 2 4 0;
     3 0 0; 3 2 0; 3 3 0; 3 4 0;
     .5 .5 .5; 1.5 .5 .5; 2.5 .5 .5;
     .5 1.5 .5; 1.5 1.5 .5; 2.5 1.5 .5;
     .5 2.5 .5; 1.5 2.5 .5; 2.5 2.5 .5;
     .5 3.5 .5; 1.5 3.5 .5; 2.5 3.5 .5;
     2 3 1; 1 3 1; 1 2 1; 2 2 1; 2 1 1; 1 1 1;
     1.5 2.5 1.5; 1.5 1.5 1.5]; pts(:,3)=pts(:,3)*sqrt(2);
figure(6); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([3 1 0],1);
axis equal; axis off; hold off; view(-77,18); colormap(brightsummer); pause
% print -dpdf 'stack_oblong.pdf'

% triangular base
s=sind(60); y=tand(30)*.5; h= sqrt(6)*2/3/2;
pts=[0 0 0; 1 0 0; 2 0 0; 3 0 0;
     0.5 s 0; 1.5 s 0; 1 2*s 0; 2 2*s 0; 1.5 3*s 0; 1 s+y h; 2 s+y h; 1.5 2*s+y h;
     .5  y h; 1.5 y h; 2.5 y h; 1 s-y 2*h; 2 s-y 2*h; 1.5 2*s-y 2*h; 1.5 s 3*h];
figure(7); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end; RR_drawsphere([2.5 s 0],1); 
axis equal; axis off; hold off; view(-77,18); colormap(summer); pause
% print -dpdf 'stack_triangular.pdf'

clf; pts=[1 s+y h; 1.5 2*s+y h;
     .5  y h; 1.5 y h; 2.5 y h; 1 s-y 2*h; 2 s-y 2*h; 1.5 2*s-y 2*h; 1.5 s 3*h];
figure(8); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end;
axis equal; axis off; hold off; view(-77,18); colormap(summer), pause
% print -dpdf 'stack_triangular3.pdf'

clf; pts=[1 s-y 2*h; 2 s-y 2*h; 1.5 2*s-y 2*h; 1.5 s 3*h];
figure(9); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end
axis equal; axis off; hold off; view(-77,18), colormap(summer), pause
% print -dpdf 'stack_triangular2.pdf'

clf; pts=[1.5 s 3*h]
figure(10); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0); hold on; end
axis equal; axis off; hold off; view(-77,18); colormap(summer), pause
% print -dpdf 'stack_triangular1.pdf'

% pythag
ya=[0 0 0 0 1 1 1 2 2 3]; xa=[0 1 2 3 0 1 2 0 1 0];
yb=[0 1 1 2 2 2 3 3 3 3]; xb=[4 3 4 2 3 4 1 2 3 4];
figure(11); clf;  for i=1:size(ya,2); RR_drawsphere(1.0*[xa(i) ya(i) 0],0); hold on; end;
for i=1:size(yb,2); RR_drawsphere(1.0*[xb(i) yb(i) 0],1);  hold on; end, pause
axis equal; axis off; view(0.5,90); colormap(brightsummer)
% print -dpdf oblong.pdf

% FCC cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0; 0.5 0 0.5; 0.5 1 0.5; 0 0.5 0.5; 1 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1; 0.5 0.5 1];
pts=pts*sqrt(2);
figure(12); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0,0.5); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(brightsummer)
print -dpdf 'fcc.pdf'
pt=[0 1 0.5]*sqrt(2); hold on; RR_drawsphere(pt,0,0.208,50), pause
% print -dpdf -vector 'fcc_plus_carbon.pdf'

% BCC cube
pts=[0 0 0; 0 1 0; 1 0 0; 1 1 0; 0.5 0.5 0.5; 0 0 1; 0 1 1; 1 0 1; 1 1 1];
pts=pts*2/sqrt(3);
figure(13); clf; for i=1:size(pts,1); RR_drawsphere(pts(i,:),0,0.5); hold on; end
axis equal; axis off; hold off; view(-160,13); colormap(brightsummer)
% print -dpdf -vector 'bcc.pdf'

