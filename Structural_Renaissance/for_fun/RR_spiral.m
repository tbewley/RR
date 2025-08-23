% script RR_spiral
% Draws a polygon that successively shifts along its own edges, and spirals in.
% Code written by Thomas Bewley, with inspiration from Zacharay and Nadia Bewley, on Aug 23, 2025.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, for_fun)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, corners=8; fac=0.15; % change the parameters at left to alter design

% A=[0 0 -1 -1 0 0 1 1 2 2 1 1;
%    0 2  2  3 3 4 4 3 3 2 2 0];

r=1; phi=360/corners;       % compute the corners of a regular polygon
for i=1:corners, A(1,i)=r*sind(i*phi); A(2,i)=r*cosd(i*phi); end

figure(1), clf, hold on, [d,n]=size(A); draw_polygon(A,n)
for refinements=1:500
  for i=1:n-1, B(:,i)=fac*A(:,i)+(1-fac)*A(:,i+1); end
  B(:,n)=fac*A(:,n)+(1-fac)*A(:,1); draw_polygon(B,n), A=B;
end
axis equal, axis tight, axis off

function draw_polygon(A,n)
for i=1:n-1, plot([A(1,i) A(1,i+1)],[A(2,i) A(2,i+1)],'k-'), end
plot([A(1,n) A(1,1)],[A(2,n) A(2,1)],'k-')
end