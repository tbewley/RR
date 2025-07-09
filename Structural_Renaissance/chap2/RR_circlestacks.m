% script RR_circlestacks
% draws some depictions of FCC and HCP

clear all; clc, figure(1); clf
c=sqrt(3)/2; d=tand(30)/2;
x=[0 1 2 3 4 5 6 7 8 9 0.5 1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 ...
   1 2 3 4 5 6 7 8 1.5 2.5 3.5 4.5 5.5 6.5 7.5 ...
   2 3 4 5 6 7];
y=c*[zeros(1,10) ones(1,9) 2*ones(1,8) 3*ones(1,7) 4*ones(1,6)];
for i=1:length(y); RR_drawcircle([x(i) y(i)],1,1,[1 .7 .7]); hold on; end 

x=[0.5 1.5 2.5 3.5 1 2 3 1.5 2.5 2];
y=c*[0 0 0 0 1 1 1 2 2 3]+d;
for i=1:length(y); RR_drawcircle([x(i) y(i)],1,1,[.7 .7 1]); end 

x=x+5;
for i=1:length(y); RR_drawcircle([x(i) y(i)],1,1,[.7 .7 1]); end 

x=[1.5 2.5 2];
y=c*[1 1 2];
for i=1:length(y); RR_drawcircle([x(i) y(i)],1,1,[1 .7 .7]); hold on; end 

x=[1 2 3 1.5 2.5 2]+5; y=c*[1 1 1 2 2 3]-d;
for i=1:length(y); RR_drawcircle([x(i) y(i)],1,1,[1 1 1]); hold on; end 

axis equal; axis off; view(0.5,90);

text(3.9,c*4,'A'),
text(1.9,c*3+d,'B'), text(1.4,c*1,'A'),  
text(6.9,c*3+d+.15,'B'), text(5.9,c*1-d,'C'),  

print -dpdf circlestacks.pdf;