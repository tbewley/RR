% script RR_spiral
% Makes a polygon that successively shifts along its own edges, and spirals in.
% Code written by Thomas Bewley, with inspiration from Nadia Bewley, on Aug 23, 2025.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, for_fun)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, r=1; corners=4; fac=0.05;

phi=360/corners;
for i=1:corners, A(1,i)=r*sind(i*phi); A(2,i)=r*cosd(i*phi); end

figure(1), clf, hold on, [d,n]=size(A); draw_box(A,n)
for refinements=1:50
  for i=1:n-1, B(:,i)=fac*A(:,i)+(1-fac)*A(:,i+1); end
  B(:,n)=fac*A(:,n)+(1-fac)*A(:,1); draw_box(B,n), A=B;
end
axis square, axis equal, axis tight, axis off

function draw_box(A,n)
plot([A(1,n) A(1,1)],[A(2,n) A(2,1)],'k-')
for i=1:n-1, plot([A(1,i) A(1,i+1)],[A(2,i) A(2,i+1)],'k-'), end
end