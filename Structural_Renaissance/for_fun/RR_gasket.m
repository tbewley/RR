% script RR_gasket
% UNFINISHED
% Code written by Thomas Bewley, with inspiration from Zacharay Bewley, on Aug 23, 2025.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, for_fun)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, d=0; close all; figure(1), hold on, axis equal, axis tight, axis off
A=[0 1; 0 1]; draw_square(A), pause, divide_square(A,d)

function divide_square(A,d)
Bx=[A(1,1):(A(1,2)-A(1,1))/3:A(1,2)]; By=[A(2,1):(A(2,2)-A(2,1))/3:A(2,2)];
draw_square([Bx(2) Bx(3); By(2) By(3)])
if d<5
  divide_square([Bx(1) Bx(2); By(1) By(2)],d+1)
  divide_square([Bx(2) Bx(3); By(1) By(2)],d+1)
  divide_square([Bx(3) Bx(4); By(1) By(2)],d+1)
  divide_square([Bx(1) Bx(2); By(2) By(3)],d+1)
  divide_square([Bx(3) Bx(4); By(2) By(3)],d+1)
  divide_square([Bx(1) Bx(2); By(3) By(4)],d+1)
  divide_square([Bx(2) Bx(3); By(3) By(4)],d+1)
  divide_square([Bx(3) Bx(4); By(3) By(4)],d+1)
end
end

function draw_square(A)
  plot([A(1,1) A(1,2)],[A(2,1) A(2,1)],'k-')
  plot([A(1,1) A(1,2)],[A(2,2) A(2,2)],'k-')
  plot([A(1,1) A(1,1)],[A(2,1) A(2,2)],'k-')
  plot([A(1,2) A(1,2)],[A(2,1) A(2,2)],'k-')
end