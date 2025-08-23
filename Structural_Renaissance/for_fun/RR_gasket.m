% script RR_gasket
% Code written by Thomas Bewley, with inspiration from Zacharay Bewley, on Aug 23, 2025.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, for_fun)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, global depth; depth=3; close all; figure(1), hold on
Ax=[0 0 1 1];
Ay=[0 1 1 0]; A=[Ax; Ay] draw_square(A)
axis equal, axis tight, axis off

divide_square(A)

function divide square(A)

for i=0:3; for j=0:3, A(9)
A_refined=[]

B=[A(1,1)      ;
     

C
D
E
F
G
H
I
J

end


function draw_square(A)
for i=1:3, plot([A(1,i) A(1,i+1)],[A(2,i) A(2,i+1)],'k-'), end
plot([A(1,4) A(1,1)],[A(2,4) A(2,1)],'k-')
end