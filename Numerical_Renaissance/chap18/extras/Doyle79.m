% script <a href="matlab:Doyle79">Doyle79</a>
% Calculates the eigenvectors of the (defective, stable) LQG composite system matrix, the
% large transient energy growth, the diminishing gain margin, and the characteristic
% polynomial of the Doyle79 model.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 21.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap21">Chapter 21</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Consider the poorly-behaved LQG composite system matrix identified in Doyle79.')

disp('Case 1: note defective system matrix (equal columns of V) even for small q, sigma.')
q=1; sigma=1; f=2+sqrt(4+q); d=2+sqrt(4+sigma); figure(1); clf;
m=1; A=[1 1 0 0;0 1 -m*f -m*f; d 0 1-d 1; d 0 -d-f 1-f]; [V,D]=eig(A); V, eigs=diag(D)',
t=[0:.01:10]; for i=1:length(t); f(i)=max(eig(expm(A'*t(i))*expm(A*t(i)))); end, plot(t,f)
disp('Large transient energy growth (aka "peaking") illustrated in Figure 1.')
title('Maximum transient energy growth for various tau, for q=sigma=m=1')

disp(' '); disp('Case 2: large q and sigma, unstable for both m=1.02 and m=.98 - bad gain margin!')
q=10000; sigma=10000; f=2+sqrt(4+q); d=2+sqrt(4+sigma);
m=1.02, A=[1 1 0 0;0 1 -m*f -m*f; d 0 1-d 1; d 0 -d-f 1-f]; [V,D]=eig(A); eigs=diag(D)'
m=1.00, A=[1 1 0 0;0 1 -m*f -m*f; d 0 1-d 1; d 0 -d-f 1-f]; [V,D]=eig(A); eigs=diag(D)'
m= .98, A=[1 1 0 0;0 1 -m*f -m*f; d 0 1-d 1; d 0 -d-f 1-f]; [V,D]=eig(A); eigs=diag(D)'

disp(' '); disp('Case 3: compute characteristic polynomial symbolically')
syms s m f d, A=[1 1 0 0;0 1 -m*f -m*f; d 0 1-d 1; d 0 -d-f 1-f];
characteristic_polynomial=collect(det(s*eye(4)-A),s),
disp('See comments in Doyle79 for why this is problematic.')

% end script Doyle79